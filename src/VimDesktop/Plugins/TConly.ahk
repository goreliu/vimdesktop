TConly:
;=======================================================
	Global TCPath
	TCPath := "e:\Program Files\totalcmd\TOTALCMD.EXE"
	If RegExMatch(TcPath,"i)totalcmd64\.exe$")
	{
		Global TCListBox := "LCLListBox"
		Global TCEdit := "Edit2"
		Global TInEdit := "TInEdit1"
		GLobal TCPanel1 := "Window1"
		Global TCPanel2 := "Window11"
	}
	Else
	{
		Global TCListBox := "TMyListBox"
		Global TCEdit := "Edit1"
		Global TInEdit := "TInEdit1"
		Global TCPanel1 := "TPanel1"
		Global TCPanel2 := "TMyPanel8"
	}
	Global Mark := []
	Global NewFiles := []
	vim.Comment("<Normal_Mode_TC>","返回正常模式")
	vim.Comment("<Insert_Mode_TC>","进入插入模式")
	vim.Comment("<ToggleTC>","打开/激活TC")

	vim.Comment("<azHistory>","a-z历史导航")
	vim.Comment("<DownSelect>","向下选择")
	vim.Comment("<UpSelect>","向上选择")
	vim.Comment("<Mark>","标记功能")
	vim.Comment("<ForceDelete>","强制删除")
	vim.Comment("<ListMark>","显示标记")
	vim.Comment("<WinMaxLeft>","最大化左侧窗口")
	vim.Comment("<WinMaxRight>","最大化右侧窗口")
	vim.Comment("<GoLastTab>","切换到最后一个标签")
	vim.Comment("<CopyNameOnly>","只复制文件名，不含扩展名")
	vim.Comment("<GotoLine>","移动到[count]行，默认第一行")
	vim.Comment("<LastLine>","移动到[count]行，默认最后一行")
	vim.Comment("<Half>","移动到窗口中间行")
	vim.Comment("<CreateNewFile>","文件模板")
	vim.Comment("<GoToParentEx>","返回到上层文件夹，可返回到我的电脑")
	vim.Comment("<AlwayOnTop>","设置TC顶置")
    vim.mode("normal","TQUICKSEARCH")
	vim.map("J","<Down>","TQUICKSEARCH")
	;;默认按键(VIM)
	vim.map("K","<Up>","TQUICKSEARCH")
    ;vim.map("<esc>","<Normal_Mode_TC>","TQUICKSEARCH")
	vim.mode("insert","TTOTAL_CMD")
    vim.map("<esc>","<Normal_Mode_TC>","TTOTAL_CMD")
	vim.map("<lwin>e","<ToggleTC>")

    vim.mode("normal","TTOTAL_CMD")
	vim.map("0","<0>","TTOTAL_CMD")
	vim.map("1","<1>","TTOTAL_CMD")
	vim.map("2","<2>","TTOTAL_CMD")
	vim.map("3","<3>","TTOTAL_CMD")
	vim.map("4","<4>","TTOTAL_CMD")
	vim.map("5","<5>","TTOTAL_CMD")
	vim.map("6","<6>","TTOTAL_CMD")
	vim.map("7","<7>","TTOTAL_CMD")
	vim.map("8","<8>","TTOTAL_CMD")
	vim.map("9","<9>","TTOTAL_CMD")
	vim.map("k","<up>","TTOTAL_CMD")
	vim.map("K","<upSelect>","TTOTAL_CMD")
	vim.map("j","<down>","TTOTAL_CMD")
	vim.map("J","<downSelect>","TTOTAL_CMD")
	vim.map("h","<left>","TTOTAL_CMD")
	vim.map("H","<cm_GotoPreviousDir>","TTOTAL_CMD")
	vim.map("l","<right>","TTOTAL_CMD")
	vim.map("L","<cm_GotoNextDir>","TTOTAL_CMD")
	vim.map("I","<CreateNewFile>","TTOTAL_CMD")
	vim.map("i","<Insert_Mode_TC>","TTOTAL_CMD")
	vim.map("d","<cm_DirectoryHotlist>","TTOTAL_CMD")
	vim.map("D","<cm_OpenDesktop>","TTOTAL_CMD")
	vim.map("e","<cm_ContextMenu>","TTOTAL_CMD")
	vim.map("E","<cm_ExeCuteDOS>","TTOTAL_CMD")
	vim.map("N","<cm_DirectoryHistory>","TTOTAL_CMD")
	vim.map("n","<azHistory>","TTOTAL_CMD")
	vim.map("m","<Mark>","TTOTAL_CMD")
	vim.map("M","<Half>","TTOTAL_CMD")
	vim.map("'","<ListMark>","TTOTAL_CMD")
	vim.map("u","<GoToParentEx>","TTOTAL_CMD")
	vim.map("U","<cm_GoToRoot>","TTOTAL_CMD")
	vim.map("o","<cm_LeftOpenDrives>","TTOTAL_CMD")
	vim.map("O","<cm_RightOpenDrives>","TTOTAL_CMD")
	vim.map("q","<cm_SrcQuickView>","TTOTAL_CMD")
	vim.map("r","<cm_RenameOnly>","TTOTAL_CMD")
	vim.map("R","<cm_MultiRenameFiles>","TTOTAL_CMD")
	vim.map("x","<cm_Delete>","TTOTAL_CMD")
	vim.map("X","<ForceDelete>","TTOTAL_CMD")
	vim.map("w","<cm_List>","TTOTAL_CMD")
	vim.map("y","<cm_CopyNamesToClip>","TTOTAL_CMD")
	vim.map("Y","<cm_CopyFullNamesToClip>","TTOTAL_CMD")
	vim.map("P","<cm_PackFiles>","TTOTAL_CMD")
	vim.map("p","<cm_UnpackFiles>","TTOTAL_CMD")
	vim.map("t","<cm_OpenNewTab>","TTOTAL_CMD")
	vim.map("T","<cm_OpenNewTabBg>","TTOTAL_CMD")
	vim.map("/","<cm_ShowQuickSearch>","TTOTAL_CMD")
	vim.map("?","<cm_SearchFor>","TTOTAL_CMD")
	vim.map("[","<cm_SelectCurrentName>","TTOTAL_CMD")
	vim.map("{","<cm_UnselectCurrentName>","TTOTAL_CMD")
	vim.map("]","<cm_SelectCurrentExtension>","TTOTAL_CMD")
	vim.map("}","<cm_UnSelectCurrentExtension>","TTOTAL_CMD")
	vim.map("\","<cm_ExchangeSelection>","TTOTAL_CMD")
	vim.map("|","<cm_ClearAll>","TTOTAL_CMD")
	vim.map("-","<cm_SwitchSeparateTree>","TTOTAL_CMD")
	vim.map("=","<cm_MatchSrc>","TTOTAL_CMD")
	vim.map(":","<cm_FocusCmdLine>","TTOTAL_CMD")
	vim.map("G","<LastLine>","TTOTAL_CMD")
	vim.map("ga","<cm_CloseAllTabs>","TTOTAL_CMD")
	vim.map("gg","<GoToLine>","TTOTAL_CMD")
	vim.map("gn","<cm_SwitchToNextTab>","TTOTAL_CMD")
	vim.map("gp","<cm_SwitchToPreviousTab>","TTOTAL_CMD")
	vim.map("gc","<cm_CloseCurrentTab>","TTOTAL_CMD")
	vim.map("gb","<cm_OpenDirInNewTabOther>","TTOTAL_CMD")
	vim.map("ge","<cm_Exchange>","TTOTAL_CMD")
	vim.map("gw","<cm_ExchangeWithTabs>","TTOTAL_CMD")
	vim.map("g1","<cm_SrcActivateTab1>","TTOTAL_CMD")
	vim.map("g2","<cm_SrcActivateTab2>","TTOTAL_CMD")
	vim.map("g3","<cm_SrcActivateTab3>","TTOTAL_CMD")
	vim.map("g4","<cm_SrcActivateTab4>","TTOTAL_CMD")
	vim.map("g5","<cm_SrcActivateTab5>","TTOTAL_CMD")
	vim.map("g6","<cm_SrcActivateTab6>","TTOTAL_CMD")
	vim.map("g7","<cm_SrcActivateTab7>","TTOTAL_CMD")
	vim.map("g8","<cm_SrcActivateTab8>","TTOTAL_CMD")
	vim.map("g9","<cm_SrcActivateTab9>","TTOTAL_CMD")
	vim.map("g0","<GoLastTab>","TTOTAL_CMD")
	vim.map("sn","<cm_SrcByName>","TTOTAL_CMD")
	vim.map("se","<cm_SrcByExt>","TTOTAL_CMD")
	vim.map("ss","<cm_SrcBySize>","TTOTAL_CMD")
	vim.map("sd","<cm_SrcByDateTime>","TTOTAL_CMD")
	vim.map("sr","<cm_SrcNegOrder>","TTOTAL_CMD")
	vim.map("s1","<cm_SrcSortByCol1>","TTOTAL_CMD")
	vim.map("s2","<cm_SrcSortByCol2>","TTOTAL_CMD")
	vim.map("s3","<cm_SrcSortByCol3>","TTOTAL_CMD")
	vim.map("s4","<cm_SrcSortByCol4>","TTOTAL_CMD")
	vim.map("s5","<cm_SrcSortByCol5>","TTOTAL_CMD")
	vim.map("s6","<cm_SrcSortByCol6>","TTOTAL_CMD")
	vim.map("s7","<cm_SrcSortByCol7>","TTOTAL_CMD")
	vim.map("s8","<cm_SrcSortByCol8>","TTOTAL_CMD")
	vim.map("s9","<cm_SrcSortByCol9>","TTOTAL_CMD")
	vim.map("s0","<cm_SrcUnsorted>","TTOTAL_CMD")
	vim.map("v","<cm_SrcCustomViewMenu>","TTOTAL_CMD")
	vim.map("Vb","<cm_VisButtonbar>","TTOTAL_CMD")
	vim.map("Vd","<cm_VisDriveButtons>","TTOTAL_CMD")
	vim.map("Vo","<cm_VisTwoDriveButtons>","TTOTAL_CMD")
	vim.map("Vr","<cm_VisDriveCombo>","TTOTAL_CMD")
	vim.map("Vc","<cm_VisDriveCombo>","TTOTAL_CMD")
	vim.map("Vt","<cm_VisTabHeader>","TTOTAL_CMD")
	vim.map("Vs","<cm_VisStatusbar>","TTOTAL_CMD")
	vim.map("Vn","<cm_VisCmdLine>","TTOTAL_CMD")
	vim.map("Vf","<cm_VisKeyButtons>","TTOTAL_CMD")
	vim.map("Vw","<cm_VisDirTabs>","TTOTAL_CMD")
	vim.map("Ve","<cm_CommandBrowser>","TTOTAL_CMD")
	vim.map("zz","<cm_50Percent>","TTOTAL_CMD")
	vim.map("zi","<WinMaxLeft>","TTOTAL_CMD")
	vim.map("zo","<WinMaxRight>","TTOTAL_CMD")
	vim.map("zt","<AlwayOnTop>","TTOTAL_CMD")
	vim.map("zn","<cm_Minimize>","TTOTAL_CMD")
	vim.map("zm","<cm_Maximize>","TTOTAL_CMD")
	vim.map("zr","<cm_Restore>","TTOTAL_CMD")
	vim.map("zv","<cm_VerticalPanels>","TTOTAL_CMD")
	vim.map("zv","<cm_VerticalPanels>","TTOTAL_CMD")
	;vim.map("zs","<TransParent>","TTOTAL_CMD")
	vim.map(".","<Repeat>","TTOTAL_CMD")
/*
	KeyList := vim.listKey("TTOTAL_CMD")
	GUI,Add,ListView,w300 h500,a
	Loop,Parse,KeyList,`n
	{
		LV_Add("",A_LoopField)
	}
	GUI,Show ,w310 h510
*/
	;; 默认按键完
	ReadNewFile()
return
; TTOTAL_CMD_CheckMode()
TTOTAL_CMD_CheckMode()
{
	WinGet,MenuID,ID,AHK_CLASS #32768
	If MenuID
		return True
	ControlGetFocus,ctrl,AHK_CLASS TTOTAL_CMD
;	If RegExMatch(ctrl,TInEdit)
;		Return True
;	If RegExMatch(ctrl,TCEdit)
;		Return True
	Ifinstring,ctrl,%TCListBox% 
		Return False
	Return True
}
<ExcSubOK>:
	Tooltip
return
; <Esc_TC> {{{1
<Normal_Mode_TC>:
	Send,{Esc}
    vim.Mode("normal","TTOTAL_CMD")
	;emptymem()
return
; <insert_TC> {{{1
<Insert_Mode_TC>:
    vim.Mode("insert","TTOTAL_CMD")
return
; <ToggleTC> {{{1
<ToggleTC>:
	IfWinExist,AHK_CLASS TTOTAL_CMD
	{
		WinGet,AC,MinMax,AHK_CLASS TTOTAL_CMD
		If Ac = -1
			Winactivate,AHK_ClASS TTOTAL_CMD
		Else
		Ifwinnotactive,AHK_CLASS TTOTAL_CMD
			Winactivate,AHK_CLASS TTOTAL_CMD
		Else
			Winminimize,AHK_CLASS TTOTAL_CMD
	}
	Else
	{
		Run,%TCPath%
		Loop,4
		{
			IfWinNotActive,AHK_CLASS TTOTAL_CMD
				WinActivate,AHK_CLASS TTOTAL_CMD
			Else
				Break
			Sleep,500
		}
	}
    ;settimer,AUTHTC,on
	;emptymem()
return
AUTHTC:
    AUTHTC()
return
AUTHTC()
{
    WinGetText, string,ahk_class TNASTYNAGSCREEN
    If Strlen(string)
    {
        RegExMatch(string,"\d",idx)
        ControlClick,TButton%idx%,ahk_class TNASTYNAGSCREEN,,,,NA
        ;msgbox % idx
        settimer,AUTHTC,off
    }
}
; <azHistory> {{{1
<azHistory>:
		azhistory()
Return
azhistory()
{
	GoSub,<cm_DirectoryHistory>
	Sleep, 200
	if WinExist("ahk_class #32768")
	{
		SendMessage,0x01E1 ;Get Menu Hwnd
		hmenu := ErrorLevel
		if hmenu!=0
		{
			If Not RegExMatch(GetMenuString(Hmenu,1),".*[\\|/]$")
				Return
			Menu,sh,UseErrorLevel
			Menu,sh,add
			Menu,sh,deleteall
			If ErrorLevel
				return
			a :=
			itemCount := DllCall("GetMenuItemCount", "Uint", hMenu, "Uint")
			Loop %itemCount%
			{
				;a := chr(A_Index+64) . ">>" .  GetMenuString(Hmenu,A_Index-1)
				a :=  GetMenuString(Hmenu,A_Index-1) A_Tab "[&"  chr(A_Index+64) "]"
				Menu,SH,add,%a%,azSelect
				If not Mod(A_Index,3)
					Menu,SH,add
			}
			Send {Esc}
			ControlGetFocus,TLB,ahk_class TTOTAL_CMD
			ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
			Menu,SH,show,%xn%,%yn%
			Return
		}
	}
}
GetMenuString(hMenu, nPos)
{
      VarSetCapacity(lpString, 256)
      length := DllCall("GetMenuString"
         , "UInt", hMenu
         , "UInt", nPos
         , "Str", lpString
         , "Int", 255
         , "UInt", 0x0400)
   	  return lpString
}
azSelect:
	azSelect()
Return
azSelect()
{
	nPos := A_ThisMenuItem
	nPos := Asc(Substr(nPos,-1,1)) - 64
	Winactivate,ahk_class TTOTAL_CMD
	Postmessage,1075,572,0,,ahk_class TTOTAL_CMD
	Sleep,200
	if WinExist("ahk_class #32768")
	{
		Loop %nPos%
			SendInput {Down}
		Send {enter}
	}
}
; <DownSelect> {{{1
<DownSelect>:
	Send +{Down}
return
; <upSelect> {{{1
<upSelect>:
	Send +{Up}
return
; <WinMaxLeft> {{{1
<WinMaxLeft>:
	WinMaxLR(true)
Return
; <WinMaxRight> {{{1
<WinMaxRight>:
	WinMaxLR(false)
Return
WinMaxLR(lr)
{
	If lr
	{
		ControlGetPos,x,y,w,h,%TCPanel2%,ahk_class TTOTAL_CMD
		ControlGetPos,tm1x,tm1y,tm1W,tm1H,%TCPanel1%,ahk_class TTOTAL_CMD
		If (tm1w < tm1h) ; 判断纵向还是横向 Ture为竖 false为横
		{
			ControlMove,%TCPanel1%,x+w,,,,ahk_class TTOTAL_CMD
		}
		else
			ControlMove,%TCPanel1%,0,y+h,,,ahk_class TTOTAL_CMD
		ControlClick, %TCPanel1%,ahk_class TTOTAL_CMD
		WinActivate ahk_class TTOTAL_CMD
	}
	Else
	{
		ControlMove,%TCPanel1%,0,0,,,ahk_class TTOTAL_CMD
		ControlClick,%TCPanel1%,ahk_class TTOTAL_CMD
		WinActivate ahk_class TTOTAL_CMD
	}
}
; <GoLastTab> {{{1
<GoLastTab>:
	GoSub,<cm_SrcActivateTab1>
	GoSub,<cm_SwitchToPreviousTab>
return
; <CopyNameOnly> {{{1
<CopyNameOnly>:
		CopyNameOnly()
Return
CopyNameOnly()
{
	clipboard :=
	GoSub,<cm_CopyNamesToClip>
	ClipWait
	If Not RegExMatch(clipboard,"^\..*")
		clipboard := RegExReplace(RegExReplace(clipboard,"\\$"),"\.[^\.]*$")
}
; <ForceDelete>  {{{1
; 强制删除
<ForceDelete>:
	Send +{Delete}
return
; <GotoLine> {{{1
; 转到[count]行,缺省第一行
<GotoLine>:
	If Vim_HotKeyCount
		GotoLine(Vim_HotKeyCount)
	Else
		GotoLine(1)
return
; <LastLine> {{{1
; 转到[count]行, 最后一行
<LastLine>:
	If Vim_HotKeyCount
		GotoLine(Vim_HotKeyCount)
	Else
		GotoLine(0)
return
GotoLine(Index)
{
	Vim_HotKeyCount := 0
	ControlGetFocus,Ctrl,AHK_CLASS TTOTAL_CMD
	If Index
	{
		Index--
		ControlGet,text,List,,%ctrl%,AHK_CLASS TTOTAL_CMD
		Stringsplit,T,Text,`n
		Last := T0 - 1
		If Index > %Last%
			Index := Last
		Postmessage,0x19E,%Index%,1,%Ctrl%,AHK_CLASS TTOTAL_CMD
	}
	Else
	{
		ControlGet,text,List,,%ctrl%,AHK_CLASS TTOTAL_CMD
		Stringsplit,T,Text,`n
		Last := T0 - 1
		PostMessage, 0x19E,  %Last% , 1 , %CTRL%, AHK_CLASS TTOTAL_CMD
	}
}
; <Half>  {{{1
; 移动到窗口中间
<Half>:
		Half()
Return
Half()
{
	winget,tid,id,ahk_class TTOTAL_CMD
	controlgetfocus,ctrl,ahk_id %tid%
	controlget,cid,hwnd,,%ctrl%,ahk_id %tid%
	controlgetpos,x1,y1,w1,h1,THeaderClick2,ahk_id %tid%
	controlgetpos,x,y,w,h,%ctrl%,ahk_id %tid%
	SendMessage,0x01A1,1,0,,ahk_id %cid%
	Hight := ErrorLevel
	SendMessage,0x018E,0,0,,ahk_id %cid%
	Top := ErrorLevel
	HalfLine := Ceil( ((h-h1)/Hight)/2 ) + Top
	PostMessage, 0x19E, %HalfLine%, 1, , AHK_id %cid%
}
; <Mark> {{{1
; 标记功能
<Mark>:
	Mark()
Return
Mark()
{
	vim.mode("insert")
	GoSub,<cm_FocusCmdLine>
	ControlGet,EditId,Hwnd,,AHK_CLASS TTOTAL_CMD
	ControlSetText,%TCEdit%,m,AHK_CLASS TTOTAL_CMD
	Postmessage,0xB1,2,2,%TCEdit%,AHK_CLASS TTOTAL_CMD
	SetTimer,<MarkTimer>,100
}
<MarkTimer>:
	MarkTimer()
Return
MarkTimer()
{
	ControlGetFocus,ThisControl,AHK_CLASS TTOTAL_CMD
	ControlGetText,OutVar,%TCEdit%,AHK_CLASS TTOTAL_CMD
	Match_TCEdit := "i)^" . TCEdit . "$"
	If Not RegExMatch(ThisControl,Match_TCEdit) OR Not RegExMatch(Outvar,"i)^m.?")
	{
		vim.mode("normal")
		Settimer,<MarkTimer>,Off
		Return
	}
	If RegExMatch(OutVar,"i)^m.+")
	{
		vim.mode("normal")
		SetTimer,<MarkTimer>,off
		ControlSetText,%TCEdit%,,AHK_CLASS TTOTAL_CMD
		ControlSend,%TCEdit%,{Esc},AHK_CLASS TTOTAL_CMD
		ClipSaved := ClipboardAll
		Clipboard :=
		Postmessage 1075, 2029, 0, , ahk_class TTOTAL_CMD
		ClipWait
		Path := Clipboard
		Clipboard := ClipSaved
		If StrLen(Path) > 80
		{
			SplitPath,Path,,PathDir
			Path1 := SubStr(Path,1,15)
			Path2 := SubStr(Path,RegExMatch(Path,"\\[^\\]*$")-Strlen(Path))
			Path := Path1 . "..." . SubStr(Path2,1,65) "..."
		}
		M := SubStr(OutVar,2,1)
		mPath := "&" . m . ">>" . Path
		If RegExMatch(Mark["ms"],m)
		{
			DelM := Mark[m]
			Menu,MarkMenu,Delete,%DelM%
			Menu,MarkMenu,Add,%mPath%,<AddMark>
			Mark["ms"] := Mark["ms"] . m
			Mark[m] := mPath
		}
		Else
		{
			Menu,MarkMenu,Add,%mPath%,<AddMark>
			Mark["ms"] := Mark["ms"] . m
			Mark[m] := mPath
		}
	}
}
<AddMark>:
	AddMark()
Return
AddMark()
{
	ThisMenuItem := SubStr(A_ThisMenuItem,5,StrLen(A_ThisMenuItem))
	If RegExMatch(ThisMenuItem,"i)\\\\桌面$")
	{
		Postmessage 1075, 2121, 0, , ahk_class TTOTAL_CMD
		Return
	}
	If RegExMatch(ThisMenuItem,"i)\\\\计算机$")
	{
		Postmessage 1075, 2122, 0, , ahk_class TTOTAL_CMD
		Return
	}
	If RegExMatch(ThisMenuItem,"i)\\\\所有控制面板项$")
	{
		Postmessage 1075, 2123, 0, , ahk_class TTOTAL_CMD
		Return
	}
	If RegExMatch(ThisMenuItem,"i)\\\\Fonts$")
	{
		Postmessage 1075, 2124, 0, , ahk_class TTOTAL_CMD
		Return
	}
	If RegExMatch(ThisMenuItem,"i)\\\\网络$")
	{
		Postmessage 1075, 2125, 0, , ahk_class TTOTAL_CMD
		Return
	}
	If RegExMatch(ThisMenuItem,"i)\\\\打印机$")
	{
		Postmessage 1075, 2126, 0, , ahk_class TTOTAL_CMD
		Return
	}
	If RegExMatch(ThisMenuItem,"i)\\\\回收站$")
	{
		Postmessage 1075, 2127, 0, , ahk_class TTOTAL_CMD
		Return
	}
	ControlSetText, %TCEdit%, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
	ControlSend, %TCEdit%, {Enter}, ahk_class TTOTAL_CMD
	Return
}
; <ListMark> {{{1
; 显示标记
<ListMark>:
	ListMark()
Return
ListMark()
{
	If Not Mark["ms"]
		Return
	ControlGetFocus,TLB,ahk_class TTOTAL_CMD
	ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
	Menu,MarkMenu,Show,%xn%,%yn%
}
; <CreateNewFile> {{{1
; 新建文件
<CreateNewFile>:
	CreateNewFile()
return
CreateNewFile()
{
	ControlGetFocus,TLB,ahk_class TTOTAL_CMD
	ControlGetPos,xn,yn,,,%TLB%,ahk_class TTOTAL_CMD
	Menu,FileTemp,Add
	Menu,FileTemp,DeleteAll
	Menu,FileTemp,Add ,0 新建文件,:CreateNewFile
	Menu,FileTemp,Icon,0 新建文件,%A_WinDir%\system32\Shell32.dll,-152
	Menu,FileTemp,Add ,1 文件夹,<cm_Mkdir>
	Menu,FileTemp,Icon,1 文件夹,%A_WinDir%\system32\Shell32.dll,4
	Menu,FileTemp,Add ,2 快捷方式,<cm_CreateShortcut>
	Menu,FileTemp,Icon,2 快捷方式,%A_WinDir%\system32\Shell32.dll,264
	Menu,FileTemp,Add ,3 添加到新模板,<AddToTempFiles>
	Menu,FileTemp,Icon,3 添加到新模板,%A_WinDir%\system32\Shell32.dll,-155
	FileTempMenuCheck()
	Menu,FileTemp,Show,%xn%,%yn%
}
; 检查文件模板功能
FileTempMenuCheck()
{
	Global TCPath
	Splitpath,TCPath,,TCDir
	Loop,%TCDir%\shellnew\*.*
	{
		If A_Index = 1
			Menu,FileTemp,Add
		ft := chr(64+A_Index) . " >> " . A_LoopFileName
		Menu,FileTemp,Add,%ft%,FileTempNew
		Ext := "." . A_LoopFileExt
		IconFile := RegGetNewFileIcon(Ext)
		IconFIle := RegExReplace(IconFile,"i)%systemroot%",A_WinDir)
		IconFilePath := RegExReplace(IconFile,",-?\d*","")
		IconFileIndex := RegExReplace(IconFile,".*,","")
		If Not FileExist(IconFilePath)
			Menu,FileTemp,Icon,%ft%,%A_WinDir%\system32\Shell32.dll,-152
		Else
			Menu,FileTemp,Icon,%ft%,%IconFilePath%,%IconFileIndex%
	}
}
; 添加到文件模板中
<AddToTempFiles>:
	AddToTempFiles()
return
AddToTempFiles()
{
	ClipSaved := ClipboardAll
	Clipboard :=
	GoSub,<cm_CopyFullNamesToClip>
	ClipWait,2
	If clipboard
		AddPath := clipboard
	Else
		Return
	clipboard := ClipSaved
	If FileExist(AddPath)
		Splitpath,AddPath,filename,,fileext,filenamenoext
	else
		Return
	Gui, Destroy
	Gui, Add, Text, Hidden, %AddPath%
	Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
	Gui, Add, Edit, x72 y20 w300 h20 Disabled, %FileName%
	Gui, Add, Text, x12 y50 w50 h20 +Center, 模板名
	Gui, Add, Edit, x72 y50 w300 h20 , %FileName%
	Gui, Add, Button, x162 y80 w90 h30 gAddTempOK default, 确认(&S)
	Gui, Add, Button, x282 y80 w90 h30 gNewFileClose , 取消(&C)
	Gui, Show, w400 h120, 添加模板
	If Fileext
	{
		Controlget,nf,hwnd,,edit2,A
		PostMessage,0x0B1,0,Strlen(filenamenoext),Edit2,A
	}
}
AddTempOK:
	AddTempOK()
return
AddTempOK()
{
	Global TCPath
	GuiControlGet,SrcPath,,Static1
	Splitpath,SrcPath,filename,,fileext,filenamenoext
	GuiControlGet,NewFileName,,Edit2
	SNDir := RegExReplace(TCPath,"[^\\]*$") . "ShellNew\"
	If Not FileExist(SNDir)
		FileCreateDir,%SNDir%
	NewFile := SNDir . NewFileName
	FileCopy,%SrcPath%,%NewFile%,1
	Gui,Destroy
}
; 新建文件模板
FileTempNew:
	NewFile(RegExReplace(A_ThisMenuItem,".\s>>\s",RegExReplace(TCPath,"\\[^\\]*$","\shellnew\")))
return
; 新建文件
NewFile:
	NewFile()
return
NewFile(File="")
{
	Global NewFile
	If Not File
		File := RegExReplace(NewFiles[A_ThisMenuItemPos],"(.*\[|\]$)","")
	If Not FileExist(File)
	{
		RegRead,ShellNewDir,HKEY_USERS,.default\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
		If Not ShellNewDir
			ShellNewDir := "C:\windows\Shellnew"
		File := ShellNewDir . "\" file
		If RegExMatch(SubStr(file,-7),"NullFile")
		{
			fileext := RegExReplace(NewFiles[A_ThisMenuItemPos],"(.*\(|\).*)")
			File := "New" . fileext
			FileName := "New" . fileext
			FileNamenoext := "New"
		}
	}
	Else
		Splitpath,file,filename,,fileext,filenamenoext
	Gui, Destroy
	Gui, Add, Text, x12 y20 w50 h20 +Center, 模板源
	Gui, Add, Edit, x72 y20 w300 h20 Disabled, %file%
	Gui, Add, Text, x12 y50 w50 h20 +Center, 新建文件
	Gui, Add, Edit, x72 y50 w300 h20 , %filename%
	Gui, Add, Button, x162 y80 w90 h30 gNewFileOk default, 确认(&S)
	Gui, Add, Button, x282 y80 w90 h30 gNewFileClose , 取消(&C)
	Gui, Show, w400 h120, 新建文件
	If Fileext
	{
		Controlget,nf,hwnd,,edit2,A
		PostMessage,0x0B1,0,Strlen(filenamenoext),Edit2,A
	}
	return
}
; 关闭新建文件窗口
NewFileClose:
	Gui,Destroy
return

; 确认新建文件
NewFileOK:
	NewFileOK()
return
NewFileOK()
{
	GuiControlGet,SrcPath,,Edit1
	GuiControlGet,NewFileName,,Edit2
	ClipSaved := ClipboardAll
	Clipboard :=
	GoSub,<cm_CopySrcPathToClip>
	ClipWait,2
	If clipboard
		DstPath := Clipboard
	Else
		Return
	clipboard := ClipSaved
		If RegExMatch(DstPath,"^\\\\计算机$")
		Return
	If RegExMatch(DstPath,"i)\\\\所有控制面板项$")
		Return
	If RegExMatch(DstPath,"i)\\\\Fonts$")
		Return
	If RegExMatch(DstPath,"i)\\\\网络$")
		Return
	If RegExMatch(DstPath,"i)\\\\打印机$")
		Return
	If RegExMatch(DstPath,"i)\\\\回收站$")
		Return
	If RegExmatch(DstPath,"^\\\\桌面$")
		DstPath := A_Desktop
	NewFile := DstPath . "\" . NewFileName
	If FileExist(NewFile)
	{
		MsgBox, 4, 新建文件, 新建文件已存在，是否覆盖？
		IfMsgBox No
			Return
	}
		FileCopy,%SrcPath%,%NewFile%,1
	Gui,Destroy
	WinActivate,AHK_CLASS TTOTAL_CMD
	ControlGetFocus,FocusCtrl,AHK_Class TTOTAL_CMD
	IF RegExMatch(FocusCtrl,TCListBox)
	{
		GoSub,<cm_RereadSource>
		ControlGet,Text,List,,%FocusCtrl%,AHK_CLASS TTOTAL_CMD
		Loop,Parse,Text,`n
		{
			If RegExMatch(A_LoopField,NewFileName)
			{
				Index := A_Index - 1
				Postmessage,0x19E,%Index%,1,%FocusCtrl%,AHK_CLASS TTOTAL_CMD
				Break
			}
		}
	}
}
;============================================================================
; ReadNewFile()
; 新建文件菜单
ReadNewFile()
{
	NewFiles[0] := 0
	SetBatchLines -1
	Loop,HKEY_CLASSES_ROOT ,,1,0
	{
		If RegExMatch(A_LoopRegName,"^\..*")
		{
			Reg := A_LoopRegName
			Loop,HKEY_CLASSES_ROOT,%Reg%,1,1
			{
				If RegExMatch(A_LoopRegName,"i)shellnew")
				{
					NewReg := A_LoopRegSubKey "\shellnew"
					If RegGetNewFilePath(NewReg)
					{
						NewFiles[0]++
						Index := NewFiles[0]
						NewFiles[Index] := RegGetNewFileDescribe(Reg) . "(" . Reg . ")[" . RegGetNewFilePath(NewReg) . "]"
					}
				}
			}
		}
	}
	LoopCount := NewFiles[0]
	Half := LoopCount/2
	Loop % LoopCount
	{
		If A_Index < %Half%
		{
			B_Index := NewFiles[0] - A_Index + 1
			C_Index := NewFiles[A_Index]
			NewFiles[A_Index] := NewFiles[B_Index]
			NewFiles[B_Index] := C_Index
		}
	}
	Menu,CreateNewFile,UseErrorLevel,On
	Loop % NewFiles[0]
	{
		File := RegExReplace(NewFiles[A_Index],"\(.*","")
		Exec := RegExReplace(NewFiles[A_Index],"(.*\(|\)\[.*)","")
		MenuFile := Chr(A_Index+64) . " >> " . File . "(" Exec . ")"
		Menu,CreateNewFile,Add,%MenuFile%,NewFile

		IconFile := RegGetNewFileIcon(Exec)
		IconFIle := RegExReplace(IconFile,"i)%systemroot%",A_WinDir)
		IconFilePath := RegExReplace(IconFile,",-?\d*","")
		If Not FileExist(IconFilePath)
			IconFilePath := ""
		IconFileIndex := RegExReplace(IconFile,".*,","")
		If Not RegExMatch(IconFileIndex,"^-?\d*$")
			IconFileIndex := ""
		If RegExMatch(Exec,"\.lnk")
		{
			IconFilePath := A_WinDir . "\system32\Shell32.dll"
			IconFileIndex := "264"
		}
		Menu,CreateNewFile,Icon,%MenuFile%,%IconFilePath%,%IconFileIndex%
	}
}
; 获取新建文件的源
; reg 为后缀
RegGetNewFilePath(reg)
{
	RegRead,GetRegPath,HKEY_CLASSES_ROOT,%Reg%,FileName
	IF Not ErrorLevel
		Return GetRegPath
	RegRead,GetRegPath,HKEY_CLASSES_ROOT,%Reg%,NullFile
	IF Not ErrorLevel
		Return "NullFile"
}
; RegGetNewFileType(reg)
; 获取新建文件类型名
; reg 为后缀
RegGetNewFileType(reg)
{
	RegRead,FileType,HKEY_CLASSES_ROOT,%Reg%
	If Not ErrorLevel
		Return FileType
}
; 获取文件描述
; reg 为后缀
RegGetNewFileDescribe(reg)
{
	FileType := RegGetNewFileType(reg)
	RegRead,FileDesc,HKEY_CLASSES_ROOT,%FileType%
	If Not ErrorLevel
		Return FileDesc
}
; 获取文件对应的图标
; reg 为后缀
RegGetNewFileIcon(reg)
{
	IconPath := RegGetNewFileType(reg) . "\DefaultIcon"
	RegRead,FileIcon,HKEY_CLASSES_ROOT,%IconPath%
	If Not ErrorLevel
		Return FileIcon
}
; <GoToParentEx> {{{1
; 返回到上层文件夹，可返回到我的电脑
<GoToParentEx>:
	IsRootDir()
	GoSub,<cm_GoToParent>
return
IsRootDir()
{
	ClipSaved := ClipboardAll
	clipboard :=
	GoSub,<cm_CopySrcPathToClip>
	ClipWait,1
	Path := Clipboard
	Clipboard := ClipSaved
	If RegExMatch(Path,"^.:\\$")
	{
		GoSub,<cm_OpenDrives>
		Path := "i)" . RegExReplace(Path,"\\","")
		ControlGetFocus,focus_control,AHK_CLASS TTOTAL_CMD
		ControlGet,outvar,list,,%focus_control%,AHK_CLASS TTOTAL_CMD
		Loop,Parse,Outvar,`n
		{
			If Not A_LoopField
				Break
			If RegExMatch(A_LoopField,Path)
			{
				Focus := A_Index - 1
				Break
			}
		}
		PostMessage, 0x19E, %Focus%, 1, %focus_control%, AHK_CLASS TTOTAL_CMD
	}
}
<AlwayOnTop>:
	AlwayOnTop()
Return
AlwayOnTop()
{
	WinGet,ExStyle,ExStyle,ahk_class TTOTAL_CMD
	If (ExStyle & 0x8)
   		WinSet,AlwaysOnTop,off,ahk_class TTOTAL_CMD
	else
   		WinSet,AlwaysOnTop,on,ahk_class TTOTAL_CMD 
}
