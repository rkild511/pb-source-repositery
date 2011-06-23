; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1372&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 17. June 2003
; OS: Windows
; Demo: Yes


; Wenn man SpecialFX benutzen will, sollte ClearScreen() in der SpecialFX Routine sein.
; If you want to use the SpecialFX, then ClearScreen() should be inside the SpecialFX routine.

If InitSprite() = 0 
  End 
EndIf 
  
OpenWindow(0, 0, 0, 200, 200, "DisplayTranslucideSprite-Effekt", #PB_Window_MinimizeGadget| #PB_Window_ScreenCentered) 
If OpenWindowedScreen(WindowID(0), 0, 0, 200, 200, 0, 0, 0) 
  CreateSprite(0, 50, 50) 
  CreateSprite(1, 50, 50) 
  StartDrawing(SpriteOutput(0)) 
    Box(0, 0, 50, 50, RGB(255, 255, 255)) 
  StopDrawing() 
  StartDrawing(SpriteOutput(1)) 
    Box(0, 0, 50, 50, RGB(0, 0, 255)) 
  StopDrawing()  
EndIf 

Repeat 
    
  StartSpecialFX() 
    ClearScreen(RGB(0,0,0)) 
    DisplaySprite(0, 10, 10) 
    DisplayTranslucentSprite(1, 20, 20, 50) 
  StopSpecialFX() 
  DisplaySprite(0, 10, 70) 
  DisplayTranslucentSprite(1, 20, 80, 50) 
  
  FlipBuffers() 
  
  EventID = WaitWindowEvent() 
Until EventID = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
