#SingleInstance,Force
CoordMode, Tooltip, Screen
CoordMode, Mouse, Screen
Coordmode, Menu,Window
SetControlDelay,-1
SetKeyDelay,-1
Detecthiddenwindows,on
Menu,Tray,Icon,%A_ScriptDir%\viatc.ico
Menu,Tray,NoStandard
Menu,Tray,Add,查看热键(&K),<vc_Keymap>
Menu,Tray,Add,查看插件(&P),<vc_Plugin>
Menu,Tray,Add,
Menu,Tray,Add,重启(&R),<Reload>
Menu,Tray,Add,退出(&X),<Exit>
iniWrite,%A_ScriptHwnd%,%A_Temp%\vimd_auto.ini,auto,hwnd
; 启用vim
vim := class_vim()
;vim.SetAction("VIMD_CMD","执行命令")
Global ConfigPath := A_ScriptDir  "\vimd.ini"
ini := class_EasyINI(A_ScriptDir "\vimd.ini")
;vimdrc := yaml(A_ScriptDir "\config.yaml")
;vimdrc := Class_EasyINI(A_ScriptDir "\.INI")
;
act := vim.SetAction("VIMD_CMD","VIMD命令执行")
act.SetFunction("VIMD_CMD")
;vim.Debug(true)
CheckPlugin()
CheckHotKey()
; 用于接收来自cehck.ahk的信息
OnMessage(0x4a, "Receive_WM_COPYDATA")
return

GetVimdConfig()
{
  ;Global vimdrc
  ;return vimdrc
  Global ini
  return ini
}

SaveVimdConfig()
{
  Global ini
  ini.save()
  ;Global vimdrc
  ;yaml_Save(vimdrc,A_ScriptDir "\config.yaml")
}

CheckPlugin()
{
  global vim
  dc := GetVimdConfig()
  for plugin , bold in dc.plugins
    If bold
      vim.LoadPlugin(plugin)
}
CheckHotKey()
{
    global vim, arr_vimd
    arr_vimd := IsObject(arr_vimd) ? arr_vimd : []
    ini := GetVimdConfig()
    for i , k in ini.global
    {
        if not strlen(i)
            Continue
        if RegExMatch(k,"\[=[^\[\]]*\]",mode)
        {
            this_mode := Substr(mode,3,strlen(mode)-3)
						vim.Mode(this_mode)
            this_action := RegExReplace(k,"\[=[^\[\]]*\]")
            ;vim.map(i, this_action)
            If RegExMatch(this_action,"^((run)|(key))\|")
            {
                vim.map(i,"VIMD_CMD")
                arr_vimd[i] := this_action
            }
            else
            {
                vim.map(i, this_action)
            }

        }
    }
    for i , k in ini.exclude
    {
        vim.Setwin(i,i)
        vim.excludeWin(i,True)
    }
    for i , k in ini
    {
        If RegExMatch(i, "i)(config)|(exclude)|(global)|(plugins)")
            Continue
        win := vim.SetWin(i, k.set_class, k.set_file)
        vim.SetTimeOut(k.set_time_out, i)
        vim.SetMaxCount(k.set_Max_count, i)
        win.SetInfo(k.set_show_info)
        for m , n in k
        {
						if not strlen(m)
								Continue
            if RegExMatch(m, "i)(set_class)|(set_file)|(set_time_out)|(set_Max_count)|(set_show_info)")
								Continue
						if RegExMatch(n,"\[=[^\[\]]*\]",mode)
						{
								this_mode := Substr(mode,3,strlen(mode)-3)
								vim.mode(this_mode, i)
								this_action := RegExReplace(n,"\[=[^\[\]]*\]")
								vim.map(m, this_action, i)
						}
            else If RegExMatch(n,"i)^((run)|(key))\|")
            {
								vim.mode("normal", i)
                                    /*
                                    <c-j> 记事本 run|notepad.exe
                                    */

                vim.map(m,"VIMD_CMD",i)
                arr_vimd[m] := n
            }
        }
    }
}
/*
  global vim,arr_vimd
  arr_vimd := IsObject(arr_vimd) ? arr_vimd : []
  dc := GetVimdConfig()
  for win , winobj in dc.keymap
  {
    If IsObject(winObj)
    {
      If win = global
        win := ""
      Else
      {
        set := winObj.set
        w := vim.SetWin(win, set.class, set.filepath, set.title)
        vim.SetMaxCount(set.maxcount, win)
        vim.SetTimeOut(set.TimeOut, win)
        w.SetInfo(set.Info)
      }
      for mode , keyobj in winObj
      {
        if mode = set
          Continue
        vim.SetMode(mode,win)
        for key, action in keyObj
        {
          If RegExMatch(action,"i)^((run)|(key))\|")
          {
            vim.Map(key,"VIMD_CMD",win)
            arr_vimd[key] := action
          }
          Else
            vim.Map(key,action,win)
        }
      }
    }
  }
}
*/


VIMD_CMD()
{
  global arr_vimd
  obj := GetLastAction()
  If RegExMatch(arr_vimd[obj.keytemp],"i)^(run)\|",m)
  {
    run,% substr(arr_vimd[obj.keytemp],strlen(m1)+2)
  }
  If RegExMatch(arr_vimd[obj.keytemp],"i)^(key)\|",m)
  {
    Send,% substr(arr_vimd[obj.keytemp],strlen(m1)+2)
  }
}

; Receive_WM_COPYDATA(wParam, lParam) {{{2
Receive_WM_COPYDATA(wParam, lParam){
    StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
    AHKReturn := StrGet(StringAddress)  ; 从结构中复制字符串.
	If RegExMatch(AHKReturn,"i)reload")
  {
		Settimer,VIMD_Reload,500
    return true
  }
}
VIMD_Reload:
  Reload
return

RunAsAdmin()
{
    local params, uacrep
    Loop %0%
        params .= " " (InStr(%A_Index%, " ") ? """" %A_Index% """" : %A_Index%)
    If(A_IsCompiled)
        uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, A_ScriptFullPath, str, "/r" params, str, A_WorkingDir, int, 1)
    else
        uacrep := DllCall("shell32\ShellExecute", uint, 0, str, "RunAs", str, A_AhkPath, str, "/r """ A_ScriptFullPath """" params, str, A_WorkingDir, int, 1)
    If(uacrep = 42) ;UAC Prompt confirmed, application may run as admin
        ExitApp
    else
        MsgBox 未能获取管理员权限，这可能导致部分功能无法运行。
}

#Include %A_ScriptDir%\lib\class_EasyINI.ahk
#Include %A_ScriptDir%\lib\class_vim.ahk
#Include %A_ScriptDir%\lib\acc.ahk
#Include %A_ScriptDir%\Lib\ini.ahk
#Include %A_ScriptDir%\lib\gdip.ahk
#Include %A_ScriptDir%\Lib\VIMD_plugins.ahk
