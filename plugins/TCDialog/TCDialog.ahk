TCDialog:
    vim.comment("<TC_OpenTCDialog>", "激活TC选择文件")

    ;读取配置参数，禁用时直接跳过
    IniRead, AsOpenFileDialog, %ConfigPath%, TotalCommander_Config, AsOpenFileDialog, 1
    if AsOpenFileDialog <> 1
        return

    ;读取排除窗体文字
    Loop, read, %ConfigPath%
    {
        ifInString, A_LoopReadLine, OpenFileDialogExclude
        {
            OpenFileDialogExclude := SubStr(A_LoopReadLine, InStr(A_LoopReadLine, "=")+1)
            IfNotInString, OpenFileDialogExclude, 密码
                OpenFileDialogExclude .= ", 密码"
            break
        }
    }

    ;未发现TC路径时自动禁用该功能
    if StrLen(TCPath) = 0
        return

    ;用于记录文件打开对话框所属窗体
    global CallerId := 0

    ;等待OpenFileDialog出现
    SetTimer, <CheckFileDialog>, 1000

return


<TCDialog_MapKeys>:
    vim.mode("normal", "TTOTAL_CMD")
    vim.map("<enter>", "<TC_PreSelected>", "TTOTAL_CMD")
    vim.map("<c-enter>", "<TC_Selected>", "TTOTAL_CMD")
    vim.map("<s-enter>", "<TC_SelectedCurrentDir>", "TTOTAL_CMD")
    vim.map("<esc>", "<Return_To_Caller>", "TTOTAL_CMD")
return

<TCDialog_UnMapKeys>:
    vim.mode("normal", "TTOTAL_CMD")
    vim.map("<enter>", "<Default>", "TTOTAL_CMD")
    vim.map("<c-enter>", "<Default>", "TTOTAL_CMD")
    vim.map("<s-enter>", "<Default>", "TTOTAL_CMD")
    vim.map("<esc>", "<Default>", "TTOTAL_CMD")
return

;返回调用者
<Return_To_Caller>:
    gosub, <TCDialog_UnMapKeys>

    ;未发现可激活的调用窗体时，最小化TC
    if CallerId = 0
    {
        Winminimize, AHK_CLASS TTOTAL_CMD
        sleep, 500
        CallerId := WinExist("A")
        if CallerId = 0
            return
    }

    WinActivate, ahk_id %CallerId%
return

;发现标准打开文件对话框，未记录，焦点控件为Edit1=>记录，并激活TC
<CheckFileDialog>:
    WinGetClass, class, A
    if class <> #32770
        return

    ControlGetFocus, ct, ahk_class #32770
    if ct <> Edit1
        return

    ;以此排除“另存为”，或其它已经包含文字的对话框
    ControlGetText, str, Edit1, ahk_class #32770
    if StrLen(str) > 0
        return

    ;排除用户自定义窗体
    WinGetText, str, ahk_class #32770
    WinGetTitle, title, ahk_class #32770
    if StrLen(title)=0
        return
    str .= title
    Loop, parse, OpenFileDialogExclude, `, , %A_Space%%A_Tab%
    {
        If StrLen(A_LoopField) = 0
            continue
        IfInString, str, %A_LoopField%
            return
    }

    id := WinExist("A")
    if id = 0
        return
    if id = %CallerId%
        return

    CallerId := id
    gosub, <FocusTC>
    gosub, <TCDialog_MapKeys>
return

; * 非TC窗口按下后激活TC窗口
; * TC窗口按下后复制当前选中文件返回原窗口后粘贴
<TC_OpenTCDialog>:
    ; 复制保存文件对话框中的文件名到剪切板
    send, ^c
    WinGetClass, class, A

    ;在Total Commander按下快捷键时，激活调用窗体并执行粘贴操作
    if class = TTOTAL_CMD
    {
        gosub, <TC_Selected>
        return
    }

    if class <> TTOTAL_CMD
    {
        CallerId := WinExist("A")
        if CallerId = 0
            return

        gosub, <FocusTC>
        gosub, <TCDialog_MapKeys>
        return
    }

return

<TC_PreSelected>:
    ; cm_CopyNetNamesToClip
    SendPos(2021)
    sleep, 100 ; 此处用clipwait貌似会出错？

    ;未多选
    IfNotInString, clipboard, `n
    {
        ;当前复制项为文件夹时
        StringRight, str, clipboard, 1
        IfInString, str, \
            {
                ; cm_GoToDir
                SendPos(2003)
                return
            }
    }

    ;return 注意，此处无需return

<TC_Selected>:
    gosub, <TCDialog_UnMapKeys>

    SendPos(2021)
    sleep, 100

    ;仅在多选时两侧增加双引号
    IfInString, clipboard, `n
    {
        files := ""
        Loop, parse, clipboard, `n, `r
            files .= """" A_LoopField  """ "
        clipboard := files
    }

    ;未发现可激活的调用窗体时，最小化TC
    if CallerId = 0
    {
        Winminimize, AHK_CLASS TTOTAL_CMD
        sleep, 500
        CallerId := WinExist("A")
        if CallerId = 0
            return
    }

    WinActivate, ahk_id %CallerId%
    WinWait, ahk_id %CallerId%
    send, ^v
    send, {Enter}
return

<TC_SelectedCurrentDir>:
    gosub, <TCDialog_UnMapKeys>

    filename := "\" . clipboard
    ; cm_CopySrcPathToClip
    SendPos(2029)
    sleep, 100

    clipboard := clipboard . filename

    ;未发现可激活的调用窗体时，最小化TC
    if CallerId = 0
    {
        Winminimize, AHK_CLASS TTOTAL_CMD
        sleep, 500
        CallerId := WinExist("A")
        if CallerId = 0
            return
    }

    WinActivate, ahk_id %CallerId%
    WinWait, ahk_id %CallerId%
    send, ^v
    send, {Enter}{Enter}
return
