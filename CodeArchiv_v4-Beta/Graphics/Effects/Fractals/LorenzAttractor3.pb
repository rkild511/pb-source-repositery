; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3499
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 20. January 2004
; OS: Windows
; Demo: Yes

; Lorenz Attractor - example 3
; Lorenz-Attraktor - Beispiel 3

; Some ideas taken from:
; http://astronomy.swin.edu.au/~pbourke/fractals/

ExamineDesktops()
sx = DesktopWidth(0)
sy = DesktopHeight(0)
sd = 32 

InitSprite() 
InitKeyboard() 

iterationen=300000 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; unbedingt probieren!!! 
factor.f=1 
a.f=1; a.f=-1000; a.f=-1; a.f=10.4; 
b.f=4; b.f=0.1; b.f=-2; b.f=1; 
c.f=60; c.f=-10; c.f=-3; c.f=0; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

Procedure sign(l) 
  If l>0 
    ProcedureReturn 1 
  ElseIf l<0 
    ProcedureReturn-1 
  Else 
    ProcedureReturn 0 
  EndIf 
  
EndProcedure 

If OpenScreen(sx,sy,sd,"Random") 
  Repeat 
    x0.f=0 
    y0.f=0 
    x1.f=0 
    y1.f=0 
    
    ExamineKeyboard() 
    
    FlipBuffers() 
    ClearScreen(RGB(0,0,0))
    
    StartDrawing(ScreenOutput()) 
    For i=0 To iterationen 
      x1=y0-sign(x0)*Pow(Abs(b*x0-c),1/2) 
      y1=a-x0 
      x0=x1 
      y0=y1 
      Plot(x0*factor+Round(sx/2,1),y0*factor+Round(sy/2,1),Round(i/iterationen*16777000,1)) 
      
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