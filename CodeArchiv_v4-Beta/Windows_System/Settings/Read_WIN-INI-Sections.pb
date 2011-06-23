; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2967
; Author: sk
; Date: 29. November 2003
; OS: Windows
; Demo: No

Procedure.s ReadIniSections(IniFile$)
  
  Buffer$    = Space(1024)
  Counter    = 0
  Length     = 0
  Res        = GetPrivateProfileSectionNames_(@Buffer$, Len(Buffer$), @IniFile$)
  
  If Res > 0
    Section$ = PeekS(@Buffer$)
    Result$  = Section$
    Length   = Len(Section$)
    Res      = Res - Length - 1
    While Res > 0
      Counter  + 1
      Section$ = PeekS(@Buffer$ + Counter + Length)
      Length   + Len(Section$)
      Res      = Res - Len(Section$) - 1
      Result$  = Result$ + Chr(9) + Section$
    Wend
  EndIf
  ProcedureReturn Result$
  
EndProcedure

MessageRequester("WIN.INI",ReadIniSections("C:\WINDOWS\WIN.INI") ,0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
