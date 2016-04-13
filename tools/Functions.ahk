global Arg

Functions:
    @("Help", "帮助信息")
    @("AhkRun", "使用 Ahk 的 Run 运行 `; cmd", true)
    @("CmdRun", "使用 cmd 运行 : cmd", true)
    @("ReloadFiles", "重新加载需要搜索的文件")
    @("Clip", "显示剪切板内容")
    @("Calc", "计算器")
    @("SearchInWeb", "在浏览器（百度）搜索剪切板或输入内容")
    @("EditConfig", "编辑配置文件")
    @("ClearClipboardFormat", "清除剪切板中文字的格式")
    @("RunClipboard", "使用 ahk 的 Run 运行剪切板内容")
    @("T2S", "繁体转简体剪切板内容")
    @("ShowIp", "显示 IP")
    @("Calendar", "用浏览器打开万年历")
    @("Dictionary", "词典，依赖 bash 和 ydcv")
    @("ArgTest", "参数测试：ArgTest arg1,arg2,...")
return

Help:
    helpText := ""
        . "键入内容 搜索，回车 执行（a），Alt + 字母 执行，F1 帮助，Esc 退出`n"
        . "Tab + 字母 也可执行字母对应功能`n"
        . "Tab + 大写字母 可将字母对应功能加入到配置文件，以便优先显示`n"
        . "Ctrl + r 重新创建待搜索文件列表`n"
        . "Ctrl + j 清除编辑框内容`n"
        . "Ctrl + d 用 TC 打开第一个文件所在目录`n"
        . "Ctrl + s 显示第一个文件的完整路径`n"
        . "Ctrl + x 删除第一个文件`n"
        . "F2 编辑配置文件`n`n"
        . "可直接输入网址，如 www.baidu.com`n"
        . "分号开头则使用 ahk 的 Run 运行命令，如 `;ping www.bidu.com`n"
        . "冒号开头则在 cmd 运行命令，如 :ping www.baidu.com`n"
        . "当搜索无结果时，回车 也等同 run 输入内容`n"
        . "当输入内容包含空格时，列表锁定，逗号作为命令参数的分隔符"

    DisplayResult(helpText)
return

CmdRun:
    RunWithCmd(Arg)
return

AhkRun:
    Run, %Arg%
return

Clip:
    DisplayResult("剪切板内容长度 " . StrLen(clipboard) . " ：`n`n" . clipboard)
return

EditConfig:
    Run, % g_ConfFile
return

ArgTest:
    Args := StrSplit(Arg, ",")
    result := "共有 " . Args.Length() . " 个参数。`n`n"

    for index, argument in Args
    {
        result .= "第 " . index - 1 " 个参数：" . argument . "`n"
    }

    DisplayResult(result)
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
    result := Eval(Arg)
    DisplayResult(result)
    clipboard := result
return
