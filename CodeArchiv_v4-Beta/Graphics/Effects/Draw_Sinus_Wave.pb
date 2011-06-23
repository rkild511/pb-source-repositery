; English forum:
; Author: merendo (updated for PB4.00 by blbltheworm)
; Date: 30. May 2003
; OS: Windows
; Demo: No

If InitSprite() And OpenWindow(0,0,0,640,480,"SineWave",#PB_Window_SystemMenu) And OpenWindowedScreen(WindowID(0),0,0,640,480,0,0,0) 
  #ToRad = 0.017453 
  Repeat 
    Sleep_(1) 
      x+1 
      If x>640:x=0:EndIf 
        StartDrawing(ScreenOutput()) 
          Plot(x,Sin(x*#ToRad)*100+100,65280) 
        StopDrawing() 
      FlipBuffers() 
  Until WindowEvent()=#PB_Event_CloseWindow 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -