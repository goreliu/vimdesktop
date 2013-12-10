TCCOMMAND+:
	vim.comment("<OpenDriveThis>","打开驱动器列表:本侧")
	vim.comment("<OpenDriveThat>","打开驱动器列表:另侧")
	vim.comment("<MoveDirectoryHotlist>","移动到常用文件夹")
	vim.comment("<CopyDirectoryHotlist>","复制到常用文件夹")
	vim.comment("<GotoPreviousDirOther>","后退另一侧")
	vim.comment("<GotoNextDirOther>","前进另一侧")
	;vim.map("H","o","<OpenDriveThis>")
	;vim.map("H","O","<OpenDriveThat>")
	;复制/移动到右侧 f取file的意思 filecopy
	vim.map("fc","<cm_CopyOtherpanel>","TTOTAL_CMD")
	vim.map("fx","<cm_MoveOnly>","TTOTAL_CMD")
	;ff复制到剪切板 fz剪切到剪切板 fv粘贴
	vim.map("ff","<cm_CopyToClipboard>","TTOTAL_CMD")
	vim.map("fz","<cm_CutToClipboard>","TTOTAL_CMD")
	vim.map("fv","<cm_PasteFromClipboard>","TTOTAL_CMD")
	;fb复制到收藏夹某个目录，fd移动到收藏夹的某个目录
	vim.map("fb","<CopyDirectoryHotlist>","TTOTAL_CMD")
	vim.map("fd","<MoveDirectoryHotlist>","TTOTAL_CMD")
	vim.map("ft","<cm_SyncChangeDir>","TTOTAL_CMD")
	vim.map("gh","<GotoPreviousDirOther>","TTOTAL_CMD")
	vim.map("gl","<GotoNextDirOther>","TTOTAL_CMD")
	vim.map("<shift>vh","<cm_SwitchIgnoreList>","TTOTAL_CMD")
return

;<OpenDriveThat>: >>打开驱动器列表:另侧{{{2
<OpenDriveThis>:
	ControlGetFocus,CurrentFocus,AHK_CLASS TTOTAL_CMD
	if CurrentFocus not in TMyListBox2,TMyListBox1
		return
	if CurrentFocus in TMyListBox2
		SendPos(131)
	else
		SendPos(231)
Return

;<OpenDriveThis>: >>打开驱动器列表:本侧{{{2
<OpenDriveThat>:
	ControlGetFocus,CurrentFocus,AHK_CLASS TTOTAL_CMD
	if CurrentFocus not in TMyListBox2,TMyListBox1
		return
	if CurrentFocus in TMyListBox2
		SendPos(231)
	else
		SendPos(131)
Return

;<DirectoryHotlistother>: >>常用文件夹:另一侧{{{2
<DirectoryHotlistother>:
	ControlGetFocus,CurrentFocus,AHK_CLASS TTOTAL_CMD
	if CurrentFocus not in TMyListBox2,TMyListBox1
		return
	if CurrentFocus in TMyListBox2
		otherlist = TMyListBox1
	else
		otherlist = TMyListBox2
	ControlFocus, %otherlist% ,ahk_class TTOTAL_CMD
	SendPos(526)
	SetTimer WaitMenuPop3
return
WaitMenuPop3:
	winget,menupop,,ahk_class #32768
	if menupop
	{
		SetTimer, WaitMenuPop3 ,Off
		SetTimer, WaitMenuOff3
	}
return
WaitMenuOff3:
	winget,menupop,,ahk_class #32768
	if not menupop
	{
		SetTimer,WaitMenuOff3, off
		goto, goonhot
	}
return
goonhot:
ControlFocus, %CurrentFocus% ,ahk_class TTOTAL_CMD
Return

;<CopyDirectoryHotlist>: >>复制到常用文件夹{{{2
<CopyDirectoryHotlist>:
	ControlGetFocus,CurrentFocus,AHK_CLASS TTOTAL_CMD
	if CurrentFocus not in TMyListBox2,TMyListBox1
		return
	if CurrentFocus in TMyListBox2
		otherlist = TMyListBox1
	else
		otherlist = TMyListBox2
	ControlFocus, %otherlist% ,ahk_class TTOTAL_CMD
	SendPos(526)
	SetTimer WaitMenuPop1
return
WaitMenuPop1:
winget,menupop,,ahk_class #32768
if menupop
	{
		SetTimer, WaitMenuPop1 ,Off
		SetTimer, WaitMenuOff1
	}
return
WaitMenuOff1:
	winget,menupop,,ahk_class #32768
	if not menupop
	{
		SetTimer,WaitMenuOff1, off
		goto, gooncopy
	}
return
gooncopy:
	ControlFocus, %CurrentFocus% ,ahk_class TTOTAL_CMD
	SendPos(3101)
return

;<MoveDirectoryHotlist>: >>移动到常用文件夹{{{2
<MoveDirectoryHotlist>:
	If SendPos(0)
		ControlGetFocus,CurrentFocus,AHK_CLASS TTOTAL_CMD
	if CurrentFocus not in TMyListBox2,TMyListBox1
		return
	if CurrentFocus in TMyListBox2
		otherlist = TMyListBox1
	else
		otherlist = TMyListBox2
	ControlFocus, %otherlist% ,ahk_class TTOTAL_CMD
	SendPos(526)
	SetTimer WaitMenuPop2
return
WaitMenuPop2:
	winget,menupop,,ahk_class #32768
	if menupop
	{
		SetTimer, WaitMenuPop2 ,Off
		SetTimer, WaitMenuOff2
	}
return
WaitMenuOff2:
	winget,menupop,,ahk_class #32768
	if not menupop
	{
	SetTimer,WaitMenuOff2, off
	goto, goonmove
	}
return
GoonMove:
	ControlFocus, %CurrentFocus% ,ahk_class TTOTAL_CMD
	SendPos(1005)
return

;<GotoPreviousDirOther>: >>后退另一侧{{{2
<GotoPreviousDirOther>:
	Send {Tab}
	SendPos(570)
	Send {Tab}
Return

;<GotoNextDirOther>: >>前进另一侧{{{2
<GotoNextDirOther>:
	Send {Tab}
	SendPos(571)
	Send {Tab}
Return
