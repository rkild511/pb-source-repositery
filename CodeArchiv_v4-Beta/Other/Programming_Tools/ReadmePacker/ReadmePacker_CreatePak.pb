; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3038&highlight=
; Author: AndyMars  (some slightly modifications by Andre for the CodeArchiv, updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 06. December 2003
; OS: Windows
; Demo: Yes


; Part 1/2 of the ReadmePacker - creates a packed readme file,
; later to be included in the ReadmePacker_CreateExe example

; Andy Marschner - entnommen aus: 
; ------------------------------------------------------------ 
; 
;   PureBasic - Compressor example file 
; 
;    (c) 2001 - Fantaisie Software 
; 
; ------------------------------------------------------------ 
;erstellt mit/für PureBasic 3.8 

Procedure _M(Text$) 
  MessageRequester("Readme Packer",Text$) 
EndProcedure 

OpenPreferences("ReadmePacker.ini") 
SourceFile.s=ReadPreferenceString("SourceFile","") 
TargetFile.s=ReadPreferenceString("TargetFile","") 
ClosePreferences() 

If ReadFile(0, SourceFile) 
  FileLength = Lof(0) 
  
  ; Allocate the 2 memory buffers needed for compression.. 
  ; 
  Mem1 = AllocateMemory(FileLength)
  Mem2 = AllocateMemory(FileLength + 8)
  If FileLength And Mem1 And Mem2
    ReadData(0, Mem1, FileLength) ; Read the whole file in the memory buffer 
    CloseFile(0) 
    ; Compress our file, which is in memory 
    ; 
    CompressedLength = PackMemory(Mem1, Mem2, FileLength,9) 
    If CompressedLength 
      If CreateFile(0,TargetFile) 
        WriteData(0, Mem2, CompressedLength) 
        CloseFile(0) 
      Else 
        _M("Error - cannot create file: "+TargetFile) 
      EndIf 
    Else 
      _M("Error - compressing failed!") 
    EndIf 
  EndIf 
Else 
  _M("Error - cannot open file: "+SourceFile) 
EndIf 

End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
