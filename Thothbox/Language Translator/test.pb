; JCV @ PureBasic Forum
; http://www.JCVsite.com

XIncludeFile "translator.pb"

Procedure Test_Translate()
  Protected origTxt.s, tranlatedTxt.s
  ; Sample words to translate based from id.mo file
  origTxt = "%i lines of file '%s' were not loaded correctly."
  ; Output translated words
  tranlatedTxt = T(origTxt)
  
  Debug origTxt
  Debug tranlatedTxt
EndProcedure

; Initialize Translator and load default folder
; Here in example, we are forcing to load indonesian locale translation, blank means autodetect locale
Translator_init("locale\", "id")

; Lets see =)
Test_Translate()

; Clean up
Translator_destroy()
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 21
; Folding = -