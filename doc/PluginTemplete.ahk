; 插件名和目录名一致，插件要放到 plugins/PluginName/PluginName.ahk 位置。
; 放入插件后，重新运行 vimd 会自动启用插件。
; 标签名请添加 PluginName_ 前缀，避免和其他插件冲突。

; 该标签名需要和插件名一致
PluginName:
    ; 定义注释（可选）
    vim.SetAction("<PluginName_NormalMode>", "进入normal模式")
    vim.SetAction("<PluginName_InsertMode>", "进入insert模式")
    vim.SetAction("<PluginName_Function1>", "功能1")
    vim.SetAction("<PluginName_Function2>", "功能2")

    ; 请务必调用 vim.SetWin 并保证 PluginName 和文件名一致，以避免名称混乱影响使用
    vim.SetWin("PluginName", "ahk_class名")
    ; 或：
    vim.SetWin("PluginName", "ahk_class名", "PluginName.exe")
    ; 如果 class 和 exe 同时填写，以 exe 为准

    ; insert模式（如果无需 insert 模式，可去掉）
    vim.SetMode("insert", "PluginName")

    vim.Map("<esc>", "<PluginName_NormalMode>", "PluginName")

    ; normal模式（必需）
    vim.SetMode("normal", "PluginName")

    vim.Map("i", "<PluginName_InsertMode>", "PluginName")

    vim.Map("a", "<PluginName_Function1>", "PluginName")
    vim.Map("b", "<PluginName_Function2>", "PluginName")

    ; 可选
    vim.BeforeActionDo("PluginName_BeforeActionDo", "PluginName")
return

; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
PluginName_BeforeActionDo()
{
    ControlGetFocus, ctrl, AHK_CLASS PluginName
    ; MsgBox % ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}

<PluginName_NormalMode>:
    vim.SetMode("normal", "PluginName")
return

<PluginName_InsertMode>:
    vim.SetMode("insert", "PluginName")
return

<PluginName_Function1>:
    Send, ^n
return

<PluginName_Function2>:
    Send, ^p
return
