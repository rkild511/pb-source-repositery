; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2439&postdays=0&postorder=asc&start=10
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 04. October 2003
; OS: Windows
; Demo: No

If CreateImage(0,400,400) 
  hDC=StartDrawing(ImageOutput(0)) 
  pen=CreatePen_(#PS_SOLID,20,RGB(255,255,255)) 
  oldpen=GetCurrentObject_(hDC,#OBJ_PEN) 
  SelectObject_(hDC,pen) 
  Line(0,0,400,400) 
  SelectObject_(hDC,oldpen) 
  DeleteObject_(pen) 
  StopDrawing() 
  
  If OpenWindow(1,0,0,400,400,"Pen-Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
    If CreateGadgetList(WindowID(1)) 
      ImageGadget(0,0,0,400,400,ImageID(0)) 
      While WaitWindowEvent()<>#PB_Event_CloseWindow:Wend 
      CloseWindow(1) 
    EndIf 
  EndIf 
  FreeImage(0) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
