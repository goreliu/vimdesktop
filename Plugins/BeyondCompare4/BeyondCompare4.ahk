BeyondCompare4:
    ; 定义注释
    vim.comment("<Normal_Mode_TViewForm>", "进入normal模式")
    vim.comment("<Insert_Mode_TViewForm>", "进入insert模式")
    vim.comment("<BeyondCompare4_NextDiffSection>", "下一处不同")
    vim.comment("<BeyondCompare4_PrevDiffSection>", "上一处不同")
    vim.comment("<BeyondCompare4_NextDiff>", "下一行不同")
    vim.comment("<BeyondCompare4_PrevDiff>", "上一行不同")
    vim.comment("<BeyondCompare4_Home>", "跳转到文件开头")
    vim.comment("<BeyondCompare4_End>", "跳转到文件结尾")
    vim.comment("<BeyondCompare4_Search>", "搜索内容")
    vim.comment("<BeyondCompare4_CopyToLeft>", "复制到左侧")
    vim.comment("<BeyondCompare4_CopyToRight>", "复制到右侧")

    ; insert模式
    vim.mode("insert", "TViewForm")

    vim.map("<esc>", "<Normal_Mode_TViewForm>", "TViewForm")

    ; normal模式
    vim.mode("normal", "TViewForm")

    vim.map("i", "<Insert_Mode_TViewForm>", "TViewForm")

    vim.map("<esc>", "<Pass>", "TViewForm")
    
    vim.map("j", "<BeyondCompare4_NextDiffSection>", "TViewForm")
    vim.map("k", "<BeyondCompare4_PrevDiffSection>", "TViewForm")
    vim.map("J", "<BeyondCompare4_NextDiff>", "TViewForm")
    vim.map("K", "<BeyondCompare4_PrevDiff>", "TViewForm")
    vim.map("gg", "<BeyondCompare4_Home>", "TViewForm")
    vim.map("G", "<BeyondCompare4_End>", "TViewForm")
    vim.map("/", "<BeyondCompare4_Search>", "TViewForm")
    vim.map("h", "<BeyondCompare4_CopyToLeft>", "TViewForm")
    vim.map("l", "<BeyondCompare4_CopyToRight>", "TViewForm")
return

; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
TViewForm_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS TViewForm
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}

<Normal_Mode_TViewForm>:
    vim.mode("normal", "TViewForm")
return

<Insert_Mode_TViewForm>:
    vim.mode("insert", "TViewForm")
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
