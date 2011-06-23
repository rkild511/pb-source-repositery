; German forum: http://www.purebasic.fr/german/viewtopic.php?t=459&highlight=
; Author: Froggerprogger
; Date: 16. October 2004
; OS: Windows
; Demo: No

; Transponieren von Gitarren-Akkorden
; Reihenfolge der Tonarten:
; A A# B C C# D D# E F F# G G#


; Transponieren einer Note:

Dim Noten.s(11)

Noten(0) = "C"
Noten(1) = "C#/Db"
Noten(2) = "D"
Noten(3) = "D#/Eb"
Noten(4) = "E"
Noten(5) = "F"
Noten(6) = "F#/Gb"
Noten(7) = "G"
Noten(8) = "G#/Ab"
Noten(9) = "A"
Noten(10) = "A#/B[b]"
Noten(11) = "H[B]"

Procedure.l TransposeNote(note.l, transpose.l)
  If transpose = 0
    ProcedureReturn note
  Else
    Protected res.l
    res = (note + transpose) % 12 ; % 12, damit z.B. Wert 13 wieder zu 1 wird
    ; -11 <= res <= 11
    If res < 0
      ProcedureReturn 12+res ; z.B. -1 = 11
    Else
      ProcedureReturn res
    EndIf
  EndIf
EndProcedure

aktuelleNote = 9
Debug Noten(aktuelleNote)
schieberegler = 4
Debug "Transpose " + Str(schieberegler) + " Halbtöne"
neueAktuelleNote = TransposeNote(aktuelleNote, schieberegler)
Debug "=> " + Noten(neueAktuelleNote)

aktuelleNote = neueAktuelleNote
schieberegler = -9
Debug "Transpose "+Str(schieberegler) + " Halbtöne"
neueAktuelleNote = TransposeNote(aktuelleNote, schieberegler)
Debug "=> " + Noten(neueAktuelleNote)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -