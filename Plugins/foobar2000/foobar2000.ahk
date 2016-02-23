foobar2000:
    foobar2000_class:="{97E27FAA-C0B3-4b8e-A693-ED7881E99FC1}"
    
    ;插入模式
    vim.mode("insert",foobar2000_class)
    vim.map("<esc>","<General_mode_normal>",foobar2000_class)
    vim.map("<ctrl><esc>","<General_mode_disable>",foobar2000_class)

    ;normal模式
    vim.mode("normal",foobar2000_class)
    vim.map("<ctrl><esc>","<General_mode_disable>",foobar2000_class)
    vim.map("i","<General_mode_insert>",foobar2000_class)
    vim.map("0","<0>",foobar2000_class)
    vim.map("1","<1>",foobar2000_class)
    vim.map("2","<2>",foobar2000_class)
    vim.map("3","<3>",foobar2000_class)
    vim.map("4","<4>",foobar2000_class)
    vim.map("5","<5>",foobar2000_class)
    vim.map("6","<6>",foobar2000_class)
    vim.map("7","<7>",foobar2000_class)
    vim.map("8","<8>",foobar2000_class)
    vim.map("9","<9>",foobar2000_class)
    
    vim.map("j","<down>",foobar2000_class)
    vim.map("k","<up>",foobar2000_class)
    vim.map("l","<enter>",foobar2000_class)
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
    
    vim.map("zj","<WindowMoveDown>",foobar2000_class)
    vim.map("zk","<WindowMoveUp>",foobar2000_class)
    vim.map("zh","<WindowMoveLeft>",foobar2000_class)
    vim.map("zl","<WindowMoveRight>",foobar2000_class)
    vim.map("zc","<WindowMoveCenter>",foobar2000_class)
    vim.map("zf","<fullscreen>",foobar2000_class)
    vim.map("zm","<WindowMax>",foobar2000_class)
    vim.map("zn","<WindowMin>",foobar2000_class)
    vim.map("zr","<WindowRestore>",foobar2000_class)
    
    vim.map("gn","<NextTab>",foobar2000_class)
    vim.map("gp","<PrevTab>",foobar2000_class)
    vim.map("g1","<ActivateTab1>",foobar2000_class)
    vim.map("g2","<ActivateTab2>",foobar2000_class)
    vim.map("g3","<ActivateTab3>",foobar2000_class)
    vim.map("g4","<ActivateTab4>",foobar2000_class)
    vim.map("g5","<ActivateTab5>",foobar2000_class)
    vim.map("g6","<ActivateTab6>",foobar2000_class)
    vim.map("g7","<ActivateTab7>",foobar2000_class)
    vim.map("g8","<ActivateTab8>",foobar2000_class)
    vim.map("g9","<ActivateTab9>",foobar2000_class)
    vim.map("g0","<ActivateTab0>",foobar2000_class)

    ;vim.map("x","<CloseTab>",foobar2000_class)
    
    vim.Comment("<foobar2000_search>","打开搜索窗口")
    vim.Comment("<foobar2000_tree>","定位到目录窗口")
    vim.Comment("<foobar2000_list>","定位到播放列表")
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
