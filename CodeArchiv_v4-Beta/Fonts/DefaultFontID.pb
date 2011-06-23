; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3044&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 06. December 2003
; OS: Windows
; Demo: No


Procedure DefaultFontID() 
  ProcedureReturn GetStockObject_(#SYSTEM_FONT) 
EndProcedure 

OpenWindow(0,0,0,450,200,"test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

StartDrawing(WindowOutput(0)) 
  DrawingMode(1) 

  DrawText(5,5,"default") 

  DrawingFont(LoadFont(1,"Lucida Console",14)) 
  DrawText(5,22,"Lucida Console 14") 

  DrawingFont(LoadFont(2,"Courier New",35)) 
  DrawText(5,35,"Courier New 35") 

  DrawingFont(DefaultFontID()) 
  DrawText(5,77,"default") 

StopDrawing() 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
