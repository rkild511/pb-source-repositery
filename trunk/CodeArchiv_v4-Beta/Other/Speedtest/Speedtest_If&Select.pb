; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8192&highlight=
; Author: Froggerprogger
; Date: 05. November 2003
; OS: Windows
; Demo: No

#max = 1000000000
Global a.l, b.l 

starttime = GetTickCount_() 
For i=0 To #max 
  If a=0 : b=0 
    ElseIf a=1 : b=1 
    ElseIf a=2 : b=2 
    Else : b=3 
  EndIf 
Next 
time = GetTickCount_() - starttime 
MessageRequester("",Str(time)+"ms with IF:ELSEIF:ELSE",0) 

starttime = GetTickCount_() 
For i=0 To #max 
  Select a 
    Case 0 : b=0 
    Case 1 : b=1 
    Case 2 : b=2 
    Default : b=3 
  EndSelect 
Next 
time = GetTickCount_() - starttime 
MessageRequester("",Str(time)+"ms with SELECT:CASE:DEFAULT",0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
