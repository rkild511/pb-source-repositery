; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5323&highlight=
; Author: Bourbon
; Date: 10. August 2004
; OS: Windows
; Demo: Yes
;

; ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
; o                                                       o
; o       Geile "Superformel" aus dem Blitz-Forum         o
; o                                                       o
; o    diese Formel gibt es übrigens auch für 3D ;o)      o
; o                                                       o
; ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

Procedure.f Super(m.f,n1.f,n2.f,n3.f,a.f,b.f,phi.f)
  ProcedureReturn Pow((Abs(Cos(m*phi/4)/a)),n2)+Pow((Abs(Pow((Sin(m*phi/4)/b),n3))),(1/-n1))
EndProcedure

If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error", "DirectX 7 oder größer wird benötigt!", 0)
  End
EndIf

var1.f = 3.11
var2.f = 9.9
var3.f = 1.4
var4.f = 3.5
var5.f = 0.2
var6.f = 1.0
col.l = 128


If OpenScreen(800, 600, 16, "Superformel")

  Repeat

    FlipBuffers()
    ClearScreen(RGB(0,0,0))

    StartDrawing(ScreenOutput())
    DrawText(5,  5, "1.(Q/A): " + StrF(var1))
    DrawText(5, 25, "2.(W/S): " + StrF(var2))
    DrawText(5, 45, "3.(E/D): " + StrF(var3))
    DrawText(5, 65, "4.(R/F): " + StrF(var4))
    DrawText(5, 85, "5.(T/G): " + StrF(var5))
    DrawText(5, 105, "6.(X/C): " + StrF(var6))
    DrawText(5, 125, "7.(V/B): " + Str(col))
    phi.f = 0
    While phi < 360
      r.f = Super.f(var1,var2,var3,var4,var5,var6,phi)
      PunktA.f = r*Cos(phi)*10+400
      PunktB.f = -r*Sin(phi)*10+300
      If (PunktA > 0 And PunktA < 800) And (PunktB > 0 And PunktB < 600)
        Plot(PunktA,PunktB, RGB(Random(col)+col, Random(col)+col, Random(col)+col))
      EndIf
      phi + 0.01
    Wend
    StopDrawing()

    ExamineKeyboard()

    If KeyboardReleased(#PB_Key_Q) : var1 + 0.01 : EndIf
    If KeyboardReleased(#PB_Key_A) : var1 - 0.01 : EndIf
    If KeyboardReleased(#PB_Key_W) : var2 + 0.1 : EndIf
    If KeyboardReleased(#PB_Key_S) : var2 - 0.1 : EndIf
    If KeyboardReleased(#PB_Key_E) : var3 + 0.1 : EndIf
    If KeyboardReleased(#PB_Key_D) : var3 - 0.1 : EndIf
    If KeyboardReleased(#PB_Key_R) : var4 + 0.1 : EndIf
    If KeyboardReleased(#PB_Key_F) : var4 - 0.1 : EndIf
    If KeyboardReleased(#PB_Key_T) : var5 + 0.1 : EndIf
    If KeyboardReleased(#PB_Key_G) : var5 - 0.1 : EndIf
    If KeyboardReleased(#PB_Key_C) : var6 + 0.1 : EndIf
    If KeyboardReleased(#PB_Key_X) : var6 - 0.1 : EndIf
    If (col+col) < 255
      If KeyboardPushed(#PB_Key_B) : col + 1 : EndIf
    EndIf
    If col > 1
      If KeyboardPushed(#PB_Key_V) : col - 1 : EndIf
    EndIf

  Until KeyboardPushed(#PB_Key_Escape)

EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -