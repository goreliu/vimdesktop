DoubleCommander:
    global DoubleCommander_name := "DoubleCommander"
    global DoubleCommander_class := "DClass"
    global DoubleCommander_exe := "doublecmd.exe"

    ; normal模式
    vim.SetWin(DoubleCommander_name, DoubleCommander_class, DoubleCommander_exe)
    vim.mode("normal", DoubleCommander_name)

    vim.map("h", "<left>", DoubleCommander_name)
    vim.map("j", "<down>", DoubleCommander_name)
    vim.map("k", "<up>", DoubleCommander_name)
    vim.map("l", "<enter>", DoubleCommander_name)
    vim.map("gg", "<DoubleCommander_GoToFirstFile>", DoubleCommander_name)
    vim.map("G", "<end>", DoubleCommander_name)
    vim.map("o", "<DoubleCommander_ContextMenu>", DoubleCommander_name)
    vim.map("<la-r>", "<DoubleCommander_Rename>", DoubleCommander_name)
    vim.map("<f2>", "<DoubleCommander_RenameFull>", DoubleCommander_name)
    vim.map("<c-f>", "<pgdn>", DoubleCommander_name)
    vim.map("<c-b>", "<pgup>", DoubleCommander_name)

    vim.BeforeActionDo("DoubleCommander_ForceInsertMode", DoubleCommander_name)
return

DoubleCommander_ForceInsertMode()
{
    ControlGetFocus, ctrl
    ;MsgBox % ctrl
    if RegExMatch(ctrl, "Edit")
        return true
    return false

    ;WinGet, MenuID, ID, AHK_CLASS #32768
    ;if MenuID
    ;    return true
}

<DoubleCommander_GoToFirstFile>:
    Send, {home}{down}
return

<DoubleCommander_ContextMenu>:
    Send, {appskey}
return

<DoubleCommander_Rename>:
    Send, {f2}{right}
return

<DoubleCommander_RenameFull>:
    Send, {f2}^a
return

/*  插件缺失功能：

    从模板创建新文件
    进入目录后自动定位到第一个文件
    切换 50% 100% cm_PanelsSplitterPerPos
    切换到上/下一个同级目录
*/

/*  DC 现有问题：

    不能查看回收站（阻碍迁移，暂时可以用资源管理器来查看）
    不能单独定制文件打开方式（有些影响，但可以定制右键菜单）
    图片快速浏览过慢（影响不大，用 Imagine 后速度基本没问题了，只是快速切换图片时会闪屏）
    内存占用比 TC 稍高（基本没有影响）
*/

/*  DC 的优势：

    开源，免费，跨平台，可以自由改代码定制功能
    内建 lua 解释器，方便写一些高级功能（TC 插件通过异步消息调用 TC，会遇到很多同步相关麻烦）
    配置界面更漂亮、好用

    总体吸引力不足，缺少重量级优势，暂时还不切换
*/
