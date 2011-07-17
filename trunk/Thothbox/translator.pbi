; Translator
; JCV @ PureBasic Forum
; http://www.JCVsite.com

#COUNT_OFFSET = 8
#ORIG_TABLE_POINTER_OFFSET = 12
#TRANSLATION_TABLE_POINTER_OFFSET = 16

Global origTableOffset.l, translationTableOffset.l, count.l

IncludeFile "filereader.pbi"
IncludeFile "locale.pbi"

Declare.s autodetect_(podir.s, requested_locale.s)
Declare Translator(filename.s)
Declare.s Tranlator_getOrigMessage(index.l)
Declare.s Tranlator_getTranslationMessage (index.l, *len)
Declare.s Tranlator_translate(message.s, *retlen)

Procedure Translator_init(podir.s, locale.s)
  ProcedureReturn Translator(autodetect_(podir, locale))
EndProcedure

Procedure Translator_destroy()
  FileReader_destroy()
EndProcedure
  
Procedure.s autodetect_(podir.s, requested_locale.s)
  Protected locale.s, find_
  
  If (requested_locale = "")
    locale = getLanguageName()    
    If locale = "C"
      ProcedureReturn ""
    EndIf
  Else
    locale = requested_locale
  EndIf
  
  If FileSize(podir + locale + ".mo")
    ProcedureReturn podir + locale + ".mo"
  EndIf
  
  find_ = FindString(locale, "_", 1)
  locale = Left(locale, find_ - 1)
  
  If FileSize(podir + locale + ".mo")
    Debug podir + locale + ".mo"
    ProcedureReturn podir + locale + ".mo"
  EndIf
  
  ; Give up
  ProcedureReturn ""
EndProcedure

Procedure Translator(filename.s)
  Global reader
  
  reader = FileReader(filename)
  ; Sanity check file Size.
  If (FileReader_getSize() < #TRANSLATION_TABLE_POINTER_OFFSET)
    ProcedureReturn 0
  EndIf
  
  ; Load pointer info.
;	count.l = FileReader_readInt(#COUNT_OFFSET);
;	origTableOffset.l = FileReader_readInt(#ORIG_TABLE_POINTER_OFFSET);
;	translationTableOffset.l = FileReader_readInt(#TRANSLATION_TABLE_POINTER_OFFSET);
	count.l                  = PeekL(*Translator_MemoryID + #COUNT_OFFSET)
	origTableOffset.l        = PeekL(*Translator_MemoryID + #ORIG_TABLE_POINTER_OFFSET)
	translationTableOffset.l = PeekL(*Translator_MemoryID + #TRANSLATION_TABLE_POINTER_OFFSET)
  
  ; Further sanity check file Size.
  If (FileReader_getSize() < origTableOffset Or FileReader_getSize() < translationTableOffset)
    ProcedureReturn 1
  EndIf
EndProcedure

Procedure.s Tranlator_getOrigMessage(index.l)
  Protected len.l, msgOffset.l
  
  ;len.l = FileReader_readInt(origTableOffset + index * 8)
	;msgOffset = FileReader_readInt(origTableOffset + index * 8 + 4)
  ;ProcedureReturn FileReader_readStr(msgOffset)
  len       = PeekL(*Translator_MemoryID + origTableOffset + index * 8)
  msgOffset = PeekL(*Translator_MemoryID + origTableOffset + index * 8 + 4)
  ProcedureReturn PeekS(*Translator_MemoryID + msgOffset, len, #PB_UTF8)
  
EndProcedure

Procedure.s Tranlator_getTranslationMessage(index.l, *len)
  Protected msgOffset.l
  *len      = FileReader_readInt(translationTableOffset + index * 8)
  msgOffset = FileReader_readInt(translationTableOffset + index * 8 + 4)
;  ProcedureReturn FileReader_readStr(msgOffset)
  ProcedureReturn PeekS(*Translator_MemoryID + msgOffset, *len, #PB_UTF8)
EndProcedure

Procedure.s Tranlator_translate(message.s, *retlen)
  Protected low.l, high.l, mid.l
  Protected i, origMsg.s, retlen.l
  
  ; Lookup the translation With binary search.
	low = 0
	high = count - 1
  While (low <= high)
    mid = (low + high) / 2
    origMsg = Tranlator_getOrigMessage(mid)
    i = CompareMemoryString(@message, @origMsg, 0, -1, #PB_UTF8)
    If (i < 0)
      high = mid - 1
    ElseIf (i > 0)
      low = mid + 1
    Else
      ; translation found.
      ProcedureReturn Tranlator_getTranslationMessage(mid, @retlen)
    EndIf
  Wend
      
  ; translation Not found.
  ProcedureReturn ""
EndProcedure

Procedure.s T(msg.s)
  Protected len, out.s
  
  If msg = ""
    ProcedureReturn ""
  EndIf
  
  out = Tranlator_translate(msg, @len)
  
  ; Use default text if no translation
  If out = ""
    out = msg
  EndIf
  
  ProcedureReturn out
EndProcedure

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 108
; FirstLine = 95
; Folding = --
; EnableUnicode