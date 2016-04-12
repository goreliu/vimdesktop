#NoEnv
#SingleInstance, Force
#NoTrayIcon

FileEncoding, utf-8

; 从配置文件读取
global g_SearchFileDir
global g_SearchFileType

; 自动生成的命令文件
global g_CommandsFile := A_ScriptDir . "\Commands.txt"
; 手动填写的命令文件
global g_UserCommandsFile := A_ScriptDir . "\UserCommands.txt"
; 配置文件
global g_ConfFile := A_ScriptDir . "\Launch.ini"

; 所有命令
global g_Commands
; 编辑框当前内容
global g_CurrentInput
; 当前匹配到的第一条命令
global g_CurrentCommand
; 当前匹配到的所有命令
global g_CurrentCommandList
global g_EnableTCMatch

IniRead, g_SearchFileDir, %g_ConfFile%, config, SearchFileDir
IniRead, g_SearchFileType, %g_ConfFile%, config, SearchFileType

IniRead, TCMatchPath, %g_ConfFile%, config, TCMatchPath

if (FileExist(TCMatchPath) && TCMatchOn(TCMatchPath))
{
    g_EnableTCMatch := true
}
else
{
    g_EnableTCMatch := false
}

if (FileExist(g_CommandsFile))
{
    LoadCommands()
}
else
{
    GoSub, ReloadCommand
}

commands := SearchCommand("", true)

Gui, Main:Font, s12
Gui, Main:Add, Edit, gProcessInputCommand vSearchArea w600 h25
;Gui, Main:Add, Button, w0 h0
Gui, Main:Add, Edit, w600 h250 ReadOnly gSelectCommand vDisplayArea, %commands%
Gui, Main:Show, , Launch
;WinSet, Style, -0xC00000, A

Hotkey, IfWinActive, Launch
HotKey, enter, RunCurrentCommand

bindKeys := "abcdefghijklmno"
Loop, Parse, bindKeys
{
    HotKey, ~%A_LoopField%, RunSelectedCommand
}

return

Esc::
    ExitApp

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
    ; 用逗号来判断参数
    if (InStr(command, ",") && g_CurrentCommand != "")
    {
        return
    }

    result := ""
    order := 97

    g_CurrentCommandList := Object()

    for index, element in g_Commands
    {
        currentCommand := StrSplit(element, " | ")[2]

        ; 第一次运行只加载 function 类型
        if (firstRun && !InStr(element, "function | ", 1))
        {
            result .= "`n`n"
            result .= "以上显示的仅为内置命令，请键入内容搜索，按 Esc 退出。`n"
            result .= "可直接输入网址，如 www.baidu.com。`n"
            result .= "可直接输入命令，如 `;ping www.baidu.com。`n"

            break
        }
            
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
            elementToRun := StrSplit(element, "（")[1]

            g_CurrentCommandList.Insert(elementToRun)

            if (order == 97)
            {
                g_CurrentCommand := elementToRun
            }
            else
            {
                result .= "`n"
            }

            result .= Chr(order++) . " | " . elementToShow

            if (order - 97 >= 15)
            {
                break
            }
        }
    }
    
    if (result == "")
    {
        if (SubStr(command, 1, 1) == ":" || SubStr(command, 1, 1) == ";")
        {
            result := "cmd | " . SubStr(command, 2)
        }
        else
        {
            result := "run | " . command
        }

        g_CurrentCommand := result
    }

    DisplayText(result)
    return result
}

SelectCommand:
    MsgBox good
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
    if (RegexMatch(command, "^(file|url|run)"))
    {
        cmd := StrSplit(command, " | ")[2]
        Run, %cmd%
    }
    else if (InStr(command, "cmd | ", true, 1))
    {
        cmd := StrSplit(command, " | ")[2]
        RunWithCmd(cmd)
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

RunSelectedCommand:
    ControlGetFocus, ctrl,
    if (ctrl == "Edit1")
    {
        return
    }

    index := Asc(SubStr(A_ThisHotkey, 2, 1)) - Asc("a") + 1

    RunCommand(g_CurrentCommandList[index])
return

LoadCommands()
{
    g_Commands := Object()

    g_Commands.Insert("function | ReloadCommand（重载）")
    g_Commands.Insert("function | Clip（显示剪切板内容）")
    g_Commands.Insert("function | Help（帮助信息）")
    g_Commands.Insert("function | ArgTest（参数测试：ArgTest,arg1,arg2,...）")

    GoSub, UserCmd

    Loop, Read, %g_UserCommandsFile%
    {
        g_Commands.Insert(A_LoopReadLine)
    }

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
    result := ""

    for index, argument in StrSplit(g_CurrentInput, ",")
    {
        if (index == 1)
        {
            result .= "输入命令名：" . argument . "`n`n"
        }
        else (index > 1)
        {
            result .= "第 " . index - 1 " 个参数：" . argument . "`n"
        }
    }

    MsgBox % result
return

ReloadCommand:
    GenerateCommandList()

    LoadCommands()
return

Help:
    DisplayText("帮助")
return

Clip:
    DisplayText("剪切板内容长度 " . StrLen(clipboard) . " ：`n`n" . clipboard)
return

; AddAction(label, info)
@(label, info)
{
    g_Commands.Insert("function | " . label . "（" . info . "）")
}

RunAndGetOutput(command)
{
    tempFileName := "Launch.stdout.log"
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

#include %A_ScriptDir%\Kanji\Kanji.ahk
#include %A_ScriptDir%\TCMatch.ahk
#include %A_ScriptDir%\Commands.ahk
