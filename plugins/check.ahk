#NoTrayIcon
#NoEnv

FileEncoding, utf-8
ExtensionsAHK := A_ScriptDir "\plugins.ahk"

; 清理无用#include
Filedelete, %ExtensionsAHK%
FileAppend, %NewExtensions%, %ExtensionsAHK%

; 查询是否有新插件加入
Loop, %A_ScriptDir%\*.*, 2
    plugins .=  "#include *i `%A_ScriptDir`%\plugins\" A_LoopFileName "\" A_LoopFileName ".ahk`n"
FileAppend, %plugins%, %ExtensionsAHK%

; 保存修改时间
SaveTime := "/*`r`n[ExtensionsTime]`r`n"
Loop, %A_ScriptDir%\*.*, 2
{
    plugin :=  A_ScriptDir "\" A_LoopFileName "\" A_LoopFileName ".ahk"
    FileGetTime, ExtensionsTime, %plugin%, M
    SaveTime .= A_LoopFileName "=" ExtensionsTime "`r`n"
}
SaveTime .= "*/`r`n"
FileAppend, %SaveTime%, %ExtensionsAHK%
Exit
