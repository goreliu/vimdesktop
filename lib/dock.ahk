
; lib : Dock
; Ver 2.0 b3
; author : majkinetor.
Dock(pClientID, pDockDef="", reset=0) {                    ;Reset is internal parameter, used by Dock_Shutdown 
   local cnt, new, cx, cy, hx, hY, t, hP
   static init=0, idDel, classes="x|y|w|h"

    if (reset)                                             ;Used by Dock Shutdown to reset the function 
		return init := 0 

	if !init
		Dock_aClient_0_ := 0

   cnt := Dock_aClient_0_ 

   ;remove dock client ? 
   if (pDockDef="-") and (Dock_%pClientID%){ 

      idDel := Dock_%pClientID% 

      loop, parse, classes, |
		loop, 3
         Dock_%pClientID%_%A_LoopField%%A_Index% := ""
	  Dock_%pClientID% := ""			; don't remove t Dock_%pClientID%_t := 
       
      ;move last one to the place of the deleted one 
      Dock_aClient_%idDel%_ := Dock_aClient_%cnt%_, Dock_aClient_%cnt%_ := "", Dock_aClient_0_-- 
      return "OK - Remove" 
   } 

   if pDockDef = 
   { 
      WinGetPos hX, hY,,, ahk_id %Dock_HostID% 
      WinGetPos cX, cY,,, ahk_id %pClientID% 
      pDockDef := "x(0,0," cX - hX ")  y(0,0," cY - hY ")"
   } 

   ;add new dock client if it not exists, or update its dock settings if it exists 
	loop, parse, pDockDef, %A_Space%%A_Tab%
	   if (A_LoopField != "") {
			t := A_LoopField, c := SubStr(t,1,1)
			if c not in x,y,w,h,t
				return "ERR: Bad dock definition"

			if c = t
			{
				 Dock_%pClientID%_t := 1
			}
			else {			
				t := SubStr(t,3,-1)
				StringReplace, t, t,`,,|,UseErrorLevel
				t .= !ErrorLevel ? "||" : (ErrorLevel=1 ? "|" : "")
				loop, parse, t,|,%A_Space%%A_Tab% 
					Dock_%pClientID%_%c%%A_Index% := A_LoopField ? A_LoopField : 0
			}
	   }

	if !Dock_%pClientID% {
		Dock_%pClientID%   := ++cnt, 
		Dock_aClient_%cnt%_ := pClientId 
		Dock_aClient_0_++ 
	}

   ;start the dock if its not already started
   If !init { 
      init++, Dock_hookProcAdr := RegisterCallback("Dock_HookProc")
      Dock_Toggle(true)	 
   } 

   Dock_Update()
   return "OK" 
}       


;----------------------------------------------------------------------------------------------------- 
;Function:  Dock_Shutdown 
;			Uninitialize dock module. This will clear all clients and internal data and unregister hooks. 
;			Dock_OnHostDeath, Dock_HostId are kept on user values. 
; 
Dock_Shutdown() { 
   local cID 

   Dock_Toggle(false) 
   DllCall("GlobalFree", "UInt", Dock_hookProcAdr), Dock_hookProcAdr := "" 
   Dock(0,0,1)         ;reset dock function 

   ;erase clients 
   loop, % Dock_aClient_0_ 
   { 
      cId := Dock_aClient_%A_Index%_, Dock_aClient_%A_Index%_ := "" 
      Dock_%cID% := "" 
      loop, 10 
         Dock_%cID%_%A_Index% := "" 
   }
}

;----------------------------------------------------------------------------------------------------- 
;Function: Dock_Toggle 
;          Toggles the dock module ON or OFF.
; 
;Parameters: 
;         enable - Set to true to set the dock ON, set to FALSE to turn it OFF. Skip to toggle. 
; 
;Remarks: 
;         Use Dock_Toggle(false) to suspend the dock module (to unregister hook), leaving its internal data in place. 
;         This is different from Dock_Shutdown as latest removes module completely from memory and 
;         unregisters its clients. 
;          
;         You can also use this function to temporary disable module when you don't want dock update routine to interrupt your time critical sections. 
;
Dock_Toggle( enable="" ) { 
   global 

   if Dock_hookProcAdr = 
      return "ERR - Dock must be loaded." 

   if enable = 
      enable := !Dock_hHook1 
   else if (enable && Dock_hHook1)
		return	"ERR - Dock already enabled"

   if !enable 
      API_UnhookWinEvent(Dock_hHook1), API_UnhookWinEvent(Dock_hHook2), API_UnhookWinEvent(Dock_hHook3), Dock_hHook3 := Dock_hHook1 := Dock_hHook2 := "" 
   else  { 
      Dock_hHook1 := API_SetWinEventHook(3,3,0,Dock_hookProcAdr,0,0,0)				; EVENT_SYSTEM_FOREGROUND 
      Dock_hHook2 := API_SetWinEventHook(0x800B,0x800B,0,Dock_hookProcAdr,0,0,0)	; EVENT_OBJECT_LOCATIONCHANGE 
	  Dock_hHook3 := API_SetWinEventHook(0x8002,0x8003,0,Dock_hookProcAdr,0,0,0)	; EVENT_OBJECT_SHOW, EVENT_OBJECT_HIDE

      if !(Dock_hHook1 && Dock_hHook2 && Dock_hHook3) {	   ;some of them failed, unregister everything
         API_UnhookWinEvent(Dock_hHook1), API_UnhookWinEvent(Dock_hHook2), API_UnhookWinEvent(Dock_hHook3) 
         return "ERR - Hook failed" 
      } 

	 Dock_Update() 
   } 
   return enable
} 
;==================================== INTERNAL ====================================================== 
Dock_Update() { 
   local hX, hY, hW, hh, W, H, X, Y, cx, cy, cw, ch, fid, wd, cid 
   static gid=0   ;fid & gid are function id and global id. I use them to see if the function interupted itself. 

   wd := A_WinDelay 
   SetWinDelay, -1 
   fid := gid += 1 
   WinGetPos hX, hY, hW, hH, ahk_id %Dock_HostID% 
;   OutputDebug %hX% %hY% %hW% %hH%	 %event%

   ;xhw,xw,xd,  yhh,yh,yd,  whw,wd,  hhh,hd 
	loop, % Dock_aClient_0_ 
	{ 
		cId := Dock_aClient_%A_Index%_ 
		WinGetPos cX, cY, cW, cH, ahk_id %cID% 
		W := Dock_%cId%_w1*hW + Dock_%cId%_w2,  H := Dock_%cId%_h1*hH + Dock_%cId%_h2 
		X := hX + Dock_%cId%_x1*hW + Dock_%cId%_x2* (W ? W : cW) + Dock_%cId%_x3
		Y := hY + Dock_%cId%_y1*hH + Dock_%cId%_y2* (H ? H : cH) + Dock_%cId%_y3

		if (fid != gid) 				;some newer instance of the function was running, so just return (function was interupted by itself). Without this, older instance will continue with old host window position and clients will jump to older location. This is not so visible with WinMove as it is very fast, but SetWindowPos shows this in full light. 
			break
		
		if dock_resetT
		{
			dock_resetT := false
			DllCall("SetWindowLong", "uint", cId, "int", -8, "uint", 0)
		}
		DllCall("SetWindowPos", "uint", cId, "uint", 0, "uint", X ? X : cX, "uint", Y ? Y : cY, "uint", W ? W : cW, "uint", H ? H :cH, "uint", 1044) ;4 | 0x10 | 0x400 
;		WinMove ahk_id %cId%,,X ? X:"" ,Y ? Y:"", W ? W : "" ,H ? H : "" 
	}      
	SetTimer, Dock_SetZOrder, -80		;set z-order in another thread (protects also from spaming z-order changes when host is rapidly moved).
	SetWinDelay, %wd% 
}

Dock_SetZOrder: 
;    OutputDebug setzorder
	exists := WinExist("ahk_id " Dock_HostID), active := WInExist("A") = Dock_HostId
	loop, % Dock_aClient_0_  
	{
	  _ := Dock_aClient_%A_Index%_, _ := Dock_%_%_t
	  if !_
	      DllCall("SetWindowPos", "uint", Dock_aClient_%A_Index%_, "uint", Dock_HostID, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 19 | 0x4000 | 0x40)
	  else {
		;Set owned clients if they are not already set. Host may not exist here.
		_ := DllCall("GetWindowLong", "uint", Dock_aClient_%A_Index%_, "int", -8)
		if !_ and exists
		{
			dock_resetT := true
			DllCall("SetWindowLong", "uint", Dock_aClient_%A_Index%_, "int", -8, "uint", Dock_HostId)
		}
		
		DllCall("SetWindowPos", "uint", Dock_aClient_%A_Index%_, "uint"
				, active ? 0 : DllCall("GetWindow", "uint", Dock_HostId, "uint", 3) ;hwndprev
				, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 0x40 | 19 | 0x4000) ;SWP_SHOWWINDOW ..., no activate

	}
	}
return 

Dock_SetZOrder_OnClientFocus:
    ;OutputDebug setzorder on focus

	;Set host just bellow focused client.
	res := DllCall("SetWindowPos", "uint", Dock_HostID, "uint", Dock_AClient, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 19) ;SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE ...

	;Set the non-T children , T children are handled normaly by OS as owned.
	loop, % Dock_aClient_0_
	{
		_ := Dock_aClient_%A_Index%_, _ := Dock_%_%_t
		if !_
			 DllCall("SetWindowPos", "uint", Dock_aClient_%A_Index%_, "uint", Dock_HostID, "uint", 0, "uint", 0, "uint", 0, "uint", 0, "uint", 19) ;SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE
	}
return 

;-----------------------------------------------------------------------------------------
; Events :
;			3	  - Host is set to foreground
;			32779 - Location change
;			32770 - Show
;			32771 - Hide (also called on exit)
;
Dock_HookProc(hWinEventHook, event, hwnd, idObject, idChild, dwEventThread, dwmsEventTime ) { 
	local e, cls, style

	if idObject or idChild
		return
	WinGet, style, Style, ahk_id %hwnd%
	if (style & 0x40000000)					;RETURN if hwnd is child window, for some reason idChild may be 0 for some children ?!?! ( I hate ms )
		return

;	WINGETCLASS, cls, ahk_id %hwnd%
;	if cls in #32768,#32771,#32772,#32769,SysShadow,tooltips_class32		;skip some windows classes, just to speed it up
;		return

	;outputdebug % cls " " hwnd " " event
	if (event = 3) 
	{
		;check if client is taking focus
		loop, % Dock_aClient_0_
 		  if (hwnd = Dock_aClient_%A_Index%_){
			Dock_AClient := hwnd
			gosub Dock_SetZOrder_OnClientFocus
			return
		}		
	}

	If (hwnd != Dock_HostID){
      if !WinExist("ahk_id " Dock_HostID) && IsLabel(Dock_OnHostDeath)
	  {
 		 Dock_Toggle(false)
		 gosub %Dock_OnHostDeath% 
 		 loop, % Dock_aClient_0_
			DllCall("ShowWindow", "uint", Dock_aClient_%A_Index%_, "uint",  0)
	  }
	  return 
	} 

	
	if event in 32770,32771
	{
	   e := (event - 32771) * -5
	   loop, % Dock_aClient_0_
			DllCall("ShowWindow", "uint", Dock_aClient_%A_Index%_, "uint",  e)
	}

	Dock_Update() 
;	SetTimer, Dock_Update, -10
} 

Dock_Update:
	Dock_Update()
return

API_SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) { 
   DllCall("CoInitialize", "uint", 0) 
   return DllCall("SetWinEventHook", "uint", eventMin, "uint", eventMax, "uint", hmodWinEventProc, "uint", lpfnWinEventProc, "uint", idProcess, "uint", idThread, "uint", dwFlags) 
} 

API_UnhookWinEvent( hWinEventHook ) { 
   return DllCall("UnhookWinEvent", "uint", hWinEventHook) 
} 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
