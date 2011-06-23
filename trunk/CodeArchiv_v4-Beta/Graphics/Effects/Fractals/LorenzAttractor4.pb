; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3499
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 20. January 2004
; OS: Windows
; Demo: Yes

; Lorenz Attractor - example 4
; Lorenz-Attraktor - Beispiel 4

; Some ideas taken from:
; http://astronomy.swin.edu.au/~pbourke/fractals/

ExamineDesktops()
sx = DesktopWidth(0)
sy = DesktopHeight(0)
sd = 32 

InitSprite() 
InitKeyboard() 

iterationen=300000 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
a.f=2.01 ;-2.7  ;-2.24  ;-2        ich habe nicht alle ausprobiert 
b.f=-2.53 ;-0.09  ;0.43 ;-2 
c.f=1.61 ;-0.86 ;-0.65  ;-1.2 
d.f=-0.33 ;-2.2 ;-2.43  ;2 
factor=100 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


If OpenScreen(sx,sy,sd,"Random") 
  Repeat 
    x0.f=1 
    y0.f=1 
    x1.f=1 
    y1.f=1 
    
    ExamineKeyboard() 
    
    FlipBuffers() 
    ClearScreen(RGB(0,0,0))
    
    StartDrawing(ScreenOutput()) 
    For i=0 To iterationen 
      x1=Sin(a*y0)-Cos(b*x0) 
      y1=Sin(c*x0)-Cos(d*y0) 
      x0=x1 
      y0=y1 
      Plot(Round(x0*factor+sx/2,1),Round(y0*factor+sy/2,1),Round(i/iterationen*16777000,1)) 
    Next 
    StopDrawing() 
    
    Delay(5) 
  Until KeyboardPushed(#PB_Key_Escape)
  CloseScreen() 
  
Else 
  MessageRequester("Error","Can't open screen",0) 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger