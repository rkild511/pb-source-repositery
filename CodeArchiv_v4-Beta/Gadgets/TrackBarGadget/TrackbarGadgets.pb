; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=775&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 27. April 2003
; OS: Windows
; Demo: No

Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select EventGadget() 
    Case 6 
      SetFocus_(WindowID(1)) 
    Case 7 
      SetFocus_(WindowID(1)) 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 


OpenWindow(1, 0, 0, 1024, 768, "Trackbar probleme", #PB_Window_SystemMenu) 
CreateGadgetList(WindowID(1)) 
  
TrackBarGadget(6, 210, 490, 200, 50, 4, 20,#PB_TrackBar_Ticks) 
TrackBarGadget(7, 400, 300, 50, 200, 4, 20,#PB_TrackBar_Ticks|#PB_TrackBar_Vertical) 

horizontal=10 
vertical=10 

TextGadget(9, 280, 410, 50, 30, Str(horizontal)+" x "+Str(vertical))  
gad=SetGadgetState(6,10) 
SetGadgetState(7,10) 

SetWindowCallback(@MyWindowCallback()) 

Repeat 

  event.l=WaitWindowEvent() 
  If event.l = #PB_Event_Gadget 
    If EventGadget()=6 
      horizontal=GetGadgetState(6) 
      SetGadgetText(9,Str(horizontal)+" x "+Str(vertical)) 
    EndIf    
    If EventGadget()=7 
      vertical=GetGadgetState(7) 
      SetGadgetText(9,Str(horizontal)+" x "+Str(vertical)) 
    EndIf 
  EndIf 
  
Until event.l = #WM_CLOSE
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
