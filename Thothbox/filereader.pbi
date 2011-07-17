; FileReader
; JCV @ PureBasic Forum
; http://www.JCVsite.com

;Global hMapFile.l, hFile.l, Size.l = 0
;Global addr.l
Global *Translator_MemoryID, Translator_Filesize

Procedure FileReader_destroy()
  ;CloseHandle_(hMapFile)
  ;CloseHandle_(hFile)
  FreeMemory(*Translator_MemoryID)
EndProcedure

Procedure FileReader_getSize()
  ProcedureReturn Translator_Filesize
EndProcedure

Procedure FileReader_readInt(offset)
  Protected i
  i = PeekL(*Translator_MemoryID + offset)
  ProcedureReturn i
EndProcedure

Procedure.s FileReader_readStr(offset)
  Protected out.s
	out = PeekS(*Translator_MemoryID + offset, -1, #PB_UTF8)
  ProcedureReturn out
EndProcedure

Procedure FileReader(filename.s)
  Protected buf.OFSTRUCT
  
  hFile = ReadFile(#PB_Any, filename)
  If hFile
    Translator_Filesize = Lof(hFile)                            ; get the length of opened file
    *Translator_MemoryID = AllocateMemory(Translator_Filesize)         ; allocate the needed memory
    If *Translator_MemoryID
      addr = ReadData(hFile, *Translator_MemoryID, Translator_Filesize)   ; read all data into the memory block
      Debug "Number of bytes read: " + Str(Translator_Filesize)
    Else
      ProcedureReturn 1
    EndIf
    CloseFile(hFile)
  Else
    ProcedureReturn 2
  EndIf
  
;   buf\cBytes = SizeOf(OFSTRUCT);
;   hFile = CreateFile_(filename, #GENERIC_READ, #FILE_SHARE_READ, #Null, #OPEN_EXISTING, 0, #Null)
;   If (hFile = #INVALID_HANDLE_VALUE)
;     ProcedureReturn 0
;   EndIf
; 	Size = GetFileSize_(hFile, #Null)
; 	hMapFile = CreateFileMapping_(hFile, #Null, #PAGE_READONLY, 0, Size, #Null)
; 	If hMapFile = #Null
;     CloseHandle_(hFile)
;     ProcedureReturn 1
;   EndIf
;     
; 	addr = MapViewOfFile_(hMapFile, #FILE_MAP_READ, 0, 0, Size)
;   If (addr = #Null)
;     CloseHandle_(hMapFile);
;     CloseHandle_(hFile);
;     ProcedureReturn 2
;   EndIf
EndProcedure
  
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 29
; FirstLine = 12
; Folding = -
; EnableUnicode