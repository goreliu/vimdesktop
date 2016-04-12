; 该配置文件内容为 ahk 代码
; 增加标签后，在 UserCmd 和 return 之间添加
; @("标签名", "功能描述)

UserCmd:
    @("PasteToNotepad", "在记事本显示剪切板内容")
    @("ClearClipboardFormat", "清除剪切板中文字的格式")
    @("Dictionary", "词典，依赖 bash 和 ydcv")
    @("Calendar", "用浏览器打开万年历")
    @("T2S", "繁体转简体剪切板内容")
    @("ShowIp", "显示 IP")
return


PasteToNotepad:
    Run, notepad
    Send, ^v^{home}
return

ShowIp:
    DisplayText(A_IPAddress1
            . "`r`n" . A_IPAddress2
            . "`r`n" . A_IPAddress3
            . "`r`n" . A_IPAddress4)
return

Dictionary:
    word := StrSplit(g_CurrentInput, ",")[2]
    if (word == "")
    {
        word := clipboard
    }

    DisplayText(RunAndGetOutput("echo " . word . " | ydcv"))
return

Calendar:
    Run % "http://www.baidu.com/baidu?wd=%CD%F2%C4%EA%C0%FA"
return

T2S:
    Run, notepad
    clipboard := Kanji_t2s(clipboard)
    Send, ^v
return

ClearClipboardFormat:
    clipboard := clipboard
return
