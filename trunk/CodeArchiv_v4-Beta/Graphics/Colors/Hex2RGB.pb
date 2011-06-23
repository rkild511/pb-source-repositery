; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8597&highlight=
; Author: darklordz  (modified and example by Andre, example extended by blbltheworm)
; Date: 06. December 2003
; OS: Windows
; Demo: Yes

Procedure.l _Hex2Dec(hex.s) 
    For r=1 To Len(hex.s) 
        d<<4 : a.s=Mid(hex.s,r,1) 
        If Asc(a.s)>60 
            d+Asc(a.s)-55 
        Else 
            d+Asc(a.s)-48 
        EndIf 
    Next 
    ProcedureReturn d 
EndProcedure 

; A HEX to RGB function.
; First parameter is the color in Hex format, second parameter
; must be R, G Or B (the color, you want the value of)
Procedure.s _Hex2RGB(hex.s,ret.s) 
    hex.s = UCase(hex.s) 
    For i=1 To (6-Len(hex.s)) 
        hexa.s = hexa.s+"0" 
    Next 
    hex.s=hexa.s+hex.s 
    r.l = _Hex2Dec(Mid(hex.s,1,2)) 
    g.l = _Hex2Dec(Mid(hex.s,3,2)) 
    b.l = _Hex2Dec(Mid(hex.s,5,2)) 
    If UCase(ret.s) = "A" 
        ProcedureReturn Str(r.l)+","+Str(g.l)+","+Str(b.l) 
    ElseIf UCase(ret.s) = "R" 
        ProcedureReturn Str(r.l) 
    ElseIf UCase(ret.s) = "G" 
        ProcedureReturn Str(g.l) 
    ElseIf UCase(ret.s) = "B" 
        ProcedureReturn Str(b.l) 
    EndIf 
EndProcedure 
 

Color.s = "AACC77"
Debug Hex(170) + Hex(204) + Hex(119)
Debug _Hex2RGB(Color,"R")  ; red part
Debug _Hex2RGB(Color,"G")  ; green part
Debug _Hex2RGB(Color,"B")  ; blue part
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
