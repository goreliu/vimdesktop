TotalCommander:
    global TCPath
    global TCDir
    global TCIni
    global TCMarkIni
    global ini
    global TC64Bit

    TCPath := ini.TotalCommander_Config.TCPath
    TCIni := ini.TotalCommander_Config.TCIni
    Splitpath, TCPath, , TCDir
    TCMarkIni := TCDir "\TCMark.ini"

    if (!FileExist(TCPath) || !FileExist(TCIni)) {
        MsgBox, 请在配置文件中设置正确的 TotalCommander 地址
        return
    }

    if (InStr(TCPath, "totalcmd64.exe")) {
        TC64Bit := true

        global TCListBox := "LCLListBox"
        ; 64 位的下方命令编辑框的 id 不固定，可能是 Edit1 或者 Edit2
        global TCEdit := "Edit1"
        global TInEdit := "Edit1"
        global TCPanel1 := "Window1"
        global TCPanel2 := "Window11"
        global TCPathPanel := "Window8"
        global TCPathPanelRight := "Window13"
    } else {
        ; 左右面板
        global TCListBox := "TMyListBox"
        ; 底下命令编辑框
        global TCEdit := "Edit1"
        ; 重命名文件编辑框
        global TInEdit := "TInEdit1"
        ; 纵向分隔
        global TCPanel1 := "TPanel1"
        ; 横向分隔
        global TCPanel2 := "TMyPanel8"
        ; 左地址栏
        global TCPathPanel := "TPathPanel1"
        ; 右地址栏
        global TCPathPanelRight := "TPathPanel2"
    }

    global Mark := []
    global SaveMark := ini.TotalCommander_Config.SaveMark

    if (SaveMark != 0) {
        IniRead, all_marks, %TCMarkIni%, mark, ms
        all_marks := StrReplace(all_marks, "ERROR", "")

        if (all_marks != "") {
            Mark["ms"] := all_marks

            Loop, Parse, all_marks
            {
                IniRead, new_mark, %TCMarkIni%, mark, %A_LoopField%

                Mark[A_LoopField] := new_mark
                Menu, MarkMenu, Add, %new_mark%, AddMark
            }
        }
    }

    global NewFiles := []

    Gosub, TCCommand

    vim.Comment("<TC_NormalMode>", "返回正常模式")
    vim.Comment("<TC_InsertMode>", "进入插入模式")
    vim.Comment("<TC_ToggleTC>", "打开/激活TC")
    vim.Comment("<TC_FocusTC>", "激活 TC")
    vim.Comment("<TC_FocusTCCmd>", "激活 TC，并定位到命令行")
    vim.Comment("<TC_AZHistory>", "a-z历史导航")
    vim.Comment("<TC_DownSelect>", "向下选择")
    vim.Comment("<TC_UpSelect>", "向上选择")
    vim.Comment("<TC_Mark>", "标记功能")
    vim.Comment("<TC_ForceDelete>", "强制删除")
    vim.Comment("<TC_ListMark>", "显示标记")
    vim.Comment("<TC_Toggle_50_100Percent>", "切换当前窗口显示状态 50% ~ 100%")
    vim.Comment("<TC_Toggle_50_100Percent_V>", "切换当前（纵向）窗口显示状态 50% ~ 100%")
    vim.Comment("<TC_WinMaxLeft>", "最大化左侧窗口")
    vim.Comment("<TC_WinMaxRight>", "最大化右侧窗口")
    vim.Comment("<TC_GoLastTab>", "切换到最后一个标签")
    vim.Comment("<TC_CopyNameOnly>", "只复制文件名，不含扩展名")
    vim.Comment("<TC_GotoLine>", "移动到 [count] 行，默认第一行")
    vim.Comment("<TC_LastLine>", "移动到 [count] 行，默认最后一行")
    vim.Comment("<TC_Half>", "移动到窗口中间行")
    vim.Comment("<TC_CreateNewFile>", "从模板创建文件")
    vim.Comment("<TC_GoToParentEx>", "返回到上层文件夹，可返回到我的电脑")
    vim.Comment("<TC_AlwayOnTop>", "设置 TC 顶置")
    vim.Comment("<TC_OpenDriveThis>", "打开驱动器列表:本侧")
    vim.Comment("<TC_OpenDriveThat>", "打开驱动器列表:另侧")
    vim.Comment("<TC_MoveDirectoryHotlist>", "移动到常用文件夹")
    vim.Comment("<TC_CopyDirectoryHotlist>", "复制到常用文件夹")
    vim.Comment("<TC_GotoPreviousDirOther>", "后退另一侧")
    vim.Comment("<TC_GotoNextDirOther>", "前进另一侧")
    vim.Comment("<TC_SearchMode>", "连续搜索")
    vim.Comment("<TC_CopyUseQueues>", "无需确认，使用队列拷贝文件至另一窗口")
    vim.Comment("<TC_MoveUseQueues>", "无需确认，使用队列移动文件至另一窗口")
    vim.Comment("<TC_ViewFileUnderCursor>", "使用查看器打开光标所在文件（shift + f3）")
    vim.Comment("<TC_OpenWithAlternateViewer>", "使用外部查看器打开（alt + f3）")
    vim.Comment("<TC_ToggleShowInfo>", "显示/隐藏: 按键提示")
    vim.Comment("<TC_ToggleMenu>", "显示/隐藏: 菜单栏")
    vim.Comment("<TC_SuperReturn>", "同回车键，但定位到第一个文件")
    vim.Comment("<TC_FileCopyForBak>", "将当前光标下的文件复制一份作为作为备份")
    vim.Comment("<TC_FileMoveForBak>", "将当前光标下的文件重命名为备份")
    vim.Comment("<TC_MultiFilePersistOpen>", "多个文件一次性连续打开")
    vim.Comment("<TC_CopyFileContents>", "不打开文件就复制文件内容")
    vim.Comment("<TC_OpenDirAndPaste>", "不打开目录，直接把复制的文件贴进去")
    vim.Comment("<TC_MoveSelectedFilesToPrevFolder>", "将当前文件夹下的选定文件移动到上层目录中")
    vim.Comment("<TC_MoveAllFilesToPrevFolder>", "将当前文件夹下的全部文件移动到上层目录中")
    vim.Comment("<TC_SrcQuickViewAndTab>", "预览文件时，光标自动移到对侧窗口里")
    vim.Comment("<TC_CreateFileShortcut>", "创建当前光标下文件的快捷方式")
    vim.Comment("<TC_CreateFileShortcutToDesktop>", "创建当前光标下文件的快捷方式并发送到桌面")
    vim.Comment("<TC_CreateFileShortcutToStartup>", "创建当前光标下文件的快捷方式并发送到启动文件里")
    vim.Comment("<TC_FilterSearchFNsuffix_exe>", "在当前目录里快速过滤 exe 扩展名的文件")
    vim.Comment("<TC_TwoFileExchangeName>", "两个文件互换文件名")
    vim.Comment("<TC_SelectCmd>", "选择命令来执行")
    vim.Comment("<TC_MarkFile>", "标记文件，将文件注释改成m")
    vim.Comment("<TC_UnMarkFile>", "取消文件标记，将文件注释清空")
    vim.Comment("<TC_ClearTitle>", "将 TC 标题栏字符串设置为空")
    vim.Comment("<TC_ReOpenTab>", "重新打开之前关闭的标签页")
    vim.Comment("<TC_OpenDirsInFile>", "将光标所在的文件内容中的文件夹在新标签页依次打开")
    vim.Comment("<TC_CreateBlankFile>", "创建空文件")
    vim.Comment("<TC_CreateBlankFileNoExt>", "创建无扩展名空文件")
    vim.Comment("<TC_PasteFileEx>", "粘贴文件，如果光标下为目录则粘贴进该目录")
    vim.Comment("<TC_ThumbsView>", "缩略图试图，并且修改 h 和 l 为方向键")
    vim.Comment("<TC_Restart>", "重启 TC")
    vim.Comment("<TC_PreviousParallelDir>", "切换到上一个同级目录")
    vim.Comment("<TC_NextParallelDir>", "切换到下一个同级目录")

    vim.SetWin("TCQuickSearch", "TQUICKSEARCH")
    vim.Mode("normal", "TCQuickSearch")
    vim.Map("J", "<Down>", "TCQuickSearch")
    vim.Map("K", "<Up>", "TCQuickSearch")

    vim.Mode("insert", "TTOTAL_CMD")
    vim.SetTimeOut(800, "TTOTAL_CMD")
    vim.Map("<esc>", "<TC_NormalMode>", "TTOTAL_CMD")

    vim.Mode("search", "TTOTAL_CMD")
    vim.Map("<esc>", "<TC_NormalMode>", "TTOTAL_CMD")

    vim.Mode("normal", "TTOTAL_CMD")

    vim.Map("fc", "<cm_CopyOtherpanel>", "TTOTAL_CMD")
    vim.Map("fx", "<cm_MoveOnly>", "TTOTAL_CMD")

    vim.Map("fqc", "<TC_CopyUseQueues>", "TTOTAL_CMD")
    vim.Map("fqx", "<TC_MoveUseQueues>", "TTOTAL_CMD")

    vim.Map("ff", "<cm_CopyToClipboard>", "TTOTAL_CMD")
    vim.Map("fz", "<cm_CutToClipboard>", "TTOTAL_CMD")
    vim.Map("fv", "<cm_PasteFromClipboard>", "TTOTAL_CMD")

    vim.Map("fb", "<TC_CopyDirectoryHotlist>", "TTOTAL_CMD")
    vim.Map("fd", "<TC_MoveDirectoryHotlist>", "TTOTAL_CMD")
    vim.Map("fg", "<cm_CopySrcPathToClip>", "TTOTAL_CMD")
    vim.Map("ft", "<cm_SyncChangeDir>", "TTOTAL_CMD")
    vim.Map("F", "<TC_SearchMode>", "TTOTAL_CMD")
    vim.Map("gh", "<TC_GotoPreviousDirOther>", "TTOTAL_CMD")
    vim.Map("gl", "<TC_GotoNextDirOther>", "TTOTAL_CMD")
    vim.Map("Vh", "<cm_SwitchIgnoreList>", "TTOTAL_CMD")
    vim.Map("0", "<0>", "TTOTAL_CMD")
    vim.Map("1", "<1>", "TTOTAL_CMD")
    vim.Map("2", "<2>", "TTOTAL_CMD")
    vim.Map("3", "<3>", "TTOTAL_CMD")
    vim.Map("4", "<4>", "TTOTAL_CMD")
    vim.Map("5", "<5>", "TTOTAL_CMD")
    vim.Map("6", "<6>", "TTOTAL_CMD")
    vim.Map("7", "<7>", "TTOTAL_CMD")
    vim.Map("8", "<8>", "TTOTAL_CMD")
    vim.Map("9", "<9>", "TTOTAL_CMD")
    vim.Map("k", "<up>", "TTOTAL_CMD")
    vim.Map("K", "<TC_UpSelect>", "TTOTAL_CMD")
    vim.Map("j", "<down>", "TTOTAL_CMD")
    vim.Map("J", "<TC_DownSelect>", "TTOTAL_CMD")
    vim.Map("h", "<left>", "TTOTAL_CMD")
    vim.Map("H", "<cm_GotoPreviousDir>", "TTOTAL_CMD")
    vim.Map("l", "<right>", "TTOTAL_CMD")
    vim.Map("L", "<cm_GotoNextDir>", "TTOTAL_CMD")
    vim.Map("I", "<TC_CreateNewFile>", "TTOTAL_CMD")
    vim.Map("i", "<TC_InsertMode>", "TTOTAL_CMD")
    vim.Map("d", "<cm_DirectoryHotlist>", "TTOTAL_CMD")
    vim.Map("D", "<cm_OpenDesktop>", "TTOTAL_CMD")
    vim.Map("e", "<cm_ContextMenu>", "TTOTAL_CMD")
    vim.Map("E", "<cm_ExecuteDOS>", "TTOTAL_CMD")
    vim.Map("n", "<TC_AZHistory>", "TTOTAL_CMD")
    vim.Map("m", "<TC_Mark>", "TTOTAL_CMD")
    vim.Map("M", "<TC_Half>", "TTOTAL_CMD")
    vim.Map("'", "<TC_ListMark>", "TTOTAL_CMD")
    vim.Map("u", "<TC_GoToParentEx>", "TTOTAL_CMD")
    vim.Map("U", "<cm_GoToRoot>", "TTOTAL_CMD")
    vim.Map("o", "<cm_LeftOpenDrives>", "TTOTAL_CMD")
    vim.Map("O", "<cm_RightOpenDrives>", "TTOTAL_CMD")
    vim.Map("q", "<cm_SrcQuickView>", "TTOTAL_CMD")
    vim.Map("r", "<cm_RenameOnly>", "TTOTAL_CMD")
    vim.Map("R", "<cm_MultiRenameFiles>", "TTOTAL_CMD")
    vim.Map("x", "<cm_Delete>", "TTOTAL_CMD")
    vim.Map("X", "<TC_ForceDelete>", "TTOTAL_CMD")
    vim.Map("w", "<cm_List>", "TTOTAL_CMD")
    vim.Map("y", "<cm_CopyNamesToClip>", "TTOTAL_CMD")
    vim.Map("Y", "<cm_CopyFullNamesToClip>", "TTOTAL_CMD")
    vim.Map("P", "<cm_PackFiles>", "TTOTAL_CMD")
    vim.Map("p", "<cm_UnpackFiles>", "TTOTAL_CMD")
    vim.Map("t", "<cm_OpenNewTab>", "TTOTAL_CMD")
    vim.Map("T", "<cm_OpenNewTabBg>", "TTOTAL_CMD")
    vim.Map("/", "<cm_ShowQuickSearch>", "TTOTAL_CMD")
    vim.Map("?", "<cm_SearchFor>", "TTOTAL_CMD")
    vim.Map("[", "<cm_SelectCurrentName>", "TTOTAL_CMD")
    vim.Map("{", "<cm_UnselectCurrentName>", "TTOTAL_CMD")
    vim.Map("]", "<cm_SelectCurrentExtension>", "TTOTAL_CMD")
    vim.Map("}", "<cm_UnSelectCurrentExtension>", "TTOTAL_CMD")
    vim.Map("\", "<cm_ExchangeSelection>", "TTOTAL_CMD")
    vim.Map("|", "<cm_ClearAll>", "TTOTAL_CMD")
    vim.Map("-", "<cm_SwitchSeparateTree>", "TTOTAL_CMD")
    vim.Map("=", "<cm_MatchSrc>", "TTOTAL_CMD")
    vim.Map(",", "<cm_SrcThumbs>", "TTOTAL_CMD")
    vim.Map(";", "<cm_DirectoryHotlist>", "TTOTAL_CMD")
    vim.Map(":", "<cm_FocusCmdLine>", "TTOTAL_CMD")
    vim.Map("~", "<cm_SysInfo>", "TTOTAL_CMD")
    vim.Map("``", "<TC_ToggleShowInfo>", "TTOTAL_CMD")
    vim.Map("G", "<TC_LastLine>", "TTOTAL_CMD")
    vim.Map("ga", "<cm_CloseAllTabs>", "TTOTAL_CMD")
    vim.Map("gg", "<TC_GoToLine>", "TTOTAL_CMD")
    vim.Map("g$", "<TC_LastLine>", "TTOTAL_CMD")

    vim.Map("gt", "<cm_SwitchToNextTab>", "TTOTAL_CMD")
    vim.Map("gT", "<cm_SwitchToPreviousTab>", "TTOTAL_CMD")
    vim.Map("gc", "<cm_CloseCurrentTab>", "TTOTAL_CMD")
    vim.Map("gb", "<cm_OpenDirInNewTabOther>", "TTOTAL_CMD")
    vim.Map("ge", "<cm_Exchange>", "TTOTAL_CMD")
    vim.Map("gr", "<TC_ReOpenTab>", "TTOTAL_CMD")
    vim.Map("gw", "<cm_ExchangeWithTabs>", "TTOTAL_CMD")
    vim.Map("g1", "<cm_SrcActivateTab1>", "TTOTAL_CMD")
    vim.Map("g2", "<cm_SrcActivateTab2>", "TTOTAL_CMD")
    vim.Map("g3", "<cm_SrcActivateTab3>", "TTOTAL_CMD")
    vim.Map("g4", "<cm_SrcActivateTab4>", "TTOTAL_CMD")
    vim.Map("g5", "<cm_SrcActivateTab5>", "TTOTAL_CMD")
    vim.Map("g6", "<cm_SrcActivateTab6>", "TTOTAL_CMD")
    vim.Map("g7", "<cm_SrcActivateTab7>", "TTOTAL_CMD")
    vim.Map("g8", "<cm_SrcActivateTab8>", "TTOTAL_CMD")
    vim.Map("g9", "<cm_SrcActivateTab9>", "TTOTAL_CMD")
    vim.Map("g0", "<TC_GoLastTab>", "TTOTAL_CMD")
    vim.Map("sn", "<cm_SrcByName>", "TTOTAL_CMD")
    vim.Map("se", "<cm_SrcByExt>", "TTOTAL_CMD")
    vim.Map("ss", "<cm_SrcBySize>", "TTOTAL_CMD")
    vim.Map("sd", "<cm_SrcByDateTime>", "TTOTAL_CMD")
    vim.Map("sr", "<cm_SrcNegOrder>", "TTOTAL_CMD")
    vim.Map("s1", "<cm_SrcSortByCol1>", "TTOTAL_CMD")
    vim.Map("s2", "<cm_SrcSortByCol2>", "TTOTAL_CMD")
    vim.Map("s3", "<cm_SrcSortByCol3>", "TTOTAL_CMD")
    vim.Map("s4", "<cm_SrcSortByCol4>", "TTOTAL_CMD")
    vim.Map("s5", "<cm_SrcSortByCol5>", "TTOTAL_CMD")
    vim.Map("s6", "<cm_SrcSortByCol6>", "TTOTAL_CMD")
    vim.Map("s7", "<cm_SrcSortByCol7>", "TTOTAL_CMD")
    vim.Map("s8", "<cm_SrcSortByCol8>", "TTOTAL_CMD")
    vim.Map("s9", "<cm_SrcSortByCol9>", "TTOTAL_CMD")
    vim.Map("s0", "<cm_SrcUnsorted>", "TTOTAL_CMD")
    vim.Map("v", "<cm_SrcCustomViewMenu>", "TTOTAL_CMD")
    vim.Map("Vb", "<cm_VisButtonbar>", "TTOTAL_CMD")
    vim.Map("Vm", "<TC_ToggleMenu>", "TTOTAL_CMD")
    vim.Map("Vd", "<cm_VisDriveButtons>", "TTOTAL_CMD")
    vim.Map("Vo", "<cm_VisTwoDriveButtons>", "TTOTAL_CMD")
    vim.Map("Vr", "<cm_VisDriveCombo>", "TTOTAL_CMD")
    vim.Map("Vc", "<cm_VisDriveCombo>", "TTOTAL_CMD")
    vim.Map("Vt", "<cm_VisTabHeader>", "TTOTAL_CMD")
    vim.Map("Vs", "<cm_VisStatusbar>", "TTOTAL_CMD")
    vim.Map("Vn", "<cm_VisCmdLine>", "TTOTAL_CMD")
    vim.Map("Vf", "<cm_VisKeyButtons>", "TTOTAL_CMD")
    vim.Map("Vw", "<cm_VisDirTabs>", "TTOTAL_CMD")
    vim.Map("Ve", "<cm_CommandBrowser>", "TTOTAL_CMD")
    vim.Map("zz", "<TC_Toggle_50_100Percent>", "TTOTAL_CMD")
    vim.Map("zh", "<TC_Toggle_50_100Percent_V>", "TTOTAL_CMD")
    vim.Map("zi", "<TC_WinMaxLeft>", "TTOTAL_CMD")
    vim.Map("zo", "<TC_WinMaxRight>", "TTOTAL_CMD")
    vim.Map("zt", "<TC_AlwayOnTop>", "TTOTAL_CMD")
    vim.Map("zn", "<cm_Minimize>", "TTOTAL_CMD")
    vim.Map("zm", "<cm_Maximize>", "TTOTAL_CMD")
    vim.Map("zr", "<cm_Restore>", "TTOTAL_CMD")
    vim.Map("zv", "<cm_VerticalPanels>", "TTOTAL_CMD")

    vim.BeforeActionDo("TC_BeforeActionDo", "TTOTAL_CMD")
return

TC_BeforeActionDo() {
    WinGet, MenuID, ID, ahk_class #32768
    if MenuID
        return true
    ControlGetFocus, ctrl, ahk_class TTOTAL_CMD
    Ifinstring, ctrl, %TCListBox%
        return false
    return true
}

<TC_NormalMode>:
    Send, {Esc}
    Gosub, <SwitchToEngIME>
    vim.Mode("normal", "TTOTAL_CMD")
return

<TC_SearchMode>:
    vim.Mode("search", "TTOTAL_CMD")
return

<TC_InsertMode>:
    vim.Mode("insert", "TTOTAL_CMD")
return

<TC_ToggleTC>:
    IfWinExist, ahk_class TTOTAL_CMD
    {
        WinGet, AC, MinMax, ahk_class TTOTAL_CMD
        if Ac = -1
            Winactivate, ahk_class TTOTAL_CMD
        else {
            Ifwinnotactive, ahk_class TTOTAL_CMD
                Winactivate, ahk_class TTOTAL_CMD
            else
                Winminimize, ahk_class TTOTAL_CMD
        }
    } else {
        Run, %TCPath%
        WinWait, ahk_class TTOTAL_CMD
        IfWinNotActive, ahk_class TTOTAL_CMD
            WinActivate, ahk_class TTOTAL_CMD
    }
return

<TC_FocusTC>:
    IfWinExist, ahk_class TTOTAL_CMD
        Winactivate, ahk_class TTOTAL_CMD
    else {
        Run, %TCPath%
        WinWait, ahk_class TTOTAL_CMD
        IfWinNotActive, ahk_class TTOTAL_CMD
            WinActivate, ahk_class TTOTAL_CMD
    }
return

<TC_FocusTCCmd>:
    Gosub, <TC_FocusTC>
    SendPos(4003)
return

<TC_AZHistory>:
    Gosub, <cm_ConfigSaveDirHistory>
    Sleep, 200

    history := ""
    if Mod(LeftRight(), 2) {
        f := ini.redirect.LeftHistory

        if FileExist(f)
            IniRead, history, %f%, LeftHistory
        else
            IniRead, history, %TCIni%, LeftHistory

        if RegExMatch(history, "RedirectSection=(.+)", HistoryRedirect) {
            StringReplace, HistoryRedirect1, HistoryRedirect1, `%COMMANDER_PATH`%, %TCPath%\..
            IniRead, history, %HistoryRedirect1%, LeftHistory
        }
    } else {
        f := ini.redirect.RightHistory

        if FileExist(f)
            IniRead, history, %f%, RightHistory
        else
            IniRead, history, %TCIni%, RightHistory

        if RegExMatch(history, "RedirectSection=(.+)", HistoryRedirect) {
            StringReplace, HistoryRedirect1, HistoryRedirect1, `%COMMANDER_PATH`%, %TCPath%\..
            IniRead, history, %HistoryRedirect1%, RightHistory
        }
    }

    history_obj := []
    global history_name_obj := []
    count := 0

    Loop, Parse, history, `n
    {
        idx := RegExReplace(A_LoopField, "=.*$")
        value := RegExReplace(A_LoopField, "^\d\d?=")

        ; 避免&被识别成快捷键
        name := StrReplace(value, "&", ":＆:")

        if (InStr(value, "::") == 1) {
            if (InStr(value, "::|") == 1) {
                name  := StrReplace(value, "::|")
                value := 2121
            } else if (InStr(value, "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}|") == 1) {
                name  := StrReplace(value, "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}|")
                value := 2122
            } else if (InStr(value, "::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{2227A280-3AEA-1069-A2DE-08002B30309D}|") == 1) {
                name  := StrReplace(value, "::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{2227A280-3AEA-1069-A2DE-08002B30309D}|")
                value := 2126
            } else if (InStr(value, "::{208D2C60-3AEA-1069-A2D7-08002B30309D}|") == 1) {
                ; NothingIsBig 的是 XP 系统，网上邻居是这个调整
                name := StrReplace(value, "::{208D2C60-3AEA-1069-A2D7-08002B30309D}|")
                value := 2125
            } else if (InStr(value, "::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}|") == 1) {
                name := StrReplace(value, "::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}|")
                value := 2125
            } else if (InStr(value, "::{26EE0668-A00A-44D7-9371-BEB064C98683}\0|") == 1) {
                name := StrReplace(value, "::{26EE0668-A00A-44D7-9371-BEB064C98683}\0|")
                value := 2123
            } else if (InStr(value, "::{645FF040-5081-101B-9F08-00AA002F954E}|") == 1) {
                name := StrReplace(value, "::{645FF040-5081-101B-9F08-00AA002F954E}|")
                value := 2127
            }
        }

        name := RegExReplace(name, "`t#.*$") A_Tab "[&"  chr(idx+65) "]"
        history_obj[idx] := name
        history_name_obj[name] := value

        if (++count >= 26) {
            break
        }
    }

    Menu, az, UseErrorLevel
    Menu, az, add
    Menu, az, deleteall
    size := TCConfig.GetValue("TotalCommander_Config", "MenuIconSize")
    if not size
        size := 20

    Loop, %count% {
        idx := A_Index - 1
        name := history_obj[idx]
        Menu, az, Add, %name%, AZHistorySelect
        Menu, az, icon, %name%, %A_ScriptDir%\plugins\TotalCommander\a-zhistory.icl, %A_Index%, %size%
    }

    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, wn, , %TLB%, ahk_class TTOTAL_CMD
    Menu, az, show, %xn%, %yn%
return

AZHistorySelect:
    global history_name_obj

    if (InStr(A_ThisMenuItem, "\\") == 1) {
        if (history_name_obj[A_ThisMenuItem] == 2121)
            Gosub, <cm_OpenDesktop>
        else if (history_name_obj[A_ThisMenuItem] == 2122)
            Gosub, <cm_OpenDrives>
        else if (history_name_obj[A_ThisMenuItem] == 2123)
            Gosub, <cm_OpenControls>
        else if (history_name_obj[A_ThisMenuItem] == 2125)
            Gosub, <cm_OpenNetwork>
        else if (history_name_obj[A_ThisMenuItem] == 2126)
            Gosub, <cm_OpenPrinters>
        else if (history_name_obj[A_ThisMenuItem] == 2127)
            Gosub, <cm_OpenRecycled>
        else {
            MsgBox, 打开 %A_ThisMenuItem% 失败
            return
        }
    } else {
        ThisMenuItem := RegExReplace(A_ThisMenuItem, "\t.*$")
        ThisMenuItem := StrReplace(ThisMenuItem, ":＆:", "&")

        FixTCEditId()

        ControlSetText, %TCEdit%, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {enter}, ahk_class TTOTAL_CMD
        ControlGetFocus, Ctrl, ahk_class TTOTAL_CMD
        Postmessage, 0x19E, 1, 1, %Ctrl%, ahk_class TTOTAL_CMD
    }
return

<TC_DownSelect>:
    Send +{Down}
return

<TC_UpSelect>:
    Send +{Up}
return

<TC_WinMaxLeft>:
    WinMaxLR(true)
return

<TC_WinMaxRight>:
    WinMaxLR(false)
return

WinMaxLR(lr)
{
    if lr {
        ControlGetPos, x, y, w, h, %TCPanel2%, ahk_class TTOTAL_CMD
        ControlGetPos, tm1x, tm1y, tm1W, tm1H, %TCPanel1%, ahk_class TTOTAL_CMD
        if (tm1w < tm1h) ; 判断纵向还是横向 Ture为竖 false为横
        {
            ControlMove, %TCPanel1%, x+w, , , , ahk_class TTOTAL_CMD
        }
        else
            ControlMove, %TCPanel1%, 0, y+h, , , ahk_class TTOTAL_CMD
        ControlClick, %TCPanel1%, ahk_class TTOTAL_CMD
        WinActivate ahk_class TTOTAL_CMD
    } else {
        ControlMove, %TCPanel1%, 0, 0, , , ahk_class TTOTAL_CMD
        ControlClick, %TCPanel1%, ahk_class TTOTAL_CMD
        WinActivate ahk_class TTOTAL_CMD
    }
}

<TC_GoLastTab>:
    Gosub, <cm_SrcActivateTab1>
    Gosub, <cm_SwitchToPreviousTab>
return

<TC_CopyNameOnly>:
    Clipboard :=
    Gosub, <cm_CopyNamesToClip>
    ClipWait

    if (InStr(Clipboard, "\") == StrLen(Clipboard)) {
        Clipboard := SubStr(Clipboard, 1, -1)
    } else if (InStr(Clipboard, ".")) {
        Clipboard := RegExReplace(Clipboard, "m)\.[^.]*$")
    }
return

<TC_ForceDelete>:
    Send +{Delete}
return

; 转到 [count] 行, 缺省第一行
<TC_GotoLine>:
    if (count := vim.GetCount("TTOTAL_CMD") > 1)
        TC_GotoLine(count)
    else
        TC_GotoLine(1)
return

; 转到 [count] 行, 最后一行
<TC_LastLine>:
    if (count := vim.GetCount("TTOTAL_CMD") > 1)
        TC_GotoLine(count)
    else
        TC_GotoLine(0)
return

TC_GotoLine(Index) {
    Vim_HotKeyCount := 0
    ControlGetFocus, Ctrl, ahk_class TTOTAL_CMD
    if Index {
        ControlGet, text, List, , %ctrl%, ahk_class TTOTAL_CMD
        Stringsplit, T, Text, `n
        Last := T0 - 1
        if Index > %Last%
            Index := Last
        Postmessage, 0x19E, %Index%, 1, %Ctrl%, ahk_class TTOTAL_CMD
    } else {
        ControlGet, text, List, , %ctrl%, ahk_class TTOTAL_CMD
        Stringsplit, T, Text, `n
        Last := T0 - 1
        PostMessage, 0x19E, %Last% , 1 , %CTRL%, ahk_class TTOTAL_CMD
    }
}

; 移动到窗口中间
<TC_Half>:
    winget, tid, id, ahk_class TTOTAL_CMD
    controlgetfocus, ctrl, ahk_id %tid%
    controlget, cid, hwnd, , %ctrl%, ahk_id %tid%
    controlgetpos, x1, y1, w1, h1, THeaderClick2, ahk_id %tid%
    controlgetpos, x, y, w, h, %ctrl%, ahk_id %tid%
    SendMessage, 0x01A1, 1, 0, , ahk_id %cid%
    Hight := ErrorLevel
    SendMessage, 0x018E, 0, 0, , ahk_id %cid%
    Top := ErrorLevel
    HalfLine := Ceil(((h - h1) / Hight) / 2 ) + Top
    PostMessage, 0x19E, %HalfLine%, 1, , AHK_id %cid%
return

; 标记功能
<TC_Mark>:
    vim.Mode("insert")
    Gosub, <cm_FocusCmdLine>
    ControlGet, EditId, Hwnd, , ahk_class TTOTAL_CMD

    FixTCEditId()

    ControlSetText, %TCEdit%, m, ahk_class TTOTAL_CMD
    Postmessage, 0xB1, 2, 2, %TCEdit%, ahk_class TTOTAL_CMD
    SetTimer, MarkTimer, 100
return

MarkTimer:
    ControlGetFocus, ThisControl, ahk_class TTOTAL_CMD

    FixTCEditId()

    ControlGetText, OutVar, %TCEdit%, ahk_class TTOTAL_CMD
    Match_TCEdit := "i)^" . TCEdit . "$"
    if Not RegExMatch(ThisControl, Match_TCEdit) OR Not RegExMatch(Outvar, "i)^m.?") {
        vim.Mode("normal")
        Settimer, MarkTimer, Off
        return
    }

    if RegExMatch(OutVar, "i)^m.+") {
        vim.Mode("normal")
        SetTimer, MarkTimer, off
        ControlSetText, %TCEdit%, , ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {Esc}, ahk_class TTOTAL_CMD
        ClipSaved := ClipboardAll
        Clipboard := ""
        Postmessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
        ClipWait
        Path := Clipboard
        Clipboard := ClipSaved
        ClipSaved := ""

        if (StrLen(Path) > 80) {
            SplitPath, Path, , PathDir
            Path1 := SubStr(Path, 1, 15)
            Path2 := SubStr(Path, RegExMatch(Path, "\\[^\\]*$")-Strlen(Path))
            Path := Path1 . "..." . SubStr(Path2, 1, 65) "..."
        }

        m := SubStr(OutVar, 2, 1)
        mPath := "&" . m . " >> " . Path
        if RegExMatch(Mark["ms"], m) {
            DelM := Mark[m]
            Menu, MarkMenu, Delete, %DelM%
            Menu, MarkMenu, Add, %mPath%, AddMark
            Mark[m] := mPath

            if (SaveMark != 0) {
                IniWrite, %mPath%, %TCMarkIni%, mark, %m%
            }
        } else {
            Menu, MarkMenu, Add, %mPath%, AddMark
            marks := Mark["ms"] . m
            Mark["ms"] := marks
            Mark[m] := mPath
            if (SaveMark != 0) {
                IniWrite, %marks%, %TCMarkIni%, mark, ms
                IniWrite, %mPath%, %TCMarkIni%, mark, %m%
            }
        }
    }
return

AddMark:
    ; &x >> dir
    ; &x >> run cmd
    ThisMenuItem := SubStr(A_ThisMenuItem, 7)

    if (InStr(ThisMenuItem, "run ") == 1) {
        Run, % SubStr(ThisMenuItem, 5)
        return
    } else if (InStr(ThisMenuItem, "\\") == 1) {
        if (ThisMenuItem == "\\桌面") {
            Postmessage 1075, 2121, 0, , ahk_class TTOTAL_CMD
            return
        } else if (ThisMenuItem == "\\计算机") {
            Postmessage 1075, 2122, 0, , ahk_class TTOTAL_CMD
            return
        } else if (ThisMenuItem == "\\所有控制面板项") {
            Postmessage 1075, 2123, 0, , ahk_class TTOTAL_CMD
            return
        } else if (ThisMenuItem = "\\Fonts") {
            Postmessage 1075, 2124, 0, , ahk_class TTOTAL_CMD
            return
        } else if (ThisMenuItem == "\\网络") {
            Postmessage 1075, 2125, 0, , ahk_class TTOTAL_CMD
            return
        } else if (ThisMenuItem == "\\打印机") {
            Postmessage 1075, 2126, 0, , ahk_class TTOTAL_CMD
            return
        } else if (ThisMenuItem == "\\回收站") {
            Postmessage 1075, 2127, 0, , ahk_class TTOTAL_CMD
            return
        }
    }

    FixTCEditId()

    ; 先跳转到回收站，避免在 FTP 等目录中中无法正常跳转
    ; 当回收站文件较多时会异常，不再使用
    ; Postmessage 1075, 2127, 0, , ahk_class TTOTAL_CMD

    ControlSetText, %TCEdit%, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
    ControlSend, %TCEdit%, {Enter}, ahk_class TTOTAL_CMD
    ControlGetFocus, Ctrl, ahk_class TTOTAL_CMD
    Postmessage, 0x19E, 1, 1, %Ctrl%, ahk_class TTOTAL_CMD
return

; 显示标记
<TC_ListMark>:
    if Not Mark["ms"]
        return
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, , , %TLB%, ahk_class TTOTAL_CMD
    Menu, MarkMenu, Show, %xn%, %yn%
return

<TC_CreateNewFile>:
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, , , %TLB%, ahk_class TTOTAL_CMD

    Menu, FileTemp, Add
    Menu, FileTemp, DeleteAll
    Menu, FileTemp, Add , F >> 文件夹, <cm_Mkdir>
    Menu, FileTemp, Icon, F >> 文件夹, %A_WinDir%\system32\Shell32.dll, 4
    Menu, FileTemp, Add , S >> 快捷方式, <cm_CreateShortcut>

    if A_OSVersion in WIN_2000, WIN_XP
        Menu, FileTemp, Icon, S >> 快捷方式, %A_WinDir%\system32\Shell32.dll, 30 ; 我测试 xp 下必须是 30
    else
        Menu, FileTemp, Icon, S >> 快捷方式, %A_WinDir%\system32\Shell32.dll, 264 ; 原来是 264，xp 下反正是有问题

    FileTempMenuCheck()
    Menu, FileTemp, Show, %xn%, %yn%
return

; 检查文件模板功能
FileTempMenuCheck() {
    global TCDir

    blankico := false

    if FileExist(TCDir "\ShellNew\blankico") {
        blankico := true
    }

    Loop, %TCDir%\ShellNew\*.* {
        if A_Index = 1
            Menu, FileTemp, Add
        ft := SubStr(A_LoopFileName, 1, 1) . " >> " . A_LoopFileName
        Menu, FileTemp, Add, %ft%, FileTempNew

        if (blankico) {
            Menu, FileTemp, Icon, %ft%, %A_WinDir%\system32\Shell32.dll, 1 ;-152
            continue
        } else if FileExist(TCDir "\ShellNew\icons\" A_LoopFileExt ".ico") {
            Menu, FileTemp, Icon, %ft%, % TCDir "\ShellNew\icons\" A_LoopFileExt ".ico"
            continue
        }

        Ext := "." . A_LoopFileExt
        IconFile := RegGetNewFileIcon(Ext)
        IconFile := StrReplace(IconFile, "%systemroot%", A_WinDir)
        IconFilePath := RegExReplace(IconFile, ",-?\d*", "")
        StringReplace, IconFilePath, IconFilePath, ", , A
        IconFileIndex := RegExReplace(IconFile, ".*,", "")
        IconFileIndex := IconFileIndex >= 0 ? IconFileIndex + 1 : IconFileIndex
        MsgBox, %Ext% %IconFile% %IconFilePath% %IconFileIndex%
        if Not FileExist(IconFilePath)
            Menu, FileTemp, Icon, %ft%, %A_WinDir%\system32\Shell32.dll, 1 ;-152
        else
            Menu, FileTemp, Icon, %ft%, %IconFilePath%, %IconFileIndex%
    }
}

; 新建文件模板
FileTempNew:
    NewFile(RegExReplace(A_ThisMenuItem, ".\s>>\s", RegExReplace(TCPath, "\\[^\\]*$", "\ShellNew\")))
return

; 新建文件
NewFile(File = "", Blank := false, Ext := "txt") {
    global NewFile

    if Not File
        File := RegExReplace(NewFiles[A_ThisMenuItemPos], "(.*\[|\]$)", "")

    if (Blank) {
        FileName := "New"
        FileNameNoExt := "New"
        FileExt := Ext

        if (Ext != "") {
            FileName .= "." Ext
        }
    } else if Not FileExist(File) {
        RegRead, ShellNewDir, HKEY_USERS, .default\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
        if Not ShellNewDir
            ShellNewDir := "C:\windows\ShellNew"
        File := ShellNewDir . "\" file

        if (SubStr(file, -7) = "NullFile") {
            FileExt := RegExReplace(NewFiles[A_ThisMenuItemPos], "(.*\(|\).*)")
            File := "New" . FileExt
            FileName := "New" . FileExt
            FileNameNoExt := "New"
        }
    }
    else
        Splitpath, file, filename, , FileExt, filenamenoext

    Gui, Destroy
    Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
    Gui, Add, Edit, x72 y20 w300 h20 Disabled, %file%
    Gui, Add, Text, x12 y50 w50 h20 +Center, 新建文件
    Gui, Add, Edit, x72 y50 w300 h20 , %filename%
    Gui, Add, Button, x162 y80 w90 h30 gNewFileOk default, 确认(&S)
    Gui, Add, Button, x282 y80 w90 h30 gNewFileClose , 取消(&C)
    Gui, Show, w400 h120, 新建文件

    if FileExt {
        Controlget, nf, hwnd, , edit2, A
        PostMessage, 0x0B1, 0, Strlen(filenamenoext), Edit2, A
    }
    return

    GuiEscape:
        Gui, Destroy
    return
}

; 关闭新建文件窗口
NewFileClose:
    Gui, Destroy
return

; 确认新建文件
NewFileOK:
    GuiControlGet, SrcPath, , Edit1
    GuiControlGet, NewFileName, , Edit2

    ClipSaved := ClipboardAll
    Clipboard :=
    Gosub, <cm_CopySrcPathToClip>
    ClipWait, 2
    DstPath := Clipboard
    Clipboard := ClipSaved
    ClipSaved := ""

    if (DstPath == "") {
        return
    }

    if (InStr(DstPath, "\\") == 1) {
        if (RegExMatch(DstPath, "^\\\\(计算机|所有控制面板项|Fonts|网络|打印机|回收站)$")) {
            MsgBox, 0, 提示, 无法在此处创建新文件
            Gui, Destroy
            return
        } else if (DstPath == "\\桌面") {
            DstPath := A_Desktop
        }
    }

    NewFile := DstPath . "\" . NewFileName
    if FileExist(NewFile) {
        MsgBox, 4, 新建文件, 新建文件已存在，是否覆盖？
        IfMsgBox No
        {
            return
        }
    }

    if FileExist(SrcPath) {
        FileCopy, %SrcPath%, %NewFile%, 1
    } else {
        Run, fsutil file createnew "%NewFile%" 0, , Hide
    }

    Gui, Destroy

    WinActivate, ahk_class TTOTAL_CMD
    ControlGetFocus, FocusCtrl, ahk_class TTOTAL_CMD
    if (InStr(FocusCtrl, TCListBox) == 1) {
        Gosub, <cm_RereadSource>
        ControlGet, Text, List, , %FocusCtrl%, ahk_class TTOTAL_CMD
        Loop, Parse, Text, `n
        {
            if (InStr(A_LoopField, NewFileName) == 1) {
                Postmessage, 0x19E, % A_Index - 1, 1, %FocusCtrl%, ahk_class TTOTAL_CMD
                break
            }
        }
    }
return

; 获取新建文件的源
; reg 为后缀
RegGetNewFilePath(reg) {
    RegRead, GetRegPath, HKEY_CLASSES_ROOT, %Reg%, FileName
    IF Not ErrorLevel
        return GetRegPath
    RegRead, GetRegPath, HKEY_CLASSES_ROOT, %Reg%, NullFile
    IF Not ErrorLevel
        return "NullFile"
}

; 获取新建文件类型名
; reg 为后缀
RegGetNewFileType(reg) {
    RegRead, FileType, HKEY_CLASSES_ROOT, %Reg%
    if Not ErrorLevel
        return FileType
}

; 获取文件描述
; reg 为后缀
RegGetNewFileDescribe(reg) {
    FileType := RegGetNewFileType(reg)
    RegRead, FileDesc, HKEY_CLASSES_ROOT, %FileType%
    if Not ErrorLevel
        return FileDesc
}

; 获取文件对应的图标
; reg 为后缀
RegGetNewFileIcon(reg) {
    IconPath := RegGetNewFileType(reg) . "\DefaultIcon"
    RegRead, FileIcon, HKEY_CLASSES_ROOT, %IconPath%
    if Not ErrorLevel
        return FileIcon
}

<TC_GoToParentEx>:
    ClipSaved := ClipboardAll
    Clipboard :=
    Gosub, <cm_CopySrcPathToClip>
    ClipWait, 1
    Path := Clipboard
    Clipboard := ClipSaved
    ClipSaved := ""

    if RegExMatch(Path, "^.:\\$") {
        Gosub, <cm_OpenDrives>
        Path := "i)" . RegExReplace(Path, "\\", "")
        ControlGetFocus, focus_control, ahk_class TTOTAL_CMD
        ControlGet, outvar, list, , %focus_control%, ahk_class TTOTAL_CMD
        Loop, Parse, Outvar, `n
        {
            if Not A_LoopField
                break
            if RegExMatch(A_LoopField, Path) {
                Focus := A_Index - 1
                break
            }
        }
        PostMessage, 0x19E, %Focus%, 1, %focus_control%, ahk_class TTOTAL_CMD
    } else {
        Gosub, <cm_GoToParent>
    }
return

<TC_AlwayOnTop>:
    WinGet, ExStyle, ExStyle, ahk_class TTOTAL_CMD
    if (ExStyle & 0x8)
        WinSet, AlwaysOnTop, off, ahk_class TTOTAL_CMD
    else
        WinSet, AlwaysOnTop, on, ahk_class TTOTAL_CMD
return

LeftRight() {
    location := 0
    ControlGetPos, x1, y1, , , %TCPanel1%, ahk_class TTOTAL_CMD
    if x1 > %y1%
        location += 2
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, x2, y2, wn, , %TLB%, ahk_class TTOTAL_CMD
    if (location) {
        if x1 > %x2%
            location += 1
    } else {
        if y1 > %y2%
            location += 1
    }

    return location
}

; 增强命令 By 流彩
; 常用文件夹:另一侧
<DirectoryHotlistother>:
    ControlGetFocus, CurrentFocus, ahk_class TTOTAL_CMD
    if CurrentFocus not in %TCListBox%2, %TCListBox%1
        return
    if CurrentFocus in %TCListBox%2
        otherlist = %TCListBox%1
    else
        otherlist = %TCListBox%2
    ControlFocus, %otherlist% , ahk_class TTOTAL_CMD
    SendPos(526)
    SetTimer WaitMenuPop3
return

WaitMenuPop3:
    winget, menupop, , ahk_class #32768
    if menupop {
        SetTimer, WaitMenuPop3, Off
        SetTimer, WaitMenuOff3
    }
return

WaitMenuOff3:
    winget, menupop, , ahk_class #32768
    if not menupop {
        SetTimer, WaitMenuOff3, off
        goto, goonhot
    }
return

goonhot:
    ControlFocus, %CurrentFocus% , ahk_class TTOTAL_CMD
return

;<TC_CopyDirectoryHotlist>: >>复制到常用文件夹{{{2
<TC_CopyDirectoryHotlist>:
    ControlGetFocus, CurrentFocus, ahk_class TTOTAL_CMD
    if CurrentFocus not in %TCListBox%2, %TCListBox%1
        return
    if CurrentFocus in %TCListBox%2
        otherlist = %TCListBox%1
    else
        otherlist = %TCListBox%2
    ControlFocus, %otherlist% , ahk_class TTOTAL_CMD
    SendPos(526)
    SetTimer WaitMenuPop1
return

WaitMenuPop1:
    winget, menupop, , ahk_class #32768
    if menupop
    {
        SetTimer, WaitMenuPop1 , Off
        SetTimer, WaitMenuOff1
    }
return

WaitMenuOff1:
    winget, menupop, , ahk_class #32768
    if not menupop {
        SetTimer, WaitMenuOff1, off
        goto, gooncopy
    }
return

gooncopy:
    ControlFocus, %CurrentFocus% , ahk_class TTOTAL_CMD
    SendPos(3101)
return

<TC_CopyUseQueues>:
    Send {F5}
    Send {F2}
return

<TC_MoveUseQueues>:
    Send {F6}
    Send {F2}
return

<TC_MoveDirectoryHotlist>:
    if SendPos(0)
        ControlGetFocus, CurrentFocus, ahk_class TTOTAL_CMD
    if CurrentFocus not in %TCListBox%2, %TCListBox%1
        return
    if CurrentFocus in %TCListBox%2
        otherlist = %TCListBox%1
    else
        otherlist = %TCListBox%2
    ControlFocus, %otherlist% , ahk_class TTOTAL_CMD
    SendPos(526)
    SetTimer WaitMenuPop2
return

WaitMenuPop2:
    winget, menupop, , ahk_class #32768
    if menupop {
        SetTimer, WaitMenuPop2 , Off
        SetTimer, WaitMenuOff2
    }
return

WaitMenuOff2:
    winget, menupop, , ahk_class #32768
    if not menupop {
        SetTimer, WaitMenuOff2, off
        goto, GoonMove
    }
return

GoonMove:
    ControlFocus, %CurrentFocus%, ahk_class TTOTAL_CMD
    SendPos(1005)
return

<TC_GotoPreviousDirOther>:
    Send {Tab}
    SendPos(570)
    Send {Tab}
return

<TC_GotoNextDirOther>:
    Send {Tab}
    SendPos(571)
    Send {Tab}
return

<TC_Toggle_50_100Percent>:
    ControlGetPos, , , wp, hp, %TCPanel1%, ahk_class TTOTAL_CMD
    ControlGetPos, , , w1, h1, %TCListBox%1, ahk_class TTOTAL_CMD
    ControlGetPos, , , w2, h2, %TCListBox%2, ahk_class TTOTAL_CMD
    if (wp < hp) {
        ;纵向
        if (abs(w1 - w2) > 2)
            SendPos(909)
        else
            SendPos(910)
    } else {
        ;横向
        if (abs(h1 - h2)  > 2)
            SendPos(909)
        else
            SendPos(910)
    }
return

; 横向分割的窗口使用 TC_Toggle_50_100Percent 即可
<TC_Toggle_50_100Percent_V>:
    ControlGetPos, , , wp, hp, %TCPanel1%, ahk_class TTOTAL_CMD
    ControlGetPos, , , w1, h1, %TCListBox%1, ahk_class TTOTAL_CMD
    ControlGetPos, , , w2, h2, %TCListBox%2, ahk_class TTOTAL_CMD
    ControlGetPos, , , w3, h3, %TCListBox%3, ahk_class TTOTAL_CMD
    ; msgbox % "wp " wp " hp " hp " w1 " w1 " h1 " h1 " w2 " w2 " h2 " h2 " w3 " w3 " h3 " h3

    ; 修复打开 FTP 等地址后失效的问题
    if (w3 > 0 && h3 > 0) {
        w1 := w2
        h1 := h2
        w2 := w3
        h2 := h3
    }

    if (wp < hp)  {
        ; 纵向

        if (abs(w1 - w2) > 2) {
            SendPos(909)
        } else {
            SendPos(910)
            SendPos(305)
        }
    } else {
        ; 横向

        if (abs(h1 - h2)  > 2) {
            SendPos(305)
            SendPos(909)
        }
        /*
        横向切换会错乱
        else {
            SendPos(910)
        }
        */
    }
return

<TC_OpenWithAlternateViewer>:
    send !{f3}
return

<TC_ViewFileUnderCursor>:
    send +{f3}
return

<TC_ToggleShowInfo>:
    vim.GetWin("TTOTAL_CMD").SetInfo(!vim.GetWin("TTOTAL_CMD").info)
return

<TC_ToggleMenu>:
    IniRead, Mainmenu, %TCIni%, Configuration, Mainmenu

    if (Mainmenu = "WCMD_CHN.MNU") {
        WinGet,TChwnd,Id,ahk_class TTOTAL_CMD
        DllCall("SetMenu", "uint", TChwnd, "uint", 0)
        IniWrite, NONE.MNU, %TCIni%, Configuration, Mainmenu
        IniWrite, 1, %TCIni%, Configuration, RestrictInterface

        noneMnuPath := TCDir . "\LANGUAGE\NONE.MNU"

        if (!FileExist(noneMnuPath)) {
            FileAppend, , %noneMnuPath%, UTF-8-RAW
        }
    } else {
        IniWrite, WCMD_CHN.MNU, %TCIni%, Configuration, Mainmenu
        IniWrite, 0, %TCIni%, Configuration, RestrictInterface

        WinClose, ahk_class TTOTAL_CMD
        WinWaitClose, ahk_class TTOTAL_CMD, , 2

        Run, %TCPath%
        WinWait, ahk_class TTOTAL_CMD

        IfWinNotActive, ahk_class TTOTAL_CMD
            WinActivate, ahk_class TTOTAL_CMD
    }
return

<TC_SuperReturn>:
    ; 浏览压缩文件时会失效

    ClipSaved := ClipboardAll
    Clipboard := ""
    Gosub, <cm_CopySrcPathToClip>
    ClipWait

    OldPwd := Clipboard

    Gosub, <cm_Return>

    Loop, 5 {
        Sleep, 10

        Clipboard := ""
        Gosub, <cm_CopySrcPathToClip>
        ClipWait

        if (OldPwd != Clipboard) {
            Gosub, <cm_GoToFirstEntry>
            break
        }
    }

    Clipboard := ClipSaved
    ClipSaved := ""
return

<TC_FileCopyForBak>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    filecopy, %Clipboard%, %Clipboard%.bak
Return

<TC_FileMoveForBak>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext

    if (Clipboard != dir . "\")
        FileMove, %Clipboard%, %Clipboard%.bak
    else
        FileMoveDir, %dir%, %dir%.bak
Return

<TC_MultiFilePersistOpen>:
    Clipboard :=
    Sendpos(2018)
    ClipWait
    SendPos(524)
    sleep, 200
    Loop, Parse, Clipboard, `n, `r
    {
        run, %A_LoopField%
    }
Return

<TC_CopyFileContents>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    fileread, Contents, %Clipboard%
    Clipboard := Contents
Return

<TC_OpenDirAndPaste>:
    SendPos(1001)
    SendPos(2009)
    SendPos(2002)
Return

<TC_MoveSelectedFilesToPrevFolder>:
    Send ^x
    SendPos(2002)
    Send ^v
Return

; 时间控制不好可能会误删文件，慎用
<TC_MoveAllFilesToPrevFolder>:
    Send ^a
    sleep 100
    Send ^x
    SendPos(2002)
    Send ^v
    sleep 500
    Send {del}
Return

<TC_SrcQuickViewAndTab>:
    SendPos(304)
    Send, {Tab}
    Send, {Shift}
Return

<TC_CreateFileShortcut>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext
    ExtLen := StrLen(ext)
    if %ExtLen% != 0
        FileCreateShortcut, %Clipboard%, %dir%\%name_no_ext%.lnk
    if %ExtLen% = 0
        FileCreateShortcut, %dir%, %dir%.lnk
Return

<TC_CreateFileShortcutToDesktop>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext
    ExtLen := StrLen(ext)
    if %ExtLen% != 0
        FileCreateShortcut, %Clipboard%, %dir%\%name_no_ext%.lnk
        FileMove, %dir%\%name_no_ext%.lnk, %USERPROFILE%\desktop\

        FixTCEditId()

        ; 如果不想打开桌面目录的话，注释以下 4 行

        ControlSetText, %TCEdit%, cd %USERPROFILE%\desktop\, ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {enter}, ahk_class TTOTAL_CMD
        ControlGetFocus, Ctrl, ahk_class TTOTAL_CMD
        Postmessage, 0x19E, 1, 1, %Ctrl%, ahk_class TTOTAL_CMD
Return

<TC_CreateFileShortcutToStartup>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext
    ExtLen := StrLen(ext)
    if (%ExtLen% != 0) {
        ; MsgBox, %Clipboard%
        FileCreateShortcut, %Clipboard%, %dir%\%name_no_ext%.lnk
        FileMove, %dir%\%name_no_ext%.lnk, %appdata%\Microsoft\Windows\Start Menu\Programs\Startup\

        FixTCEditId()

        ; 如果不想打开启动目录的话，注释以下4行
        ControlSetText, %TCEdit%, cd %appdata%\Microsoft\Windows\Start Menu\Programs\Startup\, ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {enter}, ahk_class TTOTAL_CMD
        ControlGetFocus, Ctrl, ahk_class TTOTAL_CMD
        Postmessage, 0x19E, 1, 1, %Ctrl%, ahk_class TTOTAL_CMD
    }
Return

<TC_FilterSearchFNsuffix_exe>:
    SendPos(2915)
    Send, *.exe
    Send, {ESC}
Return

<TC_TwoFileExchangeName>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    PathArray := StrSplit(Clipboard, "`r`n")
    FirstName := PathArray[1]
    SecondName := PathArray[2]
    SendPos(524)
    sleep, 200
    FileMove, %FirstName%, %FirstName%.bak
    FileMove, %SecondName%, %FirstName%
    FileMove, %FirstName%.bak, %SecondName%
Return

TC_OpenPath(Path, InNewTab := true, LeftOrRight := "") {
    if (LeftOrRight = "") {
        LeftOrRight := "/R"

        if Mod(LeftRight(), 2) {
            LeftOrRight := "/L"
        }
    }

    if (InNewTab) {
        Run, "%TCPath%" /O /T /A "%LeftOrRight%"="%Path%"
    } else {
        Run, "%TCPath%" /O /A "%LeftOrRight%"="%Path%"
    }
}

<TC_MarkFile>:
    Gosub, <cm_EditComment>
    ; 将备注设置为 m，可以通过将备注为 m 的文件显示成不同颜色，实现标记功能
    ; 不要在已有备注的文件使用
    Send, ^+{end}m{f2}
return

<TC_UnMarkFile>:
    Gosub, <cm_EditComment>
    ; 删除 TC_MarkFile 的文件标记，也可用于清空文件备注
    Send, ^+{end}{del}{f2}
return

<TC_SelectCmd>:
    Clipboard := ""

    Gosub, <cm_CommandBrowser>
    ; WinWaitClose, ahk_class TCmdSelForm
    ClipWait

    if (IsLabel("<" Clipboard ">")) {
        Gosub, <%Clipboard%>
    }
return

<TC_ClearTitle>:
    TC_SetTitle("", false)
return

; 自动设置的话显示效果滞后
TC_SetTitle(Title := "", KeepVersion := true) {
    if (KeepVersion) {
        WinGetTitle, OldTitle, ahk_class TTOTAL_CMD
        StringMid, NewTitle, OldTitle, 1, 21  ;保留TC的版本号信息
        WinSetTitle, ahk_class TTOTAL_CMD, , %NewTitle% - %Title%
    } else {
        WinSetTitle, ahk_class TTOTAL_CMD, , %Title%
    }
}

<TC_ReOpenTab>:
    Gosub, <cm_OpenNewTab>
    Gosub, <cm_GotoPreviousDir>
return

<TC_OpenDirsInFile>:
    OldClipboard := Clipboard
    Clipboard := ""
    Gosub, <cm_CopyFullNamesToClip>
    ClipWait
    FileRead, Contents, %Clipboard%
    Clipboard := OldClipboard
    OldClipboard =
    Loop, Parse, Contents, `n, `r
    {
        if FileExist(A_LoopField) {
            TC_OpenPath(A_LoopField, true)
            Sleep, 100
        }
    }
return

<TC_CreateBlankFile>:
    NewFile("创建空文件", true)
return

<TC_CreateBlankFileNoExt>:
    NewFile("创建空文件", true, "")
return

TC_Run(cmd) {
    FixTCEditId()

    ControlSetText, %TCEdit%, %cmd%, ahk_class TTOTAL_CMD
    ControlSend, %TCEdit%, {Enter}, ahk_class TTOTAL_CMD
}

<TC_PasteFileEx>:
    OldClipboard := ClipboardAll
    Clipboard =
    SendPos(524)   ;cm_ClearAll
    SendPos(2018)  ;cm_CopyFullNamesToClip
    ClipWait
    TempClip := Clipboard
    If (SubStr(TempClip, 0) == "\") {
        SendPos(1001)  ;cm_Return
        Clipboard := OldClipboard
        SendPos(2009)  ;cm_PasteFromClipboard
        SendPos(2002)  ;cm_GoToParent
    } else {
        Clipboard := OldClipboard
        SendPos(2009)  ;cm_PasteFromClipboard
    }
    OldClipboard =
return

; 缩略图视图，并且临时修改 h 和 l 按键为左右方向键
<TC_ThumbsView>:
    Gosub, <cm_SrcThumbs>
    Gosub, <TC_ThumbsViewSwitchKey>
return

<TC_ThumbsViewSwitchKey>:
    InThumbsView := !InThumbsView
    if (InThumbsView) {
        vim.Map("h", "<left>", "TTOTAL_CMD")
        vim.Map("l", "<right>", "TTOTAL_CMD")
    } else {
        vim.Map("h", "<cm_GoToParent>", "TTOTAL_CMD")
        vim.Map("l", "<TC_SuperReturn>", "TTOTAL_CMD")
    }
return

FixTCEditId() {
    global TC64Bit

    if (!TC64Bit) {
        return
    }

    ControlGetText, Result, Edit2, ahk_class TTOTAL_CMD

    if (ErrorLevel) {
        TCEdit := "Edit1"
    } else {
        TCEdit := "Edit2"
    }
}

<TC_Restart>:
    ErrorMessage := ""

    WinClose, ahk_class TTOTAL_CMD
    WinWaitClose, ahk_class TTOTAL_CMD, , 2
    ErrorMessage .= "|" ErrorLevel

    Run, %TCPath%
    ErrorMessage .= "|" ErrorLevel
    WinWaitActive, ahk_class TTOTAL_CMD
    ErrorMessage .= "|" ErrorLevel

    if (!WinExist("ahk_class TTOTAL_CMD")) {
        ; 有时重启失败，需要查询原因，而不是 Sleep 加重试
        MsgBox, 重启失败 %ErrorMessage%
    }
return

<TC_PreviousParallelDir>:
    ClipSaved := ClipboardAll
    Clipboard := ""
    Gosub, <cm_CopySrcPathToClip>
    ClipWait

    OldPwd := Clipboard

    if (StrLen(OldPwd) == 3) {
        ; 在根分区
        Gosub, <cm_GotoPreviousDrive>
        Gosub, <cm_GoToFirstEntry>

        Clipboard := ClipSaved
        ClipSaved := ""

        return
    } else if (RegExMatch(OldPwd, "^\\\\\\\w+\\\w+$")) {
        Clipboard := ClipSaved
        ClipSaved := ""

        return
    }

    Gosub, <cm_GoToParent>

    if (InStr(OldPwd, "\\\")) {
        ; 网络文件系统比较慢，等待下
        Sleep, 50
    }

    Gosub, <cm_GotoPrev>

    Clipboard := ""
    Gosub, <cm_CopyFullNamesToClip>
    ClipWait

    if (!InStr(OldPwd, Clipboard)) {
        Gosub, <cm_GoToDir>
        Gosub, <cm_GoToFirstEntry>
    } else {
        Gosub, <cm_GotoPreviousDir>
        Gosub, <cm_GoToFirstEntry>
    }

    Clipboard := ClipSaved
    ClipSaved := ""
return

<TC_NextParallelDir>:
    ClipSaved := ClipboardAll
    Clipboard := ""
    Gosub, <cm_CopySrcPathToClip>
    ClipWait

    OldPwd := Clipboard

    if (StrLen(OldPwd) == 3) {
        ; 在根分区
        Gosub, <cm_GotoNextDrive>
        Gosub, <cm_GoToFirstEntry>

        Clipboard := ClipSaved
        ClipSaved := ""

        return
    } else if (RegExMatch(OldPwd, "^\\\\\\\w+\\\w+$")) {
        Clipboard := ClipSaved
        ClipSaved := ""

        return
    }

    Gosub, <cm_GoToParent>

    if (InStr(OldPwd, "\\\")) {
        ; 网络文件系统比较慢，等待下
        Sleep, 50
    }

    Gosub, <cm_GotoNext>
    Gosub, <cm_GoToDir>

    if (InStr(OldPwd, "\\\")) {
        ; 网络文件系统比较慢，等待下
        Sleep, 50
    }

    Clipboard := ""
    Gosub, <cm_CopySrcPathToClip>
    ClipWait

    if (OldPwd != Clipboard && InStr(OldPwd, Clipboard)) {
        ; 下一个是文件而不是目录
        Gosub, <cm_GotoPreviousDir>
    } else {
        Gosub, <cm_GoToFirstEntry>
    }

    Clipboard := ClipSaved
    ClipSaved := ""
return

#Include %A_ScriptDir%\plugins\TotalCommander\TCCommand.ahk
