global ConfigPath
global vim
global ini
global default_enable_show_info
global editor
global VIMD_CMD_LIST

VimdRun()
{
    CustomInit := "CustomInit"
    if (IsLabel(CustomInit))
    {
        GoSub, %CustomInit%
    }

    ConfigPath := A_ScriptDir "\conf\vimd.ini"
    IniRead, CustomConfigPath, %ConfigPath%, config, custom_config_path
    if (FileExist(A_ScriptDir "\conf\" CustomConfigPath))
    {
        ConfigPath := A_ScriptDir "\conf\" CustomConfigPath
    }

    vim := class_vim()
    VIMD_CMD_LIST := []

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

    ; 定时检查配置文件更新
    SetTimer, WatchConfigFile, 2000
}

CheckPlugin()
{
    ExtensionsAHK := A_ScriptDir "\plugins\plugins.ahk"

    ; 检测是否有新增插件
    Loop, %A_ScriptDir%\plugins\*, 2, 0
    {
        IniRead, PluginTime, %ExtensionsAHK%, ExtensionsTime, %A_LoopFileName%
        if (PluginTime = "ERROR")
        {
            MsgBox, 发现新插件 %A_LoopFileName%，将自动加载该插件

            Filedelete, %ExtensionsAHK%

            Loop, %A_ScriptDir%\plugins\*.*, 2
                plugins .=  "#include *i `%A_ScriptDir`%\plugins\" A_LoopFileName "\" A_LoopFileName ".ahk`n"
            FileAppend, %plugins%, %ExtensionsAHK%

            SaveTime := "/*`r`n[ExtensionsTime]`r`n"
            Loop, %A_ScriptDir%\plugins\*.*, 2
            {
                plugin :=  A_ScriptDir "\plugins\" A_LoopFileName "\" A_LoopFileName ".ahk"
                FileGetTime, ExtensionsTime, %plugin%, M
                SaveTime .= A_LoopFileName "=" ExtensionsTime "`r`n"
            }
            SaveTime .= "*/`r`n"
            FileAppend, %SaveTime%, %ExtensionsAHK%

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

VIMD_Reload:
    Reload
return

WatchConfigFile:
    FileGetTime, newConfigFileModifyTime, %ConfigPath%

    if (lastConfigFileModifyTime != "" && lastConfigFileModifyTime != newConfigFileModifyTime)
    {
        GoSub, VIMD_Reload
    }
    lastConfigFileModifyTime := newConfigFileModifyTime
return
