#SingleInstance, Force
#NoTrayIcon

global msg

clipboardLength := StrLen(clipboard)
msg := "剪切板内容 " . clipboardLength . " 字节`n"
msg .= "-------------------- `n"

if (clipboardLength <= 100)
{
    msg .= clipboard
}
else
{
    msg .= SubStr(clipboard, 1, 50)
    msg .= "`n....................`n"
    msg .= SubStr(clipboard, -50)
}

msg .= "`n--------------------`n`n"


@("s", "PasteToNotepad", "显示剪切板内容")
@("r", "RunClipboardWithMintty", "运行剪切板的命令")
@("d", "Dictionary", "词典")
@("c", "Calendar", "万年历")
@("2", "t2s", "繁体转简体")
@("z", "Test", "测试")

GUI, Main:Font, s12
GUI, Main:Add, Text, , %msg%
GUI, Main:Show

Esc::
    ExitApp


; AddAction(key, label, info)
@(key, label, info)
{
    global msg
    msg .= key "  =>  " info "`n"
    HotKey, %key%, %label%
}

RunWithBash(command)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("bash -c '" command " | iconv -f utf-8 -t gbk -c")
    return exec.StdOut.ReadAll()
}

RunWithCmd(command)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /C " command)
    return exec.StdOut.ReadAll()
}

RunWithMintty(command)
{
    ;MsgBox % RunWithBash(clipboard)
    ;Run, mintty -e sh -c '%clipboard%; read'
    Run % "mintty -e sh -c '" command "; read'"
    ExitApp
}

; ===========

PasteToNotepad:
    Run, notepad
    Send, ^v
    ExitApp
return

ShowClipboard:
    MsgBox, %clipboard%
    ExitApp
return

ShowIp:
    MsgBox, %A_IPAddress1%`n%A_IPAddress2%`n%A_IPAddress3%`n%A_IPAddress4%
    ExitApp
return

RunClipboardWithMintty:
    RunWithMintty(clipboard)
    ExitApp
return

Dictionary:
    RunWithMintty("echo " . clipboard . " | ydcv")
    ExitApp
return

Calendar:
    Run % "http://www.baidu.com/baidu?wd=%CD%F2%C4%EA%C0%FA"
    ExitApp
return

t2s:
    Run, notepad
    clipboard := Kanji_t2s(clipboard)
    Send, ^v
    ExitApp
return

Test:
    msgbox, Test
return

#include %A_ScriptDir%\..\lib\Kanji\Kanji.ahk
