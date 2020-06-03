/*
颜色选择器：弹出菜单由用户选择颜色,返回值为16进制rgb颜色值
 color 可被传递给调用者
 default 用户按下ESC时的默认颜色值
 注意：Excel使用BGR格式色值，使用前请用ToBGR转换

2013-12-26 杜立涛
-----------------------
初步创建，后续计划：
 * 提供更多标准颜色
 * 在颜色方块上标准A-Z导航--希望能有高手认领此任务

*/
InputColor(ByRef color)
{
	color = null
	Menu, MyMenu, Add, [&T]ransparent, MenuHandler
	Menu, MyMenu, Add, [&H]Black, MenuHandler
	Menu, MyMenu, Add, [&W]White, MenuHandler
	Menu, MyMenu, Add, [&C]Gray, MenuHandler
	Menu, MyMenu, Add, [&R]ed, MenuHandler
	Menu, MyMenu, Add, [&O]range, MenuHandler
	Menu, MyMenu, Add, [&Y]ellow, MenuHandler
	Menu, MyMenu, Add, [&G]reen, MenuHandler
	Menu, MyMenu, Add, [&B]lue, MenuHandler
	Menu, MyMenu, Add, [&P]urple, MenuHandler

	Menu, MyMenu, Show, 500, 300
	return  ; 脚本的自动运行段结束.

MenuHandler:
	if A_ThisMenuItem = [&T]ransparent
		color = Transparent
	else if A_ThisMenuItem = [&H]Black
		color := 0x000000
	else if A_ThisMenuItem = [&W]White
		color := 0xffffff
	else if A_ThisMenuItem = [&C]Gray
		color := 0x545454
	else if A_ThisMenuItem = [&R]ed
		color := 0xff0000
	else if A_ThisMenuItem = [&O]range
		color := 0xe47833
	else if A_ThisMenuItem = [&Y]ellow
		color := 0xffff00
	else if A_ThisMenuItem = [&G]reen
		color := 0x00ff00
	else if A_ThisMenuItem = [&B]lue
		color := 0x0000ff
	else if A_ThisMenuItem = [&P]urple
		color := 0x9932cd
	else
		color = null
	return
}

;为什么有这个方法?
;    --Microsoft Excel使用的颜色值为BGR
;将RGB颜色值转换为BGR颜色值
;该函数同样可以将BGR颜色值转换为RGB颜色值
ToBGR( color )
{

	RedByte := ( color & 0xFF0000 ) >> 16

	GreenByte := color & 0x00FF00

	BlueByte := ( color & 0x0000FF ) << 16

	return BlueByte | GreenByte | RedByte

}


