; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3499
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 20. January 2004
; OS: Windows
; Demo: Yes

; Lorenz Attractor - example 2
; Lorenz-Attraktor - Beispiel 2

; Some ideas taken from:
; http://astronomy.swin.edu.au/~pbourke/fractals/

ExamineDesktops()
sx = DesktopWidth(0)
sy = DesktopHeight(0)
sd = 32 

InitSprite() 
InitKeyboard() 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
m=12 ;zwischen 2 und 12   unbedingt ausprobieren! 
iterationen=300000 ;für langsamere PC verkleinern 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
x.f=1 
y.f=1 
c.f=0 
s1.f=250 
s2.f=(s1)*sy/sx 
Dim a.f(25) 
Dim b.f(25) 
For i=1 To m 
  a(i)=Cos(2*#PI*i/m) 
  b(i)=Sin(2*#PI*i/m) 
Next 


If OpenScreen(sx,sy,sd,"Random") 
  Repeat 
    ExamineKeyboard() 
    
    FlipBuffers() 
    ClearScreen(RGB(0,0,0))
    
    StartDrawing(ScreenOutput()) 
    
    For n=1 To iterationen 
      c=Random(100)/100 
      l=1+Int(c*m) 
      a0.f=Random(100)/100 
      If a0<0.5 
        x1.f=x/2+a(l) 
        y1.f=y/2+b(l) 
      Else 
        x1.f=x*a(l)+y*b(l)+x*x*b(l) 
        y1.f=y*a(l)-x*b(l)+x*x*a(l) 
        x1=x1/6 
        y1=y1/6 
      EndIf 
      x=x1 
      y=y1 
      If n>10 
        xp=Round(sx/2+s1*x,1) 
        yp=Round(sy/2+s2*y,1) 
        Plot(xp,yp,Round(Sqr(sx*sx+sy*sy)/Sqr((xp-sx/2)*(xp-sx/2)+(sy/2-yp)*(sy/2-yp)),1)*16777000) 
      EndIf 
    Next 
    StopDrawing() 
    
    If KeyboardReleased(#PB_Key_Space) 
      Repeat 
        Delay(5) 
        ExamineKeyboard() 
        If KeyboardPushed(1):End:EndIf 
      Until KeyboardReleased(#PB_Key_Space) 
    EndIf 
    
    
    Delay(5) 
  Until KeyboardReleased(1) 
  CloseScreen() 
  
Else 
  MessageRequester("Error","Can't open screen",0) 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger