; 我自己使用的文件，放在这里为了避免丢失，会从发布包删除

~LWin Up::
    return

~LAlt Up::
    return

<MY_OpenChrome>:
    if (!WinExist("ahk_class Chrome_WidgetWin_1"))
    {
        Run, c:\Users\goreliu\AppData\Local\CentBrowser\Application\chrome.exe
    }
return
