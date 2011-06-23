; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1996&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. August 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 21.07.2003 - german forum 
;   changed by Danilo on 18.08.2003 - multi window version 
; 
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
      Case WindowID(1) 
        MoveWindow_(GadgetID(5),0,0,w,h,1) 
    EndSelect 
  EndIf 
  ProcedureReturn Result 
EndProcedure 


  AreaX = GetDesktopWidth() 
  AreaY = GetDesktopHeight() 

  hImg = CreateImage(0,AreaX,AreaY) 
  StartDrawing(ImageOutput(0)) 
    For x = 0 To AreaX Step 100 
     For y = 0 To AreaY Step 100 
       Box(x   ,y   ,48,48,RGB($24,$55,$9E)) 
       Box(x+50,y   ,48,48,RGB($FF,$FF,$FF)) 
       Box(x   ,y+50,48,48,RGB($FF,$FF,$00)) 
       Box(x+50,y+50,48,48,RGB($0C,$A0,$F3)) 
     Next y 
    Next x 
  StopDrawing() 

OpenWindow(0,0,0,300,300,"PB_Scrollbar",#PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ScrollAreaGadget(0,0,0,WindowWidth(0),WindowHeight(0),AreaX,AreaY,10,#PB_ScrollArea_BorderLess) 
    ImageGadget(1,0,0,AreaX,AreaY,hImg) 
    ButtonGadget(2,AreaX-100,AreaY-20,100,20,"Exit") 
  CloseGadgetList() 

OpenWindow(1,0,0,300,300,"PB_Scrollbar 2",#PB_Window_SystemMenu|#PB_Window_SizeGadget) 
  CreateGadgetList(WindowID(1)) 
  ScrollAreaGadget(5,0,0,WindowWidth(1),WindowHeight(1),AreaX,AreaY,10,#PB_ScrollArea_BorderLess) 
    ImageGadget(6,0,0,AreaX,AreaY,hImg) 
  CloseGadgetList() 


  SetWindowCallback(@ResizeCallback()) 


Repeat 
  Select WaitWindowEvent(): 
     Case #PB_Event_CloseWindow: End 
     Case #PB_Event_Gadget 
       Select EventGadget() 
         Case 3 
           If MessageRequester("EXIT","Really quit application ?",#PB_MessageRequester_YesNo)=#IDYES 
             End 
           EndIf 
       EndSelect 
  EndSelect 
ForEver 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
