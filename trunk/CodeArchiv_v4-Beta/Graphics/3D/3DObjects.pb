; English forum: 
; Author: Franco (updated for PB4.00 by benny)
; Date: 31. December 2004
; OS: Windows
; Demo: No

 
; 3D_Example coded by Franco 
; based on an initial isometric 3D-code from Deeém2031 (german forum) 
 
;#PI = 3.1415626 
 
;Don't know what this is... anyway: 
;good visual results for CAD with 36000 
Constant.f=360 * 360 ; to be on the save side... 
 
;For gaming: 2.828 -> isometric 
;Constant.f = 2 * Sqr(2) 
 
Global _sin.f, _cos.f
Dim _sin.f(360) 
Dim _cos.f(360) 
 
CameraPosition.f = 18 
 
Procedure d_init3d(ScreenWidth.l,ScreenHeight.l) 
  
  ; write sin und cos in Array 
 
;  Dim _sin.f(360) 
;  Dim _cos.f(360) 
  Shared _sin(), _cos()
 

  For i = 0 To 360 
    _sin(i) = Sin(i/(180/#PI)) 
    _cos(i) = Cos(i/(180/#PI)) 
  Next i 
  
  ; Screen stuff... 
  Global ScreenWidth2.l 
  Global ScreenHeight2.l 
 
  ScreenWidth2.l = Round((ScreenWidth/2),0) 
  ScreenHeight2.l = Round((ScreenHeight/2),0) 
  
  Global wx.l 
  Global wy.l 
  Global wz.l 
 
EndProcedure 
 
Procedure.f CalcXRotation(x.f,y.f,z.f) 
  Shared _cos(), _sin()
  Result.f = _cos(wy) * _cos(wz) * x - _cos(wy) * _sin(wz) * y + _sin(wy) * z 
  ProcedureReturn Result 
EndProcedure 
 
Procedure.f CalcYRotation(x.f,y.f,z.f) 
  Shared _cos(), _sin()
  Result.f =  (_cos(wx) * _sin(wz) + _sin(wx) * _sin(wy) * _cos(wz)) * x + (_cos(wx) * _cos(wz) - _sin(wx) * _sin(wy) * _sin(wz)) * y - _sin(wx) * _cos(wy) * z 
  ProcedureReturn Result 
EndProcedure 
 
Procedure.f CalcZRotation(x.f,y.f,z.f) 
  Shared _cos(), _sin()
  Result.f =  (_sin(wx) * _sin(wz) - _cos(wx) * _sin(wy) * _cos(wz)) *y + (_sin(wx) * _cos(wz) + _cos(wx) * _sin(wy) * _sin(wz)) * y + _cos(wx) * _cos(wy) * z 
  ProcedureReturn Result 
EndProcedure 
 
Procedure CheckXRotation(x.l) 
  If x >= 360 
    Repeat 
      x - 360 
    Until x >= 0 And x < 360 
  EndIf 
  If x < 0 
    Repeat 
      x + 360 
    Until x >= 0 And x < 360 
  EndIf 
  ProcedureReturn x 
EndProcedure 
 
Procedure CheckYRotation(y.l) 
  If y >= 360 
    Repeat 
      y - 360 
    Until y >= 0 And y < 360 
  EndIf 
  If y < 0 
    Repeat 
      y + 360 
    Until y >= 0 And y < 360 
  EndIf 
  ProcedureReturn y 
EndProcedure 
  
Procedure CheckZRotation(z.l) 
  If z >= 360 
    Repeat 
      z - 360 
    Until z >= 0 And z < 360 
  EndIf 
  If z < 0 
    Repeat 
      z + 360 
    Until z >= 0 And z < 360 
  EndIf 
  ProcedureReturn z 
EndProcedure 
 
Procedure d_circle3d(x1.f,y1.f,z1.f,diameter.f) 
  Shared Constant, CameraPosition 
  ; calculate rotation 
  xx.f = CalcXRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition) 
  yy.f = CalcYRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition) 
  zz.f = CalcZRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition) 
 
  ; 1. convert to 2D coordinates 
  ; 2. draw it... 
 
Circle(Round(xx-zz/Constant,0)+ScreenWidth2,Round(yy-zz/Constant,0)+ScreenHeight2, diameter*CameraPosition) 
EndProcedure 
 
Procedure d_line3d(x1.f,y1.f,z1.f,x2.f,y2.f,z2.f) 
  Shared Constant,CameraPosition 
 
  ; calculate rotation 
  xx.f = CalcXRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition) 
  yy.f = CalcYRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition) 
  zz.f = CalcZRotation(x1*CameraPosition,y1*CameraPosition,z1*CameraPosition) 
 
  xx2.f = CalcXRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition)
  yy2.f = CalcYRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition)
  zz2.f = CalcZRotation(x2*CameraPosition,y2*CameraPosition,z2*CameraPosition)
 
  ; 1. convert to 2D coordinates 
  ; 2. draw it... 
   
  LineXY(Round(xx-zz/Constant,0)+ScreenWidth2,Round(yy-zz/Constant,0)+ScreenHeight2,Round(xx2-zz2/Constant,0)+ScreenWidth2,Round(yy2-zz2/Constant,0)+ScreenHeight2) 
EndProcedure 
 

;- Init stuff 
 
InitSprite() 
InitMouse() 
InitKeyboard() 
 
d_init3d(1024,768) 
 
OpenWindow(1,100,200,750,480,"Test",#PB_Window_SystemMenu) 
OpenWindowedScreen( WindowID(1),10,10,800,600,1,10,10) 
 
;- main program 
 
x.f = 0 
y.f = 0 
z.f = 0 
 
Start.l = 1 
 
Repeat 
ExamineMouse() 
ExamineKeyboard() 
  
; check rotation -> if x, y and z <0 or >360 error 
  wx = CheckXRotation(x) 
  wy = CheckYRotation(y) 
  wz = CheckZRotation(z) 
  
 
  
  ClearScreen(RGB(0,0,0)) 
  StartDrawing(ScreenOutput()) 
  
  ; DrawingMode: 
  ;  0: Default mode, text is displayed with background, graphics shape are filled 
  ;  1: Set the text background transparent 
  ;  2: Enable the XOr mode (all graphics are XOR'ed with current background) 
  ;  4: Enable the outlined shape. Circle, Box etc... will be only outlined, no more filled. 
  DrawingMode(0) 
 

  ; set the circle on top of the component 
  FrontColor(RGB(255,0,0))
  d_circle3d(0,0,4,0.2) 
 

  FrontColor(RGB(255,255,255))
 

; IC SOL18-P-300-1.27 Toshiba ULN2803 
; dimensions in millimeter 
; body top 
  d_line3d( -15.775, 3.75, 1.15,-25.775, 3.75, 1.15) 
  d_line3d( -15.775,-3.75, 1.15,-25.775,-3.75, 1.15) 
  d_line3d( -25.775, 3.75, 1.15,-25.775,-3.75, 1.15) 
  d_line3d( -15.775, 3.75, 1.15,-15.775,-3.75, 1.15) 
;body bottom 
  d_line3d( -15.775, 3.75,-1.15,-25.775, 3.75,-1.15) 
  d_line3d( -15.775,-3.75,-1.15,-25.775,-3.75,-1.15) 
  d_line3d( -25.775, 3.75,-1.15,-25.775,-3.75,-1.15) 
  d_line3d( -15.775, 3.75,-1.15,-15.775,-3.75,-1.15) 
;body z corners 
  d_line3d( -25.775, 3.75, 1.15,-25.775, 3.75,-1.15) 
  d_line3d( -15.775, 3.75, 1.15,-15.775, 3.75,-1.15) 
  d_line3d( -25.775,-3.75, 1.15,-25.775,-3.75,-1.15) 
  d_line3d( -15.775,-3.75, 1.15,-15.775,-3.75,-1.15) 
 

; IC SOL18-P-300-1.27 Toshiba ULN2803 
; dimensions in millimeter 
; body top 
  d_line3d( -5.775, 3.75, 1.15, 5.775, 3.75, 1.15) 
  d_line3d( -5.775,-3.75, 1.15, 5.775,-3.75, 1.15) 
  d_line3d(  5.775, 3.75, 1.15, 5.775,-3.75, 1.15) 
  d_line3d( -5.775, 3.75, 1.15,-5.775,-3.75, 1.15) 
;body bottom 
  d_line3d( -5.775, 3.75,-1.15, 5.775, 3.75,-1.15) 
  d_line3d( -5.775,-3.75,-1.15, 5.775,-3.75,-1.15) 
  d_line3d(  5.775, 3.75,-1.15, 5.775,-3.75,-1.15) 
  d_line3d( -5.775, 3.75,-1.15,-5.775,-3.75,-1.15) 
;body z corners 
  d_line3d(  5.775, 3.75, 1.15, 5.775, 3.75,-1.15) 
  d_line3d( -5.775, 3.75, 1.15,-5.775, 3.75,-1.15) 
  d_line3d(  5.775,-3.75, 1.15, 5.775,-3.75,-1.15) 
  d_line3d( -5.775,-3.75, 1.15,-5.775,-3.75,-1.15) 
 

;lead # 5 
  d_line3d(  0.24, 3.75, 0.14,-0.24, 3.75, 0.14) 
  d_line3d(  0.24, 3.75,-0.14,-0.24, 3.75,-0.14) 
  d_line3d(  0.24, 3.75, 0.14, 0.24, 3.75,-0.14) 
  d_line3d( -0.24, 3.75, 0.14,-0.24, 3.75,-0.14) 
  
  d_line3d(  0.24, 3.75, 0.14, 0.24, 4.49, 0.14) 
  d_line3d( -0.24, 3.75, 0.14,-0.24, 4.49, 0.14) 
  d_line3d(  0.24, 3.75,-0.14, 0.24, 4.31,-0.14) 
  d_line3d( -0.24, 3.75,-0.14,-0.24, 4.31,-0.14) 
 
  d_line3d(  0.24, 4.49, 0.14, 0.24, 4.49,-1.22) 
  d_line3d( -0.24, 4.49, 0.14,-0.24, 4.49,-1.22) 
  d_line3d(  0.24, 4.31,-0.14, 0.24, 4.31,-1.50) 
  d_line3d( -0.24, 4.31,-0.14,-0.24, 4.31,-1.50) 
  d_line3d(  0.24, 4.49, 0.14,-0.24, 4.49, 0.14) 
  d_line3d(  0.24, 3.75,-0.14,-0.24, 3.75,-0.14) 
 
  d_line3d(  0.24, 4.49,-1.22, 0.24, 5.15,-1.22) 
  d_line3d( -0.24, 4.49,-1.22,-0.24, 5.15,-1.22) 
  d_line3d(  0.24, 4.31,-1.50, 0.24, 5.15,-1.50) 
  d_line3d( -0.24, 4.31,-1.50,-0.24, 5.15,-1.50) 
 
  d_line3d(  0.24, 5.15,-1.22,-0.24, 5.15,-1.22) 
  d_line3d(  0.24, 5.15,-1.50,-0.24, 5.15,-1.50) 
  d_line3d(  0.24, 5.15,-1.22, 0.24, 5.15,-1.50) 
  d_line3d( -0.24, 5.15,-1.22,-0.24, 5.15,-1.50) 
 
  StopDrawing() 
  FlipBuffers() 
  
  ExamineKeyboard() 
 
  If KeyboardPushed(#PB_Key_Home) 
    Constant = Constant * 1.02 
    SetWindowText_(WindowID(1),StrF(Constant)) 
  EndIf 
  If KeyboardPushed(#PB_Key_End) 
    Constant = Constant * 0.98 
    SetWindowText_(WindowID(1),StrF(Constant)) 
  EndIf 
 
  If KeyboardPushed(#PB_Key_PageUp) 
    CameraPosition = CameraPosition * 1.02 
  EndIf 
  If KeyboardPushed(#PB_Key_PageDown) 
    CameraPosition = CameraPosition * 0.98 
  EndIf 
 
  If KeyboardPushed(#PB_Key_Up) 
    x = x - 1 ;normally it should be y 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) 
    x = x + 1 ;normally it should be y 
  EndIf 
 
  If KeyboardPushed(#PB_Key_Right) 
    y = y  - 1 ;normally it should be x 
  EndIf 
  If KeyboardPushed(#PB_Key_Left) 
    y = y + 1 ;normally it should be x 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Delete) 
    z = z - 1 
  EndIf 
  If KeyboardPushed(#PB_Key_Insert) 
    z = z + 1 
  EndIf 
 
  If KeyboardPushed(#PB_Key_F1) 
    x = 0 
    y = 0 
    z = 0 
  EndIf 
 
  SetWindowText_(WindowID(1)," X: " + Str(wx) + "   Y: " + Str(wy) + "   Z: " + Str(wz) + "   SinX: " + StrF(_sin(wx),2) + "   SinY: " + StrF(_sin(wy),2) + "  SinZ: " + StrF(_sin(wz),2) + "   CosX: " + StrF(_cos(wx),2) + "   CosY: " + StrF(_cos(wy),2) + "   CosZ: " + StrF(_cos(wz),2) + "   Constant: " + StrF(Constant)) 
Until MouseButton(1) Or KeyboardPushed(#PB_Key_Escape) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger