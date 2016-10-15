global ConfigPath
global vim
global ini
global default_enable_show_info
global editor
global VIMD_CMD_LIST

VimdRun()
{
    ConfigPath := A_ScriptDir "\conf\vimd.ini"
    IniRead, CustomConfigPath, %ConfigPath%, config, custom_config_path
    if (FileExist(A_ScriptDir "\conf\" CustomConfigPath))
    {
        ConfigPath := A_ScriptDir "\conf\" CustomConfigPath
    }

    vim := class_vim()
    VIMD_CMD_LIST := []

    ; 给 check.ahk 使用
    IniWrite, %A_ScriptHwnd%, %A_Temp%\vimd_auto.ini, auto, hwnd

    if (!FileExist(ConfigPath))
    {
        FileCopy, %A_ScriptDir%\conf\vimd.ini.help.txt, %ConfigPath%
    }

    ini := class_EasyINI(ConfigPath)
    default_enable_show_info := ini.config.default_enable_show_info
    editor := ini.config.editor

    if (ini.config.enable_log == 1)
    {
        global log := new Logger(A_ScriptDir "\debug.log")
    }

    if (ini.config.enable_debug == 1)
    {
        vim.Debug(true)
    }

    ; 第二个参数为存放描述信息的全局变量名
    act := vim.SetAction("VIMD_CMD", "VIMD_CMD_LIST")
    act.SetFunction("VIMD_CMD")

    CheckPlugin()
    CheckHotKey()

    ; 用于接收来自 cehck.ahk 的信息
    OnMessage(0x4a, "ReceiveWMCopyData")
}

CheckPlugin()
{
    ; 检测是否有新增插件
    Loop, %A_ScriptDir%\plugins\*, 2, 0
    {
        IniRead, PluginTime, %A_ScriptDir%\plugins\plugins.ahk, ExtensionsTime, %A_LoopFileName%
        if (PluginTime = "ERROR")
        {
            MsgBox, 发现新插件 %A_LoopFileName%，将自动加载该插件

            if (FileExist(A_ScriptDir "\vimd.exe"))
            {
                Run, %A_ScriptDir%\vimd.exe "%A_ScriptDir%\plugins\check.ahk"
            }
            else
            {
                Run, %A_ScriptDir%\plugins\check.ahk
            }

            IniWrite, 1, %ConfigPath%, plugins, %A_LoopFileName%
            Reload
        }
    }

    for plugin, flag in ini.plugins
        if flag
            vim.LoadPlugin(plugin)
}

CheckHotKey()
{
    for this_key, this_action in ini.global
    {
        this_mode := "normal"
        if RegExMatch(this_action, "\[=[^\[\]]*\]", mode)
        {
            this_mode := Substr(mode, 3, strlen(mode) - 3)
            this_action := RegExReplace(this_action, "\[=[^\[\]]*\]")
        }

        vim.mode(this_mode)
        if RegExMatch(this_action, "^(run|key|dir|tccmd|wshkey|function)\|")
        {
            vim.map(this_key, "VIMD_CMD")
            VIMD_CMD_LIST[this_key] := this_action
        }
        else
        {
            vim.map(this_key, this_action)
        }
    }

    for win, flag in ini.exclude
    {
        vim.SetWin(win, win)
        vim.ExcludeWin(win, true)
    }

    for PluginName, Key in ini
    {
        if RegExMatch(PluginName, "i)(config)|(exclude)|(global)|(plugins)")
            continue

        win := vim.SetWin(PluginName, Key.set_class, Key.set_file)
        vim.SetTimeOut(Key.set_time_out, PluginName)
        vim.SetMaxCount(Key.set_max_count, PluginName)
        if (Key.enable_show_info = 1)
        {
            win.SetInfo(true)
        }

        for m, n in Key
        {
            if RegExMatch(m, "i)(set_class)|(set_file)|(set_time_out)|(set_max_count)|(enable_show_info)")
                continue

            this_mode := "normal"
            this_action := n

            if RegExMatch(this_action, "\[=[^\[\]]*\]", mode)
            {
                this_mode := Substr(mode, 3, strlen(mode) - 3)
                this_action := RegExReplace(n, "\[=[^\[\]]*\]")
            }

            vim.mode(this_mode, PluginName)

            if RegExMatch(n, "i)^(run|key|dir|tccmd|wshkey|function)\|")
            {
                /*
                示例：
                <c-j>=run|notepad.exe
                */

                vim.map(m, "VIMD_CMD", PluginName)
                VIMD_CMD_LIST[m] := n
            }
            else
            {
                vim.map(m, this_action, PluginName)
            }
        }
    }
}

VIMD_CMD()
{
    obj := GetLastAction()
    if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(run)\|", m)
    {
        Run, % substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2)
    }
    else if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(key)\|", m)
    {
        Send, % substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2)
    }
    else if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(dir)\|", m)
    {
        TC_OpenPath(substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2), false)
    }
    else if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(function)\|", m)
    {
        splitedCommand:= StrSplit(substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2), "|")
        functionName := splitedCommand[1]
        if (IsFunc(functionName))
        {
            ; 简单起见只支持一个参数，需要更多函数的话请自行切割字符串
            %functionName%(splitedCommand[2])
        }
        else
        {
            MsgBox, %functionName% 函数不存在！
        }
    }
    else if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(tccmd)\|", m)
    {
        TC_Run(substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2))
    }
    else if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(wshkey)\|", m)
    {
        SendLevel, 1
        Send, % substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2)
    }
}

ReceiveWMCopyData(wParam, lParam)
{
    ; 获取 CopyDataStruct 的 lpData 成员.
    StringAddress := NumGet(lParam + 2 * A_PtrSize)
    ; 从结构中复制字符串.
    AHKReturn := StrGet(StringAddress)
    if RegExMatch(AHKReturn, "i)reload")
    {
        Settimer, VIMD_Reload, 500
        return true
    }
}

VIMD_Reload:
    Reload
return

/*
RunAsAdmin()
{
    local params, uacrep
    Loop %0%
        params .= " " (InStr(%A_Index%, " ") ? """" %A_Index% """" : %A_Index%)
    if(A_IsCompiled)
        uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, A_ScriptFullPath, str, "/r" params, str, A_WorkingDir, int, 1)
    else
        uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, A_AhkPath, str, "/r """ A_ScriptFullPath """" params, str, A_WorkingDir, int, 1)
    if(uacrep = 42) ;UAC Prompt confirmed, application may run as admin
        ExitApp
    else
        MsgBox 未能获取管理员权限，这可能导致部分功能无法运行。
}
*/
