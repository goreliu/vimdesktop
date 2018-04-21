Foobar2000:
    global Foobar2000_name := "Foobar2000"
    global Foobar2000_class := "{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}"
    global Foobar2000_exe := "Foobar2000.exe"
    global Foobar2000_list_classnn := "{4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1"

    vim.comment("<Foobar2000_Search>", "打开搜索窗口")
    vim.comment("<Foobar2000_Tree>", "定位到目录窗口")
    vim.comment("<Foobar2000_List>", "定位到播放列表")
    vim.comment("<Foobar2000_ToggleShowInfo>", "显示/隐藏 按键提示")

    ; normal模式
    vim.SetWin(Foobar2000_name, Foobar2000_class, Foobar2000_exe)
    vim.mode("normal", Foobar2000_name)

    ;vim.map("i", "<Foobar2000_InsertMode>", Foobar2000_name)
    vim.map("<esc>", "<RemoveToolTip>", Foobar2000_name)

    vim.map("0", "<0>", Foobar2000_name)
    vim.map("1", "<1>", Foobar2000_name)
    vim.map("2", "<2>", Foobar2000_name)
    vim.map("3", "<3>", Foobar2000_name)
    vim.map("4", "<4>", Foobar2000_name)
    vim.map("5", "<5>", Foobar2000_name)
    vim.map("6", "<6>", Foobar2000_name)
    vim.map("7", "<7>", Foobar2000_name)
    vim.map("8", "<8>", Foobar2000_name)
    vim.map("9", "<9>", Foobar2000_name)
    
    vim.map("j", "<down>", Foobar2000_name)
    vim.map("k", "<up>", Foobar2000_name)
    vim.map("l", "<enter>", Foobar2000_name)
    vim.map("gg", "<home>", Foobar2000_name)
    vim.map("G", "<end>", Foobar2000_name)
    vim.map("<c-f>", "<pgdn>", Foobar2000_name)
    vim.map("<c-b>", "<pgup>", Foobar2000_name)
    vim.map("/", "<Foobar2000_Search>", Foobar2000_name)
    vim.map("t", "<Foobar2000_Tree>", Foobar2000_name)
    vim.map("m", "<Foobar2000_List>", Foobar2000_name)
    vim.map("n", "<Media_Next>", Foobar2000_name)
    vim.map("p", "<Media_Prev>", Foobar2000_name)
    vim.map("s", "<Media_Stop>", Foobar2000_name)
    vim.map("z", "<ShowHelp>", Foobar2000_name)
    
    vim.map("N", "<NextTab>", Foobar2000_name)
    vim.map("P", "<PrevTab>", Foobar2000_name)

    vim.map("``", "<Foobar2000_ToggleShowInfo>", Foobar2000_name)

    vim.BeforeActionDo("Foobar2000_ForceInsertMode", Foobar2000_name)
return

Foobar2000_ForceInsertMode()
{
    ControlGetFocus, ctrl
    ;MsgBox % ctrl
    if RegExMatch(ctrl, "Edit")
        return true
    return false
}

<Foobar2000_Search>:
    send ^f
return

<Foobar2000_Tree>:
    ControlFocus, SysTreeView321
return

<Foobar2000_List>:
    ControlFocus, %Foobar2000_list_classnn%
return

<Foobar2000_ToggleShowInfo>:
    vim.GetWin(Foobar2000_name).SetInfo(!vim.GetWin(Foobar2000_name).info)
return
