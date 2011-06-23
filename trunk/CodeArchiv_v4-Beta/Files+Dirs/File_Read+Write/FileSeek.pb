; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5966&highlight=
; Author: ricardo (updated for PB4.00 by blbltheworm)
; Date: 27. April 2003
; OS: Windows
; Demo: Yes

If OpenFile(0,"test.txt")           ; Create a new file for testing 
  For i = 0 To 20 
    WriteStringN(0,"Line #" + Str(i)) ; write one line at time 
  Next i 
CloseFile(0)                        ; Close the file 
EndIf 

If OpenFile(1,"test.txt")           ; Now we will read the file 
  FileSeek(1,100)                     ; But start reading at one specific point of the file 
  Line$ = ReadString(1)              ; read at this point 
  MessageRequester("",Line$,0)      ; See the string readed 
  CloseFile(1) 
  DeleteFile("test.txt")            ;delete the file 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
