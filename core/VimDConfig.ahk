VimDConfig:
    vim.SetPlugin("VimDConfig", "Array", "0.1", "VimDesktop的配置界面")
    vim.SetAction("<VimDConfig_Plugin>", "显示 VimDesktop 插件信息")
    vim.SetAction("<VimDConfig_Keymap>", "显示 VimDesktop 热键信息")
    vim.SetAction("<VimDConfig_EditConfig>", "打开 VimDesktop 配置文件")
return

<VimDConfig_Plugin>:
    GUI, VimDConfig_plugin:Destroy
    GUI, VimDConfig_plugin:Default
    GUI, VimDConfig_plugin:Font, s10, Microsoft YaHei

    GUI, VimDConfig_plugin:Add, GroupBox, x10 y460 w170 h70, 过滤 &F
    GUI, VimDConfig_plugin:Add, Edit, x20 y490 gsearch_plugin v_search

    GUI, VimDConfig_plugin:Add, GroupBox, x190 y10 w650 h520, 动作 &A
    GUI, VimDConfig_plugin:Add, ListView, glistview x200 y35 w630 h482 grid altsubmit, 序号|动作|描述（双击进入文件）

    LV_ModifyCol(1, "center")
    LV_ModifyCol(2, "left 250")
    LV_ModifyCol(3, "left 320")

    ; 先创建右边的 ListView，再创建左边的 ListView，否则 LV_Modify 时会出问题。
    GUI, VimDConfig_plugin:Add, GroupBox, x10 y10 w170 h440, 插件 &P
    GUI, VimDConfig_plugin:Add, ListView, x20 y35 w150 h400 grid altsubmit gVimDConfig_LoadActions, 名称

    for plugin, obj in vim.PluginList
        LV_Add("", plugin)

    LV_Modify(1, "Select")

    GUI, VimDConfig_plugin:Show
return

<VimDConfig_Keymap>:
    menu, VimDConfig_keymap_menu, add
    menu, VimDConfig_keymap_menu, add, &Exit, VimDConfig_keymap_exit

    GUI, VimDConfig_keymap:Destroy
    GUI, VimDConfig_keymap:Default
    GUI, VimDConfig_keymap:Font, s10, Microsoft YaHei

    GUI, VimDConfig_keymap:Add, GroupBox, x10 y10 w200 h269, 插件 &P
    GUI, VimDConfig_keymap:Add, ListBox, x20 y35 w180 R12 center gVimDConfig_keymap_loadmodelist

    GUI, VimDConfig_keymap:Add, GroupBox, x10 y290 w200 h135, 模式 &M
    GUI, VimDConfig_keymap:Add, ListBox, x20 y315 w180 R5 center gVimDConfig_keymap_loadhotkey

    GUI, VimDConfig_keymap:Add, GroupBox, x10 y435 w200 h61, 过滤 &F
    GUI, VimDConfig_keymap:Add, Edit, gsearch_keymap v_search x20 y460 w180 h25

    GUI, VimDConfig_keymap:Add, GroupBox, x225 y10 w650 h486, 映射 &K
    GUI, VimDConfig_keymap:Add, Listview, glistview x235 y36 w630 h450 grid, 热键|动作（双击定位，右键双击编辑）|描述

    LV_ModifyCol(1, "left 100")
    LV_ModifyCol(2, "left 250")
    LV_ModifyCol(3, "left 259")

    VimDConfig_keymap_loadwinlist()
    VimDConfig_keymap_loadhotkey(VimDConfig_keymap_loadmodelist(thiswin))

    GUI, VimDConfig_keymap:Show
    ControlFocus, Edit1, A
return

<VimDConfig_EditConfig>:
    Run, %ConfigPath%
return

VimDConfig_LoadActions:
    If A_GuiEvent = I
    {
        if not InStr(ErrorLevel, "S", true)
        {
            return
        }

        GUI, VimDConfig_plugin:ListView, sysListview322
        LV_GetText(plugin, A_EventInfo)
        GUI, VimDConfig_plugin:Default
        GUI, VimDConfig_plugin:ListView, sysListview321
        idx := 1
        LV_Delete()

        global current_plugin := ""
        for action, type in vim.ActionFromPlugin
        {
            If type = %plugin%
            {
                Desc := vim.GetAction(action)
                LV_Add("", idx, action, Desc.Comment)
                current_plugin .= idx "`t" action "`t" Desc.Comment "`n"
                idx++
            }
        }
    }

    ControlFocus, Edit1, A
return

VimDConfig_keymap_exit:
{
    GUI, VimDConfig_keymap:Destroy
    return
}

VimDConfig_keymap_loadwinlist()
{
    global vim
    list := "|全局"
    GUI, VimDConfig_keymap:Default
    for win, obj in vim.WinList
    {
        if vim.ExcludeWinList[win]
        {
            continue
        }

        ; Convert class name TTOTAL_CMD to plugin name TotalCommander
        if (win = "TTOTAL_CMD")
        {
            win := "TotalCommander"
        }
        list .= "|" win
    }
    GuiControl, , ListBox1, %list%
}

VimDConfig_keymap_loadmodelist:
    VimDConfig_keymap_loadmodelist()
    GUI, VimDConfig_keymap:Default
    LV_delete()
    GuiControl, Choose, ListBox2, |normal
    ControlFocus, Edit1, A
return

VimDConfig_keymap_loadmodelist(win = "")
{
    global vim
    GUI, VimDConfig_keymap:Default
    If not strlen(win)
        ControlGet, win, Choice, , ListBox1
    If win = 全局
        winObj := vim.GetWin()
    Else
        winObj := vim.GetWin(win)
    for mode, obj in winObj.modeList
        mlist .= "|" mode
    GuiControl, , ListBox2, %mlist%
    return win
}

VimDConfig_keymap_loadhotkey:
    GUI, VimDConfig_keymap:Default
    ControlGet, win, Choice, , ListBox1
    win := RegExMatch(win, "^全局$") ? "" : win

    ; Convert plugin name TotalCommander to class name TTOTAL_CMD
    if (win = "TotalCommander")
    {
        win := "TTOTAL_CMD"
    }

    ControlGet, mode, Choice, , ListBox2
    VimDConfig_keymap_loadhotkey(win, mode)
return

VimDConfig_keymap_loadhotkey(win, mode = "")
{
    global vim
    global current_keymap := ""
    If strlen(mode)
    {
        winObj  := vim.GetWin(win)
        modeobj := winObj.modeList[mode]
    }
    Else
        modeobj := vim.GetMode(win)
    GUI, VimDConfig_keymap:Default
    LV_delete()
    for key, i in modeobj.keymapList
    {
        ; Type = 1 : Function
        if (vim.GetAction(i).Type = 1)
        {
            ActionDescList := vim.GetAction(i).Comment
            actionDesc := StrSplit(%ActionDescList%[key], "|")
            LV_ADD("", Key, actionDesc[1], actionDesc[2])
            current_keymap .= Key "`t" actionDesc[1] "`t" actionDesc[2] "`n"
        }
        else
        {
            LV_Add("", RegExReplace(Key, "<S-(.*)>", "$1"), i, vim.GetAction(i).Comment)
            current_keymap .= Key "`t" i "`t" vim.GetAction(i).Comment "`n"
        }
    }
}

listview:
    if A_GuiEvent = DoubleClick
    {
        ;~ ToolTip You double-clicked row number %A_EventInfo%.
        LV_GetText(SelectedAction, A_EventInfo, 2)
        LV_GetText(SelectedDesc, A_EventInfo, 3)
        SearchFileForEdit(SelectedAction, SelectedDesc, false)
    }
    else if A_GuiEvent = R
    {
        LV_GetText(SelectedAction, A_EventInfo, 2)
        LV_GetText(SelectedDesc, A_EventInfo, 3)
        SearchFileForEdit(SelectedAction, SelectedDesc, true)
    }
return

SearchFileForEdit(Action, Desc, EditKeyMapping)
{
    IsUserCmd := RegExMatch(Action, "^(run|key|dir|tccmd|wshkey)$")
    if (IsUserCmd || EditKeyMapping)
    {
        SearchLine := "=" Action
        if (IsUserCmd || Action == "function")
        {
            SearchLine := Action "|" Desc
        }

        Loop, Read, %ConfigPath%
        {
            if (InStr(A_LoopReadLine, SearchLine))
            {
                EditFile(%ConfigPath%, A_Index)
                return
            }
        }

        EditFile(%ConfigPath%)
        return
    }

    label := Action ":"
    if (Action == "function")
    {
        label := Desc
    }

    Loop, %A_ScriptDir%\plugins\*.ahk, , 1
    {
        Loop, Read, %A_LoopFileFullPath%
        {
            if (InStr(A_LoopReadLine, label) == 1)
            {
                EditFile(A_LoopFileFullPath, A_Index)
                return
            }
        }
    }

    Loop, %A_ScriptDir%\core\*.ahk, , 1
    {
        Loop, Read, %A_LoopFileFullPath%
        {
            if (InStr(A_LoopReadLine, label) = 1)
            {
                EditFile(A_LoopFileFullPath, A_Index)
                return
            }
        }
    }
}

EditFile(editPath, line := 1)
{
    editorArgs := {}
    editorArgs["notepad"] := "/g $line $file"
    editorArgs["notepad2"] := "/g $line $file"
    editorArgs["sublime_text"] := "$file:$line"
    editorArgs["vim"] := "+$line $file"
    editorArgs["gvim"] := "--remote-silent-tab +$line $file"
    editorArgs["everedit"] := "-n$line $file"
    editorArgs["notepad++"] := "-n$line $file"
    editorArgs["EmEditor"] := "-l $line $file"
    editorArgs["uedit32"] := "$file/$line"
    editorArgs["Editplus"] := "$file -cursor $line"
    editorArgs["textpad"] := "$file($line)"
    editorArgs["pspad"] := "$file /$line"
    editorArgs["ConTEXT"] := "$file /g1:$line"
    editorArgs["scite"] := "$file -goto:$line"

    Global editor
    
    If not FileExist(editor)
    {
        MsgBox, 请配置 %ConfigPath% 中 [config] 中的 editor ，并重启 vimd ！
        return
    }

    ; 根据编辑器 exe 名称获取打开参数
    SplitPath, editor, , , OutExtension, OutNameNoExt
    args := editorArgs[OutNameNoExt]
    StringReplace, args, args, $line, %line%
    StringReplace, args, args, $file, "%editPath%"
    target := editor " " args

    run, %target%
}

search_keymap:
    global current_keymap
    search_to_display(current_keymap)
return

search_plugin:
    global current_plugin
    search_to_display(current_plugin)
return

search_to_display(lines)
{
    Gui Submit, nohide
    GuiControlGet, OutputVar, , _search

    text := StrSplit(lines, "`n")

    LV_Delete() ; 清理不掉，第二次加载后，都成了重复的了，不知道怎么处理
    GuiControl, -Redraw, listview ; 重新启用重绘 (上面把它禁用了)
    for k, v in text
    {
        if v =
            continue
        if Instr(v, OutputVar)
        {
            list := StrSplit(v, "`t")
            LV_Add("", list[1], list[2], list[3])
        }
    }
    GuiControl, +Redraw, listview ; 重新启用重绘 (上面把它禁用了)
}
