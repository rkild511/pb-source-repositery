; German forum: http://www.purebasic.fr/german/viewtopic.php?t=673&highlight=
; Author: Sunny (updated for PB 4.00 by Andre)
; Date: 30. October 2004
; OS: Windows
; Demo: 
; OS; Windows, Linux
; Demo: Yes

; Sinus test: Oscillation
; Sinus-Test: Schwingung

InitSprite() : InitKeyboard() 

OpenScreen(1024, 768, 32, "Sinus-Test") 

CreateSprite(0, 10, 10) 

Repeat 

  ClearScreen(RGB(100,122,130)) 
  
  x = x + 1 
  DisplaySprite(0, 512, (100* Sin(x/100)) + 384) 

  FlipBuffers(0) 
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) 
    quit = #True 
  EndIf 
Until quit = #True

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
