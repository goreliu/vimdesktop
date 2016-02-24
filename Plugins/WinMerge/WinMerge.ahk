WinMerge:
    ; 定义注释
    vim.comment("<Normal_Mode_WinMergeWindowClassW>", "进入normal模式")
    vim.comment("<Insert_Mode_WinMergeWindowClassW>", "进入insert模式")
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

    ; insert模式
    vim.mode("insert", "WinMergeWindowClassW")

    vim.map("<esc>", "<Normal_Mode_WinMergeWindowClassW>", "WinMergeWindowClassW")

    ; normal模式
    vim.mode("normal", "WinMergeWindowClassW")

    vim.map("i", "<Insert_Mode_WinMergeWindowClassW>", "WinMergeWindowClassW")

    vim.map("<esc>", "<Pass>", "WinMergeWindowClassW")
    
    vim.map("j", "<WinMerge_NextDiff>", "WinMergeWindowClassW")
    vim.map("k", "<WinMerge_PrevDiff>", "WinMergeWindowClassW")
    vim.map("gg", "<WinMerge_FirstDiff>", "WinMergeWindowClassW")
    vim.map("G", "<WinMerge_LastDiff>", "WinMergeWindowClassW")
    vim.map("/", "<WinMerge_Search>", "WinMergeWindowClassW")
    vim.map("h", "<WinMerge_CopyToLeft>", "WinMergeWindowClassW")
    vim.map("l", "<WinMerge_CopyToRight>", "WinMergeWindowClassW")
    vim.map("H", "<WinMerge_CopyToLeftAndGoOn>", "WinMergeWindowClassW")
    vim.map("L", "<WinMerge_CopyToRightAndGoOn>", "WinMergeWindowClassW")
    vim.map("<ctrl>h", "<WinMerge_CopyToLeftAll>", "WinMergeWindowClassW")
    vim.map("<ctrl>l", "<WinMerge_CopyToRightAll>", "WinMergeWindowClassW")

return

/*
; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
WinMergeWindowClassW_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS WinMergeWindowClassW
    ; msgbox, ctrl
    If RegExMatch(ctrl, "Afx")
        return true
    return false
}
*/

<Normal_Mode_WinMergeWindowClassW>:
    vim.mode("normal", "WinMergeWindowClassW")
return

<Insert_Mode_WinMergeWindowClassW>:
    vim.mode("insert", "WinMergeWindowClassW")
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
