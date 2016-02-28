;=====================================================================o
;                      Esc Enhancement                                |
;---------------------------------------------------------------------o
;Description:                                                         |
;    This Script turns Esc into an function Key just like Ctrl and    |
; Alt by combining Esc with almost all other keys in the keyboard.    |
;                                                                     |
; See also:                                                           |
;    github.com/Vonng/Configuration/blob/master/win_ahk/CapsLock.ahk  |
;                                                                     |
;Summary:                                                             |
;o----------------------o---------------------------------------------o
;|Esc + `             | {CapsLock}CapsLock Switcher as a Substituent  |
;|Esc + {BackSpace}   | Exit                                          |
;|Esc + hjklwb        | Vim-Style Cursor Mover                        |
;|Esc + ioup          | Convient Home/End PageUp/PageDn               |
;|Esc + .             | Delete                                        |
;|Esc + zxcvay        | Windows-Style Editor                          |
;|Esc + Direction     | Mouse Move                                    |
;|Esc + Enter         | Mouse Click                                   |
;|Esc + 1~6           | Media Controller                              |
;|Esc + nm,sqd        | Windows & Tags Control                        |
;|Esc + ;'            | Convient Key Mapping                          |
;|Unused              | e f g r t 7-0 - = / [ ] \                     |
;-----------------------o---------------------------------------------o
;|Use it whatever and wherever you like. Hope it help                 |
;=====================================================================o

;=====================================================================o
#NoTrayIcon                                                          ;|
#SingleInstance force                                                ;|
SetKeyDelay, -1                                                      ;|
                                                                     ;|
$Esc:: Send, {ESC}                                                   ;|
$^+Esc:: Send, ^+{Esc}                                               ;|
$#Esc:: ExitApp                                                      ;|
;=====================================================================o

;=====================================================================o
;                       CapsLock Switcher:                           ;|
;---------------------------------o-----------------------------------o
;                      Esc + ` | {CapsLock}                          ;|
;---------------------------------o-----------------------------------o
Esc & `::                                                            ;|
GetKeyState, CapsLockState, CapsLock, T                              ;|
if CapsLockState = D                                                 ;|
    SetCapsLockState, AlwaysOff                                      ;|
else                                                                 ;|
    SetCapsLockState, AlwaysOn                                       ;|
KeyWait, ``                                                          ;|
return                                                               ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                     Esc Direction Navigator                        ;|
;-----------------------------------o---------------------------------o
;                        Esc + h |  Left                             ;|
;                        Esc + j |  Down                             ;|
;                        Esc + k |  Up                               ;|
;                        Esc + l |  Right                            ;|
;-----------------------------------o---------------------------------o
Esc & h::Send, {Left}                                                ;|
Esc & j::Send, {Down}                                                ;|
Esc & k::Send, {Up}                                                  ;|
Esc & l::Send, {Right}                                               ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                       Esc Home/End Navigator                       ;|
;-----------------------------------o---------------------------------o
;                         Esc + i |  Home                            ;|
;                         Esc + o |  End                             ;|
;                      Ctrl, Alt Compatible                          ;|
;-----------------------------------o---------------------------------o
Esc & i::                                                            ;|
if GetKeyState("control") = 0                                        ;|
{                                                                    ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, {Home}                                                 ;|
    else                                                             ;|
        Send, +{Home}                                                ;|
    return                                                           ;|
}                                                                    ;|
else {                                                               ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, ^{Home}                                                ;|
    else                                                             ;|
        Send, +^{Home}                                               ;|
    return                                                           ;|
}                                                                    ;|
return                                                               ;|
;-----------------------------------o                                ;|
Esc & o::                                                            ;|
if GetKeyState("control") = 0                                        ;|
{                                                                    ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, {End}                                                  ;|
    else                                                             ;|
        Send, +{End}                                                 ;|
    return                                                           ;|
}                                                                    ;|
else {                                                               ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, ^{End}                                                 ;|
    else                                                             ;|
        Send, +^{End}                                                ;|
    return                                                           ;|
}                                                                    ;|
return                                                               ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                        Esc Page Navigator                          ;|
;-----------------------------------o---------------------------------o
;                        Esc + u |  PageUp                           ;|
;                        Esc + p |  PageDown                         ;|
;                        Ctrl, Alt Compatible                        ;|
;-----------------------------------o---------------------------------o
Esc & u::                                                            ;|
if GetKeyState("control") = 0                                        ;|
{                                                                    ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, {PgUp}                                                 ;|
    else                                                             ;|
        Send, +{PgUp}                                                ;|
    return                                                           ;|
}                                                                    ;|
else {                                                               ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, ^{PgUp}                                                ;|
    else                                                             ;|
        Send, +^{PgUp}                                               ;|
    return                                                           ;|
}                                                                    ;|
return                                                               ;|
;-----------------------------------o                                ;|
Esc & p::                                                            ;|
if GetKeyState("control") = 0                                        ;|
{                                                                    ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, {PgDn}                                                 ;|
    else                                                             ;|
        Send, +{PgDn}                                                ;|
    return                                                           ;|
}                                                                    ;|
else {                                                               ;|
    if GetKeyState("alt") = 0                                        ;|
        Send, ^{PgDn}                                                ;|
    else                                                             ;|
        Send, +^{PgDn}                                               ;|
    return                                                           ;|
}                                                                    ;|
return                                                               ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                        Esc Mouse Controller                        ;|
;-----------------------------------o---------------------------------o
;                       Esc + Up   |  Mouse Up                       ;|
;                       Esc + Down |  Mouse Down                     ;|
;                       Esc + Left |  Mouse Left                     ;|
;                      Esc + Right |  Mouse Right                    ;|
;        Esc + Enter(Push Release) |  Mouse Left Push(Release)       ;|
;-----------------------------------o---------------------------------o
Esc & Up::    MouseMove, 0, -10, 0, R                                ;|
Esc & Down::  MouseMove, 0, 10, 0, R                                 ;|
Esc & Left::  MouseMove, -10, 0, 0, R                                ;|
Esc & Right:: MouseMove, 10, 0, 0, R                                 ;|
;-----------------------------------o                                ;|
Esc & Enter::                                                        ;|
SendEvent {Blind}{LButton down}                                      ;|
KeyWait Enter                                                        ;|
SendEvent {Blind}{LButton up}                                        ;|
return                                                               ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                           Esc Deletor                              ;|
;-----------------------------------o---------------------------------o
;                     Esc + .  |  Ctrl + BackSpace                   ;|
;-----------------------------------o---------------------------------o
Esc & .:: Send, {Del}                                                ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                           Esc Editor                               ;|
;-----------------------------------o---------------------------------o
;                     Esc + z  |  Ctrl + z (Cancel)                  ;|
;                     Esc + x  |  Ctrl + x (Cut)                     ;|
;                     Esc + c  |  Ctrl + c (Copy)                    ;|
;                     Esc + v  |  Ctrl + z (Paste)                   ;|
;                     Esc + a  |  Ctrl + a (Select All)              ;|
;                     Esc + y  |  Ctrl + z (Yeild)                   ;|
;                     Esc + w  |  Ctrl + Right(Move as [vim: w])     ;|
;                     Esc + b  |  Ctrl + Left (Move as [vim: b])     ;|
;-----------------------------------o---------------------------------o
Esc & z:: Send, ^z                                                   ;|
Esc & x:: Send, ^x                                                   ;|
Esc & c:: Send, ^{Insert}                                            ;|
Esc & v:: Send, +{Insert}                                            ;|
Esc & a:: Send, ^a                                                   ;|
Esc & y:: Send, ^y                                                   ;|
Esc & w:: Send, ^{Right}                                             ;|
Esc & b:: Send, ^{Left}                                              ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                          Esc Media Controller                      ;|
;-----------------------------------o---------------------------------o
;                       Esc + 1  |  Media_Play_Pause                 ;|
;                       Esc + 2  |  Media_Next                       ;|
;                       Esc + 3  |  Media_Prev                       ;|
;                       Esc + 4  |  Volume_Down                      ;|
;                       Esc + 5  |  Volume_Up                        ;|
;                       Esc + 6  |  Volume_Mute                      ;|
;-----------------------------------o---------------------------------o
Esc & 1:: Send, {Media_Play_Pause}                                   ;|
Esc & 2:: Send, {Media_Next}                                         ;|
Esc & 3:: Send, {Media_Prev}                                         ;|
Esc & 4:: Send, {Volume_Down}                                        ;|
Esc & 5:: Send, {Volume_Up}                                          ;|
Esc & 6:: Send, {Volume_Mute}                                        ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                         Esc Window Controller                      ;|
;-----------------------------------o---------------------------------o
;                    Esc + m  |  Maximize Window                     ;|
;                    Esc + n  |  Restore Window                      ;|
;                    Esc + ,  |  Minmize Window                      ;|
;                    Esc + q  |  Alt + F4   (Close Windows)          ;|
;                    Esc + s  |  Ctrl + Tab (Swith Tag)              ;|
;                    Esc + g  |  AppsKey    (Menu Key)               ;|
;-----------------------------------o---------------------------------o
Esc & m:: WinMaximize, A                                             ;|
Esc & n:: WinRestore, A                                              ;|
Esc & ,:: WinMinimize, A                                             ;|
Esc & q:: Send, !{F4}                                                ;|
Esc & s:: Send, ^{Tab}                                               ;|
Esc & d:: Send, {AppsKey}                                            ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                        Esc Char Mapping                            ;|
;-----------------------------------o---------------------------------o
;                     Esc + ;  |  Enter                              ;|
;                     Esc + '  |  =                                  ;|
;-----------------------------------o---------------------------------o
Esc & `;:: Send, {Enter}                                             ;|
Esc & ':: Send, =                                                    ;|
;---------------------------------------------------------------------o
