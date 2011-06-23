; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2423&highlight=
; Author: helpy (updated for PB4.00 by blbltheworm)
; Date: 30. September 2003
; OS: Windows
; Demo: Yes


;/ DynamicFileHandles (dfh) - Start 
; Limits 
#dfh_SizeOfList = 32            ; SizeOfList x 32 Bit 
#dfh_MaxFileHandle = 999        ; PureBasic erlaubt nur FileHandles von 0 bis 999 

; Fehlermeldungen der Prozeduren 
#dfh_Error_CanNot_OpenCreate_File = -1 
#dfh_Error_Invalid_FileHandle = -2 
#dfh_Error_Limit_FileHandles = -3 
#dfh_Error_Limit_PureBasic = -4 

; Struktur zum Speichern der FileHandles ! 
; In den einzelnen Bits der Struktur wird der Zustand eines 
; FileHandles (verwendet od. nicht verwendet) gespeichert. 
Structure struc_ListOfDynamicFileHandles 
  FileHandles.l[#dfh_SizeOfList] ; 32 x 32Bit = 1024 FileHandles 
EndStructure 

; BitMaske für Abfrage eines FileHandles 
Procedure.l dfh_BitMask( FileHandle ) 
  ProcedureReturn (1 << ((FileHandle) & $1F)) 
EndProcedure 

; Offset für die Strukur berechnen. 
Procedure.l dfh_ListOffset( FileHandle ) 
  ProcedureReturn ((FileHandle) >> 5) 
EndProcedure 

; Abfrage eines FileHandles: 
;  Return: = 0 ... FileHandle ist frei 
;          <>0 ... FileHandle ist verwendet 
Procedure.l dfh_IsFileHandleInUse( FileHandle ) 
  Shared dfh_List.struc_ListOfDynamicFileHandles 
  ProcedureReturn dfh_List\FileHandles[dfh_ListOffset(FileHandle)] & dfh_BitMask(FileHandle) 
EndProcedure 

; FileHandle als "verwendet" markieren 
Procedure dfh_SetFileHandle( FileHandle ) 
  Shared dfh_List.struc_ListOfDynamicFileHandles 
  dfh_List\FileHandles[dfh_ListOffset(FileHandle)] | dfh_BitMask(FileHandle) 
EndProcedure 

; FileHandle als "frei" markieren 
Procedure dfh_ResetFileHandle( FileHandle ) 
  Shared dfh_List.struc_ListOfDynamicFileHandles 
  dfh_List\FileHandles[dfh_ListOffset(FileHandle)] & ~dfh_BitMask(FileHandle) 
EndProcedure 

; Freies FileHandle ermitteln und wenn möglich Datei öffnen 
Procedure dfh_OpenFile(Filename.s) 
  Shared dfh_List.struc_ListOfDynamicFileHandles 
  Protected FreeFileHandle 
  FreeFileHandle = -1 
  Repeat 
    FreeFileHandle + 1 
    If FreeFileHandle > #dfh_MaxFileHandle 
      ProcedureReturn #dfh_Error_Limit_PureBasic 
    EndIf 
    If FreeFileHandle > #dfh_SizeOfList * 32 
      ProcedureReturn #dfh_Error_Limit_FileHandles 
    EndIf 
  Until dfh_IsFileHandleInUse(FreeFileHandle) = 0 
  If OpenFile(FreeFileHandle,Filename) 
    dfh_SetFileHandle(FreeFileHandle) 
    ProcedureReturn FreeFileHandle 
  Else 
    ProcedureReturn #dfh_Error_CanNot_OpenCreate_File 
  EndIf 
EndProcedure 

; Datei schließen und FileHandle wieder freigeben 
Procedure dfh_CloseFile(FileHandle) 
  Shared dfh_List.struc_ListOfDynamicFileHandles 
  If FileHandle > #dfh_MaxFileHandle 
    ProcedureReturn #dfh_Error_Limit_PureBasic 
  EndIf 
  If FreeFileHandle > #dfh_SizeOfList * 32 
    ProcedureReturn #dfh_Error_Limit_FileHandles 
  EndIf 
  If dfh_IsFileHandleInUse(FileHandle) <> 0 
    CloseFile(FileHandle) 
    dfh_ResetFileHandle(FileHandle) 
    ProcedureReturn FileHandle 
  Else 
    ProcedureReturn #dfh_Error_Invalid_FileHandle 
  EndIf 
EndProcedure 
;/ DynamicFileHandles - End 



;- Verwendung/Usage
;fh1 = dfh_OpenFile( FileName1 ) 
;fh2 = dfh_OpenFile( FileName2 ) 
;
; ... 
;
;dfh_CloseFile(fh1) 
;dfh_CloseFile(fh2) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
