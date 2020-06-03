WinMerge:
    ; 定义注释
    vim.comment("<WinMerge_NormalMode>", "进入normal模式")
    vim.comment("<WinMerge_InsertMode>", "进入insert模式")
    vim.comment("<WinMerge_NextDiff>", "下一处不同")
    vim.comment("<WinMerge_PrevDiff>", "上一处不同")
    vim.comment("<WinMerge_FirstDiff>", "第一处不同")
    vim.comment("<WinMerge_LastDiff>", "最后一处不同")
    vim.comment("<WinMerge_Search>", "打开搜索窗口")
    vim.comment("<WinMerge_CopyToLeft>", "复制到左侧")
    vim.comment("<WinMerge_CopyToRight>", "复制到右侧")
    vim.comment("<WinMerge_CopyToLeftAndGoOn>", "复制到左侧并继续")
    vim.comment("<WinMerge_CopyToRightAndGoOn>", "复制到右侧并继续")
    vim.comment("<WinMerge_CopyToLeftAll>", "全部复制到左侧")
    vim.comment("<WinMerge_CopyToRightAll>", "全部复制到右侧")

    vim.SetWin("WinMerge", "WinMergeWindowClassW")

    ; insert模式
    vim.mode("insert", "WinMerge")

    vim.map("<esc>", "<WinMerge_NormalMode>", "WinMerge")

    ; normal模式
    vim.mode("normal", "WinMerge")

    vim.map("i", "<WinMerge_InsertMode>", "WinMerge")

    vim.map("<esc>", "<Pass>", "WinMerge")
    
    vim.map("j", "<WinMerge_NextDiff>", "WinMerge")
    vim.map("k", "<WinMerge_PrevDiff>", "WinMerge")
    vim.map("gg", "<WinMerge_FirstDiff>", "WinMerge")
    vim.map("G", "<WinMerge_LastDiff>", "WinMerge")
    vim.map("/", "<WinMerge_Search>", "WinMerge")
    vim.map("h", "<WinMerge_CopyToLeft>", "WinMerge")
    vim.map("l", "<WinMerge_CopyToRight>", "WinMerge")
    vim.map("H", "<WinMerge_CopyToLeftAndGoOn>", "WinMerge")
    vim.map("L", "<WinMerge_CopyToRightAndGoOn>", "WinMerge")
    vim.map("<c-h>", "<WinMerge_CopyToLeftAll>", "WinMerge")
    vim.map("<c-l>", "<WinMerge_CopyToRightAll>", "WinMerge")
return

/*
; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
WinMerge_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS WinMerge
    ; msgbox, ctrl
    If RegExMatch(ctrl, "Afx")
        return true
    return false
}
*/

<WinMerge_NormalMode>:
    vim.mode("normal", "WinMerge")
return

<WinMerge_InsertMode>:
    vim.mode("insert", "WinMerge")
return

<WinMerge_NextDiff>:
    Send, !{down}
return

<WinMerge_PrevDiff>:
    Send, !{up}
return

<WinMerge_FirstDiff>:
    Send, !{home}
return

<WinMerge_LastDiff>:
    Send, !{end}
return

<WinMerge_Search>:
    Send, ^f
return

<WinMerge_CopyToLeft>:
    Send, !{left}
return

<WinMerge_CopyToRight>:
    Send, !{right}
return

<WinMerge_CopyToLeftAndGoOn>:
    Send, ^!{left}
return

<WinMerge_CopyToRightAndGoOn>:
    Send, ^!{right}
return

<WinMerge_CopyToLeftAll>:
    Send, !my
return

<WinMerge_CopyToRightAll>:
    Send, !ma
return
