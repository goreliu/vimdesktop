;==============主代码
SGBrowser:
vim.mode("insert","SE_AxControl")
vim.map("<esc>","<Normal_Mode_SE_AxControl>","SE_AxControl")

vim.mode("normal","SE_AxControl")
vim.map("i","<Insert_Mode_SE_AxControl>","SE_AxControl")
;vim.map("<esc>","<Normal_Mode_SE_AxControl>","SE_AxControl")
vim.map("gt","<SG_NextTab>","SE_AxControl")
vim.map("gT","<SG_PrevTab>","SE_AxControl")

vim.comment("<SG_NextTab>","下一个标签")
vim.comment("<SG_PrevTab>","前一个标签")
return

;================检查模式,用于检查焦点Edit1这个控件内激活insert模式,而不用normal模式

SE_AxControl_CheckMode()
{
    ControlGetFocus,ctrl,AHK_CLASS SE_AxControl
    If RegExMatch(ctrl,"Edit1")
        Return True
    return False
}


<Normal_Mode_SE_AxControl>:
    Send,{Esc}
    vim.Mode("normal","SE_AxControl")
return

<Insert_Mode_SE_AxControl>:
    vim.Mode("insert","SE_AxControl")
return

;============功能代码
<SG_NextTab>:
    SG_Send("^{Tab}")
return

<SG_PrevTab>:
    SG_send("^+{Tab}")
return

SG_Send(Keys){
	Delay := A_KeyDelay
	Setkeydelay,10
	Send,%Keys%
	Setkeydelay,%Delay%
}
