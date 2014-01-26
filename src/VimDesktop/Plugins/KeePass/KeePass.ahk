;激活TC，并定位到命令行

<KeePassAutoType>:
{
	Process, Exist, KeePass.exe
	if ErrorLevel = 0
	{
		kp := ""
		IniRead kp, %ConfigPath%, Config, KeePass.Run, ""
		if kp = ""
		{
			msgbox, 尚未配置KeePass的启动参数：KeePass.Run=KeePass.exe路径 数据文件路径
			return
		}

		Run, %kp%

		pid := 0
		Loop,4
		{
			Process, Exist, KeePass.exe
			pid := ErrorLevel
			if pid
				break
			Sleep,500
		}
		
		if pid = 0
		{
			MsgBox 未能启动KeePass，请参考帮助文件配置启动参数
			return
		}

		return
	}

	IniRead key, %ConfigPath%, config, KeePass.GlobalAutoType, ""
	if key
		send %key%
	return
}

