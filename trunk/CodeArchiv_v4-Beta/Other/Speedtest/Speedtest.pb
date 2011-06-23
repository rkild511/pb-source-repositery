; English forum: 
; Author: Unknown 
; Date: 31. December 2002
; OS: Windows
; Demo: Yes

OpenConsole() 

Dim a(10) 

ti2=Minute(Date()) 
ti=Second(Date()) 

For i=1 To 500000000 
  a(b)=a(b+1) 
  j=i+j 
  a(b+1)=j 
Next 

ti2=Minute(Date())-ti2 
ti=Second(Date())-ti 

If ti2<0 
  ti2=60+ti2 
EndIf 

If ti<0 
  ti=60+ti 
  ti2=ti2-1 
EndIf 

res=Print(Str(ti2*60+ti)) 
a$=Input()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger