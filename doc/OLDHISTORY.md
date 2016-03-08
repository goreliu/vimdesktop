## 计划完成的功能

- [ ] 1. 增加Dock支持
- [ ] 1. 增加一个简单的配置界面
- [ ] 1. 迁移TC插件
- [x] 1. 迁移Everything插件

## 历史记录

- 2015-07-05 22:54:00

> 修复BUG，增加对老版本的支持。

- 2015-02-11 13:31:04

> 修改TC插件里的\\的执行方式，防止误操作。

- 2015-02-09 18:03:12

> ++ TC插件，增加\\复制不含后缀的文件名到剪切板中
> 
> \*\* 修复只能执行一次动作的Bug

- 2015-02-09 13:31:45

> ++ 增加[vim.SetModeFunction()](https://github.com/linxinhong/VimDesktop/wiki/API#setmodefunctionfuncmodenamewinname)


> ++ 优化vim.Debug调试界面。


> ++ 优化判断逻辑。


> ++ 增加 \\ 独立搜索界面、\\ 切换到桌面两个功能。


> ++ 增加check.ahk用于检测管理插件，增加viatc.ico做为VIMD的图标。


> \*\* 修复TC插件对totalcmd64.exe识别出错的问题。


> \*\* 修复任务栏图标右键无法退出的Bug。


> \*\*移动 Plugins\\Plugins.ahk到lib\\vimd\_plugins.ahk，便于管理。


> \*\* 其它若干Bug修复。

- 2015-02-07 17:49:20

> ++ 增加对老版本的vimd插件的支持（可以直接迁移）


> ++ 增加在映射的热键的时候，Action无效的错误处理（直接添加vim.SetAction）。


> \*\* 修复无法复制Genral模式的问题


> \*\* 其它若干Bug处理

- 2015-02-07 10:50:44

> \*\* 修复CapsLock判断的错误


> \*\* 修复class\_vim 的几个逻辑错误

- 2015-02-05 16:44:11

> \*\* 修复增加新特性后，TC插件无法使用的BUG


> \*\* 修复TC64位与32位不正确的BUG


> \*\* 修复按下\[Count\]后，不执行afterActionDo对应的函数

- 2015-02-05 11:09:11

> ++ 增加Example.ahk示例
> 
> ++ 增加SetWin时，使用ahk\_exe判断，如:
> 
> vim.setwin(”记事本”,”Notepad”,”notepad.exe”)
> 
> \*\* 修复vim.GetMore()不显示Count的Bug

- 2015-02-03

> 初始化