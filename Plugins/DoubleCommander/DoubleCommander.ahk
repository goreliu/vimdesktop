/*
    此插件仅供自用，依赖对 DC 代码的修改以及专门的配置

    ---

    DC 的优势

    开源，免费，跨平台，可以自由改代码定制功能，很好编译
    可以改代码让所有目录中的父目录（..）消失（已完成）
    可以把按键绑定到工具栏的子菜单上，然后再通过按键触发功能
    内建 lua 解释器，方便写一些高级功能（感觉功能有限，用处不大）
    主界面和配置界面更漂亮、好用

    ---

    TODO

    列表视图和缩略图试图返回上一级目录失效

    ff/fa 按键

    迁移 TC 的主菜单命令

    CreateShortcut 导出为命令

    缩略图模式自动修改按键绑定

    整理快捷键列表到配置文件

    切换到上/下一个同级目录（进行中）

    作为 OpenDialog
*/

DoubleCommander:
    global DC := "ahk_class DClass"
    global DC_Dir := "c:\mine\app\doublecmd"
    DC_Name := "DoubleCommander"

    vim.SetWin(DC_Name, "DClass", "doublecmd.exe")
    vim.Mode("normal", DC_Name)

    vim.Map("h", "<left>", DC_Name)
    vim.Map("j", "<down>", DC_Name)
    vim.Map("k", "<up>", DC_Name)
    vim.Map("l", "<enter>", DC_Name)
    vim.Map("gg", "<home>", DC_Name)
    vim.Map("G", "<end>", DC_Name)
    vim.Map("o", "<DC_ContextMenu>", DC_Name)
    vim.Map("<la-r>", "<DC_Rename>", DC_Name)
    vim.Map("<f1>", "<DC_Test>", DC_Name)
    vim.Map("<f2>", "<DC_RenameFull>", DC_Name)
    vim.Map("<f5>", "<DC_Restart>", DC_Name)
    vim.Map("<c-f>", "<pgdn>", DC_Name)
    vim.Map("<c-b>", "<pgup>", DC_Name)
    vim.Map("zz", "<DC_Toggle_50_100>", DC_Name)
    vim.Map("zi", "<DC_Show_100_0>", DC_Name)
    vim.Map("zo", "<DC_Show_0_100>", DC_Name)
    vim.Map("zv", "<DC_HorizontalFilePanels>", DC_Name)
    vim.Map("<S-K>", "<DC_PreviousParallelDir>", DC_Name)
    vim.Map("<S-J>", "<DC_NextParallelDir>", DC_Name)
    vim.Map("<c-k>", "<DC_UpSelect>", DC_Name)
    vim.Map("<c-j>", "<DC_DownSelect>", DC_Name)
    vim.Map("i", "<DC_CreateNewFile>", DC_Name)
    vim.Map("sn", "<DC_SortByName>", DC_Name)
    vim.Map("se", "<DC_SortByExt>", DC_Name)
    vim.Map("ss", "<DC_SortBySize>", DC_Name)
    vim.Map("sd", "<DC_SortByDate>", DC_Name)
    vim.Map("sa", "<DC_SortByAttr>", DC_Name)
    vim.Map("sr", "<DC_ReverseOrder>", DC_Name)
    vim.Map("s1", "<DC_SortByName>", DC_Name)
    vim.Map("s2", "<DC_SortByExt>", DC_Name)
    vim.Map("s3", "<DC_SortBySize>", DC_Name)
    vim.Map("s4", "<DC_SortByDate>", DC_Name)
    vim.Map(".", "<DC_OpenExplorer>", DC_Name)
    vim.Map("""", "<DC_MarkFile>", DC_Name)
    vim.Map("_", "<DC_UnMarkFile>", DC_Name)
    vim.Map("Vm", "<DC_ShowMainMenu>", DC_Name)
    vim.Map("Vb", "<DC_ShowButtonMenu>", DC_Name)
    vim.Map("Vv", "<DC_OperationsViewer>", DC_Name)
    vim.Map("Va", "<DC_BriefView>", DC_Name)
    vim.Map("V1", "<DC_ColumnsView1>", DC_Name)
    vim.Map("V2", "<DC_ColumnsView2>", DC_Name)

    vim.BeforeActionDo("DC_ForceInsertMode", DC_Name)
return

DC_ForceInsertMode() {
    ControlGetFocus, ctrl
    if (InStr(ctrl, "Edit") == 1) {
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

; 返回值 [1]: left/right [2]: 左侧面板所占比例 0-100
DC_GetPanelInfo() {
    ClipSaved := ClipboardAll
    Clipboard := ""
    DC_run("cm_CopyPanelInfoToClip")
    ClipWait, 2

    PanelInfo := StrSplit(Clipboard, " ")
    Clipboard := ClipSaved

    return PanelInfo
}

DC_ExecuteToolbarItem(Id) {
    DC_Run("cm_ExecuteToolbarItem ToolItemID=" . Id)
}

DC_ColumnsView(columnset) {
    if (columnset == "") {
        DC_Run("cm_ColumnsView")
    } else {
        DC_Run("cm_ColumnsView columnset=" columnset)
    }
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
    ; DC_ExecuteToolbarItem("{700FF494-B939-48A3-B248-8823EB366AEA}")
    DC_Run("cm_About")
return

<DC_Restart>:
    WinClose, % DC
    WinWaitClose, % DC, , 2

    Run, % DC_Dir . "\doublecmd.exe"

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

<DC_Toggle_50_100>:
    PanelInfo := DC_GetPanelInfo()

    if (abs(50 - PanelInfo[2]) < 10) {
        if (PanelInfo[1] == "left") {
            DC_Run("cm_PanelsSplitterPerPos splitpct=100")
        } else {
            DC_Run("cm_PanelsSplitterPerPos splitpct=0")
        }
    } else {
        DC_Run("cm_PanelsSplitterPerPos splitpct=50")
    }
return

<DC_MakeDir>:
    DC_Run("cm_MakeDir")
return

<DC_PreviousParallelDir>:
; TODO
/*
    ClipSaved := ClipboardAll
    Clipboard := ""
    DC_Run("cm_CopyCurrentPathToClip")
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
        Menu, NewFileMenu, Icon, % ft, %A_WinDir%\system32\Shell32.dll
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
    DC_Run("cm_CopyCurrentPathToClip")
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
        Run, % DC_Dir . "\doublecmd.exe"
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
    DC_Run("cm_FocusSwap")
    ; side=left/right
return

<DC_CopyCurrentPathToClip>:
    DC_Run("cm_CopyCurrentPathToClip")
return

<DC_OpenExplorer>:
    DC_Run(".")
return

<DC_MarkFile>:
    DC_Run("cm_EditComment")
    ; 不要在已有备注的文件使用
    Send, ^+{end}🖥{f2}
return

<DC_UnMarkFile>:
    DC_Run("cm_EditComment")
    ; 删除 DC_MarkFile 的文件标记，也可用于清空文件备注
    Send, ^+{end}{del}{f2}
return

<DC_ShowMainMenu>:
    DC_Run("cm_ShowMainMenu")
return

<DC_ShowButtonMenu>:
    DC_Run("cm_ShowButtonMenu")
return

<DC_OperationsViewer>:
    DC_Run("cm_OperationsViewer")
return

<DC_TreeView>:
    DC_Run("cm_TreeView")
return

<DC_FocusTreeView>:
    DC_Run("cm_FocusTreeView")
return

<DC_BriefView>:
    DC_Run("cm_BriefView")
return

<DC_ColumnsView1>:
    DC_ColumnsView("mine")
return

<DC_ColumnsView2>:
    DC_ColumnsView("test")
return
