#NoTrayIcon

msg .= "a  =>  run notepad`n"
msg .= "b  =>  B`n"
msg .= "c  =>  C`n"
msg .= "d  =>  D`n"

HotKey, a, A
HotKey, b, B
HotKey, c, C
HotKey, d, D
MsgBox, %msg%

ExitApp

A:
    run, notepad
    ExitApp
return

B:
    MsgBox, B
return

C:
    MsgBox, C
return

D:
    MsgBox, D
return
