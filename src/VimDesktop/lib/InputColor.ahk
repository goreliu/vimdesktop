/*
颜色选择器：弹出菜单由用户选择颜色
 color 可被传递给调用者
 default 用户按下ESC时的默认颜色值

2013-12-26 杜立涛
-----------------------
初步创建，后续计划：
 * 提供更多标准颜色
 * 在颜色方块上标准A-Z导航--希望能有高手认领此任务
 * 0x0000ff无法被Excel正确读取？

*/
InputColor(ByRef color,default)
{
	Menu, MyMenu, Add, [&R]ed, MenuHandler
	Menu, MyMenu, Add, [&G]reen, MenuHandler
	Menu, MyMenu, Add, [&B]lue, MenuHandler
	Menu, MyMenu, Add, [&Y]ellow, MenuHandler
	Menu, MyMenu, Add, [&T]est, MenuHandler

	Menu, MyMenu, Show, 500, 300
	return  ; 脚本的自动运行段结束.

MenuHandler:
	if A_ThisMenuItem = [&R]ed
		color = -16776961
	else if A_ThisMenuItem = [&G]reen
		color = -11489280
	else if A_ThisMenuItem = [&B]lue
		color = -4165632
	else if A_ThisMenuItem = [&Y]ellow
		color =-16711681
	else if A_ThisMenuItem = [&T]est
		color = 0x0000ff
	else
		color = default
	return
}



