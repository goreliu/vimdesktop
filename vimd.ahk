#SingleInstance, Force

CoordMode, Tooltip, Screen
CoordMode, Mouse, Screen
Coordmode, Menu, Window
SetControlDelay, -1
SetKeyDelay, -1
Detecthiddenwindows, on
FileEncoding, utf-8

global ConfigPath := A_ScriptDir "\vimd.ini"
global vim := class_vim()
global ini := class_EasyINI(A_ScriptDir "\vimd.ini")
global default_enable_show_info := ini.config.default_enable_show_info
global editor := ini.config.editor

Menu, Tray, Icon, %A_ScriptDir%\viatc.ico
Menu, Tray, NoStandard
Menu, Tray, Add, 查看热键(&K), <vc_Keymap>
Menu, Tray, Add, 查看插件(&P), <vc_Plugin>
Menu, Tray, Add,
Menu, Tray, Add, 重启(&R), <Reload>
Menu, Tray, Add, 退出(&X), <Exit>
iniWrite, %A_ScriptHwnd%, %A_Temp%\vimd_auto.ini, auto, hwnd

if (!FileExist(ConfigPath))
{
    FileCopy, %ConfigPath%.help.txt, %ConfigPath%
}

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
OnMessage(0x4a, "Receive_WM_COPYDATA")

return


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
    global VIMD_CMD_LIST := IsObject(VIMD_CMD_LIST) ? VIMD_CMD_LIST : []

    for this_key, this_action in ini.global
    {
        this_mode := "normal"
        if RegExMatch(this_action, "\[=[^\[\]]*\]", mode)
        {
            this_mode := Substr(mode, 3, strlen(mode) - 3)
            this_action := RegExReplace(this_action, "\[=[^\[\]]*\]")
        }

        vim.mode(this_mode)
        if RegExMatch(this_action, "^((run)|(key)|(dir)|(tccmd))\|")
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

            if RegExMatch(n, "i)^((run)|(key)|(dir)|(tccmd))\|")
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
    global VIMD_CMD_LIST
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
    else if RegExMatch(VIMD_CMD_LIST[obj.keytemp], "i)^(tccmd)\|", m)
    {
        TC_Run(substr(VIMD_CMD_LIST[obj.keytemp], strlen(m1) + 2))
    }
}

Receive_WM_COPYDATA(wParam, lParam)
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

#Include %A_ScriptDir%\core\class_vim.ahk
#Include %A_ScriptDir%\core\VimDConfig.ahk
#Include %A_ScriptDir%\lib\class_EasyINI.ahk
#Include %A_ScriptDir%\lib\acc.ahk
#Include %A_ScriptDir%\lib\ini.ahk
#Include %A_ScriptDir%\lib\gdip.ahk
#Include %A_ScriptDir%\lib\Logger.ahk
#Include %A_ScriptDir%\plugins\plugins.ahk
; 用户自定义配置
#Include *i %A_ScriptDir%\custom.ahk
