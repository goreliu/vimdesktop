
; class INI {{{1
; Create By Linxinhong
class INI {
	; __new(p) {{{2
	__new(p) {
		this.filepath  := p 
		this.timestamp := ""
		this.CheckTime()
	}
	; Read() {{{2
	Read(i="") {
		this.env := []
		this.content := []
		If not strlen(i)
		{
			p := this.filepath
			FileRead,i,%p%
		}
		Loop,Parse,i,`n,`r 
		{
			this.content[0] := A_Index
			this.content[A_Index] := A_LoopField
			LoopString := Trim(A_LoopField)
			;If not Strlen(LoopString) ;空白行
			;	continue
			If InStr(SubStr(LoopString,1,1),"[") And InStr(SubStr(LoopString,Strlen(LoopString)),"]") {
                sec := SubStr(LoopString,2,Strlen(LoopString)-2)
				this.content["`nsections"] .= sec "`n"
				this.content[sec "`nnumber"] := 0
				continue
			}
			this.content[sec "`nall"] .= A_LoopField "`n"
			If InStr(SubStr(LoopString,1,1),";") {
				this.content[sec "`ncomment"] .= LoopString "`n"
				continue
			}
			If InStr(LoopString,"=")
			{
				k := Trim(SubStr(LoopString,1,InStr(LoopString , "=" ) -1 ))
				v := Trim(SubStr(LoopString,InStr(LoopString, "=") + 1))
			}
			Else
				k := LoopString
			If Strlen(k)
				this.content[sec "`nkeys"] .= k "`n"
			this.content[sec "`nkeyValue"] .= LoopString "`n"
			this.content[sec "`n" k] := v
			idx := this.content[sec "`nnumber"] + 1
			this.content[sec "`nnumber"] := idx
			;this.content[sec "`nnumber" idx] := k "=" v
			this.content[sec "`nnumber" idx] := A_LoopField
			If sec = Env 
			{
				e := []
				e.vaild := True
				e.var   := v
				this.Env[k] := e
				If RegExMatch(this.filepath,"i)\\menuz\.ini$")
					GlobalSetEnvs(k,e)
			}
		}
		cnt := this.content[0]
		this.content[0] := cnt - 1
		this.content[cnt] := ""
	}
	; Write() {{{2
	Write() {
		p := this.filepath
		cnt := this.content[0]
		Loop %cnt%
			rs .= this.content[A_Index] "`n"
		;rs := RTrim(rs,"`r`n")
		FileDelete,%p%
		FileAppend,%rs%,%p%
		FileGetTime,t,%p%
		this.timestamp := t
		return rs
	}
	; CheckTime() {{{2
	CheckTime() {
		p := this.filepath
		FileGetTime,t,%p%
		If this.timestamp <> t {
			this.timestamp := t
			this.Read()
		}
		else
			return this.timestamp
	}

	; Adjust(src,dst="",mothed="md") {{{2
	Adjust(src,dst="",mothed="m") {
		this.CheckTime()
		sl := this.GetSections()
		If InStr(mothed,"m") or InStr(mothed,"c"){
			If src.number
			{
				temp := this.content[src.section "`nnumber" src.number] 
				space := "`n"
			}
			else
				temp := this.content[src.section "`nall"]
			If InStr(mothed,"m")
				If src.number
					this.content[src.section "`nall"] := this.Adjust_delete(this.content[src.section "`nall"],temp)
				else
					this.content[src.section "`nall"] := ""
			If InStr(mothed,"u")
				If dst.number
					this.content[dst.section "`nall"] := this.Adjust_insert_up(this.content[dst.section "`nall"],this.content[dst.section "`nnumber" dst.number],temp)
				Else
					this.content[dst.section "`nall"] := temp space this.content[dst.section "`nall"]
			else
				If dst.number
					this.content[dst.section "`nall"] := this.Adjust_insert_down(this.content[dst.section "`nall"],this.content[dst.section "`nnumber" dst.number],temp)
				Else
					this.content[dst.section "`nall"] := this.content[dst.section "`nall"] temp 
		}
		If InStr(mothed,"t"){
			If RegExMatch(dst.section,"i)^" this._ToMatch(src.section) "$"){
				all := this.content[src.section "`nall"]
				m1 := this._ToMatch(this.content[src.section "`nnumber" src.number])
				m2 := this._ToMatch(this.content[src.section "`nnumber" dst.number])
				Loop,Parse,all,`n
				{
					If RegExMatch(A_LoopField,m1) and src.number{
						idx1 := A_Index
						temp1 := A_LoopField
						continue
					}
					If RegExMatch(A_LoopField,m2) and dst.number{
						idx2 := A_Index
						temp2 := A_LoopField
						continue
					}
					If idx1 and idx2
						break
				}
				If not src.number
					temp1 := this.content[src.section "`nall"]
				If not dst.number
					temp2 := this.content[src.section "`nall"]
				Loop,Parse,all,`n
				{
					If A_Index = %idx1%
						ns .= temp2 "`n" 
					Else If A_Index = %idx2%
						ns .= temp1 "`n"
					Else
						ns .= A_LoopField "`n"
				}
				this.content[src.section "`nall"] := ns
			}
			Else {
				If src.number 
					temp_s := this.content[src.section "`nnumber" src.number]
				Else
					temp_s := this.content[src.section "`nall"]
				If dst.number
					temp_d := this.content[dst.section "`nnumber" dst.number]
				Else
					temp_d := this.content[dst.section "`nall"]
				;temp_s := RegExReplace(temp_s,"\n$")
				;temp_d := RegExReplace(temp_d,"\n$")
				If src.number
					this.content[src.section "`nall"] := this.Adjust_trans(this.content[src.section "`nall"],this.content[src.section "`nnumber" src.number],temp_d)
				Else
					this.content[src.section "`nall"] := temp_d 
				If dst.number
					this.content[dst.section "`nall"] := this.Adjust_trans(this.content[dst.section "`nall"],this.content[dst.section "`nnumber" dst.number],temp_s)
				Else
					this.content[dst.section "`nall"] := temp_s
				;msgbox % this.content[src.section "`nall"] "`n" this.content[dst.section "`nall"]	
			}
		}
		rs := this.content["`nall"]
		Loop,Parse,sl,`n
		{
			If not strlen(A_LoopField)
				continue
			rs .= "[" A_LoopField "]`n"
			If RegExMatch(this.content[A_LoopField "`nall"],"\n$")
				rs .= this.content[A_LoopField "`nall"] 
			Else
				rs .= this.content[A_LoopField "`nall"] "`n"
		}
		this.Read(rs)
		this.Write()
	}
	Adjust_trans(s,k,t) {
		If not strlen(k)
			return
		m := this._ToMatch(k)
		Loop,Parse,s,`n
		{
			If RegExMatch(A_LoopField,m)
				rs .= t "`n"
			else
				rs .= A_LoopField "`n"
		}
		return substr(rs,1,strlen(rs)-1)
	}
	Adjust_delete(s,k) {
		If not strlen(k)
			return
		m := this._ToMatch(k)
		Loop,Parse,s,`n
		{
			If RegExMatch(A_LoopField,m)
				continue
			rs .= A_LoopField "`n"
		}
		return substr(rs,1,strlen(rs)-1)
	}
	Adjust_insert_up(s,k,i) {
		If not strlen(k)
			return
		m := this._ToMatch(k)
		Loop,Parse,s,`n
		{
			If RegExMatch(A_LoopField,m)
				rs .= i "`n"
			rs .= A_LoopField "`n"
		}
		return substr(rs,1,strlen(rs)-1)
	}
	Adjust_insert_down(s,k,i) {
		If not strlen(k)
			return
		m := this._ToMatch(k)
		found := 0
		Loop,Parse,s,`n
		{
			If found = 1
			{
				rs .= i "`n"
				found := 2
			}
			If RegExMatch(A_LoopField,m) And (found = 0)
				found := 1
			rs .= A_LoopField "`n"
		}
		return substr(rs,1,strlen(rs)-1)
	}
	; Insert(section,Number,string,d=1) {{{2
	Insert(section,Number,string,d=1) {
		this.CheckTime()
		sl := this.GetSections()
		If d
			this.content[section "`nall"] := this.Adjust_insert_down(this.content[section "`nall"],this.content[section "`nnumber" Number],string)
		Else
			this.content[section "`nall"] := this.Adjust_insert_up(this.content[section "`nall"],this.content[section "`nnumber" Number],string)
		rs := this.content["`nall"]
		Loop,Parse,sl,`n
		{
			If not strlen(A_LoopField)
				continue
			rs .= "[" A_LoopField "]`n"
			If RegExMatch(this.content[A_LoopField "`nall"],"\n$")
				rs .= this.content[A_LoopField "`nall"] 
			Else
				rs .= this.content[A_LoopField "`nall"] "`n"
		}
		this.Read(rs)
		this.Write()
	}
	iniwrite(section,key,string){
		p := this.filePath
		iniwrite,%string%,%p%,%section%,%key%
	}
	iniread(section,key,default=""){
		p := this.filePath
		iniread,v,%p%,%section%,%key%,%default%
		return v
	}

	; GetINI() {{{2
	GetINI() {
		this.CheckTime()
		cnt := this.content[0]
		Loop %cnt%
			rs .= this.content[A_Index] "`n"
		return rs
	}
	; GetSections() {{{2
	GetSections() {
		this.CheckTime()
		return this.content["`nsections"]
	}
	; GetSectionsF(fuzzy) {{{2
	GetSectionsF(fuzzy) {
		this.CheckTime()
		r := ""
		l := this.GetSections()
		Loop,Parse,l,`n
		{
            If InStr(A_LoopField,"|") {
				s := A_LoopField 
                Loop , Parse , s, |
                {
                    If A_LoopField = %fuzzy%
                    {
                        r .= s "`n"
                        Break
                    }
                }
            }
            Else If A_LoopField = %fuzzy%
                r .= A_LoopField "`n"
        }
        Return RTrim(r,"`n")	
	}
	; GetSectionsR(regex) {{{2
	GetSectionsR(regex) {
		this.CheckTime()
		r := ""
		l := this.GetSections()
		Loop,Parse,l,`n
		{
			If RegExMatch(A_LoopField,regex)
				r .= A_LoopField "`n"
		}
		return RTrim(r,"`n")
	}
	; GetKeys(section) {{{2
	GetKeys(section) {
		this.CheckTime()
		return this.content[section "`nkeys"]
	}
	; GetValue(section,Key) {{{2
	GetValue(section,Key) {
		this.CheckTime()
		return this.content[section "`n" key]
	}
	; GetKeyValue(section) {{{2
	GetKeyValue(section) {
		this.CheckTime()
		return this.content[section "`nkeyValue"]
	}
	; GetValueN(section,idx) {{{2
	GetValueN(section,idx) {
		LoopString := this.GetKeyValueN(section,idx)
		return 	Trim(SubStr(LoopString,InStr(LoopString, "=") + 1))
	}
	; GetKeyValueN(section,idx) {{{2
	GetKeyValueN(section,idx) {
		this.CheckTime()
		return this.content[section "`nnumber" idx]
	}
	; GetComment() {{{2
	GetComment(sec) {
		this.CheckTime()
		return this.content[sec "`ncomment"]
	}
	; GetKeycomment(sec) {{{2
	GetKeycomment(sec) {
		this.CheckTime()
		return this.content[sec "`nall"]
	}
	; ReplaceEnv(string) {{{2
	ReplaceEnv(string) {
		Global globalenv
		this.CheckTime()
		p1 := 1
        Loop {
            p2 := RegExMatch(string,"%[^%]*%",m,p1)
            If Not p2 {
                If P1 > 1
                    r .= over
                Else
                    r := string
                Break
            }
            Else If Strlen(m) {
                env := SubStr(m,2,strlen(m)-2)
                e := This.Env[env]
				g := GlobalGetEnvs(env)
				If not ErrorLevel
                    Rstring := g
                Else If e.Vaild
                    Rstring := e.Var
                Else If RegExMatch(env,"i)(^apps$)|(^Script$)|(^config$)|(^Extensions$)|(^icons$)",MZVar)
                    RString := A_ScriptDir "\" MZVar
                Else If RegExMatch(env,"i)(^A_WorkingDir$)|(^A_ScriptDir$)|(^A_ScriptName$)|(^A_ScriptFullPath$)|(^A_ScriptHwnd$)|(^A_LineNumber$)|(^A_LineFile$)|(^A_ThisFunc$)|(^A_ThisLabel$)|(^A_AhkVersion$)|(^A_AhkPath$)|(^A_IsUnicode$)|(^A_IsCompiled$)|(^A_ExitReason$)|(^A_YYYY$)|(^A_MM$)|(^A_DD$)|(^A_MMMM$)|(^A_MMM$)|(^A_DDDD$)|(^A_DDD$)|(^A_WDay$)|(^A_YDay$)|(^A_YWeek$)|(^A_Hour$)|(^A_Min$)|(^A_Sec$)|(^A_MSec$)|(^A_Now$)|(^A_NowUTC$)|(^A_TickCount$)|(^A_IsSuspended$)|(^A_IsPaused$)|(^A_IsCritical$)|(^A_BatchLines$)|(^A_TitleMatchMode$)|(^A_TitleMatchModeSpeed$)|(^A_DetectHiddenWindows$)|(^A_DetectHiddenText$)|(^A_AutoTrim$)|(^A_StringCaseSense$)|(^A_FileEncoding$)|(^A_FormatInteger$)|(^A_FormatFloat$)|(^A_KeyDelay$)|(^A_WinDelay$)|(^A_ControlDelay$)|(^A_MouseDelay$)|(^A_DefaultMouseSpeed$)|(^A_RegView$)|(^A_IconHidden$)|(^A_IconTip$)|(^A_IconFile$)|(^A_IconNumber$)|(^A_TimeIdle$)|(^A_TimeIdlePhysical$)|(^A_Gui$)|(^A_GuiControl$)|(^A_GuiWidth$)|(^A_GuiHeight$)|(^A_GuiX$)|(^A_GuiY$)|(^A_GuiEvent$)|(^A_EventInfo$)|(^A_ThisHotkey$)|(^A_PriorHotkey$)|(^A_PriorKey$)|(^A_TimeSinceThisHotkey$)|(^A_TimeSincePriorHotkey$)|(^A_Temp$)|(^A_OSType$)|(^A_OSVersion$)|(^A_Is64bitOS$)|(^A_PtrSize$)|(^A_Language$)|(^A_ComputerName$)|(^A_UserName$)|(^A_WinDir$)|(^A_ProgramFiles$)|(^A_AppData$)|(^A_AppDataCommon$)|(^A_Desktop$)|(^A_DesktopCommon$)|(^A_StartMenu$)|(^A_StartMenuCommon$)|(^A_Programs$)|(^A_ProgramsCommon$)|(^A_Startup$)|(^A_StartupCommon$)|(^A_MyDocuments$)|(^A_IsAdmin$)|(^A_ScreenWidth$)|(^A_ScreenHeight$)|(^A_IPAddress1$)|(^A_IPAddress2$)|(^A_IPAddress3$)|(^A_IPAddress4$)|(^A_Cursor$)|(^A_CaretX$)|(^A_CaretY$)",ahkVar)
                    RString := %ahkVar%
                Else If RegExMatch(env,"i)(^ALLUSERSPROFILE$)|(^APPDATA$)|(^CommonProgramFiles$)|(^COMPUTERNAME$)|(^ComSpec$)|(^FP_NO_HOST_CHECK$)|(^HOMEDRIVE$)|(^HOMEPATH$)|(^LOCALAPPDATA$)|(^LOGONSERVER$)|(^NUMBER_OF_PROCESSORS$)|(^OS$)|(^Path$)|(^PROCESSOR_ARCHITECTURE$)|(^PROCESSOR_IDENTIFIER$)|(^PROCESSOR_LEVEL$)|(^PROCESSOR_REVISION$)|(^ProgramData$)|(^ProgramFiles$)|(^PROMPT$)|(^PSModulePath$)|(^SESSIONNAME$)|(^SystemDrive$)|(^SystemRoot$)|(^TEMP$)|(^TMP$)|(^USERDOMAIN$)|(^USERNAME$)|(^USERPROFILE$)|(^windir$)",sysVar)
                {
                    EnvGet,getsysVar,%sysVar%
                    ;msgbox % sysvar "`n" getsysVar
                    RString := getsysVar
                }
                Else
                    RString := m
            }
            inter := SubStr(string,p1,p2-p1)
            p1 := p2 + Strlen(m)
            over := SubStr(string,p1)
            r .= inter RString
        }
        Return r
	}
	; GetEnvs(e) {{{2
	GetEnvs(e) {
		this.CheckTime()
		Return GlobalGetEnvs(e)
	}
	; SetEnvs(e,v) {{{2
	SetEnvs(e,v) {
		this.CheckTime()
		return GlobalSetEnvs(e,v)
	}
	; Set(s,k="",v="") {{{2
	Set(s,k="",v="") {
		cnt := this.content[0]
		If not this.GetSectionsR("i)^" this._ToMatch(s) "$") {
			this.content[0] := cnt + 1
			this.content[cnt+1] := "[" s "]"
			this.content["`nsections"] .= sec "`n"
			this.content[sec "`nnumber"] := 0
		}
		If strlen(k) {
			cnt := this.content[0]
			this.content[0] := cnt + 1
			this.content[cnt+1] := k "=" v "`n"

			this.content[s "`nkeys"] .= k "`n"
			this.content[s "`nkeyValue"] .= k "=" v "`n"
			this.content[s "`n" k] := v
			idx := this.content[s "`nnumber"] + 1
			this.content[s "`nnumber"] := idx
			this.content[s "`nnumber" idx] := k "=" v
		}
	}
	_ToMatch(str){
		str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
		Return RegExReplace(str,"\s","\s")
	}
}

; GetINIObj(p) {{{1
GetINIObj(i){
	global SaveINIObj
	p := ConvertPath(i)
	If not IsObject(SaveINIObj)
		SaveINIObj := []
	If Not FileExist(p)
		return 	
	r := SaveINIObj[p] 	
	If not strlen(r.filePath) {
		r := new INI(p)
		SaveINIObj[p] := r
	}
	return r
}

; ConvertPath(p,type="l") {{{1
ConvertPath(p,type="l") {
    Loop,%p%,1
        lp := A_LoopFileLongPath
    Loop,%lp%,1
    {
        If type = r
            Return SubStr(lp,Strlen(A_Loopfiledir)+2)
        If type = l
            Return A_LoopFileLongPath
        If type = s
            Return A_LoopFileShortPath
    }
}

; GlobalGetEnvs(e) {{{1
GlobalGetEnvs(e){
	global globalenv
	v := globalenv[e]
	If v.Vaild
	{
		ErrorLevel := False
		return v.var
	}
	Else
	{
		ErrorLevel := True
		return e
	}
}
; GlobalSetEnvs(e,v) {{{1
GlobalSetEnvs(e,v){
	global globalenv
	If not IsObject(globalenv)
		globalenv := []
	globalenv[e] := v
}
