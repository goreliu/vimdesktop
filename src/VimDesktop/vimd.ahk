;Version 1.0.3
#Persistent,ON
#SingleInstance,Force
SetControlDelay,-1
Detecthiddenwindows,on
Coordmode,Menu,Window
Global InvalidMode := False
Init()

vim.mode("normal")
vim.map("<ctrl><esc>","<GeneralCopy>")


Menu,Tray,NoStandard
Menu,Tray,Add,显示热键(&Q),GUI_ListHotkey
Menu,Tray,Default,显示热键(&Q)
Menu,Tray,Add
Menu,Tray,Add,主页(&M),GUI_GotoWeb
Menu,Tray,Add,提交问题(&I),GUI_GotoIssue
Menu,Tray,Add
Menu,Tray,Add,重启(&R),GUI_Reload
Menu,Tray,Add,退出(&X),GUI_Exit
Menu,Tray,Icon,viatc.ico
IniRead,sub,%A_ScriptDir%\plugins\plugins.ahk,ExtensionsTime
Loop,Parse,Sub,`n
{
	If RegExMatch(A_LoopField,"^(.*)=\d*$",m)
	{
		If IsLabel(m1)
			GoSub,%m1%
	}
}
WatchDirectory(A_ScriptDir "\plugins",0)
SetTimer,WatchPlugins,1000
return

WatchPlugins:
	WatchDirectory("PluginsChange")
return
PluginsChange(a,f,i){
	Run %A_ScriptDir%\check.ahk
	SetTimer,WatchPlugins,off
}
CheckMode(){
	;msgbox % A_ThisHotkey
	;Load Exclude List
	;Load Enabled Hotkey
}

GUI_ListHotkey() {
	win := "全局" "`n"
	For i , k in vim.vimWindows
		win .= i "`n"
	;GUI,ListHotkey:Add,Edit
	GUI,ListHotkey:Destroy
	GUI,ListHotkey:Font,s9 ,Microsoft YaHei
	Gui,ListHotkey:+Delimiter`n +hwndlhk +LastFound +Resize
	GUI,ListHotkey:Add,Text,x7 y8,窗口:
	GUI,ListHotkey:Add,DropDownList,x45 y5 w560 choose1 gGUI_ListHotKey_Win,%win%
	GUI,ListHotkey:Add,Text,x7 y38 ,模式:
	GUI,ListHotKey:Add,DropDownList,x45 y35 w560 choose1 gGUI_ListHotKey_Mode
	GUI,ListHotKey:Add,ListView, x5   w600 h400 ,热键`n动作`n说明
	GUI,ListHotkey:Default
	LV_ModifyCol(1,"100 ")
	LV_ModifyCol(2,"200 ")
	LV_ModifyCol(3,"300 ")
	GUI,ListHOtkey:Show
	WinMove,ahk_id %lhk%,,,,626
	GoSub,GUI_ListHotkey_Win
}

GUI_ListHotkey_Win:
	GUI_ListHotkey_Win()
return
GUI_ListHotkey_Win() {
	GUI,ListHotkey:Default
	GUIControlGet,win,,ComboBox1
    win := win = 全局 ? "" : win
	m := vim.ListKey(win)
	mode := "`n"
	Loop,Parse,m,`n
	{
		If IsMode
			mode .= A_LoopField "`n"
		If A_LoopField = ====
			IsMode := True
		ELse
			IsMode := False
	}
	GUIControl,,ComboBox2,%mode%
	GUIControl,Choose,ComboBox2,1
	GoSub,GUI_ListHotkey_Mode
}
GUI_ListHotkey_Mode:
	GUI_ListHotkey_Mode()
return
GUI_ListHotkey_Mode() {
	GUI,ListHOtkey:Default
	GUIControlGet,win,,ComboBox1
	GUIControlGet,Mode,,ComboBox2
	m := vim.ListKey(win,Mode)
	m0 := 1
	LV_Delete()
	Loop,Parse,m,`n
	{
		If Strlen(A_LoopField) = 0
			Continue
		m1 := ""
		m2 := ""
		Loop,Parse,A_LoopField,%A_Space%
		{
			If Strlen(m1)
				m2 := A_LoopField
			Else
				m1 := A_LoopField
		}
		m3 := vim.CommentList[m2]
		If LV_Add("",m1,m2,m3)
			m0 := m0 + 1
	}
}
GUISize(w,p){
	GUI,ListHotkey:+hwndlhk 
	IfWinActive ahk_id %lhk%
	{
		Anchor("combobox1","w")
		Anchor("combobox2","w")
		Anchor("SysListView321","wh")
		GUI,ListHotkey:Default
		GUI,ListView,SysListView321
		ControlGetPos , , , w, ,SysListView321,ahk_id %lhk%
		LV_ModifyCol(3,w-221)
	}
}

GUI_ListHotkey:
	GUI_ListHotkey()
return

GUI_Listline:
	Listlines
return
GUI_Reload:
	Reload
return

GUI_Exit:
	ExitApp
return

GUI_GotoWeb:
	run "https://github.com/victorwoo/vimdesktop"
return

GUI_GotoIssue:
	run "https://github.com/victorwoo/vimdesktop/issues"
return

GUI_VIMINFO:
    GUI_VIMINFO()
return
GUI_VIMINFO()
{
    GUI,Query:Default
    GUIControlGet,Key,,Edit1
    GUIControlGet,Win,,Static1
    w := vim.Vaild(win)
    mode := w.GetMode()
    If Strlen(Key)
    {
        Msgbox % win Key
    }
    Else
        GUI,Query:Destroy
}



#Include lib\vimcore.ahk
#Include lib\anchor.ahk
#Include lib\ini.ahk
#Include lib\watchdir.ahk
#Include *i plugins\plugins.ahk
