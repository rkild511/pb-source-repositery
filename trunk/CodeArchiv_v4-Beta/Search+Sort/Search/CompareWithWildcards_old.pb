; German forum:
; Author: NicTheQuick
; Date: 19. February 2003
; OS: Windows
; Demo: Yes

Procedure CompareWithWildcards(String.s, WC.s)
  Repeat
    a.l = FindString(WC, "**", 1)
    If a
      WC = Left(WC, a) + Mid(WC, a + 2, Len(WC))
    EndIf
  Until a = #False
  Debug WC
  
  Offset.l = 1
  wcOffset.l = 1
  Repeat
    wcz.s = Mid(WC, wcOffset, 1)
    stz.s = Mid(String, Offset, 1)
    If wcz = "*"
      If wcOffset = Len(WC)                ;Wenn der Stern am Schluss steht
        wcOffset + 1
      Else
        If Offset - 1 = Len(String)        ;Wenn dem Stern noch was folgt, aber String.s am Ende ist
          ProcedureReturn #False
        Else
          z.s = Mid(WC, wcOffset + 1, 1)
          If z = stz
            wcOffset + 1
          Else
            Offset + 1
          EndIf
        EndIf
      EndIf
    ElseIf wcz = "?"
      If Len(String) < Offset
        ProcedureReturn #False
      Else
        Offset + 1
        wcOffset + 1
      EndIf
    Else
      If wcz <> stz
        ProcedureReturn #False
      Else
        Offset + 1
        wcOffset + 1
      EndIf
    EndIf
  Until wcOffset - 1 = Len(WC)
  ProcedureReturn #True
EndProcedure

Text.s = "NicTheQuick"
Wildcards.s = "N?c??eQ*k"
Debug CompareWithWildcards(Text, Wildcards)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -