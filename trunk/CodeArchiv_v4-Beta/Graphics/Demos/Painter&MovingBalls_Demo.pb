; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3152&highlight=
; Author: Marcus (updated for PB4.00 by blbltheworm)
; Date: 16. December 2003
; OS: Windows
; Demo: No


;- Marcus 14.12.2003 
;- Danilo schrieb viele Programmteile 
;- Ball Demo Autor: Pride; Datum: 04.10.02; Forum: Deutsches Forum 

Declare Move_Balls() 
Declare Draw_Balls() 

Global Dim ball_x.l(40) 
Global Dim ball_y.l(40) 
Global Dim ball_speed_x.l(40) 
Global Dim ball_speed_y.l(40) 

For b = 0 To 40 
  ball_x(b) = Random(600) 
  ball_y(b) = Random(500) 
  ball_speed_x(b) = Random(15) 
  ball_speed_y(b) = Random(15) 
Next 
Procedure Move_Balls() 
  For b = 0 To 40 
    ball_x(b) = ball_x(b) + ball_speed_x(b) 
    ball_y(b) = ball_y(b) + ball_speed_y(b) 
    If ball_x(b) > 750     : ball_speed_x(b) =- ball_speed_x(b) :EndIf 
    If ball_x(b) < 0       : ball_speed_x(b) =- ball_speed_x(b) :EndIf 
    If ball_y(b) > 600     : ball_speed_y(b) =- ball_speed_y(b) :EndIf 
    If ball_y(b) < 0       : ball_speed_y(b) =- ball_speed_y(b) :EndIf 
  Next 
EndProcedure 
Procedure Draw_Balls() 
  For b = 0 To 20      
    Circle(ball_x(b),ball_y(b),Random(40),Random(250)) 
  Next 
EndProcedure 

;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Gadget_Pen 
  #Gadget_Balls 
EndEnumeration 

Procedure Open_Window_0() 
  If InitSprite() And InitMouse() 
    If OpenWindow(#Window_0, 100, 5, 655, 555, "New window ( 0 )", #PB_Window_SystemMenu  | #PB_Window_SizeGadget  | #PB_Window_TitleBar ) 
      If CreateGadgetList(WindowID(#Window_0)) 
        ButtonGadget(#Gadget_Balls,  5, 5, 40, 40, "Balls") 
        ButtonGadget(#Gadget_Pen,  50, 5, 40, 40, "Pen") 
      EndIf 
      OpenWindowedScreen(WindowID(#Window_0),50, 50, 600, 500, 0,0,0) 
    EndIf 
  EndIf 
EndProcedure 

Procedure WindowClientMouseX(win)             ; added param, 11.12.03 
  ; Returns X-Position of MouseCursor 
  ; in the current window's client area 
  ; or -1 if mouse cursor isnt in this area. 
  GetCursorPos_(mouse.POINT) 
  ScreenToClient_(WindowID(win),mouse) 
  GetClientRect_(WindowID(win),rect.RECT) 
  If mouse\x < 0 Or mouse\x > rect\right 
    ProcedureReturn -1 
  ElseIf mouse\y < 0 Or mouse\y > rect\bottom ; added 11.12.03 
    ProcedureReturn - 1 
  Else 
    ProcedureReturn mouse\x 
  EndIf 
EndProcedure 

Procedure WindowClientMouseY(win)             ; added param, 11.12.03 
  ; Returns Y-Position of MouseCursor 
  ; in the current window's client area 
  ; or -1 if mouse cursor isnt in this area. 
  GetCursorPos_(mouse.POINT) 
  ScreenToClient_(WindowID(win),mouse) 
  GetClientRect_(WindowID(win),rect.RECT) 
  If mouse\y < 0 Or mouse\y > rect\bottom 
    ProcedureReturn -1 
  ElseIf mouse\x < 0 Or mouse\x > rect\right  ; added 11.12.03 
    ProcedureReturn - 1 
  Else 
    ProcedureReturn mouse\y 
  EndIf 
EndProcedure 

ButtonNo.w=1 
mousedownpressed.w=0 
mouseuppressed.w=1 
Open_Window_0() 
SetFrameRate(85) ;- Framerate 
StartDrawing(ScreenOutput()) 
PixelFormat  = DrawingBufferPixelFormat() 
Pitch        = DrawingBufferPitch() 
StopDrawing() 
ClearScreen(RGB(0,0,0)) 

Repeat 
  mx.w=WindowClientMouseX(#Window_0)-50 
  my.w=WindowClientMouseY(#Window_0)-50 
  
  ;EventID  =  WaitWindowEvent() 
  EventID  =  WindowEvent() 
  If EventID  = #PB_Event_Gadget 
    ;Debug "WindowID: " + Str(EventWindowID()) 
    GadgetID  = EventGadget() 
    ;- #Gadget_Pen 
    If GadgetID = #Gadget_Pen 
      ButtonNo=1 
      ;- #Gadget_Balls  
    ElseIf GadgetID  = #Gadget_Balls 
      ButtonNo=2 
    EndIf 
    
    ;- #WM_LBUTTONDOWN" 
  ElseIf EventID=#WM_LBUTTONDOWN 
    Debug "GadgetID: #WM_LBUTTONDOWN" 
    If mouseuppressed=1 
      If mx>=0 And mx=<600 And my>=0 And my=<500 
        MousePosDownX.w=mx 
        MousePosDownY.w=my 
        mousedownpressed=1 
        mouseuppressed=0 
      EndIf 
    EndIf 
    ;- #WM_LBUTTONUP" 
  ElseIf EventID=#WM_LBUTTONUP 
    Debug "GadgetID: #WM_LBUTTONUP" 
    If mousedownpressed=1 
      If mx>=0 And mx=<600 And my>=0 And my=<500 
        MousePosUpX.w=mx 
        MousePosUpY.w=my 
        mousedownpressed=0 
        mouseuppressed=1 
      EndIf 
    EndIf 
    
  EndIf 
  
  If ButtonNo=2 Or (ButtonNo=1 And mousedownpressed=1) 
    ClearScreen(RGB(0,0,0)) 
  EndIf 
  
  StartDrawing(ScreenOutput()) 
  
  For x.w=25 To 575 Step 25 
    For y.w=25 To 475 Step 25 
      Box(x-1,y-1,3,3,RGB(0,0,255)) 
    Next 
  Next 
  FrontColor(RGB($00,$FF,$00)) 
  If mousedownpressed=1 
    DrawingMode(0|4) 
    Box(MousePosDownX,MousePosDownY,mx-MousePosDownX,my-MousePosDownY,RGB(255,0,0)) 
  ElseIf mouseuppressed=1 
    DrawingMode(0|1) 
    Box(MousePosDownX,MousePosDownY,MousePosUpX-MousePosDownX,MousePosUpY-MousePosDownY,RGB(255,0,0)) 
    FrontColor(RGB($FF,$FF,$00)) 
    DrawText(50,90,"Pixel pos" + Str(MousePosUpX-MousePosDownX) + " , " + Str(MousePosUpY-MousePosDownY)) 
  EndIf 
  DrawingMode(1) 
  FrontColor(RGB($FF,$FF,$00)) 
  DrawText(50,10,"Pixel pos" + Str(mx.w) + " , " + Str(my.w)) 
  DrawText(50,30,"Pixel pos" + Str(MousePosDownX.w) + " , " + Str(MousePosDownY.w)) 
  DrawText(50,50,"Pixel pos" + Str(MousePosUpX.w) + " , " + Str(MousePosUpY.w)) 
  DrawText(50,70,"Pixel pos" + Str(mx-MousePosDownX) + " , " + Str(my-MousePosDownY)) 
  
  If ButtonNo=1 
    If mx>=0 And mx=<600 And my>=0 And my=<500 
      *Screen.LONG = DrawingBuffer() 
      *Screen + (Pitch*my)+(mx*4) 
      If PixelFormat = #PB_PixelFormat_32Bits_RGB 
        *Screen\l = $FFFF0000 
      ElseIf PixelFormat = #PB_PixelFormat_32Bits_BGR 
        *Screen\l = $00FFFF00 
      EndIf 
    EndIf 
  EndIf 
  
  If ButtonNo=2 
    Draw_Balls() 
  EndIf 
  StopDrawing() 
  FlipBuffers() 
  If ButtonNo=2 
    Move_Balls() 
  EndIf 
Until EventID  = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
