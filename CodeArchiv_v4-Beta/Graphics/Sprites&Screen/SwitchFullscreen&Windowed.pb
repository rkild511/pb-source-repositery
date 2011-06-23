; www.PureArea.net 
; Author: Andre (updated for PB 4.00 by HeX0R)
; Date: 05. March 2006 
; OS: Windows, Linux, MacOS 
; Demo: Yes 

If Not InitSprite() Or Not InitKeyboard() 
   MessageRequester("Error!", "There was an error during initialization of sprite and keyboard enviroment.") 
   End 
EndIf 

ExamineDesktops() 
screenwidth  = DesktopWidth(0) : screenheight = DesktopHeight(0) : screendepth  = DesktopDepth(0) 

#Windowed   = 0 
#Fullscreen = 1 
NewMode = #Fullscreen 

Procedure.l SwitchScreen(NewMode) 
   Shared screenwidth, screenheight, screendepth 
   If NewMode = #Windowed 
      CloseScreen() 
      If OpenWindow(0, 0, 0, 260, 260, "Press F1 to switch to fullscreen...", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
         OpenWindowedScreen(WindowID(0), 0, 0, 260, 260, 0, 0, 0) 
      EndIf 
   Else   ; NewMode = #Fullscreen 
      CloseScreen() 
      CloseWindow(0) 
      OpenScreen(screenwidth, screenheight, screendepth, "Switch between fullscreen and windowed screen...") 
   EndIf 
   ProcedureReturn NewMode 
EndProcedure 

If OpenScreen(screenwidth, screenheight, screendepth, "Switch between fullscreen and windowed screen...") 

   Repeat 
      If NewMode = #Windowed 
         Event.l = WindowEvent() 
      Else 
         Event = 0 
      EndIf 
      If Event = #PB_Event_CloseWindow 
         End 
      Else 
         FlipBuffers() 
         ClearScreen(RGB(0, 0, 0)) 
         StartDrawing(ScreenOutput()) 
            Box(30, 30, 200, 200, RGB(255, 255, 255)) 
            Circle(130, 130, 70, RGB(255, 0, 0)) 
            DrawingMode(1) 
            If NewMode = #Fullscreen 
              DrawText(5, 5, "Press F1 to switch to windowed screen...", RGB(255, 255, 255)) 
            Else
              DrawText(5, 5, "Press F1 to switch to fullscreen...", RGB(255, 255, 255)) 
            EndIf
         StopDrawing() 

         ExamineKeyboard() 
         If KeyboardReleased(#PB_Key_F1) 
            If NewMode = #Fullscreen 
               ; If IsScreenActive()   ; fullscreen is active 
               ; Debug 1 
               NewMode = SwitchScreen(#Windowed) 
            Else 
               ; Debug 0             ; windowed mode is active 
               NewMode = SwitchScreen(#Fullscreen) 
            EndIf 
         EndIf 

         If KeyboardPushed(#PB_Key_Escape) 
            End 
         EndIf 

      EndIf 

   ForEver 

   End 

EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP