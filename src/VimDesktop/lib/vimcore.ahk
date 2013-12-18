/*
API 函数列表：
vim.mode("模式","ahk_class")  ; 设置运行的模式
vim.map("热键","Label标签","ahk_class")  ;映射热键
vim.settimeout("按键超时时间","ahk_class")  ;设置按键超时时间
vim.listkey("ahk_class")  ;显示所有映射的热键体
vim.control("on/off","ahk_class")  ;启用/禁用映射的热键
vim.comment("标签","描述","是否允许多次运行（0/1)")
内置Label:
<Repeat> 重复上一次动作
*/
#UseHook On
Setkeydelay,-1
return


; 此函数可以根据自己的喜好进行修改
ShowComment(more="") {
    WinGetClass,win,A
    w := vim.Vaild(win)
    mode := w.GetMode()
    msg := mode.KeyTemp "`n=============================`n"
;	GUIControl,,Edit1,%msg%

    If Strlen(more)
    {
        Loop,Parse,more,`n
        {
            key := Trim(A_LoopField)
            action := mode.KeyBody[key]
            ;comment := vim.CommentList[action]
            comment := GetCommentDest(action)
            If Strlen(comment)
                msg .= key "  >>  " comment "`n"
            Else
                msg .= key "  >>  " action "`n"

        }
        Tooltip % msg
		;GUI,VIMINFO:Show
    }
    Else
        Tooltip
		;GUI,VIMINFO:Show,Hide
}



; ====================
; ====================
; 内部脚本，请匆修改！
; ====================
; ====================

; 初始化 vimcore
Init() {
	OnMessage(0x05,"GuiSize")
    GoSub,vimnew
}

vimnew:
    Global vim := new vimcore
return


; 以下为class封装，请匆修改
Class vimcore {
    __New() {
       This.vimWindows := []
       This.vimGlobal  := new This.vimClass("")
       This.TimeOutClass := ""
	   This.ExcludeList := []
	   ;This.ExcludeList["AutoHotkey"] := True
       This.CommentList := []
       This.CommentType := []
	   This.UseHotkey   := []
    }

    Vaild(win) {
        if Strlen(win) = 0
            Return This.vimGlobal
        w := This.vimWindows[win]
        if w.winVaild
            return w
        Else
            return This.vimGlobal
    }

    mode(mode,win="") {
        if Strlen(win) = 0
            w := This.vimGlobal
        Else
            w := This.vimWindows[win]
        If not w.winVaild
        {
            w := new This.vimClass(win)
            This.vimWindows[win] := w
        }
        w.SetMode(mode)
        ShowComment()
    }

	sMap(key,label,win=""){
		This.UseHotkey[key] := True
    	this.Map(key,label,win)
	}
    Map(key,label,win="") {
		If not RegExMatch(Key,"[^\s]")
			return
        if Strlen(win) = 0
            w := This.vimGlobal
        Else
            w := This.vimWindows[win]
        If not w.winVaild
        {
            w := new This.vimClass(win)
            This.vimWindows[win] := w
        }
        mode := w.GetMode()
        mode.SetHotkey(key,label)
    }

    Comment(action,desc,complex=1) {
        This.CommentList[action] := desc
        This.CommentType[action] := complex
    }

    do() {
        WinGetClass,win,A
        w := This.Vaild(win)
		m := w.GetMode()
		If This.ExcludeList[win] And not this.UseHotkey[m.GetThisHotkey()]
		{
			Send,% m.TransSendKey(A_ThisHotkey)
			return
		}
        If w.winVaild {
            mode := w.GetMode()
			If Mode.KeyList[A_ThisHotkey]
            	mode.Try()
			Else
			{
				w := This.vimGlobal
				mode := w.GetMode()
				mode.Try()
			}
        }
    }

	Filter(String) {

        WinGetClass,win,A

		If This.ExcludeList[win]
			return
        w := This.Vaild(win)

        If w.winVaild {
            mode := w.GetMode()
			mode.query(string)
        }
    }

	Exclude(win) {
		This.ExcludeList[win] := True
	}

	Include(win) {
		This.ExcludeList[win] := False
	}


    ListKey(win="",mode="") {
        w := This.Vaild(win)
        If strlen(mode) {
            m := w.winmode[mode]
            For k , l in m.KeyBody
                msg .= k "  " l "`n"
            return msg
        }
        Else {
            For n , m  in w.winMode
            {
                msg .= "====`n" n "`n----`n"
                mode := m
                For k , l in m.KeyBody
                    msg .= k "  " l "`n"
            }
            return msg
        }
    }

	copy(win1,win2) {

        w2 := This.vimWindows[win2]

        If w2.winVaild
            return False

		w1 := This.Vaild(win1)
		w1.winName := win2
		For n , m in w1.WinMode
		{
			mode := m
			mode.win := win2
			w1.WinMode[n] := mode
			For k , l in m.KeyList
            {
				Hotkey,IfWinActive,ahk_class %win2%
                Hotkey,%k%,<HotkeyLabel>
            }
		}
		This.vimWindows[win2] := w1
        return True
	}

    Control(switch,win="") {
        w := This.Vaild(win)
        If switch = on
        {
            For n , m  in w.winMode
            {
                mode := m
                For k , l in m.KeyList
                {
                    Hotkey,%k%,on
                }
            }
        }
        If switch = off
        {
            For n , m  in w.winMode
            {
                mode := m
                For k , l in m.KeyList
                {
                    Hotkey,%k%,off
                }
            }
        }
    }

    test() {
        msgbox vim test
    }

    SetTimeOut(tick,win="") {
        w := This.Vaild(win)
        If not w.winVaild
        {
            w := new This.vimClass(win)
            This.vimWindows[win] := w
        }
        w.TimeOut := tick
    }

    TimeOut() {
        w := This.Vaild(This.TimeOutClass)
        mode := w.GetMode()
        mode.KeyTemp := ""
        ;GoSub,% mode.TimeOutAction
        mode.ExecSub(mode.TimeOutAction)
        ;    ShowComment()
        mode.TimeOutAction := ""
    }

    Repeat() {
        WinGetClass,win,A
        w := This.vimWindows[win]
        If not w.winVaild
            w := This.vimGlobal
        If w.winVaild {
            mode := w.GetMode()
            mode.KeyCount := w.winRepeatCount
            mode.ExecSub(w.winRepeat,Ture)
        }
    }

    GetWin() {
        WinGetClass,win,A
        Return This.Vaild(win)
    }

	GetCount() {
		w := This.GetWin()
		m := w.GetMode()
		Return m.KeyCount ? m.KeyCount : 1
	}
	
    Class vimClass {

        __New(win) {
            This.winName := win
            This.winVaild   := 1
            This.winControl := 0
            This.winTimeOut := 0
            THis.winMaxCount := 99
            This.winKeyList := []
            This.winMode    := []
            This.winThisMode := ""
            This.winRepeat   := ""
            This.winRepeatCount := 0
        }
        ;设置窗口类下的模式
        SetMode(md) {
            m := This.winMode[md]
            If Strlen(m.Mode) = 0 {
                This.winThisMode := md
                m := new This.Mode(md,This.winName)
                This.winMode[md] := m
            }
            Else
                This.winThisMode := md
            return m
        }
        ;获取窗口类下的模式

        GetMode() {
            m := This.winMode[This.winThisMode]
            return m
        }



        Class Mode {
            __New(mode,win) {
                This.Mode := mode
                This.win  := win ;可变
                If Strlen(win)
                    This.CheckMode := win "_CheckMode"
                Else
                    This.CheckMode := "CheckMode"
                This.KeyTemp   := ""
                This.KeyString := ""
                This.KeyCount := 0
                This.TimeOut := 0
                This.TimeOutTick   := 0
                This.TimeOutAction := ""
                This.KeyBody := []
                This.KeyList := []
                This.KeyMap  := []
            }

            test() {
                msgbox % This.Mode
            }

            Try(){
				checkMode := This.CheckMode
                settimer,<TimeOutLabel>,off
                Key := This.GetThisHotkey()
                If ( Not This.KeyList[A_ThisHotkey] ) or ( IsFunc(CheckMode) AND (%CheckMode%()) ) {
                    Send,% This.TransSendKey(A_ThisHotkey)
                    ShowComment()
					return
				}
                _SaveKeyTemp := This.KeyTemp
                This.KeyTemp .= Key
                P := 1
                more := ""
                moreCount := 0
                Loop {
                    P := RegExMatch(This.KeyString,"i)\t" This.ToMatch(This.keyTemp) "[^\t]*",m,P)
                    If P {
                        ;msgbox % This.KeyString "`np=" p "`nm=" m
                        more .= m "`n"
                        P += Strlen(m)
                        moreCount++
                    }
                    Else
                        Break
                }
                more := RTrim(more,"`n")
                If moreCount = 0
                {
                	This.KeyTemp := ""
					
                    action := This.KeyBody[_SaveKeyTemp]
                    If Strlen(action) {
                        This.ExecSub(Action)
                    }
                    Else {
                        action := This.KeyBody[Key]
                        If Strlen(action) {
							If InvalidMode
                            	ShowComment()
							Else
                            	This.ExecSub(Action)
						}
                        Else {
							If RegExMatch(This.KeyString,"i)\t" This.ToMatch(key) "[^\t]*")
							{
								If InvalidMode
                            		ShowComment()
								Else
                        			This.Try()
							}
							Else
							{
                            	Send,% This.TransSendKey(A_ThisHotkey)
                            	ShowComment()
							}
							return
                        }
                    }
                }
                Else If moreCount = 1
                {
                    Action := This.KeyBody[This.KeyTemp]
                    If Strlen(Action) {
                        This.ExecSub(Action)
                        This.KeyTemp := ""
                    }
                    Else
                        ShowComment(more)
                }
                Else
                {
                    TimeOut := 0 - GetTimeOutClass(This.win)
                    If Timeout And This.KeyBody[This.KeyTemp]{
                        This.TimeOutAction := This.KeyBody[This.KeyTemp]
                        This.TimeOutTick   := A_TickCount
                        SetTimeOutClass(This.win)
                        Settimer,<TimeOutLabel>,%TimeOut%
                    }
                    ErrorLevel := True
                    ShowComment(more)
                    return more
                }
            }


            ExecSub(action) {
                w := vim.vaild(This.win)
                If RegExMatch(Action,"(?<=^<)\d(?=>$)",cnt) {
                        This.KeyCount := This.KeyCount * 10 + cnt
                        MaxCount := w.winMaxCount
                        If This.KeyCount > MaxCount
                            This.KeyCount := MaxCount
                        Tooltip % This.KeyCount
                        return false
                }
                Else {
                    ShowComment()
                    If This.KeyCount And GetCommentType(Action)
                        cnt := This.KeyCount
                    Else
                        cnt := 1
                    ;cnt := This.KeyCount ? This.KeyCount : 1
                    If RegExMatch(action,"^<.*>$") {
                        If IsLabel(action) {
                            Loop,%cnt%
                                GoSub % Action
                        }
                        Else {
                            Msgbox %Action%不存在，请检查脚本
                            Return
                        }
                    }
                    If RegExMatch(action,"^\(.*\)$") {
						file := SubStr(action,2,Strlen(action)-2)
                        Run,%File%,,UseErrorLevel,ExecID
                        If ErrorLevel
                        {
                            msgbox 运行%file%失败
                            return
                        }
                        Else
                        {
                            WinWait,AHK_PID %ExecID%,,1
                            WinActivate,AHK_PID %ExecID%
                        }
                    }
                    If RegExMatch(Action,"^\{.*\}$") {
                        Text := Substr(Action,2,Strlen(Action)-2)
                        Loop,%cnt%
                            Send,%Text%
                    }

                    This.KeyCount := 0
                    If rpt
                        return
                    If not RegExMatch(action,"i)^<repeat>$") {
                        w.winRepeatCount := cnt
                        w.winRepeat := Action
                    }
                }
				EmptyMem()
            }

            SetHotkey(key,label) {
                ;msgbox % This.win
                If Strlen(This.win) > 0 {
                    class := This.win
                    Hotkey,IfWinActive,ahk_class %class%
                }
                Else
                    Hotkey,IfWinActive

                mKey := ""
                Loop,Parse,Key
                {
                    If Asc(A_LoopField) >= 65 And Asc(A_LoopField) <= 90
                        mKey .= "<shift>" . Chr(Asc(A_LoopField)+32)
                    Else
                        mKey .= A_LoopField
                }
                Hotkey_OK := True
                ;Idx := This.KeyList[0] ? This.KeyList[0] : 1
                cnt := 1
                _SaveList := []
                for,i,k in This.ResolveHotkey(mKey)
                {
                    Hotkey,%k%,<HotkeyLabel>,On,UseErrorLevel
                    If ErrorLevel
                    {
                        Msgbox 映射错误
                        Hotkey_OK := False
                        Break
                    }
                    ;If Not This.KeyList[k] {
                    ;    This.KeyList[idx] := k
                    ;    idx++
                    ;}
                    _SaveList[cnt] := k
                    cnt++
                    This.KeyList[k] := This.KeyList[k] ? This.KeyList[k] + 1 : 1
                }
                ;This.KeyList[0] := idx
                If Not Hotkey_OK {
                    For i , k IN _SaveList
                    {
                        This.KeyList[k] := This.KeyList[k] - 1
                        If This.KeyList[k] = 0 {
                            Hotkey,%k%,off
                        }
                    }
                }
                Else {
                    This.KeyBody[mkey] := label
                    If not RegExMatch(This.KeyString,"\t" This.ToMatch(mKey) "[^\t]*")
                        This.KeyString .= A_Tab mKey A_Tab
                }
            }

            ResolveHotkey(KeyList)
            {
                Keys := []
                NewKeyList := []
                n := 1
                Loop
                {
                    Pos := RegExMatch(KeyList,"<[^<>]*>",A_Index)
                    If Pos
                    {
                        LoopKey := SubStr(KeyList,1,Pos-1)
                        Loop,Parse,LoopKey
                        {
                            If Asc(A_LoopField) >= 65 And Asc(A_LoopField) <= 90
                            {
                                Keys[n] := "shift"
                                n++
                                Keys[n] := Chr(Asc(A_LoopField)+32)
                            }
                            Else
                                Keys[n] := A_LoopField
                            n++
                        }
                        KeyList := SubStr(KeyList,Pos,Strlen(KeyList))
                        Pos := RegExMatch(KeyList,">")
                        Keys[n] := SubStr(KeyList,2,Pos-2)
                        KeyList := SubStr(KeyList,Pos+1,Strlen(KeyList))
                        n++
                    }
                    Else
                    {
                        Loop,Parse,KeyList
                        {
                            If Asc(A_LoopField) >= 65 And Asc(A_LoopField) <= 90
                            {
                                Keys[n] := "shift"
                                n++
                                Keys[n] := Chr(Asc(A_LoopField)+32)
                            }
                            Else
                                Keys[n] := A_LoopField
                            n++
                        }
                        Break
                    }
                }
                n := 1
                For,i,key in Keys
                {
                    If RegExMatch(key,"i)(l|r)?(ctrl|shift|win|alt)")
                    {
                        List .= Key " & "
                        Continue
                    }
                    Else
                    {
                        List .= Key
                        NewKeyList[n] := List
                        List :=
                    }
                    n++
                }
                Return NewKeyList
            }

            GetThisHotkey(G_ThisHotkey="")
            {
                If Strlen(G_ThisHotkey) = 0
                    G_ThisHotkey := A_ThisHotkey
                GetKeyState,Var,CapsLock,T
                If Var = D
                {
                    If RegExMatch(ThisHotkey,"i)^(l|r)?shift\s&\s[a-z]$")
                        ThisHotkey := Substr(ThisHotkey,0)
                    Else If RegExMatch(G_ThisHotkey,"^[a-z]$")
                        ThisHotkey := "shift & " . G_ThisHotkey
					Else
						ThisHotkey := A_ThisHotkey
                }
                Else
                    ThisHotkey := G_ThisHotkey
                Loop
                {
                    If RegExMatch(ThisHotkey,"(?<!<)(((l|r)?(ctrl|control|alt|win|shift))|(f\d\d?)|esc|escape|space|tab|enter|bs|del|ins|home|end|pgup|pgdn|up|down|left|right|((?<=&\s)[<>]$))(?!>)",m) {
                        ThisHotkey := RegExReplace(ThisHotkey,This.ToMatch(m),"<" m ">")
                    }
                    Else
                    {
                        ThisHotkey := RegExReplace(ThisHotkey,"\s&\s")
                        Break
                    }
                }
                ;msgbox % Thishotkey
                Return ThisHotKey
            }

            ; TransSendKey(hotkey) {{{2
            ; 在SendKey时，将hotkey转换为Send能支持的格式
            TransSendKey(hotkey)
            {
                Loop
                {
                    If RegExMatch(Hotkey,"i)^(f\d\d?)|esc|escpa|space|tab|enter|bs|del|ins|home|end|pgup|pgdn|up|down|left|right|!|#|\+|\^|\{|\}$")
                    {
                        Hotkey := "{" . Hotkey . "}"
                        Break
                    }
                    If StrLen(hotkey) > 1 AND Not RegExMatch(Hotkey,"^\+.$")
                    {
                        Hotkey := "{" . hotkey . "}"
                        If RegExMatch(hotkey,"i)(shift|lshift|rshift)(\s\&\s)?.+$")
                            Hotkey := "+" . RegExReplace(hotkey,"i)(shift|lshift|rshift)(\s\&\s)?")
                        If RegExMatch(hotkey,"i)(ctrl|lctrl|rctrl|control|lcontrol|rcontrol)(\s\&\s)?.+$")
                            Hotkey := "^" . RegExReplace(hotkey,"i)(ctrl|lctrl|rctrl|control|lcontrol|rcontrol)(\s\&\s)?")
                        If RegExMatch(hotkey,"i)(lwin|rwin)(\s\&\s)?.+$")
                            Hotkey := "#" . RegExReplace(hotkey,"i)(lwin|rwin)(\s\&\s)?")
                        If RegExMatch(hotkey,"i)(alt|lalt|ralt)(\s\&\s)?.+$")
                            Hotkey := "!" . RegExReplace(hotkey,"i)(alt|lalt|ralt)(\s\&\s)?")A
                    }
                    If RegExMatch(Hotkey,"^\+.$")
                    {
                        Hotkey := SubStr(Hotkey,1,1) . "{" . SubStr(Hotkey,2) . "}"
                    }
                    GetKeyState,Var,CapsLock,T
                    If Var = D
                    {
                        If RegExMatch(Hotkey,"^\+\{[a-z]\}$")
                        {
                            Hotkey := SubStr(Hotkey,2)
                            Break
                        }
                        If RegExMatch(Hotkey,"^[a-z]$")
                        {
                            Hotkey := "+{" . Hotkey . "}"
                            Break
                        }
                        If RegExMatch(Hotkey,"^\{[a-z]\}$")
                        {
                            Hotkey := "+" . Hotkey
                            Break
                        }
                    }
                    Break
                }
                Return hotkey
            }

            ToMatch(Key)
            {
                Key := RegExReplace(Key,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
                Return RegExReplace(Key,"\s","\s")
            }

        }
    }

}

SetTimeOutClass(win) {
    vim.TimeOutClass := win
}
GetTimeOutClass(win) {
    w := vim.Vaild(win)
    return w.TimeOut
}
GetCommentDest(action) {
    Return vim.CommentList[action]
}
GetCommentType(action) {
    Type := vim.CommentType[action]
    If Strlen(Type)
        return Type
    Else
        return true
}
EmptyMem(PID="AHK Rocks")
{
    pid:=(pid="AHK Rocks") ? DllCall("GetCurrentProcessId") : pid
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", pid)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}
<TimeOutLabel>:
    vim.TimeOut()
return

<HotkeyLabel>:
    vim.Do()
return

<Repeat>:
    vim.Repeat()
return
