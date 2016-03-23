VimDConfig:
    vim.SetPlugin("VimDConfig", "Array", "0.1", "VimDesktop的配置界面")
    vim.SetAction("<vc_plugin>", "显示 VimDesktop 插件信息")
    vim.SetAction("<vc_keymap>", "显示 VimDesktop 热键信息")
return

<vc_plugin>:
{
    GUI, VimDConfig_plugin:Destroy
    GUI, VimDConfig_plugin:Default
    GUI, VimDConfig_plugin:Font, s10, Microsoft YaHei
    GUI, VimDConfig_plugin:Add, ListView, x10 y10 w150 h400 grid altsubmit gVimDConfig_LoadActions, 插件
    for plugin, obj in vim.PluginList
        LV_Add("", plugin)
    GUI, VimDConfig_plugin:Add, ListView, glistview x170 y10 w650 h400 grid altsubmit, 序号|动作|描述（双击进入文件）

    GUI, VimDConfig_plugin:Font, s12, Microsoft YaHei
    GUI, VimDConfig_plugin:Add, Text, x180 h25, 搜索：
    GUI, VimDConfig_plugin:Font, s10, Microsoft YaHei
    GUI, VimDConfig_plugin:Add, Edit, gsearch_plugin v_search x+10 w120 h25

    LV_ModifyCol(1, "center")
    LV_ModifyCol(2, "left 250")
    LV_ModifyCol(3, "left 400")
    GUI, VimDConfig_plugin:Show
    return
}

VimDConfig_LoadActions:
{
    If A_GuiEvent = I
    {
        if not InStr(ErrorLevel, "S", true)
        {
            return
        }

        GUI, VimDConfig_plugin:ListView, sysListview321
        LV_GetText(plugin, A_EventInfo)
        GUI, VimDConfig_plugin:Default
        GUI, VimDConfig_plugin:ListView, sysListview322
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
    return
}

<vc_keymap>:
{
    menu, VimDConfig_keymap_menu, add
    ;menu, VimDConfig_keymap_menu, deleteall
    menu, VimDConfig_keymap_menu, add, &Exit, VimDConfig_keymap_exit

    GUI, VimDConfig_keymap:Destroy
    GUI, VimDConfig_keymap:Default
    GUI, VimDConfig_keymap:Font, s10, Microsoft YaHei

    GUI, VimDConfig_keymap:Add, GroupBox, x10 y10 w300 h270, 窗口(&Q)
    GUI, VimDConfig_keymap:Add, ListBox, x20 y36 w180 R12 center gVimDConfig_keymap_loadmodelist

    GUI, VimDConfig_keymap:Add, GroupBox, x10 y290  w200 h140, 模式(&M)
    GUI, VimDConfig_keymap:Add, ListBox, x20 y316  w180 R5 center gVimDConfig_keymap_loadhotkey

    GUI, VimDConfig_keymap:Add, GroupBox, x225 y10 w650 h420, 热键定义（双击进入对应文件，右键双击修改键映射）(&V)
    GUI, VimDConfig_keymap:Add, Listview, glistview x235 y36 w630 h380 grid, 热键|动作|描述
    ;GUI, VimDConfig_keymap:Add, Listview, glistview x235 y36 w630 h380 grid, 序号|热键|动作|描述
    GUI, VimDConfig_keymap:Font, s12, Microsoft YaHei
    GUI, VimDConfig_keymap:Add, Text, x230 h25, 搜索：
    GUI, VimDConfig_keymap:Font, s10, Microsoft YaHei
    GUI, VimDConfig_keymap:Add, Edit, gsearch_keymap v_search x+10 w120 h25

    /*
    LV_ModifyCol(1, "left 50")
    LV_ModifyCol(2, "left 100")
    LV_ModifyCol(3, "left 250")
    LV_ModifyCol(4, "left 400")
    */

    LV_ModifyCol(1, "left 100")
    LV_ModifyCol(2, "left 250")
    LV_ModifyCol(3, "left 400")

    VimDConfig_keymap_loadwinlist()
    VimDConfig_keymap_loadhotkey(VimDConfig_keymap_loadmodelist(thiswin))

    GUI, VimDConfig_keymap:show
    return
}

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
    for mode, obj in winobj.modeList
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

/*
; 有Bug，暂时搁置
; 双击进入代码失效
; 插件名和Win名不对应的情况显示不出来
VimDConfig_keymap_loadhotkey_new(win, mode = "")
{
    global vim
    global current_keymap := ""
    if StrLen(mode)
    {
        winObj  := vim.GetWin(win)
        modeobj := winObj.modeList[mode]
    }
    else
        modeobj := vim.GetMode(win)
    Gui, VimDConfig_keymap:Default
    idx := 1
    LV_Delete()

    for key, i in modeobj.keymapList
    {
        if (vim.GetAction(i).Type = 1)
        {
            ActionDescList := vim.GetAction(i).Comment
            actionDesc := StrSplit(%ActionDescList%[key], "|")
            current_keymap .= Key "`t" actionDesc[1]  "`n"
        }
        else
        {
            current_keymap .= Key "`t" i  "`n"
        }
    }

    Clipboard := current_keymap
    for action, type in vim.ActionFromPlugin
    {
        if type = %win%
        {
            Desc := vim.GetAction(action)
            if InStr(current_keymap, action)
            {
                reg:="(.*)\t" . action
                Loop, Parse, current_keymap, `n, `r
                {
                    if RegExMatch(A_LoopField, reg,m)
                    {
                        LV_Add("", idx, m1 ,action, Desc.Comment)
                        break
                    }
                    else
                        continue
                }
                idx++
            }
            else
            {
                LV_Add("", idx, "无" ,action, Desc.Comment)
                idx++
            }
        }
    }
    return
}
*/

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
            LV_Add("", Key, i, vim.GetAction(i).Comment)
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
    if (Action = "key" || Action = "run" || Action = "dir" || EditKeyMapping)
    {
        SearchLine := "=" Action

        if (Action = "key" || Action = "run" || Action = "dir")
        {
            SearchLine := Action "|" Desc
        }

        Loop, Read, %A_ScriptDir%\vimd.ini
        {
            if (InStr(A_LoopReadLine, SearchLine))
            {
                EditFile(A_ScriptDir "\vimd.ini", A_Index)
                return
            }
        }

        EditFile(A_ScriptDir "\vimd.ini")
        return
    }

    label := Action ":"
    Loop, %A_ScriptDir%\plugins\*.ahk, , 1
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
        MsgBox, 请配置 vimd.ini 中 [config] 中的 editor ，并重启 vimd ！
        return
    }

    ; 根据编辑器 exe 名称获取打开参数
    SplitPath, editor, , , OutExtension, OutNameNoExt
    args := editorArgs[OutNameNoExt]
    StringReplace, args, args, $line, %line%
    StringReplace, args, args, $file, "%editPath%"
    target := editor " " args
    if (OutExtension = "sh")
    {
        target := "sh.exe " target
    }

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
