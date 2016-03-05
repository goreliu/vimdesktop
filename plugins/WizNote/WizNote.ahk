; ref http://git.oschina.net/linxinhong/VimDesktop/raw/master/Plugins/WizNote
;     /WizNote.ahk?dir=0&filepath=Plugins%2FWizNote%2FWizNote.ahk_class
;     &oid=60a9a6ecb68a3ae7ef6c5b5af540e84bc8139fc1
;     &sha=a78a6e18504e5bcecc5926e0176ed89bd661307a

WizNote:
    ; 定义注释
    vim.comment("<WizNote_NormalMode>", "进入normal模式")
    vim.comment("<WizNote_InsertMode>", "进入insert模式")
    vim.comment("<WizNote_NewNote>", "新建笔记")
    vim.comment("<WizNote_NewDesktopNote>", "新建桌面便签")
    vim.comment("<WizNote_Delete>", "删除笔记")
    vim.comment("<WizNote_CopyOrMove>", "复制或移动笔记")
    vim.comment("<WizNote_Task>", "打开任务")
    vim.comment("<WizNote_FullScreen>", "全屏")
    vim.comment("<WizNote_Edit>", "编辑笔记")
    vim.comment("<WizNote_CloseTab>", "关闭当前标签")
    vim.comment("<WizNote_NextNote>", "下一个笔记")
    vim.comment("<WizNote_PrevNote>", "上一个笔记")
    vim.comment("<WizNote_List>", "定位到左侧目录")

    vim.SetWin("WizNote", "WizNoteMainFrame")

    ; insert模式
    vim.mode("insert", "WizNote")

    vim.map("<esc>", "<WizNote_NormalMode>", "WizNote")

    ; normal模式
    vim.mode("normal", "WizNote")

    vim.map("i", "<WizNote_InsertMode>", "WizNote")
    
    vim.map("j", "<down>", "WizNote")
    vim.map("k", "<up>", "WizNote")
    vim.map("J", "<WizNote_NextNote>", "WizNote")
    vim.map("K", "<WizNote_PrevNote>", "WizNote")

    vim.map("h", "<left>", "WizNote")
    vim.map("l", "<right>", "WizNote")
    vim.map("gg", "<home>", "WizNote")
    vim.map("G", "<end>", "WizNote")

    vim.map("a", "<WizNote_NewNote>", "WizNote")
    vim.map("x", "<WizNote_Delete>", "WizNote")
    vim.map("e", "<WizNote_Edit>", "WizNote")
    vim.map("u", "<WizNote_CloseTab>", "WizNote")
    vim.map("t", "<WizNote_List>", "WizNote")

    vim.BeforeActionDo("WizNote_ForceInsertMode", "WizNote")

return

; 对指定控件使用insert模式
WizNote_ForceInsertMode()
{
    ControlGetFocus, ctrl, AHK_CLASS WizNote
    ;MsgBox ctrl
    if RegExMatch(ctrl, "WebViewHost")
        return true
    return false
}

<WizNote_NormalMode>:
    vim.mode("normal", "WizNote")
return

<WizNote_InsertMode>:
    vim.mode("insert", "WizNote")
return

<WizNote_NewNote>:
    Send, ^n
return

<WizNote_NewDesktopNote>:
    Send, ^!d
return

<WizNote_Delete>:
    Send, {Del}
return

<WizNote_Task>:
    Send, ^!y
return

<WizNote_CopyOrMove>:
    Send, ^m
return

<WizNote_FullScreen>:
    Send, {F11}
return

<WizNote_Edit>:
    Send, ^e
return

<WizNote_CloseTab>:
    Send, ^w
return

<WizNote_List>:
    ControlFocus, WizListCtrl1
return

<WizNote_NextNote>:
    Gosub, <WizNote_List>
    Send, {down}
return

<WizNote_PrevNote>:
    Gosub, <WizNote_List>
    Send, {up}
return

/*
原始快捷键列表:

内容剪辑
Win+PrintScreen 捕捉屏幕到为知
Win+S 保存选中内容
Ctrl+Alt+V 保存剪贴板中内容

全局快捷键
Ctrl+Alt+N 快速新建笔记
Ctrl+Alt+M 打开为知笔记

笔记编辑
Ctrl+E 编辑/保存文档
Ctrl+W 关闭当前标签页
Ctrl+T 笔记选中部分作为标题
Ctrl+G 笔记选中部分作为标签
Alt+E 给当前笔记添加标签
Alt+F 给当前笔记添加附件
Alt+Q 显示当前笔记信息
Ctrl+O 插入清单
Ctrl+1/2... 将设为样式中的标题1/2...
Ctrl+Shift+O 插入或设为数字列表
Ctrl+Shift+U 插入或设为无序列表
ctrl + alt + ] 增大选中文字字体
ctrl + alt + [ 减小选中文字字体
Ctrl+B 笔记选中部分加粗
Ctrl+I 笔记选中部分变斜体
Ctrl+U 笔记选中部分加下划线
Ctrl+L 插入
Ctrl+; 插入当前系统日期或时间
Ctrl+Shift+; 设置插入的日期时间格式

为知界面
Ctrl+N 新建笔记
Ctrl+F 新建子文件夹
Esc 显示/隐藏左侧目录栏
F11 进入或退出全屏模式
Ctrl+Shift+TAB 切换标签页
F7 打开上一条笔记
F8 打开下一条笔记
F9 同步笔记
Ctrl+鼠标滚轮 放大或缩小笔记视图
Alt+D 设置键盘焦点到搜索框

桌面便笺和任务列表
Ctrl+Alt+D 新建桌面便笺
Ctrl+Alt+Y 打开默认任务列表
Ctrl+F3 打开所有任务列表

更多设置
若想更改部分快捷键，可在菜单——选项——热键、网页剪辑器选项卡中进行更多设置
*/
