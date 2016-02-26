foobar2000:
    global foobar2000_class := "{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}"
    global foobar2000_list_classnn := "{4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1"

    ;vim.comment("<foobar2000_NormalMode>", "进入normal模式")
    ;vim.comment("<foobar2000_InsertMode>", "进入insert模式")
    vim.comment("<foobar2000_Search>", "打开搜索窗口")
    vim.comment("<foobar2000_Tree>", "定位到目录窗口")
    vim.comment("<foobar2000_List>", "定位到播放列表")
    vim.comment("<foobar2000_ToggleShowInfo>", "显示/隐藏 按键提示")

    /*
    ; insert模式
    vim.mode("insert", foobar2000_class)
    vim.map("<esc>", "<foobar2000_NormalMode>", foobar2000_class)
    */

    ; normal模式
    vim.mode("normal", foobar2000_class)

    ;vim.map("i", "<foobar2000_InsertMode>", foobar2000_class)

    vim.map("0", "<0>", foobar2000_class)
    vim.map("1", "<1>", foobar2000_class)
    vim.map("2", "<2>", foobar2000_class)
    vim.map("3", "<3>", foobar2000_class)
    vim.map("4", "<4>", foobar2000_class)
    vim.map("5", "<5>", foobar2000_class)
    vim.map("6", "<6>", foobar2000_class)
    vim.map("7", "<7>", foobar2000_class)
    vim.map("8", "<8>", foobar2000_class)
    vim.map("9", "<9>", foobar2000_class)
    
    vim.map("j", "<down>", foobar2000_class)
    vim.map("k", "<up>", foobar2000_class)
    vim.map("l", "<enter>", foobar2000_class)
    vim.map("gg", "<home>", foobar2000_class)
    vim.map("G", "<end>", foobar2000_class)
    vim.map("<c-f>", "<pgdn>", foobar2000_class)
    vim.map("<c-b>", "<pgup>", foobar2000_class)
    vim.map("/", "<foobar2000_Search>", foobar2000_class)
    vim.map("t", "<foobar2000_Tree>", foobar2000_class)
    vim.map("m", "<foobar2000_List>", foobar2000_class)
    vim.map("n", "<Media_Next>", foobar2000_class)
    vim.map("p", "<Media_Prev>", foobar2000_class)
    vim.map("s", "<Media_Stop>", foobar2000_class)
    
    vim.map("N", "<NextTab>", foobar2000_class)
    vim.map("P", "<PrevTab>", foobar2000_class)

    vim.map("``", "<foobar2000_ToggleShowInfo>", foobar2000_class)

    vim.BeforeActionDo("ForceNormalMode_foobar2000", foobar2000_class)
return

ForceNormalMode_foobar2000()
{
    ControlGetFocus, ctrl, AHK_CLASS %foobar2000_class%
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}

/*
<foobar2000_NormalMode>:
    DisplayMode(foobar2000_class, "normal")

    vim.mode("normal", foobar2000_class)
return

<foobar2000_InsertMode>:
    DisplayMode(foobar2000_class, "insert")

    vim.mode("insert", foobar2000_class)
return
*/

<foobar2000_Search>:
    send ^f
return

<foobar2000_Tree>:
    ControlFocus, SysTreeView321
return

<foobar2000_List>:
    ControlFocus, %foobar2000_list_classnn%
return

<foobar2000_ToggleShowInfo>:
    vim.GetWin(foobar2000_class).SetInfo(!vim.GetWin(foobar2000_class).info)
return
