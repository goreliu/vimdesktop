
;自动输入用户名/密码信息
<KeePassAutoType>:
{
	If not WinExist("ahk_exe KeePass.exe")
	{
		WinGetClass, class, A

		pid := OpenKeePass()
		if pid = 0
			return
		
		;读取数据文件路径并解析到底文件名
		data :=""
		IniRead data, %ConfigPath%, KeePass_Config, DataPath, ""
		if data = ""
		{
			msgbox, 尚未配置KeePass的数据路径：KeePass_Config/DataPath
			return
		}
		file := ""
		Loop, parse, data, `\
		{
		    file := A_LoopField
		}


		;检测直到确认打开了数据库
		WinWait ,%file% - KeePass ahk_class WindowsForms10.Window.8.app.0.33c0d9d,,9

		;超时退出
		if ErrorLevel
			return
		
		winhide,ahk_class WindowsForms10.Window.8.app.0.33c0d9d
		WinActivate,ahk_class %class%
	}

	
	AutoType()
	return
}

<KeePassOpen>:
{
	if not WinExist("ahk_exe KeePass.exe")
		OpenKeePass()	

	WinShow , ahk_class WindowsForms10.Window.8.app.0.33c0d9d
	WinActivate ,ahk_class WindowsForms10.Window.8.app.0.33c0d9d
	return
}


;打开KeePass
OpenKeePass(){
	app := ""
	IniRead app, %ConfigPath%, KeePass_Config, AppPath, ""
	if app = ""
	{
		msgbox, 尚未配置KeePass的执行路径：KeePass_Config/Path
		return 0
	}
	
	data :=""
	IniRead data, %ConfigPath%, KeePass_Config, DataPath, ""
	if data = ""
	{
		msgbox, 尚未配置KeePass的数据路径：KeePass_Config/DataPath
		return 0
	}

	;加载命令行参数
	IniRead options,%ConfigPath%,KeePass_Config,CommandLineOptions,""

	Run, %app% %data% %options%

	pid := 0
	Loop,4
	{
		Process, Exist, KeePass.exe
		pid := ErrorLevel
		if pid
			return pid
		Sleep,500
	}

	if pid = 0
	{
		MsgBox 未能启动KeePass，请参考帮助文件配置启动参数
		return 0
	}


	return pid
}

AutoType(){
	app := ""
	IniRead app, %ConfigPath%, KeePass_Config, AppPath, ""
	if app = ""
	{
		msgbox, 尚未配置KeePass的执行路径：KeePass_Config/Path
		return 0
	}
	
	Run, %app% -auto-type 
}
