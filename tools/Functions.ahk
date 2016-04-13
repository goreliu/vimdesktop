InternalFunction:
    @("ClearClipboardFormat", "清除剪切板中文字的格式")
    @("Calc", "计算器")
    @("SearchInWeb", "在浏览器（百度）搜索剪切板或输入内容")
    @("RunClipboard", "使用 ahk 的 Run 运行剪切板内容")
    @("T2S", "繁体转简体剪切板内容")
    @("ShowIp", "显示 IP")
    @("Calendar", "用浏览器打开万年历")
    @("Dictionary", "词典，依赖 bash 和 ydcv")
return

ShowIp:
    DisplayResult(A_IPAddress1
            . "`r`n" . A_IPAddress2
            . "`r`n" . A_IPAddress3
            . "`r`n" . A_IPAddress4)
return

Dictionary:
    word := Arg
    if (word == "")
    {
        word := clipboard
    }

    DisplayResult(RunAndGetOutput("echo " . word . " | ydcv"))
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

SearchInWeb:
    word := clipboard
    if (Arg != "")
    {
        word := Arg
    }

    Run, https://www.baidu.com/s?wd=%word%
return

RunClipboard:
    Run, %clipboard%
return

Calc:
    DisplayResult(Eval(Arg))
return
