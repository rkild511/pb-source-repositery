; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9145&highlight=
; Author: Uncle B (updated for PB4.00 by blbltheworm)
; Date: 14. January 2004
; OS: Windows
; Demo: No

Procedure GetDesktopWidth() 
  ProcedureReturn GetSystemMetrics_(#SM_CXSCREEN) 
EndProcedure 

Procedure GetDesktopHeight() 
  ProcedureReturn GetSystemMetrics_(#SM_CYSCREEN) 
EndProcedure 

Procedure ResizeCallback(hWnd,Msg,wParam,lParam) 
  Result = #PB_ProcessPureBasicEvents 
  If Msg = #WM_SIZE 
    w = lParam & $FFFF 
    h = (lParam >> 16 ) & $FFFF 
    Select hWnd 
      Case WindowID(0) 
        MoveWindow_(GadgetID(0),0,0,w,h,1) 
      
    EndSelect 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

  AreaX = GetDesktopWidth() 
  AreaY = GetDesktopHeight() 



OpenWindow(0,0,0,500,300,"PB_Scrollbar",#PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_ScreenCentered | #PB_Window_MaximizeGadget) 
  CreateGadgetList(WindowID(0)) 
    ScrollAreaGadget(0,0,0,WindowWidth(0),WindowHeight(0),AreaX,AreaY,10,#PB_ScrollArea_Single) 
      Gosub scrollareagadgets    
    CloseGadgetList() 



  SetWindowCallback(@ResizeCallback()) 


Repeat 
  Select WaitWindowEvent(): 
     Case #PB_Event_CloseWindow: End 
      
      
     Case #PB_Event_Gadget 
       Select EventGadget() 
         Case 2 
           If MessageRequester("EXIT","Really quit application ?",#PB_MessageRequester_YesNo)=#IDYES 
             End 
           EndIf 
         EndSelect    
       EndSelect 
        
    ; case #PB_event_menu......bla bla bla... 
    
        
ForEver 
End 


scrollareagadgets: 

ButtonGadget(2,AreaX-150,AreaY-50,100,20,"Exit") 

Return 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
