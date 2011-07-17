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
Declare.s Tranlator_getOrigMessage(index)
Declare.s Tranlator_getTranslationMessage (index, *len)
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
	count = FileReader_readInt(#COUNT_OFFSET);
	origTableOffset = FileReader_readInt(#ORIG_TABLE_POINTER_OFFSET);
	translationTableOffset = FileReader_readInt(#TRANSLATION_TABLE_POINTER_OFFSET);
  
  ; Further sanity check file Size.
  If (FileReader_getSize() < origTableOffset Or FileReader_getSize() < translationTableOffset)
    ProcedureReturn 1
  EndIf
EndProcedure

Procedure.s Tranlator_getOrigMessage(index)
  Protected len, msgOffset
  
  len = FileReader_readInt(origTableOffset + index * 8)
	msgOffset = FileReader_readInt(origTableOffset + index * 8 + 4)
  ProcedureReturn FileReader_readStr(msgOffset)
EndProcedure

Procedure.s Tranlator_getTranslationMessage(index, *len)
  Protected msgOffset
  *len = FileReader_readInt(translationTableOffset + index * 8)
  msgOffset = FileReader_readInt(translationTableOffset + index * 8 + 4)
  ProcedureReturn FileReader_readStr(msgOffset)
EndProcedure

Procedure.s Tranlator_translate(message.s, *retlen)
  Protected low, high, mid
  Protected i, origMsg.s, retlen
  
  ; Lookup the translation With binary search.
	low = 0
	high = count - 1
  While (low <= high)
    mid = (low + high) / 2
    origMsg = Tranlator_getOrigMessage(mid)
    i = CompareMemoryString(@message, @origMsg, 1, -1, #PB_UTF8)
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
; CursorPosition = 61
; Folding = --
; EnableUnicode