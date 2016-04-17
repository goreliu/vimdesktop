#NoEnv
#SingleInstance, Force

CoordMode, Tooltip, Screen
CoordMode, Mouse, Screen
Coordmode, Menu, Window
SetControlDelay, -1
SetKeyDelay, -1
Detecthiddenwindows, on
FileEncoding, utf-8
SendMode Input

Menu, Tray, Icon, %A_ScriptDir%\vimd.ico
Menu, Tray, NoStandard
Menu, Tray, Add, 热键 &K, <VimDConfig_Keymap>
Menu, Tray, Add, 插件 &P, <VimDConfig_Plugin>
Menu, Tray, Add, 配置 &C, <VimDConfig_EditConfig>
Menu, Tray, Add,
Menu, Tray, Add, 重启 &R, <Reload>
Menu, Tray, Add, 退出 &X, <Exit>
Menu, Tray, Default, 热键 &K
Menu, Tray, Click, 1

VimdRun()

return

#Include %A_ScriptDir%\core\Main.ahk
#Include %A_ScriptDir%\core\class_vim.ahk
#Include %A_ScriptDir%\core\VimDConfig.ahk
#Include %A_ScriptDir%\lib\class_EasyINI.ahk
#Include %A_ScriptDir%\lib\acc.ahk
#Include %A_ScriptDir%\lib\ini.ahk
#Include %A_ScriptDir%\lib\gdip.ahk
#Include %A_ScriptDir%\lib\Logger.ahk
#Include %A_ScriptDir%\plugins\plugins.ahk
; 用户自定义配置
#Include *i %A_ScriptDir%\custom.ahk
