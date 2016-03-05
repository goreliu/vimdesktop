BeyondCompare4:
    ; 定义注释
    vim.comment("<BeyondCompare4_NormalMode>", "进入normal模式")
    vim.comment("<BeyondCompare4_InsertMode>", "进入insert模式")
    vim.comment("<BeyondCompare4_NextDiffSection>", "下一处不同")
    vim.comment("<BeyondCompare4_PrevDiffSection>", "上一处不同")
    vim.comment("<BeyondCompare4_NextDiff>", "下一行不同")
    vim.comment("<BeyondCompare4_PrevDiff>", "上一行不同")
    vim.comment("<BeyondCompare4_Home>", "跳转到文件开头")
    vim.comment("<BeyondCompare4_End>", "跳转到文件结尾")
    vim.comment("<BeyondCompare4_Search>", "搜索内容")
    vim.comment("<BeyondCompare4_CopyToLeft>", "复制到左侧")
    vim.comment("<BeyondCompare4_CopyToRight>", "复制到右侧")

    vim.SetWin("BeyondCompare4", "TViewForm")

    ; insert模式
    vim.mode("insert", "BeyondCompare4")

    vim.map("<esc>", "<BeyondCompare4_NormalMode>", "BeyondCompare4")

    ; normal模式
    vim.mode("normal", "BeyondCompare4")

    vim.map("i", "<BeyondCompare4_InsertMode>", "BeyondCompare4")

    vim.map("<esc>", "<Pass>", "BeyondCompare4")
    
    vim.map("j", "<BeyondCompare4_NextDiffSection>", "BeyondCompare4")
    vim.map("k", "<BeyondCompare4_PrevDiffSection>", "BeyondCompare4")
    vim.map("J", "<BeyondCompare4_NextDiff>", "BeyondCompare4")
    vim.map("K", "<BeyondCompare4_PrevDiff>", "BeyondCompare4")
    vim.map("gg", "<BeyondCompare4_Home>", "BeyondCompare4")
    vim.map("G", "<BeyondCompare4_End>", "BeyondCompare4")
    vim.map("/", "<BeyondCompare4_Search>", "BeyondCompare4")
    vim.map("h", "<BeyondCompare4_CopyToLeft>", "BeyondCompare4")
    vim.map("l", "<BeyondCompare4_CopyToRight>", "BeyondCompare4")
return

; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
BeyondCompare4_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS BeyondCompare4
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}

<BeyondCompare4_NormalMode>:
    vim.mode("normal", "BeyondCompare4")
return

<BeyondCompare4_InsertMode>:
    vim.mode("insert", "BeyondCompare4")
return

<BeyondCompare4_NextDiffSection>:
    Send, ^n
return

<BeyondCompare4_PrevDiffSection>:
    Send, ^p
return

<BeyondCompare4_NextDiff>:
    Send, ^+n
return

<BeyondCompare4_PrevDiff>:
    Send, ^+p
return

<BeyondCompare4_Home>:
    Send, ^{home}
return

<BeyondCompare4_End>:
    Send, ^{end}
return

<BeyondCompare4_Search>:
    Send, ^f
return

<BeyondCompare4_CopyToLeft>:
    Send, ^+r
return

<BeyondCompare4_CopyToRight>:
    Send, ^r
return
