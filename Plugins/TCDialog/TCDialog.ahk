TCDialog:
    ; 用于记录文件打开对话框所属窗体
    global CallerId := 0

    global vim

    vim.Comment("<TC_OpenTCDialog>", "用 TC 选择文件或者目录")

return

<TCD_MapKeys>:
    vim.Mode("normal", "TTOTAL_CMD")
    vim.Map("<S-Enter>", "<TCD_SelectedCurrentDir>", "TTOTAL_CMD")
    vim.Map("<Esc>", "<TCD_ReturnToCaller>", "TTOTAL_CMD")
return

<TCD_UnMapKeys>:
    vim.Mode("normal", "TTOTAL_CMD")
    vim.Map("<S-Enter>", "<Default>", "TTOTAL_CMD")
    vim.Map("<Esc>", "<Default>", "TTOTAL_CMD")
return

; 返回调用者
<TCD_ReturnToCaller>:
    gosub <TCD_UnMapKeys>

    WinActivate, ahk_id %CallerId%

    CallerId := 0
return

; 非 TC 窗口按下后激活 TC 窗口
; TC 窗口按下后复制当前选中文件返回原窗口后粘贴
<TC_OpenTCDialog>:
    WinGetClass, name, A

    ; 在Total Commander 按下快捷键时，激活调用窗体并执行粘贴操作
    if (name == "TTOTAL_CMD") {
        if (CallerId != 0) {
            gosub <TCD_Selected>
            CallerId := 0
        }
    } else {
        CallerId := WinExist("A")
        if (CallerId == 0) {
            return
        }

        gosub <TC_FocusTC>
        gosub <TCD_MapKeys>
    }
return

<TCD_Selected>:
    gosub <TCD_UnMapKeys>

    Clipboard := ""
    gosub <cm_CopySrcPathToClip>
    ClipWait
    pwd := Clipboard

    Clipboard := ""
    gosub <cm_CopyNamesToClip>
    ClipWait

    WinActivate, ahk_id %CallerId%
    WinWait, ahk_id %CallerId%
    CallerId := 0

    if (!InStr(Clipboard, "`n")) {
        Clipboard := pwd . "\" . Clipboard
        Send, {Home}
        Send, ^v
        Send, {Enter}

        return
    }

    ; 多选

    files := ""
    Loop, parse, Clipboard, `n, `r
        files .= """" . A_LoopField  . """ "

    ; 第一步：跳转到当前路径
    Clipboard := pwd
    Send, ^a
    Send, ^v
    Send, {Enter}
    sleep, 100

    ; 第二步：提交文件名
    Clipboard := files
    Send, ^v
    Send, {Enter}
return

<TCD_SelectedCurrentDir>:
    gosub <TCD_UnMapKeys>

    if (callerId == 0) {
        return
    }

    Clipboard := ""
    gosub <cm_CopySrcPathToClip>
    ClipWait

    ; 添加默认路径不带反斜杠，添加之
    Clipboard .= "\"

    WinActivate, ahk_id %CallerId%
    WinWait, ahk_id %CallerId%
    CallerId := 0

    Send, {Home}
    Send, ^v
    Send, {Enter}
return
