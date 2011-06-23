; German forum: http://www.purebasic.fr/german/viewtopic.php?t=384&highlight=
; Author: Sylvia (updated for PB 4.00 by Andre)
; Date: 09. October 2004
; OS: Windows
; Demo: Yes


; Converts a Hex$ / Bin$ into a decimal number 
; Konvertiert einen Hex$ / Bin$ in einen Dezimalwert

; **********************************
; * 09.Oct.2004 "Sylvia" GermanForum
; **********************************

Procedure Dec(NoDec$)
  ; wandelt einen Hex$ / Bin$ um in einen Dezimalwert.
  ; Die Umwandlung erfolgt bis zum ersten ungültigen Zeichen
  ; Grenzwerte werden nicht überprüft

  ; NoDec$ = 1.Zeichen ="$" -> Wert wird als Hexzahl behandelt
  ;                    ="%" -> Wert wird als Binärzahl behandelt

  Protected Result,x,Char

  Select PeekB(@NoDec$)
    ;-------------------------
    Case '$'     ; Hex -> Dec

      NoDec$=UCase(NoDec$)
      x=1: Char=PeekB(@NoDec$+x)

      While Char
        Result << 4
        Select char
          Case '0': Result+ 0
          Case '1': Result+ 1
          Case '2': Result+ 2
          Case '3': Result+ 3
          Case '4': Result+ 4
          Case '5': Result+ 5
          Case '6': Result+ 6
          Case '7': Result+ 7
          Case '8': Result+ 8
          Case '9': Result+ 9
          Case 'A': Result+10
          Case 'B': Result+11
          Case 'C': Result+12
          Case 'D': Result+13
          Case 'E': Result+14
          Case 'F': Result+15

          Default
            ProcedureReturn Result >> 4

        EndSelect

        x+1: Char=PeekB(@NoDec$+x)
      Wend

      ;-------------------------
    Case '%'     ; Bin -> Dec

      x=1: Char=PeekB(@NoDec$+x)

      While Char
        Result << 1
        Select Char
          Case '0': Result+ 0
          Case '1': Result+ 1

          Default
            ProcedureReturn Result >> 1

        EndSelect

        x+1: Char=PeekB(@NoDec$+x)
      Wend

  EndSelect

  ProcedureReturn Result
EndProcedure


Debug dec("$ff")                  ; =255
Debug dec("$7F FF 00")            ; =127 Space is no valid
Debug dec("%1010")                ; = 10
Debug dec("%111F")                ; =  7 'F' is no valid in Binary
Debug dec("$FFCDAFBCDF53A31C90")  ; ok,ok,ok...no problem, cut by 53A31C90 :D

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -