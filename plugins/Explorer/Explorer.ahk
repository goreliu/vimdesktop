; 因为Explorer对快捷键支持很不友好，此插件功能不全而且部分功能有问题。
; 仅用于必须临时使用Explorer的场景。

Explorer:
    ; 定义注释
    vim.comment("<Explorer_NormalMode>", "进入normal模式")
    vim.comment("<Explorer_InsertMode>", "进入insert模式")
    vim.comment("<Explorer_GotoParent>", "进入上一层目录")
    vim.comment("<Explorer_Enter>", "进入目录")
    vim.comment("<Explorer_IconViewX>", "图标视图 超大")
    vim.comment("<Explorer_IconViewR>", "图标视图 大")
    vim.comment("<Explorer_IconViewM>", "图标视图 中等")
    vim.comment("<Explorer_IconViewN>", "图标视图 小")
    vim.comment("<Explorer_IconViewS>", "图标视图 平铺")
    vim.comment("<Explorer_ListViewL>", "列表视图 列表")
    vim.comment("<Explorer_ListViewD>", "列表视图 详情")
    vim.comment("<Explorer_ListViewT>", "列表视图 内容")
    vim.comment("<Explorer_Tree>", "定位到左侧目录栏")
    vim.comment("<Explorer_Main>", "定位到右侧文件栏")
    vim.comment("<Explorer_Rename>", "重命名")
    vim.comment("<Explorer_GotoTC>", "使用TC打开当前目录")
    vim.comment("<Explorer_GotoTCX>", "使用TC打开当前目录，并关闭Explorer")
    vim.comment("<Explorer_GotoTCInNewTab>", "使用TC在新标签页打开当前目录")
    vim.comment("<Explorer_GotoTCInNewTabX>", "使用TC在新标签页打开当前目录，并关闭Explorer")

    vim.SetWin("Explorer", "CabinetWClass")

    ; insert模式
    vim.mode("insert", "Explorer")

    vim.map("<esc>", "<Explorer_NormalMode>", "Explorer")

    ; normal模式
    vim.mode("normal", "Explorer")

    vim.map("i", "<Explorer_InsertMode>", "Explorer")
    
    vim.map("j", "<down>", "Explorer")
    vim.map("k", "<up>", "Explorer")
    vim.map("h", "<Explorer_GotoParent>", "Explorer")
    vim.map("l", "<Explorer_Enter>", "Explorer")

    vim.map("t", "<Explorer_Tree>", "Explorer")
    vim.map("m", "<Explorer_Main>", "Explorer")
    vim.map("n", "<Explorer_IconViewR>", "Explorer")
    vim.map("N", "<Explorer_ListViewD>", "Explorer")
    vim.map("r", "<Explorer_Rename>", "Explorer")

    vim.map("H", "<backspace>", "Explorer")
    vim.map("<c-h>", "<left>", "Explorer")
    vim.map("<c-l>", "<right>", "Explorer")
    vim.map("<c-j>", "<down>", "Explorer")
    vim.map("<c-k>", "<up>", "Explorer")
    vim.map("gg", "<home>", "Explorer")
    vim.map("G", "<end>", "Explorer")
    vim.map("f", "<Explorer_GotoTCInNewTab>", "Explorer")
    vim.map("F", "<Explorer_GotoTC>", "Explorer")

    vim.BeforeActionDo("Explorer_ForceInsertMode", "Explorer")

return

; 对指定控件使用insert模式
Explorer_ForceInsertMode()
{
    ControlGetFocus, ctrl, AHK_CLASS CabinetWClass
    ;MsgBox ctrl
    if (RegExMatch(ctrl, "Edit|DirectUIHWND1") or WinExist("ahk_class #32768"))
        return true
    return false
}

<Explorer_NormalMode>:
    vim.mode("normal", "Explorer")
return

<Explorer_InsertMode>:
    vim.mode("insert", "Explorer")
return

<Explorer_GotoParent>:
    Send, !{up}
return

<Explorer_IconViewX>:
    ; 这系列命令必须保证鼠标不在焦点文件上才有效
    Send, {Click, right}vx
return

<Explorer_IconViewR>:
    Send, {Click, right}vr
return

<Explorer_IconViewM>:
    Send, {Click, right}vm
return

<Explorer_IconViewN>:
    Send, {Click, right}vn
return

<Explorer_IconViewS>:
    Send, {Click, right}vs
return

<Explorer_ListViewL>:
    Send, {Click, right}vl
return

<Explorer_ListViewD>:
    Send, {Click, right}vd
return

<Explorer_ListViewS>:
    Send, {Click, right}vs
return

<Explorer_ListViewT>:
    Send, {Click, right}vt
return

<Explorer_Enter>:
    Send, {enter}
    sleep, 100
    ; 如果载入目录时间过长，不会自动定位到第一个文件
    Send, {down}{up}{right}{left}
return

<Explorer_Tree>:
    ControlFocus, SysTreeView321
return

<Explorer_Main>:
    ControlFocus, DirectUIHWND3
return

<Explorer_Rename>:
    Send, {f2}
return

<Explorer_GotoTC>:
    Explorer_GotoTC(false)
return

<Explorer_GotoTCX>:
    Explorer_GotoTC(false, true)
return

<Explorer_GotoTCInNewTab>:
    Explorer_GotoTC(true)
return

<Explorer_GotoTCInNewTabX>:
    Explorer_GotoTC(true, true)
return

Explorer_GotoTC(newTab, closeExplorer = false)
{
    OldClipboard := ClipboardAll
    Clipboard =

    Send, ^c
    ClipWait, 0.3

    if (!ErrorLevel)
    {
        FileToOpen := Clipboard
        if (closeExplorer)
        {
            WinClose, A
        }
        TC_OpenPath(FileToOpen, newTab, "/L")
        Clipboard := OldClipboard
        OldClipboard =
    }
    else
    {
        FileToOpen := Explorer_GetPath()
        if (closeExplorer)
        {
            WinClose, A
        }
        TC_OpenPath(FileToOpen, newTab, "/L")
    }

    Clipboard := OldClipboard
    OldClipboard =
}

Explorer_GetPath(hwnd = "")
{
    if !(window := Explorer_GetWindow(hwnd))
        return ErrorLevel := "Error"
    if (window = "desktop")
        return A_Desktop
    path := window.LocationURL
    path := RegExReplace(path, "ftp://.*@", "ftp://")
    StringReplace, path, path, file:///
    StringReplace, path, path, /, \, All

    ; thanks to polyethene
    Loop
        if RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
            StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
        else Break
    return path
}

Explorer_GetAll(hwnd = "")
{
    return Explorer_Get(hwnd)
}

Explorer_GetSelected(hwnd = "")
{
    return Explorer_Get(hwnd, true)
}

Explorer_GetWindow(hwnd = "")
{
    ; thanks to jethrow for some pointers here
    WinGet, Process, ProcessName, % "ahk_id" hwnd := hwnd ? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%

    if (Process!="explorer.exe")
        return

    if (class ~= "(Cabinet|Explore)WClass")
    {
        for window in ComObjCreate("Shell.Application").Windows
        if (window.hwnd == hwnd)
            return window
    }
    else if (class ~= "Progman|WorkerW")
        return "desktop" ; desktop found
}

Explorer_Get(hwnd = "", selection = false)
{
    if !(window := Explorer_GetWindow(hwnd))
        return ErrorLevel := "Error"
    if (window="desktop")
    {
        ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
        if !hwWindow ; #D mode
            ControlGet, hwWindow, HWND,, SysListView321, A
        ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
        base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop
        Loop, Parse, files, `n, `r
        {
            path := base "\" A_LoopField
            IfExist %path% ; Ignore special icons like Computer (at least for now)
                ret .= path "`n"
        }
    }
    else
    {
        if selection
            collection := window.document.SelectedItems
        else
            collection := window.document.Folder.Items
        for item in collection
        ret .= item.path "`n"
    }
    return Trim(ret,"`n")
}
return
