; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9150&highlight=
; Author: localmotion34 (updated for PB4.00 by blbltheworm)
; Date: 15. January 2004
; OS: Windows
; Demo: Yes


; PureBasic Visual Designer v3.82 build 1344 

Global window,button,frame 
;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Button_0 
  #Frame3D_0 
EndEnumeration 

window=#Window_0   ;set our variable starting with the original values 
button=#Button_0   ; 
frame=#Frame3D_0   ; 
Procedure Open_Window_0() 
  Windowtext$="Window" +" " + Str(window+1) 
  If OpenWindow(window, 216, 0, 600, 300, Windowtext$,  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(window)) 
      ButtonGadget(button, 80, 100, 120, 40, "Clone Me!!!") 
      Frame3DGadget(frame, 30, 60, 230, 140, "Button") 
      
    EndIf 
  EndIf 
  window=window+1 ;now we add 1 to the values we set before so we dont reuse them 
  button=button+2 ; we make sure we step 1 above the follwing frame gadget value 
  frame=frame+2   ; 

EndProcedure 

Open_Window_0() 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    GadgetID = EventGadget() 
    
    For a=0 To button Step 2 ;since #button_0 = 0 at the beginning, we have to step 2 values above because 
      If GadgetID=a         ;frame3d_0 is always button+1 
          Open_Window_0() 
        EndIf 
      Next 

    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
