; English forum: 
; Author: Horst (updated for PB 4.00 by Andre)
; Date: 31. December 2003
; OS: Windows
; Demo: Yes

; ---------------------------------------------------------------
; File Buffer for fast line reading - InlineASM Compiler Option
; The complete file is read into the buffer, and closed while 
; the file remains in memory. 
; End of line codes supported: CR+LF or CR only 
; by Horst Schaeffer - horst.schaeffer@gmx.net
; ---------------------------------------------------------------

; Updated code for PB3.92+ by Lars, the #FileBufferMem ID isn't needed anymore

;; #FileBufferMem ; memory allocation ID to supply 
;; set this constant before the IncludeFile statement 

Global MemFileOffset.l, MemFileSize.l, *FileBuffer

Procedure LoadFileToMem(fileID,fname.s) 
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
Protected line.s, Length, pt
line.s = "" 
If *FileBuffer And MoreInMem()
  pt = *FileBuffer + MemFileOffset  ; keep pointer
  Length = 0
  MOV Ebx,*FileBuffer  ; base
  MOV Esi,MemFileOffset
  !SUB Ecx,Ecx         ; length count
  !.rpt_SI:
    CMP Esi,MemFileSize
    !JNB .done         ; end of file  
    !MOV AL,[Ebx+Esi] 
    !INC Esi
    !INC Ecx
    !CMP AL,13         ; CR?
    !JNE .rpt_SI 
  !DEC Ecx             ; discount CR
  CMP Esi,MemFileSize
  !JNB .done 
  !CMP byte[Ebx+Esi],10 ; LF?
  !JNE .done
    !INC Esi            ; skip LF
  !.done:
  MOV MemFileOffset,Esi ; next line
  MOV Length,Ecx
  line = PeekS(pt,Length)
EndIf 
ProcedureReturn line
EndProcedure 

Procedure CloseFileMem()
  FreeMemory(*FileBuffer)
EndProcedure 
 
  
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; Executable = C:\Programme\PureBasic\Projects\Schiessl\Install\test.exe
; DisableDebugger