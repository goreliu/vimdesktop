WPS:
	return
	Global wpsApp
	vim.mode("insert","QWidget")
	;vim.map("<esc>","<word_normal>","QWidget")

	vim.mode("normal","QWidget")
	wpsW := vim.VimWindows["QWidget"]
	wpsW.winMaxCount := 9999
	vim.map("h","<WPS_PreviousChar>","QWidget")
	vim.map("l","<WPS_NextChar>","QWidget")
	vim.map("j","<WPS_NextLine>","QWidget")
	vim.map("k","<WPS_PreviousLine>","QWidget")

	vim.Comment("<WPS_NextChar>","向左移动一个字符",0)
	vim.Comment("<WPS_PreviousChar>","向右移动一个字符",0)
	vim.Comment("<WPS_NextLine>","向下移动一行",0)
	vim.Comment("<WPS_PreviousLine>","向上移动一行",0)

	vim.map("1","<1>","QWidget")
	vim.map("2","<2>","QWidget")
	vim.map("3","<3>","QWidget")
	vim.map("4","<4>","QWidget")
	vim.map("5","<5>","QWidget")
	vim.map("6","<6>","QWidget")
	vim.map("7","<7>","QWidget")
	vim.map("8","<8>","QWidget")
	vim.map("9","<9>","QWidget")
	vim.map("0","<0>","QWidget")

	;Msgbox % vim.ListKey("QWidget")
return

QWidget_CheckMode() {
	winGet,name,ProcessName,ahk_class QWidget

	If RegExMatch(name,"i)^wps\.exe$")
	{
		If Not Strlen(wpsApp.version)
			wpsApp := ComObjectCreate("WPS.Application")
	}
	Else
		Return True
}

<word_normal>:
    vim.mode("normal","QWidget")
return
<word_insert>:
    vim.mode("insert","QWidget")
return



<WPS_NextChar>:
	WPS_NextChar()
Return

WPS_NextChar(){
	Selection := wpsApp.Selection
	Selection.Next(1,vim.GetCount()).Select	
}

<WPS_PreviousChar>:
	WPS_PreviousChar()
Return

WPS_PreviousChar(){
	Selection := wpsApp.Selection
	Selection.Previous(1,Vim.GetCount()).Select	
}

<WPS_NextLine>:
	WPS_NextLine()
Return

<WPS_PreviousLine>:
	WPS_PreviousLine()
Return

WPS_NextLine(){
	;OLDpos := wpsApp.Range.Start
	Loop % Vim.GetCount()
		DelaySend("{Down}")
	;wpsApp.Selection.Range.END := wpsApp.Selection.Range.Start + 1
	Pos  := wpsApp.Selection.Start
	MsgBox % Pos
	wpsApp.Selection.Start := wpsApp.Selection.Start - 1
	wpsApp.Selection.END   := Pos
	wpsApp.Selection.Select
}
WPS_PreviousLine(){
	Loop % Vim.GetCount()
		DelaySend("{UP}")
	Pos  := wpsApp.Selection.Start 
	wpsApp.Selection.END   := wpsApp.Selection.Start + 1
	wpsApp.Selection.Select
}
WPS_NextPara(){
	Range := wpsApp.Selection.Next(4,Vim.GetCount())
	Range.END := Range.Start + 1
	Range.Select
}
DelaySend(Keys){
	Delay := A_KeyDelay
	Setkeydelay,10
	Send,%Keys%
	Setkeydelay,%Delay%
}
