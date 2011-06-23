; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3340&highlight=
; Author: Rob
; Date: 05. January 2004
; OS: Windows
; Demo: Yes

Procedure Rom2Dec(s.s) 
  s=UCase(s) 
  If Len(s) < 1 : ProcedureReturn 0 : EndIf 
  For i = 1 To Len(s) 
    b.s = Mid(s,i,1) 
    Select a.s 
      Case "I": If FindString("VXLCDM",b,0) : erg - 2 : EndIf 
      Case "V": If FindString("XLCDM",b,0) : erg - 10 : EndIf 
      Case "X": If FindString("LCDM",b,0) : erg - 20 : EndIf 
      Case "L": If FindString("CDM",b,0) : erg - 100 : EndIf 
      Case "C": If FindString("DM",b,0) : erg - 200 : EndIf 
      Case "D": If b = "M" : erg - 1000 : EndIf 
    EndSelect 
    Select UCase(b) 
      Case "I" 
        erg + 1 
      Case "V" 
        erg + 5 
      Case "X" 
        erg + 10 
      Case "L" 
        erg + 50 
      Case "C" 
        erg + 100 
      Case "D" 
        erg + 500 
      Case "M" 
        erg + 1000 
      Default 
        ProcedureReturn 0 
    EndSelect 
    a = b 
  Next 
  ProcedureReturn erg 
EndProcedure 


Procedure.s Dec2Rom(dec) 
  rom.s 
  If dec < 0 : sign.s = "-" : EndIf 
  dec = Abs(dec) 
  While dec <> 0 
    If dec >= 1000: rom = "M": dec - 1000 
    ElseIf dec < 1000 And dec >= 900: rom + "CM": dec  - 900 
    ElseIf dec < 500 And dec >= 400: rom + "CD": dec - 400 
    ElseIf dec < 900 And dec >= 500: rom + "D": dec - 500 
    ElseIf dec < 400 And dec >= 100: rom + "C": dec - 100 
    ElseIf dec < 400 And dec >= 90: rom + "XC": dec - 90 
    ElseIf dec < 50 And dec >= 40: rom + "XL": dec - 40 
    ElseIf dec < 90 And dec >= 50: rom + "L": dec - 50 
    ElseIf dec < 40 And dec >= 10: rom + "X": dec - 10 
    ElseIf dec < 9 And dec >= 5: rom + "V": dec - 5 
    ElseIf dec < 4 And dec >= 1: rom + "I": dec - 1 
    ElseIf dec = 9: rom + "IX": dec - 9 
    ElseIf dec = 4: rom + "IV": dec - 4 
    Else 
      Break 
    EndIf 
  Wend 
  ProcedureReturn sign+rom 
EndProcedure 


Debug Dec2Rom(1984) 
Debug Rom2Dec("MCMLXXXIV")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
