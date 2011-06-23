; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2901&start=40
; Author: GPI
; Date: 23. November 2003
; OS: Windows
; Demo: No


; Disable debugger !!!
; Debugger ausschalten!!!!!! 

Timer1=GetTickCount_() 
For i=0 To 3000000 
  b.b+1 
Next 
Timer1=GetTickCount_()-Timer1 

Timer2=GetTickCount_() 
For i=0 To 3000000 
  w.w+1 
Next 
Timer2=GetTickCount_()-Timer2 

Timer3=GetTickCount_() 
For i=0 To 3000000 
  l.l+1 
Next 
Timer3=GetTickCount_()-Timer3 

Timer4=GetTickCount_() 
For i=0 To 3000000 
  f.f+1 
Next 
Timer4=GetTickCount_()-Timer4 

a$="Byte:"+Str(Timer1)+"ms" 
a$+Chr(13)+Chr(10)+"Word:"+Str(Timer2)+"ms" 
a$+Chr(13)+Chr(10)+"Long:"+Str(Timer3)+"ms" 
a$+Chr(13)+Chr(10)+"Float:"+Str(Timer4)+"ms" 

MessageRequester("Result:",a$)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
