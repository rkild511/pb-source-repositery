; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6534&highlight=
; Author: Num3 (updated for PB4.00 by blbltheworm)
; Date: 12. June 2003
; OS: Windows
; Demo: No

; Note: coloring doesn't work with enabled XP-Skin support!

Declare Open_Window_0() 

;- Window Constants 
; 
#Window_0  = 0 
#PBM_SETBARCOLOR = $409 
#PBM_SETBKCOLOR = $2001 
;- Gadget Constants 
; 
#Gadget_0  = 0 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 251, 249, 300, 100, "Colored Progress Bar", #PB_Window_SystemMenu  | #PB_Window_SizeGadget  | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ProgressBarGadget(#Gadget_0, 10, 10, 190, 10, 0, 100 ,#PB_ProgressBar_Smooth)        
      PostMessage_(GadgetID(#Gadget_0), #PBM_SETBARCOLOR, 0, RGB(255, 204, 51)) 
      PostMessage_(GadgetID(#Gadget_0), #PBM_SETBKCOLOR, 0, RGB(51, 102, 153)) 
      SetGadgetState(#Gadget_0,80)  
      
    EndIf 
  EndIf 
EndProcedure 


Open_Window_0() 
Repeat 
  Event  = WaitWindowEvent() 
  
  
Until Event  = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
