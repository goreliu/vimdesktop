global __vimLastAction

; 初始化class_Vim
vim_Init:
    #UseHook
    SetKeyDelay, -1
return

; 用于热键映射
vim_Key:
    vim.Key()
return

; 用于热键超时
vim_TimeOut:
    vim.IsTimeOut()
return

; 用于Count计数
Internal:
    __v.SetPlugin("Internal", "Array", "0.1", "内置插件")
    __v.SetAction("<1>", "数字 1")
    __v.SetAction("<2>", "数字 2")
    __v.SetAction("<3>", "数字 3")
    __v.SetAction("<4>", "数字 4")
    __v.SetAction("<5>", "数字 5")
    __v.SetAction("<6>", "数字 6")
    __v.SetAction("<7>", "数字 7")
    __v.SetAction("<8>", "数字 8")
    __v.SetAction("<9>", "数字 9")
    __v.SetAction("<0>", "数字 0")
    __v.SetAction("<>", "空操作")
    __v.SetAction("<Pass>", "空操作")
    __v.SetAction("<Default>", "恢复默认")
    __v := ""
return

<1>:
<2>:
<3>:
<4>:
<5>:
<6>:
<7>:
<8>:
<9>:
<0>:
<>:
<Pass>:
<Default>:
return

Class_vim()
{
    global __v
    GoSub, vim_Init
    __v := v := new __vim
    __v.LoadPlugin("Internal")
    return v
}

GetLastAction()
{
    return __vimLastAction
}

ShowInfo()
{
    Global vim
    obj := vim.GetMore(true)
    winObj := vim.GetWin(vim.LastFoundWin)
    if winObj.Count
        np .= winObj.Count
    Loop, % obj.MaxIndex()
    {
        act := vim.GetAction(obj[A_Index]["Action"])
        key := RegExReplace(obj[A_Index]["key"], "<S-(.*)>", "$1")

        ; Type = 1 : Function
        if (act.Type = 1)
        {
            ActionDescList := act.Comment
            np .= key "`t" %ActionDescList%[Key] "`n"
        }
        else
        {
            np .= key "`t" act.Comment "`n"
        }

        if (A_Index = 1)
            np .= "=====================`n" 
    }
    MouseGetPos, posx, posy, A
    posx += 40
    posy += 40
    Tooltip, %np%, %posx%, %posy%
}

HideInfo()
{
    ; 当屏幕有非快捷键补全帮助信息时，不清理
    Global showToolTipStatus
    if (!showToolTipStatus)
    {
        Tooltip
    }
}

; 定义数据结构
; Class __vim {{{1
Class __vim
{
    __new()
    {
        this.PluginList := []
        this.WinList    := []
        this.WinInfo    := []
        this.ActionList := []
        this.ActionFromPlugin := []
        this.ExcludeWinList := []
        this.winGlobal  := new __win
        this.ErrorCode  := 0
        tihs.ActionFromPluginName := ""
        this.LastFoundWin := ""
    }
    
    ; LoadPlugin(PluginName) {{{2
    ; 用于注册插件
    LoadPlugin(PluginName)
    {
        if this.PluginList[PluginName]
            return this.PluginList[PluginName]
        p := new __Plugin(PluginName)
        this.PluginList[PluginName] := p
        back := this.ActionFromPluginName
        this.ActionFromPluginName := PluginName
        p.CheckSub()
        if p.Error
        {
            MsgBox load plugin "%PluginName%" error
            this.ActionFromPluginName := back
        }
    }

    ; SetPlugin(PluginName, Author = "", Ver = "", Comment = "") {{{2
    ; 设置Plugin信息
    SetPlugin(PluginName, Author = "", Ver = "", Comment = "")
    {
        p := this.PluginList[PluginName]
        p.Author := Author
        p.Ver := Ver
        p.Comment := Comment
    }

    ; GetPlugin(PluginName) {{{2
    ; 获取Plugin信息
    GetPlugin(PluginName)
    {
        return this.PluginList[PluginName]
    }

    ; Comment(Action, Desc, Complex = 1) {{{2
    ; 兼容老版本的vimcore.ahk
    Comment(Action, Desc = "", Complex = 1)
    {
        act := this.SetAction(Action, Desc)
        if not complex ; 不允许多次运行
            act.SetMaxTimes(1)
        return act
    }

    ; SetAction(Name, Comment) {{{2
    ; 用于为Action(动作)进行注释
    SetAction(Name, Comment = "")
    {
        if this.ActionList[Name]
            ra := This.ActionList[Name] 
        else
            ra := This.ActionList[Name] := new __Action(Name, Comment)
        This.ActionFromPlugin[Name] := this.ActionFromPluginName
        return ra
    }

    ; GetAction(Name) {{{2
    ; 获取Action的信息
    GetAction(Name)
    {
        return this.ActionList[Name]
    }

    ; SetWin(winName, class, filepath, title) {{{2
    ; 添加win成员
    SetWin(winName, class, filepath = "", title = "")
    {
        if this.WinList[winName]
            rw := this.WinList[winName]
        else
            rw := this.WinList[winName] := new __win(class, filepath, title)
        this.WinInfo["class`t"class]       := winName
        this.WinInfo["filepath`t"filepath] := winName
        this.WinInfo["title`t"title]       := winName
        return rw
    }

    ; GetWin(winName) {{{2
    GetWin(winName = "")
    {
        if strlen(winName)
            return this.WinList[winName]
        else
            return this.winGlobal
    }

    ; CheckWin() {{{2
    CheckWin()
    {
        /*
        WinGetTitle, t, A
        if Strlen(winName := this.WinInfo["title`t"t])
            return winName
        */

        WinGet, f, ProcessName, A
        if Strlen(winName := this.WinInfo["filepath`t"f])
            return winName
        WinGetClass, c, A
        if Strlen(winName := this.WinInfo["class`t"c])
            return winName
    }

    ; mode(mode, win = "") {{{2
    ; 兼容老版本的vimcore.ahk
    mode(mode, win = "")
    {
        if not IsObject(this.GetWin(win))
            this.SetWin(win, win)
        return this.SetMode(mode, win)
    }

    ; SetMode(modeName, winName) {{{2
    SetMode(modeName, winName = "")
    {
        winObj := This.GetWin(winName)
        return winObj.ChangeMode(modeName)
    }

    ; SetModeFunction(func, modeName, winName = "") {{{2
    SetModeFunction(func, modeName, winName = "")
    {
        winObj := This.GetWin(winName)
        modeObj := winObj.modeList[modeName]
        modeObj.modeFunction := func
    }

    ; GetMode(winName) {{{2
    ; 获取指定win中当前的模式
    GetMode(winName = "")
    {
        winObj := This.GetWin(winName)
        return winObj.modeList[winObj.ExistMode()]
    }

    ; GetInputState {{{2
    ; 0：英文 1：中文
    GetInputState(WinTitle = "A")
    {
        ControlGet, hwnd, HWND, , , %WinTitle%
        if (A_Cursor = "IBeam")
            return 1
        if (WinActive(WinTitle))
        {
            ptrSize := !A_PtrSize ? 4 : A_PtrSize
            VarSetCapacity(stGTI, cbSize := 4 + 4 + (PtrSize * 6) + 16, 0)
            NumPut(cbSize, stGTI, 0, "UInt")   ;   DWORD   cbSize;
            hwnd := DllCall("GetGUIThreadInfo", Uint, 0, Uint, &stGTI)
                             ? NumGet(stGTI, 8 + PtrSize, "UInt") : hwnd
        }
        return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint, hwnd)
            , UInt, 0x0283  ;Message : WM_IME_CONTROL
            , Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
            , Int, 0)      ;lParam  : 0
    }

    ; BeforeActionDo(Function, winName = "") {{{2
    BeforeActionDo(Function, winName = "")
    {
        winObj  := this.GetWin(winName)
        winObj.BeforeActionDoFunc := Function
    }

    ; AfterActionDo(Function, winName = "") {{{2
    AfterActionDo(Function, winName = "")
    {
        winObj := this.GetWin(winName)
        winObj.AfterActionDoFunc := Function
    }

    ; SetMaxCount(Int, winName) {{{2
    SetMaxCount(Int, winName = "")
    {
        winObj := This.GetWin(winName)
        winObj.MaxCount := int
    }

    ; GetMaxCount(winName) {{{2
    GetMaxCount(winName = "")
    {
        winObj := This.GetWin(winName)
        return winObj.MaxCount
    }

    ; SetCount(int, winName) {{{2
    SetCount(int, winName = "")
    {
        winObj := This.GetWin(winName)
        winObj.Count := int
    }

    ; GetCount(winName) {{{2
    GetCount(winName = "")
    {
        winObj := This.GetWin(winName)
        return winObj.Count
    }

    ; SetTimeOut(Int, winName) {{{2
    SetTimeOut(Int, winName = "")
    {
        winObj := This.GetWin(winName)
        winObj.TimeOut := int
    }

    ; GetTimeOut(winName) {{{2
    GetTimeOut(winName = "")
    {
        winObj := This.GetWin(winName)
        return winObj.TimeOut
    }

    ; Map(keyName, Action, winName) {{{2
    ; 例 Map("<C-A>jjj", <a>, "TC")
    ; Map("<nowait>jk", <b>, "TC")
    Map(keyName, Action, winName = "")
    {
        if not this.GetAction(Action)
        {
            if Islabel(action)
                this.SetAction(Action, Action)
            else
            {
                MsgBox % "map " keyname " to "  action  " error"
                this.ErrorCode := "MAP_ACTION_ERROR"
                return
            }
        }

        winObj := This.GetWin(winName)
        modeObj := this.GetMode(winName)
        Class := winObj.class
        filepath := winObj.filepath
        if winName
        {
            if strlen(filepath)
                Hotkey, IfWinActive, ahk_exe %filepath%
            else
                Hotkey, IfWinActive, ahk_class %class%
        }
        else
            Hotkey, IfWinActive
        keyName := RegExReplace(keyName, "i)<nowait>", "", nowait)
        keyName := RegExReplace(keyName, "i)<super>", "", super)
        newkeyName := keyName
        keyIndex := 0
        Loop
        {
            if not strlen(newkeyName)
                break
            else
            {
                saveMoreKey .= thisKey
                modeobj.SetMoreKey(saveMoreKey)
            }

            if RegExMatch(newkeyName, "P)^<.+?>", m)
            {
                thisKey := SubStr(newkeyName, 1, m)
                newkeyName := SubStr(newkeyName, m+1)
            }
            else
            {
                thisKey := SubStr(newkeyName, 1, 1)
                newKeyName := SubStr(newkeyName, 2)
            }

            if RegExMatch(thisKey, "^([A-Z])$", m)
                thisKey := "<S-" m ">"
            SaveKeyName .= thisKey
            key := this.Convert2AHK(thisKey)
            this.Debug.Add("Map: " thiskey " to: " Action)

            if (Action <> "<Default>")
            {
                Hotkey, %Key%, vim_Key, On, UseErrorLevel
            }
            else
            {
                Hotkey, %Key%, Off, UseErrorLevel
            }

            if ErrorLevel
            {
                Msgbox % KeyName "`n" key "`n映射错误"
                this.ErrorCode := "MAP_KEY_ERROR"
                return
            }
            else
            {
                winObj.SuperKeyList[key] := super
                winObj.KeyList[key] := true
                keyIndex++
            }
        }

        modeObj.SetKeyMap(SavekeyName, Action)
        modeObj.SetNoWait(SavekeyName, nowait)
        return false
    }

    ; ExcludeWin(winName = "", Bold = true) {{{2
    ExcludeWin(winName = "", Bold = true)
    {
        this.ExcludeWinList[winName] := Bold
    }

    ; Toggle(winName) {{{2
    Toggle(winName)
    {
        winObj := this.GetWin(winName)
        winObj.Status := !winObj.Status
        this.Control(winObj.Status, winName)
        return winObj.Status
    }

    ; Control(bold, winName) {{{2
    Control(bold, winName = "", all=false)
    {
        local class

        winObj := this.GetWin(winName)
        class := winObj.Class
        filepath := winObj.filepath
        if Strlen(filepath)
            Hotkey, IfWinActive, ahk_exe %filepath%
        else if Strlen(class)
            Hotkey, IfWinActive, ahk_class %class%
        else
            Hotkey, IfWinActive

        this.Debug.Add("===== Control End  =====")
        for i , k in winObj.KeyList
        {
            if winObj.SuperKeyList[i] And (not all)
                Continue
            this.Debug.Add("class: " class "`tkey: " i "`tcontrol: " bold)
            if bold
                Hotkey, %i%, vim_Key, On
            else
                Hotkey, %i%, vim_Key, off
            winObj.KeyList[i] := bold
        }
        this.Debug.Add("===== Control Start =====")
    }

    ; Copy(winName1, winName2) {{{2
    ; 复制winName1到winName2, winName2按class/filepath/title定义
    Copy(winName1, winName2, class, filepath = "", title = "")
    {
        this.debug.Add("Copy>> "winName1 "`t"  winName2 "`t" class)
        win1 := This.GetWin(winName1)
        win2 := this.SetWin(winName2, class, filepath, title)
        win2.class := class
        win2.filepath := filepath
        win2.title := title
        win2.KeyList := win1.KeyList
        win2.SuperKeyList := win1.SuperKeyList
        win2.modeList  := win1.modeList
        win2.mode      := win1.mode
        win2.LastKey   := win1.LastKey
        win2.KeyTemp   := win1.KeyTemp
        win2.MaxCount  := win1.MaxCount
        win2.Count     := win1.Count
        win2.TimeOut   := win1.TimeOut
        win2.Info      := win1.Info
        win2.BeforeActionDoFunc := win1.BeforeActionDoFunc
        win2.AfterActionDoFunc  := win1.AfterActionDoFunc
        win2.ShowInfoFunc := win1.ShowInfoFunc
        win2.HideInfoFunc := win1.HideInfoFunc
        this.Control(Bold := true, winName2, all := true)
        return win2
    }

    ; CopyMode(win, mode, to) {{{2
    ; 在当前的Win中复制一个模式
    CopyMode(winName, fromMode, toMode)
    {
        winObj := This.GetWin(winName)
        winObj.mode := modeName
        winObj.KeyTemp := ""
        winObj.Count := 0
        from := winObj.modeList[fromMode] 
        from.name  := toMode
        winObj.modeList[toMode] := from
        return from
    }
    
    ; Delete(winName) {{{2
    Delete(winName = "")
    {
        this.Control(false, winName, all := true)
        this.WinList[winName] := ""
    }

    ; GetMore() {{{2
    GetMore(obj = false)
    {
        rt_obj := []
        winObj  := this.GetWin(this.LastFoundWin)
        modeObj := this.GetMode(this.LastFoundWin)
        if Strlen(winObj.KeyTemp)
        {
            r := winObj.KeyTemp "`n"
            rt_obj[1] := {"key":winObj.KeyTemp, "Action":modeObj.GetKeyMap(winObj.KeyTemp)}
            m := "i)^" this.ToMatch(winObj.KeyTemp) ".+"
            for i , k in modeObj.keymapList
            {
                if RegExMatch(i, m)
                {
                    r .= i "`t" modeObj.GetKeyMap(i) "`n" 
                    rt_obj[rt_obj.MaxIndex()+1] := {"key":i, "Action":modeObj.GetKeyMap(i)}
                }
            }

            if obj 
                return rt_obj
            else
                return r
        }
        else
            if winObj.count
                return winObj.count
    }

    ; Clear() {{{2
    Clear(winName = "")
    {
        winObj := This.GetWin(winName)
        winObj.KeyTemp := ""
        winObj.Count := 0
    }
        
    ; Key() {{{2
    Key()
    {
        ; 获取winName
        winName := this.CheckWin()
        ; 获取当前的热键
        k := this.CheckCapsLock(this.Convert2VIM(A_ThisHotkey))
        ; 如果winName在排除窗口中，直接发送热键
        if this.ExcludeWinList[winName]
        {
            Send, % this.Convert2AHK(k, ToSend := true)
            return
        }
        ; 如果当前热键在当前winName无效，判断全局热键中是否有效？
        winObj := this.GetWin(winName)
        if Not winObj.KeyList[A_thisHotkey]
        {
            winObj := this.GetWin()
            if Not winObj.KeyList[A_thisHotkey]
            {
                ; 无效热键，按普通键输出
                Send, % this.Convert2AHK(k, ToSend := true)
                return
            }
            else
                winName := ""
        }

        this.LastFoundWin := winName
        ; 执行在判断热键前的函数, 如果函数返回true，按普通键输出
        if IsFunc(f := winObj.BeforeActionDoFunc)
        {
            if %f%()
            {
                Send, % this.Convert2AHK(k, ToSend := true)
                return
            }
        }

        ; 获取当前模式对应的对象
        modeObj := this.GetMode(winName)
        ; 把当前热键添加到热键缓存中, 并设置最后热键为k
        winObj.KeyTemp .= winObj.LastKey := k
        this.Debug.Add(" win: " winname "`tHotkey: " k)

        /*
            if winObj.Count
                this.Debug.Add(" [" winName "`t热键:" winObj.Count winObj.KeyTemp)
            else
                this.Debug.Add(" [" winName "]`t热键:" winObj.KeyTemp)
        */

        ; 热键缓存是否有对应的Action?
        ; 判断是否有更多热键, 如果当前具有<nowait>设置，则无视更多热键
        if modeObj.GetMoreKey(winObj.KeyTemp) And (Not modeObj.GetNoWait(winObj.KeyTemp))
        {
            ; 启用TimeOut
            if strlen(modeObj.GetKeymap(winObj.KeyTemp))
                if tick := winObj.TimeOut
                    Settimer, Vim_TimeOut, %tick%

            winObj.ShowMore()
            ; 执行在判断热键后的函数, 如果函数返回true，按普通键输出
            if IsFunc(f := winObj.AfterActionDoFunc)
            {
                if %f%()
                    Send, % this.Convert2AHK(k, ToSend := true)
            }

            return
        }

        ; 如果没有更多，热键缓存是否有对应的Action?
        if strlen(actionName := modeObj.GetKeymap(winObj.KeyTemp))
        {
            actObj := this.GetAction(actionName)
            if (actObj.Type = 0) And RegExMatch(actionName , "^<(\d)>$", m)
            {
                ; 数字则进行累加
                winObj.Count := winObj.Count * 10 + m1
                if winObj.MaxCount And winObj.Count > winObj.MaxCount
                    winObj.Count := winObj.MaxCount

                winObj.KeyTemp := ""
                winObj.ShowMore()
                if IsFunc(f := winObj.AfterActionDoFunc)
                    %f%()
                return
            }
            else
            {
                ; 非数字则直接运行
                ;this.Debug.Add("act: " actionName "`tLK: " winObj.KeyTemp)
                __vimLastAction := {"LastKey":k, "winName":winName, "ActionName":ActionName, "KeyTemp":winObj.KeyTemp, "Count":winObj.Count}
                Settimer, Vim_TimeOut, Off
                actObj.Do(winObj.Count)
                winObj.Count := 0
            }
        }
        else
        {
            Settimer, Vim_TimeOut, Off
            ; 如果没有，按普通键输出
            if strlen(actionName := modeObj.GetKeymap(winObj.LastKey))
            {
                actObj := this.GetAction(actionName)
                __vimLastAction := {"LastKey":k, "winName":winName, "ActionName":ActionName, "KeyTemp":winObj.KeyTemp, "Count":winObj.Count}
                actObj.Do(winObj.Count)
                winObj.Count := 0
            }
            else
            {
                Send, % this.Convert2AHK(k, ToSend := true)
                winObj.Count := 0
            }
        }

        winObj.KeyTemp := ""
        winObj.HideMore()
        ; 执行在判断热键后的函数, 如果函数返回true，按普通键输出
        if IsFunc(f := winObj.AfterActionDoFunc)
        {
            if %f%()
                Send, % this.Convert2AHK(k, ToSend := true)
            ; %f%() ;直接运行
        }
        return
    }

    ; IsTimeOut() {{{2
    IsTimeOut()
    {
        winObj  := this.GetWin(this.LastFoundWin)
        modeObj := this.GetMode(this.LastFoundWin)
        act := this.GetAction(modeObj.GetKeyMap(winObj.KeyTemp))
        if act
        {
            winObj.HideMore()
            __vimLastAction := {"LastKey":k, "winName":winName, "ActionName":ActionName, "KeyTemp":winObj.KeyTemp, "Count":winObj.Count}
            act.Do(winObj.Count)
            winObj.Count := 0
            winObj.KeyTemp := ""
            ; 执行在判断热键后的函数, 如果函数返回true，按普通键输出
            if IsFunc(f := winObj.AfterActionDoFunc)
            {
                if %f%()
                Send, % this.Convert2AHK(k, ToSend := true)
            }
            Settimer, Vim_TimeOut, Off
        }
    }

    ; Debug(Bold) {{{2
    Debug(Bold, history = false)
    {
        if Bold
        {
            this.Debug := new __vimDebug(history)
            this.Debug.var(this)
        }
        else
        {
            GUI, vimDebug:Destroy
            this.Debug := ""
        }
    }

    ; Convert2VIM(key) {{{2
    ; 将AHK热键名转换为类VIM的热键名
    ; 例 Convert2VIM("f1")
    Convert2VIM(key)
    {
        if RegExMatch(key, "^[A-Z]$")
            return "<S-" this.Upper(key) ">"
        if RegExMatch(key, "i)^((F1)|(F2)|(F3)|(F4)|(F5)|(F6)|(F7)|(F8)|(F9)|(F10)|(F11)|(F12))$")
            return "<" key ">"
        if RegExMatch(key, "i)^((AppsKey)|(Tab)|(Enter)|(Space)|(Home)|(End)|(CapsLock)|(ScroollLock)|(Up)|(Down)|(Left)|(Right)|(PgUp)|(PgDn))$")
            return "<" key ">"
        if RegExMatch(key, "i)^((BS)|(BackSpace))$")
            return "<BS>"
        if RegExMatch(key, "i)^((Esc)|(Escape))$")
            return "<Esc>"
        if RegExMatch(key, "i)^((Ins)|(Insert))$")
            return "<Insert>"
        if RegExMatch(key, "i)^((Del)|(Delete))$")
            return "<Delete>"
        if RegExMatch(key, "i)^PrintScreen$")
            return "<PrtSc>"
        if RegExMatch(key, "i)^shift\s&\s(.*)", m) or RegExMatch(key, "^\+(.*)", m)
            return "<S-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^lshift\s&\s(.*)", m) or RegExMatch(key, "^<\+(.*)", m)
            return "<LS-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^rshift\s&\s(.*)", m) or RegExMatch(key, "^>\+(.*)", m)
            return "<RS-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^Ctrl\s&\s(.*)", m) or RegExMatch(key, "^\^(.*)", m)
            return "<C-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^lctrl\s&\s(.*)", m) or RegExMatch(key, "^<\^(.*)", m)
            return "<LC-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^rctrl\s&\s(.*)", m) or RegExMatch(key, "^>\^(.*)", m)
            return "<RC-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^alt\s&\s(.*)", m) or RegExMatch(key, "^\!(.*)", m)
            return "<A-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^lalt\s&\s(.*)", m) or RegExMatch(key, "^<\!(.*)", m)
            return "<LA-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^ralt\s&\s(.*)", m) or RegExMatch(key, "^>\!(.*)", m)
            return "<RA-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^lwin\s&\s(.*)", m) or RegExMatch(key, "^#(.*)", m)
            return "<W-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^space\s&\s(.*)", m)
            return "<SP-" this.Upper(m1) ">"
        if RegExMatch(key, "i)^alt$")
            return "<Alt>"
        if RegExMatch(key, "i)^ctrl$")
            return "<Ctrl>"
        if RegExMatch(key, "i)^shift$")
            return "<Shift>"
        if RegExMatch(key, "i)^lwin$")
            return "<Win>"
        return key
    }

    Upper(k)
    {
        StringUpper, k, k
        return k
    }

    ; Convert2AHK(key, ToSend=false) {{{2
    ; 将类VIM的热键名转换为AHK热键名
    ; 例 Convert2AHK("<F1>")
    Convert2AHK(key, ToSend=false)
    {
        this.CheckCapsLock(key)
        if RegExMatch(key, "^<.*>$")
        {
            key := SubStr(key, 2, strlen(key)-2)
            if RegExMatch(key, "i)^((F1)|(F2)|(F3)|(F4)|(F5)|(F6)|(F7)|(F8)|(F9)|(F10)|(F11)|(F12))$")
                return ToSend ? "{" key "}" : key
            if RegExMatch(key, "i)^((AppsKey)|(Tab)|(Enter)|(Space)|(Home)|(End)|(CapsLock)|(ScroollLock)|(Up)|(Down)|(Left)|(Right)|(PgUp)|(PgDn)|(BS)|(ESC)|(Insert)|(Delete))$")
                return ToSend ? "{" key "}" : key
            if RegExMatch(key, "i)^PrtSc$")
                return ToSend ? "{PrintScreen}" : "PrintScreen"
            if RegExMatch(key, "i)^alt$")
                return ToSend ? "{!}" : "alt"
            if RegExMatch(key, "i)^ctrl$")
                return ToSend ? "{^}" : "ctrl"
            if RegExMatch(key, "i)^shift$")
                return ToSend ? "{+}" : "shift"
            if RegExMatch(key, "i)^win$")
                return ToSend ? "{#}" : "lwin"
            if RegExMatch(key, "<LT>")
                return "<"
            if RegExMatch(key, "<RT>")
                return ">"
            if RegExMatch(key, "i)^S\-(.*)", m)
                return ToSend ? "+" this.CheckToSend(m1) : "+" m1 
            if RegExMatch(key, "i)^LS\-(.*)", m)
                return ToSend ? "<+" this.CheckToSend(m1) : "<+" m1
            if RegExMatch(key, "i)^RS-(.*)", m)
                return ToSend ? ">+" this.CheckToSend(m1) : ">+" m1
            if RegExMatch(key, "i)^C\-(.*)", m)
                return ToSend ? "^" this.CheckToSend(m1) : "^" m1
            if RegExMatch(key, "i)^LC\-(.*)", m)
                return ToSend ? "<^" this.CheckToSend(m1) : "<^" m1
            if RegExMatch(key, "i)^RC\-(.*)", m)
                return ToSend ? ">^" this.CheckToSend(m1) : ">^" m1
            if RegExMatch(key, "i)^A\-(.*)", m)
                return ToSend ? "!" this.CheckToSend(m1) : "!" m1
            if RegExMatch(key, "i)^LA\-(.*)", m)
                return ToSend ? "<!" this.CheckToSend(m1) : "<!" m1
            if RegExMatch(key, "i)^RA\-(.*)", m)
                return ToSend ? ">!" this.CheckToSend(m1) : ">!" m1
            if RegExMatch(key, "i)^w\-(.*)", m)
                return ToSend ? "#" this.CheckToSend(m1) : "#" m1
            if RegExMatch(key, "i)^SP\-(.*)", m)
                return ToSend ? "{space}" this.CheckToSend(m1) : "space & " m1
        }
        else
            return key
    }

    CheckToSend(key)
    {
        if RegExMatch(key, "i)^((F1)|(F2)|(F3)|(F4)|(F5)|(F6)|(F7)|(F8)|(F9)|(F10)|(F11)|(F12))$")
            return "{" key "}" 
        if RegExMatch(key, "i)^((AppsKey)|(Tab)|(Enter)|(Space)|(Home)|(End)|(CapsLock)|(ScroollLock)|(Up)|(Down)|(Left)|(Right)|(PgUp)|(PgDn)|(BS)|(ESC)|(Insert)|(Delete))$")
            return "{" key "}"
        if RegExMatch(key, "i)^PrtSc$")
            return "{PrintScreen}"
        if RegExMatch(key, "i)^alt$")
            return "{!}"
        if RegExMatch(key, "i)^ctrl$")
            return "{^}"
        if RegExMatch(key, "i)^shift$")
            return "{+}"
        if RegExMatch(key, "i)^win$")
            return "{#}"
        if RegExMatch(key, "<LT>")
            return "<"
        if RegExMatch(key, "<RT>")
            return ">"
        return Key
    }

    ; CheckCapsLock(key) {{{2
    ; 检测CapsLock是否按下，返回对应的值
    ; key 的值为类VIM键，如 CheckCapsLock("<S-A>")
    CheckCapsLock(key)
    {
        if GetKeyState("CapsLock", "T")
        {
            if RegExMatch(key, "^[a-z]$")
                return "<S-" key ">"
            if RegExMatch(key, "i)^<S\-([a-zA-Z])>", m)
            {
                StringLower, key, m1
                return key 
            }
        }
        return key
    }

    ToMatch(v)
    {
        v := RegExReplace(v , "\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\", "\$0")
        return RegExReplace(v , "\s", "\s")
    }
}

; Class __win {{{1
Class __win 
{
    __new(class = "", filepath = "", title = "")
    {
        this.class     := class
        this.filepath  := filepath
        this.title     := title
        this.KeyList   := []
        this.SuperKeyList   := []
        this.modeList  := []
        this.Status    := true
        this.mode      := ""
        this.LastKey   := ""
        this.KeyTemp   := ""
        this.MaxCount  := 99
        this.Count     := 0
        this.TimeOut   := 0
        this.Info := default_enable_show_info
        this.BeforeActionDoFunc := ""
        this.AfterActionDoFunc   := ""
        this.ShowInfoFunc := "ShowInfo"
        this.HideInfoFunc := "HideInfo"
    }

    ; ChangeMode(modeName) {{{2
    ; 检查模式是否存在，如存在则返回模式对象，如果不存在则新建并返回模式对象
    ChangeMode(modeName)
    {
        this.mode := modeName
        this.KeyTemp := ""
        this.Count := 0
        if not this.modeList[modeName]
            this.modeList[modeName] := new __Mode(modeName)

        modeObj := this.modeList[modeName]
        if IsFunc(func := modeObj.modeFunction)
            %func%()
        return modeObj
    }

    ; ExistMode() {{{2
    ; 获取当前模式名
    ExistMode()
    {
        return this.mode
    }

    ; SetInfo() {{{2
    SetInfo(bold)
    {
        this.info := bold
    }

    ; SetShowInfo() {{{2
    SetShowInfo(func)
    {
        this.ShowInfoFunc := func
    }

    ; SetHideInfo() {{{2
    SetHideInfo(func)
    {
        this.HideInfoFunc := func
    }

    ; ShowMore() {{{2
    ShowMore()
    {
        if IsFunc(f := this.ShowInfoFunc) And this.Info
            %f%()
    }

    ; HideMore() {{{2
    HideMore()
    {
        if IsFunc(f:=this.HideInfoFunc) And this.Info
            %f%()
    }
}

; Class __Mode {{{1
Class __Mode
{
    __new(modeName)
    {
        this.name  := modeName
        this.keymapList := []
        this.keymoreList := []
        this.nowaitList := []
        this.modeFunction := ""
    }

    ; SetKeyMap(key, action) {{{2
    SetKeyMap(key, action)
    {
        this.keymapList[key] := action
    }

    ; GetKeyMap(key) {{{2
    GetKeyMap(key)
    {
        return this.keymapList[key]
    }

    ; DelKeyMap(key) {{{2
    DelKeyMap(key)
    {
        this.keymapList[key] := ""
    }

    ; SetNoWait(key, bold) {{{2
    ; 无视TimeOut执行热键
    SetNoWait(key, bold)
    {
        this.nowaitList[key] := bold
    }

    ; GetNoWait(key) {{{2
    GetNoWait(key)
    {
        return this.nowaitList[key]
    }

    ; SetMoreKey(key) {{{2
    SetMoreKey(key)
    {
        this.keymoreList[key] := true
    }

    ; GetMoreKey(key) {{{2
    GetMoreKey(key)
    {
        return this.keymoreList[key]
    }
}

; Class __Action {{{1
Class __Action
{
    ; Action 有几种类型
    ; 0 代表执行Action对应的Label (默认)
    ; 1 代表执行Function的值对应的函数
    ; 2 代表运行CmdLine对应的值
    ; 3 代表发送HotString对应的文本

    __new(Name, Comment)
    {
        this.Name := Name
        this.Comment := Comment
        this.MaxTimes := 0
        this.Type := 0
        this.Function := ""
        this.CmdLine := ""
        this.HotString := ""
    }

    ; SetFunction(Function) {{{2
    ; 设置Action执行的函数名
    SetFunction(Function)
    {
        this.Function := Function
        this.Type := 1
    }

    ; SetCmdLine(CmdLine) {{{2
    ; 设置Action运行的字符串
    SetCmdLine(CmdLine)
    {
        this.CmdLine := CmdLine
        this.Type := 2
    }

    ; SetHotString(HotString) {{{2
    ; 设置Action发送的文本
    SetHotString(HotString)
    {
        this.HotString := HotString
        this.Type := 3
    }

    ; SetMaxTimes(Times) {{{2
    ; 设置最大运行次数
    SetMaxTimes(Times)
    {
        this.MaxTimes := Times
    }

    ; Do(Times=1) {{{2
    ; 执行Action
    Do(Times=0)
    {
        Times := !Times ? 1 : Times
        if this.MaxTimes And (Times > this.MaxTimes)
            Times := this.MaxTimes
        Loop, %Times%
        {
            if this.Type = 0
            {
                if IsLabel(label := this.Name)
                    GoSub, %label%
            }
            else if this.Type = 1
            {
                if IsFunc(f := this.Function)
                    %f%()
            }
            else if this.Type = 2
            {
                c := this.CmdLine
                Run, %cmd%
            }
            else if This.Type = 3
            {
                t := this.HotString
                Send, %t%
            }
        }
    }
}

; Class __Plugin {{{1
Class __Plugin
{
    __new(PluginName)
    {
        this.PluginName := PluginName
        this.Author := ""
        this.Ver := ""
        this.Comment := ""
    }

    ; CheckSub() {{{2
    CheckSub()
    {
        if IsLabel(p := this.PluginName)
        {
            GoSub, %p%
            this.Error := false
        }
        else
            this.Error := true
    }
}

; Class __vimDebug {{{1
Class __vimDebug
{
    __new(key)
    {
        this.mode := key
        if key
        {
            GUI, vimDebug:Destroy
            GUI, vimDebug:+hwnd_vimdebug -Caption +ToolWindow +Border
            GUI, vimDebug:color, 454545, 454545
            GUI, vimDebug:font, s16 cFFFFFF
            GUI, vimDebug:Add, Edit, x-2 y-2 w400 h60 readonly
            GUI, vimDebug:Show, w378 h56 y600
            WinSet, AlwaysOnTop, On, ahk_id %_vimdebug%
        }
        else
        {
            GUI, vimDebug:font, s12
            GUI, vimDebug:Destroy
            GUI, vimDebug:Add, Edit, x10 y10 w400 h300 readonly
            GUI, vimDebug:Add, Edit, x10 y320 w400 h26 readonly
            GUI, vimDebug:Show, w420 h356
        }
    }

    var(obj)
    {
        this.vim := obj
    }

    Set(v)
    {
        winName := this.vim.CheckWin()
        winObj := this.vim.GetWin(winName)
        if winObj.Count
            k := " 热键缓存:" winObj.Count winObj.KeyTemp
        else
             k := " 热键缓存:" winObj.KeyTemp
        GUI, vimDebug:Default
        GUIControl, , Edit1, %v%
        GUIControl, , Edit2, %k%
    }

    Get()
    {
        GUI, vimDebug:Default
        GUIControlGet, v, , Edit1
        return v
    }

    ; Add(v) {{{2
    Add(v)
    {
        b := this.Get()
        if this.mode
            this.Set(b)
        else
            this.Set(v "`n" b)
    }

    ; Clear() {{{2
    Clear()
    {
        this.Set("")
    }
}
