; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9755&highlight=
; Author: einander (updated for PB 4.00 by Andre)
; Date: 06. March 2004
; OS: Windows
; Demo: Yes

; Here is a simple example for color gradient and 2D aleatory coral growing.

; CoralReef
; simple color Gradient and aleatory growing
; by einander
; march 5 -2004 - PB 3.81

Global Xmin, Ymin, Xmax, Ymax, Gradient
Gradient = 8 ; try different values

Procedure ChangeColor(COLOR)
  R = Red(COLOR) : G = Green(COLOR) : B = Blue(COLOR)
  G2 = Gradient * 2
  Select Random(2)
    Case 0
      If R > 255 - G2 : R - Gradient
      ElseIf R < G2 : R + Gradient
      Else : R + Random(Gradient * 2) - Gradient
      EndIf
    Case 1
      If G > 255 - G2 : G - Gradient
      ElseIf G < G2 : G + Gradient
      Else : G + Random(Gradient * 2) - Gradient
      EndIf
    Case 2
      If B > 255 - G2 : B - Gradient
      ElseIf B < G2 : B + Gradient
      Else : B + Random(Gradient * 2) - Gradient
      EndIf
  EndSelect
  ProcedureReturn RGB(R, G, B)
EndProcedure

Procedure Grow()
  Select Random(3) ; search first pixel <> Black , starting on aleatory window margin
    Case 0
      Y = Random(Ymax - Ymin) + Ymin
      For x = Xmin To Xmax
        If Point(x, y)
          Circle(X, Y, 2, ChangeColor(Point(X, Y)))
          If Xmin >= x : Xmin = x - 1 : EndIf
          Break
        EndIf
      Next
    Case 1
      Y = Random(Ymax - Ymin) + Ymin
      For x = Xmax To Xmin Step - 1
        If Point(x, y)
          Circle(X + 1, Y, 2, ChangeColor(Point(X, Y)))
          If Xmax <= x : Xmax = x + 1 : EndIf
          Break
        EndIf
      Next
    Case 2
      X = Random(Xmax - Xmin) + Xmin
      For y = Ymin To Ymax
        If Point(x, y)
          Circle(X, Y, 2, ChangeColor(Point(X, Y)))
          If Ymin >= y : Ymin = y - 1 : EndIf
          Break
        EndIf
      Next
    Case 3
      X = Random(Xmax - Xmin) + Xmin
      For y = Ymax To Ymin Step - 1
        If Point(x, y)
          Circle(X, Y + 1, 2, ChangeColor(Point(X, Y)))
          If Ymax <= y : Ymax = y + 1 : EndIf
          Break
        EndIf
      Next
  EndSelect
EndProcedure
; ____________________________________________________________________________________-
ExamineDesktops()
_X = DesktopWidth(0) - 8 : _Y = DesktopHeight(0) - 68
OpenWindow(0, 0, 0, _X, _Y, "", #WS_OVERLAPPEDWINDOW | #WS_MAXIMIZE)
StartDrawing(WindowOutput(0))
DrawingMode(0)

Xmin = _x / 2 - 1 : Ymin = _y / 2 - 1 : Xmax = Xmin + 2 : Ymax = Ymin + 2
Box(0, 0, WindowWidth(0), WindowHeight(0), #Black)
Plot(_x / 2, _y / 2, Random($FFFFFF)) ; aleatory color starting point
Repeat
  Select WindowEvent()
    Case #PB_Event_CloseWindow : End
    Case #WM_KEYDOWN : If EventwParam() = 27 : End : EndIf
  EndSelect
  If Xmin > 10 And Ymin > 40 And Xmax < _x - 10 And Ymax < _y - 60
    Grow()
  EndIf
ForEver
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger