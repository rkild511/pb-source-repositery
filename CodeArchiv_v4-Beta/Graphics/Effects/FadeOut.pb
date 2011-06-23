; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3899&highlight=
; Author. Ypser (updated for PB 4.00 by Andre)
; Date: 05. March 2004
; OS: Windows
; Demo: Yes


; FadeOut, eine Möglichkeit:
; Blende doch ein schwarzes (RGB (1, 1, 1)) gezoomtes 3D-Sprite drüber und zähl die
; Deckkraft von 0 bis 255... 

InitSprite() 
InitSprite3D() 
InitKeyboard() 
OpenScreen (800, 600, 32, "") 

CreateSprite (0, 32, 32, #PB_Sprite_Texture) 
  StartDrawing (SpriteOutput(0)) 
  Box (0, 0, 32, 32, RGB (1, 1, 1)) 
  StopDrawing () 
CreateSprite3D (0, 0) 
Start3D (): ZoomSprite3D (0, 800, 600): Stop3D () 

SetFrameRate (40) 

FadeOut = 0 

Repeat 
  StartDrawing (ScreenOutput ()): DrawingMode (1) 
    Box (0, 0, 800, 600, RGB (0, 0, 255)) 
    FrontColor (RGB(255, 255, 255))
    DrawText (20, 20, "[SPACE] drücken für FadeOut") 
  StopDrawing () 
  
  If FadeOut 
    If (FadeOut < 255): FadeOut + 3: EndIf 
    Start3D () 
    DisplaySprite3D (0, 0, 0, FadeOut) 
    Stop3D () 
    If FadeOut > 255: FadeOut = 0: EndIf 
  EndIf 
  FlipBuffers () 
  
  ExamineKeyboard () 
  If KeyboardReleased(#PB_Key_Space): FadeOut = 1: EndIf 
Until KeyboardReleased (#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -