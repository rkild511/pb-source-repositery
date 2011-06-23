; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1112
; Author: remi_meier (updated for PB 4.00 by remi_meier)
; Date: 04. December 2004
; OS: Windows
; Demo: Yes


; Einfacher Lösungsalgorithmus für lineare Gleichungssysteme.
; Wenn du wissen willst, wies funktioniert, dann Google (Gauss-Algorithmus)...

Procedure GaussSolve(Matrix.f(2), n.l)
  Protected h.f, i, j, k
  n = n - 1

  For i = 0 To n - 1
    h = Matrix(i, i)
    If h = 0
      ProcedureReturn #False
    EndIf
    For j = 0 To n
      Matrix(j, i) = Matrix(j, i) / h
    Next
    For j = 0 To n - 1
      If i <> j
        h = Matrix(i, j)
        For k = 0  To n
          Matrix(k, j) = Matrix(k, j) - Matrix(k, i) * h
        Next
      EndIf
    Next
  Next

  ProcedureReturn #True
EndProcedure

#x = 3
#y = 2
Dim Matrix.f(#x - 1, #y - 1)

For y = 0 To #y - 1
  For x = 0 To #x - 1
    Read Matrix(x, y)
  Next
Next

GaussSolve(Matrix(), #x)

line.s
For y = 0 To #y - 1
  For x = 0 To #x - 1
    line + StrF(Matrix(x, y)) + " "
  Next
  Debug line
  line = ""
Next


DataSection
  matrix:
  Data.f 7, 2, 3
  Data.f 8, 3, 9
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -