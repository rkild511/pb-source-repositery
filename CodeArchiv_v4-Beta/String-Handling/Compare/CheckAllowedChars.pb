; German forum: http://www.purebasic.fr/german/viewtopic.php?t=149&postdays=0&postorder=asc&start=10
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 16. September 2004
; OS: Windows
; Demo: Yes

Global Dim AllowedChars.l(255) 
Procedure SetAllowedChars(*AllowedChars.BYTE) 
  Protected a.l 
  For a = 0 To 255 
    AllowedChars(a) = #False 
  Next 
  While *AllowedChars\b 
    AllowedChars(*AllowedChars\b & $FF) = #True 
    *AllowedChars + 1 
  Wend 
EndProcedure 

Procedure TestAllowedChars(*String.BYTE) 
  While *String\b 
    If AllowedChars(*String\b & $FF) = 0 : ProcedureReturn #False : EndIf 
    *String + 1 
  Wend 
  ProcedureReturn #True 
EndProcedure 

SetAllowedChars(@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-.%") 

Debug TestAllowedChars(@"Hallo") 
Debug TestAllowedChars(@"Nummer123") 
Debug TestAllowedChars(@"www.ich-bin-da.de") 
Debug TestAllowedChars(@"das geht nicht") 
Debug TestAllowedChars(@"das%20geht%20auch%20nicht!")
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -