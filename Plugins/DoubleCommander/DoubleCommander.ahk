DoubleCommander:
    global DC := "ahk_class DClass"
    global DC_name := "DoubleCommander"
    global DC_Dir := "c:\mine\app\doublecmd"
    ; global DC_splitpct := 50

    ; normal模式
    vim.SetWin(DC_name, "DClass", "doublecmd.exe")
    vim.mode("normal", DC_name)

    vim.map("h", "<left>", DC_name)
    vim.map("j", "<down>", DC_name)
    vim.map("k", "<up>", DC_name)
    vim.map("l", "<enter>", DC_name)
    vim.map("gg", "<home>", DC_name)
    vim.map("G", "<end>", DC_name)
    vim.map("o", "<DC_ContextMenu>", DC_name)
    vim.map("<la-r>", "<DC_Rename>", DC_name)
    vim.map("<f1>", "<DC_Test>", DC_name)
    vim.map("<f2>", "<DC_RenameFull>", DC_name)
    vim.map("<f5>", "<DC_Restart>", DC_name)
    vim.map("<c-f>", "<pgdn>", DC_name)
    vim.map("<c-b>", "<pgup>", DC_name)
    vim.map("zz", "<DC_Show_50_50>", DC_name)
    vim.map("zi", "<DC_Show_100_0>", DC_name)
    vim.map("zo", "<DC_Show_0_100>", DC_name)
	vim.map("zv", "<DC_HorizontalFilePanels>", DC_name)
	vim.map("<S-K>", "<DC_PreviousParallelDir>", DC_name)
	vim.map("<S-J>", "<DC_NextParallelDir>", DC_name)
	vim.map("<c-k>", "<DC_UpSelect>", DC_name)
	vim.map("<c-j>", "<DC_DownSelect>", DC_name)
	vim.map("i", "<DC_CreateNewFile>", DC_name)
	vim.map("sn", "<DC_SortByName>", DC_name)
	vim.map("se", "<DC_SortByExt>", DC_name)
	vim.map("ss", "<DC_SortBySize>", DC_name)
	vim.map("sd", "<DC_SortByDate>", DC_name)
	vim.map("sa", "<DC_SortByAttr>", DC_name)
	vim.map("sr", "<DC_ReverseOrder>", DC_name)
	vim.map("s1", "<DC_SortByName>", DC_name)
	vim.map("s2", "<DC_SortByExt>", DC_name)
	vim.map("s3", "<DC_SortBySize>", DC_name)
	vim.map("s4", "<DC_SortByDate>", DC_name)

    vim.BeforeActionDo("DC_ForceInsertMode", DC_name)
return

DC_ForceInsertMode() {
    ControlGetFocus, ctrl
    if (ctrl == "Edit") {
        return true
    }

    WinGet, MenuID, ID, AHK_CLASS #32768
    if (MenuID != "") {
        return true
    }

    return false
}

DC_Run(cmd) {
    ControlSetText, Edit1, % cmd, % DC
    ControlSend, Edit1, {enter}, % DC
}

<DC_ContextMenu>:
    Send, {appskey}
return

<DC_Rename>:
    Send, {f2}{right}
return

<DC_RenameFull>:
    Send, {f2}^a
return

<DC_Test>:
    DC_Run("cm_About")
return

<DC_Restart>:
    WinClose, % DC
    WinWaitClose, % DC, , 2

    Run, c:\mine\app\doublecmd\doublecmd.exe

    WinWaitActive, % DC

    if (!WinExist(DC)) {
        MsgBox, 重启失败 %ErrorMessage%
    }
return

<DC_Show_50_50>:
    DC_Run("cm_PanelsSplitterPerPos splitpct=50")
return

<DC_Show_100_0>:
    DC_Run("cm_PanelsSplitterPerPos splitpct=100")
return

<DC_Show_0_100>:
    DC_Run("cm_PanelsSplitterPerPos splitpct=0")
return

<DC_HorizontalFilePanels>:
	DC_Run("cm_HorizontalFilePanels mode=legacy")
return

<DC_MakeDir>:
	DC_Run("cm_MakeDir")
return

<DC_PreviousParallelDir>:
; TODO
/*
    ClipSaved := ClipboardAll
    Clipboard := ""
    DC_Run("cm_CopyPathOfFilesToClip")
    ClipWait

    OldPwd := Clipboard

    if (StrLen(OldPwd) == 3) {
        ; 在根分区
        ; Gosub, <cm_GotoPreviousDrive>

        Clipboard := ClipSaved
        ClipSaved := ""

        return
    }
    ; DC_Run("cm_ChangeDirToParent")
*/

	Send, {left}
	Sleep, 10
	Send, {up}
	Sleep, 10
	Send, {right}

/*
    if (InStr(OldPwd, "wfx") == 1) {
        ; 网络文件系统比较慢，等待下
        Sleep, 50
    }

    Clipboard := ClipSaved
    ClipSaved := ""
*/
return

<DC_NextParallelDir>:
; TODO
	Send, {left}
	Sleep, 10
	Send, {down}
	Sleep, 10
	Send, {right}
return

<DC_DownSelect>:
    Send +{Down}
return

<DC_UpSelect>:
    Send +{Up}
return

<DC_CreateNewFile>:
    ControlGetFocus, TLB, % DC
	ControlGetPos, xn, yn, , , % TLB, % DC

    Menu, NewFileMenu, Add
    Menu, NewFileMenu, DeleteAll
/*
   TODO
    Menu, NewFileMenu, Add , S >> 快捷方式, <cm_CreateShortcut>
	Menu, NewFileMenu, Icon, S >> 快捷方式, %A_WinDir%\system32\Shell32.dll, 264
    Menu, NewFileMenu, Add
*/

    Loop, % DC_Dir . "\ShellNew\*.*" {
        ft := SubStr(A_LoopFileName, 1, 1) . " >> " . A_LoopFileName
        Menu, NewFileMenu, Add, % ft, DC_NewFileMenuAction
        Menu, NewFileMenu, Icon, % ft, %A_WinDir%\system32\Shell32.dll, 
    }

    Menu, NewFileMenu, Show, % xn, % yn + 2
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
return

DC_NewFileClose:
    Gui, Destroy
return

DC_NewFileOK:
    GuiControlGet, SrcFilePath, , Edit1
    GuiControlGet, NewFilename, , Edit2

    ClipSaved := ClipboardAll
    Clipboard :=
	DC_Run("cm_CopyPathOfFilesToClip")
    ClipWait, 2
    DstPath := Clipboard
    Clipboard := ClipSaved
    ClipSaved := ""

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

    ; TODO
    ; 好像无法实现定位到新创建的文件

    Gui, Destroy
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
        Run, c:\mine\app\doublecmd\doublecmd.exe
        WinWait, % DC

        if (!WinActive(DC)) {
            WinActivate, % DC
        }
    }
return

<DC_SortByName>:
    DC_Run("cm_SortByName")
return

<DC_SortByExt>:
    DC_Run("cm_SortByExt")
return

<DC_SortBySize>:
    DC_Run("cm_SortBySize")
return

<DC_SortByDate>:
    DC_Run("cm_SortByDate")
return

<DC_SortByAttr>:
    DC_Run("cm_SortByAttr")
return

<DC_ReverseOrder>:
    DC_Run("cm_ReverseOrder")
return

<DC_FocusSwap>:
    DC_run("cm_FocusSwap")
    ; side=left/right
return 

/* 
    DC 现有问题

    不能查看回收站（有些影响，暂时可以用资源管理器来查看）
    图片快速浏览过慢（影响不大，用 Imagine 后速度基本没问题了，只是快速切换图片时会闪屏）
    有时常规功能会导致错误弹窗（影响不大，可以关闭）
    左右面板的 ClassNN 不固定，很难获取位置信息（影响不大，可以改代码添加新命令获取）

	---

    DC 的优势

    开源，免费，跨平台，可以自由改代码定制功能，很好编译
    可以改代码让所有目录中的父目录（..）消失（已完成）
    内建 lua 解释器，方便写一些高级功能（感觉功能有限，用处不大）
    配置界面更漂亮、好用
    最吸引我的是可以通过修改源码定制和添加功能，迁移中

	---

    TODO

    切换到上/下一个同级目录（进行中）

    用右键菜单定制某些文件的打开方式
   
    实现命令 cm_GetPanelInfo（感觉用处不大，优先级低）
    无参数
    通过剪切板返回：m n
    m 左边则返回 left，右边则返回 right
    n 左面板占用比例，0-100
*/
