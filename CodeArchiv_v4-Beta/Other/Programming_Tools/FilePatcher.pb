; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8966&highlight=
; Author: thefool (corrected by Henrik, Readfile check added by Andre, updated for PB 4.00 by Andre)
; Date: 01. January 2004
; OS: Windows
; Demo: Yes


FileToPatch.s="test.exe"

Procedure.l patch(file.s,location.l,byte.b) ;<----byte.b
  If OpenFile(1,file.s)
    
    FileSeek(1,location)
    WriteByte(1,byte) ;<-----
    MessageRequester("File Patch at :",Str(location.l) + " With the value : "+StrU(byte.b,#Byte))
    
    CloseFile(1) ;<--CloseWriteFile
    ProcedureReturn 1
  EndIf
EndProcedure


If ReadFile(0,"patch.cfg")   ; syntax of the file is: "Address,Byte"

  Repeat
    pstring$=ReadString(0)
    Position = FindString(pstring$,",", 1)
    leftstring$=Left(pstring$, Position-1)
    rightstring$=Right(pstring$,Position-2)
    
    L_Num.l=Val(leftstring$)
    
    B_Num.b=Val(rightstring$) ;<----BNum.b
    
    patch(FileToPatch.s,L_Num,B_Num)
    
  Until Eof(0)
  
  CloseFile(0)
  MessageRequester("File Patched :"," Done : ")
Else
  MessageRequester("Error","Opening patch.cfg file failed.")
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
