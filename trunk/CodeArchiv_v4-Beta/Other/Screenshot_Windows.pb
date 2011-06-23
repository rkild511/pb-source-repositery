; German forum: 
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No

;Bitmap anlegen 
CreateImage(0,GetSystemMetrics_(#SM_CXSCREEN),GetSystemMetrics_(#SM_CYSCREEN)) 
;auf angelegtes Bitmap zeichnen 
DC = StartDrawing(ImageOutput(0)) 
BitBlt_(DC,0,0,ImageWidth(0),ImageHeight(0),GetDC_(GetDesktopWindow_()),0,0,#SRCCOPY ) 
StopDrawing() 

;Bitmap an Fenstergroesse anpassen 
ResizeImage(0,640,480) 

If OpenWindow(0, 10, 10, 640, 480, "Screenshot", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
StartDrawing(WindowOutput(0)) 
DrawImage(ImageID(0),0,0) 
StopDrawing() 
  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf 
  Until Quit = 1 
EndIf 
End  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -