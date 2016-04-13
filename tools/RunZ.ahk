#NoEnv
#SingleInstance, Force
#NoTrayIcon

FileEncoding, utf-8
SendMode Input

; 自动生成的命令文件
global g_CommandsFile := A_ScriptDir . "\Commands.txt"
global g_ConfFile := A_ScriptDir . "\RunZ.ini"
; 配置文件
global g_Conf := class_EasyINI(g_ConfFile)

; 从配置文件读取
global g_SearchFileDir = g_Conf.config.SearchFileDir
global g_SearchFileType = g_Conf.config.SearchFileType

; 所有命令
global g_Commands
; 当搜索无结果时使用的命令
global g_FallbackCommands
; 编辑框当前内容
global g_CurrentInput
; 当前匹配到的第一条命令
global g_CurrentCommand
; 当前匹配到的所有命令
global g_CurrentCommandList
; 是否启用 TCMatch
global g_EnableTCMatch = TCMatchOn(g_Conf.config.TCMatchPath)
; 列表排序的第一个字符
global g_FirstChar := Asc("a")
; 当前输入命令的参数，数组，为了方便没有添加 g_ 前缀
global Arg

if (FileExist(g_CommandsFile))
{
    LoadCommands()
}
else
{
    GoSub, ReloadCommand
}

Gui, Main:Font, s12
Gui, Main:Add, Edit, gProcessInputCommand vSearchArea w600 h25,
Gui, Main:Add, Edit, w600 h250 ReadOnly vDisplayArea, % SearchCommand("", true)
if (g_Conf.config.ShowCurrentCommand)
{
    Gui, Main:Add, Edit, w600 h25 ReadOnly,
}
Gui, Main:Show, , RunZ
;WinSet, Style, -0xC00000, A

Hotkey, IfWinActive, RunZ
HotKey, enter, RunCurrentCommand
HotKey, ^j, ClearInput
HotKey, f1, Help
HotKey, f2, EditConfig

bindKeys := "abcdefghijklmno"
Loop, Parse, bindKeys
{
    ; lalt
    HotKey, <!%A_LoopField%, RunSelectedCommand1
    HotKey, ~%A_LoopField%, RunSelectedCommand2
    HotKey, ~+%A_LoopField%, AddCustomCommand
}

if (g_Conf.config.SaveInputText && g_Conf.auto.InputText != "")
{
    Send, % g_Conf.auto.InputText
}

return

Esc::
    if (g_Conf.config.SaveInputText)
    {
        g_Conf.DeleteKey("auto", "InputText")
        g_Conf.AddKey("auto", "InputText", g_CurrentInput)
        g_Conf.Save()
    }
    ExitApp
return

GenerateCommandList()
{
    FileDelete, %g_CommandsFile%

    for dirIndex, dir in StrSplit(g_SearchFileDir, " | ")
    {
        if (InStr(dir, "A_") == 1)
        {
            searchPath := %dir%
        }
        else
        {
            searchPath := dir
        }

        for extIndex, ext in StrSplit(g_SearchFileType, " | ")
        {
            Loop, Files, %searchPath%\%ext%, R
            {
                if (g_Conf.config.SearchFileExclude != ""
                        && RegexMatch(A_LoopFileLongPath, g_Conf.config.SearchFileExclude))
                {
                    continue
                }
                FileAppend, file | %A_LoopFileLongPath%`n, %g_CommandsFile%,
            }
        }
    }
}

ProcessInputCommand:
    GuiControlGet, g_CurrentInput, , SearchArea
    SearchCommand(g_CurrentInput)
return

SearchCommand(command = "", firstRun = false)
{
    result := ""
    commandPrefix := SubStr(command, 1, 1)

    if (commandPrefix ==  ";" || commandPrefix == ":")
    {
        if (commandPrefix == ";")
        {
            g_CurrentCommand := g_FallbackCommands[1]
        }
        else if (commandPrefix == ":")
        {
            g_CurrentCommand := g_FallbackCommands[2]
        }

        g_CurrentCommandList.Insert(g_CurrentCommand)
        result .= "a | " . g_CurrentCommand
        Arg := SubStr(g_CurrentInput, 2)
        DisplayResult(result)
        return result
    }
    ; 用空格来判断参数
    else if (InStr(command, " ") && g_CurrentCommand != "")
    {
        Arg := SubStr(command, InStr(command, " ") + 1)
        return
    }

    g_CurrentCommandList := Object()

    order := g_FirstChar

    for index, element in g_Commands
    {
        currentCommand := StrSplit(element, " | ")[2]

        if (InStr(element, "file | ", true, 1))
        {
            ; 只搜不带扩展名的文件名
            SplitPath, currentCommand, , , , currentCommand
            elementToShow := SubStr("file | " . currentCommand, 1, 68)
        }
        else
        {
            elementToShow := SubStr(element, 1, 68)
        }

        if (MatchCommand(currentCommand, command))
        {
            g_CurrentCommandList.Insert(element)

            if (order == g_FirstChar)
            {
                g_CurrentCommand := element
            }
            else
            {
                result .= "`n"
            }

            result .= Chr(order++) . " | " . elementToShow

            if (order - g_FirstChar >= 15)
            {
                break
            }

            ; 第一次运行只加载 function 类型
            if (firstRun && (order - g_FirstChar >= 11))
            {
                result .= "`n`n现有 " g_Commands.Length() " 条命令。"
                result .= "`n`n键入内容 搜索，回车 执行第一条，Alt + 字母 执行，F1 帮助，Esc 退出。"

                break
            }
        }
    }

    if (result == "")
    {
        g_CurrentCommand := g_FallbackCommands[1]
        g_CurrentCommandList := g_FallbackCommands
        Arg := g_CurrentInput

        for index, element in g_FallbackCommands
        {
            if (index != 1)
            {
                result .= "`n"
            }

            result .= Chr(g_FirstChar - 1 + index++) . " | " . element 
        }
    }

    DisplayResult(result)
    return result
}

DisplayResult(result)
{
    DisplayText(result)

    if (g_CurrentCommandList.Length() == 1 && g_Conf.config.RunIfOnlyOne)
    {
        GoSub, RunCurrentCommand
    }

    if (g_Conf.config.ShowCurrentCommand)
    {
        ControlSetText, Edit3, %g_CurrentCommand%
    }
}

ClearInput:
    ControlSetText, Edit1,
return

RunCurrentCommand:
    RunCommand(g_CurrentCommand)
return

MatchCommand(Haystack, Needle)
{
    if (g_EnableTCMatch)
    {
        return TCMatch(Haystack, Needle)
    }

    return InStr(Haystack, Needle)
}

RunCommand(command)
{
    command := StrSplit(command, "（")[1]

    if (RegexMatch(command, "^(file|url)"))
    {
        cmd := StrSplit(command, " | ")[2]
        Run, %cmd%
    }
    else if (InStr(command, "function | ", true, 1))
    {
        cmd := StrSplit(command, " | ")[2]
        if (IsLabel(cmd))
        {
            GoSub, %cmd%
        }
    }
}

RunSelectedCommand1:
    index := Asc(SubStr(A_ThisHotkey, 3, 1)) - Asc("a") + 1

    RunCommand(g_CurrentCommandList[index])
return

RunSelectedCommand2:
    ControlGetFocus, ctrl,
    if (ctrl == "Edit1")
    {
        return
    }

    index := Asc(SubStr(A_ThisHotkey, 2, 1)) - Asc("a") + 1

    RunCommand(g_CurrentCommandList[index])
return

AddCustomCommand:
    ControlGetFocus, ctrl,
    if (ctrl == "Edit1")
    {
        return
    }

    index := Asc(SubStr(A_ThisHotkey, 3, 1)) - Asc("a") + 1

    if (g_CurrentCommandList[index] != "")
    {
        g_Conf.AddKey("command", g_CurrentCommandList[index], g_CurrentInput)

        g_Conf.Save()

        LoadCommands()
    }
return

LoadCommands()
{
    g_Commands := Object()
    g_FallbackCommands := Object()

    for key, value in g_Conf.command
    {
        if (value != "")
        {
            g_Commands.Insert(key . "（" . value "）")
        }
        else
        {
            g_Commands.Insert(key)
        }
    }

    @("AhkRun", "使用 Ahk 的 Run 运行 `; cmd", true)
    @("CmdRun", "使用 cmd 运行 : cmd", true)
    @("ReloadCommand", "重新搜索文件")
    @("Clip", "显示剪切板内容")
    @("EditConfig", "编辑配置文件")
    @("Help", "帮助信息")
    @("ArgTest", "参数测试：ArgTest arg1,arg2,...")

    GoSub, UserCmd

    Loop, Read, %g_CommandsFile%
    {
        g_Commands.Insert(A_LoopReadLine)
    }
}

DisplayText(text)
{
    textToDisplay := StrReplace(text, "`n", "`r`n")
    ControlSetText, Edit2, %textToDisplay%
}

ArgTest:
    Args := StrSplit(Arg, ",")
    result := "共有 " . Args.Length() . " 个参数。`n`n"

    for index, argument in Args
    {
        result .= "第 " . index - 1 " 个参数：" . argument . "`n"
    }

    DisplayText(result)
return

ReloadCommand:
    GenerateCommandList()

    LoadCommands()
return

Help:
    helpText := "帮助：`n`n"
        . "键入内容 搜索，回车 执行（a），Alt + 字母 执行，F1 帮助，Esc 退出`n"
        . "Tab + 字母 也可执行字母对应功能`n"
        . "Tab + 大写字母 可将字母对应功能加入到配置文件，以便优先显示`n"
        . "Ctrl + j 清除编辑框内容`n"
        . "F2 编辑配置文件`n`n"
        . "可直接输入网址，如 www.baidu.com`n"
        . "分号开头则使用 ahk 的 Run 运行命令，如 `;ping www.baidu.com`n"
        . "冒号开头则在 cmd 运行命令，如 :ping www.baidu.com`n"
        . "当搜索无结果时，回车 也等同 run 输入内容`n"
        . "当输入内容包含空格时，列表锁定，逗号作为命令参数的分隔符`n"

    DisplayText(helpText)
return

EditConfig:
    Run, % g_ConfFile
return

Clip:
    DisplayText("剪切板内容长度 " . StrLen(clipboard) . " ：`n`n" . clipboard)
return

CmdRun:
    RunWithCmd(Arg)
return

AhkRun:
    Run, %Arg%
return

; AddAction(label, info, fallback)
@(label, info, fallback = false)
{
    g_Commands.Insert("function | " . label . "（" . info . "）")
    if (fallback)
    {
        g_FallbackCommands.Insert("function | " . label . "（" . info . "）")
    }
}

RunAndGetOutput(command)
{
    tempFileName := "RunZ.stdout.log"
    fullCommand = bash -c "%command% &> %tempFileName%"

    if (!FileExist("c:\msys64\usr\bin\bash.exe"))
    {
        fullCommand = %ComSpec% /C "%command% > %tempFileName%"
    }

    RunWait, %fullCommand%, %A_Temp%, Hide
    FileRead, result, %A_Temp%\%tempFileName%
    FileDelete, %A_Temp%\%tempFileName%
    return result
}

RunWithCmd(command)
{
    if (FileExist("c:\msys64\usr\bin\mintty.exe"))
    {
        Run, % "mintty -e sh -c '" command "; read'"
    }
    else
    {
        Run, % ComSpec " /C " command
    }
}

#include %A_ScriptDir%\..\lib\class_EasyIni.ahk
#include %A_ScriptDir%\lib\Kanji\Kanji.ahk
#include %A_ScriptDir%\lib\TCMatch.ahk
#include %A_ScriptDir%\lib\Eval.ahk
#include %A_ScriptDir%\Commands.ahk
