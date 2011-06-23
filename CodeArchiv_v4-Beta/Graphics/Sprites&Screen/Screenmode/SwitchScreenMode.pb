; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7772&highlight=
; Author: Shopro (updated for PB4.00 by blbltheworm)
; Date: 10. October 2003
; OS: Windows
; Demo: Yes

; Sample Code to Switch Screen Modes (between full screen and windowed screen)
; 2003/10/11 
; Kenji Gunn 

; Constants 
#True = 1 
#False = 0 

#Screen_Width  = 320 
#Screen_Height = 240 
#Screen_Depth  = 16 

; Variables 
Scan_Input_AltEnter.b = 0 
Scan_Event_WindowEvent.w = 0 

Screen_Fullscreen.b = 0 

; Open Window 
OpenWindow(0, 0, 0, #Screen_Width, #Screen_Height, "Hit Alt + Enter to Switch Screen Modes", #PB_Window_SystemMenu) 

; Initialize DirectX 
InitSprite() 
InitKeyboard() 
OpenWindowedScreen(WindowID(0), 0, 0, 320, 240, 1, 0, 0) 

Repeat 
  
  ; Scan Key Presses and Window Events 
  ExamineKeyboard() 
  Scan_Input_AltEnter = ((KeyboardPushed(#PB_Key_LeftAlt) Or 0) Or (KeyboardPushed(#PB_Key_RightAlt) Or 0)) And (KeyboardPushed(#PB_Key_Return) Or 0) 
  Scan_Event_WindowEvent = WindowEvent() 
  
  ; Switch Screen Modes 
  If Scan_Input_AltEnter = #True 
    If Screen_Fullscreen = #True 
       Screen_Fullscreen = #False 
       CloseScreen() 
       OpenWindow(0, 0, 0, #Screen_Width, #Screen_Height, "Hit Alt + Enter to Switch Screen Modes", #PB_Window_SystemMenu) 
       OpenWindowedScreen(WindowID(0), 0, 0, #Screen_Width, #Screen_Height, 0, 0, 0) 
     ElseIf Screen_Fullscreen = #False 
      Screen_Fullscreen = #True 
      CloseWindow(0) 
      CloseScreen() 
      OpenScreen(#Screen_Width, #Screen_Height, #Screen_Depth, "Hit Alt + Enter to Switch Screen Modes") 
    EndIf 
  EndIf 

  ; Flip Buffers 
  StartDrawing(ScreenOutput())
    Circle(#Screen_Width/2,#Screen_Height/2,50,255)
  StopDrawing()
  FlipBuffers() 
  
Until KeyboardPushed(#PB_Key_Escape) Or Scan_Event_WindowEvent = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
