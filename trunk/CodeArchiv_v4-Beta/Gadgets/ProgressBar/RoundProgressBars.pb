; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1852&highlight=
; Author: Mischa (updated for PB 4.00 by Andre)
; Date: 30. January 2005
; OS: Windows
; Demo: No


#maxroundprogresses=10 

Structure rprogress 
  gadgetid.l 
  imageid.l 
  imagecolor.l 
  backcolor.l 
  frontcolor.l 
  textcolor.l 
  font.l 
  max.l 
  state.l 
  extension.s 
EndStructure 

Global Dim RoundProgresses.rprogress(#maxroundprogresses) 

Procedure SetRoundProgressState(id,state) 
  If state<>RoundProgresses(id)\state 
    w=ImageWidth(RoundProgresses(id)\imageid) : h=ImageHeight(RoundProgresses(id)\imageid) 
    dc=StartDrawing(ImageOutput(RoundProgresses(id)\imageid)) 
    Box(0,0,w,h,RoundProgresses(id)\imagecolor) 
    pen=CreatePen_(#PS_SOLID,1,RoundProgresses(id)\backcolor) 
    brush=CreateSolidBrush_(RoundProgresses(id)\backcolor) 
    SelectObject_(dc,brush) : SelectObject_(dc,pen) 
    Ellipse_(dc,0,0,w,h) 
    DeleteObject_(brush) : DeleteObject_(pen) 
    pen=CreatePen_(#PS_SOLID,1,0) 
    If RoundProgresses(id)\frontcolor=-1 
      cstate=state * 448 / RoundProgresses(id)\max 
      If cstate<256 
        color=RGB(255,cstate,0) 
      Else 
        cstate-256 
        color=RGB(255-cstate,255,0) 
      EndIf 
      brush=CreateSolidBrush_(color) 
    Else  
      brush=CreateSolidBrush_(RoundProgresses(id)\frontcolor) 
    EndIf 
    SelectObject_(dc,brush) : SelectObject_(dc,pen) 
    angle.f=state * 360 / RoundProgresses(id)\max 
    If angle>0 
      If angle>358 
        Ellipse_(dc,0,0,w,h) 
      Else 
        mx=w/2 : my=h/2 
        rx.f = 0 - (0 - my) * Sin(6.28318531*angle/360) + mx 
        ry.f = (0 - my) * Cos(6.28318531*angle/360) + my 
        x2 = rx : y2 = ry 
        Pie_(dc,0,0,w,h,x2,y2,w/2,0) 
      EndIf 
    EndIf 
    DeleteObject_(brush) : DeleteObject_(pen) 
    SelectObject_(dc,RoundProgresses(id)\font) 
    SetBkMode_(dc,#TRANSPARENT) 
    SetTextColor_(dc,RoundProgresses(id)\textcolor) 
    text.s = Str(state)+RoundProgresses(id)\extension 
    DrawText_(dc,text,-1,rect.RECT,#DT_CALCRECT) 
    diffx=(w-rect\right)/2 : diffy=(h-rect\bottom)/2 
    DrawText(diffx,diffy,text) 
    StopDrawing() 
    RoundProgresses(id)\state = state 
  EndIf 
  SetGadgetState(RoundProgresses(id)\gadgetid,ImageID(RoundProgresses(id)\imageid)) 
EndProcedure 

Procedure RoundProgress(id,x,y,w,h,ic,bc,fc,tc,font,max,state,ext.s) 
  RoundProgresses(id)\gadgetid   = ImageGadget(#PB_Any,x,y,w,h,0) 
  RoundProgresses(id)\imageid    = CreateImage(#PB_Any,w,h) 
  RoundProgresses(id)\imagecolor = ic 
  RoundProgresses(id)\backcolor  = bc 
  RoundProgresses(id)\frontcolor = fc 
  RoundProgresses(id)\textcolor  = tc 
  RoundProgresses(id)\font       = font 
  RoundProgresses(id)\max        = max 
  RoundProgresses(id)\state      = -1 
  RoundProgresses(id)\extension  = ext 
  SetRoundProgressState(id,state) 
EndProcedure 

Procedure RemoveRoundProgress(id) 
  FreeImage(RoundProgresses(id)\imageid) 
  FreeGadget(RoundProgresses(id)\gadgetid) 
EndProcedure  



OpenWindow(0,50,50,450,230,"Test",#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
font1=LoadFont(#PB_Any,"Arial",14,#PB_Font_Bold) 
font2=LoadFont(#PB_Any,"Times New Roman",24,#PB_Font_Bold) 
font3=LoadFont(#PB_Any,"System",10) 

RoundProgress(0,10,10,100,100,GetSysColor_(#COLOR_BTNFACE),RGB(160,160,160),RGB(230,128,230),RGB(255,230,255),FontID(font1),100,0,"%") 
RoundProgress(1,120,10,100,100,GetSysColor_(#COLOR_BTNFACE),RGB(160,160,160),RGB(230,230,128),RGB(255,255,230),FontID(font1),100,0,"%") 
RoundProgress(2,230,10,210,210,GetSysColor_(#COLOR_BTNFACE),RGB(160,160,160),-1,RGB(0,0,0),FontID(font2),100,0,"%") 
RoundProgress(3,10,120,100,100,GetSysColor_(#COLOR_BTNFACE),RGB(160,160,160),RGB(128,230,230),RGB(0,0,0),FontID(font1),1000,0," Units") 
RoundProgress(4,120,120,100,45,GetSysColor_(#COLOR_BTNFACE),RGB(120,120,120),RGB(64,160,160),RGB(0,0,0),FontID(font3),100,0,"%") 
RoundProgress(5,120,175,100,45,GetSysColor_(#COLOR_BTNFACE),RGB(80,80,32),RGB(160,160,64),RGB(255,255,128),FontID(font3),100,100,"%") 

time=timeGetTime_() 
Repeat 
  Event=WindowEvent() 
  If timeGetTime_()-time>80 
    state1+1 
    If state1>100 
      state1=0 
    EndIf 
    state2+2 
    If state2>100 
      state2=0 
    EndIf 
    state3+4 
    If state3>100 
      state3=0 
    EndIf 
    state4+5 
    If state4>1000 
      state4=0 
    EndIf 
    state5+3 
    If state5>100 
      state5=0 
    EndIf 
    state6-2 
    If state6<0 
      state6=100 
    EndIf 
    SetRoundProgressState(5,state6) 
    SetRoundProgressState(4,state5) 
    SetRoundProgressState(3,state4) 
    SetRoundProgressState(2,state1) 
    SetRoundProgressState(1,state2) 
    SetRoundProgressState(0,state3) 
    time=timeGetTime_() 
  Else
    Delay(5) 
  EndIf  
Until Event=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger