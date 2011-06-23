; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3285&highlight=
; Author: nicolaus
; Date: 30. December 2003
; OS: Windows
; Demo: No

#IMAGE=1 
Global TrackFlag.l 

Procedure WindowProc(hwnd,Msg,wParam,lParam) 
  
  Shared WindowProc_ImageInMove 
  
  Select Msg 
    Case #WM_LBUTTONDOWN 
      WindowProc_ImageInMove = 1 
    Case #WM_LBUTTONUP 
      WindowProc_ImageInMove = 0 
    Case #WM_MOUSEMOVE 
      If ChildWindowFromPoint_(hwnd,lParam & $FFFF,(lParam>>16) & $FFFF) = GadgetID(1) And wParam&#MK_LBUTTON And WindowProc_ImageInMove 
        y = ((lParam>>16)&$FFFF)-GadgetHeight(1)/2 
        ; Debug y 
        If y > 160 Or y = 160 Or y < 1 Or y = 1 
          WindowProc_ImageInMove = 0 
          TrackFlag = 0 
        Else 
          ResizeGadget(1,100,y,#PB_Ignore,#PB_Ignore) 
          TrackFlag = 1 
        EndIf 
      Else 
        WindowProc_ImageInMove = 0 
        TrackFlag = 0 
      EndIf 
      
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

wnd = OpenWindow(0,0,0,400,200, "Test",#WS_POPUP | #PB_Window_ScreenCentered | #PB_Window_WindowCentered) 
CreateGadgetList(WindowID(0)) 
ButtonGadget(0,10,0,80,20,"Show Pic") 
ButtonGadget(2,10,30,80,20,"Close") 

Repeat 
  x_mouse = WindowMouseX(0) 
  y_mouse = WindowMouseY(0) 
  
  EventID.l = WindowEvent() 
    If EventID = #PB_Event_Gadget 
      Select EventGadget()  
        Case 0 
          LoadImage(#IMAGE,"..\..\Graphics\Gfx\PB.bmp") 
          ImageGadget(#IMAGE,100,50,80,20,ImageID(#IMAGE)) 
          DisableGadget(#IMAGE,1)
        Case 2 
          End 
      EndSelect 
    EndIf 
    ; Debug TrackFlag 
    If EventID = #WM_LBUTTONDOWN And x_mouse < 121 And x_mouse > 100 And y_mouse < 180 And y_mouse > 1 
      TrackFlag = 1 
      SetWindowCallback(@WindowProc()) 
    EndIf 
    If EventID = #WM_LBUTTONDOWN  And TrackFlag = 0 
      ReleaseCapture_() 
      SendMessage_(wnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
    EndIf 
  Delay(1) 

Until quit = 1 
End                    

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
