; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8133&highlight=
; Author: LarsG (updated for PB4.00 by blbltheworm)
; Date: 31. October 2003
; OS: Windows
; Demo: Yes


; Note: changed keyboard access to mouse access via WaitWindowEvent() by Andre

; check If directx is available (sprite, keyboard and mouse init) 
If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  MessageRequester("Error","Can't open DirectX",0) 
  End 
EndIf 

; constants 
#Window_0      = 0    ; window ID 
#SCREEN_WIDTH  = 640  ; width 
#SCREEN_HEIGHT = 480  ; height 
;apptitle 
apptitle.s = "This is my windowed screen!" 

; create window 
If OpenWindow(#Window_0, 0, 0, #SCREEN_WIDTH, #SCREEN_HEIGHT, apptitle.s,  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
EndIf 

; open screen 
If OpenWindowedScreen(WindowID(#Window_0),0,0,#SCREEN_WIDTH, #SCREEN_HEIGHT,0,0,0) 
  ; main loop 
  Repeat 
    FlipBuffers():ClearScreen(RGB(0,0,0)) 
    If StartDrawing(ScreenOutput()) 
      DrawText(250,250,"This is my screen!!! YEAH!") 
      StopDrawing() 
    EndIf 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
