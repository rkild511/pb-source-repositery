; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1764
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 21. July 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 21.07.2003 - german forum 
; 
; Resize ScrollArea in ScrollAreaGadget at runtime, PB 3.70. 
; So kann man die ScrollArea in einem ScrollAreaGadget zur Laufzeit verändern. 

Procedure ResizeScrollArea(Gadget,ScrollAreaWidth,ScrollAreaHeight) 
  Structure PB_ScrollAreaData 
    ScrollAreaChild.l; 
    ScrollStep.l; 
  EndStructure 
  hScrollArea = GadgetID(Gadget) 
  *SAGdata.PB_ScrollAreaData = GetWindowLong_(hScrollArea,#GWL_USERDATA) 
  If *SAGdata 
    GetClientRect_(hScrollArea,client.RECT) 
    MoveWindow_(*SAGdata\ScrollAreaChild,0,0,ScrollAreaWidth,ScrollAreaHeight,#True) 
    SI.SCROLLINFO 
    SI\cbSize = SizeOf(SCROLLINFO); 
    SI\fMask  = #SIF_PAGE|#SIF_POS|#SIF_RANGE; 
    SI\nMin   = 0; 
    SI\nMax   = ScrollAreaHeight-1; 
    SI\nPage  = client\bottom; 
    SI\nPos   = 0; 
    SetScrollInfo_(hScrollArea,#SB_VERT,@SI,#True); 
    SI\nMax   = ScrollAreaWidth-1; 
    SI\nPage  = client\right; 
    SetScrollInfo_(hScrollArea,#SB_HORZ,@SI,#True); 
  EndIf 
EndProcedure 

MainWnd.l = OpenWindow( 0,0,0,300,300,"PB_Scrollbar",#PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID( 0)) 
  ScrollAreaGadget(1,0,0,300,300,500,500,10,#PB_ScrollArea_BorderLess) 
    ButtonGadget(2,400,480,100,20,"Test") 
  CloseGadgetList() 
  
  ResizeScrollArea(1,510,510) 

Repeat 
  Select WaitWindowEvent(): 
     Case #PB_Event_CloseWindow: End 
     Case #PB_Event_Gadget 
  EndSelect 
ForEver 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
