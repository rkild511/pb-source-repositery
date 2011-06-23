; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5129&highlight=
; Author: Stefan Moebius (updated for PB 4.00 by Andre)
; Date: 22. July 2004
; OS: Windows
; Demo: No


;Achtung: 
;Funktioniert nicht mit Win 9x/Me! 
OpenWindow(0,0,0,275,275,"Rotierende Ellipse (by Stefan Moebius))",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
    
Repeat 
  
  DC=StartDrawing(WindowOutput(0)) 
  
  Trans.XFORM 
  
  Winkel.f+0.1;Winkel im Bogenmaﬂ 
  
  Trans\eM11=Cos(Winkel.f) 
  Trans\eM12=Sin(Winkel.f) 
  Trans\eM21=-Sin(Winkel.f) 
  Trans\eM22=Cos(Winkel.f) 
  
  ;Rotationsmittelpunkt 
  Trans\ex=100 
  Trans\ey=100 
  
  SetGraphicsMode_(DC,#GM_ADVANCED) 
  SetWorldTransform_(DC,Trans) 
  
  
  Color=~Color 
  Ellipse(0,0,100,25,Color) 

  
  StopDrawing() 
  
  Delay(100) 
  
Until WindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -