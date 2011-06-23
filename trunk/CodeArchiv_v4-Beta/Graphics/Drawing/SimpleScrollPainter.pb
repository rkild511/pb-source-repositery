; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7654&highlight=
; Author: griz (updated for PB4.00 by blbltheworm)
; Date: 27. September 2003
; OS: Windows
; Demo: No

Procedure GetMouseX(gadget) 
  GetCursorPos_(mouse.POINT) 
  MapWindowPoints_(0,GadgetID(gadget),mouse,1) 
  ProcedureReturn mouse\x 
EndProcedure 

Procedure GetMouseY(gadget) 
  GetCursorPos_(mouse.POINT) 
  MapWindowPoints_(0,GadgetID(gadget),mouse,1) 
  ProcedureReturn mouse\y 
EndProcedure 

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
    If IsGadget(1)
      MoveWindow_(GadgetID(1),0,0,w,h,1) 
    EndIf
  EndIf 
  ProcedureReturn Result 
EndProcedure 

OpenWindow( 0,0,0,300,300,"PB_Scrollpaint",#PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID( 0)) 
  SetWindowCallback(@ResizeCallback()) 

  AreaX = GetDesktopWidth() : AreaY = GetDesktopHeight() 

  hImg = CreateImage(0,AreaX,AreaY) 
  StartDrawing(ImageOutput(0)) 
    For x = 0 To AreaX Step 40 
     For y = 0 To AreaY Step 40 
       Box(x,y,20,20,RGB(0,0,255)) : Box(x+20,y,20,20,RGB(0,0,180)) 
       Box(x,y+20,20,20,RGB(0,0,128)) : Box(x+20,y+20,20,20,RGB(0,0,80)) 
     Next y 
    Next x 
  StopDrawing() 

  ScrollAreaGadget(1,0,0,WindowWidth( 0),WindowHeight( 0),AreaX,AreaY,10,#PB_ScrollArea_BorderLess) 
    ImageGadget(2,0,0,AreaX,AreaY,hImg)  
  CloseGadgetList() 

pendown=0 

Repeat 
  Select WaitWindowEvent(): 
     Case #PB_Event_CloseWindow: End 
      
     Case #WM_LBUTTONDOWN 
       mx=GetMouseX(2) : my=GetMouseY(2) 
       mxx=(mx/20)*20 : myy=(my/20)*20 
       StartDrawing(ImageOutput(0)) 
          Box(mxx,myy,20,20,RGB(255,180,0)) 
       StopDrawing() 
       SetGadgetState(2, ImageID(0)) 
       pendown=1 
      
     Case #WM_LBUTTONUP 
       pendown=0 

     Case #WM_MOUSEMOVE 
       If pendown=1 
         mx=GetMouseX(2) : my=GetMouseY(2) 
         mxx=(mx/20)*20 : myy=(my/20)*20 
         StartDrawing(ImageOutput(0)) 
            Box(mxx,myy,20,20,RGB(255,180,0)) 
         StopDrawing() 
       SetGadgetState(2, ImageID(0)) 
       EndIf 
      
     Case #PB_Event_Gadget 
       Select EventGadget() 
         Case 3 
             End 
       EndSelect 
  EndSelect 
ForEver 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
