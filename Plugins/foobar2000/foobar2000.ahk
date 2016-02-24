foobar2000:
    global foobar2000_class := "{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}"

    ; insert模式
    vim.mode("insert", foobar2000_class)
    vim.map("<esc>", "<Normal_Mode_foobar2000>", foobar2000_class)

    ; normal模式
    vim.mode("normal", foobar2000_class)

    vim.map("i", "<Insert_Mode_foobar2000>", foobar2000_class)

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
    vim.map("<ctrl>f", "<pgdn>", foobar2000_class)
    vim.map("<ctrl>b", "<pgup>", foobar2000_class)
    vim.map("/", "<foobar2000_search>", foobar2000_class)
    vim.map("t", "<foobar2000_tree>", foobar2000_class)
    vim.map("m", "<foobar2000_list>", foobar2000_class)
    vim.map("n", "<Media_Next>", foobar2000_class)
    vim.map("p", "<Media_Prev>", foobar2000_class)
    vim.map("s", "<Media_Stop>", foobar2000_class)
    
    vim.map("gn", "<NextTab>", foobar2000_class)
    vim.map("gp", "<PrevTab>", foobar2000_class)

    vim.Comment("<Normal_Mode_foobar2000>", "进入normal模式")
    vim.Comment("<Insert_Mode_foobar2000>", "进入insert模式")
    vim.Comment("<foobar2000_search>", "打开搜索窗口")
    vim.Comment("<foobar2000_tree>", "定位到目录窗口")
    vim.Comment("<foobar2000_list>", "定位到播放列表")
return

<Normal_Mode_foobar2000>:
    ToolTip % "进入 normal 模式"
    SetTimer, <RemoveToolTip>, 600
    vim.mode("normal", foobar2000_class)
return

<Insert_Mode_foobar2000>:
    ToolTip % "进入 insert 模式"
    SetTimer, <RemoveToolTip>, 600
    vim.mode("insert", foobar2000_class)
return

<foobar2000_search>:
    send ^f
return

<foobar2000_tree>:
    ControlFocus, SysTreeView321
return

<foobar2000_list>:
    ControlFocus, {4B94B650-C2D8-40de-A0AD-E8FADF62D56C}1
return
