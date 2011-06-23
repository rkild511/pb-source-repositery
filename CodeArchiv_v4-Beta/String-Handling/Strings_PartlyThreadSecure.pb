; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5230&highlight=
; Author: Rings
; Date: 02. August 2004
; OS: Windows
; Demo: No

; Additional note: starting with PB v4 there is thread-secure string handling natively included.

; Lösung, um teilweise sichere Strings zu verwalten. 
; Dieser Tipp funktioniert nur unter Windows und beseitigt nicht das 
; generelle Problem threadsichere Strings, aber man kann das erreichen
; was man will, keine Abstürze mehr bei scheinbar gleicher Stringbearbeitung: 

; Ergänzung von Sylvia:
; Ergänzend sollte man noch dazu sagen, dass während der Code-Abarbeitung 
; zwischen EnterCriticalSection_() und LeaveCriticalSection_() ein 
; erneuter Thread-Aufruf NICHT möglich ist (beziehungsweise "geblockt" wird). 
; Soll heissen: Fasse dich kurz zwischen Enter..und Leave !

Global CSInitialized.l 
Global CS.CRITICAL_SECTION 

Global a.s 

Procedure testme(P) 
  If CSInitialized =0 
    InitializeCriticalSection_(CS) 
    CSInitialized = 1 
  EndIf 

  While T<20 
    EnterCriticalSection_(CS) 
    ;do everything now 
    a.s = Str(P) 
    Debug a.s 
    LeaveCriticalSection_(CS) 
    Delay(500) 
    T + 1 
  Wend 
EndProcedure 

For I=1 To 10 
  ThreadID = CreateThread(@testme(), I) 
Next I 

Max = 10000 
t0 = GetTickCount_() 
While T<Max 
  T = GetTickCount_()-t0 
  Delay(100) 
  a.s = "0" 
  Debug a.s 
Wend 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -