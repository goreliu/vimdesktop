KeePass:

vim.SetAction("<KeePass_NormalMode>", "进入normal模式")

vim.SetWin("KeePass", "KeePass", "KeePass.exe")

 ; normal模式（必需）
    vim.SetMode("normal", "KeePass")

    vim.Map("j", "<Down>", "KeePass")
    vim.Map("k", "<Up>", "KeePass")
    vim.Map("/","<focusSearch>","KeePass")

    vim.BeforeActionDo("KeePass_ForceInsertMode", "KeePass")

return

; 对指定控件使用insert模式
KeePass_ForceInsertMode(){
    ControlGetFocus, ctrl, A
    if (RegExMatch(ctrl, "Edit"))
        return true
    return false
}

<focusSearch>:
	ControlFocus,Edit1,A
	return

;自动输入用户名/密码信息
<KeePassAutoType>:
{
    preId := 0
    If not WinExist("ahk_exe KeePass.exe")
    {
        WinGet, preId, ID, A
        ActivateKeePass()
        WinGet, pid, ID, A
        WinMinimize,ahk_id %pid%
        winhide,ahk_id %pid%
    }
    
    if preId
        WinActivate, ahk_id %preId%
    
    AutoType()

    return
}

;显示/隐藏KeePass
<ToggleKeePass>:
{
    WinGet,name,ProcessName,A

    ;隐藏KeePass
    if name = KeePass.exe
    {
        WinGet, pid, ID, A
        WinMinimize,ahk_id %pid%
        winhide,ahk_id %pid%
        return
    }        

    ;激活KeePass
    ActivateKeePass()
    
    return
}

;激活KeePass
ActivateKeePass()
{
    ;WinActivate不能激活keepass2.27,尝试发现重新重新运行下Keepass.exe可激活之
    ;if not WinExist("ahk_exe KeePass.exe")
        OpenKeePass()

    Process, Exist, KeePass.exe
    pid := ErrorLevel
    if pid=0
        return 0

    Loop,9
    {
        WinGet,name,ProcessName,A
        if name = KeePass.exe
            return
        pid := OpenKeePass()
        WinActivate, ahk_id %pid%
        Sleep,500
    }
    
    return pid
}

;打开KeePass
OpenKeePass()
{
    ;读取KeePass路径
    app := ""
    IniRead app, %ConfigPath%, KeePass_Config, AppPath, ""
    if app = ""
    {
        msgbox, 尚未配置KeePass的执行路径：KeePass_Config/Path
        return 0
    }
    
    ;读取数据文件路径
    data :=""
    IniRead data, %ConfigPath%, KeePass_Config, DataPath, ""
    if data = ""
    {
        msgbox, 尚未配置KeePass的数据路径：KeePass_Config/DataPath
        return 0
    }

    ;加载命令行参数
    IniRead options,%ConfigPath%,KeePass_Config,CommandLineOptions,""

    ;启动KeePass，已启动时不再指定参数信息
    if not WinExist("ahk_exe KeePass.exe")
        Run, %app% %data% %options%
    else
        Run, %app%
    

    ;检测直到发现KeePass.exe进程
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
        return 0
    }

    ;解析数据文件名
    file := ""
    Loop, parse, data, `\
    {
        file := A_LoopField
    }

    ;检测直到确认打开了数据库
    WinWait ,%file% - KeePass ahk_exe KeePass.exe,,20

    ;超时退出
    if ErrorLevel
    {
        Process,Close,KeePass.exe
        return 0
    }

    return pid
}

;执行自动输入用户名、密码
AutoType()
{
    app := ""
    IniRead app, %ConfigPath%, KeePass_Config, AppPath, ""
    if app = ""
    {
        msgbox, 尚未配置KeePass的执行路径：KeePass_Config/Path
        return 0
    }

    ;切换至英文输入法，并删除当前输入框中的内容
    GoSub, <SwitchToEngIME>
    send ^a
    send {del}
    
    Run, %app% -auto-type
}
