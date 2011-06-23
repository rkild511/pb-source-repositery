;**
;* Include for easy use porc.dll _
;* Author: ts-soft

Prototype.l PORC_compile_script(InputFile.s, OutPutFile.s)
Prototype.l PORC_set_codepage(CodePage.l)
Prototype.l PORC_set_language(lngID.l)

Global PORC_DLL_hWnd.l 
OpenLibrary(#PB_Any, "PORC.dll")

;** PORC_Compile
Procedure.l PORC_Compile(ResourceScript.s);* Compiles the RC to RES!
  If Not PORC_DLL_hWnd : ProcedureReturn #False : EndIf
  Protected PORC_compile_script.PORC_compile_script = GetProcAddress_(PORC_DLL_hWnd, "_compile_script@8")
  Protected ResourceCompilat.s = Left(ResourceScript, Len(ResourceScript) - 2) + "res"
  ProcedureReturn PORC_compile_script(ResourceScript, ResourceCompilat)
EndProcedure

;** PORC_SetCodePage
Procedure.l PORC_SetCodePage(CodePage.l, Constant.l = 0);* PORC_SetCodePage(0, #PB_UTF8) or PORC_SetCodePage(65001)
  If Not PORC_DLL_hWnd : ProcedureReturn #False : EndIf
  Protected PORC_set_codepage.PORC_set_codepage = GetProcAddress_(PORC_DLL_hWnd, "_set_codepage@4")
  If Constant
    Select Constant
      Case #PB_Ascii
        CodePage = 0
      Case #PB_UTF8
        CodePage = 65001
      Case #PB_Unicode
        CodePage = 1200
    EndSelect
  EndIf
  ProcedureReturn PORC_set_codepage(CodePage)
EndProcedure

;** PORC_SetLanguage
Procedure.l PORC_SetLanguage(LangID.l);* for example 1031 for germany
  If Not PORC_DLL_hWnd : ProcedureReturn #False : EndIf
  Protected PORC_set_language.PORC_set_language = GetProcAddress_(PORC_DLL_hWnd, "_set_language@4")
  ProcedureReturn PORC_set_language(LangID)
EndProcedure

Procedure.l PORC_Free()
  CloseLibrary(PORC_DLL_hWnd)
  PORC_DLL_hWnd = 0
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; HideErrorLog