VimConfig:
    vim.SetPlugin("VimConfig", "Array", "0.1", "VimDesktop的配置界面")
    vim.SetAction("<vc_plugin>", "打开VimDesktop配置界面")
    vim.SetAction("<vc_keymap>", "打开VimDesktop配置界面")
return

/*
<vc_config>:
    menu, vimconfig_menu, add
    menu, vimconfig_menu, deleteall
    menu, vimconfig_menu, add, &Exit, <vc_keymap>
    GUI, vimconfig:Destroy
    GUI, vimconfig:Default
    GUI, vimconfig:Menu, vimconfig_menu
    GUI, vimconfig:Add, StatusBar
    GUI, vimconfig:Show, w700 h500
return

<vc_keymap2>:
{
    GUI, vimconfig_keymap:Destroy
    GUI, vimconfig_keymap:Default
    GUI, vimconfig_keymap:Font, s10, Microsoft YaHei
    GUI, vimconfig_keymap:Add, Text, x10 y13, 热键(&K)
    GUI, vimconfig_keymap:Add, Edit, x70 y10 w240 r1
    GUI, vimconfig_keymap:Add, Button, x320 y8 w30 h30, &?
    GUI, vimconfig_keymap:Add, Text, x10 y48, 动作(&L)
    GUI, vimconfig_keymap:Add, Edit, x70 y45 w240 r1
    GUI, vimconfig_keymap:Add, Button, x320 y43 w30 h30 g<vc_plugin>, &!
    ;GUI, vimconfig_keymap:Add, Button, x575 y350 w60 h65, 保存(&S)
    GUI, vimconfig_keymap:show
    return
}
*/

<vc_plugin>:
{
    plist := ""
    GUI, vimconfig_plugin:Destroy
    GUI, vimconfig_plugin:Default
    GUI, vimconfig_plugin:Font, s10, Microsoft YaHei
    GUI, vimconfig_plugin:Add, ListView, x10   y10 w150 h400 grid  altsubmit gvimconfig_LoadActions, 插件
    for plugin, obj in vim.pluginlist
        LV_Add("", plugin)
    GUI, vimconfig_plugin:Add, ListView, x170 y10 w500 h400 grid  altsubmit, 序号|动作|描述
    LV_ModifyCol(1, "center")
    LV_ModifyCol(2, "left 200")
    LV_ModifyCol(3, "left 400")
    GUI, vimconfig_plugin:Show
    return
}

vimconfig_LoadActions:
{
    If A_GuiEvent = I
    {
        GUI, vimconfig_plugin:ListView, sysListview321
        LV_GetText(plugin, A_EventInfo)
        GUI, vimconfig_plugin:Default
        GUI, vimconfig_plugin:ListView, sysListview322
        idx:=1
        LV_Delete()
        for action, type in vim.ActionFromPlugin
        {
            If type = %plugin%
            {
                Desc := vim.GetAction(action)
                LV_Add("", idx, action, Desc.Comment)
                idx++
            }
        }
    }
    return
}

<vc_keymap>:
{
    menu, vimconfig_keymap_menu, add
    ;menu, vimconfig_keymap_menu, deleteall
    menu, vimconfig_keymap_menu, add, &Exit, vimconfig_keymap_exit

    GUI, vimconfig_keymap:Destroy
    GUI, vimconfig_keymap:Default
    GUI, vimconfig_keymap:Font, s10, Microsoft YaHei

    GUI, vimconfig_keymap:Add, GroupBox, x10 y10 w200 h270, 窗口(&Q)
    GUI, vimconfig_keymap:Add, ListBox, x20 y36 w180 R12 center gvimconfig_keymap_loadmodelist

    GUI, vimconfig_keymap:Add, GroupBox, x10 y290  w200 h140, 模式(&M)
    GUI, vimconfig_keymap:Add, ListBox, x20 y316  w180 R5 center gvimconfig_keymap_loadhotkey

    GUI, vimconfig_keymap:Add, GroupBox, x225 y10 w420 h420, 热键定义(&V)
    GUI, vimconfig_keymap:Add, Listview, x235 y36 w630 h380 grid, 热键|动作|描述
/*
    GUI, vimconfig_keymap:Add, Text, x235 y309, 过滤(&F)
    GUI, vimconfig_keymap:Add, Edit, x290 y307 w160 r1

    GUI, vimconfig_keymap:Add, Button, x465 y305 w80, 添加(&A)
    GUI, vimconfig_keymap:Add, Button, x555 y305 w80, 删除(&D)

    GUI, vimconfig_keymap:Add, Text, x235 y353, 热键(&K)
    GUI, vimconfig_keymap:Add, Edit, x290 y350 w240 r1
    GUI, vimconfig_keymap:Add, Text, x235 y390, 动作(&L)
    GUI, vimconfig_keymap:Add, Edit, x290 y387 w240 r1

    GUI, vimconfig_keymap:Add, Button, x535 y350 w30 h30 ;gvimconfig_keymap_exit, &?
    GUI, vimconfig_keymap:Add, Button, x535 y385 w30 h30 g<vc_plugin>, &>
    GUI, vimconfig_keymap:Add, Button, x575 y350 w60 h65 ;, 保存(&S)

    GUI, vimconfig_keymap:Add, Statusbar
    GUI, vimconfig_keymap:Menu, vimconfig_keymap_menu
*/

    LV_ModifyCol(1, "left 100")
    LV_ModifyCol(2, "left 250")
    LV_ModifyCol(3, "left 250")

    vimconfig_keymap_loadwinlist()
    vimconfig_keymap_loadhotkey(vimconfig_keymap_loadmodelist(thiswin))

    GUI, vimconfig_keymap:show
    return
}

vimconfig_keymap_exit:
{
    GUI, vimconfig_keymap:Destroy
    return
}

vimconfig_keymap_loadwinlist()
{
    global vim
    list := "|全局"
    GUI, vimconfig_keymap:Default
    for win, obj in vim.winlist
        list .= "|" win
    GuiControl, , ListBox1, %list%
}
vimconfig_keymap_loadmodelist:
    vimconfig_keymap_loadmodelist()
    GUI, vimconfig_keymap:Default
    LV_delete()
return

vimconfig_keymap_loadmodelist(win="")
{
    global vim
    GUI, vimconfig_keymap:Default
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

vimconfig_keymap_loadhotkey:
    GUI, vimconfig_keymap:Default
    ControlGet, win, Choice, , ListBox1
    win := RegExMatch(win, "^全局$") ? "" : win
    ControlGet, mode, Choice, , ListBox2
    vimconfig_keymap_loadhotkey(win, mode)
return

vimconfig_keymap_loadhotkey(win, mode="")
{
    global vim
    If strlen(mode)
    {
        winObj  := vim.GetWin(win)
        modeobj := winObj.modeList[mode]
    }
    Else
        modeobj := vim.GetMode(win)
    GUI, vimconfig_keymap:Default
    LV_delete()
    for key, i in modeobj.keymapList
        LV_Add("", Key, i, vim.GetAction(i).comment)
}
