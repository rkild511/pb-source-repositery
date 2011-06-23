; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6638&highlight=
; Author: wichtel
; Date: 15. July 2003
; OS: Windows
; Demo: No


AllocConsole_() 
  stdout=GetStdHandle_(#STD_OUTPUT_HANDLE) 
  
  For i=1 To 100 

  msg$="test"+Str(i)+Chr(13)+Chr(10) 
  size.l=Len(msg$) 
  written.l 
  WriteConsole_(stdout,@msg$,size, @written, #Null) 
  Delay(30) 
  
  Next i 
  
  Delay(2000) 
FreeConsole_() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
