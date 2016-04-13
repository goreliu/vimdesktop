Kanji_s2t(text){
    Return Kanji(text, 1)
}

Kanji_t2s(text){
    Return Kanji(text)
}

; https://autohotkey.com/boards/viewtopic.php?t=9133
Kanji(s,r:=""){ ;  r= 1-简繁 ""-繁简
    static f:=__Kanji()
    n:=r?f.1:f.2
    Loop,Parse,s
        b.=n[A_Loopfield]?n[A_Loopfield]:A_Loopfield
    Return b
}
 
__Kanji(){
    FileRead,s,% A_ScriptDir "\lib\Kanji\Kanji.txt"
    f:=[], h:=[],s:=Trim(s)
    Loop,Parse,s,% A_Space
        f[a:=SubStr(A_Loopfield,1,1)]:=b:=SubStr(A_Loopfield,2),h[b]:=a
    Return [f,h]
}
