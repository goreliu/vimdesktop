#NoTrayIcon
Send_WM_COPYDATA("exitapp")
FileEncoding,utf-8
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
Loop,%A_ScriptDir%\Plugins\*.*,2
	plugins .=  "#include `%A_ScriptDir`%\plugins\" A_LoopFileName "\" A_LoopFileName ".ahk`n"
FileAppend,%plugins%,%ExtensionsAHK%
; 保存修改时间
SaveTime := "/*`r`n[ExtensionsTime]`r`n"
Loop,%A_ScriptDir%\plugins\*.*,2
{
	plugin :=  A_ScriptDir "\plugins\" A_LoopFileName "\" A_LoopFileName ".ahk"
	FileGetTime,ExtensionsTime,%plugin%,M
	SaveTime .= A_LoopFileName "=" ExtensionsTime "`r`n"
}
SaveTime .= "*/`r`n"
FileAppend,%SaveTime%,%ExtensionsAHK%
FileRead,Extensions,%ExtensionsAHK%
Run %A_AHKPath% "%A_ScriptDir%\vimd.ahk"
Exit
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle="vimd.ahk ahk_class AutoHotkey")
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) 
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%  
    DetectHiddenWindows %Prev_DetectHiddenWindows%  
    SetTitleMatchMode %Prev_TitleMatchMode% 
    return ErrorLevel  
}


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
