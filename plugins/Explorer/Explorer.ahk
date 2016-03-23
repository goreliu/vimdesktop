; 因为Explorer对快捷键支持很不友好，此插件功能不全而且部分功能有问题。
; 仅用于必须临时使用Explorer的场景。

Explorer:
    ; 定义注释
    vim.comment("<Explorer_NormalMode>", "进入normal模式")
    vim.comment("<Explorer_InsertMode>", "进入insert模式")
    vim.comment("<Explorer_GoToParent>", "进入上一层目录")
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
    vim.comment("<Explorer_GoToTC>", "使用TC打开当前目录")

    vim.SetWin("Explorer", "CabinetWClass")

    ; insert模式
    vim.mode("insert", "Explorer")

    vim.map("<esc>", "<Explorer_NormalMode>", "Explorer")

    ; normal模式
    vim.mode("normal", "Explorer")

    vim.map("i", "<Explorer_InsertMode>", "Explorer")
    
    vim.map("j", "<down>", "Explorer")
    vim.map("k", "<up>", "Explorer")
    vim.map("h", "<Explorer_GoToParent>", "Explorer")
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
    vim.map("f", "<Explorer_GoToTC>", "Explorer")

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

<Explorer_GoToParent>:
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

<Explorer_GoToTC>:
    OldClipboard := ClipboardAll
    Clipboard =

    Send, ^c
    ClipWait, 0.3

    if (!ErrorLevel)
    {
        FileToOpen := Clipboard
        TC_OpenPath(FileToOpen, true, "/L")
        Clipboard := OldClipboard
        return
    }
    else
    {
        ; 这个比 WinGetTitle 好
        ControlGetText, OutputVar, ToolbarWindow322, A
        StringTrimLeft, FileToOpen, OutputVar, 4
        TC_OpenPath(FileToOpen, true, "/L")
        Clipboard := OldClipboard
        return
    }
return
