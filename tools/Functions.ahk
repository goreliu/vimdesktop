global Arg

Functions:
    @("Help", "帮助信息")
    @("AhkRun", "使用 Ahk 的 Run 运行 `; cmd", true)
    @("CmdRun", "使用 cmd 运行 : cmd", true)
    @("WinRRun", "使用 win + r 运行", true)
    @("RunAndDisplay", "使用 cmd 运行，并显示结果", true)
    @("ReloadFiles", "重新加载需要搜索的文件")
    @("Clip", "显示剪切板内容")
    @("Calc", "计算器")
    @("SearchInWeb", "在浏览器（百度）搜索剪切板或输入内容", true)
    @("Dictionary", "有道在线词典翻译", true)
    @("EditConfig", "编辑配置文件")
    @("ClearClipboardFormat", "清除剪切板中文字的格式")
    @("RunClipboard", "使用 ahk 的 Run 运行剪切板内容")
    @("LogOff", "注销 登出")
    @("RestartMachine", "重启")
    @("ShutdownMachine", "关机")
    @("SuspendMachine", "挂起 睡眠 待机")
    @("HibernateMachine", "休眠")
    @("TurnMonitorOff", "关闭显示器")
    @("T2S", "将剪切板中的内容繁体转简体")
    @("ShowIp", "显示 IP")
    @("Calendar", "用浏览器打开万年历")
    @("ArgTest", "参数测试：ArgTest arg1,arg2,...")
return

Help:
    helpText := ""
        . "键入内容 搜索，回车 执行（a），Alt + 字母 执行，F1 帮助，Esc 退出`n"
        . "按 Tab 后 字母 也可执行字母对应功能`n"
        . "按 Tab 后 Shift + 字母或数字 可增加对应功能的权重`n"
        . "Ctrl + b 可减少列表第一项功能的权重`n"
        . "Ctrl + r 重新创建待搜索文件列表`n"
        . "Ctrl + h 显示历史记录`n"
        . "Ctrl + j 清除编辑框内容`n"
        . "Ctrl + d 用 TC 打开第一个文件所在目录`n"
        . "Ctrl + s 显示并复制第一个文件的完整路径`n"
        . "Ctrl + x 删除第一个文件`n"
        . "F2 编辑配置文件`n`n"
        . "可直接输入网址，如 www.baidu.com`n"
        . "分号开头则使用 ahk 的 Run 运行命令，如 `;ping www.bidu.com`n"
        . "冒号开头则在 cmd 运行命令，如 :ping www.baidu.com`n"
        . "当搜索无结果时，回车 也等同 run 输入内容`n"
        . "当输入内容包含空格时，列表锁定，逗号作为命令参数的分隔符`n`n`n"
        . "内置功能列表：`n`n"
        . GetAllFunctions()

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

    url := "http://fanyi.youdao.com/openapi.do?keyfrom=YouDaoCV&key=659600698&"
            . "type=data&doctype=json&version=1.2&q=" UrlEncode(word)
    jsonText := StrReplace(UrlDownloadToString(url), "-phonetic", "_phonetic")

    parsed := JSON.Load(jsonText)
	result := parsed.query

	if (parsed.basic.uk_phonetic != "" && parsed.basic.us_phonetic != "")
	{
		result .= " UK: [" parsed.basic.uk_phonetic "], US: [" parsed.basic.us_phonetic "]`n"
	}
	else if (parsed.basic.phonetic != "")
	{
		result .= " [" parsed.basic.phonetic "]`n"
	}
    else
    {
        result .= "`n"
    }

	if (parsed.basic.explains.Length() > 0)
	{
		result .= "`n"
		for index, explain in parsed.basic.explains
		{
			result .= "    * " explain "`n"
		}
	}

	if (parsed.web.Length() > 0)
	{
		result .= "`n----`n"

		for i, element in parsed.web
		{
			result .= "`n    * " element.key
			for j, value in element.value
			{
				if (j == 1)
				{
					result .= "`n       "
				}
				else
				{
					result .= "`; "
				}

				result .= value
			}
		}
	}

    DisplayResult(result)
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

RunAndDisplay:
    DisplayResult(RunAndGetOutput(Arg))
return

WinRRun:
    Send, #r
    sleep, 100
    Send, %Arg%
    Send, {enter}
return

LogOff:
    Shutdown, 0
return

ShutdownMachine:
    Shutdown, 1
return

RestartMachine:
    Shutdown, 2
return

HibernateMachine:
    ; 参数 #1: 使用 1 代替 0 来进行休眠而不是挂起。
	; 参数 #2: 使用 1 代替 0 来立即挂起而不询问每个应用程序以获得许可。
	; 参数 #3: 使用 1 而不是 0 来禁止所有的唤醒事件。
    DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
return

SuspendMachine:
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return

TurnMonitorOff:
	; 关闭显示器:
	SendMessage, 0x112, 0xF170, 2,, Program Manager
	; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
	; 对上面命令的注释: 使用 -1 代替 2 来打开显示器.
	; 使用 1 代替 2 来激活显示器的节能模式.
return
