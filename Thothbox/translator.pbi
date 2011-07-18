; Translator
; JCV @ PureBasic Forum
; http://www.JCVsite.com
; Corrected by djes@free.fr Jul 18th 2011

#COUNT_OFFSET = 8
#ORIG_TABLE_POINTER_OFFSET = 12
#TRANSLATION_TABLE_POINTER_OFFSET = 16

Global origTableOffset.l, translationTableOffset.l
Global *Translator_MemoryID, Translator_Filesize
Global NewMap TranslationTable.s()

;IncludeFile "filereader.pbi"
IncludeFile "locale.pbi"

Declare.s Translator_Autodetect(podir.s, requested_locale.s)
Declare   Translator(FileName.s)
Declare.s Translator_getOrigMessage(index.l)
Declare.s Translator_getTranslationMessage (index.l)
Declare.s Translator_translate(message.s)

Procedure Translator_init(podir.s, locale.s)
  ;Debug Translator_Autodetect(podir, locale)
  ProcedureReturn Translator(Translator_Autodetect(podir, locale))
EndProcedure

Procedure Translator_destroy()
  ClearMap(TranslationTable())
EndProcedure
  
Procedure.s Translator_Autodetect(podir.s, requested_locale.s)
  Protected locale.s, find_
   
  If requested_locale = ""
    locale = getLanguageName()    
    If locale = "C"
      ProcedureReturn ""
    EndIf
  Else
    locale = requested_locale
  EndIf
  
  If FileSize(podir + locale + ".mo") > 0
    ProcedureReturn podir + locale + ".mo"
  EndIf
    
  If FileSize(podir + locale + "_" + UCase(locale) + ".mo") > 0   
    ProcedureReturn podir + locale + "_" + UCase(locale) + ".mo"
  EndIf
  
  ; Give up
  ProcedureReturn ""
EndProcedure

Procedure.s Translator_getOrigMessage(index.l)
  Protected len.l, msgOffset.l
  len       = PeekL(*Translator_MemoryID + origTableOffset + index * 8)
  msgOffset = PeekL(*Translator_MemoryID + origTableOffset + index * 8 + 4)
  ProcedureReturn PeekS(*Translator_MemoryID + msgOffset, len, #PB_UTF8)
EndProcedure

Procedure.s Translator_getTranslationMessage(index.l)
  Protected len.l, msgOffset.l
  len       = PeekL(*Translator_MemoryID + translationTableOffset + index * 8)
  msgOffset = PeekL(*Translator_MemoryID + translationTableOffset + index * 8 + 4)
  ProcedureReturn PeekS(*Translator_MemoryID + msgOffset, len, #PB_UTF8)
EndProcedure

Procedure Translator(FileName.s)
  Protected hFile, addr.i, count.i, i.i
  
  hFile = ReadFile(#PB_Any, FileName)
  If hFile
    Translator_Filesize = Lof(hFile)                            ; get the length of opened file
    *Translator_MemoryID = AllocateMemory(Translator_Filesize)         ; allocate the needed memory
    If *Translator_MemoryID
      If ReadData(hFile, *Translator_MemoryID, Translator_Filesize) = 0   ; read all data into the memory block
        ProcedureReturn 1
      EndIf
        ;Debug "Number of bytes read: " + Str(Translator_Filesize)
    Else
      ProcedureReturn 1
    EndIf
    CloseFile(hFile)
  Else
    ProcedureReturn 2
  EndIf
  
  ; Sanity check file Size.
  If (Translator_Filesize < #TRANSLATION_TABLE_POINTER_OFFSET)
    ProcedureReturn 0
  EndIf
  
  ; Further sanity check file Size.
  If (Translator_Filesize < origTableOffset Or Translator_Filesize < translationTableOffset)
    ProcedureReturn 1
  EndIf

	count                    = PeekL(*Translator_MemoryID + #COUNT_OFFSET)
	origTableOffset.l        = PeekL(*Translator_MemoryID + #ORIG_TABLE_POINTER_OFFSET)
	translationTableOffset.l = PeekL(*Translator_MemoryID + #TRANSLATION_TABLE_POINTER_OFFSET)
	
	;Fill map table
	For i = 0 To count - 1
	  TranslationTable(Translator_getOrigMessage(i)) = Translator_getTranslationMessage(i)
	  ;Debug "'" + Translator_getOrigMessage(i) + "' : '" + Translator_getTranslationMessage(i) + "'"
  Next i
     
  FreeMemory(*Translator_MemoryID)
  
EndProcedure

Procedure.s t(msg.s)
  Protected len, out.s
  
  If msg = ""
    ProcedureReturn ""
  EndIf
  
  out = TranslationTable(msg)
  
  ; Use default text if no translation
  If out = ""
    out = msg
  EndIf
  
  ProcedureReturn out
EndProcedure

Macro GetText(msg)
  t(msg)
EndMacro
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 70
; FirstLine = 53
; Folding = --
; EnableUnicode