#SingleInstance, Force
#NoTrayIcon

global msg

@("a", "RunNotepad", "用记事本显示剪切板内容")
@("b", "ShowClipboard", "显示剪切板内容")
@("c", "ShowIp", "显示IP")
@("d", "RunClipboardWithMintty", "运行剪切板的命令")
@("z", "Test", "测试")

MsgBox, %msg%

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

; ===========

RunNotepad:
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
    MsgBox % clipboard
    ;MsgBox % RunWithBash(clipboard)
    ;Run, mintty -e sh -c '%clipboard%; read'
    Run % "mintty -e sh -c '" clipboard "; read'"
    ExitApp
return

Test:
    MsgBox, test
    ExitApp
return
