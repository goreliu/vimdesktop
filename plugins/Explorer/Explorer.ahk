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

    ; insert模式
    vim.mode("insert", "CabinetWClass")

    vim.map("<esc>", "<Explorer_NormalMode>", "CabinetWClass")

    ; normal模式
    vim.mode("normal", "CabinetWClass")

    vim.map("i", "<Explorer_InsertMode>", "CabinetWClass")
    
    vim.map("j", "<down>", "CabinetWClass")
    vim.map("k", "<up>", "CabinetWClass")
    vim.map("h", "<Explorer_GoToParent>", "CabinetWClass")
    vim.map("l", "<Explorer_Enter>", "CabinetWClass")

    vim.map("t", "<Explorer_Tree>", "CabinetWClass")
    vim.map("m", "<Explorer_Main>", "CabinetWClass")
    vim.map("n", "<Explorer_IconViewR>", "CabinetWClass")
    vim.map("N", "<Explorer_ListViewD>", "CabinetWClass")
    vim.map("r", "<Explorer_Rename>", "CabinetWClass")

    vim.map("H", "<backspace>", "CabinetWClass")
    vim.map("<c-h>", "<left>", "CabinetWClass")
    vim.map("<c-l>", "<right>", "CabinetWClass")
    vim.map("<c-j>", "<down>", "CabinetWClass")
    vim.map("<c-k>", "<up>", "CabinetWClass")
    vim.map("gg", "<home>", "CabinetWClass")
    vim.map("G", "<end>", "CabinetWClass")
    vim.map("f", "<Explorer_GoToTC>", "CabinetWClass")

    vim.BeforeActionDo("Explorer_ForceInsertMode", "CabinetWClass")

return

; 对指定控件使用insert模式
Explorer_ForceInsertMode()
{
    ControlGetFocus, ctrl, AHK_CLASS CabinetWClass
    ;MsgBox ctrl
    if RegExMatch(ctrl, "Edit")
        return true
    return false
}

<Explorer_NormalMode>:
    vim.mode("normal", "CabinetWClass")
return

<Explorer_InsertMode>:
    vim.mode("insert", "CabinetWClass")
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
    ; 有时不能用
    ControlFocus, Edit1
    Send, {Click}^c
    ;MsgBox % clipboard
    GoSub, <TC_FocusTCCmd>
    Send, cd ^v{enter}
return
