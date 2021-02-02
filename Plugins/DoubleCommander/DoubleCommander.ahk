DoubleCommander:
    global DC_Name := "DoubleCommander"
    global DC_Class := "TTOTAL_CMD"
    global DC := "ahk_class " . DC_Class
    global DC_Dir := "c:\mine\app\doublecmd"
    global DC_Path := DC_Dir . "\doublecmd.exe --no-splash"
    ; 用于记录文件打开对话框所属窗体
    global DC_CallerId := 0

    Vim.SetWin(DC_Name, DC_Class, "doublecmd.exe")
    Vim.Mode("normal", DC_Name)
    Vim.BeforeActionDo("DC_ForceInsertMode", DC_Name)
return

DC_ForceInsertMode() {
    ControlGetFocus, Ctrl
    ; Edit 用于底部命令行
    ; Windows1 或 Windows3 用于磁盘列表
    ; Button 用于各种确认窗口，影响正常使用
    if (InStr(Ctrl, "Edit") || Ctrl == "Window1" || Ctrl == "Window3")  {
        return true
    }

    WinGet, MenuID, ID, AHK_CLASS #32768
    if (MenuID != "") {
        return true
    }

    return false
}

DC_Run(Cmd) {
    ControlSetText, Edit1, % Cmd, % DC
    ControlSend, Edit1, {Enter}, % DC
}

DC_RunGet(Cmd, SaveClipboard := True) {
    if (SaveClipboard) {
        ClipSaved := ClipboardAll
    }

    Clipboard := ""

    DC_Run(Cmd)

    ClipWait, 1

    if (SaveClipboard) {
        Result := Clipboard

        Clipboard := ClipSaved
        ClipSaved := ""

        return Result
    }

    return Clipboard
}

; 返回值 [1]: left/right [2]: 左侧面板所占比例 0-100
DC_GetPanelInfo() {
    return StrSplit(DC_RunGet("cm_CopyPanelInfoToClip"), " ")
}

DC_ExecuteToolbarItem(ID) {
    DC_Run("cm_ExecuteToolbarItem ToolItemID=" . ID)
}

DC_OpenPath(Path, InNewTab := true, LeftOrRight := "") {
    LeftOfRight := DC_GetPanelInfo()[1]
    if (LeftOfRight == "right") {
        LeftOrRight := "-R"
    } else {
        LeftOrRight := "-L"
    }

    if (InNewTab) {
        Run, %DC_Path% -C -T "%LeftOrRight%" "%Path%"
    } else {
        Run, %DC_Path% -C "%LeftOrRight%" "%Path%"
    }
}

; funcend

<DC_Test>:
    ; DC_ExecuteToolbarItem("{700FF494-B939-48A3-B248-8823EB366AEA}")
    DC_Run("cm_About")
return

<DC_Restart>:
    WinClose, % DC
    WinWaitClose, % DC, , 2

    Run, % DC_Path

    WinWaitActive, % DC

    if (!WinExist(DC)) {
        MsgBox, 重启失败 %ErrorMessage%
    }
return

<DC_Toggle_50_100>:
    PanelInfo := DC_GetPanelInfo()

    if (Abs(50 - PanelInfo[2]) < 10) {
        if (PanelInfo[1] == "left") {
            DC_Run("cm_PanelsSplitterPerPos splitpct=100")
        } else {
            DC_Run("cm_PanelsSplitterPerPos splitpct=0")
        }
    } else {
        DC_Run("cm_PanelsSplitterPerPos splitpct=50")
    }
return

<DC_PrevParallelDir>:
    DC_Run("cm_ExecuteToolbarItem ToolItemID={D682D989-E31B-4774-A95F-FCAAC0723803}")

    Sleep, 50
return

<DC_NextParallelDir>:
    DC_Run("cm_ExecuteToolbarItem ToolItemID={5CFC019B-CF36-4029-B3F6-3F1AAE3FE462}")

    Sleep, 50
return

<DC_CreateNewFile>:
    ControlGetFocus, TLB, % DC
    ControlGetPos, Xn, Yn, , , % TLB, % DC

    Menu, NewFileMenu, Add
    Menu, NewFileMenu, DeleteAll
    Menu, NewFileMenu, Add , S >> 快捷方式, <DC_CreateFileShortcut>
    Menu, NewFileMenu, Icon, S >> 快捷方式, %A_WinDir%\system32\Shell32.dll, 264
    Menu, NewFileMenu, Add

    Loop, % DC_Dir . "\shellnew\*.*" {
        Ft := SubStr(A_LoopFileName, 1, 1) . " >> " . A_LoopFileName
        Menu, NewFileMenu, Add, % Ft, DC_NewFileMenuAction
        Menu, NewFileMenu, Icon, % Ft, %A_WinDir%\system32\Shell32.dll
    }

    Menu, NewFileMenu, Show, % Xn, % Yn + 2
return

DC_NewFileMenuAction:
    Filename := RegExReplace(A_ThisMenuItem, ".\s>>\s")
    FilePath := DC_Dir . "\ShellNew\" . Filename

    Gui, Destroy
    Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
    Gui, Add, Edit, x72 y20 w300 h20 Disabled, % FilePath
    Gui, Add, Text, x12 y50 w50 h20 +Center, 新建文件
    Gui, Add, Edit, x72 y50 w300 h20, % Filename
    Gui, Add, Button, x162 y80 w90 h30 gDC_NewFileOk default, 确认(&S)
    Gui, Add, Button, x282 y80 w90 h30 gDC_NewFileClose , 取消(&C)
    Gui, Show, w400 h120, 新建文件

    if (InStr(Filename, ".")) {
        ; 只选定扩展名之外的文件名
        PostMessage, 0x0B1, 0, % InStr(Filename, ".") - 1, Edit2, A
    }
return

DC_NewFileClose:
    Gui, Destroy
return

DC_NewFileOK:
    GuiControlGet, SrcFilePath, , Edit1
    GuiControlGet, NewFilename, , Edit2

    DstPath := DC_RunGet("cm_CopyCurrentPathToClip")

    if (InStr(DstPath, "`r")) {
        DstPath := SubStr(DstPath, 1, InStr(DstPath, "`r") - 1)
    } else if (DstPath == "") {
        return
    }

    NewFilePath := DstPath . NewFilename
    if (FileExist(NewFilePath)) {
        MsgBox, 4, 新建文件, 新建文件已存在，是否覆盖？
        IfMsgBox No
            return
    }

    FileCopy, % SrcFilePath, % NewFilePath, 1

    Gui, Destroy

    ; 验证有没有用
    Sleep, 10
    ; 虽然不是完全匹配，基本也能用了
    DC_Run("cm_QuickSearch text=" . NewFilename)
return

<DC_Toggle>:
    if (WinExist(DC)) {
        WinGet, Ac, MinMax, % DC
        if (Ac == -1) {
            WinActivate, % DC
        } else {
            if (!WinActive(DC)) {
                WinActivate, % DC
            } else {
                WinMinimize, % DC
            }
        }
    } else {
        Run, % DC_Path
        WinWait, % DC

        if (!WinActive(DC)) {
            WinActivate, % DC
        }
    }
return

<DC_MarkFile>:
    SelectedFiles := DC_RunGet("cm_CopyNamesToClip")
    Result := """" . StrReplace(SelectedFiles, "`r`n", """ 🖥`r`n""") . """ 🖥`r`n"

    Sleep, 10
    DC_Run("cm_MarkUnmarkAll")

    FileAppend, % Result, % DC_RunGet("cm_CopyCurrentPathToClip") . "descript.ion", UTF-8-RAW

    DC_Run("cm_Refresh")

    SelectedFiles := ""
    Result := ""
return

<DC_UnMarkFile>:
    SelectedFiles := DC_RunGet("cm_CopyNamesToClip")
    DescriptPath := DC_RunGet("cm_CopyCurrentPathToClip") . "descript.ion"

    ; 有时取消选定会失效，改 20 也一样，不清楚怎么修复
    Sleep, 10
    DC_Run("cm_MarkUnmarkAll")

    FileRead, Content, % DescriptPath

    Loop, Parse, SelectedFiles, `n, `r
    {
        Content := StrReplace(Content, """" . A_LoopField . """ 🖥`r`n")
    }

    FileDelete, % DescriptPath

    if (Content != "") {
        FileAppend, % Content, % DescriptPath, UTF-8-RAW
    }

    DC_Run("cm_Refresh")

    SelectedFiles := ""
    Content := ""
return

<DC_AddComment>:
    InputBox, Content, , 请输入注释, , 375, 125
    if ErrorLevel
        return

    SelectedFiles := DC_RunGet("cm_CopyNamesToClip")

    Result := """" . StrReplace(SelectedFiles, "`r`n", """ " . Content . "`r`n""") . """ " . Content . "`r`n"

    Sleep, 10
    DC_Run("cm_MarkUnmarkAll")

    FileAppend, % Result, % DC_RunGet("cm_CopyCurrentPathToClip") . "descript.ion", UTF-8-RAW

    DC_Run("cm_Refresh")

    SelectedFiles := ""
    Result := ""
return

<DC_RemoveComment>:
    SelectedFiles := DC_RunGet("cm_CopyNamesToClip")
    DescriptPath := DC_RunGet("cm_CopyCurrentPathToClip") . "descript.ion"

    ; 有时取消选定会失效，改 20 也一样，不清楚怎么修复
    Sleep, 10
    DC_Run("cm_MarkUnmarkAll")

    FileRead, Content, % DescriptPath

    Loop, Parse, SelectedFiles, `n, `r
    {
        Content := RegexReplace(Content, "m)^""?" . A_LoopField . """? .*")
    }

    ; \K：前边的不算，重新开始匹配
    Content := RegexReplace(Content, "(^|\R)\K\R+")

    FileDelete, % DescriptPath

    if (Content != "") {
        FileAppend, % Content, % DescriptPath, UTF-8-RAW
    }

    DC_Run("cm_Refresh")

    SelectedFiles := ""
    Content := ""
return

<DC_EditComment>:
    Run, % editor . " """ . DC_RunGet("cm_CopyCurrentPathToClip") . "descript.ion"""
return

<DC_ToggleShowInfo>:
    Vim.GetWin(DC_Name).SetInfo(!Vim.GetWin(DC_Name).info)
return

<DC_CopyFileContent>:
    FileRead, Clipboard, % DC_RunGet("cm_CopyFullNamesToClip", false)
return

<DC_PasteFileContent>:
    Filename := DC_RunGet("cm_CopyFullNamesToClip")
    FileAppend, % Clipboard, % Filename, UTF-8-RAW
return

<DC_CopyFilenamesOnly>:
    Result := DC_RunGet("cm_CopyFullNamesToClip")

    SplitPath, Result, OutFileName, , , OutFilenameNoExt

    if (InStr(FileExist(Result), "D")) {
        Clipboard := OutFileName
    } else if (InStr(Result, ".")) {
        Clipboard := OutFilenameNoExt
    }
return

<DC_CreateFileShortcut>:
    FilePath := DC_RunGet("cm_CopyFullNamesToClip")

    OutVar := FileExist(FilePath)
    if (InStr(OutVar, "D")) {
        FileCreateShortcut, % FilePath, % FilePath . ".lnk", % RegExReplace(FilePath, "\\[^\\]*$")
    } else if (OutVar != "") {
        FileCreateShortcut, % FilePath, % RegExReplace(FilePath, "\.[^.]*$", ".lnk"), % RegExReplace(FilePath, "\\[^\\]*$")
    }
return

<DC_Focus>:
    IfWinExist, % DC
        Winactivate, % DC
    else {
        Run, % DC_Path
        WinWait, % DC
        IfWinNotActive, % DC
            WinActivate, % DC
    }
return

<DC_MapKeys>:
	Vim.Mode("normal", DC_Name)
    Vim.Map("<S-Enter>", "<DC_SelectedCurrentDir>", DC_Name)
    Vim.Map("<Esc>", "<DC_ReturnToCaller>", DC_Name)
return

<DC_UnMapKeys>:
	Vim.Mode("normal", DC_Name)
    Vim.Map("<S-Enter>", "<Default>", DC_Name)
    Vim.Map("<Esc>", "<Default>", DC_Name)
return

; 返回调用者
<DC_ReturnToCaller>:
    gosub <DC_UnMapKeys>

    WinActivate, ahk_id %DC_CallerId%

    DC_CallerId := 0
return

; 非 TC 窗口按下后激活 TC 窗口
; TC 窗口按下后复制当前选中文件返回原窗口后粘贴
<DC_OpenDCDialog>:
    WinGetClass, Name, A

    ; 在 DC 按下快捷键时，激活调用窗体并执行粘贴操作
    if (Name == DC_Class) {
        if (DC_CallerId != 0) {
            gosub <DC_Selected>
            return
		}
    } else {
        DC_CallerId := WinExist("A")
        if (DC_CallerId == 0) {
            return
		}

        gosub <DC_Focus>
        gosub <DC_MapKeys>
    }
return

<DC_Selected>:
    gosub <DC_UnMapKeys>

    if (DC_CallerId == 0) {
        return
    }

    ; 避免发送回车时受同时按下的 Win 等键影响
    ; MsgBox, , , 处理中, 0.3
    ; 通过修改 DC 代码解决

    Pwd := DC_RunGet("cm_CopyCurrentPathToClip", false)

    Filename := DC_RunGet("cm_CopyNamesToClip", false)

    WinActivate, ahk_id %DC_CallerId%
    WinWait, ahk_id %DC_CallerId%
    DC_CallerId := 0

    if (!InStr(Filename, "`n")) {
        Clipboard := Pwd . Filename
        Send, {Home}
        Send, ^v
        Send, {Enter}

        return
    }

    ; 多选

    Files := ""
    Loop, Parse, FIlename, `n, `r
        Files .= """" . A_LoopField  . """ "

    ; 第一步：跳转到当前路径
    Clipboard := Pwd
    Send, ^a
    Send, ^v
    Send, {Enter}
    sleep, 100

    ; 第二步：提交文件名
    Clipboard := Files
    Send, ^v
    Send, {Enter}
return

<DC_SelectedCurrentDir>:
    gosub <DC_UnMapKeys>

    if (DC_CallerId == 0) {
        return
    }

    DC_Run("cm_CopyCurrentPathToClip")

    WinActivate, ahk_id %DC_CallerId%
    WinWait, ahk_id %DC_CallerId%
    DC_CallerId := 0

    Send, {Home}
    Send, ^v
    Send, {Enter}
return
