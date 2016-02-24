; Total Commander 内置的文件比较工具

TCCompare:
    ; insert模式
    vim.mode("insert", "TFileCompForm")

    vim.map("<esc>", "<Normal_Mode_TFileCompForm>", "TFileCompForm")

    ; normal模式
    vim.mode("normal", "TFileCompForm")

    vim.map("i", "<Insert_Mode_TFileCompForm>", "TFileCompForm")

    vim.map("<esc>", "<TCCompare_Editable>", "TFileCompForm")
    
    vim.map("j", "<TCCompare_NextDiff>", "TFileCompForm")
    vim.map("k", "<TCCompare_PrevDiff>", "TFileCompForm")
    vim.map("n", "<TCCompare_NextDiff>", "TFileCompForm")
    vim.map("p", "<TCCompare_PrevDiff>", "TFileCompForm")
    vim.map("gg", "<TCCompare_Home>", "TFileCompForm")
    vim.map("G", "<TCCompare_End>", "TFileCompForm")
    vim.map("/", "<TCCompare_Search>", "TFileCompForm")
    vim.map("h", "<TCCompare_CopyToLeft>", "TFileCompForm")
    vim.map("l", "<TCCompare_CopyToRight>", "TFileCompForm")
    vim.map("m", "<TCCompare_Editable>", "TFileCompForm")
    vim.map("c", "<TCCompare_Compare>", "TFileCompForm")
    vim.map("b", "<TCCompare_BinaryMode>", "TFileCompForm")
    vim.map("-", "<TCCompare_ChangeCodepage>", "TFileCompForm")

    ; 定义注释
    vim.comment("<Normal_Mode_TFileCompForm>", "进入normal模式")
    vim.comment("<Insert_Mode_TFileCompForm>", "进入insert模式")
    vim.comment("<TCCompare_NextDiff>", "下一处不同")
    vim.comment("<TCCompare_PrevDiff>", "上一处不同")
    vim.comment("<TCCompare_Home>", "跳转到文件开头")
    vim.comment("<TCCompare_End>", "跳转到文件结尾")
    vim.comment("<TCCompare_CopyToLeft>", "复制到左侧")
    vim.comment("<TCCompare_CopyToRight>", "复制到右侧")
    vim.comment("<TCCompare_Editable>", "进入可编辑模式")
    vim.comment("<TCCompare_Compare>", "重新比较")
    vim.comment("<TCCompare_BinaryMode>", "进入二进制比较模式")
    vim.comment("<TCCompare_ChangeCodepage>", "修改所使用的文件编码")
return


/*
; 对符合条件的控件使用insert模式，而不是normal模式
; 此段代码可以直接复制，但请修改AHK_CLASS的值和RegExMatch的第二个参数
TFileCompForm_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS TFileCompForm
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit1")
        return true
    return false
}
*/

<Normal_Mode_TFileCompForm>:
    vim.mode("normal", "TFileCompForm")
return

<Insert_Mode_TFileCompForm>:
    vim.mode("insert", "TFileCompForm")
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
