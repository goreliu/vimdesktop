VimDConfig:
    vim.SetPlugin("VimDConfig", "Array", "0.1", "VimDesktop的配置界面")
    vim.SetAction("<vc_plugin>", "打开VimDesktop配置界面")
    vim.SetAction("<vc_keymap>", "打开VimDesktop配置界面")
return

/*
<vc_config>:
    menu, VimDConfig_menu, add
    menu, VimDConfig_menu, deleteall
    menu, VimDConfig_menu, add, &Exit, <vc_keymap>
    GUI, VimDConfig:Destroy
    GUI, VimDConfig:Default
    GUI, VimDConfig:Menu, VimDConfig_menu
    GUI, VimDConfig:Add, StatusBar
    GUI, VimDConfig:Show, w700 h500
return

<vc_keymap2>:
{
    GUI, VimDConfig_keymap:Destroy
    GUI, VimDConfig_keymap:Default
    GUI, VimDConfig_keymap:Font, s10, Microsoft YaHei
    GUI, VimDConfig_keymap:Add, Text, x10 y13, 热键(&K)
    GUI, VimDConfig_keymap:Add, Edit, x70 y10 w240 r1
    GUI, VimDConfig_keymap:Add, Button, x320 y8 w30 h30, &?
    GUI, VimDConfig_keymap:Add, Text, x10 y48, 动作(&L)
    GUI, VimDConfig_keymap:Add, Edit, x70 y45 w240 r1
    GUI, VimDConfig_keymap:Add, Button, x320 y43 w30 h30 g<vc_plugin>, &!
    ;GUI, VimDConfig_keymap:Add, Button, x575 y350 w60 h65, 保存(&S)
    GUI, VimDConfig_keymap:show
    return
}
*/

<vc_plugin>:
{
    plist := ""
    GUI, VimDConfig_plugin:Destroy
    GUI, VimDConfig_plugin:Default
    GUI, VimDConfig_plugin:Font, s10, Microsoft YaHei
    GUI, VimDConfig_plugin:Add, ListView, x10 y10 w150 h400 grid altsubmit gVimDConfig_LoadActions, 插件
    for plugin, obj in vim.pluginlist
        LV_Add("", plugin)
    GUI, VimDConfig_plugin:Add, ListView, x170 y10 w650 h400 grid altsubmit, 序号|动作|描述
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

    GUI, VimDConfig_keymap:Add, GroupBox, x225 y10 w650 h420, 热键定义(&V)
    GUI, VimDConfig_keymap:Add, Listview, x235 y36 w630 h380 grid, 热键|动作|描述
/*
    GUI, VimDConfig_keymap:Add, Text, x235 y309, 过滤(&F)
    GUI, VimDConfig_keymap:Add, Edit, x290 y307 w160 r1

    GUI, VimDConfig_keymap:Add, Button, x465 y305 w80, 添加(&A)
    GUI, VimDConfig_keymap:Add, Button, x555 y305 w80, 删除(&D)

    GUI, VimDConfig_keymap:Add, Text, x235 y353, 热键(&K)
    GUI, VimDConfig_keymap:Add, Edit, x290 y350 w240 r1
    GUI, VimDConfig_keymap:Add, Text, x235 y390, 动作(&L)
    GUI, VimDConfig_keymap:Add, Edit, x290 y387 w240 r1

    GUI, VimDConfig_keymap:Add, Button, x535 y350 w30 h30 ;gVimDConfig_keymap_exit, &?
    GUI, VimDConfig_keymap:Add, Button, x535 y385 w30 h30 g<vc_plugin>, &>
    GUI, VimDConfig_keymap:Add, Button, x575 y350 w60 h65 ;, 保存(&S)

    GUI, VimDConfig_keymap:Add, Statusbar
    GUI, VimDConfig_keymap:Menu, VimDConfig_keymap_menu
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
    for win, obj in vim.WinList {
        if vim.ExcludeWinList[win]{
            continue
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
    ControlGet, mode, Choice, , ListBox2
    VimDConfig_keymap_loadhotkey(win, mode)
return

VimDConfig_keymap_loadhotkey(win, mode = "")
{
    global vim
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
        LV_Add("", Key, i, vim.GetAction(i).comment)
}
