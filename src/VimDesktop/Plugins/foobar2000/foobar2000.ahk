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
    vim.map("/", "<foobar2000_search>", foobar2000_class)
    vim.map("t", "<foobar2000_tree>", foobar2000_class)
    vim.map("m", "<foobar2000_list>", foobar2000_class)    
    
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
    
	vim.comment("<NextTab>","下一个标签")
	vim.comment("<PrevTab>","前一个标签")
	vim.comment("<CloseTab>","关闭当前标签")
	vim.comment("<NewTab>","新建标签")
	vim.comment("<ActivateTab1>","激活第一个标签")
	vim.comment("<ActivateTab2>","激活第二个标签")
	vim.comment("<ActivateTab3>","激活第三个标签")
	vim.comment("<ActivateTab4>","激活第四个标签")
	vim.comment("<ActivateTab5>","激活第五个标签")
	vim.comment("<ActivateTab6>","激活第六个标签")
	vim.comment("<ActivateTab7>","激活第七个标签")
	vim.comment("<ActivateTab8>","激活第八个标签")
	vim.comment("<ActivateTab9>","激活第九个标签")
	vim.comment("<ActivateTab0>","激活最后一个标签")
    vim.Comment("<1>","计数前缀1")
    vim.Comment("<2>","计数前缀2")
    vim.Comment("<3>","计数前缀3")
    vim.Comment("<4>","计数前缀4")
    vim.Comment("<5>","计数前缀5")
    vim.Comment("<6>","计数前缀6")
    vim.Comment("<7>","计数前缀7")
    vim.Comment("<8>","计数前缀8")
    vim.Comment("<9>","计数前缀9")
    vim.Comment("<0>","计数前缀0")
    vim.Comment("<left>","向左移动[Count]次")
    vim.Comment("<Right>","向右移动[Count]次")
    vim.Comment("<Down>","向下移动[Count]次")
    vim.Comment("<Up>","向上移动[Count]次")
    vim.Comment("<windowMoveDown>","窗口移动到下方")
    vim.Comment("<windowMoveUp>","窗口移动到上方")
    vim.Comment("<windowMoveLeft>","窗口移动到左侧")
    vim.Comment("<WindowMoveRight>","窗口移动到右侧")
    vim.Comment("<WindowMoveCenter>","窗口移动到中间")
    vim.Comment("<WindowMax>","最大化窗口")
    vim.Comment("<WindowMin>","最小化窗口")
    vim.Comment("<WindowRestore>","还原当前窗口")
    vim.Comment("<FullScreen>","全屏当前程序")
    vim.Comment("<GoToExplorer>","运行文件管理器")
    vim.comment("<ToggleShowComment>","切换是否显示快捷键提示")
return

<enter>:
    send {enter}
return

<home>:
    send {home}
return

<end>:
    send {end}
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