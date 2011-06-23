; English forum:
; Author: Unknown (updated to PB4 by ste123 + Andre)
; Date: 04. April 2003
; OS: Windows
; Demo: No

Global ToolTipControl

Procedure AddButtonToolTip(Handle,Text$)
  #TTS_BALLOON = $40
  ToolTipControl=CreateWindowEx_(0,"tooltips_class32","",$D0000000|#TTS_BALLOON,0,0,0,0,WindowID(1),0,GetModuleHandle_(0),0) 
  SendMessage_(ToolTipControl,1044,0 ,0) ;ForeColor Tooltip
  SendMessage_(ToolTipControl,1043,$58F5D6,0) ;BackColor Tooltip
  SendMessage_(ToolTipControl,1048,0,180) ;Maximum Width of tooltip
  Button.TOOLINFO\cbSize=84 ; SizeOf( TOOLINFO )
  Button\uFlags=$11
  Button\hWnd=Handle
  Button\uId=Handle
  Button\lpszText=@Text$
  SendMessage_(ToolTipControl,$0404,0,Button)
  ProcedureReturn ToolTipControl ; Return the handle !
EndProcedure

LoadFont(0, "Times New Roman", 16)

OpenWindow(1, 0, 0, 796, 550, "Background image example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget)
CreateGadgetList(WindowID(1))

CreateImage(1, WindowWidth(1), WindowHeight(1))
StartDrawing(ImageOutput(1))
  Box(0, 0, WindowWidth(1), WindowHeight(1), $ff)
  FrontColor( RGB(0, 0, 0) )
  DrawingMode(1)
  DrawingFont(FontID(0))
  DrawText(64,32,"Background image")
StopDrawing()

ImageGadget(1, 0, 0, WindowWidth(1), WindowHeight(1), ImageID(1))
DisableGadget(1, 1)
ButtonGadget = ButtonGadget(0, 80, 64, 160, 128, "My Button")
ButtonGadgettwo = ButtonGadget(2, 80, 204, 160, 128, "My Button Two")
ToolTipHandle1 = AddButtonToolTip(ButtonGadget,"Test message for Button 1")
ToolTipHandle2 = AddButtonToolTip(ButtonGadgettwo,"Test message for Button 2")
LoadFont(0, "Times New Roman", 16)

Repeat
  EventID = WaitWindowEvent()
  If EventID = #PB_Event_Gadget
    Select EventGadget()
      
      Case 0
        Gosub UpdateWindow
      
      Case 2
        Gosub UpdateWindow
    
    EndSelect
  EndIf
Until EventID = #PB_Event_CloseWindow
End

UpdateWindow:
  DestroyWindow_(ToolTipHandle1)
  DestroyWindow_(ToolTipHandle2)
  FreeGadget (0):FreeGadget(2)
  ImageID(1)
  StartDrawing(ImageOutput(1))
  Box(0, 0, WindowWidth(1), WindowHeight(1), $ff)
  FrontColor( RGB(0, 0, 0) )
  DrawingMode(1)
  DrawingFont(FontID(0))
  DrawText(64,32,"Test image")
  StopDrawing()
  ButtonGadget = ButtonGadget(0, 80, 64, 160, 128, "My Button")
  ButtonGadgettwo = ButtonGadget(2, 80, 204, 160, 128, "My Button Two")
  ToolTipHandle1 = AddButtonToolTip(ButtonGadget,"Test message for Button 1")
  ToolTipHandle2 = AddButtonToolTip(ButtonGadgettwo,"Test message for Button 2")
  SetGadgetState(1, ImageID(1))
  SetActiveGadget(0);
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -