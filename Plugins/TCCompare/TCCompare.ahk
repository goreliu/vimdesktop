; Total Commander 内置的文件比较工具

TCCompare:
    ; 定义注释
    vim.comment("<TCCompare_NormalMode>", "进入normal模式")
    vim.comment("<TCCompare_InsertMode>", "进入insert模式")
    vim.comment("<TCCompare_NextDiff>", "下一处不同")
    vim.comment("<TCCompare_PrevDiff>", "上一处不同")
    vim.comment("<TCCompare_Home>", "跳转到文件开头")
    vim.comment("<TCCompare_End>", "跳转到文件结尾")
    vim.comment("<TCCompare_Search>", "搜索内容")
    vim.comment("<TCCompare_CopyToLeft>", "复制到左侧")
    vim.comment("<TCCompare_CopyToRight>", "复制到右侧")
    vim.comment("<TCCompare_Editable>", "进入可编辑模式")
    vim.comment("<TCCompare_Compare>", "重新比较")
    vim.comment("<TCCompare_BinaryMode>", "进入二进制比较模式")
    vim.comment("<TCCompare_ChangeCodepage>", "修改所使用的文件编码")

    vim.SetWin("TCCompare", "TFileCompForm")

    ; insert模式
    vim.mode("insert", "TCCompare")

    vim.map("<esc>", "<TCCompare_NormalMode>", "TCCompare")

    ; normal模式
    vim.mode("normal", "TCCompare")

    vim.map("i", "<TCCompare_InsertMode>", "TCCompare")

    vim.map("<esc>", "<TCCompare_Editable>", "TCCompare")
    
    vim.map("j", "<TCCompare_NextDiff>", "TCCompare")
    vim.map("k", "<TCCompare_PrevDiff>", "TCCompare")
    vim.map("n", "<TCCompare_NextDiff>", "TCCompare")
    vim.map("p", "<TCCompare_PrevDiff>", "TCCompare")
    vim.map("gg", "<TCCompare_Home>", "TCCompare")
    vim.map("G", "<TCCompare_End>", "TCCompare")
    vim.map("/", "<TCCompare_Search>", "TCCompare")
    vim.map("h", "<TCCompare_CopyToLeft>", "TCCompare")
    vim.map("l", "<TCCompare_CopyToRight>", "TCCompare")
    vim.map("m", "<TCCompare_Editable>", "TCCompare")
    vim.map("c", "<TCCompare_Compare>", "TCCompare")
    vim.map("b", "<TCCompare_BinaryMode>", "TCCompare")
    vim.map("-", "<TCCompare_ChangeCodepage>", "TCCompare")
return


/*
; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
TCCompare_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS TCCompare
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit1")
        return true
    return false
}
*/

<TCCompare_NormalMode>:
    vim.mode("normal", "TCCompare")
return

<TCCompare_InsertMode>:
    vim.mode("insert", "TCCompare")
return

<TCCompare_NextDiff>:
    Send, !n
return

<TCCompare_PrevDiff>:
    Send, !p
return

<TCCompare_Home>:
    Send, ^{home}
return

<TCCompare_End>:
    Send, ^{end}
return

<TCCompare_Search>:
    Send, ^f
return

<TCCompare_CopyToLeft>:
    Send, !+<
return

<TCCompare_CopyToRight>:
    Send, !+>
return

<TCCompare_Editable>:
    Send, !m
return

<TCCompare_Compare>:
    Send, !c
return

<TCCompare_BinaryMode>:
    Send, !b
return

<TCCompare_ChangeCodepage>:
    Send, !-
return
