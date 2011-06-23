; http://www.reelmediaproductions.com/pb/archive270/tutorials/triangle.html
; Author: Francois Weil (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: Yes


Procedure.l IMin(a.l, b.l)
  If a < b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure

Procedure.l IMax(a.l, b.l)
  If a > b
    ProcedureReturn a
  Else
    ProcedureReturn b
  EndIf
EndProcedure

Procedure.l IMin3(a.l, b.l, c.l)
  d.l = IMin(a, b)
  d.l = IMin(d, c)
  ProcedureReturn d
EndProcedure

Procedure.l IMax3(a.l, b.l, c.l)
  d.l = IMax(a, b)
  d.l = IMax(d, c)
  ProcedureReturn d
EndProcedure

Procedure.l IMed3(a.l, b.l, c.l)
  x = IMin3(a, b, c)
  y = IMax3(a, b, c)
  If a <> x And a <> y
    z = a
  EndIf
  If b <> x And b <> y
    z = b
  EndIf
  If c <> x And c <> y
    z = c
  EndIf
  ProcedureReturn z
EndProcedure

Procedure DrawFacet(Xa.l, Ya.l, Xb.l, Yb.l, Xc.l, Yc.l)
  A2.Point
  B2.Point
  C2.Point
  ;
  ; The way to find the rectangle that contains the triangle
  ;
  A2\x = IMin3(Xa, Xb, Xc)
  A2\y = IMin3(Ya, Yb, Yc)
  B2\x = IMax3(Xa, Xb, Xc)
  B2\y = IMax3(Ya, Yb, Yc)
  C2\x = IMed3(Xa, Xb, Xc)
  C2\y = IMed3(Ya, Yb, Yc)
  
  ; Debug "Xa=" + Str(Xa) + " Ya=" + Str(Ya) + " Xb=" + Str(Xb) + " Yb=" + Str(Yb) + " Xc=" + Str(Xc) + " Yc=" + Str(Yc) + " A2\x=" + Str(A2\x) + " A2\y=" + Str(A2\y) + " B2\x=" + Str(B2\x) + " B2\y=" + Str(B2\y)
  LineXY(A2\x, A2\y, A2\x, B2\y, #Blue)
  LineXY(A2\x, B2\y, B2\x, B2\y, #Blue)
  LineXY(B2\x, B2\y, B2\x, A2\y, #Blue)
  LineXY(B2\x, A2\y, A2\x, A2\y, #Blue)
  
  DrawingMode(5)
  Box(Xa - 4, Ya - 4, 8, 8, #Red)
  FrontColor(RGB(0,255,0))
  DrawText(Xa + 4, Ya + 4,"A")
  Box(Xb - 4, Yb - 4, 8, 8, #Red)
  FrontColor(RGB(0,255,0))
  DrawText(Xb + 4, Yb + 4,"B")
  Box(Xc - 4, Yc - 4, 8, 8, #Red)
  FrontColor(RGB(0,255,0))
  DrawText(Xc + 4, Yc + 4,"C")
  
  ;
  ; Look for :
  ; A, B line with coeffs aAB, bAB
  ; A, C line with coeffs aAC, bAC
  ; B, C line with coeffs aBC, bBC
  ;
  aAB.f = (Yb - Ya) / (Xb - Xa)
  bAB.f = Yb - aAB * Xb
  aAC.f = (Yc - Ya) / (Xc - Xa)
  bAC.f = Yc - aAC * Xc
  aBC.f = (Yc - Yb) / (Xc - Xb)
  bBC.f = Yc - aBC * Xc
  
  ; Debug "aAB=" + StrF(aAB) + " bAB=" + StrF(bAB) + " aAC=" + StrF(aAC) + " bAC=" + StrF(bAC) + " aBC=" + StrF(aBC) + " bBC=" + StrF(bBC)
  ;
  ; Draw lines from x = 0 to x = 1024
  ;
  LineXY(0, bAB, 1024, aAB * 1024 + bAB, #Yellow)
  LineXY(0, bAC, 1024, aAC * 1024 + bAC, #Yellow)
  LineXY(0, bBC, 1024, aBC * 1024 + bBC, #Yellow)
  
  If B2\y = Ya ; A is the upper point, we draw between A,B and A,C
    For i = B2\y To C2\y Step -1
      LineXY((i - bAB) / aAB, i, (i - bAC) / aAC, i, #Cyan)
    Next
    If C2\y = Yb ; If the drawing stopped at level of B, we must still draw from C,A and C,B
      For i = A2\y To C2\y
        LineXY((i - bAC) / aAC, i, (i - bBC) / aBC, i, #Magenta)
      Next
    Else ; If the drawing stopped at level of C, we must still draw from B,A and C,B
      For i = A2\y To C2\y
        LineXY((i - bAB) / aAB, i, (i - bBC) / aBC, i, #Magenta)
      Next
    EndIf
  ElseIf B2\y = Yb ; B is the upper point, we draw between B,A and B,C
    For i = B2\y To C2\y Step -1
      LineXY((i - bAB) / aAB, i, (i - bBC) / aBC, i, #Cyan)
    Next
    If C2\y = Ya ; If the drawing stopped at level of A, we must still draw from C,A and C,B
      For i = A2\y To C2\y
        LineXY((i - bAC) / aAC, i, (i - bBC) / aBC, i, #Magenta)
      Next
    Else ; If the drawing stopped at level of C, we must still draw from A,C and A,B
      For i = A2\y To C2\y
        LineXY((i - bAB) / aAB, i, (i - bAC) / aAC, i, #Magenta)
      Next
    EndIf
  ElseIf B2\y = Yc ; C is the upper point, we draw between A,C and B,C
    For i = B2\y To C2\y Step -1
      LineXY((i - bAC) / aAC, i, (i - bBC) / aBC, i, #Cyan)
    Next
    If C2\y = Ya ; If the drawing stopped at level of A, we must still draw from A,B and B,C
      For i = A2\y To C2\y
        LineXY((i - bAB) / aAB, i, (i - bBC) / aBC, i, #Magenta)
      Next
    Else ; If the drawing stopped at level of B, we must still draw from A,C and A,B
      For i = A2\y To C2\y
        LineXY((i - bAB) / aAB, i, (i - bAC) / aAC, i, #Magenta)
      Next
    EndIf
  EndIf
  
EndProcedure

A.Point
B.Point
C.Point
If InitSprite()
  If OpenScreen(1024, 768, 32, "")
    InitSprite3D()
    
    CreateSprite(1, 32, 32, #PB_Sprite_Texture)
    StartDrawing(SpriteOutput(1))
    Box(0, 0, 32, 32, #Green)
    StopDrawing()
    CreateSprite3D(1, 1)
    
    Sprite3DQuality(1)
    If InitKeyboard()
      Quit.l = #False
      Repeat
        A\x = Random(300) + 200
        A\y = Random(300) + 200
        B\x = Random(300) + 200
        B\y = Random(300) + 200
        C\x = Random(300) + 200
        C\y = Random(300) + 200
        ClearScreen(RGB(0,0,0))
        Start3D()
        TransformSprite3D(1, A\x, A\y, B\x, B\y, A\x, A\y, C\x, C\y)
        DisplaySprite3D(1, 0, 0, 255)
        Stop3D()
        FlipBuffers()
        ExamineKeyboard()
        If KeyboardPushed(#PB_Key_Escape)
          Quit = #True
        EndIf
        Delay(1000)
      Until Quit
    Else
      Debug "Error initializing keyboard."
    EndIf
  Else
    Debug "Error opening screen."
  EndIf
Else
  Debug "Error initializing screen/sprite enviroment."
EndIf

End


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --