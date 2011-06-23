; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6511&highlight=
; Author: Tomcat (updated for PB4.00 by blbltheworm)
; Date: 13. June 2003
; OS: Windows
; Demo: No

Structure PointAPI 
x.l 
y.l 
EndStructure 

Global Dim P.PointAPI(4) 
P(0)\x = 0  :P(0)\y = 250 
P(1)\x = 0  :P(1)\y = 0 
P(2)\x = 250:P(2)\y = 0 
P(3)\x = 250:P(3)\y = 250 
    
Procedure CreateBezier() 
  CreateImage(0,256,256) 
  StartDrawing(ImageOutput(0)) 
    Box(0,0,256,256,RGB(160,160,160)) 
      
    Red = RGB(255,0,0) 
    Blue = RGB(0,0,255) 

    LineXY(P(0)\x,P(0)\y,P(1)\x,P(1)\y,Blue) 
    Box(P(0)\x,P(0)\y, 4, 4,Red) 
    Box(P(1)\x,P(1)\y, 4, 4,Red) 
    LineXY(P(2)\x,P(2)\y,P(3)\x,P(3)\y,Blue) 
    Box(P(2)\x,P(2)\y, 4, 4,Red) 
    Box(P(3)\x,P(3)\y, 4, 4,Red) 

    beziercount.w=2 ;+Start and Endpoint 
    accuracy.f=(GetGadgetState(6)/100) 
    u.f=0 
    Repeat 
      xlast.f=x.f 
      ylast.f=y.f 
      x.f=P(0)\x*Pow((1-u),3)+P(1)\x*3*u*Pow((1-u),2)+P(2)\x*3*Pow(u,2)*(1-u)+P(3)\x*Pow(u,3) 
      y.f=P(0)\y*Pow((1-u),3)+P(1)\y*3*u*Pow((1-u),2)+P(2)\y*3*Pow(u,2)*(1-u)+P(3)\y*Pow(u,3) 
      If u.f>0 
        LineXY(x,y,xlast,ylast) 
      EndIf 
      u.f+accuracy.f 
      If u.f>1.0 And endpoint.b=0 
        endpoint.b=1 
        u.f=1.0 
      EndIf 
      If u.f>0.0 And u.f<1.0 
        beziercount.w+1 
      EndIf 
    Until (u.f>1.0) 
  StopDrawing() 
  SetGadgetState(1,ImageID(0)) 
  SetGadgetText(4,"Bezier curve has "+Str(beziercount.w)+" Points") 
EndProcedure 

If OpenWindow(0,100,150,450,300,"Create Bezier Curve",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(1,10,10,256,256,0) 
  ButtonGadget(3,300,140,100,25,"Reset Points") 
  TextGadget(4,270,10,200,18,"") 
  TextGadget(5,10,275,50,18,"Accuracy:") 
  TrackBarGadget(6,60,270,206,30,1,50):SetGadgetState(6,10) 
  
  CreateBezier() 
  Repeat 
    EventID=WaitWindowEvent() 
    Select EventID 
      Case #WM_LBUTTONDOWN 
        leftmousebutton.b=1 
      Case #WM_LBUTTONUP 
        leftmousebutton.b=0 
      Case #WM_MOUSEMOVE 
        mousex=WindowMouseX(0)-15 
        mousey=WindowMouseY(0)-33 
        If leftmousebutton.b=0 
          selectedPoint=-1 
          For i=0 To 3 
            If mousex>p(i)\x-5 And mousex<p(i)\x+5 And mousey>p(i)\y-5 And mousey<p(i)\y+5 
              selectedPoint=i 
            EndIf 
          Next 
          If selectedPoint<>-1 
            SetClassLong_(WindowID(0),#GCL_HCURSOR,LoadCursor_(0,32649)) 
          Else 
            SetClassLong_(WindowID(0),#GCL_HCURSOR,LoadCursor_(0,#IDC_ARROW)) 
          EndIf 
        Else 
          If selectedPoint<>-1 
            P(selectedPoint)\x=mousex            
            P(selectedPoint)\y=mousey 
            CreateBezier() 
          EndIf 
        EndIf        
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 3          
            P(0)\x = 0  :P(0)\y = 250 
            P(1)\x = 0  :P(1)\y = 0 
            P(2)\x = 250:P(2)\y = 0 
            P(3)\x = 250:P(3)\y = 250 
            CreateBezier() 
            leftmousebutton.b=0 
          Case 6 
            CreateBezier() 
            leftmousebutton.b=0 
        EndSelect 
    EndSelect 
  Until EventID=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
