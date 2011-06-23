; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2489&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 08. October 2003
; OS: Windows
; Demo: No

Procedure.f winkel(x1.f,y1.f,x2.f,y2.f) 
  a.f = x2-x1 
  b.f = y2-y1 
  c.f = Sqr(a*a+b*b) 
  winkel.f = ACos(a/c)*57.29577 
  If y1 < y2 : winkel=360-winkel : EndIf 
  ProcedureReturn winkel 
EndProcedure 

x_window = 200 
y_window = 200 

OpenWindow(0,0,0,x_window,y_window,"Rotation",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
bgcolor = GetSysColor_(#COLOR_BTNFACE) 

CreateGadgetList(WindowID(0)) 
TrackBarGadget(0,0,y_window-18,x_window,18,0,200) 

x_mitte = x_window/2 
y_mitte = y_window/2 
punktzahl = 1000 
speed.f = 1 
SetGadgetState(0,150) 

Global Dim x.f(punktzahl) ; x 
Global Dim y.f(punktzahl) ; y 
Global Dim w.f(punktzahl) ; winkel 
Global Dim r.f(punktzahl) ; radius 
For i = 1 To punktzahl ; Werte zuweisen 
  x(i) = Random(x_window) 
  y(i) = Random(y_window) 
  w(i) = winkel(x(i),y(i),x_mitte,y_mitte) 
  r(i) = Sqr(Pow(x(i)-x_mitte,2)+Pow(y(i)-y_mitte,2)) 
Next 


Repeat 

  StartDrawing(WindowOutput(0)) 
  For i = 1 To punktzahl 
    If x(i) < x_window And x(i) > 0 And y(i) < y_window-20 And y(i) > 0 
      Plot(x(i),y(i),bgcolor)    
    EndIf 
    
    w(i) = (w(i)+speed) ; Winkel ändern 
    If w(i) >= 360 : w(i) = 0 : EndIf 
    x(i) = r(i) * Cos(w(i)*0.017453) + x_mitte ; Drehen 
    y(i) = r(i) * Sin(w(i)*0.017453) + y_mitte    
    
    If x(i) < x_window And x(i) > 0 And y(i) < y_window-20 And y(i) > 0 
      Plot(x(i),y(i),RGB(0,0,0))    
    EndIf 
  Next 
  StopDrawing() 
  
  eventid = WindowEvent() 
  If eventid = #PB_Event_Gadget 
    If EventGadget() = 0 
      speed = (GetGadgetState(0)-100)/50 
    EndIf 
  EndIf 
    
  Delay(1) 
Until eventid = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
