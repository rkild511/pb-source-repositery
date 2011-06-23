; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1925&highlight=
; Author: Darie (improved by ChaosKid, updated for PB4.00 by blbltheworm)
; Date: 05. August 2003
; OS: Windows
; Demo: Yes


InitSprite()
OpenScreen(800,600,16,"")
InitKeyboard()

Kreise.w  = 500
Abstand.b = 2
Delay.w   = 1

Repeat
  
  x1.w       = Random(800)
  y1.w       = Random(600)
  
  Rnd = Random(1)
  If Rnd = 0
    Rnd = 1
  Else
    Rnd = 2
  EndIf
  x2.w       = x1 + Rnd
  
  Farbe1_R.w = Random(255)
  Farbe1_G.w = Random(255)
  Farbe1_B.w = Random(255)
  
  Farbe2_R.w = Random(255)
  Farbe2_G.w = Random(255)
  Farbe2_B.w = Random(255)
  
  For Radius.w = 1 To Kreise
    
    ExamineKeyboard()
    StartDrawing(ScreenOutput())
    DrawingMode(4)
    
    FrontColor(RGB(Farbe1_R,Farbe1_G,Farbe1_B))
    Circle(x1,y1, Radius * Abstand)
    
    FrontColor(RGB(Farbe2_R,Farbe2_G,Farbe2_B))
    Circle(x2,y1, (Kreise - Radius + 1) * Abstand)
    
    StopDrawing()
    FlipBuffers()
    
    If KeyboardPushed(#PB_Key_All) <> 0 : Goto Ende : EndIf
    Delay(Delay)
    
  Next Radius
  
ForEver

Ende:
CloseScreen()


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
