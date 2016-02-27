#SingleInstance, Force
#NoTrayIcon

msg .= "a  =>  打开记事本并粘贴`n"
msg .= "b  =>  显示剪切板内容`n"
msg .= "c  =>  显示IP`n"
msg .= "d  =>  使用mintty运行剪切板的命令`n"
msg .= "e  =>  测试`n"

HotKey, a, RunNotepad
HotKey, b, ShowClipboard
HotKey, c, ShowIp
HotKey, d, RunClipboardMintty
HotKey, e, test
MsgBox, %msg%

ExitApp

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

RunClipboardMintty:
	MsgBox % clipboard
    ;MsgBox % RunWithBash(clipboard)
    ;Run, mintty -e sh -c '%clipboard%; read'
    Run % "mintty -e sh -c '" clipboard "; read'"
	ExitApp
return

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

test:
    MsgBox, test
    ExitApp
return
