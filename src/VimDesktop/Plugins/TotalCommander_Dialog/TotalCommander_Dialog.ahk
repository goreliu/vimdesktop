TotalCommander_Dialog:
;本插件尝试将TotalCommander作为文件打开对话框
; * 默认添加快捷键<lwin>o ,在文件对话框或任意文字编辑界面按下快捷键跳转至TC--TC中选定文件后再次按下快捷键可实现文件打开功能
; * 尝试在打开文件对话框时，自动跳转到TC进行文件选择：#32770，焦点Edit1且内无文字,对话框内不含密码、password等内容
; * 增加select模式，按下回车或Ctrl+回车均可直接选定文件;未多选情况下在文件夹上按下回车时，进入该文件夹而非选定

vim.comment("<OpenTCDialog>","激活TC选择文件,需再次按下快捷键触发对话框打开事件")

;初始化设置：全局快捷键跳转到TC
IniWriteIfNullValue(ConfigPath,"Global","*<lwin>o","<OpenTCDialog>")

;初始化设置：自动跳转到TC作为文件选择对话框
IniWriteIfNull(ConfigPath,"TotalCommander_Config","AsOpenFileDialog","0")

;初始化设置：还有下面文字的窗口将排除TC作为文件选择对话框--由于不支持中文，无法初始化"密码"，在后面代码中添加
IniWriteIfNull(ConfigPath,"TotalCommander_Config","OpenFileDialogExclude","password,pwd")

;读取配置参数，禁用时直接跳过
IniRead,AsOpenFileDialog,%ConfigPath%,TotalCommander_Config,AsOpenFileDialog,1
if AsOpenFileDialog <> 1
	return

;读取排除窗体文字
;IniRead,OpenFileDialogExclude,%ConfigPath%,TotalCommander_Config,OpenFileDialogExclude,"密码,password"
Loop, read, %ConfigPath%
{
	ifInString, A_LoopReadLine, OpenFileDialogExclude
	{
		OpenFileDialogExclude := SubStr(A_LoopReadLine,InStr(A_LoopReadLine,"=")+1)
		IfNotInString, OpenFileDialogExclude, 密码
			OpenFileDialogExclude .= ",密码"
		break
	}
}

;未发现TC路径时自动禁用该功能
if StrLen(TCPath) = 0
	return

;用于记录文件打开对话框所属窗体
global CallerId := 0

;等待OpenFileDialog出现
SetTimer, <CheckFileDialog>, 1000

return


;===============================================

;仅在执行文件选定时，开启select模式
;拷贝normal全部快捷键，并增加回车确认功能
<Select_Mode_TC>:
	vim.mode("select","TTOTAL_CMD")

	if Select_Copyed = 1
		return
	
	Select_Copyed := 1
	vim.CopyMode("TTOTAL_CMD","normal","select")
	vim.map("<enter>","<TC_PreSelected>","TTOTAL_CMD")
	vim.map("<ctrl><enter>","<TC_Selected>","TTOTAL_CMD")
	vim.map("<esc>","<Return_To_Caller>","TTOTAL_CMD")
	return

;返回调用者
<Return_To_Caller>:
	gosub,<Normal_Mode_TC>
	;未发现可激活的调用窗体时，最小化TC
	if CallerId = 0
	{
		Winminimize,AHK_CLASS TTOTAL_CMD
		sleep,500
		CallerId := WinExist("A")
		if CallerId = 0
			return
	}

	WinActivate,ahk_id %CallerId%
	return
	


;发现标准打开文件对话框，未记录，焦点控件为Edit1=>记录，并激活TC
<CheckFileDialog>:
{
	WinGetClass, class, A
	if class <> #32770
		return
		
	ControlGetFocus,ct, ahk_class #32770
	if ct <> Edit1
		return

	;以此排除“另存为”，或其它已经包含文字的对话框
	ControlGetText,str,Edit1,ahk_class #32770
	if StrLen(str) > 0
		return

	;排除用户自定义窗体
	WinGetText,str,ahk_class #32770
	WinGetTitle,title,ahk_class #32770
	if StrLen(title)=0
		return
	str .= title
	Loop, parse, OpenFileDialogExclude, `,, %A_Space%%A_Tab%
	{
		If StrLen(A_LoopField) = 0 
			continue
		IfInString,str,%A_LoopField%
			return
	}
	
	id := WinExist("A")
	if id = 0
		return
	if id = %CallerId%
		return

	CallerId := id	
	gosub,<FocusTC>
	gosub,<Select_Mode_TC>
	return
}

; * 非TC窗口按下后激活TC窗口
; * TC窗口按下后复制当前选中文件返回原窗口后粘贴
<OpenTCDialog>:
{
	WinGetClass, class, A
	
	;在Total Commander按下快捷键时，激活调用窗体并执行粘贴操作
	if class = TTOTAL_CMD
	{
		gosub,<TC_Selected>
		return
	}

	if class <> TTOTAL_CMD
	{
		CallerId := WinExist("A")
		if CallerId = 0
			return

		gosub,<FocusTC>
		gosub,<Select_Mode_TC>
		return
	}

	return
}

<TC_PreSelected>:
	SendPos(2021)
	sleep,100 ; 此处用clipwait貌似会出错？

	;未多选
	IfNotInString,clipboard,`n
	{
		;当前复制项为文件夹时
		StringRight,str,clipboard,1
		IfInString,str,\
			{
				SendPos(2003)
				return
			}
	}

	;return 注意，此处无需return

<TC_Selected>:
{
	vim.mode("normal","TTOTAL_CMD")
	SendPos(2021)
	sleep,100

	;仅在多选时两侧增加双引号
	IfInString,clipboard,`n
	{
		files := ""
		Loop, parse, clipboard, `n, `r
			files .= """" A_LoopField  """ "
		clipboard := files
	}

	;未发现可激活的调用窗体时，最小化TC
	if CallerId = 0
	{
		Winminimize,AHK_CLASS TTOTAL_CMD
		sleep,500
		CallerId := WinExist("A")
		if CallerId = 0
			return
	}

	WinActivate,ahk_id %CallerId%
	WinWait,ahk_id %CallerId%
	send, ^v
	send, {Enter}
	return
}
