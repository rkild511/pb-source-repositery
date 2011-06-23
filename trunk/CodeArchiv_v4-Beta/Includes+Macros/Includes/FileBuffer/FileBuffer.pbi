; English forum: 
; Author: Horst (updated for PB 4.00 by Andre)
; Date: 31. December 2003
; OS: Windows
; Demo: Yes

; ---------------------------------------------------------------
; File Buffer for fast line reading 
; The complete file is read into the buffer, and closed while 
; the file remains in memory. 
; End of line codes supported: CR+LF or LF+CR or CR or LF only  
; by Horst Schaeffer - horst.schaeffer@gmx.net
; ---------------------------------------------------------------
;; #FileBufferMem ; memory allocation ID to supply 
;; set this constant before the IncludeFile statement 

Global MemFileOffset.l, MemFileSize.l,*FileBuffer

Procedure LoadFileToMem(fileID,fname.s) 
  ;Protected fileID,fname 
  If ReadFile(fileID,fname)
    MemFileSize = Lof(fileID)
    *FileBuffer = AllocateMemory(MemFileSize)
    If *FileBuffer : ReadData(fileID,*FileBuffer,MemFileSize) : EndIf 
    CloseFile(fileID)
    MemFileOffset = 0 ; reset 
  EndIf 
ProcedureReturn *FileBuffer
EndProcedure 

Procedure MoreInMem()
  If MemFileOffset < MemFileSize : ok = 1 : EndIf 
ProcedureReturn ok 
EndProcedure 

Procedure.s ReadLineFromMem() ; in case EOF: empty line is returned 
Protected line.s, Length, more, pt 
line = "" : Length = 0 
If *FileBuffer And MoreInMem()
  pt = *FileBuffer + MemFileOffset     ; current read point
  more = MemFileSize - MemFileOffset   ; remaining in buffer 
  While more
    c = PeekB(pt) : more -1 : pt +1 : Length +1 
    If c = 13 Or c = 10 
      Length -1
      If more          ; 2nd byte of CR+LF or LF+CR ? 
        n = PeekB(pt)
        If (n = 13 Or n = 10) And n <> c : pt +1 : EndIf
      EndIf 
      more = 0
    EndIf 
  Wend 
  line.s = PeekS(*FileBuffer + MemFileOffset,Length)
  MemFileOffset = pt - *FileBuffer
EndIf 
ProcedureReturn line
EndProcedure 

Procedure CloseFileMem()
  FreeMemory(*FileBuffer)
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = C:\Programme\PureBasic\Projects\Schiessl\Install\test.exe
; DisableDebugger