#SingleInstance, Force
#NoTrayIcon

global msg

GoSub, UserCmd

msg .= "`n按 Esc 或 Alt + F4 退出"

Gui, Main:Font, s12
Gui, Main:Add, Button, w0 h0
Gui, Main:Add, Text, , % "剪切板内容 " . StrLen(clipboard) . " 字节："
Gui, Main:Add, Edit, w300 h200 ReadOnly, %clipboard%
Gui, Main:Add, Text, , %msg%
Gui, Main:Show, , GKey

return

Esc::
Alt & F4::
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

#include %A_ScriptDir%\Kanji\Kanji.ahk
#include %A_ScriptDir%\GKey.conf
