TotalCommander:
    global TCPath
    global TCINI
    global TCMarkINI
    global ini

    TCPath := ini.TotalCommander_Config.TCPath
    TCINI := ini.TotalCommander_Config.TCINI

    if !FileExist(TCPath)
    {
        Process, Exist, totalcmd.exe
        if ErrorLevel
        {
            WinGet, TCPath, ProcessPath, ahk_pid %ErrorLevel%
        }
        else
        {
            Process, Exist, totalcmd64.exe
            if ErrorLevel
                WinGet, TCPath, ProcessPath, ahk_pid %ErrorLevel%
        }

        if TCPath
            IniWrite, %TCPath%, %ConfigPath%, TotalCommander_Config, TCPath
    }

    if TCPath and Not FileExist(TCPath)
    {
        RegRead, TCDir, HKEY_CURRENT_USER, Software\Ghisler\Total Commander, InstallDir
        if FileExist(TCDir "\totalcmd.exe")
            l .= TCDir "\totalcmd.exe`n"
        if FileExist(TCDir "\totalcmd64.exe")
            l .= TCDir "\totalcmd64.exe`n"
        GUI, FindTC:Add, Edit, w300 ReadOnly R3, %TCDir%
        GUI, FindTC:Add, Button, w300 gTotalcomander_select_tc, TOTALCMD.EXE   (&A)
        GUI, FindTC:Add, Button, w300 gTotalcomander_select_tc64, TOTALCMD64.EXE (&S)
        GUI, FindTC:Add, Button, w300 gTotalcomander_select_tcdir, TC目录路径不对? (&D)
        GUI, FindTC:Show, , Total Commander 设置路径
    }

    if TCPath and not FileExist(TCINI)
    {
        SplitPath, TCPath, , dir
        TCINI := dir "\wincmd.ini"
        IniWrite, %TCINI%, %ConfigPath%, TotalCommander_Config, TCINI
    }

    TCMarkINI := RegExReplace(TCPath, "i)totalcmd6?4?.exe$", "TCMark.ini")

    if RegExMatch(TcPath, "i)totalcmd64\.exe$")
    {
        Global TC64bit := True

        Global TCListBox := "LCLListBox"
        ; 64 位的下方命令编辑框的 id 不固定，可能是 Edit1 或者 Edit2
        Global TCEdit := "Edit1"
        Global TInEdit := "Edit1"
        GLobal TCPanel1 := "Window1"
        Global TCPanel2 := "Window11"
        Global TCPathPanel := "Window8"
        Global TCPathPanelRight := "Window13"
    }
    else
    {
        ; 左右面板
        Global TCListBox := "TMyListBox"
        ; 底下命令编辑框
        Global TCEdit := "Edit1"
        ; 重命名文件编辑框
        Global TInEdit := "TInEdit1"
        ; 纵向分隔
        Global TCPanel1 := "TPanel1"
        ; 横向分隔
        Global TCPanel2 := "TMyPanel8"
        ; 左地址栏
        Global TCPathPanel := "TPathPanel1"
        ; 右地址栏
        Global TCPathPanelRight := "TPathPanel2"
    }

    Global Mark := []
    Global SaveMark := ini.TotalCommander_Config.SaveMark

    if (SaveMark <> 0)
    {
        IniRead, all_marks, %TCMarkINI%, mark, ms
        all_marks := StrReplace(all_marks, "ERROR", "")

        if (all_marks <> "")
        {
            Mark["ms"] := all_marks

            Loop, Parse, all_marks
            {
                IniRead, new_mark, %TCMarkINI%, mark, %A_LoopField%

                Mark[A_LoopField] := new_mark
                Menu, MarkMenu, Add, %new_mark%, <AddMark>
            }
        }
    }

    Global NewFiles := []

    vim.Comment("<TC_NormalMode>", "返回正常模式")
    vim.Comment("<TC_InsertMode>", "进入插入模式")
    vim.Comment("<TC_ToggleTC>", "打开/激活TC")
    vim.Comment("<TC_FocusTCCmd>", "激活TC，定位到命令行")
    vim.Comment("<TC_azHistory>", "a-z历史导航")
    vim.Comment("<TC_DownSelect>", "向下选择")
    vim.Comment("<TC_UpSelect>", "向上选择")
    vim.Comment("<TC_Mark>", "标记功能")
    vim.Comment("<TC_ForceDelete>", "强制删除")
    vim.Comment("<TC_ListMark>", "显示标记")
    vim.Comment("<TC_Toggle_50_100Percent>", "切换当前窗口显示状态 50% ~ 100% ")
    vim.Comment("<TC_Toggle_50_100Percent_V>", "切换当前（纵向）窗口显示状态 50% ~ 100%")
    vim.Comment("<TC_WinMaxLeft>", "最大化左侧窗口")
    vim.Comment("<TC_WinMaxRight>", "最大化右侧窗口")
    vim.Comment("<TC_GoLastTab>", "切换到最后一个标签")
    vim.Comment("<TC_CopyNameOnly>", "只复制文件名，不含扩展名")
    vim.Comment("<TC_GotoLine>", "移动到 [count] 行，默认第一行")
    vim.Comment("<TC_LastLine>", "移动到 [count] 行，默认最后一行")
    vim.Comment("<TC_Half>", "移动到窗口中间行")
    vim.Comment("<TC_CreateNewFile>", "文件模板")
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
    vim.Comment("<TC_SrcQuickViewAndTab>", "预览文件时,光标自动移到对侧窗口里")
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

    GoSub, TCCOMMAND

    vim.SetWin("TCQuickSearch", "TQUICKSEARCH")
    vim.mode("normal", "TCQuickSearch")
    vim.map("J", "<Down>", "TCQuickSearch")
    vim.map("K", "<Up>", "TCQuickSearch")
    ;vim.map("<esc>", "<TC_NormalMode>", "TCQuickSearch")

    vim.mode("insert", "TTOTAL_CMD")
    vim.SetTimeOut(800, "TTOTAL_CMD")
    vim.map("<esc>", "<TC_NormalMode>", "TTOTAL_CMD")

    vim.mode("search", "TTOTAL_CMD")
    vim.map("<esc>", "<TC_NormalMode>", "TTOTAL_CMD")

    vim.mode("normal", "TTOTAL_CMD")

    ;复制/移动到右侧 f取file的意思 filecopy
    vim.map("fc", "<cm_CopyOtherpanel>", "TTOTAL_CMD")
    vim.map("fx", "<cm_MoveOnly>", "TTOTAL_CMD")

    ;使用队列复制/移动到右侧 q-queue, fcq会影响对fc的使用，改用fqc/fqx的方式
    vim.map("fqc", "<TC_CopyUseQueues>", "TTOTAL_CMD")
    vim.map("fqx", "<TC_MoveUseQueues>", "TTOTAL_CMD")

    ;ff复制到剪切板 fz剪切到剪切板 fv粘贴
    vim.map("ff", "<cm_CopyToClipboard>", "TTOTAL_CMD")
    vim.map("fz", "<cm_CutToClipboard>", "TTOTAL_CMD")
    vim.map("fv", "<cm_PasteFromClipboard>", "TTOTAL_CMD")

    ;fb复制到收藏夹某个目录，fd移动到收藏夹的某个目录
    vim.map("fb", "<TC_CopyDirectoryHotlist>", "TTOTAL_CMD")
    vim.map("fd", "<TC_MoveDirectoryHotlist>", "TTOTAL_CMD")
    vim.map("fg", "<cm_CopySrcPathToClip>", "TTOTAL_CMD")
    vim.map("ft", "<cm_SyncChangeDir>", "TTOTAL_CMD")
    vim.map("F", "<TC_SearchMode>", "TTOTAL_CMD")
    vim.map("gh", "<TC_GotoPreviousDirOther>", "TTOTAL_CMD")
    vim.map("gl", "<TC_GotoNextDirOther>", "TTOTAL_CMD")
    vim.map("Vh", "<cm_SwitchIgnoreList>", "TTOTAL_CMD")
    vim.map("0", "<0>", "TTOTAL_CMD")
    vim.map("1", "<1>", "TTOTAL_CMD")
    vim.map("2", "<2>", "TTOTAL_CMD")
    vim.map("3", "<3>", "TTOTAL_CMD")
    vim.map("4", "<4>", "TTOTAL_CMD")
    vim.map("5", "<5>", "TTOTAL_CMD")
    vim.map("6", "<6>", "TTOTAL_CMD")
    vim.map("7", "<7>", "TTOTAL_CMD")
    vim.map("8", "<8>", "TTOTAL_CMD")
    vim.map("9", "<9>", "TTOTAL_CMD")
    vim.map("k", "<up>", "TTOTAL_CMD")
    vim.map("K", "<TC_UpSelect>", "TTOTAL_CMD")
    vim.map("j", "<down>", "TTOTAL_CMD")
    vim.map("J", "<TC_DownSelect>", "TTOTAL_CMD")
    vim.map("h", "<left>", "TTOTAL_CMD")
    vim.map("H", "<cm_GotoPreviousDir>", "TTOTAL_CMD")
    vim.map("l", "<right>", "TTOTAL_CMD")
    vim.map("L", "<cm_GotoNextDir>", "TTOTAL_CMD")
    vim.map("I", "<TC_CreateNewFile>", "TTOTAL_CMD")
    vim.map("i", "<TC_InsertMode>", "TTOTAL_CMD")
    vim.map("d", "<cm_DirectoryHotlist>", "TTOTAL_CMD")
    vim.map("D", "<cm_OpenDesktop>", "TTOTAL_CMD")
    vim.map("e", "<cm_ContextMenu>", "TTOTAL_CMD")
    vim.map("E", "<cm_ExecuteDOS>", "TTOTAL_CMD")
    vim.map("n", "<TC_azHistory>", "TTOTAL_CMD")
    vim.map("m", "<TC_Mark>", "TTOTAL_CMD")
    vim.map("M", "<TC_Half>", "TTOTAL_CMD")
    vim.map("'", "<TC_ListMark>", "TTOTAL_CMD")
    vim.map("u", "<TC_GoToParentEx>", "TTOTAL_CMD")
    vim.map("U", "<cm_GoToRoot>", "TTOTAL_CMD")
    vim.map("o", "<cm_LeftOpenDrives>", "TTOTAL_CMD")
    vim.map("O", "<cm_RightOpenDrives>", "TTOTAL_CMD")
    vim.map("q", "<cm_SrcQuickView>", "TTOTAL_CMD")
    vim.map("r", "<cm_RenameOnly>", "TTOTAL_CMD")
    vim.map("R", "<cm_MultiRenameFiles>", "TTOTAL_CMD")
    vim.map("x", "<cm_Delete>", "TTOTAL_CMD")
    vim.map("X", "<TC_ForceDelete>", "TTOTAL_CMD")
    vim.map("w", "<cm_List>", "TTOTAL_CMD")
    vim.map("y", "<cm_CopyNamesToClip>", "TTOTAL_CMD")
    vim.map("Y", "<cm_CopyFullNamesToClip>", "TTOTAL_CMD")
    vim.map("P", "<cm_PackFiles>", "TTOTAL_CMD")
    vim.map("p", "<cm_UnpackFiles>", "TTOTAL_CMD")
    vim.map("t", "<cm_OpenNewTab>", "TTOTAL_CMD")
    vim.map("T", "<cm_OpenNewTabBg>", "TTOTAL_CMD")
    vim.map("/", "<cm_ShowQuickSearch>", "TTOTAL_CMD")
    vim.map("?", "<cm_SearchFor>", "TTOTAL_CMD")
    vim.map("[", "<cm_SelectCurrentName>", "TTOTAL_CMD")
    vim.map("{", "<cm_UnselectCurrentName>", "TTOTAL_CMD")
    vim.map("]", "<cm_SelectCurrentExtension>", "TTOTAL_CMD")
    vim.map("}", "<cm_UnSelectCurrentExtension>", "TTOTAL_CMD")
    vim.map("\", "<cm_ExchangeSelection>", "TTOTAL_CMD")
    vim.map("|", "<cm_ClearAll>", "TTOTAL_CMD")
    vim.map("-", "<cm_SwitchSeparateTree>", "TTOTAL_CMD")
    vim.map("=", "<cm_MatchSrc>", "TTOTAL_CMD")
    vim.map(",", "<cm_SrcThumbs>", "TTOTAL_CMD")
    vim.map(";", "<cm_DirectoryHotlist>", "TTOTAL_CMD")
    vim.map(":", "<cm_FocusCmdLine>", "TTOTAL_CMD")
    vim.map("~", "<cm_SysInfo>", "TTOTAL_CMD")
    vim.map("``", "<TC_ToggleShowInfo>", "TTOTAL_CMD")
    vim.map("G", "<TC_LastLine>", "TTOTAL_CMD")
    vim.map("ga", "<cm_CloseAllTabs>", "TTOTAL_CMD")
    vim.map("gg", "<TC_GoToLine>", "TTOTAL_CMD")
    vim.map("g$", "<TC_LastLine>", "TTOTAL_CMD")

    ;与vim保持一致
    vim.map("gt", "<cm_SwitchToNextTab>", "TTOTAL_CMD")
    vim.map("gT", "<cm_SwitchToPreviousTab>", "TTOTAL_CMD")
    vim.map("gc", "<cm_CloseCurrentTab>", "TTOTAL_CMD")
    vim.map("gb", "<cm_OpenDirInNewTabOther>", "TTOTAL_CMD")
    vim.map("ge", "<cm_Exchange>", "TTOTAL_CMD")
    vim.map("gr", "<TC_ReOpenTab>", "TTOTAL_CMD")
    vim.map("gw", "<cm_ExchangeWithTabs>", "TTOTAL_CMD")
    vim.map("g1", "<cm_SrcActivateTab1>", "TTOTAL_CMD")
    vim.map("g2", "<cm_SrcActivateTab2>", "TTOTAL_CMD")
    vim.map("g3", "<cm_SrcActivateTab3>", "TTOTAL_CMD")
    vim.map("g4", "<cm_SrcActivateTab4>", "TTOTAL_CMD")
    vim.map("g5", "<cm_SrcActivateTab5>", "TTOTAL_CMD")
    vim.map("g6", "<cm_SrcActivateTab6>", "TTOTAL_CMD")
    vim.map("g7", "<cm_SrcActivateTab7>", "TTOTAL_CMD")
    vim.map("g8", "<cm_SrcActivateTab8>", "TTOTAL_CMD")
    vim.map("g9", "<cm_SrcActivateTab9>", "TTOTAL_CMD")
    vim.map("g0", "<TC_GoLastTab>", "TTOTAL_CMD")
    vim.map("sn", "<cm_SrcByName>", "TTOTAL_CMD")
    vim.map("se", "<cm_SrcByExt>", "TTOTAL_CMD")
    vim.map("ss", "<cm_SrcBySize>", "TTOTAL_CMD")
    vim.map("sd", "<cm_SrcByDateTime>", "TTOTAL_CMD")
    vim.map("sr", "<cm_SrcNegOrder>", "TTOTAL_CMD")
    vim.map("s1", "<cm_SrcSortByCol1>", "TTOTAL_CMD")
    vim.map("s2", "<cm_SrcSortByCol2>", "TTOTAL_CMD")
    vim.map("s3", "<cm_SrcSortByCol3>", "TTOTAL_CMD")
    vim.map("s4", "<cm_SrcSortByCol4>", "TTOTAL_CMD")
    vim.map("s5", "<cm_SrcSortByCol5>", "TTOTAL_CMD")
    vim.map("s6", "<cm_SrcSortByCol6>", "TTOTAL_CMD")
    vim.map("s7", "<cm_SrcSortByCol7>", "TTOTAL_CMD")
    vim.map("s8", "<cm_SrcSortByCol8>", "TTOTAL_CMD")
    vim.map("s9", "<cm_SrcSortByCol9>", "TTOTAL_CMD")
    vim.map("s0", "<cm_SrcUnsorted>", "TTOTAL_CMD")
    vim.map("v", "<cm_SrcCustomViewMenu>", "TTOTAL_CMD")
    vim.map("Vb", "<cm_VisButtonbar>", "TTOTAL_CMD")
    vim.map("Vm", "<TC_ToggleMenu>", "TTOTAL_CMD")
    vim.map("Vd", "<cm_VisDriveButtons>", "TTOTAL_CMD")
    vim.map("Vo", "<cm_VisTwoDriveButtons>", "TTOTAL_CMD")
    vim.map("Vr", "<cm_VisDriveCombo>", "TTOTAL_CMD")
    vim.map("Vc", "<cm_VisDriveCombo>", "TTOTAL_CMD")
    vim.map("Vt", "<cm_VisTabHeader>", "TTOTAL_CMD")
    vim.map("Vs", "<cm_VisStatusbar>", "TTOTAL_CMD")
    vim.map("Vn", "<cm_VisCmdLine>", "TTOTAL_CMD")
    vim.map("Vf", "<cm_VisKeyButtons>", "TTOTAL_CMD")
    vim.map("Vw", "<cm_VisDirTabs>", "TTOTAL_CMD")
    vim.map("Ve", "<cm_CommandBrowser>", "TTOTAL_CMD")
    vim.map("zz", "<TC_Toggle_50_100Percent>", "TTOTAL_CMD")
    vim.map("zh", "<TC_Toggle_50_100Percent_V>", "TTOTAL_CMD")
    vim.map("zi", "<TC_WinMaxLeft>", "TTOTAL_CMD")
    vim.map("zo", "<TC_WinMaxRight>", "TTOTAL_CMD")
    vim.map("zt", "<TC_AlwayOnTop>", "TTOTAL_CMD")
    vim.map("zn", "<cm_Minimize>", "TTOTAL_CMD")
    vim.map("zm", "<cm_Maximize>", "TTOTAL_CMD")
    vim.map("zr", "<cm_Restore>", "TTOTAL_CMD")
    vim.map("zv", "<cm_VerticalPanels>", "TTOTAL_CMD")

    vim.BeforeActionDo("TC_BeforeActionDo", "TTOTAL_CMD")

    ;; 默认按键完
    ReadNewFile()
return

<TC_0>:
<TC_1>:
<TC_2>:
<TC_3>:
<TC_4>:
<TC_5>:
<TC_6>:
<TC_7>:
<TC_8>:
<TC_9>:
    Vim_HotKeyCount :=
return

/*
; TTOTAL_CMD_CheckMode()
TTOTAL_CMD_CheckMode()
{
    WinGet, MenuID, ID, AHK_CLASS #32768
    if MenuID
        return True
    ControlGetFocus, ctrl, AHK_CLASS TTOTAL_CMD
    if RegExMatch(ctrl, TInEdit)
        return false
    if RegExMatch(ctrl, TCEdit)
        return True

    Ifinstring, ctrl, %TCListBox%
        return False
    Ifinstring, ctrl, RichEdit20W1
        return False
    Ifinstring, ctrl, %TCListBox%
        return False
    return True
}
*/

TC_BeforeActionDo()
{
    Global TC_SendPos
    WinGet, MenuID, ID, AHK_CLASS #32768
    if MenuID And (TC_SendPos <> 572)
        return True
    ControlGetFocus, ctrl, AHK_CLASS TTOTAL_CMD
    Ifinstring, ctrl, %TCListBox%
        return False
    return True
}

<ExcSubOK>:
    Tooltip
return
; <TC_NormalMode> {{{1
<TC_NormalMode>:
    Send, {Esc}
    GoSub, <SwitchToEngIME>
    vim.Mode("normal", "TTOTAL_CMD")
    ;emptymem()
return
; <TC_SearchMode> {{{1
<TC_SearchMode>:
    vim.Mode("search", "TTOTAL_CMD")
return
; <TC_InsertMode> {{{1
<TC_InsertMode>:
    vim.Mode("insert", "TTOTAL_CMD")
return
; <TC_ToggleTC> {{{1
<TC_ToggleTC>:
    IfWinExist, AHK_CLASS TTOTAL_CMD
    {
        WinGet, AC, MinMax, AHK_CLASS TTOTAL_CMD
        if Ac = -1
            Winactivate, AHK_ClASS TTOTAL_CMD
        else
            Ifwinnotactive, AHK_CLASS TTOTAL_CMD
                Winactivate, AHK_CLASS TTOTAL_CMD
            else
                Winminimize, AHK_CLASS TTOTAL_CMD
    }
    else
    {
        Run, %TCPath%
        Loop, 4
        {
            IfWinNotActive, AHK_CLASS TTOTAL_CMD
                WinActivate, AHK_CLASS TTOTAL_CMD
            else
                Break
            Sleep, 500
        }
    }
    ;settimer, AUTHTC, on
    ;emptymem()
return

;激活TC
<FocusTC>:
{
    IfWinExist, AHK_CLASS TTOTAL_CMD
        Winactivate, AHK_ClASS TTOTAL_CMD
    else
    {
        Run, %TCPath%
        Loop, 4
        {
            IfWinNotActive, AHK_CLASS TTOTAL_CMD
                WinActivate, AHK_CLASS TTOTAL_CMD
            else
                Break
            Sleep, 500
        }
    }
    return
}

;激活TC，并定位到命令行
<TC_FocusTCCmd>:
{
    gosub, <FocusTC>
    SendPos(4003)
    return
}

AUTHTC:
    AUTHTC()
return
AUTHTC()
{
    WinGetText, string, ahk_class TNASTYNAGSCREEN
    if Strlen(string)
    {
        RegExMatch(string, "\d", idx)
        ControlClick, TButton%idx%, ahk_class TNASTYNAGSCREEN, , , , NA
        settimer, AUTHTC, off
    }
}
; <TC_azHistory> {{{1
<TC_azHistory>:
    TC_azHistory()
return
TC_azHistory()
{
    GoSub, <cm_ConfigSaveDirHistory>
    sleep, 200
    history := ""
    if Mod(LeftRight(), 2)
    {
        f := ini.redirect.LeftHistory

        if FileExist(f)
            IniRead, history, %f%, LeftHistory
        else
            IniRead, history, %TCINI%, LeftHistory

        if RegExMatch(history, "RedirectSection=(.+)", HistoryRedirect)
        {
            StringReplace, HistoryRedirect1, HistoryRedirect1, `%COMMANDER_PATH`%, %TCPath%\..
            IniRead, history, %HistoryRedirect1%, LeftHistory
        }
    }
    else
    {
        f := ini.redirect.RightHistory

        if FileExist(f)
            IniRead, history, %f%, RightHistory
        else
            IniRead, history, %TCINI%, RightHistory

        if RegExMatch(history, "RedirectSection=(.+)", HistoryRedirect)
        {
            StringReplace, HistoryRedirect1, HistoryRedirect1, `%COMMANDER_PATH`%, %TCPath%\..
            IniRead, history, %HistoryRedirect1%, RightHistory
        }
    }
    ;MsgBox, %f%_%TCINI%_%history%
    history_obj := []
    Global history_name_obj := []
    Loop, Parse, history, `n
        max := A_index
    Loop, Parse, history, `n
    {
        idx := RegExReplace(A_LoopField, "=.*$")
        value := RegExReplace(A_LoopField, "^\d\d?=")
        ; 避免&被识别成快捷键
        name := StrReplace(value, "&", ":＆:")
        if RegExMatch(Value, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}\|")
        {
            name  := RegExReplace(Value, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}\|")
            value := 2122
        }
        if RegExMatch(Value, "::\|")
        {
            name  := RegExReplace(Value, "::\|")
            value := 2121
        }
        if RegExMatch(Value, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}\|")
        {
            name  :=  RegExReplace(Value, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}\|")
            value := 2126
        }
        if RegExMatch(Value, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|") ;NothingIsBig的是XP系统，网上邻居是这个调整
        {
            name := RegExReplace(Value, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|")
            value := 2125
        }
        if RegExMatch(Value, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}\|")
        {
            name := RegExReplace(Value, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}\|")
            value := 2125
        }
        if RegExMatch(Value, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0\|")
        {
            name := RegExReplace(Value, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0\|")
            value := 2123
        }
        if RegExMatch(Value, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}\|")
        {
            name := RegExReplace(Value, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}\|")
            value := 2127
        }

        name := RegExReplace(name, "`t#.*$") A_Tab "[&"  chr(idx+65) "]"
        history_obj[idx] := name
        history_name_obj[name] := value
    }
    Menu, az, UseErrorLevel
    Menu, az, add
    Menu, az, deleteall
    size := TCConfig.GetValue("TotalCommander_Config", "MenuIconSize")
    if not size
        size := 20
    Loop, %max%
    {
        idx := A_Index - 1
        name := history_obj[idx]
        Menu, az, Add, %name%, azHistorySelect
        Menu, az, icon, %name%, %A_ScriptDir%\plugins\TotalCommander\a-zhistory.icl, %A_Index%, %size%
    }
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, wn, , %TLB%, ahk_class TTOTAL_CMD
    Menu, az, show, %xn%, %yn%
}
azHistorySelect:
    azHistorySelect()
return
azHistorySelect()
{
    Global history_name_obj
    if ( history_name_obj[A_ThisMenuItem] = 2122 ) or RegExMatch(A_ThisMenuItem, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}")
        GoSub, <cm_OpenDrives>
    else if ( history_name_obj[A_ThisMenuItem] = 2121 ) or RegExMatch(A_ThisMenuItem, "::(?!\{)")
        GoSub, <cm_OpenDesktop>
    else if ( history_name_obj[A_ThisMenuItem] = 2126 ) or RegExMatch(A_ThisMenuItem, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}")
        GoSub, <cm_OpenPrinters>
    else if ( history_name_obj[A_ThisMenuItem] = 2125 ) or RegExMatch(A_ThisMenuItem, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}") or RegExMatch(A_ThisMenuItem, "::\{208D2C60\-3AEA\-1069\-A2D7\-08002B30309D\}\|") ;NothingIsBig的是XP系统，网上邻居是这个调整
        GoSub, <cm_OpenNetwork>
    else if ( history_name_obj[A_ThisMenuItem] = 2123 ) or RegExMatch(A_ThisMenuItem, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0")
        GoSub, <cm_OpenControls>
    else if ( history_name_obj[A_ThisMenuItem] = 2127 ) or RegExMatch(A_ThisMenuItem, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}")
        GoSub, <cm_OpenRecycled>
    else
    {
        ThisMenuItem := RegExReplace(A_ThisMenuItem, "\t.*$")
        ThisMenuItem := StrReplace(ThisMenuItem, ":＆:", "&")

        if (TC64bit)
        {
            FixTCEditId()
        }

        ControlSetText, %TCEdit%, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {enter}, ahk_class TTOTAL_CMD
        ControlGetFocus, Ctrl, AHK_CLASS TTOTAL_CMD
        Postmessage, 0x19E, 1, 1, %Ctrl%, AHK_CLASS TTOTAL_CMD
    }
}
; <TC_DownSelect> {{{1
<TC_DownSelect>:
    Send +{Down}
return
; <TC_UpSelect> {{{1
<TC_UpSelect>:
    Send +{Up}
return
; <TC_WinMaxLeft> {{{1
<TC_WinMaxLeft>:
    WinMaxLR(true)
return
; <TC_WinMaxRight> {{{1
<TC_WinMaxRight>:
    WinMaxLR(false)
return
WinMaxLR(lr)
{
    if lr
    {
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
    }
    else
    {
        ControlMove, %TCPanel1%, 0, 0, , , ahk_class TTOTAL_CMD
        ControlClick, %TCPanel1%, ahk_class TTOTAL_CMD
        WinActivate ahk_class TTOTAL_CMD
    }
}
; <TC_GoLastTab> {{{1
<TC_GoLastTab>:
    GoSub, <cm_SrcActivateTab1>
    GoSub, <cm_SwitchToPreviousTab>
return
; <TC_CopyNameOnly> {{{1
<TC_CopyNameOnly>:
    TC_CopyNameOnly()
return
TC_CopyNameOnly()
{
    clipboard :=
    GoSub, <cm_CopyNamesToClip>
    ClipWait
    if Not RegExMatch(clipboard, "^\..*")
    {
        clipboard := RegExReplace(clipboard, "m)\.[^.]*$")
        clipboard := RegExReplace(clipboard, "m)\\$")
    }
}
; <TC_ForceDelete>  {{{1
; 强制删除
<TC_ForceDelete>:
    Send +{Delete}
return
; <TC_GotoLine> {{{1
; 转到[count]行, 缺省第一行
<TC_GotoLine>:
    if ( count := vim.GetCount("TTOTAL_CMD")) > 1
        TC_GotoLine(count)
    else
        TC_GotoLine(1)
return
; <TC_LastLine> {{{1
; 转到[count]行, 最后一行
<TC_LastLine>:
    if ( count := vim.GetCount("TTOTAL_CMD")) > 1
        TC_GotoLine(count)
    else
        TC_GotoLine(0)
return
TC_GotoLine(Index)
{
    Vim_HotKeyCount := 0
    ControlGetFocus, Ctrl, AHK_CLASS TTOTAL_CMD
    if Index
    {
        ;Index--
        ControlGet, text, List, , %ctrl%, AHK_CLASS TTOTAL_CMD
        Stringsplit, T, Text, `n
        Last := T0 - 1
        if Index > %Last%
            Index := Last
        Postmessage, 0x19E, %Index%, 1, %Ctrl%, AHK_CLASS TTOTAL_CMD
    }
    else
    {
        ControlGet, text, List, , %ctrl%, AHK_CLASS TTOTAL_CMD
        Stringsplit, T, Text, `n
        Last := T0 - 1
        PostMessage, 0x19E, %Last% , 1 , %CTRL%, AHK_CLASS TTOTAL_CMD
    }
}
; <TC_Half>  {{{1
; 移动到窗口中间
<TC_Half>:
    TC_Half()
return
TC_Half()
{
    winget, tid, id, ahk_class TTOTAL_CMD
    controlgetfocus, ctrl, ahk_id %tid%
    controlget, cid, hwnd, , %ctrl%, ahk_id %tid%
    controlgetpos, x1, y1, w1, h1, THeaderClick2, ahk_id %tid%
    controlgetpos, x, y, w, h, %ctrl%, ahk_id %tid%
    SendMessage, 0x01A1, 1, 0, , ahk_id %cid%
    Hight := ErrorLevel
    SendMessage, 0x018E, 0, 0, , ahk_id %cid%
    Top := ErrorLevel
    HalfLine := Ceil( ((h-h1)/Hight)/2 ) + Top
    PostMessage, 0x19E, %HalfLine%, 1, , AHK_id %cid%
}
; <TC_Mark> {{{1
; 标记功能
<TC_Mark>:
    TC_Mark()
return
TC_Mark()
{
    vim.mode("insert")
    GoSub, <cm_FocusCmdLine>
    ControlGet, EditId, Hwnd, , AHK_CLASS TTOTAL_CMD

    if (TC64bit)
    {
        FixTCEditId()
    }

    ControlSetText, %TCEdit%, m, AHK_CLASS TTOTAL_CMD
    Postmessage, 0xB1, 2, 2, %TCEdit%, AHK_CLASS TTOTAL_CMD
    SetTimer, <MarkTimer>, 100
}
<MarkTimer>:
    MarkTimer()
return
MarkTimer()
{
    ControlGetFocus, ThisControl, AHK_CLASS TTOTAL_CMD

    if (TC64bit)
    {
        FixTCEditId()
    }

    ControlGetText, OutVar, %TCEdit%, AHK_CLASS TTOTAL_CMD
    Match_TCEdit := "i)^" . TCEdit . "$"
    if Not RegExMatch(ThisControl, Match_TCEdit) OR Not RegExMatch(Outvar, "i)^m.?")
    {
        vim.mode("normal")
        Settimer, <MarkTimer>, Off
        return
    }
    if RegExMatch(OutVar, "i)^m.+")
    {
        vim.mode("normal")
        SetTimer, <MarkTimer>, off
        ControlSetText, %TCEdit%, , AHK_CLASS TTOTAL_CMD
        ControlSend, %TCEdit%, {Esc}, AHK_CLASS TTOTAL_CMD
        ClipSaved := ClipboardAll
        Clipboard :=
        Postmessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
        ClipWait
        Path := Clipboard
        Clipboard := ClipSaved
        if StrLen(Path) > 80
        {
            SplitPath, Path, , PathDir
            Path1 := SubStr(Path, 1, 15)
            Path2 := SubStr(Path, RegExMatch(Path, "\\[^\\]*$")-Strlen(Path))
            Path := Path1 . "..." . SubStr(Path2, 1, 65) "..."
        }
        m := SubStr(OutVar, 2, 1)
        mPath := "&" . m . " >> " . Path
        if RegExMatch(Mark["ms"], m)
        {
            DelM := Mark[m]
            Menu, MarkMenu, Delete, %DelM%
            Menu, MarkMenu, Add, %mPath%, <AddMark>
            Mark[m] := mPath
            if (SaveMark <> 0)
            {
                IniWrite, %mPath%, %TCMarkINI%, mark, %m%
            }
        }
        else
        {
            Menu, MarkMenu, Add, %mPath%, <AddMark>
            marks := Mark["ms"] . m
            Mark["ms"] := marks
            Mark[m] := mPath
            if (SaveMark <> 0)
            {
                IniWrite, %marks%, %TCMarkINI%, mark, ms
                IniWrite, %mPath%, %TCMarkINI%, mark, %m%
            }
        }
    }
}
<AddMark>:
    AddMark()
return
AddMark()
{
    ; &x >> dir
    ThisMenuItem := SubStr(A_ThisMenuItem, 7, StrLen(A_ThisMenuItem))
    if RegExMatch(ThisMenuItem, "i)\\\\桌面$")
    {
        Postmessage 1075, 2121, 0, , ahk_class TTOTAL_CMD
        return
    }
    if RegExMatch(ThisMenuItem, "i)\\\\计算机$")
    {
        Postmessage 1075, 2122, 0, , ahk_class TTOTAL_CMD
        return
    }
    if RegExMatch(ThisMenuItem, "i)\\\\所有控制面板项$")
    {
        Postmessage 1075, 2123, 0, , ahk_class TTOTAL_CMD
        return
    }
    if RegExMatch(ThisMenuItem, "i)\\\\Fonts$")
    {
        Postmessage 1075, 2124, 0, , ahk_class TTOTAL_CMD
        return
    }
    if RegExMatch(ThisMenuItem, "i)\\\\网络$")
    {
        Postmessage 1075, 2125, 0, , ahk_class TTOTAL_CMD
        return
    }
    if RegExMatch(ThisMenuItem, "i)\\\\打印机$")
    {
        Postmessage 1075, 2126, 0, , ahk_class TTOTAL_CMD
        return
    }
    if RegExMatch(ThisMenuItem, "i)\\\\回收站$")
    {
        Postmessage 1075, 2127, 0, , ahk_class TTOTAL_CMD
        return
    }

    if (TC64bit)
    {
        FixTCEditId()
    }

    ControlSetText, %TCEdit%, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
    ControlSend, %TCEdit%, {Enter}, ahk_class TTOTAL_CMD
    ControlGetFocus, Ctrl, AHK_CLASS TTOTAL_CMD
    Postmessage, 0x19E, 1, 1, %Ctrl%, AHK_CLASS TTOTAL_CMD
    return
}
; <TC_ListMark> {{{1
; 显示标记
<TC_ListMark>:
    TC_ListMark()
return
TC_ListMark()
{
    if Not Mark["ms"]
        return
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, , , %TLB%, ahk_class TTOTAL_CMD
    Menu, MarkMenu, Show, %xn%, %yn%
}

<TC_CreateNewFileNewStyle>:
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, , , %TLB%, ahk_class TTOTAL_CMD
    Menu, FileTemp, Add
    Menu, FileTemp, DeleteAll
    Menu, FileTemp, Add , F >> 文件夹, <cm_Mkdir>
    Menu, FileTemp, Icon, F >> 文件夹, %A_WinDir%\system32\Shell32.dll, 4
    Menu, FileTemp, Add , S >> 快捷方式, <cm_CreateShortcut>
    if A_OSVersion in WIN_2000, WIN_XP
        Menu, FileTemp, Icon, S >> 快捷方式, %A_WinDir%\system32\Shell32.dll, 30 ;我测试xp下必须是30
    else Menu, FileTemp, Icon, S >> 快捷方式, %A_WinDir%\system32\Shell32.dll, 264 ;原来是264，xp下反正是有问题
    FileTempMenuCheckNewStyle()
    Menu, FileTemp, Show, %xn%, %yn%
return

; <TC_CreateNewFile> {{{1
; 新建文件
<TC_CreateNewFile>:
    TC_CreateNewFile()
return
TC_CreateNewFile()
{
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, xn, yn, , , %TLB%, ahk_class TTOTAL_CMD
    Menu, FileTemp, Add
    Menu, FileTemp, DeleteAll
    Menu, FileTemp, Add , 0 新建文件, :TC_CreateNewFile
    Menu, FileTemp, Icon, 0 新建文件, %A_WinDir%\system32\Shell32.dll, -152
    Menu, FileTemp, Add , 1 文件夹, <cm_Mkdir>
    Menu, FileTemp, Icon, 1 文件夹, %A_WinDir%\system32\Shell32.dll, 4
    Menu, FileTemp, Add , 2 快捷方式, <cm_CreateShortcut>
    if A_OSVersion in WIN_2000, WIN_XP
        Menu, FileTemp, Icon, 2 快捷方式, %A_WinDir%\system32\Shell32.dll, 30 ;我测试xp下必须是30
    else Menu, FileTemp, Icon, 2 快捷方式, %A_WinDir%\system32\Shell32.dll, 264 ;原来是264，xp下反正是有问题
    Menu, FileTemp, Add , 3 添加到新模板, <AddToTempFiles>
    Menu, FileTemp, Icon, 3 添加到新模板, %A_WinDir%\system32\Shell32.dll, -155
    FileTempMenuCheck()
    Menu, FileTemp, Show, %xn%, %yn%
}
; 检查文件模板功能
FileTempMenuCheck()
{
    Global TCPath
    Splitpath, TCPath, , TCDir
    Loop, %TCDir%\shellnew\*.*
    {
        if A_Index = 1
            Menu, FileTemp, Add
        ft := chr(64+A_Index) . " >> " . A_LoopFileName
        Menu, FileTemp, Add, %ft%, FileTempNew
        Ext := "." . A_LoopFileExt
        IconFile := RegGetNewFileIcon(Ext)
        IconFile := RegExReplace(IconFile, "i)%systemroot%", A_WinDir)
        IconFilePath := RegExReplace(IconFile, ",-?\d*", "")
        StringReplace, IconFilePath, IconFilePath, ", , A
        IconFileIndex := RegExReplace(IconFile, ".*,", "")
        IconFileIndex := IconFileIndex>=0?IconFileIndex+1:IconFileIndex
        ;MsgBox, %Ext%_%IconFile%_%IconFilePath%_%IconFileIndex%
        if Not FileExist(IconFilePath)
            Menu, FileTemp, Icon, %ft%, %A_WinDir%\system32\Shell32.dll, 1 ;-152
        else
            Menu, FileTemp, Icon, %ft%, %IconFilePath%, %IconFileIndex%
    }
}

; 检查文件模板功能（新）
FileTempMenuCheckNewStyle()
{
    Global TCPath
    Splitpath, TCPath, , TCDir
    Loop, %TCDir%\shellnew\*.*
    {
        if A_Index = 1
            Menu, FileTemp, Add
        ft := SubStr(A_LoopFileName, 1, 1) . " >> " . A_LoopFileName
        Menu, FileTemp, Add, %ft%, FileTempNew

        if FileExist(TCDir "\shellnew\icons\" A_LoopFileExt ".ico")
        {
            Menu, FileTemp, Icon, %ft%, % TCDir "\shellnew\icons\" A_LoopFileExt ".ico"
            continue
        }

        Ext := "." . A_LoopFileExt
        IconFile := RegGetNewFileIcon(Ext)
        IconFile := RegExReplace(IconFile, "i)%systemroot%", A_WinDir)
        IconFilePath := RegExReplace(IconFile, ",-?\d*", "")
        StringReplace, IconFilePath, IconFilePath, ", , A
        IconFileIndex := RegExReplace(IconFile, ".*,", "")
        IconFileIndex := IconFileIndex>=0?IconFileIndex+1:IconFileIndex
        ;MsgBox, %Ext%_%IconFile%_%IconFilePath%_%IconFileIndex%
        if Not FileExist(IconFilePath)
            Menu, FileTemp, Icon, %ft%, %A_WinDir%\system32\Shell32.dll, 1 ;-152
        else
            Menu, FileTemp, Icon, %ft%, %IconFilePath%, %IconFileIndex%
    }
}
; 添加到文件模板中
<AddToTempFiles>:
    AddToTempFiles()
return
AddToTempFiles()
{
    ClipSaved := ClipboardAll
    Clipboard :=
    GoSub, <cm_CopyFullNamesToClip>
    ClipWait, 2
    if clipboard
        AddPath := clipboard
    else
        return
    clipboard := ClipSaved
    if FileExist(AddPath)
        Splitpath, AddPath, filename, , FileExt, filenamenoext
    else
        return
    Gui, Destroy
    Gui, Add, Text, Hidden, %AddPath%
    Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
    Gui, Add, Edit, x72 y20 w300 h20 Disabled, %FileName%
    Gui, Add, Text, x12 y50 w50 h20 +Center, 模板名
    Gui, Add, Edit, x72 y50 w300 h20 , %FileName%
    Gui, Add, Button, x162 y80 w90 h30 gAddTempOK default, 确认(&S)
    Gui, Add, Button, x282 y80 w90 h30 gNewFileClose , 取消(&C)
    Gui, Show, w400 h120, 添加模板
    if FileExt
    {
        Controlget, nf, hwnd, , edit2, A
        PostMessage, 0x0B1, 0, Strlen(filenamenoext), Edit2, A
    }
}
AddTempOK:
    AddTempOK()
return
AddTempOK()
{
    Global TCPath
    GuiControlGet, SrcPath, , Static1
    Splitpath, SrcPath, filename, , FileExt, filenamenoext
    GuiControlGet, NewFileName, , Edit2
    SNDir := RegExReplace(TCPath, "[^\\]*$") . "ShellNew\"
    if Not FileExist(SNDir)
        FileCreateDir, %SNDir%
    NewFile := SNDir . NewFileName
    FileCopy, %SrcPath%, %NewFile%, 1
    Gui, Destroy
}
; 新建文件模板
FileTempNew:
    NewFile(RegExReplace(A_ThisMenuItem, ".\s>>\s", RegExReplace(TCPath, "\\[^\\]*$", "\shellnew\")))
return
; 新建文件
NewFile:
    NewFile()
return
NewFile(File = "", Blank := False, Ext := "txt")
{
    Global NewFile
    if Not File
        File := RegExReplace(NewFiles[A_ThisMenuItemPos], "(.*\[|\]$)", "")
    if (Blank)
    {
        FileName := "New"
        FileNameNoExt := "New"
        FileExt := Ext

        if (Ext != "")
        {
            FileName .= "." Ext
        }
    }
    else if Not FileExist(File)
    {
        RegRead, ShellNewDir, HKEY_USERS, .default\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
        if Not ShellNewDir
            ShellNewDir := "C:\windows\Shellnew"
        File := ShellNewDir . "\" file
        if RegExMatch(SubStr(file, -7), "NullFile")
        {
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
    if FileExt
    {
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
    NewFileOK()
return
NewFileOK()
{
    GuiControlGet, SrcPath, , Edit1
    GuiControlGet, NewFileName, , Edit2
    ClipSaved := ClipboardAll
    Clipboard :=
    GoSub, <cm_CopySrcPathToClip>
    ClipWait, 2
    if clipboard
        DstPath := Clipboard
    else
        return
    clipboard := ClipSaved
        if RegExMatch(DstPath, "^\\\\计算机$")
        return
    if RegExMatch(DstPath, "i)\\\\所有控制面板项$")
        return
    if RegExMatch(DstPath, "i)\\\\Fonts$")
        return
    if RegExMatch(DstPath, "i)\\\\网络$")
        return
    if RegExMatch(DstPath, "i)\\\\打印机$")
        return
    if RegExMatch(DstPath, "i)\\\\回收站$")
        return
    if RegExmatch(DstPath, "^\\\\桌面$")
        DstPath := A_Desktop
    NewFile := DstPath . "\" . NewFileName
    if FileExist(NewFile)
    {
        MsgBox, 4, 新建文件, 新建文件已存在，是否覆盖？
        IfMsgBox No
            return
    }
    if !FileExist(SrcPath)
        Run, fsutil file createnew "%NewFile%" 0, , Hide
    else
        FileCopy, %SrcPath%, %NewFile%, 1

    Gui, Destroy
    WinActivate, AHK_CLASS TTOTAL_CMD
    ControlGetFocus, FocusCtrl, AHK_Class TTOTAL_CMD
    IF RegExMatch(FocusCtrl, TCListBox)
    {
        GoSub, <cm_RereadSource>
        ControlGet, Text, List, , %FocusCtrl%, AHK_CLASS TTOTAL_CMD
        Loop, Parse, Text, `n
        {
            if RegExMatch(A_LoopField, NewFileName)
            {
                Index := A_Index - 1
                Postmessage, 0x19E, %Index%, 1, %FocusCtrl%, AHK_CLASS TTOTAL_CMD
                Break
            }
        }
    }
}
;============================================================================
; ReadNewFile()
; 新建文件菜单
ReadNewFile()
{
    NewFiles[0] := 0
    SetBatchLines -1
    Loop, HKEY_CLASSES_ROOT , , 1, 0
    {
        if A_LoopRegName=.lnk ;让新建快捷方式无效
            continue
        else if RegExMatch(A_LoopRegName, "^\..*")
        {
            Reg := A_LoopRegName
            Loop, HKEY_CLASSES_ROOT, %Reg%, 1, 1
            {
                if RegExMatch(A_LoopRegName, "i)shellnew")
                {
                    NewReg := A_LoopRegSubKey "\shellnew"
                    if RegGetNewFilePath(NewReg)
                    {
                        NewFiles[0]++
                        Index := NewFiles[0]
                        NewFiles[Index] := RegGetNewFileDescribe(Reg) . "(" . Reg . ")[" . RegGetNewFilePath(NewReg) . "]"
                    }
                }
            }
        }
    }
    LoopCount := NewFiles[0]
    Half := LoopCount/2
    Loop % LoopCount
    {
        if A_Index < %Half%
        {
            B_Index := NewFiles[0] - A_Index + 1
            C_Index := NewFiles[A_Index]
            NewFiles[A_Index] := NewFiles[B_Index]
            NewFiles[B_Index] := C_Index
        }
    }
    Menu, TC_CreateNewFile, UseErrorLevel, On
    LastExt := ""
    Loop % NewFiles[0]
    {
        File := RegExReplace(NewFiles[A_Index], "\(.*", "")
        Ext := RegExReplace(NewFiles[A_Index], "(.*\(|\)\[.*)", "")
        MenuFile := Chr(A_Index+64) . " >> " . File . "(" Ext . ")"
        ; 去除重复的文件，只有连续出现的情况有效
        if (Ext = LastExt)
        {
            continue
        }
        LastExt := Ext

        Menu, TC_CreateNewFile, Add, %MenuFile%, NewFile

        IconFile := RegGetNewFileIcon(Ext)
        IconFile := RegExReplace(IconFile, "i)%systemroot%", A_WinDir)
        IconFile := RegExReplace(IconFile, "i)%ProgramFiles%", A_ProgramFiles)
        IconFilePath := RegExReplace(IconFile, ",-?\d*", "")
        StringReplace, IconFilePath, IconFilePath, ", , A
        if Not FileExist(IconFilePath)
            IconFilePath := ""
        IconFileIndex := RegExReplace(IconFile, ".*,", "")
        IconFileIndex := IconFileIndex>=0?IconFileIndex+1:IconFileIndex
        ;MsgBox, %IconFile%_%IconFilePath%_%IconFileIndex%
        if Not RegExMatch(IconFileIndex, "^-?\d*$")
            IconFileIndex := ""
        if RegExMatch(Ext, "\.lnk")
        {
            IconFilePath := A_WinDir . "\system32\Shell32.dll"
            IconFileIndex := "264"
        }
        Menu, TC_CreateNewFile, Icon, %MenuFile%, %IconFilePath%, %IconFileIndex%
    }
}
; 获取新建文件的源
; reg 为后缀
RegGetNewFilePath(reg)
{
    RegRead, GetRegPath, HKEY_CLASSES_ROOT, %Reg%, FileName
    IF Not ErrorLevel
        return GetRegPath
    RegRead, GetRegPath, HKEY_CLASSES_ROOT, %Reg%, NullFile
    IF Not ErrorLevel
        return "NullFile"
}
; RegGetNewFileType(reg)
; 获取新建文件类型名
; reg 为后缀
RegGetNewFileType(reg)
{
    RegRead, FileType, HKEY_CLASSES_ROOT, %Reg%
    if Not ErrorLevel
        return FileType
}
; 获取文件描述
; reg 为后缀
RegGetNewFileDescribe(reg)
{
    FileType := RegGetNewFileType(reg)
    RegRead, FileDesc, HKEY_CLASSES_ROOT, %FileType%
    if Not ErrorLevel
        return FileDesc
}
; 获取文件对应的图标
; reg 为后缀
RegGetNewFileIcon(reg)
{
    IconPath := RegGetNewFileType(reg) . "\DefaultIcon"
    RegRead, FileIcon, HKEY_CLASSES_ROOT, %IconPath%
    if Not ErrorLevel
        return FileIcon
}
; <TC_GoToParentEx> {{{1
; 返回到上层文件夹，可返回到我的电脑
<TC_GoToParentEx>:
    IsRootDir()
    GoSub, <cm_GoToParent>
return
IsRootDir()
{
    ClipSaved := ClipboardAll
    clipboard :=
    GoSub, <cm_CopySrcPathToClip>
    ClipWait, 1
    Path := Clipboard
    Clipboard := ClipSaved
    if RegExMatch(Path, "^.:\\$")
    {
        GoSub, <cm_OpenDrives>
        Path := "i)" . RegExReplace(Path, "\\", "")
        ControlGetFocus, focus_control, AHK_CLASS TTOTAL_CMD
        ControlGet, outvar, list, , %focus_control%, AHK_CLASS TTOTAL_CMD
        Loop, Parse, Outvar, `n
        {
            if Not A_LoopField
                Break
            if RegExMatch(A_LoopField, Path)
            {
                Focus := A_Index - 1
                Break
            }
        }
        PostMessage, 0x19E, %Focus%, 1, %focus_control%, AHK_CLASS TTOTAL_CMD
    }
}
<TC_AlwayOnTop>:
    TC_AlwayOnTop()
return
TC_AlwayOnTop()
{
    WinGet, ExStyle, ExStyle, ahk_class TTOTAL_CMD
    if (ExStyle & 0x8)
        WinSet, AlwaysOnTop, off, ahk_class TTOTAL_CMD
    else
        WinSet, AlwaysOnTop, on, ahk_class TTOTAL_CMD
}

; LeftRight(){{{1
LeftRight()
{
    location := 0
    ControlGetPos, x1, y1, , , %TCPanel1%, AHK_CLASS TTOTAL_CMD
    if x1 > %y1%
        location += 2
    ControlGetFocus, TLB, ahk_class TTOTAL_CMD
    ControlGetPos, x2, y2, wn, , %TLB%, ahk_class TTOTAL_CMD
    if location
    {
        if x1 > %x2%
            location += 1
    }
    else
    {
        if y1 > %y2%
            location += 1
    }
    return location
}

; 增强命令 By 流彩 {{{1
;<TC_OpenDriveThis>: >>打开驱动器列表:本侧{{{2
<TC_OpenDriveThis>:
    ControlGetFocus, CurrentFocus, AHK_CLASS TTOTAL_CMD
    if CurrentFocus not in %TCListBox%2, %TCListBox%1
        return
    if CurrentFocus in %TCListBox%2
        SendPos(131)
    else
        SendPos(231)
return

;<TC_OpenDriveThat>: >>打开驱动器列表:另侧{{{2
<TC_OpenDriveThat>:
    ControlGetFocus, CurrentFocus, AHK_CLASS TTOTAL_CMD
    if CurrentFocus not in %TCListBox%2, %TCListBox%1
        return
    if CurrentFocus in %TCListBox%2
        SendPos(231)
    else
        SendPos(131)
return

;<DirectoryHotlistother>: >>常用文件夹:另一侧{{{2
<DirectoryHotlistother>:
    ControlGetFocus, CurrentFocus, AHK_CLASS TTOTAL_CMD
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
    if menupop
    {
        SetTimer, WaitMenuPop3, Off
        SetTimer, WaitMenuOff3
    }
return
WaitMenuOff3:
    winget, menupop, , ahk_class #32768
    if not menupop
    {
        SetTimer, WaitMenuOff3, off
        goto, goonhot
    }
return
goonhot:
ControlFocus, %CurrentFocus% , ahk_class TTOTAL_CMD
return

;<TC_CopyDirectoryHotlist>: >>复制到常用文件夹{{{2
<TC_CopyDirectoryHotlist>:
    ControlGetFocus, CurrentFocus, AHK_CLASS TTOTAL_CMD
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
    if not menupop
    {
        SetTimer, WaitMenuOff1, off
        goto, gooncopy
    }
return
gooncopy:
    ControlFocus, %CurrentFocus% , ahk_class TTOTAL_CMD
    SendPos(3101)
return


;<TC_CopyUseQueues>: >>无需确认，使用队列拷贝文件至另一窗口{{{2
<TC_CopyUseQueues>:
    Send {F5}
    Send {F2}
return

;<TC_MoveUseQueues>: >>无需确认，使用队列移动文件至另一窗口{{{2
<TC_MoveUseQueues>:
    Send {F6}
    Send {F2}
return

;<TC_MoveDirectoryHotlist>: >>移动到常用文件夹{{{2
<TC_MoveDirectoryHotlist>:
    if SendPos(0)
        ControlGetFocus, CurrentFocus, AHK_CLASS TTOTAL_CMD
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
    if menupop
    {
        SetTimer, WaitMenuPop2 , Off
        SetTimer, WaitMenuOff2
    }
return

WaitMenuOff2:
    winget, menupop, , ahk_class #32768
    if not menupop
    {
        SetTimer, WaitMenuOff2, off
        goto, GoonMove
    }
return

GoonMove:
    ControlFocus, %CurrentFocus%, ahk_class TTOTAL_CMD
    SendPos(1005)
return

;<TC_GotoPreviousDirOther>: >>后退另一侧{{{2
<TC_GotoPreviousDirOther>:
    Send {Tab}
    SendPos(570)
    Send {Tab}
return

;<TC_GotoNextDirOther>: >>前进另一侧{{{2
<TC_GotoNextDirOther>:
    Send {Tab}
    SendPos(571)
    Send {Tab}
return

Totalcomander_select_tc:
    Totalcomander_select_tc()
return

Totalcomander_select_tc()
{
    GUI, FindTC:Default
    GuiControlGet, dir, , Edit1
    TCPath := dir "\totalcmd.exe"
    TCINI  := dir "\wincmd.ini"
    GUi, FindTC:Destroy
    IniWrite, %TCPath%, %ConfigPath%, TotalCommander_Config, TCPath
    IniWrite, %TCINI%, %ConfigPath%, TotalCommander_Config, TCINI
}

Totalcomander_select_tc64:
    Totalcomander_select_tc64()
return

Totalcomander_select_tc64()
{
    GUI, FindTC:Default
    GuiControlGet, dir, , Edit1
    TCPath := dir "\totalcmd64.exe"
    TCINI  := dir "\wincmd.ini"
    GUi, FindTC:Destroy
    IniWrite, %TCPath%, %ConfigPath%, TotalCommander_Config, TCPath
    IniWrite, %TCINI%, %ConfigPath%, TotalCommander_Config, TCINI
}

Totalcomander_select_tcdir:
    Totalcomander_select_tcdir()
return

Totalcomander_select_tcdir()
{
    FileSelectFolder, tcdir, , 0, 打开TC安装目录

    GuiControl, , Edit1, %tcdir%
}

; 切换当前（纵向）窗口显示状态50%~100%"
<TC_Toggle_50_100Percent>:
    ControlGetPos, , , wp, hp, %TCPanel1%, ahk_class TTOTAL_CMD
    ControlGetPos, , , w1, h1, %TCListBox%1, ahk_class TTOTAL_CMD
    ControlGetPos, , , w2, h2, %TCListBox%2, ahk_class TTOTAL_CMD
    if (wp < hp)
    {
        ;纵向
        if (abs(w1 - w2) > 2)
            SendPos(909)
        else
            SendPos(910)
    }
    else
    {
        ;横向
        if (abs(h1 - h2)  > 2)
            SendPos(909)
        else
            SendPos(910)
    }
return

; 切换当前（纵向）窗口显示状态50%~100%"
; 横向分割的窗口使用 TC_Toggle_50_100Percent 即可
<TC_Toggle_50_100Percent_V>:
    ControlGetPos, , , wp, hp, %TCPanel1%, ahk_class TTOTAL_CMD
    ControlGetPos, , , w1, h1, %TCListBox%1, ahk_class TTOTAL_CMD
    ControlGetPos, , , w2, h2, %TCListBox%2, ahk_class TTOTAL_CMD
    if (wp < hp)  ;纵向
    {
        if (abs(w1 - w2) > 2)
        {
            SendPos(909)
        }
        else
        {
            SendPos(910)
            SendPos(305)
        }
    }
    else          ;横向
    {
        if (abs(h1 - h2)  > 2)
        {
            SendPos(305)
            SendPos(909)
        }
        /*
        横向切换会错乱
        else
        {
            SendPos(910)
        }
        */
    }
return


;使用外部查看器打开（alt+f3）
<TC_OpenWithAlternateViewer>:
    send !{f3}
return

;使用查看器打开光标所在文件（shift+f3）
<TC_ViewFileUnderCursor>:
    send +{f3}
return

<TC_ToggleShowInfo>:
    vim.GetWin("TTOTAL_CMD").SetInfo(!vim.GetWin("TTOTAL_CMD").info)
return

<TC_ToggleMenu>:
    IniRead, Mainmenu, %TCINI%, Configuration, Mainmenu

    if (Mainmenu = "WCMD_CHN.MNU")
    {
        WinGet,TChwnd,Id,ahk_class TTOTAL_CMD
        DllCall("SetMenu", "uint", TChwnd, "uint", 0)
        IniWrite, NONE.MNU, %TCINI%, Configuration, Mainmenu
        IniWrite, 1, %TCINI%, Configuration, RestrictInterface

        noneMnuPath := RegExReplace(TCPath, "i)totalcmd6?4?.exe$", "LANGUAGE\NONE.MNU")

        if (!FileExist(noneMnuPath))
        {
            FileAppend, , %noneMnuPath%, UTF-8-RAW
        }
    }
    else
    {
        IniWrite, WCMD_CHN.MNU, %TCINI%, Configuration, Mainmenu
        IniWrite, 0, %TCINI%, Configuration, RestrictInterface

        WinClose, AHK_CLASS TTOTAL_CMD

        Loop, 4
        {
            Sleep, 50
            Run, %TCPath%
            IfWinNotActive, AHK_CLASS TTOTAL_CMD
                WinActivate, AHK_CLASS TTOTAL_CMD
            else
                Break
            Sleep, 100
        }
    }
return

<TC_SuperReturn>:
    ControlGetText, old_pwd_left, %TCPathPanel%, AHK_CLASS TTOTAL_CMD
    ControlGetText, old_pwd_right, %TCPathPanelRight%, AHK_CLASS TTOTAL_CMD

    GoSub, <cm_Return>

    Loop, 5
    {
        ControlGetText, new_pwd_left, %TCPathPanel%, AHK_CLASS TTOTAL_CMD
        ControlGetText, new_pwd_right, %TCPathPanelRight%, AHK_CLASS TTOTAL_CMD

        if (old_pwd_left != new_pwd_left || old_pwd_right != new_pwd_right)
        {
            GoSub, <cm_GoToFirstEntry>
            return
        }

        Sleep, 10
    }
return

;<TC_FileCopyForBak>: >>将当前光标下的文件复制一份作为作为备份
<TC_FileCopyForBak>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    filecopy, %Clipboard%, %Clipboard%.bak
Return

;<TC_FileMoveForBak>: >>将当前光标下的文件重命名为备份
<TC_FileMoveForBak>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext

    if (Clipboard <> dir . "\")
        FileMove, %Clipboard%, %Clipboard%.bak
    else
        FileMoveDir, %dir%, %dir%.bak
Return

;<TC_MultiFilePersistOpen>: >>多个文件一次性连续打开
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

;<TC_CopyFileContents>: >>不打开文件就复制文件内容
<TC_CopyFileContents>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    fileread, Contents, %Clipboard%
    Clipboard :=
    Clipboard = %Contents%
Return

;<TC_OpenDirAndPaste>: >>不打开目录，直接把复制的文件贴进去
<TC_OpenDirAndPaste>:
    SendPos(1001)
    SendPos(2009)
    SendPos(2002)
Return

;<TC_MoveSelectedFilesToPrevFolder>: >>将当前文件夹下的选定文件移动到上层目录中
<TC_MoveSelectedFilesToPrevFolder>:
    Send ^x
    SendPos(2002)
    Send ^v
Return

;<TC_MoveAllFilesToPrevFolder>: >>将当前文件夹下的全部文件移动到上层目录中
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

;<TC_SrcQuickViewAndTab>: >>预览文件时,光标自动移到对侧窗口里
<TC_SrcQuickViewAndTab>:
    SendPos(304)
    Send, {Tab}
    Send, {Shift}
Return

;<TC_CreateFileShortcut>: >>创建当前光标下文件的快捷方式
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

;<TC_CreateFileShortcutToDesktop>: >>创建当前光标下文件的快捷方式并发送到桌面
<TC_CreateFileShortcutToDesktop>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext
    ExtLen := StrLen(ext)
    if %ExtLen% != 0
        FileCreateShortcut, %Clipboard%, %dir%\%name_no_ext%.lnk
        FileMove, %dir%\%name_no_ext%.lnk, %USERPROFILE%\desktop\

        ; 如果不想打开桌面目录的话，注释以下4行

        if (TC64bit)
        {
            FixTCEditId()
        }

        ControlSetText, %TCEdit%, cd %USERPROFILE%\desktop\, ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {enter}, ahk_class TTOTAL_CMD
        ControlGetFocus, Ctrl, AHK_CLASS TTOTAL_CMD
        Postmessage, 0x19E, 1, 1, %Ctrl%, AHK_CLASS TTOTAL_CMD
Return

;<TC_CreateFileShortcutToStartup>: >>创建当前光标下文件的快捷方式并发送到启动文件里
<TC_CreateFileShortcutToStartup>:
    Clipboard :=
    SendPos(2018)
    ClipWait
    SplitPath, Clipboard, name, dir, ext, name_no_ext
    ExtLen := StrLen(ext)
    if %ExtLen% != 0
        ; MsgBox, %Clipboard%
        FileCreateShortcut, %Clipboard%, %dir%\%name_no_ext%.lnk
        FileMove, %dir%\%name_no_ext%.lnk, %appdata%\Microsoft\Windows\Start Menu\Programs\Startup\

        if (TC64bit)
        {
            FixTCEditId()
        }

        ; 如果不想打开启动目录的话，注释以下4行
        ControlSetText, %TCEdit%, cd %appdata%\Microsoft\Windows\Start Menu\Programs\Startup\, ahk_class TTOTAL_CMD
        ControlSend, %TCEdit%, {enter}, ahk_class TTOTAL_CMD
        ControlGetFocus, Ctrl, AHK_CLASS TTOTAL_CMD
        Postmessage, 0x19E, 1, 1, %Ctrl%, AHK_CLASS TTOTAL_CMD
Return

;<TC_FilterSearchFNsuffix_exe>: >>在当前目录里快速过滤exe扩展名的文件
<TC_FilterSearchFNsuffix_exe>:
    SendPos(2915)
    Send, *.exe
    Send, {ESC}
Return

;<TC_TwoFileExchangeName>: >>两个文件互换文件名
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

TC_OpenPath(Path, InNewTab := true, LeftOrRight := "")
{
    if (LeftOrRight = "")
    {
        LeftOrRight := "/R"
        if Mod(LeftRight(), 2)
        {
            LeftOrRight := "/L"
        }
    }

    if (InNewTab)
    {
        Run, "%TCPath%" /O /T /A "%LeftOrRight%"="%Path%"
    }
    else
    {
        Run, "%TCPath%" /O /A "%LeftOrRight%"="%Path%"
    }
}

<TC_MarkFile>:
    GoSub, <cm_EditComment>
    ; 将备注设置为 m，可以通过将备注为 m 的文件显示成不同颜色，实现标记功能
    ; 不要在已有备注的文件使用
    Send, ^+{end}m{f2}
return

<TC_UnMarkFile>:
    GoSub, <cm_EditComment>
    ; 删除 TC_MarkFile 的文件标记，也可用于清空文件备注
    Send, ^+{end}{del}{f2}
return

<TC_SelectCmd>:
    OldClipboard := Clipboard

    GoSub, <cm_CommandBrowser>
    sleep 100
    WinWaitClose, AHK_CLASS TCmdSelForm
    if (IsLabel("<" Clipboard ">") && Clipboard <> OldClipboard)
    {
        GoSub, <%Clipboard%>
    }
    OldClipboard =
return

<TC_ClearTitle>:
    TC_SetTitle("", false)
return

; 自动设置的话显示效果滞后
TC_SetTitle(Title := "", KeepVersion := true)
{
    if (KeepVersion)
    {
        WinGetTitle, OldTitle, ahk_class TTOTAL_CMD
        StringMid, NewTitle, OldTitle, 1, 21  ;保留TC的版本号信息
        WinSetTitle, ahk_class TTOTAL_CMD, , %NewTitle% - %Title%
    }
    else
    {
        WinSetTitle, ahk_class TTOTAL_CMD, , %Title%
    }
}

<TC_ReOpenTab>:
    GoSub, <cm_OpenNewTab>
    GoSub, <cm_GotoPreviousDir>
return

<TC_OpenDirsInFile>:
    OldClipboard := Clipboard
    Clipboard := ""
    GoSub, <cm_CopyFullNamesToClip>
    ClipWait
    FileRead, Contents, %Clipboard%
    Clipboard := OldClipboard
    OldClipboard =
    Loop, Parse, Contents, `n, `r
    {
        if FileExist(A_LoopField)
        {
            TC_OpenPath(A_LoopField, true)
            Sleep, 100
        }
    }
return

<TC_CreateBlankFile>:
    NewFile("创建空文件", True)
return

<TC_CreateBlankFileNoExt>:
    NewFile("创建空文件", True, "")
return

TC_Run(cmd)
{
    if (TC64bit)
    {
        FixTCEditId()
    }

    ControlSetText, %TCEdit%, %cmd%, ahk_class TTOTAL_CMD
    ControlSend, %TCEdit%, {Enter}, ahk_class TTOTAL_CMD
}

; 粘贴文件，如果光标下为目录则粘贴进该目录
<TC_PasteFileEx>:
    OldClipboard := ClipboardAll
    Clipboard =
    SendPos(524)   ;cm_ClearAll
    SendPos(2018)  ;cm_CopyFullNamesToClip
    ClipWait
    TempClip := Clipboard
    If (SubStr(TempClip, 0) == "\")
    {
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
    GoSub, <cm_SrcThumbs>

    GoSub, <TC_ThumbsViewSwitchKey>
return

<TC_ThumbsViewSwitchKey>:
    InThumbsView := !(InThumbsView)
    if (InThumbsView) {
        vim.map("h", "<left>", "TTOTAL_CMD")
        vim.map("l", "<right>", "TTOTAL_CMD")
    } else {
        vim.map("h", "<TC_GoToParentEx>", "TTOTAL_CMD")
        vim.map("l", "<TC_SuperReturn>", "TTOTAL_CMD")
    }
return

FixTCEditId()
{
    ControlGetText, Result, Edit2, ahk_class TTOTAL_CMD
    if (ErrorLevel)
    {
        TCEdit := "Edit1"
    }
    else
    {
        TCEdit := "Edit2"
    }
}

<TC_Restart>:
    WinClose, AHK_CLASS TTOTAL_CMD

    Loop, 4
    {
        Sleep, 100
        Run, %TCPath%
        Sleep, 50
        IfWinNotActive, AHK_CLASS TTOTAL_CMD
            WinActivate, AHK_CLASS TTOTAL_CMD
        else
            Break
    }
return


; ADD HERE



; TC自带命令 {{{1
;==================================================
;=======使用VIM下的VOom 插件可以很方便的查看=======
;==================================================
TCCOMMAND:
    vim.Comment("<cm_SrcComments>", "来源窗口: 显示文件备注")
    vim.Comment("<cm_SrcShort>", "来源窗口: 列表")
    vim.Comment("<cm_SrcLong>", "来源窗口: 详细信息")
    vim.Comment("<cm_SrcTree>", "来源窗口: 文件夹树")
    vim.Comment("<cm_SrcQuickview>", "来源窗口: 快速查看")
    vim.Comment("<cm_VerticalPanels>", "纵向/横向排列")
    vim.Comment("<cm_SrcQuickInternalOnly>", "来源窗口: 快速查看(不用插件)")
    vim.Comment("<cm_SrcHideQuickview>", "来源窗口: 关闭快速查看窗口")
    vim.Comment("<cm_SrcExecs>", "来源窗口: 可执行文件")
    vim.Comment("<cm_SrcAllFiles>", "来源窗口: 所有文件")
    vim.Comment("<cm_SrcUserSpec>", "来源窗口: 上次选中的文件")
    vim.Comment("<cm_SrcUserDef>", "来源窗口: 自定义类型")
    vim.Comment("<cm_SrcByName>", "来源窗口: 按文件名排序")
    vim.Comment("<cm_SrcByExt>", "来源窗口: 按扩展名排序")
    vim.Comment("<cm_SrcBySize>", "来源窗口: 按大小排序")
    vim.Comment("<cm_SrcByDateTime>", "来源窗口: 按日期时间排序")
    vim.Comment("<cm_SrcUnsorted>", "来源窗口: 不排序")
    vim.Comment("<cm_SrcNegOrder>", "来源窗口: 反向排序")
    vim.Comment("<cm_SrcOpenDrives>", "来源窗口: 打开驱动器列表")
    vim.Comment("<cm_SrcThumbs>", "来源窗口: 缩略图")
    vim.Comment("<cm_SrcCustomViewMenu>", "来源窗口: 自定义视图菜单")
    vim.Comment("<cm_SrcPathFocus>", "来源窗口: 焦点置于路径上")
    vim.Comment("<cm_LeftComments>", "左窗口: 显示文件备注")
    vim.Comment("<cm_LeftShort>", "左窗口: 列表")
    vim.Comment("<cm_LeftLong>", "左窗口: 详细信息")
    vim.Comment("<cm_LeftTree>", "左窗口: 文件夹树")
    vim.Comment("<cm_LeftQuickview>", "左窗口: 快速查看")
    vim.Comment("<cm_LeftQuickInternalOnly>", "左窗口: 快速查看(不用插件)")
    vim.Comment("<cm_LeftHideQuickview>", "左窗口: 关闭快速查看窗口")
    vim.Comment("<cm_LeftExecs>", "左窗口: 可执行文件")
    vim.Comment("<cm_LeftAllFiles>", "左窗口: 所有文件")
    vim.Comment("<cm_LeftUserSpec>", "左窗口: 上次选中的文件")
    vim.Comment("<cm_LeftUserDef>", "左窗口: 自定义类型")
    vim.Comment("<cm_LeftByName>", "左窗口: 按文件名排序")
    vim.Comment("<cm_LeftByExt>", "左窗口: 按扩展名排序")
    vim.Comment("<cm_LeftBySize>", "左窗口: 按大小排序")
    vim.Comment("<cm_LeftByDateTime>", "左窗口: 按日期时间排序")
    vim.Comment("<cm_LeftUnsorted>", "左窗口: 不排序")
    vim.Comment("<cm_LeftNegOrder>", "左窗口: 反向排序")
    vim.Comment("<cm_LeftOpenDrives>", "左窗口: 打开驱动器列表")
    vim.Comment("<cm_LeftPathFocus>", "左窗口: 焦点置于路径上")
    vim.Comment("<cm_LeftDirBranch>", "左窗口: 展开所有文件夹")
    vim.Comment("<cm_LeftDirBranchSel>", "左窗口: 只展开选中的文件夹")
    vim.Comment("<cm_LeftThumbs>", "窗口: 缩略图")
    vim.Comment("<cm_LeftCustomViewMenu>", "窗口: 自定义视图菜单")
    vim.Comment("<cm_RightComments>", "右窗口: 显示文件备注")
    vim.Comment("<cm_RightShort>", "右窗口: 列表")
    vim.Comment("<cm_RightLong>", "详细信息")
    vim.Comment("<cm_RightTree>", "右窗口: 文件夹树")
    vim.Comment("<cm_RightQuickvie>", "右窗口: 快速查看")
    vim.Comment("<cm_RightQuickInternalOnl>", "右窗口: 快速查看(不用插件)")
    vim.Comment("<cm_RightHideQuickvie>", "右窗口: 关闭快速查看窗口")
    vim.Comment("<cm_RightExec>", "右窗口: 可执行文件")
    vim.Comment("<cm_RightAllFile>", "右窗口: 所有文件")
    vim.Comment("<cm_RightUserSpe>", "右窗口: 上次选中的文件")
    vim.Comment("<cm_RightUserDe>", "右窗口: 自定义类型")
    vim.Comment("<cm_RightByNam>", "右窗口: 按文件名排序")
    vim.Comment("<cm_RightByEx>", "右窗口: 按扩展名排序")
    vim.Comment("<cm_RightBySiz>", "右窗口: 按大小排序")
    vim.Comment("<cm_RightByDateTim>", "右窗口: 按日期时间排序")
    vim.Comment("<cm_RightUnsorte>", "右窗口: 不排序")
    vim.Comment("<cm_RightNegOrde>", "右窗口: 反向排序")
    vim.Comment("<cm_RightOpenDrives>", "右窗口: 打开驱动器列表")
    vim.Comment("<cm_RightPathFocu>", "右窗口: 焦点置于路径上")
    vim.Comment("<cm_RightDirBranch>", "右窗口: 展开所有文件夹")
    vim.Comment("<cm_RightDirBranchSel>", "右窗口: 只展开选中的文件夹")
    vim.Comment("<cm_RightThumb>", "右窗口: 缩略图")
    vim.Comment("<cm_RightCustomViewMen>", "右窗口: 自定义视图菜单")
    vim.Comment("<cm_List>", "查看(用查看程序)")
    vim.Comment("<cm_ListInternalOnly>", "查看(用查看程序, 但不用插件/多媒体)")
    vim.Comment("<cm_Edit>", "编辑")
    vim.Comment("<cm_Copy>", "复制")
    vim.Comment("<cm_CopySamepanel>", "复制到当前窗口")
    vim.Comment("<cm_CopyOtherpanel>", "复制到另一窗口(F5)")
    vim.Comment("<cm_RenMov>", "重命名/移动")
    vim.Comment("<cm_MkDir>", "新建文件夹")
    vim.Comment("<cm_Delete>", "删除")
    vim.Comment("<cm_TestArchive>", "测试压缩包")
    vim.Comment("<cm_PackFiles>", "压缩文件")
    vim.Comment("<cm_UnpackFiles>", "解压文件")
    vim.Comment("<cm_RenameOnly>", "重命名(Shift+F6)")
    vim.Comment("<cm_RenameSingleFile>", "重命名当前文件")
    vim.Comment("<cm_MoveOnly>", "移动到另一个窗口(F6)")
    vim.Comment("<cm_Properties>", "显示属性")
    vim.Comment("<cm_CreateShortcut>", "创建快捷方式")
    vim.Comment("<cm_Return>", "模仿按 ENTER 键")
    vim.Comment("<cm_OpenAsUser>", "以其他用户身份运行光标处的程序")
    vim.Comment("<cm_Split>", "分割文件")
    vim.Comment("<cm_Combine>", "合并文件")
    vim.Comment("<cm_Encode>", "编码文件(MIME/UUE/XXE 格式)")
    vim.Comment("<cm_Decode>", "解码文件(MIME/UUE/XXE/BinHex 格式)")
    vim.Comment("<cm_CRCcreate>", "创建校验文件")
    vim.Comment("<cm_CRCcheck>", "验证校验和")
    vim.Comment("<cm_SetAttrib>", "更改属性")
    vim.Comment("<cm_Config>", "配置: 布局")
    vim.Comment("<cm_DisplayConfig>", "配置: 显示")
    vim.Comment("<cm_IconConfig>", "配置: 图标")
    vim.Comment("<cm_FontConfig>", "配置: 字体")
    vim.Comment("<cm_ColorConfig>", "配置: 颜色")
    vim.Comment("<cm_ConfTabChange>", "配置: 制表符")
    vim.Comment("<cm_DirTabsConfig>", "配置: 文件夹标签")
    vim.Comment("<cm_CustomColumnConfig>", "配置: 自定义列")
    vim.Comment("<cm_CustomColumnDlg>", "更改当前自定义列")
    vim.Comment("<cm_LanguageConfig>", "配置: 语言")
    vim.Comment("<cm_Config2>", "配置: 操作方式")
    vim.Comment("<cm_EditConfig>", "配置: 编辑/查看")
    vim.Comment("<cm_CopyConfig>", "配置: 复制/删除")
    vim.Comment("<cm_RefreshConfig>", "配置: 刷新")
    vim.Comment("<cm_QuickSearchConfig>", "配置: 快速搜索")
    vim.Comment("<cm_FtpConfig>", "配置: FTP")
    vim.Comment("<cm_PluginsConfig>", "配置: 插件")
    vim.Comment("<cm_ThumbnailsConfig>", "配置: 缩略图")
    vim.Comment("<cm_LogConfig>", "配置: 日志文件")
    vim.Comment("<cm_IgnoreConfig>", "配置: 隐藏文件")
    vim.Comment("<cm_PackerConfig>", "配置: 压缩程序")
    vim.Comment("<cm_ZipPackerConfig>", "配置: ZIP 压缩程序")
    vim.Comment("<cm_Confirmation>", "配置: 其他/确认")
    vim.Comment("<cm_ConfigSavePos>", "保存位置")
    vim.Comment("<cm_ButtonConfig>", "更改工具栏")
    vim.Comment("<cm_ConfigSaveSettings>", "保存设置")
    vim.Comment("<cm_ConfigChangeIniFiles>", "直接修改配置文件")
    vim.Comment("<cm_ConfigSaveDirHistory>", "保存文件夹历史记录")
    vim.Comment("<cm_ChangeStartMenu>", "更改开始菜单")
    vim.Comment("<cm_NetConnect>", "映射网络驱动器")
    vim.Comment("<cm_NetDisconnect>", "断开网络驱动器")
    vim.Comment("<cm_NetShareDir>", "共享当前文件夹")
    vim.Comment("<cm_NetUnshareDir>", "取消文件夹共享")
    vim.Comment("<cm_AdministerServer>", "显示系统共享文件夹")
    vim.Comment("<cm_ShowFileUser>", "显示本地文件的远程用户")
    vim.Comment("<cm_GetFileSpace>", "计算占用空间")
    vim.Comment("<cm_VolumeId>", "设置卷标")
    vim.Comment("<cm_VersionInfo>", "版本信息")
    vim.Comment("<cm_ExecuteDOS>", "打开命令提示符窗口")
    vim.Comment("<cm_CompareDirs>", "比较文件夹")
    vim.Comment("<cm_CompareDirsWithSubdirs>", "比较文件夹(同时标出另一窗口没有的子文件夹)")
    vim.Comment("<cm_ContextMenu>", "显示快捷菜单")
    vim.Comment("<cm_ContextMenuInternal>", "显示快捷菜单(内部关联)")
    vim.Comment("<cm_ContextMenuInternalCursor>", "显示光标处文件的内部关联快捷菜单")
    vim.Comment("<cm_ShowRemoteMenu>", "媒体中心遥控器播放/暂停键快捷菜单")
    vim.Comment("<cm_SyncChangeDir>", "两边窗口同步更改文件夹")
    vim.Comment("<cm_EditComment>", "编辑文件备注")
    vim.Comment("<cm_FocusLeft>", "焦点置于左窗口")
    vim.Comment("<cm_FocusRight>", "焦点置于右窗口")
    vim.Comment("<cm_FocusCmdLine>", "焦点置于命令行")
    vim.Comment("<cm_FocusButtonBar>", "焦点置于工具栏")
    vim.Comment("<cm_CountDirContent>", "计算所有文件夹占用的空间")
    vim.Comment("<cm_UnloadPlugins>", "卸载所有插件")
    vim.Comment("<cm_DirMatch>", "标出新文件, 隐藏相同者")
    vim.Comment("<cm_Exchange>", "交换左右窗口")
    vim.Comment("<cm_MatchSrc>", "目标 = 来源")
    vim.Comment("<cm_ReloadSelThumbs>", "刷新选中文件的缩略图")
    vim.Comment("<cm_DirectCableConnect>", "直接电缆连接")
    vim.Comment("<cm_NTinstallDriver>", "加载 NT 并口驱动程序")
    vim.Comment("<cm_NTremoveDriver>", "卸载 NT 并口驱动程序")
    vim.Comment("<cm_PrintDir>", "打印文件列表")
    vim.Comment("<cm_PrintDirSub>", "打印文件列表(含子文件夹)")
    vim.Comment("<cm_PrintFile>", "打印文件内容")
    vim.Comment("<cm_SpreadSelection>", "选择一组文件")
    vim.Comment("<cm_SelectBoth>", "选择一组: 文件和文件夹")
    vim.Comment("<cm_SelectFiles>", "选择一组: 仅文件")
    vim.Comment("<cm_SelectFolders>", "选择一组: 仅文件夹")
    vim.Comment("<cm_ShrinkSelection>", "不选一组文件")
    vim.Comment("<cm_ClearFiles>", "不选一组: 仅文件")
    vim.Comment("<cm_ClearFolders>", "不选一组: 仅文件夹")
    vim.Comment("<cm_ClearSelCfg>", "不选一组: 文件和/或文件夹(视配置而定)")
    vim.Comment("<cm_SelectAll>", "全部选择: 文件和/或文件夹(视配置而定)")
    vim.Comment("<cm_SelectAllBoth>", "全部选择: 文件和文件夹")
    vim.Comment("<cm_SelectAllFiles>", "全部选择: 仅文件")
    vim.Comment("<cm_SelectAllFolders>", "全部选择: 仅文件夹")
    vim.Comment("<cm_ClearAll>", "全部取消: 文件和文件夹")
    vim.Comment("<cm_ClearAllFiles>", "全部取消: 仅文件")
    vim.Comment("<cm_ClearAllFolders>", "全部取消: 仅文件夹")
    vim.Comment("<cm_ClearAllCfg>", "全部取消: 文件和/或文件夹(视配置而定)")
    vim.Comment("<cm_ExchangeSelection>", "反向选择")
    vim.Comment("<cm_ExchangeSelBoth>", "反向选择: 文件和文件夹")
    vim.Comment("<cm_ExchangeSelFiles>", "反向选择: 仅文件")
    vim.Comment("<cm_ExchangeSelFolders>", "反向选择: 仅文件夹")
    vim.Comment("<cm_SelectCurrentExtension>", "选择扩展名相同的文件")
    vim.Comment("<cm_UnselectCurrentExtension>", "不选扩展名相同的文件")
    vim.Comment("<cm_SelectCurrentName>", "选择文件名相同的文件")
    vim.Comment("<cm_UnselectCurrentName>", "不选文件名相同的文件")
    vim.Comment("<cm_SelectCurrentNameExt>", "选择文件名和扩展名相同的文件")
    vim.Comment("<cm_UnselectCurrentNameExt>", "不选文件名和扩展名相同的文件")
    vim.Comment("<cm_SelectCurrentPath>", "选择同一路径下的文件(展开文件夹+搜索文件)")
    vim.Comment("<cm_UnselectCurrentPath>", "不选同一路径下的文件(展开文件夹+搜索文件)")
    vim.Comment("<cm_RestoreSelection>", "恢复选择列表")
    vim.Comment("<cm_SaveSelection>", "保存选择列表")
    vim.Comment("<cm_SaveSelectionToFile>", "导出选择列表")
    vim.Comment("<cm_SaveSelectionToFileA>", "导出选择列表(ANSI)")
    vim.Comment("<cm_SaveSelectionToFileW>", "导出选择列表(Unicode)")
    vim.Comment("<cm_SaveDetailsToFile>", "导出详细信息")
    vim.Comment("<cm_SaveDetailsToFileA>", "导出详细信息(ANSI)")
    vim.Comment("<cm_SaveDetailsToFileW>", "导出详细信息(Unicode)")
    vim.Comment("<cm_LoadSelectionFromFile>", "导入选择列表(从文件)")
    vim.Comment("<cm_LoadSelectionFromClip>", "导入选择列表(从剪贴板)")
    vim.Comment("<cm_EditPermissionInfo>", "设置权限(NTFS)")
    vim.Comment("<cm_EditAuditInfo>", "审核文件(NTFS)")
    vim.Comment("<cm_EditOwnerInfo>", "获取所有权(NTFS)")
    vim.Comment("<cm_CutToClipboard>", "剪切选中的文件到剪贴板")
    vim.Comment("<cm_CopyToClipboard>", "复制选中的文件到剪贴板")
    vim.Comment("<cm_PasteFromClipboard>", "从剪贴板粘贴到当前文件夹")
    vim.Comment("<cm_CopyNamesToClip>", "复制文件名")
    vim.Comment("<cm_CopyFullNamesToClip>", "复制文件名及完整路径")
    vim.Comment("<cm_CopyNetNamesToClip>", "复制文件名及网络路径")
    vim.Comment("<cm_CopySrcPathToClip>", "复制来源路径")
    vim.Comment("<cm_CopyTrgPathToClip>", "复制目标路径")
    vim.Comment("<cm_CopyFileDetailsToClip>", "复制文件详细信息")
    vim.Comment("<cm_CopyFpFileDetailsToClip>", "复制文件详细信息及完整路径")
    vim.Comment("<cm_CopyNetFileDetailsToClip>", "复制文件详细信息及网络路径")
    vim.Comment("<cm_FtpConnect>", "FTP 连接")
    vim.Comment("<cm_FtpNew>", "新建 FTP 连接")
    vim.Comment("<cm_FtpDisconnect>", "断开 FTP 连接")
    vim.Comment("<cm_FtpHiddenFiles>", "显示隐藏文件")
    vim.Comment("<cm_FtpAbort>", "中止当前 FTP 命令")
    vim.Comment("<cm_FtpResumeDownload>", "续传")
    vim.Comment("<cm_FtpSelectTransferMode>", "选择传输模式")
    vim.Comment("<cm_FtpAddToList>", "添加到下载列表")
    vim.Comment("<cm_FtpDownloadList>", "按列表下载")
    vim.Comment("<cm_GotoPreviousDir>", "后退")
    vim.Comment("<cm_GotoNextDir>", "前进")
    vim.Comment("<cm_DirectoryHistory>", "文件夹历史记录")
    vim.Comment("<cm_GotoPreviousLocalDir>", "后退(非 FTP)")
    vim.Comment("<cm_GotoNextLocalDir>", "前进(非 FTP)")
    vim.Comment("<cm_DirectoryHotlist>", "常用文件夹")
    vim.Comment("<cm_GoToRoot>", "转到根文件夹")
    vim.Comment("<cm_GoToParent>", "转到上层文件夹")
    vim.Comment("<cm_GoToDir>", "打开光标处的文件夹或压缩包")
    vim.Comment("<cm_OpenDesktop>", "桌面")
    vim.Comment("<cm_OpenDrives>", "我的电脑")
    vim.Comment("<cm_OpenControls>", "控制面板")
    vim.Comment("<cm_OpenFonts>", "字体")
    vim.Comment("<cm_OpenNetwork>", "网上邻居")
    vim.Comment("<cm_OpenPrinters>", "打印机")
    vim.Comment("<cm_OpenRecycled>", "回收站")
    vim.Comment("<cm_CDtree>", "更改文件夹")
    vim.Comment("<cm_TransferLeft>", "在左窗口打开光标处的文件夹或压缩包")
    vim.Comment("<cm_TransferRight>", "在右窗口打开光标处的文件夹或压缩包")
    vim.Comment("<cm_EditPath>", "编辑来源窗口的路径")
    vim.Comment("<cm_GoToFirstFile>", "光标移到列表中的第一个文件")
    vim.Comment("<cm_GoToFirstEntry>", "光标移到列表中的第一个文件或目录")
    vim.Comment("<cm_GotoNextDrive>", "转到下一个驱动器")
    vim.Comment("<cm_GotoPreviousDrive>", "转到上一个驱动器")
    vim.Comment("<cm_GotoNextSelected>", "转到下一个选中的文件")
    vim.Comment("<cm_GotoPrevSelected>", "转到上一个选中的文件")
    vim.Comment("<cm_GotoDriveA>", "转到驱动器 A")
    vim.Comment("<cm_GotoDriveC>", "转到驱动器 C")
    vim.Comment("<cm_GotoDriveD>", "转到驱动器 D")
    vim.Comment("<cm_GotoDriveE>", "转到驱动器 E")
    vim.Comment("<cm_GotoDriveF>", "可自定义其他驱动器")
    vim.Comment("<cm_GotoDriveZ>", "最多 26 个")
    vim.Comment("<cm_HelpIndex>", "帮助索引")
    vim.Comment("<cm_Keyboard>", "快捷键列表")
    vim.Comment("<cm_Register>", "注册信息")
    vim.Comment("<cm_VisitHomepage>", "访问 Totalcmd 网站")
    vim.Comment("<cm_About>", "关于 Total Commander")
    vim.Comment("<cm_Exit>", "退出 Total Commander")
    vim.Comment("<cm_Minimize>", "最小化 Total Commander")
    vim.Comment("<cm_Maximize>", "最大化 Total Commander")
    vim.Comment("<cm_Restore>", "恢复正常大小")
    vim.Comment("<cm_ClearCmdLine>", "清除命令行")
    vim.Comment("<cm_NextCommand>", "下一条命令")
    vim.Comment("<cm_PrevCommand>", "上一条命令")
    vim.Comment("<cm_AddPathToCmdline>", "将路径复制到命令行")
    vim.Comment("<cm_MultiRenameFiles>", "批量重命名")
    vim.Comment("<cm_SysInfo>", "系统信息")
    vim.Comment("<cm_OpenTransferManager>", "后台传输管理器")
    vim.Comment("<cm_SearchFor>", "搜索文件")
    vim.Comment("<cm_SearchStandalone>", "在单独进程搜索文件")
    vim.Comment("<cm_FileSync>", "同步文件夹")
    vim.Comment("<cm_Associate>", "文件关联")
    vim.Comment("<cm_InternalAssociate>", "定义内部关联")
    vim.Comment("<cm_CompareFilesByContent>", "比较文件内容")
    vim.Comment("<cm_IntCompareFilesByContent>", "使用内部比较程序")
    vim.Comment("<cm_CommandBrowser>", "浏览内部命令")
    vim.Comment("<cm_VisButtonbar>", "显示/隐藏: 工具栏")
    vim.Comment("<cm_VisDriveButtons>", "显示/隐藏: 驱动器按钮")
    vim.Comment("<cm_VisTwoDriveButtons>", "显示/隐藏: 两个驱动器按钮栏")
    vim.Comment("<cm_VisFlatDriveButtons>", "切换: 平坦/立体驱动器按钮")
    vim.Comment("<cm_VisFlatInterface>", "切换: 平坦/立体用户界面")
    vim.Comment("<cm_VisDriveCombo>", "显示/隐藏: 驱动器列表")
    vim.Comment("<cm_VisCurDir>", "显示/隐藏: 当前文件夹")
    vim.Comment("<cm_VisBreadCrumbs>", "显示/隐藏: 路径导航栏")
    vim.Comment("<cm_VisTabHeader>", "显示/隐藏: 排序制表符")
    vim.Comment("<cm_VisStatusbar>", "显示/隐藏: 状态栏")
    vim.Comment("<cm_VisCmdLine>", "显示/隐藏: 命令行")
    vim.Comment("<cm_VisKeyButtons>", "显示/隐藏: 功能键按钮")
    vim.Comment("<cm_ShowHint>", "显示文件提示")
    vim.Comment("<cm_ShowQuickSearch>", "显示快速搜索窗口")
    vim.Comment("<cm_SwitchLongNames>", "开启/关闭: 长文件名显示")
    vim.Comment("<cm_RereadSource>", "刷新来源窗口")
    vim.Comment("<cm_ShowOnlySelected>", "仅显示选中的文件")
    vim.Comment("<cm_SwitchHidSys>", "开启/关闭: 隐藏或系统文件显示")
    vim.Comment("<cm_Switch83Names>", "开启/关闭: 8.3 式文件名小写显示")
    vim.Comment("<cm_SwitchDirSort>", "开启/关闭: 文件夹按名称排序")
    vim.Comment("<cm_DirBranch>", "展开所有文件夹")
    vim.Comment("<cm_DirBranchSel>", "只展开选中的文件夹")
    vim.Comment("<cm_50Percent>", "窗口分隔栏位于 50%")
    vim.Comment("<cm_100Percent>", "窗口分隔栏位于 100% TC 8.0+")
    vim.Comment("<cm_VisDirTabs>", "显示/隐藏: 文件夹标签")
    vim.Comment("<cm_VisXPThemeBackground>", "显示/隐藏: XP 主题背景")
    vim.Comment("<cm_SwitchOverlayIcons>", "开启/关闭: 叠置图标显示")
    vim.Comment("<cm_VisHistHotButtons>", "显示/隐藏: 文件夹历史记录和常用文件夹按钮")
    vim.Comment("<cm_SwitchWatchDirs>", "启用/禁用: 文件夹自动刷新")
    vim.Comment("<cm_SwitchIgnoreList>", "启用/禁用: 自定义隐藏文件")
    vim.Comment("<cm_SwitchX64Redirection>", "开启/关闭: 32 位 system32 目录重定向(64 位 Windows)")
    vim.Comment("<cm_SeparateTreeOff>", "关闭独立文件夹树面板")
    vim.Comment("<cm_SeparateTree1>", "一个独立文件夹树面板")
    vim.Comment("<cm_SeparateTree2>", "两个独立文件夹树面板")
    vim.Comment("<cm_SwitchSeparateTree>", "切换独立文件夹树面板状态")
    vim.Comment("<cm_ToggleSeparateTree1>", "开启/关闭: 一个独立文件夹树面板")
    vim.Comment("<cm_ToggleSeparateTree2>", "开启/关闭: 两个独立文件夹树面板")
    vim.Comment("<cm_UserMenu1>", "用户菜单 1")
    vim.Comment("<cm_UserMenu2>", "用户菜单 2")
    vim.Comment("<cm_UserMenu3>", "用户菜单 3")
    vim.Comment("<cm_UserMenu4>", "用户菜单 4")
    vim.Comment("<cm_UserMenu5>", "用户菜单 5")
    vim.Comment("<cm_UserMenu6>", "用户菜单 6")
    vim.Comment("<cm_UserMenu7>", "用户菜单 7")
    vim.Comment("<cm_UserMenu8>", "用户菜单 8")
    vim.Comment("<cm_UserMenu9>", "用户菜单 9")
    vim.Comment("<cm_UserMenu10>", "可定义其他用户菜单")
    vim.Comment("<cm_OpenNewTab>", "新建标签")
    vim.Comment("<cm_OpenNewTabBg>", "新建标签(在后台)")
    vim.Comment("<cm_OpenDirInNewTab>", "新建标签(并打开光标处的文件夹)")
    vim.Comment("<cm_OpenDirInNewTabOther>", "新建标签(在另一窗口打开文件夹)")
    vim.Comment("<cm_SwitchToNextTab>", "下一个标签(Ctrl+Tab)")
    vim.Comment("<cm_SwitchToPreviousTab>", "上一个标签(Ctrl+Shift+Tab)")
    vim.Comment("<cm_CloseCurrentTab>", "关闭当前标签")
    vim.Comment("<cm_CloseAllTabs>", "关闭所有标签")
    vim.Comment("<cm_DirTabsShowMenu>", "显示标签菜单")
    vim.Comment("<cm_ToggleLockCurrentTab>", "锁定/解锁当前标签")
    vim.Comment("<cm_ToggleLockDcaCurrentTab>", "锁定/解锁当前标签(可更改文件夹)")
    vim.Comment("<cm_ExchangeWithTabs>", "交换左右窗口及其标签")
    vim.Comment("<cm_GoToLockedDir>", "转到锁定标签的根文件夹")
    vim.Comment("<cm_SrcActivateTab1>", "来源窗口: 激活标签 1")
    vim.Comment("<cm_SrcActivateTab2>", "来源窗口: 激活标签 2")
    vim.Comment("<cm_SrcActivateTab3>", "来源窗口: 激活标签 3")
    vim.Comment("<cm_SrcActivateTab4>", "来源窗口: 激活标签 4")
    vim.Comment("<cm_SrcActivateTab5>", "来源窗口: 激活标签 5")
    vim.Comment("<cm_SrcActivateTab6>", "来源窗口: 激活标签 6")
    vim.Comment("<cm_SrcActivateTab7>", "来源窗口: 激活标签 7")
    vim.Comment("<cm_SrcActivateTab8>", "来源窗口: 激活标签 8")
    vim.Comment("<cm_SrcActivateTab9>", "来源窗口: 激活标签 9")
    vim.Comment("<cm_SrcActivateTab10>", "来源窗口: 激活标签 10")
    vim.Comment("<cm_TrgActivateTab1>", "目标窗口: 激活标签 1")
    vim.Comment("<cm_TrgActivateTab2>", "目标窗口: 激活标签 2")
    vim.Comment("<cm_TrgActivateTab3>", "目标窗口: 激活标签 3")
    vim.Comment("<cm_TrgActivateTab4>", "目标窗口: 激活标签 4")
    vim.Comment("<cm_TrgActivateTab5>", "目标窗口: 激活标签 5")
    vim.Comment("<cm_TrgActivateTab6>", "目标窗口: 激活标签 6")
    vim.Comment("<cm_TrgActivateTab7>", "目标窗口: 激活标签 7")
    vim.Comment("<cm_TrgActivateTab8>", "目标窗口: 激活标签 8")
    vim.Comment("<cm_TrgActivateTab9>", "目标窗口: 激活标签 9")
    vim.Comment("<cm_TrgActivateTab10>", "目标窗口: 激活标签 10")
    vim.Comment("<cm_LeftActivateTab1>", "左窗口: 激活标签 1")
    vim.Comment("<cm_LeftActivateTab2>", "左窗口: 激活标签 2")
    vim.Comment("<cm_LeftActivateTab3>", "左窗口: 激活标签 3")
    vim.Comment("<cm_LeftActivateTab4>", "左窗口: 激活标签 4")
    vim.Comment("<cm_LeftActivateTab5>", "左窗口: 激活标签 5")
    vim.Comment("<cm_LeftActivateTab6>", "左窗口: 激活标签 6")
    vim.Comment("<cm_LeftActivateTab7>", "左窗口: 激活标签 7")
    vim.Comment("<cm_LeftActivateTab8>", "左窗口: 激活标签 8")
    vim.Comment("<cm_LeftActivateTab9>", "左窗口: 激活标签 9")
    vim.Comment("<cm_LeftActivateTab10>", "左窗口: 激活标签 10")
    vim.Comment("<cm_RightActivateTab1>", "右窗口: 激活标签 1")
    vim.Comment("<cm_RightActivateTab2>", "右窗口: 激活标签 2")
    vim.Comment("<cm_RightActivateTab3>", "右窗口: 激活标签 3")
    vim.Comment("<cm_RightActivateTab4>", "右窗口: 激活标签 4")
    vim.Comment("<cm_RightActivateTab5>", "右窗口: 激活标签 5")
    vim.Comment("<cm_RightActivateTab6>", "右窗口: 激活标签 6")
    vim.Comment("<cm_RightActivateTab7>", "右窗口: 激活标签 7")
    vim.Comment("<cm_RightActivateTab8>", "右窗口: 激活标签 8")
    vim.Comment("<cm_RightActivateTab9>", "右窗口: 激活标签 9")
    vim.Comment("<cm_RightActivateTab10>", "右窗口: 激活标签 10")
    vim.Comment("<cm_SrcSortByCol1>", "来源窗口: 按第 1 列排序")
    vim.Comment("<cm_SrcSortByCol2>", "来源窗口: 按第 2 列排序")
    vim.Comment("<cm_SrcSortByCol3>", "来源窗口: 按第 3 列排序")
    vim.Comment("<cm_SrcSortByCol4>", "来源窗口: 按第 4 列排序")
    vim.Comment("<cm_SrcSortByCol5>", "来源窗口: 按第 5 列排序")
    vim.Comment("<cm_SrcSortByCol6>", "来源窗口: 按第 6 列排序")
    vim.Comment("<cm_SrcSortByCol7>", "来源窗口: 按第 7 列排序")
    vim.Comment("<cm_SrcSortByCol8>", "来源窗口: 按第 8 列排序")
    vim.Comment("<cm_SrcSortByCol9>", "来源窗口: 按第 9 列排序")
    vim.Comment("<cm_SrcSortByCol10>", "来源窗口: 按第 10 列排序")
    vim.Comment("<cm_TrgSortByCol1>", "目标窗口: 按第 1 列排序")
    vim.Comment("<cm_TrgSortByCol2>", "目标窗口: 按第 2 列排序")
    vim.Comment("<cm_TrgSortByCol3>", "目标窗口: 按第 3 列排序")
    vim.Comment("<cm_TrgSortByCol4>", "目标窗口: 按第 4 列排序")
    vim.Comment("<cm_TrgSortByCol5>", "目标窗口: 按第 5 列排序")
    vim.Comment("<cm_TrgSortByCol6>", "目标窗口: 按第 6 列排序")
    vim.Comment("<cm_TrgSortByCol7>", "目标窗口: 按第 7 列排序")
    vim.Comment("<cm_TrgSortByCol8>", "目标窗口: 按第 8 列排序")
    vim.Comment("<cm_TrgSortByCol9>", "目标窗口: 按第 9 列排序")
    vim.Comment("<cm_TrgSortByCol10>", "目标窗口: 按第 10 列排序")
    vim.Comment("<cm_LeftSortByCol1>", "左窗口: 按第 1 列排序")
    vim.Comment("<cm_LeftSortByCol2>", "左窗口: 按第 2 列排序")
    vim.Comment("<cm_LeftSortByCol3>", "左窗口: 按第 3 列排序")
    vim.Comment("<cm_LeftSortByCol4>", "左窗口: 按第 4 列排序")
    vim.Comment("<cm_LeftSortByCol5>", "左窗口: 按第 5 列排序")
    vim.Comment("<cm_LeftSortByCol6>", "左窗口: 按第 6 列排序")
    vim.Comment("<cm_LeftSortByCol7>", "左窗口: 按第 7 列排序")
    vim.Comment("<cm_LeftSortByCol8>", "左窗口: 按第 8 列排序")
    vim.Comment("<cm_LeftSortByCol9>", "左窗口: 按第 9 列排序")
    vim.Comment("<cm_LeftSortByCol10>", "左窗口: 按第 10 列排序")
    vim.Comment("<cm_RightSortByCol1>", "右窗口: 按第 1 列排序")
    vim.Comment("<cm_RightSortByCol2>", "右窗口: 按第 2 列排序")
    vim.Comment("<cm_RightSortByCol3>", "右窗口: 按第 3 列排序")
    vim.Comment("<cm_RightSortByCol4>", "右窗口: 按第 4 列排序")
    vim.Comment("<cm_RightSortByCol5>", "右窗口: 按第 5 列排序")
    vim.Comment("<cm_RightSortByCol6>", "右窗口: 按第 6 列排序")
    vim.Comment("<cm_RightSortByCol7>", "右窗口: 按第 7 列排序")
    vim.Comment("<cm_RightSortByCol8>", "右窗口: 按第 8 列排序")
    vim.Comment("<cm_RightSortByCol9>", "右窗口: 按第 9 列排序")
    vim.Comment("<cm_RightSortByCol10>", "右窗口: 按第 10 列排序")
    vim.Comment("<cm_SrcCustomView1>", "来源窗口: 自定义列视图 1")
    vim.Comment("<cm_SrcCustomView2>", "来源窗口: 自定义列视图 2")
    vim.Comment("<cm_SrcCustomView3>", "来源窗口: 自定义列视图 3")
    vim.Comment("<cm_SrcCustomView4>", "来源窗口: 自定义列视图 4")
    vim.Comment("<cm_SrcCustomView5>", "来源窗口: 自定义列视图 5")
    vim.Comment("<cm_SrcCustomView6>", "来源窗口: 自定义列视图 6")
    vim.Comment("<cm_SrcCustomView7>", "来源窗口: 自定义列视图 7")
    vim.Comment("<cm_SrcCustomView8>", "来源窗口: 自定义列视图 8")
    vim.Comment("<cm_SrcCustomView9>", "来源窗口: 自定义列视图 9")
    vim.Comment("<cm_SrcCustomView10>", "来源窗口: 自定义列视图 10")
    vim.Comment("<cm_LeftCustomView1>", "左窗口: 自定义列视图 1")
    vim.Comment("<cm_LeftCustomView2>", "左窗口: 自定义列视图 2")
    vim.Comment("<cm_LeftCustomView3>", "左窗口: 自定义列视图 3")
    vim.Comment("<cm_LeftCustomView4>", "左窗口: 自定义列视图 4")
    vim.Comment("<cm_LeftCustomView5>", "左窗口: 自定义列视图 5")
    vim.Comment("<cm_LeftCustomView6>", "左窗口: 自定义列视图 6")
    vim.Comment("<cm_LeftCustomView7>", "左窗口: 自定义列视图 7")
    vim.Comment("<cm_LeftCustomView8>", "左窗口: 自定义列视图 8")
    vim.Comment("<cm_LeftCustomView9>", "左窗口: 自定义列视图 9")
    vim.Comment("<cm_LeftCustomView10>", "左窗口: 自定义列视图 10")
    vim.Comment("<cm_RightCustomView1>", "右窗口: 自定义列视图 1")
    vim.Comment("<cm_RightCustomView2>", "右窗口: 自定义列视图 2")
    vim.Comment("<cm_RightCustomView3>", "右窗口: 自定义列视图 3")
    vim.Comment("<cm_RightCustomView4>", "右窗口: 自定义列视图 4")
    vim.Comment("<cm_RightCustomView5>", "右窗口: 自定义列视图 5")
    vim.Comment("<cm_RightCustomView6>", "右窗口: 自定义列视图 6")
    vim.Comment("<cm_RightCustomView7>", "右窗口: 自定义列视图 7")
    vim.Comment("<cm_RightCustomView8>", "右窗口: 自定义列视图 8")
    vim.Comment("<cm_RightCustomView9>", "右窗口: 自定义列视图 9")
    vim.Comment("<cm_RightCustomView10>", "右窗口: 自定义列视图 10")
    vim.Comment("<cm_SrcNextCustomView>", "来源窗口: 下一个自定义视图")
    vim.Comment("<cm_SrcPrevCustomView>", "来源窗口: 上一个自定义视图")
    vim.Comment("<cm_TrgNextCustomView>", "目标窗口: 下一个自定义视图")
    vim.Comment("<cm_TrgPrevCustomView>", "目标窗口: 上一个自定义视图")
    vim.Comment("<cm_LeftNextCustomView>", "左窗口: 下一个自定义视图")
    vim.Comment("<cm_LeftPrevCustomView>", "左窗口: 上一个自定义视图")
    vim.Comment("<cm_RightNextCustomView>", "右窗口: 下一个自定义视图")
    vim.Comment("<cm_RightPrevCustomView>", "右窗口: 上一个自定义视图")
    vim.Comment("<cm_LoadAllOnDemandFields>", "所有文件都按需加载备注")
    vim.Comment("<cm_LoadSelOnDemandFields>", "仅选中的文件按需加载备注")
    vim.Comment("<cm_ContentStopLoadFields>", "停止后台加载备注")
    vim.Comment("<cm_FocusSrc>", "光标切换至源面板")
    vim.Comment("<cm_FocusTrg>", "光标切换至目标面板")
return
SendPos(Number)
{
    PostMessage 1075, %Number%, 0, , AHK_CLASS TTOTAL_CMD
}
;<cm_SrcComments>: >>来源窗口: 显示文件备注{{{2
<cm_SrcComments>:
    SendPos(300)
return
;<cm_SrcShort>: >>来源窗口: 列表{{{2
<cm_SrcShort>:
    SendPos(301)
return
;<cm_SrcLong>: >>来源窗口: 详细信息{{{2
<cm_SrcLong>:
    SendPos(302)
return
;<cm_SrcTree>: >>来源窗口: 文件夹树{{{2
<cm_SrcTree>:
    SendPos(303)
;<cm_SrcQuickview>: >>来源窗口: 快速查看{{{2
<cm_SrcQuickview>:
    SendPos(304)
return
;<cm_VerticalPanels>: >>纵向排列{{{2
<cm_VerticalPanels>:
    SendPos(305)
return
;<cm_SrcQuickInternalOnly>: >>来源窗口: 快速查看(不用插件){{{2
<cm_SrcQuickInternalOnly>:
    SendPos(306)
return
;<cm_SrcHideQuickview>: >>来源窗口: 关闭快速查看窗口{{{2
<cm_SrcHideQuickview>:
    SendPos(307)
return
;<cm_SrcExecs>: >>来源窗口: 可执行文件{{{2
<cm_SrcExecs>:
    SendPos(311)
return
;<cm_SrcAllFiles>: >>来源窗口: 所有文件{{{2
<cm_SrcAllFiles>:
    SendPos(312)
return
;<cm_SrcUserSpec>: >>来源窗口: 上次选中的文件{{{2
<cm_SrcUserSpec>:
    SendPos(313)
return
;<cm_SrcUserDef>: >>来源窗口: 自定义类型{{{2
<cm_SrcUserDef>:
    SendPos(314)
return
;<cm_SrcByName>: >>来源窗口: 按文件名排序{{{2
<cm_SrcByName>:
    SendPos(321)
return
;<cm_SrcByExt>: >>来源窗口: 按扩展名排序{{{2
<cm_SrcByExt>:
    SendPos(322)
return
;<cm_SrcBySize>: >>来源窗口: 按大小排序{{{2
<cm_SrcBySize>:
    SendPos(323)
return
;<cm_SrcByDateTime>: >>来源窗口: 按日期时间排序{{{2
<cm_SrcByDateTime>:
    SendPos(324)
return
;<cm_SrcUnsorted>: >>来源窗口: 不排序{{{2
<cm_SrcUnsorted>:
    SendPos(325)
return
;<cm_SrcNegOrder>: >>来源窗口: 反向排序{{{2
<cm_SrcNegOrder>:
    SendPos(330)
return
;<cm_SrcOpenDrives>: >>来源窗口: 打开驱动器列表{{{2
<cm_SrcOpenDrives>:
    SendPos(331)
return
;<cm_SrcThumbs>: >>来源窗口: 缩略图{{{2
<cm_SrcThumbs>:
    SendPos(269)
return
;<cm_SrcCustomViewMenu>: >>来源窗口: 自定义视图菜单{{{2
<cm_SrcCustomViewMenu>:
    SendPos(270)
return
;<cm_SrcPathFocus>: >>来源窗口: 焦点置于路径上{{{2
<cm_SrcPathFocus>:
    SendPos(332)
return
;左窗口 =========================================
return
;<cm_LeftComments>: >>左窗口: 显示文件备注{{{2
<cm_LeftComments>:
    SendPos(100)
return
;<cm_LeftShort>: >>左窗口: 列表{{{2
<cm_LeftShort>:
    SendPos(101)
return
;<cm_LeftLong>: >>左窗口: 详细信息{{{2
<cm_LeftLong>:
    SendPos(102)
return
;<cm_LeftTree>: >>左窗口: 文件夹树{{{2
<cm_LeftTree>:
    SendPos(103)
return
;<cm_LeftQuickview>: >>左窗口: 快速查看{{{2
<cm_LeftQuickview>:
    SendPos(104)
return
;<cm_LeftQuickInternalOnly>: >>左窗口: 快速查看(不用插件){{{2
<cm_LeftQuickInternalOnly>:
    SendPos(106)
return
;<cm_LeftHideQuickview>: >>左窗口: 关闭快速查看窗口{{{2
<cm_LeftHideQuickview>:
    SendPos(107)
return
;<cm_LeftExecs>: >>左窗口: 可执行文件{{{2
<cm_LeftExecs>:
    SendPos(111)
return
;<cm_LeftAllFiles>: >>左窗口: 所有文件{{{2
<cm_LeftAllFiles>:
    SendPos(112)
return
;<cm_LeftUserSpec>: >>左窗口: 上次选中的文件{{{2
<cm_LeftUserSpec>:
    SendPos(113)
return
;<cm_LeftUserDef>: >>左窗口: 自定义类型{{{2
<cm_LeftUserDef>:
    SendPos(114)
return
;<cm_LeftByName>: >>左窗口: 按文件名排序{{{2
<cm_LeftByName>:
    SendPos(121)
return
;<cm_LeftByExt>: >>左窗口: 按扩展名排序{{{2
<cm_LeftByExt>:
    SendPos(122)
return
;<cm_LeftBySize>: >>左窗口: 按大小排序{{{2
<cm_LeftBySize>:
    SendPos(123)
return
;<cm_LeftByDateTime>: >>左窗口: 按日期时间排序{{{2
<cm_LeftByDateTime>:
    SendPos(124)
return
;<cm_LeftUnsorted>: >>左窗口: 不排序{{{2
<cm_LeftUnsorted>:
    SendPos(125)
return
;<cm_LeftNegOrder>: >>左窗口: 反向排序{{{2
<cm_LeftNegOrder>:
    SendPos(130)
return
;<cm_LeftOpenDrives>: >>左窗口: 打开驱动器列表{{{2
<cm_LeftOpenDrives>:
    SendPos(131)
return
;<cm_LeftPathFocus>: >>左窗口: 焦点置于路径上{{{2
<cm_LeftPathFocus>:
    SendPos(132)
return
;<cm_LeftDirBranch>: >>左窗口: 展开所有文件夹{{{2
<cm_LeftDirBranch>:
    SendPos(2034)
return
;<cm_LeftDirBranchSel>: >>左窗口: 只展开选中的文件夹{{{2
<cm_LeftDirBranchSel>:
    SendPos(2047)
return
;<cm_LeftThumbs>: >>窗口: 缩略图{{{2
<cm_LeftThumbs>:
    SendPos(69)
return
;<cm_LeftCustomViewMenu>: >>窗口: 自定义视图菜单{{{2
<cm_LeftCustomViewMenu>:
    SendPos(70)
return
;右窗口 =========================================
return
;<cm_RightComments>: >>右窗口: 显示文件备注{{{2
<cm_RightComments>:
    SendPos(200)
return
;<cm_RightShort>: >>右窗口: 列表{{{2
<cm_RightShort>:
    SendPos(201)
return
;<cm_RightLong>: >> 详细信息{{{2
<cm_RightLong>:
    SendPos(202)
return
;<cm_RightTree>: >>右窗口: 文件夹树{{{2
<cm_RightTree>:
    SendPos(203)
return
;<cm_RightQuickvie>: >>右窗口: 快速查看{{{2
<cm_RightQuickvie>:
    SendPos(204)
return
;<cm_RightQuickInternalOnl>: >>右窗口: 快速查看(不用插件){{{2
<cm_RightQuickInternalOnl>:
    SendPos(206)
return
;<cm_RightHideQuickvie>: >>右窗口: 关闭快速查看窗口{{{2
<cm_RightHideQuickvie>:
    SendPos(207)
return
;<cm_RightExec>: >>右窗口: 可执行文件{{{2
<cm_RightExec>:
    SendPos(211)
return
;<cm_RightAllFile>: >>右窗口: 所有文件{{{2
<cm_RightAllFile>:
    SendPos(212)
return
;<cm_RightUserSpe>: >>右窗口: 上次选中的文件{{{2
<cm_RightUserSpe>:
    SendPos(213)
return
;<cm_RightUserDe>: >>右窗口: 自定义类型{{{2
<cm_RightUserDe>:
    SendPos(214)
return
;<cm_RightByNam>: >>右窗口: 按文件名排序{{{2
<cm_RightByNam>:
    SendPos(221)
return
;<cm_RightByEx>: >>右窗口: 按扩展名排序{{{2
<cm_RightByEx>:
    SendPos(222)
return
;<cm_RightBySiz>: >>右窗口: 按大小排序{{{2
<cm_RightBySiz>:
    SendPos(223)
return
;<cm_RightByDateTim>: >>右窗口: 按日期时间排序{{{2
<cm_RightByDateTim>:
    SendPos(224)
return
;<cm_RightUnsorte>: >>右窗口: 不排序{{{2
<cm_RightUnsorte>:
    SendPos(225)
return
;<cm_RightNegOrde>: >>右窗口: 反向排序{{{2
<cm_RightNegOrde>:
    SendPos(230)
return
;<cm_RightOpenDrive>: >>右窗口: 打开驱动器列表{{{2
<cm_RightOpenDrives>:
    SendPos(231)
return
;<cm_RightPathFocu>: >>右窗口: 焦点置于路径上{{{2
<cm_RightPathFocu>:
    SendPos(232)
return
;<cm_RightDirBranch>: >>右窗口: 展开所有文件夹{{{2
<cm_RightDirBranch>:
    SendPos(2035)
return
;<cm_RightDirBranchSel>: >>右窗口: 只展开选中的文件夹{{{2
<cm_RightDirBranchSel>:
    SendPos(2048)
return
;<cm_RightThumb>: >>右窗口: 缩略图{{{2
<cm_RightThumb>:
    SendPos(169)
return
;<cm_RightCustomViewMen>: >>右窗口: 自定义视图菜单{{{2
<cm_RightCustomViewMen>:
    SendPos(170)
return
;文件操作 =========================================
return
;<cm_List>: >>查看(用查看程序){{{2
<cm_List>:
    SendPos(903)
return
;<cm_ListInternalOnly>: >>查看(用查看程序, 但不用插件/多媒体){{{2
<cm_ListInternalOnly>:
    SendPos(1006)
return
;<cm_Edit>: >>编辑{{{2
<cm_Edit>:
    SendPos(904)
return
;<cm_Copy>: >>复制{{{2
<cm_Copy>:
    SendPos(905)
return
;<cm_CopySamepanel>: >>复制到当前窗口{{{2
<cm_CopySamepanel>:
    SendPos(3100)
return
;<cm_CopyOtherpanel>: >>复制到另一窗口{{{2
<cm_CopyOtherpanel>:
    SendPos(3101)
return
;<cm_RenMov>: >>重命名/移动{{{2
<cm_RenMov>:
    SendPos(906)
return
;<cm_MkDir>: >>新建文件夹{{{2
<cm_MkDir>:
    SendPos(907)
return
;<cm_Delete>: >>删除{{{2
<cm_Delete>:
    SendPos(908)
return
;<cm_TestArchive>: >>测试压缩包{{{2
<cm_TestArchive>:
    SendPos(518)
return
;<cm_PackFiles>: >>压缩文件{{{2
<cm_PackFiles>:
    SendPos(508)
return
;<cm_UnpackFiles>: >>解压文件{{{2
<cm_UnpackFiles>:
    SendPos(509)
return
;<cm_RenameOnly>: >>重命名(Shift+F6){{{2
<cm_RenameOnly>:
    SendPos(1002)
return
;<cm_RenameSingleFile>: >>重命名当前文件{{{2
<cm_RenameSingleFile>:
    SendPos(1007)
return
;<cm_MoveOnly>: >>移动到另一个窗口(F6){{{2
<cm_MoveOnly>:
    SendPos(1005)
return
;<cm_Properties>: >>显示属性{{{2
<cm_Properties>:
    SendPos(1003)
return
;<cm_CreateShortcut>: >>创建快捷方式{{{2
<cm_CreateShortcut>:
    SendPos(1004)
return
;<cm_Return>: >>模仿按 ENTER 键{{{2
<cm_Return>:
    SendPos(1001)
return
;<cm_OpenAsUser>: >>以其他用户身份运行光标处的程序{{{2
<cm_OpenAsUser>:
    SendPos(2800)
return
;<cm_Split>: >>分割文件{{{2
<cm_Split>:
    SendPos(560)
return
;<cm_Combine>: >>合并文件{{{2
<cm_Combine>:
    SendPos(561)
return
;<cm_Encode>: >>编码文件(MIME/UUE/XXE 格式){{{2
<cm_Encode>:
    SendPos(562)
return
;<cm_Decode>: >>解码文件(MIME/UUE/XXE/BinHex 格式){{{2
<cm_Decode>:
    SendPos(563)
return
;<cm_CRCcreate>: >>创建校验文件{{{2
<cm_CRCcreate>:
    SendPos(564)
return
;<cm_CRCcheck>: >>验证校验和{{{2
<cm_CRCcheck>:
    SendPos(565)
return
;<cm_SetAttrib>: >>更改属性{{{2
<cm_SetAttrib>:
    SendPos(502)
return
;配置 =========================================
return
;<cm_Config>: >>配置: 布局{{{2
<cm_Config>:
    SendPos(490)
return
;<cm_DisplayConfig>: >>配置: 显示{{{2
<cm_DisplayConfig>:
    SendPos(486)
return
;<cm_IconConfig>: >>配置: 图标{{{2
<cm_IconConfig>:
    SendPos(477)
return
;<cm_FontConfig>: >>配置: 字体{{{2
<cm_FontConfig>:
    SendPos(492)
return
;<cm_ColorConfig>: >>配置: 颜色{{{2
<cm_ColorConfig>:
    SendPos(494)
return
;<cm_ConfTabChange>: >>配置: 制表符{{{2
<cm_ConfTabChange>:
    SendPos(497)
return
;<cm_DirTabsConfig>: >>配置: 文件夹标签{{{2
<cm_DirTabsConfig>:
    SendPos(488)
return
;<cm_CustomColumnConfig>: >>配置: 自定义列{{{2
<cm_CustomColumnConfig>:
    SendPos(483)
return
;<cm_CustomColumnDlg>: >>更改当前自定义列{{{2
<cm_CustomColumnDlg>:
    SendPos(2920)
return
;<cm_LanguageConfig>: >>配置: 语言{{{2
<cm_LanguageConfig>:
    SendPos(499)
return
;<cm_Config2>: >>配置: 操作方式{{{2
<cm_Config2>:
    SendPos(516)
return
;<cm_EditConfig>: >>配置: 编辑/查看{{{2
<cm_EditConfig>:
    SendPos(496)
return
;<cm_CopyConfig>: >>配置: 复制/删除{{{2
<cm_CopyConfig>:
    SendPos(487)
return
;<cm_RefreshConfig>: >>配置: 刷新{{{2
<cm_RefreshConfig>:
    SendPos(478)
return
;<cm_QuickSearchConfig>: >>配置: 快速搜索{{{2
<cm_QuickSearchConfig>:
    SendPos(479)
return
;<cm_FtpConfig>: >>配置: FTP{{{2
<cm_FtpConfig>:
    SendPos(489)
return
;<cm_PluginsConfig>: >>配置: 插件{{{2
<cm_PluginsConfig>:
    SendPos(484)
return
;<cm_ThumbnailsConfig>: >>配置: 缩略图{{{2
<cm_ThumbnailsConfig>:
    SendPos(482)
return
;<cm_LogConfig>: >>配置: 日志文件{{{2
<cm_LogConfig>:
    SendPos(481)
return
;<cm_IgnoreConfig>: >>配置: 隐藏文件{{{2
<cm_IgnoreConfig>:
    SendPos(480)
return
;<cm_PackerConfig>: >>配置: 压缩程序{{{2
<cm_PackerConfig>:
    SendPos(491)
return
;<cm_ZipPackerConfig>: >>配置: ZIP 压缩程序{{{2
<cm_ZipPackerConfig>:
    SendPos(485)
return
;<cm_Confirmation>: >>配置: 其他/确认{{{2
<cm_Confirmation>:
    SendPos(495)
return
;<cm_ConfigSavePos>: >>保存位置{{{2
<cm_ConfigSavePos>:
    SendPos(493)
return
;<cm_ButtonConfig>: >>更改工具栏{{{2
<cm_ButtonConfig>:
    SendPos(498)
return
;<cm_ConfigSaveSettings>: >>保存设置{{{2
<cm_ConfigSaveSettings>:
    SendPos(580)
return
;<cm_ConfigChangeIniFiles>: >>直接修改配置文件{{{2
<cm_ConfigChangeIniFiles>:
    SendPos(581)
return
;<cm_ConfigSaveDirHistory>: >>保存文件夹历史记录{{{2
<cm_ConfigSaveDirHistory>:
    SendPos(582)
return
;<cm_ChangeStartMenu>: >>更改开始菜单{{{2
<cm_ChangeStartMenu>:
    SendPos(700)
return
;网络 =========================================
return
;<cm_NetConnect>: >>映射网络驱动器{{{2
<cm_NetConnect>:
    SendPos(512)
return
;<cm_NetDisconnect>: >>断开网络驱动器{{{2
<cm_NetDisconnect>:
    SendPos(513)
return
;<cm_NetShareDir>: >>共享当前文件夹{{{2
<cm_NetShareDir>:
    SendPos(514)
return
;<cm_NetUnshareDir>: >>取消文件夹共享{{{2
<cm_NetUnshareDir>:
    SendPos(515)
return
;<cm_AdministerServer>: >>显示系统共享文件夹{{{2
<cm_AdministerServer>:
    SendPos(2204)
return
;<cm_ShowFileUser>: >>显示本地文件的远程用户{{{2
<cm_ShowFileUser>:
    SendPos(2203)
return
;其他 =========================================
return
;<cm_GetFileSpace>: >>计算占用空间{{{2
<cm_GetFileSpace>:
    SendPos(503)
return
;<cm_VolumeId>: >>设置卷标{{{2
<cm_VolumeId>:
    SendPos(505)
return
;<cm_VersionInfo>: >>版本信息{{{2
<cm_VersionInfo>:
    SendPos(510)
return
;<cm_ExecuteDOS>: >>打开命令提示符窗口{{{2
<cm_ExecuteDOS>:
    SendPos(511)
return
;<cm_CompareDirs>: >>比较文件夹{{{2
<cm_CompareDirs>:
    SendPos(533)
return
;<cm_CompareDirsWithSubdirs>: >>比较文件夹(同时标出另一窗口没有的子文件夹){{{2
<cm_CompareDirsWithSubdirs>:
    SendPos(536)
return
;<cm_ContextMenu>: >>显示快捷菜单{{{2
<cm_ContextMenu>:
    SendPos(2500)
return
;<cm_ContextMenuInternal>: >>显示快捷菜单(内部关联){{{2
<cm_ContextMenuInternal>:
    SendPos(2927)
return
;<cm_ContextMenuInternalCursor>: >>显示光标处文件的内部关联快捷菜单{{{2
<cm_ContextMenuInternalCursor>:
    SendPos(2928)
return
;<cm_ShowRemoteMenu>: >>媒体中心遥控器播放/暂停键快捷菜单{{{2
<cm_ShowRemoteMenu>:
    SendPos(2930)
return
;<cm_SyncChangeDir>: >>两边窗口同步更改文件夹{{{2
<cm_SyncChangeDir>:
    SendPos(2600)
return
;<cm_EditComment>: >>编辑文件备注{{{2
<cm_EditComment>:
    SendPos(2700)
return
;<cm_FocusLeft>: >>焦点置于左窗口{{{2
<cm_FocusLeft>:
    SendPos(4001)
return
;<cm_FocusRight>: >>焦点置于右窗口{{{2
<cm_FocusRight>:
    SendPos(4002)
return
;<cm_FocusCmdLine>: >>焦点置于命令行{{{2
<cm_FocusCmdLine>:
    SendPos(4003)
return
;<cm_FocusButtonBar>: >>焦点置于工具栏{{{2
<cm_FocusButtonBar>:
    SendPos(4004)
return
;<cm_CountDirContent>: >>计算所有文件夹占用的空间{{{2
<cm_CountDirContent>:
    SendPos(2014)
return
;<cm_UnloadPlugins>: >>卸载所有插件{{{2
<cm_UnloadPlugins>:
    SendPos(2913)
return
;<cm_DirMatch>: >>标出新文件, 隐藏相同者{{{2
<cm_DirMatch>:
    SendPos(534)
return
;<cm_Exchange>: >>交换左右窗口{{{2
<cm_Exchange>:
    SendPos(531)
return
;<cm_MatchSrc>: >>目标 = 来源{{{2
<cm_MatchSrc>:
    SendPos(532)
return
;<cm_ReloadSelThumbs>: >>刷新选中文件的缩略图{{{2
<cm_ReloadSelThumbs>:
    SendPos(2918)
return
;并口 =========================================
return
;<cm_DirectCableConnect>: >>直接电缆连接{{{2
<cm_DirectCableConnect>:
    SendPos(2300)
return
;<cm_NTinstallDriver>: >>加载 NT 并口驱动程序{{{2
<cm_NTinstallDriver>:
    SendPos(2301)
return
;<cm_NTremoveDriver>: >>卸载 NT 并口驱动程序{{{2
<cm_NTremoveDriver>:
    SendPos(2302)
return
;打印 =========================================
return
;<cm_PrintDir>: >>打印文件列表{{{2
<cm_PrintDir>:
    SendPos(2027)
return
;<cm_PrintDirSub>: >>打印文件列表(含子文件夹){{{2
<cm_PrintDirSub>:
    SendPos(2028)
return
;<cm_PrintFile>: >>打印文件内容{{{2
<cm_PrintFile>:
    SendPos(504)
return
;选择 =========================================
return
;<cm_SpreadSelection>: >>选择一组文件{{{2
<cm_SpreadSelection>:
    SendPos(521)
return
;<cm_SelectBoth>: >>选择一组: 文件和文件夹{{{2
<cm_SelectBoth>:
    SendPos(3311)
return
;<cm_SelectFiles>: >>选择一组: 仅文件{{{2
<cm_SelectFiles>:
    SendPos(3312)
return
;<cm_SelectFolders>: >>选择一组: 仅文件夹{{{2
<cm_SelectFolders>:
    SendPos(3313)
return
;<cm_ShrinkSelection>: >>不选一组文件{{{2
<cm_ShrinkSelection>:
    SendPos(522)
return
;<cm_ClearFiles>: >>不选一组: 仅文件{{{2
<cm_ClearFiles>:
    SendPos(3314)
return
;<cm_ClearFolders>: >>不选一组: 仅文件夹{{{2
<cm_ClearFolders>:
    SendPos(3315)
return
;<cm_ClearSelCfg>: >>不选一组: 文件和/或文件夹(视配置而定){{{2
<cm_ClearSelCfg>:
    SendPos(3316)
return
;<cm_SelectAll>: >>全部选择: 文件和/或文件夹(视配置而定){{{2
<cm_SelectAll>:
    SendPos(523)
return
;<cm_SelectAllBoth>: >>全部选择: 文件和文件夹{{{2
<cm_SelectAllBoth>:
    SendPos(3301)
return
;<cm_SelectAllFiles>: >>全部选择: 仅文件{{{2
<cm_SelectAllFiles>:
    SendPos(3302)
return
;<cm_SelectAllFolders>: >>全部选择: 仅文件夹{{{2
<cm_SelectAllFolders>:
    SendPos(3303)
return
;<cm_ClearAll>: >>全部取消: 文件和文件夹{{{2
<cm_ClearAll>:
    SendPos(524)
return
;<cm_ClearAllFiles>: >>全部取消: 仅文件{{{2
<cm_ClearAllFiles>:
    SendPos(3304)
return
;<cm_ClearAllFolders>: >>全部取消: 仅文件夹{{{2
<cm_ClearAllFolders>:
    SendPos(3305)
return
;<cm_ClearAllCfg>: >>全部取消: 文件和/或文件夹(视配置而定){{{2
<cm_ClearAllCfg>:
    SendPos(3306)
return
;<cm_ExchangeSelection>: >>反向选择{{{2
<cm_ExchangeSelection>:
    SendPos(525)
return
;<cm_ExchangeSelBoth>: >>反向选择: 文件和文件夹{{{2
<cm_ExchangeSelBoth>:
    SendPos(3321)
return
;<cm_ExchangeSelFiles>: >>反向选择: 仅文件{{{2
<cm_ExchangeSelFiles>:
    SendPos(3322)
return
;<cm_ExchangeSelFolders>: >>反向选择: 仅文件夹{{{2
<cm_ExchangeSelFolders>:
    SendPos(3323)
return
;<cm_SelectCurrentExtension>: >>选择扩展名相同的文件{{{2
<cm_SelectCurrentExtension>:
    SendPos(527)
return
;<cm_UnselectCurrentExtension>: >>不选扩展名相同的文件{{{2
<cm_UnselectCurrentExtension>:
    SendPos(528)
return
;<cm_SelectCurrentName>: >>选择文件名相同的文件{{{2
<cm_SelectCurrentName>:
    SendPos(541)
return
;<cm_UnselectCurrentName>: >>不选文件名相同的文件{{{2
<cm_UnselectCurrentName>:
    SendPos(542)
return
;<cm_SelectCurrentNameExt>: >>选择文件名和扩展名相同的文件{{{2
<cm_SelectCurrentNameExt>:
    SendPos(543)
return
;<cm_UnselectCurrentNameExt>: >>不选文件名和扩展名相同的文件{{{2
<cm_UnselectCurrentNameExt>:
    SendPos(544)
return
;<cm_SelectCurrentPath>: >>选择同一路径下的文件(展开文件夹+搜索文件){{{2
<cm_SelectCurrentPath>:
    SendPos(537)
return
;<cm_UnselectCurrentPath>: >>不选同一路径下的文件(展开文件夹+搜索文件){{{2
<cm_UnselectCurrentPath>:
    SendPos(538)
return
;<cm_RestoreSelection>: >>恢复选择列表{{{2
<cm_RestoreSelection>:
    SendPos(529)
return
;<cm_SaveSelection>: >>保存选择列表{{{2
<cm_SaveSelection>:
    SendPos(530)
return
;<cm_SaveSelectionToFile>: >>导出选择列表{{{2
<cm_SaveSelectionToFile>:
    SendPos(2031)
return
;<cm_SaveSelectionToFileA>: >>导出选择列表(ANSI){{{2
<cm_SaveSelectionToFileA>:
    SendPos(2041)
return
;<cm_SaveSelectionToFileW>: >>导出选择列表(Unicode){{{2
<cm_SaveSelectionToFileW>:
    SendPos(2042)
return
;<cm_SaveDetailsToFile>: >>导出详细信息{{{2
<cm_SaveDetailsToFile>:
    SendPos(2039)
return
;<cm_SaveDetailsToFileA>: >>导出详细信息(ANSI){{{2
<cm_SaveDetailsToFileA>:
    SendPos(2043)
return
;<cm_SaveDetailsToFileW>: >>导出详细信息(Unicode){{{2
<cm_SaveDetailsToFileW>:
    SendPos(2044)
return
;<cm_LoadSelectionFromFile>: >>导入选择列表(从文件){{{2
<cm_LoadSelectionFromFile>:
    SendPos(2032)
return
;<cm_LoadSelectionFromClip>: >>导入选择列表(从剪贴板){{{2
<cm_LoadSelectionFromClip>:
    SendPos(2033)
return
;安全 =========================================
return
;<cm_EditPermissionInfo>: >>设置权限(NTFS){{{2
<cm_EditPermissionInfo>:
    SendPos(2200)
return
;<cm_EditAuditInfo>: >>审核文件(NTFS){{{2
<cm_EditAuditInfo>:
    SendPos(2201)
return
;<cm_EditOwnerInfo>: >>获取所有权(NTFS){{{2
<cm_EditOwnerInfo>:
    SendPos(2202)
return
;剪贴板 =========================================
return
;<cm_CutToClipboard>: >>剪切选中的文件到剪贴板{{{2
<cm_CutToClipboard>:
    SendPos(2007)
return
;<cm_CopyToClipboard>: >>复制选中的文件到剪贴板{{{2
<cm_CopyToClipboard>:
    SendPos(2008)
return
;<cm_PasteFromClipboard>: >>从剪贴板粘贴到当前文件夹{{{2
<cm_PasteFromClipboard>:
    SendPos(2009)
return
;<cm_CopyNamesToClip>: >>复制文件名{{{2
<cm_CopyNamesToClip>:
    SendPos(2017)
return
;<cm_CopyFullNamesToClip>: >>复制文件名及完整路径{{{2
<cm_CopyFullNamesToClip>:
    SendPos(2018)
return
;<cm_CopyNetNamesToClip>: >>复制文件名及网络路径{{{2
<cm_CopyNetNamesToClip>:
    SendPos(2021)
return
;<cm_CopySrcPathToClip>: >>复制来源路径{{{2
<cm_CopySrcPathToClip>:
    SendPos(2029)
return
;<cm_CopyTrgPathToClip>: >>复制目标路径{{{2
<cm_CopyTrgPathToClip>:
    SendPos(2030)
return
;<cm_CopyFileDetailsToClip>: >>复制文件详细信息{{{2
<cm_CopyFileDetailsToClip>:
    SendPos(2036)
return
;<cm_CopyFpFileDetailsToClip>: >>复制文件详细信息及完整路径{{{2
<cm_CopyFpFileDetailsToClip>:
    SendPos(2037)
return
;<cm_CopyNetFileDetailsToClip>: >>复制文件详细信息及网络路径{{{2
<cm_CopyNetFileDetailsToClip>:
    SendPos(2038)
return
;FTP =========================================
return
;<cm_FtpConnect>: >>FTP 连接{{{2
<cm_FtpConnect>:
    SendPos(550)
return
;<cm_FtpNew>: >>新建 FTP 连接{{{2
<cm_FtpNew>:
    SendPos(551)
return
;<cm_FtpDisconnect>: >>断开 FTP 连接{{{2
<cm_FtpDisconnect>:
    SendPos(552)
return
;<cm_FtpHiddenFiles>: >>显示隐藏文件{{{2
<cm_FtpHiddenFiles>:
    SendPos(553)
return
;<cm_FtpAbort>: >>中止当前 FTP 命令{{{2
<cm_FtpAbort>:
    SendPos(554)
return
;<cm_FtpResumeDownload>: >>续传{{{2
<cm_FtpResumeDownload>:
    SendPos(555)
return
;<cm_FtpSelectTransferMode>: >>选择传输模式{{{2
<cm_FtpSelectTransferMode>:
    SendPos(556)
return
;<cm_FtpAddToList>: >>添加到下载列表{{{2
<cm_FtpAddToList>:
    SendPos(557)
return
;<cm_FtpDownloadList>: >>按列表下载{{{2
<cm_FtpDownloadList>:
    SendPos(558)
return
;导航 =========================================
return
;<cm_GotoPreviousDir>: >>后退{{{2
<cm_GotoPreviousDir>:
    SendPos(570)
return
;<cm_GotoNextDir>: >>前进{{{2
<cm_GotoNextDir>:
    SendPos(571)
return
;<cm_DirectoryHistory>: >>文件夹历史记录{{{2
<cm_DirectoryHistory>:
    Vim_HotkeyCount := 0
    SendPos(572)
return
;<cm_GotoPreviousLocalDir>: >>后退(非 FTP){{{2
<cm_GotoPreviousLocalDir>:
    SendPos(573)
return
;<cm_GotoNextLocalDir>: >>前进(非 FTP){{{2
<cm_GotoNextLocalDir>:
    SendPos(574)
return
;<cm_DirectoryHotlist>: >>常用文件夹{{{2
<cm_DirectoryHotlist>:
    Vim_HotkeyCount := 0
    SendPos(526)
return
;<cm_GoToRoot>: >>转到根文件夹{{{2
<cm_GoToRoot>:
    SendPos(2001)
return
;<cm_GoToParent>: >>转到上层文件夹{{{2
<cm_GoToParent>:
    SendPos(2002)
return
;<cm_GoToDir>: >>打开光标处的文件夹或压缩包{{{2
<cm_GoToDir>:
    SendPos(2003)
return
;<cm_OpenDesktop>: >>桌面{{{2
<cm_OpenDesktop>:
    SendPos(2121)
return
;<cm_OpenDrives>: >>我的电脑{{{2
<cm_OpenDrives>:
    SendPos(2122)
return
;<cm_OpenControls>: >>控制面板{{{2
<cm_OpenControls>:
    SendPos(2123)
return
;<cm_OpenFonts>: >>字体{{{2
<cm_OpenFonts>:
    SendPos(2124)
return
;<cm_OpenNetwork>: >>网上邻居{{{2
<cm_OpenNetwork>:
    SendPos(2125)
return
;<cm_OpenPrinters>: >>打印机{{{2
<cm_OpenPrinters>:
    SendPos(2126)
return
;<cm_OpenRecycled>: >>回收站{{{2
<cm_OpenRecycled>:
    SendPos(2127)
return
;<cm_CDtree>: >>更改文件夹{{{2
<cm_CDtree>:
    SendPos(500)
return
;<cm_TransferLeft>: >>在左窗口打开光标处的文件夹或压缩包{{{2
<cm_TransferLeft>:
    SendPos(2024)
return
;<cm_TransferRight>: >>在右窗口打开光标处的文件夹或压缩包{{{2
<cm_TransferRight>:
    SendPos(2025)
return
;<cm_EditPath>: >>编辑来源窗口的路径{{{2
<cm_EditPath>:
    SendPos(2912)
return
;<cm_GoToFirstFile>: >>光标移到列表中的第一个文件{{{2
<cm_GoToFirstFile>:
    SendPos(2050)
return
;<cm_GotoNextDrive>: >>转到下一个驱动器{{{2
<cm_GotoNextDrive>:
    SendPos(2051)
return
;<cm_GotoPreviousDrive>: >>转到上一个驱动器{{{2
<cm_GotoPreviousDrive>:
    SendPos(2052)
return
;<cm_GotoNextSelected>: >>转到下一个选中的文件{{{2
<cm_GotoNextSelected>:
    SendPos(2053)
return
;<cm_GotoPrevSelected>: >>转到上一个选中的文件{{{2
<cm_GotoPrevSelected>:
    SendPos(2054)
return
;<cm_GotoDriveA>: >>转到驱动器 A{{{2
<cm_GotoDriveA>:
    SendPos(2061)
return
;<cm_GotoDriveC>: >>转到驱动器 C{{{2
<cm_GotoDriveC>:
    SendPos(2063)
return
;<cm_GotoDriveD>: >>转到驱动器 D{{{2
<cm_GotoDriveD>:
    SendPos(2064)
return
;<cm_GotoDriveE>: >>转到驱动器 E{{{2
<cm_GotoDriveE>:
    SendPos(2065)
return
;<cm_GotoDriveF>: >>可自定义其他驱动器{{{2
<cm_GotoDriveF>:
    SendPos(2066)
return
;<cm_GotoDriveZ>: >>最多 26 个{{{2
<cm_GotoDriveZ>:
    SendPos(2086)
return
;帮助 =========================================
return
;<cm_HelpIndex>: >>帮助索引{{{2
<cm_HelpIndex>:
    SendPos(610)
return
;<cm_Keyboard>: >>快捷键列表{{{2
<cm_Keyboard>:
    SendPos(620)
return
;<cm_Register>: >>注册信息{{{2
<cm_Register>:
    SendPos(630)
return
;<cm_VisitHomepage>: >>访问 Totalcmd 网站{{{2
<cm_VisitHomepage>:
    SendPos(640)
return
;<cm_About>: >>关于 Total Commander{{{2
<cm_About>:
    SendPos(690)
return
;窗口 =========================================
return
;<cm_Exit>: >>退出 Total Commander{{{2
<cm_Exit>:
    SendPos(24340)
return
;<cm_Minimize>: >>最小化 Total Commander{{{2
<cm_Minimize>:
    SendPos(2000)
return
;<cm_Maximize>: >>最大化 Total Commander{{{2
<cm_Maximize>:
    SendPos(2015)
return
;<cm_Restore>: >>恢复正常大小{{{2
<cm_Restore>:
    SendPos(2016)
return
;命令行 =========================================
return
;<cm_ClearCmdLine>: >>清除命令行{{{2
<cm_ClearCmdLine>:
    SendPos(2004)
return
;<cm_NextCommand>: >>下一条命令{{{2
<cm_NextCommand>:
    SendPos(2005)
return
;<cm_PrevCommand>: >>上一条命令{{{2
<cm_PrevCommand>:
    SendPos(2006)
return
;<cm_AddPathToCmdline>: >>将路径复制到命令行{{{2
<cm_AddPathToCmdline>:
    SendPos(2019)
return
;工具 =========================================
return
;<cm_MultiRenameFiles>: >>批量重命名{{{2
<cm_MultiRenameFiles>:
    SendPos(2400)
return
;<cm_SysInfo>: >>系统信息{{{2
<cm_SysInfo>:
    SendPos(506)
return
;<cm_OpenTransferManager>: >>后台传输管理器{{{2
<cm_OpenTransferManager>:
    SendPos(559)
return
;<cm_SearchFor>: >>搜索文件{{{2
<cm_SearchFor>:
    SendPos(501)
return
;<cm_SearchStandalone>: >>在单独进程搜索文件{{{2
<cm_SearchStandalone>:
    SendPos(545)
return
;<cm_FileSync>: >>同步文件夹{{{2
<cm_FileSync>:
    SendPos(2020)
return
;<cm_Associate>: >>文件关联{{{2
<cm_Associate>:
    SendPos(507)
return
;<cm_InternalAssociate>: >>定义内部关联{{{2
<cm_InternalAssociate>:
    SendPos(519)
return
;<cm_CompareFilesByContent>: >>比较文件内容{{{2
<cm_CompareFilesByContent>:
    SendPos(2022)
return
;<cm_IntCompareFilesByContent>: >>使用内部比较程序{{{2
<cm_IntCompareFilesByContent>:
    SendPos(2040)
return
;<cm_CommandBrowser>: >>浏览内部命令{{{2
<cm_CommandBrowser>:
    SendPos(2924)
return
;视图 =========================================
return
;<cm_VisButtonbar>: >>显示/隐藏: 工具栏{{{2
<cm_VisButtonbar>:
    SendPos(2901)
return
;<cm_VisDriveButtons>: >>显示/隐藏: 驱动器按钮{{{2
<cm_VisDriveButtons>:
    SendPos(2902)
return
;<cm_VisTwoDriveButtons>: >>显示/隐藏: 两个驱动器按钮栏{{{2
<cm_VisTwoDriveButtons>:
    SendPos(2903)
return
;<cm_VisFlatDriveButtons>: >>切换: 平坦/立体驱动器按钮{{{2
<cm_VisFlatDriveButtons>:
    SendPos(2904)
return
;<cm_VisFlatInterface>: >>切换: 平坦/立体用户界面{{{2
<cm_VisFlatInterface>:
    SendPos(2905)
return
;<cm_VisDriveCombo>: >>显示/隐藏: 驱动器列表{{{2
<cm_VisDriveCombo>:
    SendPos(2906)
return
;<cm_VisCurDir>: >>显示/隐藏: 当前文件夹{{{2
<cm_VisCurDir>:
    SendPos(2907)
return
;<cm_VisBreadCrumbs>: >>显示/隐藏: 路径导航栏{{{2
<cm_VisBreadCrumbs>:
    SendPos(2926)
return
;<cm_VisTabHeader>: >>显示/隐藏: 排序制表符{{{2
<cm_VisTabHeader>:
    SendPos(2908)
return
;<cm_VisStatusbar>: >>显示/隐藏: 状态栏{{{2
<cm_VisStatusbar>:
    SendPos(2909)
return
;<cm_VisCmdLine>: >>显示/隐藏: 命令行{{{2
<cm_VisCmdLine>:
    SendPos(2910)
return
;<cm_VisKeyButtons>: >>显示/隐藏: 功能键按钮{{{2
<cm_VisKeyButtons>:
    SendPos(2911)
return
;<cm_ShowHint>: >>显示文件提示{{{2
<cm_ShowHint>:
    SendPos(2914)
return
;<cm_ShowQuickSearch>: >>显示快速搜索窗口{{{2
<cm_ShowQuickSearch>:
    SendPos(2915)
return
;<cm_SwitchLongNames>: >>开启/关闭: 长文件名显示{{{2
<cm_SwitchLongNames>:
    SendPos(2010)
return
;<cm_RereadSource>: >>刷新来源窗口{{{2
<cm_RereadSource>:
    SendPos(540)
return
;<cm_ShowOnlySelected>: >>仅显示选中的文件{{{2
<cm_ShowOnlySelected>:
    SendPos(2023)
return
;<cm_SwitchHidSys>: >>开启/关闭: 隐藏或系统文件显示{{{2
<cm_SwitchHidSys>:
    SendPos(2011)
return
;<cm_Switch83Names>: >>开启/关闭: 8.3 式文件名小写显示{{{2
<cm_Switch83Names>:
    SendPos(2013)
return
;<cm_SwitchDirSort>: >>开启/关闭: 文件夹按名称排序{{{2
<cm_SwitchDirSort>:
    SendPos(2012)
return
;<cm_DirBranch>: >>展开所有文件夹{{{2
<cm_DirBranch>:
    SendPos(2026)
return
;<cm_DirBranchSel>: >>只展开选中的文件夹{{{2
<cm_DirBranchSel>:
    SendPos(2046)
return
;<cm_50Percent>: >>窗口分隔栏位于 50%{{{2
<cm_50Percent>:
    SendPos(909)
return
;<cm_100Percent>: >>窗口分隔栏位于 100%{{{2
<cm_100Percent>:
    SendPos(910)
return
;<cm_VisDirTabs>: >>显示/隐藏: 文件夹标签{{{2
<cm_VisDirTabs>:
    SendPos(2916)
return
;<cm_VisXPThemeBackground>: >>显示/隐藏: XP 主题背景{{{2
<cm_VisXPThemeBackground>:
    SendPos(2923)
return
;<cm_SwitchOverlayIcons>: >>开启/关闭: 叠置图标显示{{{2
<cm_SwitchOverlayIcons>:
    SendPos(2917)
return
;<cm_VisHistHotButtons>: >>显示/隐藏: 文件夹历史记录和常用文件夹按钮{{{2
<cm_VisHistHotButtons>:
    SendPos(2919)
return
;<cm_SwitchWatchDirs>: >>启用/禁用: 文件夹自动刷新{{{2
<cm_SwitchWatchDirs>:
    SendPos(2921)
return
;<cm_SwitchIgnoreList>: >>启用/禁用: 自定义隐藏文件{{{2
<cm_SwitchIgnoreList>:
    SendPos(2922)
return
;<cm_SwitchX64Redirection>: >>开启/关闭: 32 位 system32 目录重定向(64 位 Windows){{{2
<cm_SwitchX64Redirection>:
    SendPos(2925)
return
;<cm_SeparateTreeOff>: >>关闭独立文件夹树面板{{{2
<cm_SeparateTreeOff>:
    SendPos(3200)
return
;<cm_SeparateTree1>: >>一个独立文件夹树面板{{{2
<cm_SeparateTree1>:
    SendPos(3201)
return
;<cm_SeparateTree2>: >>两个独立文件夹树面板{{{2
<cm_SeparateTree2>:
    SendPos(3202)
return
;<cm_SwitchSeparateTree>: >>切换独立文件夹树面板状态{{{2
<cm_SwitchSeparateTree>:
    SendPos(3203)
return
;<cm_ToggleSeparateTree1>: >>开启/关闭: 一个独立文件夹树面板{{{2
<cm_ToggleSeparateTree1>:
    SendPos(3204)
return
;<cm_ToggleSeparateTree2>: >>开启/关闭: 两个独立文件夹树面板{{{2
<cm_ToggleSeparateTree2>:
    SendPos(3205)
return
;用户 =========================================
return
;<cm_UserMenu1>: >>用户菜单 1{{{2
<cm_UserMenu1>:
    SendPos(701)
return
;<cm_UserMenu2>: >>用户菜单 2{{{2
<cm_UserMenu2>:
    SendPos(702)
return
;<cm_UserMenu3>: >>用户菜单 3{{{2
<cm_UserMenu3>:
    SendPos(703)
return
;<cm_UserMenu4>: >>...{{{2
<cm_UserMenu4>:
    SendPos(704)
return
;<cm_UserMenu5>: >>5{{{2
<cm_UserMenu5>:
    SendPos(70)
return
;<cm_UserMenu6>: >>6{{{2
<cm_UserMenu6>:
    SendPos(70)
return
;<cm_UserMenu7>: >>7{{{2
<cm_UserMenu7>:
    SendPos(70)
return
;<cm_UserMenu8>: >>8{{{2
<cm_UserMenu8>:
    SendPos(70)
return
;<cm_UserMenu9>: >>9{{{2
<cm_UserMenu9>:
    SendPos(70)
return
;<cm_UserMenu10>: >>可定义其他用户菜单{{{2
<cm_UserMenu10>:
    SendPos(710)
return
;标签 =========================================
return
;<cm_OpenNewTab>: >>新建标签{{{2
<cm_OpenNewTab>:
    SendPos(3001)
return
;<cm_OpenNewTabBg>: >>新建标签(在后台){{{2
<cm_OpenNewTabBg>:
    SendPos(3002)
return
;<cm_OpenDirInNewTab>: >>新建标签(并打开光标处的文件夹){{{2
<cm_OpenDirInNewTab>:
    SendPos(3003)
return
;<cm_OpenDirInNewTabOther>: >>新建标签(在另一窗口打开文件夹){{{2
<cm_OpenDirInNewTabOther>:
    SendPos(3004)
return
;<cm_SwitchToNextTab>: >>下一个标签(Ctrl+Tab){{{2
<cm_SwitchToNextTab>:
    SendPos(3005)
return
;<cm_SwitchToPreviousTab>: >>上一个标签(Ctrl+Shift+Tab){{{2
<cm_SwitchToPreviousTab>:
    SendPos(3006)
return
;<cm_CloseCurrentTab>: >>关闭当前标签{{{2
<cm_CloseCurrentTab>:
    SendPos(3007)
return
;<cm_CloseAllTabs>: >>关闭所有标签{{{2
<cm_CloseAllTabs>:
    SendPos(3008)
return
;<cm_DirTabsShowMenu>: >>显示标签菜单{{{2
<cm_DirTabsShowMenu>:
    SendPos(3009)
return
;<cm_ToggleLockCurrentTab>: >>锁定/解锁当前标签{{{2
<cm_ToggleLockCurrentTab>:
    SendPos(3010)
return
;<cm_ToggleLockDcaCurrentTab>: >>锁定/解锁当前标签(可更改文件夹){{{2
<cm_ToggleLockDcaCurrentTab>:
    SendPos(3012)
return
;<cm_ExchangeWithTabs>: >>交换左右窗口及其标签{{{2
<cm_ExchangeWithTabs>:
    SendPos(535)
return
;<cm_GoToLockedDir>: >>转到锁定标签的根文件夹{{{2
<cm_GoToLockedDir>:
    SendPos(3011)
return
;<cm_SrcActivateTab1>: >>来源窗口: 激活标签 1{{{2
<cm_SrcActivateTab1>:
    SendPos(5001)
return
;<cm_SrcActivateTab2>: >>来源窗口: 激活标签 2{{{2
<cm_SrcActivateTab2>:
    SendPos(5002)
return
;<cm_SrcActivateTab3>: >>...{{{2
<cm_SrcActivateTab3>:
    SendPos(5003)
return
;<cm_SrcActivateTab4>: >>最多 99 个{{{2
<cm_SrcActivateTab4>:
    SendPos(5004)
return
;<cm_SrcActivateTab5>: >>5{{{2
<cm_SrcActivateTab5>:
    SendPos(5005)
return
;<cm_SrcActivateTab6>: >>6{{{2
<cm_SrcActivateTab6>:
    SendPos(5006)
return
;<cm_SrcActivateTab7>: >>7{{{2
<cm_SrcActivateTab7>:
    SendPos(5007)
return
;<cm_SrcActivateTab8>: >>8{{{2
<cm_SrcActivateTab8>:
    SendPos(5008)
return
;<cm_SrcActivateTab9>: >>9{{{2
<cm_SrcActivateTab9>:
    SendPos(5009)
return
;<cm_SrcActivateTab10>: >>0{{{2
<cm_SrcActivateTab10>:
    SendPos(5010)
return
;<cm_TrgActivateTab1>: >>目标窗口: 激活标签 1{{{2
<cm_TrgActivateTab1>:
    SendPos(5101)
return
;<cm_TrgActivateTab2>: >>目标窗口: 激活标签 2{{{2
<cm_TrgActivateTab2>:
    SendPos(5102)
return
;<cm_TrgActivateTab3>: >>...{{{2
<cm_TrgActivateTab3>:
    SendPos(5103)
return
;<cm_TrgActivateTab4>: >>最多 99 个{{{2
<cm_TrgActivateTab4>:
    SendPos(5104)
return
;<cm_TrgActivateTab5>: >>5{{{2
<cm_TrgActivateTab5>:
    SendPos(5105)
return
;<cm_TrgActivateTab6>: >>6{{{2
<cm_TrgActivateTab6>:
    SendPos(5106)
return
;<cm_TrgActivateTab7>: >>7{{{2
<cm_TrgActivateTab7>:
    SendPos(5107)
return
;<cm_TrgActivateTab8>: >>8{{{2
<cm_TrgActivateTab8>:
    SendPos(5108)
return
;<cm_TrgActivateTab9>: >>9{{{2
<cm_TrgActivateTab9>:
    SendPos(5109)
return
;<cm_TrgActivateTab10>: >>0{{{2
<cm_TrgActivateTab10>:
    SendPos(5110)
return
;<cm_LeftActivateTab1>: >>左窗口: 激活标签 1{{{2
<cm_LeftActivateTab1>:
    SendPos(5201)
return
;<cm_LeftActivateTab2>: >>左窗口: 激活标签 2{{{2
<cm_LeftActivateTab2>:
    SendPos(5202)
return
;<cm_LeftActivateTab3>: >>...{{{2
<cm_LeftActivateTab3>:
    SendPos(5203)
return
;<cm_LeftActivateTab4>: >>最多 99 个{{{2
<cm_LeftActivateTab4>:
    SendPos(5204)
return
;<cm_LeftActivateTab5>: >>5{{{2
<cm_LeftActivateTab5>:
    SendPos(5205)
return
;<cm_LeftActivateTab6>: >>6{{{2
<cm_LeftActivateTab6>:
    SendPos(5206)
return
;<cm_LeftActivateTab7>: >>7{{{2
<cm_LeftActivateTab7>:
    SendPos(5207)
return
;<cm_LeftActivateTab8>: >>8{{{2
<cm_LeftActivateTab8>:
    SendPos(5208)
return
;<cm_LeftActivateTab9>: >>9{{{2
<cm_LeftActivateTab9>:
    SendPos(5209)
return
;<cm_LeftActivateTab10>: >>0{{{2
<cm_LeftActivateTab10>:
    SendPos(5210)
return
;<cm_RightActivateTab1>: >>右窗口: 激活标签 1{{{2
<cm_RightActivateTab1>:
    SendPos(5301)
return
;<cm_RightActivateTab2>: >>右窗口: 激活标签 2{{{2
<cm_RightActivateTab2>:
    SendPos(5302)
return
;<cm_RightActivateTab3>: >>...{{{2
<cm_RightActivateTab3>:
    SendPos(5303)
return
;<cm_RightActivateTab4>: >>最多 99 个{{{2
<cm_RightActivateTab4>:
    SendPos(5304)
return
;<cm_RightActivateTab5>: >>5{{{2
<cm_RightActivateTab5>:
    SendPos(5305)
return
;<cm_RightActivateTab6>: >>6{{{2
<cm_RightActivateTab6>:
    SendPos(5306)
return
;<cm_RightActivateTab7>: >>7{{{2
<cm_RightActivateTab7>:
    SendPos(5307)
return
;<cm_RightActivateTab8>: >>8{{{2
<cm_RightActivateTab8>:
    SendPos(5308)
return
;<cm_RightActivateTab9>: >>9{{{2
<cm_RightActivateTab9>:
    SendPos(5309)
return
;<cm_RightActivateTab10>: >>0{{{2
<cm_RightActivateTab10>:
    SendPos(5310)
return
;排序 =========================================
return
;<cm_SrcSortByCol1>: >>来源窗口: 按第 1 列排序{{{2
<cm_SrcSortByCol1>:
    SendPos(6001)
return
;<cm_SrcSortByCol2>: >>来源窗口: 按第 2 列排序{{{2
<cm_SrcSortByCol2>:
    SendPos(6002)
return
;<cm_SrcSortByCol3>: >>...{{{2
<cm_SrcSortByCol3>:
    SendPos(6003)
return
;<cm_SrcSortByCol4>: >>最多 99 列{{{2
<cm_SrcSortByCol4>:
    SendPos(6004)
return
;<cm_SrcSortByCol5>: >>5{{{2
<cm_SrcSortByCol5>:
    SendPos(6005)
return
;<cm_SrcSortByCol6>: >>6{{{2
<cm_SrcSortByCol6>:
    SendPos(6006)
return
;<cm_SrcSortByCol7>: >>7{{{2
<cm_SrcSortByCol7>:
    SendPos(6007)
return
;<cm_SrcSortByCol8>: >>8{{{2
<cm_SrcSortByCol8>:
    SendPos(6008)
return
;<cm_SrcSortByCol9>: >>9{{{2
<cm_SrcSortByCol9>:
    SendPos(6009)
return
;<cm_SrcSortByCol10>: >>0{{{2
<cm_SrcSortByCol10>:
    SendPos(6010)
return
;<cm_SrcSortByCol99>: >>9{{{2
<cm_SrcSortByCol99>:
    SendPos(6099)
return
;<cm_TrgSortByCol1>: >>目标窗口: 按第 1 列排序{{{2
<cm_TrgSortByCol1>:
    SendPos(6101)
return
;<cm_TrgSortByCol2>: >>目标窗口: 按第 2 列排序{{{2
<cm_TrgSortByCol2>:
    SendPos(6102)
return
;<cm_TrgSortByCol3>: >>...{{{2
<cm_TrgSortByCol3>:
    SendPos(6103)
return
;<cm_TrgSortByCol4>: >>最多 99 列{{{2
<cm_TrgSortByCol4>:
    SendPos(6104)
return
;<cm_TrgSortByCol5>: >>5{{{2
<cm_TrgSortByCol5>:
    SendPos(6105)
return
;<cm_TrgSortByCol6>: >>6{{{2
<cm_TrgSortByCol6>:
    SendPos(6106)
return
;<cm_TrgSortByCol7>: >>7{{{2
<cm_TrgSortByCol7>:
    SendPos(6107)
return
;<cm_TrgSortByCol8>: >>8{{{2
<cm_TrgSortByCol8>:
    SendPos(6108)
return
;<cm_TrgSortByCol9>: >>9{{{2
<cm_TrgSortByCol9>:
    SendPos(6109)
return
;<cm_TrgSortByCol10>: >>0{{{2
<cm_TrgSortByCol10>:
    SendPos(6110)
return
;<cm_TrgSortByCol99>: >>9{{{2
<cm_TrgSortByCol99>:
    SendPos(6199)
return
;<cm_LeftSortByCol1>: >>左窗口: 按第 1 列排序{{{2
<cm_LeftSortByCol1>:
    SendPos(6201)
return
;<cm_LeftSortByCol2>: >>左窗口: 按第 2 列排序{{{2
<cm_LeftSortByCol2>:
    SendPos(6202)
return
;<cm_LeftSortByCol3>: >>...{{{2
<cm_LeftSortByCol3>:
    SendPos(6203)
return
;<cm_LeftSortByCol4>: >>最多 99 列{{{2
<cm_LeftSortByCol4>:
    SendPos(6204)
return
;<cm_LeftSortByCol5>: >>5{{{2
<cm_LeftSortByCol5>:
    SendPos(6205)
return
;<cm_LeftSortByCol6>: >>6{{{2
<cm_LeftSortByCol6>:
    SendPos(6206)
return
;<cm_LeftSortByCol7>: >>7{{{2
<cm_LeftSortByCol7>:
    SendPos(6207)
return
;<cm_LeftSortByCol8>: >>8{{{2
<cm_LeftSortByCol8>:
    SendPos(6208)
return
;<cm_LeftSortByCol9>: >>9{{{2
<cm_LeftSortByCol9>:
    SendPos(6209)
return
;<cm_LeftSortByCol10>: >>0{{{2
<cm_LeftSortByCol10>:
    SendPos(6210)
return
;<cm_LeftSortByCol99>: >>9{{{2
<cm_LeftSortByCol99>:
    SendPos(6299)
return
;<cm_RightSortByCol1>: >>右窗口: 按第 1 列排序{{{2
<cm_RightSortByCol1>:
    SendPos(6301)
return
;<cm_RightSortByCol2>: >>右窗口: 按第 2 列排序{{{2
<cm_RightSortByCol2>:
    SendPos(6302)
return
;<cm_RightSortByCol3>: >>...{{{2
<cm_RightSortByCol3>:
    SendPos(6303)
return
;<cm_RightSortByCol4>: >>最多 99 列{{{2
<cm_RightSortByCol4>:
    SendPos(6304)
return
;<cm_RightSortByCol5>: >>5{{{2
<cm_RightSortByCol5>:
    SendPos(6305)
return
;<cm_RightSortByCol6>: >>6{{{2
<cm_RightSortByCol6>:
    SendPos(6306)
return
;<cm_RightSortByCol7>: >>7{{{2
<cm_RightSortByCol7>:
    SendPos(6307)
return
;<cm_RightSortByCol8>: >>8{{{2
<cm_RightSortByCol8>:
    SendPos(6308)
return
;<cm_RightSortByCol9>: >>9{{{2
<cm_RightSortByCol9>:
    SendPos(6309)
return
;<cm_RightSortByCol10>: >>0{{{2
<cm_RightSortByCol10>:
    SendPos(6310)
return
;<cm_RightSortByCol99>: >>9{{{2
<cm_RightSortByCol99>:
    SendPos(6399)
return
;自定义列视图 =========================================
return
;<cm_SrcCustomView1>: >>来源窗口: 自定义列视图 1{{{2
<cm_SrcCustomView1>:
    SendPos(271)
return
;<cm_SrcCustomView2>: >>来源窗口: 自定义列视图 2{{{2
<cm_SrcCustomView2>:
    SendPos(272)
return
;<cm_SrcCustomView3>: >>...{{{2
<cm_SrcCustomView3>:
    SendPos(273)
return
;<cm_SrcCustomView4>: >>最多 29 个{{{2
<cm_SrcCustomView4>:
    SendPos(274)
return
;<cm_SrcCustomView5>: >>5{{{2
<cm_SrcCustomView5>:
    SendPos(275)
return
;<cm_SrcCustomView6>: >>6{{{2
<cm_SrcCustomView6>:
    SendPos(276)
return
;<cm_SrcCustomView7>: >>7{{{2
<cm_SrcCustomView7>:
    SendPos(277)
return
;<cm_SrcCustomView8>: >>8{{{2
<cm_SrcCustomView8>:
    SendPos(278)
return
;<cm_SrcCustomView9>: >>9{{{2
<cm_SrcCustomView9>:
    SendPos(279)
return
;<cm_LeftCustomView1>: >>左窗口: 自定义列视图 1{{{2
<cm_LeftCustomView1>:
    SendPos(710)
return
;<cm_LeftCustomView2>: >>左窗口: 自定义列视图 2{{{2
<cm_LeftCustomView2>:
    SendPos(72)
return
;<cm_LeftCustomView3>: >>...{{{2
<cm_LeftCustomView3>:
    SendPos(73)
return
;<cm_LeftCustomView4>: >>最多 29 个{{{2
<cm_LeftCustomView4>:
    SendPos(74)
return
;<cm_LeftCustomView5>: >>5{{{2
<cm_LeftCustomView5>:
    SendPos(75)
return
;<cm_LeftCustomView6>: >>6{{{2
<cm_LeftCustomView6>:
    SendPos(76)
return
;<cm_LeftCustomView7>: >>7{{{2
<cm_LeftCustomView7>:
    SendPos(77)
return
;<cm_LeftCustomView8>: >>8{{{2
<cm_LeftCustomView8>:
    SendPos(78)
return
;<cm_LeftCustomView9>: >>9{{{2
<cm_LeftCustomView9>:
    SendPos(79)
return
;<cm_RightCustomView1>: >>右窗口: 自定义列视图 1{{{2
<cm_RightCustomView1>:
    SendPos(171)
return
;<cm_RightCustomView2>: >>右窗口: 自定义列视图 2{{{2
<cm_RightCustomView2>:
    SendPos(172)
return
;<cm_RightCustomView3>: >>...{{{2
<cm_RightCustomView3>:
    SendPos(173)
return
;<cm_RightCustomView4>: >>最多 29 个{{{2
<cm_RightCustomView4>:
    SendPos(174)
return
;<cm_RightCustomView5>: >>5{{{2
<cm_RightCustomView5>:
    SendPos(175)
return
;<cm_RightCustomView6>: >>6{{{2
<cm_RightCustomView6>:
    SendPos(176)
return
;<cm_RightCustomView7>: >>7{{{2
<cm_RightCustomView7>:
    SendPos(177)
return
;<cm_RightCustomView8>: >>8{{{2
<cm_RightCustomView8>:
    SendPos(178)
return
;<cm_RightCustomView9>: >>9{{{2
<cm_RightCustomView9>:
    SendPos(179)
return
;<cm_SrcNextCustomView>: >>来源窗口: 下一个自定义视图{{{2
<cm_SrcNextCustomView>:
    SendPos(5501)
return
;<cm_SrcPrevCustomView>: >>来源窗口: 上一个自定义视图{{{2
<cm_SrcPrevCustomView>:
    SendPos(5502)
return
;<cm_TrgNextCustomView>: >>目标窗口: 下一个自定义视图{{{2
<cm_TrgNextCustomView>:
    SendPos(5503)
return
;<cm_TrgPrevCustomView>: >>目标窗口: 上一个自定义视图{{{2
<cm_TrgPrevCustomView>:
    SendPos(5504)
return
;<cm_LeftNextCustomView>: >>左窗口: 下一个自定义视图{{{2
<cm_LeftNextCustomView>:
    SendPos(5505)
return
;<cm_LeftPrevCustomView>: >>左窗口: 上一个自定义视图{{{2
<cm_LeftPrevCustomView>:
    SendPos(5506)
return
;<cm_RightNextCustomView>: >>右窗口: 下一个自定义视图{{{2
<cm_RightNextCustomView>:
    SendPos(5507)
return
;<cm_RightPrevCustomView>: >>右窗口: 上一个自定义视图{{{2
<cm_RightPrevCustomView>:
    SendPos(5508)
return
;<cm_LoadAllOnDemandFields>: >>所有文件都按需加载备注{{{2
<cm_LoadAllOnDemandFields>:
    SendPos(5512)
return
;<cm_LoadSelOnDemandFields>: >>仅选中的文件按需加载备注{{{2
<cm_LoadSelOnDemandFields>:
    SendPos(5513)
return
;<cm_ContentStopLoadFields>: >>停止后台加载备注{{{2
<cm_ContentStopLoadFields>:
    SendPos(5514)
return
;<cm_GoToFirstEntry>: >>光标移到列表中的第一个文件或目录{{{2
<cm_GoToFirstEntry>:
    SendPos(2049)
return
;<cm_FocusSrc>: >>光标切换至源面板{{{2
<cm_FocusSrc>:
    SendPos(4005)
return
;<cm_FocusTrg>: >>光标切换至目标面板{{{2
<cm_FocusTrg>:
    SendPos(4006)
return
