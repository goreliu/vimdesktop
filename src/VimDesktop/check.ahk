#NoTrayIcon
ExtensionsAHK := A_ScriptDir "\plugins\plugins.ahk"
/*If Not FileExist(ExtensionsAHK)
	FileAppend,,%ExtensionsAHK%
FileRead,Extensions,%ExtensionsAHK%
; 验证Extensions里Include的插件是否存在
Loop,Parse,Extensions,`n,`r
{
	If Not RegExMatch(A_LoopField,"i)^#include")
		Continue
	If FileExist(RegExReplace(A_LoopField,"i)^#include\s%A_ScriptDir%\\"))
	{
		Match := "\t" ToMatch(SubStr(A_LoopField,35)) "\t"
		If Not RegExMatch(ExtensionsNames,Match)
			NewExtensions .= A_LoopField "`r`n"
		ExtensionsNames .= A_Tab Substr(A_LoopField,35) A_Tab
	}
}
*/
; 清理无用#include
Filedelete,%ExtensionsAHK%
FileAppend,%NewExtensions%,%ExtensionsAHK%
; 查询是否有新插件加入
Loop,%A_ScriptDir%\Plugins\*.ahk
{
	If RegExMatch(A_LoopFileName,"i)^plugins\.ahk$")
		Continue
	Else
	{
		Match := "\t" ToMatch(A_LoopFileName) "\t"
		If Not RegExMatch(ExtensionsNames,Match)
			FileAppend,#include `%A_ScriptDir`%\plugins\%A_LoopFileName%`n , %ExtensionsAHK%
	}
}
; 保存修改时间
SaveTime := "/*`r`n[ExtensionsTime]`r`n"
Loop,%A_ScriptDir%\plugins\*.ahk
{
	If RegExMatch(A_LoopFileName,"i)^plugins.ahk$")
		Continue
	FileGetTime,ExtensionsTime,%A_LoopFileFullPath%,M
	SaveTime .= RegExReplace(A_LoopFileName,"i)\.ahk$") "=" ExtensionsTime "`r`n"
}
SaveTime .= "*/`r`n"
FileAppend,%SaveTime%,%ExtensionsAHK%
FileRead,Extensions,%ExtensionsAHK%
Run %A_AHKPath% "%A_ScriptDir%\vimd.ahk"
Exit



ToMatch(str){
    str := RegExReplace(str,"\+|\?|\.|\*|\{|\}|\(|\)|\||\^|\$|\[|\]|\\","\$0")
    Return RegExReplace(str,"\s","\s")
}
; ToReplace(str) {{{2
;
ToReplace(str){
    If RegExMatch(str,"\$")
        return  Regexreplace(str,"\$","$$$$")
    Else
        Return str
}
