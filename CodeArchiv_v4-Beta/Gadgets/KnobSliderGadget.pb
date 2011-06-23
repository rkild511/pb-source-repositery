; English forum: http://www.purebasic.fr/english/viewtopic.php?t=15458
; Author: einander (updated for PB 4.00 by Andre, new WrapF procedure by Deeem2031)
; Date: 07. June 2005
; OS: Windows
; Demo: No


;Knob by einander
;june 7 -2005
;PB 3.94 beta 1
;Thanks Psychophanta for the Wrap ASM procedure!
UseJPEGImageDecoder()
RandomSeed(3234)    ; change seed to see other colors - Original seed=3234

Structure Knob
  Pos.Point
  Size.l
  MinValue.l
  MaxValue.l
  xCenter.l
  yCenter.l
EndStructure

Global Knob.Knob, _MX,_MY,_MK,_Inkey,_Deg2Rad.f,Position.Point, _KnobIMG
Global _Red.f,_Green.f,_Blue.f,_RR.f,_GG.f,_BB.f,_OldValue
_Red=100:_Green=100:_Blue=100 :_RR=3.3 :_GG=3.4 :_BB=-3.2
_Deg2Rad=57.29577  ;Degrees To Radians

Procedure APILine(DC,X,Y,X1,Y1,width,Color)
  Pen=CreatePen_(#PS_SOLID,width,Color)
  SelectObject_(DC,Pen)
  MoveToEx_(DC,X,Y,0):LineTo_(DC,X1,Y1)
  DeleteObject_(Pen)
EndProcedure

Procedure ChangeColor()
  r=Random(50)
  Select Random(2)
    Case 0
      _Red+_RR:If _Red>200+r Or _Red<120-r:_RR=-_RR:EndIf
    Case 1
      _Green+_GG:If _Green>200+r Or _Green<120-r:_GG=-_GG:EndIf
    Default
      _Blue+_BB:If _Blue>200+r Or _Blue<120-r:_BB=-_BB:EndIf
  EndSelect
EndProcedure


Procedure Limit(a,b,c)
  If a < b : ProcedureReturn b :EndIf
  If a > c : ProcedureReturn c : EndIf
  ProcedureReturn a
EndProcedure

Procedure Proportion(X.f, Min,Max,a,z)
  If X.f = Min :ProcedureReturn a: EndIf
  If X.f = Max : ProcedureReturn z: EndIf
  b.f=(Max-Min) / (X.f - Min)
  ProcedureReturn Limit(a + (z-a) / b,a,z)
EndProcedure

Procedure.f WrapF(number.f,margin1.f,margin2.f)
  !fld dword[p.v_margin1] ;push left value to FPU stack (to st1)
  !fld dword[p.v_margin2] ;push right value (to st0)
  !fcomi st1   ;compares st1 (margin2) with st0 (margin1)
  !jz near WrapFEqual   ;if margin1 = margin2 then return margin2 (to avoid fprem instruction to divide by 0)
  !jnc near @f  ;if st0 (margin2) < st1 (margin1), then:
  !fxch    ;swap st0 and st1, else:
  !@@: ;now we have lower margin at st1, and higher margin at st0
  !fsub st0,st1  ;range [lowermargin,highermargin] decremented to floor, now in st0
  !fld dword[p.v_number] ;push "number" to FPU stack (to st0).
  !fsub st0,st2  ;number (st0) substracted to floor. Number now in st0
  !;Now "number" in st0. Range in st1. And lower margin in st2
  !fprem  ;get remainder (modulo) in st0, from the division st0/st1
  !ftst ;test to see if modulo <= 0
  !fnstsw ax ;transfers FPU status word to ax
  !fwait
  !sahf   ;transfers ah to CPU flags.
  !jnc near @f ;if number has a negative value (is less than lower margin), the modulo is negative too then:
  !faddp st1,st0 ;add modulo and range (inverting modulo inside range)
  !faddp st1,st0 ;add the result to lower margin
  !jmp near WrapFgo
  !WrapFEqual:fstp st1
  !jmp near WrapFgo
  !@@:  ;else
  !fstp st1 ;don't need anymore the range, so now modulo is in st0
  !faddp st1,st0 ;add the modulo to lower margin
  !WrapFgo: ;finish returning st0 content
  ProcedureReturn
EndProcedure

Procedure.f AngleXY(X,Y,Ang.f,Dist)  ;Get Point at distance Dist from X, Y, with angle Angle
  Ang/_Deg2Rad
  Position\X= X+(Dist*Cos(Ang) + Dist*Sin(Ang))
  Position\Y= Y+(Dist*Sin(Ang) - Dist*Cos(Ang))
EndProcedure

Procedure.f GetAngle(X,Y,X1,Y1)  ; Get angle between two points
  a.f = X1-X
  Ang.f = ACos(a/Sqr(a*a+Pow( Y1-Y,2)))*_Deg2Rad
  If Y < Y1 :ProcedureReturn -(359-Ang) : EndIf
  ProcedureReturn -Ang
EndProcedure

Procedure DrawKnob(DC,X,Y,l)
  Ang.f
  Repeat
    x2.f = X+(l*Cos(Ang) + l*Sin(Ang))
    y2.f = Y+(l*Sin(Ang) - l*Cos(Ang))
    APILine(DC,X,Y,x2 ,y2,4,RGB(_Red,_Green,_Blue))
    ChangeColor()
    Ang+0.01
  Until Ang>=359
EndProcedure


Procedure Knob(Ang.f)
  X=Knob\Pos\X :Y=Knob\Pos\Y
  DrawImage(ImageID(_KnobIMG), X,Y,Knob\Size,Knob\Size)
  AngleXY(Knob\xCenter,Knob\yCenter,Ang,Knob\Size/3.14)
  Circle(Position\X,Position\Y,6,#Blue)
  ProcedureReturn Proportion(WrapF(Ang-136,0,359),0,359,Knob\MinValue,Knob\MaxValue)
EndProcedure


Procedure Callback(hWnd, Msg, lParam, wParam)
  If Msg = #WM_PAINT
    DrawImage(ImageID(_KnobIMG), Knob\Pos\X,Knob\Pos\Y,Knob\Size,Knob\Size)
  EndIf
  Select Msg
    Case #WM_KEYDOWN
      _Inkey = EventwParam()
      If _Inkey=27:End:EndIf
    Case #PB_Event_CloseWindow
      End
    Default
      _MX=WindowMouseX(0)
      _MY=WindowMouseY(0)
      _MK=Abs(GetAsyncKeyState_(#VK_LBUTTON) +GetAsyncKeyState_(#VK_RBUTTON)*2+GetAsyncKeyState_(#VK_MBUTTON)*3)/$8000
  EndSelect
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

;_________________________________________
OpenWindow(0,0,0,0,0,"",#WS_OVERLAPPEDWINDOW | #WS_MAXIMIZE)
hDC=GetDC_(WindowID(0))
;**********************************************************
Knob\Pos\X=WindowWidth(0)/2.5                ; put here your defs
Knob\Pos\Y=WindowHeight(0)/2.5
Knob\Size=120
Knob\xCenter=Knob\Pos\X+Knob\Size/2
Knob\yCenter=Knob\Pos\Y+Knob\Size/2
Knob\MinValue=0
Knob\MaxValue=1000
;**********************************************************

Style=0   ; ************************choose style=1 to load knob; style=0 to create knob

If Style   ; Load your knob image
  _KnobIMG=LoadImage(#PB_Any,"G:\Graficos\Knob 1.bmp")
Else         ; Draw Knob
  _KnobIMG=CreateImage(#PB_Any,Knob\Size,Knob\Size)
  DrawKnob(StartDrawing(ImageOutput(_KnobIMG)),ImageWidth(_KnobIMG)/2,ImageHeight(_KnobIMG)/2,ImageWidth(_KnobIMG)/3)
  StopDrawing()
EndIf
StartDrawing(WindowOutput(0))

Box(0,0,WindowWidth(0),WindowHeight(0),0)
SetWindowCallback(@Callback())
Repeat
  EV = WaitWindowEvent()
  If _MK=1
    X=Knob\Pos\X:Y=Knob\Pos\Y
    X1=X+Knob\Size : Y1=Y+Knob\Size
    If _MX>X And _MY>Y And _MX<X1 And _MY<Y1
      Catch=1              ;catch the knob until mouse is released
    EndIf
  Else
    Catch=0   ; released
    cuadrant=0
  EndIf
  If Catch
    Ang.f=WrapF(GetAngle(_MX,_MY,Knob\xCenter,Knob\yCenter)-136,0,359)
    value=Knob(Ang)
    If  _MY>Knob\yCenter
      If _MX<Knob\xCenter
        If cuadrant=0: cuadrant=1: EndIf
      Else
        If cuadrant=0 : cuadrant=2 : EndIf
      EndIf
    Else
      cuadrant=0
    EndIf
    If cuadrant=1
      If value>Knob\MaxValue/2
        value=Knob\MinValue
      EndIf
    ElseIf cuadrant=2
      If value<Knob\MaxValue/4
        value=Knob\MaxValue
      EndIf
    EndIf

    t$=Str(value)
    SetBkMode_(hDC,#TRANSPARENT)
    SetTextColor_(hDC,#Green)
    TextOut_(hDC,Knob\Pos\X,Knob\Pos\Y+Knob\Size-18,t$,Len(t$))
  EndIf
Until EV = #PB_Event_CloseWindow
End


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --