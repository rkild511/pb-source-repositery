; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8880&highlight=
; Author: Psychophanta (updated for PB4.00 by blbltheworm)
; Date: 26. December 2003
; OS: Windows
; Demo: Yes


; Ohh! some Xmas i have Amiga BlitzBasic2 melancholy. 
; So i've translated to PB a very old code i made: 

;************************************ 
;Interactiving masses: 
;************************************ 

Procedure.f InputNum(inum.f,x.l,y.l) 
  s.b=1:num.f=0 
  StartDrawing(ScreenOutput()):BackColor(RGB(0,0,0)):FrontColor(RGB(200,200,240)) 
  DrawText(x,y,"input mass:"):BackColor(RGB(160,170,0)):FrontColor(RGB(230,230,240)) 
  DrawText(x+TextWidth("input mass:"),y,Space(10)) 
  DrawText(x+TextWidth("input mass:"),y,Str(inum)) 
  StopDrawing() 
  FlipBuffers() 
  While MouseButton(1):ExamineMouse():Wend;<-wait until LMB is released 
  Repeat 
    ExamineKeyboard():ExamineMouse() 
    If KeyboardReleased(#PB_Key_PadEnter) Or KeyboardReleased(#PB_Key_Return) Or MouseButton(1):While MouseButton(1):ExamineMouse():Wend:Break 
    ElseIf KeyboardReleased(#PB_Key_Subtract) Or KeyboardReleased(#PB_Key_Minus):num.f=-num.f:s.b=-s.b:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_PadComma) Or KeyboardReleased(#PB_Key_Comma):key.b=1 ;punto flotante? 
    ElseIf KeyboardReleased(#PB_Key_Pad0) Or KeyboardReleased(#PB_Key_0):num*10:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad1) Or KeyboardReleased(#PB_Key_1):num*10+1*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad2) Or KeyboardReleased(#PB_Key_2):num*10+2*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad3) Or KeyboardReleased(#PB_Key_3):num*10+3*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad4) Or KeyboardReleased(#PB_Key_4):num*10+4*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad5) Or KeyboardReleased(#PB_Key_5):num*10+5*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad6) Or KeyboardReleased(#PB_Key_6):num*10+6*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad7) Or KeyboardReleased(#PB_Key_7):num*10+7*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad8) Or KeyboardReleased(#PB_Key_8):num*10+8*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Pad9) Or KeyboardReleased(#PB_Key_9):num*10+9*s:key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Back):num=Int(num/10):key.b=1 
    ElseIf KeyboardReleased(#PB_Key_Escape):ProcedureReturn 10000000;<-ESCAPE; no add item. 
    Else:key=0 
    EndIf 
    If key.b:inum=num 
      If num>=10000 Or num<=-10000:num=Int(num/10):EndIf 
      StartDrawing(ScreenOutput()):BackColor(RGB(0,0,0)):FrontColor(RGB(200,200,240)) 
      DrawText(x,y,"input mass:"):BackColor(RGB(160,170,0)):FrontColor(RGB(230,230,240)) 
      DrawText(x+TextWidth("input mass:"),y,Space(10)) 
      DrawText(x+TextWidth("input mass:"),y,Str(inum)) 
      StopDrawing() 
      FlipBuffers() 
    EndIf 
  ForEver 
  ProcedureReturn inum 
EndProcedure 

;-INITS: 
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("Error", "Can't open DirectX. Ahhh! Se siente!", 0) 
  End 
EndIf 
Define .f 
Structure MasaPuntual 
  x.f:y.f;<-current position coords 
  mx.f:my.f;<-movement vector 
  mass.f;<-mass 
EndStructure 
Global NewList p.MasaPuntual() 

#bitplanes=32:#RX=800:#RY=600 
If OpenScreen(#RX,#RY,#bitplanes,"")=0:End:EndIf 

CreateSprite(0,16,16);<-The mouse cursor 
StartDrawing(SpriteOutput(0)):BackColor(RGB(0,0,0)) 
Line(0,0,15,10,$CABE2A) 
Line(0,0,5,15,$CABE2A) 
LineXY(5,15,15,10,$CABE2A) 
FillArea(2,2,$CABE2A,$C0C1D0) 
StopDrawing() 
CreateSprite(1,4,4);<-the masses objects 
StartDrawing(SpriteOutput(1)):BackColor(RGB(0,0,0)) 
Circle(2,2,2,$50F0CA) 
StopDrawing() 
MouseLocate(#RX/2,#RY/2) 
#K=10000 
routine.b=1:num.f=500 
;-MAIN: 
Repeat 
  ExamineKeyboard():ExamineMouse() 
  x=MouseX():y=MouseY() 
  If MouseButton(1) 
    Gosub addnewone 
  EndIf 
  ClearScreen(RGB(0,0,0)) 
  Gosub displaymaintext 
  Gosub SelectRoutine 
  Gosub displaymasses 
  DisplayTransparentSprite(0,x,y);draw our mouse pointer sprite just here 
  FlipBuffers();<--swap buffers 
Until KeyboardPushed(#PB_Key_Escape) 
ReleaseMouse(1):CloseScreen():End 
;-Subroutines: 
displaymaintext: 
  If hidetext.b=0 
    StartDrawing(ScreenOutput()):BackColor(RGB(0,0,0)):FrontColor(RGB(120,170,160)) 
    DrawText(0,0,"Push LMB to add a mass") 
    DrawText(0,20,"ESC key to exit") 
    DrawText(0,120,"F11 => Show/Hide Text") 
    DrawText(0,140,"F12 => RESTART") 
    FrontColor(RGB(120,198,160)):DrawText(0,140,"  (now "+Str(CountList(p()))+" objects)") 
    StopDrawing() 
  EndIf 
Return 
SelectRoutine: 
  If KeyboardReleased(#PB_Key_F1):If routine.b<>1:Gosub resetmovements:routine.b=1:EndIf 
  ElseIf KeyboardReleased(#PB_Key_F2):If routine.b<>2:Gosub resetmovements:routine.b=2:EndIf 
  ElseIf KeyboardReleased(#PB_Key_F3):If routine.b<>3:Gosub resetmovements:routine.b=3:EndIf 
  ElseIf KeyboardReleased(#PB_Key_F4):If routine.b<>4:Gosub resetmovements:routine.b=4:EndIf 
  ElseIf KeyboardReleased(#PB_Key_F11):hidetext.b!1 
  ElseIf KeyboardReleased(#PB_Key_F12):ClearList(p()) 
  EndIf 
  StartDrawing(ScreenOutput()):BackColor(RGB(0,0,0)):FrontColor(RGB(220,210,160)) 
  Select routine 
  Case 1 
    If hidetext.b=0 
      DrawText(0,40,"Now processing Simple Harmonic Motion consecutives dependant systems") 
      FrontColor(RGB(120,170,160)) 
      DrawText(0,60,"F2 => process (all on all) interactive dependant Simple Harmonic Motion systems") 
      DrawText(0,80,"F3 => process gravity simulation consecutive dependant systems") 
      DrawText(0,100,"F4 => process gravity simulation, this is (all on all)") 
    EndIf 
    Gosub process1 
  Case 2 
    If hidetext.b=0 
      DrawText(0,60,"Now processing (all on all) interactive dependant Simple Harmonic Motion systems") 
      FrontColor(RGB(120,170,160)) 
      DrawText(0,40,"F1 => process Simple Harmonic Motion consecutives dependant systems") 
      DrawText(0,80,"F3 => process gravity simulation consecutive dependant systems") 
      DrawText(0,100,"F4 => process gravity simulation, this is (all on all)") 
    EndIf 
    Gosub process2 
  Case 3 
    If hidetext.b=0 
      DrawText(0,80,"Now processing gravity simulation consecutive dependant systems") 
      FrontColor(RGB(120,170,160)) 
      DrawText(0,40,"F1 => process Simple Harmonic Motion consecutives dependant systems") 
      DrawText(0,60,"F2 => process (all on all) interactive dependant Simple Harmonic Motion systems") 
      DrawText(0,100,"F4 => process gravity simulation, this is (all on all)") 
    EndIf 
    Gosub process3 
  Case 4 
    If hidetext.b=0 
      DrawText(0,100,"Now processing gravity simulation, this is (all on all)") 
      FrontColor(RGB(120,170,160)) 
      DrawText(0,40,"F1 => process Simple Harmonic Motion consecutives dependant systems") 
      DrawText(0,60,"F2 => process (all on all) interactive dependant Simple Harmonic Motion systems") 
      DrawText(0,80,"F3 => process gravity simulation consecutive dependant systems") 
    EndIf 
    Gosub process4 
  Default 
    If hidetext.b=0 
      FrontColor(RGB(120,170,160)) 
      DrawText(0,40,"F1 => process Simple Harmonic Motion consecutives dependant systems") 
      DrawText(0,60,"F2 => process (all on all) interactive dependant Simple Harmonic Motion systems") 
      DrawText(0,80,"F3 => process gravity simulation consecutive dependant systems") 
      DrawText(0,100,"F4 => process gravity simulation, this is (all on all)") 
    EndIf 
  EndSelect 
  StopDrawing() 
Return 
addnewone: 
  num=InputNum(num,x,y) 
  If num<1000000;<-if no ESC key pushed: 
    AddElement(p()) 
    p()\x=x:p()\y=y 
    p()\mass=num/#K 
  Else:num=0 
  EndIf 
Return 
displaymasses: 
  ForEach p() 
    p()\x+p()\mx:p()\y+p()\my 
    DisplayTransparentSprite(1,p()\x,p()\y) 
  Next 
Return 
resetmovements: 
  ForEach p() 
    p()\mx=0:p()\my=0 
  Next 
Return 
process1:;<-process consecutives dependant systems of "Simple Harmonic Motion" 
  ForEach p() 
    *p.MasaPuntual=@p() ;<-pushItem 
    While NextElement(p()) 
      dx=p()\x-*p\x:dy=p()\y-*p\y;<-(dx,dy) is the *p->p() vector 
      af=p()\mass/100 
      *p\mx+dx*af:*p\my+dy*af 
    Wend 
    ChangeCurrentElement(p(),*p);<-popItem 
  Next 
Return 
process2:;<-process "all on all" interactive consecutives dependant systems of "Simple Harmonic Motion" 
  ForEach p() 
    *p.MasaPuntual=@p();<-pushItem 
    While NextElement(p()) 
      If @p()=*p:Continue:EndIf 
      dx=(p()\x-*p\x):dy=(p()\y-*p\y);<-(dx,dy) is the *p->p() vector 
      af1=p()\mass/100 
      af2=*p\mass/100 
      *p\mx+dx*af1:*p\my+dy*af1 
      p()\mx-dx*af2:p()\my-dy*af2 
    Wend 
    ChangeCurrentElement(p(),*p);<-popItem 
  Next 
Return 
process3:;<-process gravity simulation consecutive dependant systems 
  ForEach p() 
    *p.MasaPuntual=@p() ;<-pushItem 
    While NextElement(p()) 
      dx=p()\x-*p\x:dy=p()\y-*p\y;<-(dx,dy) is the *p->p() vector 
      af=p()\mass/Sqr(dx*dx+dy*dy);<-mass/distance 
      *p\mx+dx*af:*p\my+dy*af 
    Wend 
    ChangeCurrentElement(p(),*p);<-popItem 
  Next 
Return 
process4:;<-process gravity simulation (interactiving all masses on all masses). 
  ForEach p() 
    *p.MasaPuntual=@p();<-pushItem 
    While NextElement(p()) 
      If @p()=*p:Continue:EndIf 
      dx=(p()\x-*p\x):dy=(p()\y-*p\y);<-(dx,dy) is the *p->p() vector 
      af1=p()\mass/Sqr(dx*dx+dy*dy);<-mass/distance 
      af2=*p\mass/Sqr(dx*dx+dy*dy);<-mass/distance 
      *p\mx+dx*af1:*p\my+dy*af1 
      p()\mx-dx*af2:p()\my-dy*af2 
    Wend 
    ChangeCurrentElement(p(),*p);<-popItem 
  Next 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
