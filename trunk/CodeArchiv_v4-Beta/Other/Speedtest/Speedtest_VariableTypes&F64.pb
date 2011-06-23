; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2901&start=50
; Author: Friedhelm
; Date: 29. November 2003
; OS: Windows
; Demo: No

;Debugger ausschalten!!!!!! 

#z = 30000000 
Delay(100) 
Timer1=GetTickCount_() 
For i=0 To #z 
  b.b+1 
Next 
Timer1=GetTickCount_()-Timer1 

Delay(100) 

Timer2=GetTickCount_() 
For i=0 To #z 
  w.w+1 
Next 
Timer2=GetTickCount_()-Timer2 

Delay(100) 

Timer3=GetTickCount_() 
For i=0 To #z 
  l.l+1 
Next 
Timer3=GetTickCount_()-Timer3 

Delay(100) 

Timer4=GetTickCount_() 
For i=0 To #z 
  f.f+1 
Next 
Timer4=GetTickCount_()-Timer4 

Delay(100) 

Eingabe.f= 1 
ergeb.f 

Timer5=GetTickCount_() 
!FINIT 
!FLDZ 
For i=0 To #z 
   !FLD dword [v_Eingabe] ;FPU intern 
   !FADDP st1,st 
Next 
!FST dword [v_ergeb] 
Timer5=GetTickCount_()-Timer5 

Delay(100) 

Timer6=GetTickCount_() 
!FINIT 
!FLDZ 
For i=0 To #z 
  !FLD dword [v_Eingabe] ;Lade eingebe 
  !FADDP st1,st 
Next 
!FST dword [v_ergeb] 
Timer6=GetTickCount_()-Timer6 




a$="   Byte:     "+Str(Timer1)+"ms" 
a$+Chr(13)+Chr(10)+"   Word:    "+Str(Timer2)+"ms" 
a$+Chr(13)+Chr(10)+"   Long:     "+Str(Timer3)+"ms" 
a$+Chr(13)+Chr(10)+"   Float:    "+Str(Timer4)+"ms" 
a$+Chr(13)+Chr(10)+"1 Float 64: "+Str(Timer5)+"ms  "+Str(ergeb) 
a$+Chr(13)+Chr(10)+"2 Float 64: "+Str(Timer6)+"ms  "+Str(ergeb) 

MessageRequester("Result:",a$)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
