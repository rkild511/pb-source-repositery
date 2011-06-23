; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8748&highlight=
; Author. Paul (FileSize check added by Andre, updated for PB 4.00 by Andre)
; Date: 15. December 2003
; OS: Windows
; Demo: Yes


; This will change bytes in an EXE file at a specific location... 
; Just specify Filename, location in file to patch, And new byte 
; Returns 1 if successful.

Procedure.l Patch(file.s,location.l,byte.b) 
  If FileSize(file) < 0
    ProcedureReturn 0
  EndIf 
  If OpenFile(0,file) 
    FileSeek(0,location) 
    WriteData(0,@byte,1) 
    CloseFile(0) 
    ProcedureReturn 1 
  EndIf
EndProcedure 

Debug Patch("FiletoPatch.exe",50,20) 
 



; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
