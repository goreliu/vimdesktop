;Version 1.0.3
#Persistent,ON
#SingleInstance,Force
SetWorkingDir, %A_ScriptDir%
SetControlDelay,-1
Detecthiddenwindows,on
Coordmode,Menu,Window
OnMessage(0x4a, "Receive_WM_COPYDATA")
Init()
; Tray Menu {{{1
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
;====================================================================
; Read Config {{{1
If Not FileExist(A_ScriptDir "\vimd.ini")
	FileAppend,,%A_ScriptDir%\vimd.ini
config := GetINIObj(A_ScriptDir "\vimd.ini")
plog   := GetINIObj(A_ScriptDir "\plugins\plugins.ahk")

Global InvalidMode := config.GetValue("config","InvalidMode")
sub := plog.GetKeys("ExtensionsTime")
Loop,Parse,Sub,`n
{
	If IsLabel(A_LoopField) And Strlen(A_LoopField){
		Enabled := strlen(config.GetValue("plugins",A_LoopField)) ? config.GetValue("plugins",A_LoopField) : 1
		GoSub,%A_LoopField%
	}
}
keylist := config.GetKeys("Global")
Loop,Parse,keylist,`n
{
	If not strlen(A_LoopField)
		continue
	value := config.GetValue("Global",Trim(A_LoopField))
	If RegExMatch(value,"\[=[^\[\]]*\]",mode)
		vim.mode(Substr(mode,3,strlen(mode)-3))
	If RegExMatch(Trim(A_LoopField),"^\*")
		vim.smap(SubStr(Trim(A_LoopField),2),RegExReplace(value,"\[=[^\[\]]*\]"))
	Else
		vim.map(Trim(A_LoopField),RegExReplace(value,"\[=[^\[\]]*\]"))
}

keylist := config.GetKeys("Global_Exclude")
Loop,Parse,keylist,`n
{
	If Strlen(A_LoopField)
		vim.Exclude(A_LoopField)
	Else
		continue
}

for class ,k in vim.vimWindows
{
	If strlen(config.GetKeyValue(class))
	{
		keylist := config.GetKeys(class)
		Loop,Parse,keylist,`n
		{
			If not strlen(A_LoopField)
				continue
			value := config.GetValue(class,Trim(A_LoopField))
			If RegExMatch(value,"\[=[^\[\]]*\]",mode)
				vim.mode(Substr(mode,3,strlen(mode)-3))
			If RegExMatch(Trim(A_LoopField),"^\*")
				vim.smap(SubStr(Trim(A_LoopField),2),RegExReplace(value,"\[=[^\[\]]*\]"),class)
			Else
				vim.map(Trim(A_LoopField),RegExReplace(value,"\[=[^\[\]]*\]"),class)
		}
	}
}

WatchDirectory(A_ScriptDir "\plugins",1)
autoload := strlen(config.GetValue("config","autoload")) ? config.GetValue("config","autoload") : 1
If autoload
	SetTimer,WatchPlugins,1000
EmptyMem()
return

;====================================================================
WatchPlugins:
	WatchDirectory("PluginsChange")
return
PluginsChange(a,f,i){
	Run %A_ScriptDir%\check.ahk
	;SetTimer,WatchPlugins,off
	ExitApp
}
; GUI {{{1
; GUI_Config() {{{2
<Config>:
	GUI_Config()
return
GUI_Config() {
	GUI,Config:Destroy
	GUI,Config:Font,s9 ,Microsoft YaHei
	Gui,Config:+Delimiter`n +hwndconfig +LastFound +Resize
	GUI,Config:Add,ListBox,w200 h200
	GUI,Config:Show
	WinMove,ahk_id %config%,,,,626,500
}

; GUI_ListHotkey() {{{2
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
; GUI_ListHotkey_Win() {{{2
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
; GUI_ListHotkey_Mode() {{{2
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
; GUISize(w,p){{{2
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
; Receive_WM_COPYDATA(wParam, lParam) {{{2
Receive_WM_COPYDATA(wParam, lParam){
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
    AHKReturn := StrGet(StringAddress)  ; 从结构中复制字符串.
	If RegExMatch(AHKReturn,"i)exitapp")
		ExitApp
    return true
}

#Include %A_ScriptDir%\lib\vimcore.ahk
#Include %A_ScriptDir%\lib\anchor.ahk
#Include %A_ScriptDir%\lib\ini.ahk
#Include %A_ScriptDir%\lib\watchdir.ahk
#Include *i %A_ScriptDir%\plugins\plugins.ahk
