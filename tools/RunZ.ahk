#NoEnv
#SingleInstance, Force
#NoTrayIcon

FileEncoding, utf-8
SendMode Input

; 自动生成的命令文件
global g_SearchFileList := A_ScriptDir . "\SearchFileList.txt"
; 配置文件
global g_ConfFile := A_ScriptDir . "\RunZ.ini"

if !FileExist(g_ConfFile)
{
    FileCopy, %g_ConfFile%.help.txt, %g_ConfFile%
}

global g_Conf := class_EasyINI(g_ConfFile)

; 所有命令
global g_Commands
; 当搜索无结果时使用的命令
global g_FallbackCommands
; 当前是否使用着 g_FallbackCommands
global g_UseFallbackCommands
; 编辑框当前内容
global g_CurrentInput
; 当前匹配到的第一条命令
global g_CurrentCommand
; 当前匹配到的所有命令
global g_CurrentCommandList
; 是否启用 TCMatch
global g_EnableTCMatch = TCMatchOn(g_Conf.Config.TCMatchPath)
; 列表第一列的首字母或数字
global g_FirstChar := Asc(g_Conf.Gui.FirstChar)
; 在列表中显示的行数
global g_DisplayRows := g_Conf.Gui.DisplayRows
; 在列表中显示的文字列数（多出的会被截断）
global g_DisplayCols := g_Conf.Gui.DisplayCols
; 命令使用了显示框
global g_UseDisplay
; 当前输入命令的参数，数组，为了方便没有添加 g_ 前缀
global Arg

if (FileExist(g_SearchFileList))
{
    LoadFiles()
}
else
{
    GoSub, ReloadFiles
}

Gui, Main:Font, % "s" g_Conf.Gui.FontSize, % g_Conf.Gui.FontName
Gui, Main:Add, Edit, % "gProcessInputCommand vSearchArea"
        . " w" g_Conf.Gui.WidgetWidth " h" g_Conf.Gui.EditHeight,
Gui, Main:Add, Edit, % "ReadOnly vDisplayArea"
        . " w" g_Conf.Gui.WidgetWidth " h" g_Conf.Gui.DisplayAreaHeight
        , % SearchCommand("", true)
if (g_Conf.Gui.ShowCurrentCommand)
{
    Gui, Main:Add, Edit, % "ReadOnly"
        . " w" g_Conf.Gui.WidgetWidth " h" g_Conf.Gui.EditHeight,
}
Gui, Main:Show, , RunZ
if (g_Conf.Gui.HideTitle)
{
    WinSet, Style, -0xC00000, A
}

if (g_Conf.Config.ExitIfInactivate)
{
    OnMessage(0x06, "WM_ACTIVATE")
}

Hotkey, IfWinActive, RunZ
Hotkey, ~enter, RunCurrentCommand
Hotkey, ^j, ClearInput
Hotkey, f1, Help
Hotkey, f2, EditConfig
Hotkey, esc, ExitRunZ
Hotkey, ^d, OpenCurrentFileDir
Hotkey, ^x, DeleteCurrentFile
Hotkey, ^s, ShowCurrentFile
Hotkey, ^r, ReloadFiles

if (g_Conf.Config.RunInBackground)
{
    Hotkey, esc, WindowMin
}

Loop, % g_DisplayRows
{
    key := Chr(g_FirstChar + A_Index - 1)
    ; lalt +
    Hotkey, <!%key%, RunSelectedCommand1
    ; tab +
    Hotkey, ~%key%, RunSelectedCommand2
    ; shift +
    Hotkey, ~+%key%, AddCustomCommand
}

if (g_Conf.Config.SaveInputText && g_Conf.Auto.InputText != "")
{
    Send, % g_Conf.Auto.InputText
}

return

ExitRunZ:
    if (g_Conf.Config.SaveInputText)
    {
        g_Conf.DeleteKey("auto", "InputText")
        g_Conf.AddKey("auto", "InputText", g_CurrentInput)
        g_Conf.Save()
    }

    ExitApp
return

WindowMin:
    WinMinimize, A
return

GenerateSearchFileList()
{
    FileDelete, %g_SearchFileList%

    searchFileType := g_Conf.Config.SearchFileType

    for dirIndex, dir in StrSplit(g_Conf.Config.SearchFileDir, " | ")
    {
        if (InStr(dir, "A_") == 1)
        {
            searchPath := %dir%
        }
        else
        {
            searchPath := dir
        }

        for extIndex, ext in StrSplit(searchFileType, " | ")
        {
            Loop, Files, %searchPath%\%ext%, R
            {
                if (g_Conf.Config.SearchFileExclude != ""
                        && RegexMatch(A_LoopFileLongPath, g_Conf.Config.SearchFileExclude))
                {
                    continue
                }
                FileAppend, file | %A_LoopFileLongPath%`n, %g_SearchFileList%,
            }
        }
    }
}

ReloadFiles:
    GenerateSearchFileList()

    LoadFiles()
return

ProcessInputCommand:
    GuiControlGet, g_CurrentInput, , SearchArea
    SearchCommand(g_CurrentInput)
return

SearchCommand(command = "", firstRun = false)
{
    result := ""
    commandPrefix := SubStr(command, 1, 1)

    if (commandPrefix == ";" || commandPrefix == ":")
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
        DisplaySearchResult(result)
        return result
    }
    ; 用空格来判断参数
    else if (InStr(command, " ") && g_CurrentCommand != "")
    {
        if (g_UseFallbackCommands)
        {
            Arg := command
        }
        else
        {
            Arg := SubStr(command, InStr(command, " ") + 1)
        }
        return
    }

    g_CurrentCommandList := Object()

    order := g_FirstChar

    for index, element in g_Commands
    {
        splitedElement := StrSplit(element, " | ")

        if (splitedElement[1] == "file")
        {
            SplitPath, % splitedElement[2], , fileDir, , fileNameNoExt

            ; 只搜索和展示不带扩展名的文件名
            elementToSearch := fileNameNoExt
            elementToShow := "file | " . fileNameNoExt

            if (splitedElement.Length() >= 3)
            {
                elementToSearch .= " " . splitedElement[3]
                elementToShow .= "（" . splitedElement[3] . "）"
            }

            elementToShow := SubStr(elementToShow, 1, g_DisplayCols)

            if (g_Conf.Config.SearchFullPath)
            {
                ; TCMatch 在搜索路径时只搜索文件名，强行将 \ 转成空格
                elementToSearch := StrReplace(fileDir, "\", " ") . " " . elementToSearch
            }
        }
        else
        {
            elementToShow := SubStr(element, 1, g_DisplayCols)
            elementToSearch := splitedElement[2]
        }

        if (MatchCommand(elementToSearch, command))
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

            if (order - g_FirstChar >= g_DisplayRows)
            {
                break
            }
            ; 第一次运行只加载 function 类型
            if (firstRun && (order - g_FirstChar >= g_DisplayRows - 4))
            {
                result .= "`n`n现有 " g_Commands.Length() " 条命令。"
                result .= "`n`n键入内容 搜索，回车 执行第一条，Alt + 字母 执行，F1 帮助，Esc 退出。"

                break
            }
        }
    }

    if (result == "")
    {
        g_UseFallbackCommands := true
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
    else
    {
        g_UseFallbackCommands := false
    }

    DisplaySearchResult(result)
    return result
}

DisplaySearchResult(result)
{
    DisplayText(result)

    if (g_CurrentCommandList.Length() == 1 && g_Conf.Config.RunIfOnlyOne)
    {
        GoSub, RunCurrentCommand
    }

    if (g_Conf.Gui.ShowCurrentCommand)
    {
        ControlSetText, Edit3, %g_CurrentCommand%
    }
}

ClearInput:
    ControlSetText, Edit1,
return

RunCurrentCommand:
    if (g_CurrentInput != "")
    {
        g_UseDisplay := false

        RunCommand(g_CurrentCommand)
        if (g_Conf.Config.RunOnce && !g_UseDisplay)
        {
            GoSub, ExitRunZ
        }
    }
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

        if (InStr(cmd, ".lnk"))
        {
            ; 处理 32 位 ahk 运行不了某些 64 位系统 .lnk 的问题
            FileGetShortcut, %cmd%, filePath
            if (!FileExist(filePath))
            {
                filePath := StrReplace(filePath, "C:\Program Files (x86)", "C:\Program Files")
                if (FileExist(filePath))
                {
                    cmd := filePath
                }
            }
        }

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
    else if (InStr(command, "cmd | ", true, 1))
    {
        cmd := StrSplit(command, " | ")[2]
        RunWithCmd(cmd)
    }
}

RunSelectedCommand1:
    index := Asc(SubStr(A_ThisHotkey, 3, 1)) - g_FirstChar + 1

    RunCommand(g_CurrentCommandList[index])
return

RunSelectedCommand2:
    ControlGetFocus, ctrl,
    if (ctrl == "Edit1")
    {
        return
    }

    index := Asc(SubStr(A_ThisHotkey, 2, 1)) - g_FirstChar + 1

    RunCommand(g_CurrentCommandList[index])
return

AddCustomCommand:
    ControlGetFocus, ctrl,
    if (ctrl == "Edit1")
    {
        return
    }

    index := Asc(SubStr(A_ThisHotkey, 3, 1)) - g_FirstChar + 1

    if (g_CurrentCommandList[index] != "")
    {
        g_Conf.AddKey("command", g_CurrentCommandList[index], g_CurrentInput)

        g_Conf.Save()

        LoadFiles()
    }
return

LoadFiles()
{
    g_Commands := Object()
    g_FallbackCommands := Object()

    for key, value in g_Conf.Command
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

    if (FileExist(A_ScriptDir "\UserFunctions.ahk"))
    {
        userFunctionLabel := "UserFunctions"
        if (IsLabel(userFunctionLabel))
        {
            GoSub, %userFunctionLabel%
        }
        else
        {
            MsgBox, 未在 %A_ScriptDir%\UserFunctions.ahk 中发现 %userFunctionLabel% 标签，请修改！
        }
    }

    GoSub, Functions

    Loop, Read, %g_SearchFileList%
    {
        g_Commands.Insert(A_LoopReadLine)
    }

    if (g_Conf.Config.LoadControlPanelFunctions)
    {
        Loop, Read, %A_ScriptDir%\ControlPanelFunctions.txt
        {
            g_Commands.Insert(A_LoopReadLine)
        }
    }
}

DisplayText(text)
{
    textToDisplay := StrReplace(text, "`n", "`r`n")
    ControlSetText, Edit2, %textToDisplay%
}

DisplayResult(result)
{
    DisplayText(result)
    g_UseDisplay := true
}

; AddAction(label, info, fallback)
@(label, info, fallback = false)
{
    if (!IsLabel(label))
    {
        MsgBox, 未找到 %label% 标签，请检查 %A_ScriptDir%\UserFunctions.ahk 文件格式！
        return
    }

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
        Run, % ComSpec " /C " command " & pause"
    }
}

OpenPath(filePath)
{
    if (!FileExist(filePath))
    {
        return
    }

    if (FileExist(g_Conf.Config.TCPath))
    {
        TCPath := g_Conf.Config.TCPath
        Run, %TCPath% /O /A /L="%filePath%"
    }
    else
    {
        SplitPath, filePath, , fileDir, ,
        Run, explorer "%fileDir%"
    }
}

GetAllFunctions()
{
    result := ""
    functionBegin := false

    for index, element in g_Commands
    {
        if (InStr(element, "function | ") == 1)
        {
            functionBegin := true
            result .= element "`n"
        }
        else if (functionBegin)
        {
            break
        }
    }

    return result
}

OpenCurrentFileDir:
    filePath := StrSplit(g_CurrentCommand, " | ")[2]
    OpenPath(filePath)
return

DeleteCurrentFile:
    filePath := StrSplit(g_CurrentCommand, " | ")[2]

    if (!FileExist(filePath))
    {
        return
    }

    FileRecycle, % filePath
    GoSub, ReloadFiles
return

ShowCurrentFile:
    clipboard := StrSplit(g_CurrentCommand, " | ")[2]
    ToolTip, % clipboard
    SetTimer, RemoveToolTip, 800
return

RemoveToolTip:
    ToolTip
    SetTimer, RemoveToolTip, Off
return

WM_ACTIVATE(wParam, lParam)
{
    if (wParam >= 1) ; 窗口激活
    {
        return
    }
    else if (wParam <= 0) ; 窗口非激活
    {
        GoSub, ExitRunZ
    }
}


#include %A_ScriptDir%\..\lib\class_EasyIni.ahk
#include %A_ScriptDir%\lib\Kanji\Kanji.ahk
#include %A_ScriptDir%\lib\TCMatch.ahk
#include %A_ScriptDir%\lib\Eval.ahk
#include %A_ScriptDir%\Functions.ahk
; 用户自定义命令
#include *i %A_ScriptDir%\UserFunctions.ahk
