DoubleCommander:
    global DC_name := "DoubleCommander"
    global DC_class := "DClass"
    global DC_exe := "doublecmd.exe"

    ; normal模式
    vim.SetWin(DC_name, DC_class, DC_exe)
    vim.mode("normal", DC_name)

    vim.map("h", "<left>", DC_name)
    vim.map("j", "<down>", DC_name)
    vim.map("k", "<up>", DC_name)
    vim.map("l", "<enter>", DC_name)
    vim.map("gg", "<DC_GoToFirstFile>", DC_name)
    vim.map("G", "<end>", DC_name)
    vim.map("o", "<DC_ContextMenu>", DC_name)
    vim.map("<la-r>", "<DC_Rename>", DC_name)
    vim.map("<f2>", "<DC_RenameFull>", DC_name)
    vim.map("<f1>", "<DC_Test>", DC_name)
    vim.map("<c-f>", "<pgdn>", DC_name)
    vim.map("<c-b>", "<pgup>", DC_name)

    vim.BeforeActionDo("DC_ForceInsertMode", DC_name)
return

DC_ForceInsertMode()
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

DC_Run(cmd)
{
    ControlSetText, Edit1, %cmd%, ahk_class %DC_class%
    ControlSend, Edit1, {enter}, ahk_class %DC_class%
}

<DC_GoToFirstFile>:
    Send, {home}{down}
return

<DC_ContextMenu>:
    Send, {appskey}
return

<DC_Rename>:
    Send, {f2}{right}
return

<DC_RenameFull>:
    Send, {f2}^a
return

<DC_Test>:
    DC_Run("cm_About")
return

/*  插件缺失功能：

    从模板创建新文件
    进入目录后自动定位到第一个文件
    切换 50% 100% cm_PanelsSplitterPerPos
    切换到上/下一个同级目录
*/

/*  DC 现有问题：

    左右面板的 ClassNN 不固定，很难获取位置信息（阻碍迁移）
    不能查看回收站（有些影响，暂时可以用资源管理器来查看）
    不能单独定制文件打开方式（影响不大，但可以定制右键菜单）
    有时常规功能会导致错误弹窗（影响不大，可以关闭）
    图片快速浏览过慢（影响不大，用 Imagine 后速度基本没问题了，只是快速切换图片时会闪屏）
    内存占用比 TC 稍高（基本没有影响）
*/

/*  DC 的优势：

    开源，免费，跨平台，可以自由改代码定制功能
    内建 lua 解释器，方便写一些高级功能（TC 插件通过异步消息调用 TC，会遇到很多同步相关麻烦）
    配置界面更漂亮、好用

    总体吸引力不足，缺少重量级优势，暂时还不切换
*/
