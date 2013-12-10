#Persistent,ON
SetControlDelay,-1
Detecthiddenwindows,on
Coordmode,Menu,Window
Init()

vim.mode("normal")
vim.map("<ctrl><esc>","<GeneralCopy>")


Menu,Tray,Add,œ‘ æ»»º¸,GUI_ListHotkey
Menu,Tray,Icon,e:\Program Files\VimDesktop\viatc.ico

GoSub,General
GoSub,TCOnly
GoSub,TCCOMMAND
GoSub,TCCOMMAND+
GoSub,SGBrowser
;Gosub,WPS

#Include Include\vimcore2.ahk
#Include Include\General.ahk
#Include Include\TCCOMMAND.ahk
#Include Include\TCCOMMAND+.ahk
#Include Include\TConly.ahk
#Include Include\WPS.ahk
#Include Include\SGBrowser.ahk


GUI_ListHotkey:
	GUI_ListHotkey()
return

