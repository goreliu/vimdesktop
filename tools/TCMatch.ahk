TCMatchOn(aDllPath, aOff:=False)
{
    Static hModule := 0
    If !hModule && FileExist(aDllPath)
        hModule := DllCall("LoadLibrary", "Str", aDllPath, "Ptr")  
    If aOff
        hModule := 0
    Return hModule
}

TCMatchOff()
{
    DllCall("FreeLibrary", "Ptr", hModule)
}

TCMatch(aString, aMatch)
{
    Return DllCall("TCMatch\MatchFileW",  "WStr", aMatch, "WStr", aString)
}
