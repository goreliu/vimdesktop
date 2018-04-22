General:
    Gen_Save_Win := []
    vim.SetAction("<down>", "向下移动")
    vim.SetAction("<up>", "向上移动")
    vim.SetAction("<left>", "向左移动")
    vim.SetAction("<right>", "向右移动")
    vim.SetAction("<home>", "home键")
    vim.SetAction("<end>", "end键")
    vim.SetAction("<Gen_InsertMode>", "插入模式")
    vim.SetAction("<Gen_NormalMode>", "浏览模式")
    vim.SetAction("<Gen_Toggle>", "启用/禁用vim热键(General插件)")
    vim.SetAction("<Reload>", "重新加载")
    vim.SetAction("<Suspend>", "禁用")
    vim.SetAction("<WindowMoveDown>", "窗口移动到下方")
    vim.SetAction("<WindowMoveUp>", "窗口移动到上方")
    vim.SetAction("<WindowMoveLeft>", "窗口移动到左侧")
    vim.SetAction("<WindowMoveRight>", "窗口移动到右侧")
    vim.SetAction("<WindowMoveCenter>", "窗口移动到中间")
    vim.SetAction("<WindowMax>", "最大化窗口")
    vim.SetAction("<WindowMaxNoTitle>", "最大化窗口，并且隐藏标题栏")
    vim.SetAction("<WindowMin>", "最小化窗口")
    vim.SetAction("<WindowRestore>", "还原当前窗口")
    vim.SetAction("<FullScreen>", "全屏当前程序")
    vim.SetAction("<NextTab>", "下一个标签")
    vim.SetAction("<PrevTab>", "前一个标签")
    vim.SetAction("<CloseTab>", "关闭当前标签")
    vim.SetAction("<NewTab>", "新建标签")
    vim.SetAction("<ActivateTab1>", "激活第一个标签")
    vim.SetAction("<ActivateTab2>", "激活第二个标签")
    vim.SetAction("<ActivateTab3>", "激活第三个标签")
    vim.SetAction("<ActivateTab4>", "激活第四个标签")
    vim.SetAction("<ActivateTab5>", "激活第五个标签")
    vim.SetAction("<ActivateTab6>", "激活第六个标签")
    vim.SetAction("<ActivateTab7>", "激活第七个标签")
    vim.SetAction("<ActivateTab8>", "激活第八个标签")
    vim.SetAction("<ActivateTab9>", "激活第九个标签")
    vim.SetAction("<ActivateTab0>", "激活最后一个标签")
    vim.SetAction("<pgup>", "上一页")
    vim.SetAction("<pgdn>", "下一页")
    vim.SetAction("<enter>", "回车键")
    vim.SetAction("<space>", "空格键")
    vim.SetAction("<backspace>", "退格键")
    vim.SetAction("<Pass>", "屏蔽按键")
    vim.SetAction("<Media_Next>", "播放下一首")
    vim.SetAction("<Media_Prev>", "播放上一首")
    vim.SetAction("<Media_Play_Pause>", "播放/停止")
    vim.SetAction("<Media_Stop>", "停止播放")
    vim.SetAction("<RemoveToolTip>", "清除屏幕的ToolTip")
    vim.SetAction("<ShowHelp>", "显示所有按键帮助信息")
    vim.SetAction("<ToggleCapsLock>", "切换大小写")
    vim.SetAction("<MouseUp>", "向上移动鼠标")
    vim.SetAction("<MouseDown>", "向下移动鼠标")
    vim.SetAction("<MouseLeft>", "向左移动鼠标")
    vim.SetAction("<MouseRight>", "向右移动鼠标")
    vim.SetAction("<SearchInWeb>", "在网络搜索剪切板内容")
    vim.SetAction("<PrintScreenAndSave>", "截图并保存")
    vim.SetAction("<RunZ>", "运行 RunZ")
    vim.SetAction("<Test>", "测试")


    vim.SetWin("General", "General")
    vim.SetMode("insert", "General")
    vim.map("<Esc>", "<Gen_NormalMode>", "General")
    vim.SetMode("normal", "General")
    vim.map("i", "<Gen_InsertMode>", "General")
    vim.map("0", "<0>", "General")
    vim.map("1", "<1>", "General")
    vim.map("2", "<2>", "General")
    vim.map("3", "<3>", "General")
    vim.map("4", "<4>", "General")
    vim.map("5", "<5>", "General")
    vim.map("6", "<6>", "General")
    vim.map("7", "<7>", "General")
    vim.map("8", "<8>", "General")
    vim.map("9", "<9>", "General")
    vim.map("k", "<up>", "General")
    vim.map("j", "<down>", "General")
    vim.map("k", "<up>", "General")
    vim.map("h", "<left>", "General")
    vim.map("l", "<right>", "General")
    vim.map("zj", "<WindowMoveDown>", "General")
    vim.map("zk", "<WindowMoveUp>", "General")
    vim.map("zh", "<WindowMoveLeft>", "General")
    vim.map("zl", "<WindowMoveRight>", "General")
    vim.map("zc", "<WindowMoveCenter>", "General")
    vim.map("zf", "<fullscreen>", "General")
    vim.map("zm", "<WindowMax>", "General")
    vim.map("zn", "<WindowMin>", "General")
    vim.map("zr", "<WindowRestore>", "General")
    vim.map("t", "<NewTab>", "General")
    vim.map("x", "<CloseTab>", "General")
    vim.map("gn", "<NextTab>", "General")
    vim.map("gp", "<PrevTab>", "General")
    vim.map("g1", "<ActivateTab1>", "General")
    vim.map("g2", "<ActivateTab2>", "General")
    vim.map("g3", "<ActivateTab3>", "General")
    vim.map("g4", "<ActivateTab4>", "General")
    vim.map("g5", "<ActivateTab5>", "General")
    vim.map("g6", "<ActivateTab6>", "General")
    vim.map("g7", "<ActivateTab7>", "General")
    vim.map("g8", "<ActivateTab8>", "General")
    vim.map("g9", "<ActivateTab9>", "General")
    vim.map("g0", "<ActivateTab0>", "General")
    vim.BeforeActionDo("Gen_Before", "General")
return

Gen_Before()
{
    Global vim
    WinGet, MenuID, ID, AHK_CLASS #32768
    If MenuID
        return True
}

<Gen_InsertMode>:
    vim.SetMode("Insert", vim.CheckWin())
    Tooltip, Insert模式, , , 19
    Settimer, cancelTooltip, 1200
return
<Gen_NormalMode>:
    vim.SetMode("Normal", vim.CheckWin())
    Tooltip, Normal模式, , , 19
    Settimer, cancelTooltip, 1200
return
<Gen_Toggle>:
    Gen_Toggle()
return
Gen_Toggle()
{
    Global vim, Gen_Save_Win
    WinGetClass, c, A
    WinGet, f, ProcessPath, ahk_class %c%
    WinName:=vim.CheckWin()
    If not Gen_Save_Win[c]
    {
        If Strlen(winName) And IsObject(vim.GetWin(winName))
        {
            MsgBox, , VimDesktop, 当前窗口 [ %winName% ] 已经拥有Vim模式`n不允许替换为通用(General)模式！
            return
        }
    }
    winObj := vim.GetWin(c)
    If not Isobject(winObj)
    {
        vim.copy("General", c, c, f)
        Gen_Save_Win[c] := True
        Tooltip, 复制VIMD热键到当前窗口成功, , , 19
    }
    Else
    {
        if vim.Toggle(c)
            Tooltip, 激活当前窗口的VIMD热键, , , 19
        else
            Tooltip, 取消当前窗口的VIMD热键, , , 19
    }
    Settimer, cancelTooltip, 1200
}
cancelTooltip:
    Tooltip, , , , 19
return
<Reload>:
    Reload
return
<Exit>:
    ExitApp
return
<Suspend>:
    Suspend
return
<down>:
    send, {down}
return
<up>:
    send, {up}
return
<left>:
    send, {left}
return
<right>:
    send, {right}
return
<home>:
    send, {home}
return
<end>:
    send, {end}
return
<pgup>:
    send, {pgup}
return
<pgdn>:
    send, {pgdn}
return
<enter>:
    send, {enter}
return
<space>:
    send, {space}
return
<backspace>:
    send, {backspace}
return
<Media_Next>:
    send, {Media_Next}
return
<Media_Prev>:
    send, {Media_Prev}
return
<Media_Stop>:
    send, {Media_Stop}
return
<Media_Play_Pause>:
    send, {Media_Play_Pause}
return

<WindowMoveDown>:
    WindowPadMove("0, +1, 1.0, 0.5")
Return
<WindowMoveUp>:
    WindowPadMove("0, -1, 1.0, 0.5")
Return
<WindowMoveLeft>:
    WindowPadMove("-1, 0, 0.5, 1.0")
Return
<WindowMoveRight>:
    WindowPadMove("+1, 0, 0.5, 1.0")
Return
<WindowMoveCenter>:
    WindowPadMove("0, 0, 0.5, 0.7")
return
<WindowMax>:
    WinMaximize, A
return
<WindowMaxNoTitle>:
    WinMaximize, A
    WinSet, Style, -0xc00000, A
return
<WindowMin>:
    WinMinimize, A
return
<WindowRestore>:
    WinRestore, A
return

; 全屏当前程序
<FullScreen>:
    FullScreen()
return
FullScreen() {
    WinGet, windowID, ID, A
    WindowState := FullScreenID[windowID]
    If Strlen(windowState) = 0
        WindowState := 0
    If WindowState
    {
        WinSet, Style, ^0xC40000, ahk_id %WindowID%
        Loop, Parse, windowState, `,
        {
            If A_Index = 2
                WinPosX := A_LoopField
            If A_Index = 3
                WinPosY := A_LoopField
            If A_Index = 4
                WindowWidth := A_LoopField
            If A_Index = 5
                WindowHeight := A_LoopField
        }
        WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight
        WindowState := 0
    }
    Else
    {
        WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
        WinSet, Style, ^0xC40000, ahk_id %WindowID%
        WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
        WindowState := 1 ", " WinPosX ", " WinPosY ", " WindowWidth ", " WindowHeight
        ;MsgBox 再按一下刚刚的热键退出全屏
    }
    FullScreenID[windowID] := WindowState
}


;====================================================================================
;
; WindowPad.ahk
; Version: 0.4
; Last Updated: 11/5/2009
;
; This file contains functions which are useful for manipulating and moving windows.
; This is a stripped down version of WindowPad v.1.56 by Lexikos.
; Downloaded from http://www.autohotkey.com/forum/topic21703.html
;

WindowPadMove(P)
{
    StringSplit, P, P, `, , %A_Space%%A_Tab%
    ; Params: 1:dirX, 2:dirY, 3:widthFactor, 4:heightFactor, 5:window

    if P1 =
        P1 = R
    if P2 =
        P2 = R

    WindowPad_WinExist(P5)

    if !WinExist()
        return

    ; Determine width/height factors.
    if (P1 or P2) {
        ; to a side
        widthFactor := P3+0 ? P3 : (P1 ? 0.5 : 1.0)
        heightFactor := P4+0 ? P4 : (P2 ? 0.5 : 1.0)
    } else {
        ; to center
        widthFactor  := P3+0 ? P3 : 1.0
        heightFactor := P4+0 ? P4 : 1.0
    }

    ; Move the window!
    MoveWindowInDirection(P1, P2, widthFactor, heightFactor)
}

MaximizeToggle(P)
{
    WindowPad_WinExist(P)

    WinGet, state, MinMax
    if state
        WinRestore
    else
        WinMaximize
}

; Does the grunt work of the script.
MoveWindowInDirection(sideX, sideY, widthFactor, heightFactor)
{
    WinGetPos, x, y, w, h

    hwnd:=WinExist()
    if (can_restore := GetWindowProperty(hwnd, "wpHasRestorePos"))
    {   ; Window has restore info. Check if it is where we last put it.
        last_x := GetWindowProperty(hwnd, "wpLastX")
        last_y := GetWindowProperty(hwnd, "wpLastY")
        last_w := GetWindowProperty(hwnd, "wpLastW")
        last_h := GetWindowProperty(hwnd, "wpLastH")
    }
    if (can_restore && last_x = x && last_y = y && last_w = w && last_h = h)
    {   ; Window is where we last put it. Check if user wants to restore.
        if SubStr(sideX, 1, 1) = "R"
        {   ; Restore on X-axis.
            restore_x := GetWindowProperty(hwnd, "wpRestoreX")
            restore_w := GetWindowProperty(hwnd, "wpRestoreW")
            StringTrimLeft, sideX, sideX, 1
        }
        if SubStr(sideY, 1, 1) = "R"
        {   ; Restore on Y-axis.
            restore_y := GetWindowProperty(hwnd, "wpRestoreY")
            restore_h := GetWindowProperty(hwnd, "wpRestoreH")
            StringTrimLeft, sideY, sideY, 1
        }
        if (restore_x != "" || restore_y != "")
        {   ; If already at the "restored" size and position, do the normal thing instead.
            if ((restore_x = x || restore_x = "") && (restore_y = y || restore_y = "")
                && (restore_w = w || restore_w = "") && (restore_h = h || restore_h = ""))
            {
                restore_x =
                restore_y =
                restore_w =
                restore_h =
            }
        }
    }
    else
    {   ; Next time user requests the window be "restored" use this position and size.
        SetWindowProperty(hwnd, "wpHasRestorePos", true)
        SetWindowProperty(hwnd, "wpRestoreX", x)
        SetWindowProperty(hwnd, "wpRestoreY", y)
        SetWindowProperty(hwnd, "wpRestoreW", w)
        SetWindowProperty(hwnd, "wpRestoreH", h)

        if SubStr(sideX, 1, 1) = "R"
            StringTrimLeft, sideX, sideX, 1
        if SubStr(sideY, 1, 1) = "R"
            StringTrimLeft, sideY, sideY, 1
    }

    ; If no direction specified, restore or only switch monitors.
    if (sideX+0 = "" && restore_x = "")
        restore_x := x, restore_w := w
    if (sideY+0 = "" && restore_y = "")
        restore_y := y, restore_h := h

    ; Determine which monitor contains the center of the window.
    m := GetMonitorAt(x+w/2, y+h/2)

    ; Get work area of active monitor.
    gosub CalcMonitorStats
    ; Calculate possible new position for window.
    gosub CalcNewSizeAndPosition

    ; If the window is already there,
    if (newx ", " newy ", " neww ", " newh) = (x ", " y ", " w ", " h)
    {   ; ..move to the next monitor along instead.

        if (sideX or sideY)
        {   ; Move in the direction of sideX or sideY.
            SysGet, monB, Monitor, %m% ; get bounds of entire monitor (vs. work area)
            x := (sideX=0) ? (x+w/2) : (sideX>0 ? monBRight : monBLeft) + sideX
            y := (sideY=0) ? (y+h/2) : (sideY>0 ? monBBottom : monBTop) + sideY
            newm := GetMonitorAt(x, y, m)
        }
        else
        {   ; Move to center (Numpad5)
            newm := m+1
            SysGet, mon, MonitorCount
            if (newm > mon)
                newm := 1
        }

        if (newm != m)
        {
            m := newm
            ; Move to opposite side of monitor (left of a monitor is another monitor's right edge)
            sideX *= -1
            sideY *= -1
            ; Get new monitor's work area.
            gosub CalcMonitorStats
        }
        else
        {
            ; No monitor to move to, alternate size of window instead.
            if sideX
                widthFactor /= 2
            else if sideY
                heightFactor /= 2
            else
                widthFactor *= 1.5
            gosub CalcNewSizeAndPosition
        }

        ; Calculate new position for window.
        gosub CalcNewSizeAndPosition
    }

    ; Restore before resizing...
    WinGet, state, MinMax
    if state
        WinRestore

    WinDelay := A_WinDelay
    SetWinDelay, 0

    ; Move the window!
    WinMove, , , newx, newy, neww, newh

    ; For console windows and other windows which have size restrictions, check
    ; that the window was actually resized. If not, reposition based on actual size.
    WinGetPos, newx, newy, realw, realh
    if (neww != realw || newh != realh)
    {
        neww := realw
        newh := realh
        gosub CalcNewPosition
        if ((newm = "" || newm = m) && (newx ", " newy ", " realw ", " realh)=(x ", " y ", " w ", " h))
        {
            if sideX
                neww //= 2
            else if sideY
                newh //= 2
            else
                neww := Round(neww*1.5)
            ; Size first, since the window size will probably be restricted in some way.
            WinMove, , , , , neww, newh
            WinGetPos, , , neww, newh
            gosub CalcNewPosition
        }
        WinMove, , , newx, newy
    }

    ; Explorer uses WM_EXITSIZEMOVE to detect when a user finishes moving a window
    ; in order to save the position for next time. May also be used by other apps.
    PostMessage, 0x232

    SetWinDelay, WinDelay

    ; Remember where we put it, to detect if the user moves it.
    SetWindowProperty(hwnd, "wpLastX", newx)
    SetWindowProperty(hwnd, "wpLastY", newy)
    SetWindowProperty(hwnd, "wpLastW", neww)
    SetWindowProperty(hwnd, "wpLastH", newh)
    return

CalcNewSizeAndPosition:
    ; Calculate new size.
    if (IsResizable()) {
        neww := restore_w != "" ? restore_w : Round(monWidth * widthFactor)
        newh := restore_h != "" ? restore_h : Round(monHeight * heightFactor)
    } else {
        neww := w
        newh := h
    }
CalcNewPosition:
    ; Calculate new position.
    newx := restore_x != "" ? restore_x : Round(monLeft + (sideX+1) * (monWidth  - neww)/2)
    newy := restore_y != "" ? restore_y : Round(monTop  + (sideY+1) * (monHeight - newh)/2)
    return

CalcMonitorStats:
    ; Get work area (excludes taskbar-reserved space.)
    SysGet, mon, MonitorWorkArea, %m%
    monWidth  := monRight - monLeft
    monHeight := monBottom - monTop
    return
}

; Get/set window property. type should be int, uint or float.
GetWindowProperty(hwnd, property_name, type="int") {
    return DllCall("GetProp", "uint", hwnd, "str", property_name, type)
}
SetWindowProperty(hwnd, property_name, data, type="int") {
    return DllCall("SetProp", "uint", hwnd, "str", property_name, type, data)
}

; Get the index of the monitor containing the specified x and y co-ordinates.
GetMonitorAt(x, y, default=1)
{
    SysGet, m, MonitorCount
    ; Iterate through all monitors.
    Loop, %m%
    {
        ; Check if the window is on this monitor.
        SysGet, Mon, Monitor, %A_Index%
        if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
            return A_Index
    }

    return default
}

IsResizable()
{
    WinGetClass, Class
    if Class = Chrome_XPFrame
        return true
    if Class = ConsoleWindowClass
        return false
    WinGet, Style, Style
    return (Style & 0x40000) ; WS_SIZEBOX
}

WindowPad_WinExist(WinTitle)
{
    if WinTitle = P
        return WinPreviouslyActive()
    if WinTitle = M
    {
        MouseGetPos, , , win
        return WinExist("ahk_id " win)
    }
    return WinExist(WinTitle!="" ? WinTitle : "A")
}

; Note: This may not work properly with always-on-top windows. (Needs testing)
WinPreviouslyActive()
{
    active := WinActive("A")
    WinGet, win, List

    ; Find the active window.
    ; (Might not be win1 if there are always-on-top windows?)
    Loop, %win%
        if (win%A_Index% = active)
        {
            if (A_Index < win)
                N := A_Index+1

            ; hack for PSPad: +1 seems to get the document (child!) window, so do +2
            ifWinActive, ahk_class TfPSPad
                N += 1

            break
        }

    ; Use WinExist to set Last Found Window (for consistency with WinActive())
    return WinExist("ahk_id " . win%N%)
}


;
; Switch without moving/resizing (relative to screen)
;
WindowScreenMove(P)
{
    SetWinDelay, 0

    StringSplit, P, P, `, , %A_Space%%A_Tab%
    ; 1:Next|Prev|Num, 2:Window

    WindowPad_WinExist(P2)

    WinGet, state, MinMax
    if state = 1
        WinRestore

    WinGetPos, x, y, w, h

    ; Determine which monitor contains the center of the window.
    ms := GetMonitorAt(x+w/2, y+h/2)

    SysGet, mc, MonitorCount

    ; Determine which monitor to move to.
    if P1 in , N, Next
    {
        md := ms+1
        if (md > mc)
            md := 1
    }
    else if P1 in P, Prev, Previous
    {
        md := ms-1
        if (md < 1)
            md := mc
    }
    else if P1 is integer
        md := P1

    if (md=ms or (md+0)="" or md<1 or md>mc)
        return

    ; Get source and destination work areas (excludes taskbar-reserved space.)
    SysGet, ms, MonitorWorkArea, %ms%
    SysGet, md, MonitorWorkArea, %md%
    msw := msRight - msLeft, msh := msBottom - msTop
    mdw := mdRight - mdLeft, mdh := mdBottom - mdTop

    ; Calculate new size.
    if (IsResizable()) {
        w := Round(w*(mdw/msw))
        h := Round(h*(mdh/msh))
    }

    ; Move window, using resolution difference to scale co-ordinates.
    WinMove, , , mdLeft + (x-msLeft)*(mdw/msw), mdTop + (y-msTop)*(mdh/msh), w, h

    if state = 1
        WinMaximize
}


;
; "Gather" windows on a specific screen.
;
GatherWindows(md=1)
{
    global ProcessGatherExcludeList

    SetWinDelay, 0

    ; List all visible windows.
    WinGet, win, List

    ; Copy bounds of all monitors to an array.
    SysGet, mc, MonitorCount
    Loop, %mc%
        SysGet, mon%A_Index%, MonitorWorkArea, %A_Index%

    if md = M
    {
        ; Special exception for 'M', since the desktop window
        ; spreads across all screens.
        CoordMode, Mouse, Screen
        MouseGetPos, x, y
        md := GetMonitorAt(x, y, 0)
    }
    else if md is not integer
    {
        ; Support A, P and WinTitle.
        ; (Gather at screen containing specified window.)
        WindowPad_WinExist(md)
        WinGetPos, x, y, w, h
        md := GetMonitorAt(x+w/2, y+h/2, 0)
    }
    if (md<1 or md>mc)
        return

    ; Destination monitor
    mdx := mon%md%Left
    mdy := mon%md%Top
    mdw := mon%md%Right - mdx
    mdh := mon%md%Bottom - mdy

    Loop, %win%
    {
        ; If this window matches the GatherExclude group, don't touch it.
        if (WinExist("ahk_group GatherExclude ahk_id " . win%A_Index%))
            continue

        ; Set Last Found Window.
        if (!WinExist("ahk_id " . win%A_Index%))
            continue

        WinGet, procname, ProcessName
        ; Check process (program) exclusion list.
        if procname in %ProcessGatherExcludeList%
            continue

        WinGetPos, x, y, w, h

        ; Determine which monitor this window is on.
        xc := x+w/2, yc := y+h/2
        ms := 0
        Loop, %mc%
            if (xc >= mon%A_Index%Left && xc <= mon%A_Index%Right
                && yc >= mon%A_Index%Top && yc <= mon%A_Index%Bottom)
            {
                ms := A_Index
                break
            }
        ; If already on destination monitor, skip this window.
        if (ms = md)
            continue

        WinGet, state, MinMax
        if (state = 1) {
            WinRestore
            WinGetPos, x, y, w, h
        }

        if ms
        {
            ; Source monitor
            msx := mon%ms%Left
            msy := mon%ms%Top
            msw := mon%ms%Right - msx
            msh := mon%ms%Bottom - msy

            ; If the window is resizable, scale it by the monitors' resolution difference.
            if (IsResizable()) {
                w *= (mdw/msw)
                h *= (mdh/msh)
            }

            ; Move window, using resolution difference to scale co-ordinates.
            WinMove, , , mdx + (x-msx)*(mdw/msw), mdy + (y-msy)*(mdh/msh), w, h
        }
        else
        {
            ; Window not on any monitor, move it to center.
            WinMove, , , mdx + (mdw-w)/2, mdy + (mdh-h)/2
        }

        if state = 1
            WinMaximize
    }
}

GetLastMinimizedWindow()
{
    WinGet, w, List

    Loop %w%
    {
        wi := w%A_Index%
        WinGet, m, MinMax, ahk_id %wi%
        if m = -1 ; minimized
        {
            lastFound := wi
            break
        }
    }

    return "ahk_id " . (lastFound ? lastFound : 0)
}


;================================== 功能代码 :由北风一叶提供
;下一个标签
<NextTab>:
    send ^{tab}
return

;上一个标签
<PrevTab>:
    send ^+{tab}
return

;关闭当前标签
<CloseTab>:
    send ^{w}
return

;新建标签
<NewTab>:
    send ^{t}
return

;激活第一个标签
<ActivateTab1>:
    send ^{1}
return

;激活第二个标签
<ActivateTab2>:
    send ^{2}
return

;激活第三个标签
<ActivateTab3>:
    send ^{3}
return

;激活第四个标签
<ActivateTab4>:
    send ^{4}
return

;激活第五个标签
<ActivateTab5>:
    send ^{5}
return

;激活第六个标签
<ActivateTab6>:
    send ^{6}
return

;激活第七个标签
<ActivateTab7>:
    send ^{7}
return

;激活第八个标签
<ActivateTab8>:
    send ^{8}
return

;激活第九个标签
<ActivateTab9>:
    send ^{8}^{tab}
return

;激活最后一个标签
<ActivateTab0>:
    send ^{9}
return

;清除 ToolTip 计时器
<RemoveToolTip>:
    Global showToolTipStatus

    SetTimer, <RemoveToolTip>, Off
    ToolTip
    showToolTipStatus := false
return

;进入、退出模式时显示提示
DisplayMode(ahk_class_name, mode_name)
{
    Global vim
    Global showToolTipStatus

    ToolTip, 进入 %mode_name% 模式
    showToolTipStatus := true

    SetTimer, <RemoveToolTip>, 500
}

ShowHelp()
{
    Global vim

    modeObj := vim.GetMode(vim.LastFoundWin)

    np := "help`n"
    np .= "=====================`n"

    for i, k in modeObj.keymapList
    {
        if (i >= 0 && i <= 9)
        {
            Continue
        }

        act := vim.GetAction(modeObj.GetKeyMap(i))
        if (act.Type = 1)
        {
            ActionDescList := act.Comment
            np .= i "`t"  %ActionDescList%[i] "`n"
        }
        else
        {
            np .= i "`t" act.Comment "`n"
        }
    }

    MouseGetPos, posx, posy, A
    posx += 40
    posy += 40
    Tooltip, %np%, %posx%, %posy%
}

<ShowHelp>:
    Global showToolTipStatus

    if (!showToolTipStatus)
    {
        ShowHelp()
    }
    else
    {
        ToolTip
    }

    showToolTipStatus := !showToolTipStatus
return

<ToggleCapsLock>:
    GetKeyState, CapsLockState, CapsLock, T
    if CapsLockState = D
        SetCapsLockState, AlwaysOff
    else
        SetCapsLockState, AlwaysOn
return

<MouseUp>:
    MouseMove, 0, -10, 0, R
return

<MouseDown>:
    MouseMove, 0, 10, 0, R
return

<MouseLeft>:
    MouseMove, -10, 0, 0, R
return

<MouseRight>:
    MouseMove, 10, 0, 0, R
return

<SearchInWeb>:
    Run, cmd /c start https://www.baidu.com/s?wd=%Clipboard%, , Hide
return

<Test>:
    MsgBox, 测试
return

TestFunction(arg)
{
    MsgBox, 参数：%arg%
}

<PrintScreenAndSave>:
    if (RegExMatch(A_ThisHotkey, "i)!PrintScreen"))
    {
        Send, !{PrintScreen}
    }
    else
    {
        Send, {PrintScreen}
    }

    sleep, 50

    FileSelectFile, selectedFile, s16, 截图_%A_Now%.png, 另存为, 图片(*.png; *.jpg; *.gif; *.bmp)

    if (selectedFile == "")
    {
        return
    }

    SaveImageFromClipboard(selectedFile)
return

SaveImageFromClipboard(filename)
{
    pToken := Gdip_Startup()
    pBitmap := Gdip_CreateBitmapFromClipboard()
    Gdip_SaveBitmapToFile(pBitmap, filename)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
}

; ScreenSnapshot("FullScreen.png")
; ScreenSnapshot("Area_xywh.png", "10|20|200|200")
ScreenSnapshot(filename, area := 0)
{
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromScreen(area)
    Gdip_SaveBitmapToFile(pBitmap, filename)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)
}

SwitchIME(dwLayout)
{
    HKL := DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus, ctl, A
    SendMessage, 0x50, 0, HKL, %ctl%, A
}

; 来自天甜
; 用法：SwitchIMEname("中文(简体) - 百度输入法")
SwitchIMEByName(name)
{
    Loop, HKLM, SYSTEM\CurrentControlSet\Control\Keyboard Layouts, 1, 1
    {
        IfEqual, A_LoopRegName, Layout Text
        {
            RegRead, Value
            IfInString,value,%name%
            {
                RegExMatch(A_LoopRegSubKey, "[^\\]+$", dwLayout)
                HKL := DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
                ControlGetFocus, ctl, A
                SendMessage, 0x50, 0, HKL, %ctl%, A
                break
            }
        }
    }
}

<SwitchToEngIME>:
    ; 下方代码可只保留一个
    SwitchIME(0x04090409) ; 英语(美国) 美式键盘
    SwitchIME(0x08040804) ; 中文(中国) 简体中文-美式键盘
return

<SwitchToEngIMEAndEsc>:
    Send, {esc}
    ; 下方代码可只保留一个
    SwitchIME(0x04090409) ; 英语(美国) 美式键盘
    SwitchIME(0x08040804) ; 中文(中国) 简体中文-美式键盘
return

<RunZ>:
    RunZPath := A_ScriptDir "\..\RunZ\RunZ.exe"
    if (ini.config.runz_dir != "")
    {
        RunZPath := ini.config.runz_dir "\RunZ.exe"
    }

    if (!FileExist(RunZPath))
    {
        return
    }

    Run, "%RunZPath%"
return

<AppendClipboard>:
    OldClipboard := Clipboard
    Clipboard =
    Send, ^c
    ClipWait, 2
    Clipboard := OldClipboard . Clipboard
return

<OpenBaiduNetdiskLink>:
    Clipboard =
    Send, ^c
    ClipWait, 1

    Result := StrSplit(RegExReplace(Clipboard, "(链接：|密码：|提取)"), " ")
    Run, % Result[1]
    Sleep, 2000
    Send, % Result[2]
    Send, {Enter}
return

ClickContextMenu(key)
{
    Send, {AppsKey}
    WinWait, ahk_class #32768
    Send, %key%
}

<RunAhkInClipboard>:
    tmp_file := A_Temp "\tmpcode.ahk"
    FileDelete, %tmp_file%
    FileAppend, %Clipboard%, %tmp_file%
    Run, %A_ScriptDir%\vimd.exe %tmp_file%
return

<SuspendMachine>:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return

<AlwaysOnTop>:
    WinSet, AlwaysOnTop, on, A
return

<CancelAlwaysOnTop>:
    WinSet, AlwaysOnTop, off, A
return

<ToggleTitleBar>:
    WinSet, Style, ^0xC40000, A
return
