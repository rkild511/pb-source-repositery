; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 09. September 2002
; OS: Windows
; Demo: Yes


; Wanna do some Debug outputs on lets say the console?


;Digits to string converter
;--------------------------
;positive numbers only, 
;Only base10 use negative numbers
;Why? Because -1 may be FF, FFFF or FFFFFFFF in Hex depending on datasize Byte/Word/Long
Procedure.s d2s(input.l,base.b)
  lastdigit.l
  returnstring.s
  input=Abs(input)
  If input=0:returnstring="0":EndIf
  While input>0 
    lastdigit=input-(input/base*base)
    If lastdigit<10
      returnstring=Chr(lastdigit+48)+returnstring
    Else
      returnstring=Chr(lastdigit+55)+returnstring
    EndIf
    input=input/base
  Wend
  ProcedureReturn returnstring
EndProcedure

; Example:
OpenConsole()
PrintN(d2s(32489908,10))    ; -> "32489908"
PrintN(d2s(32489908,16))    ; -> "1EFC1B4"
PrintN(d2s(300,2))          ; -> "100101100"
Input()
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -