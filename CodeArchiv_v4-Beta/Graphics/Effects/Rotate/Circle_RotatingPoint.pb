; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2411&start=30
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 03. October 2003
; OS: Windows
; Demo: No

;- Example
OpenWindow(0,0,0,200,200,"Rotation",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

x_mitte = 100 
y_mitte = 100 
radius = 80 
bg_color = GetSysColor_(#COLOR_BTNFACE) 

Repeat 
  
  winkel + 1 % 360      ; Modulo function, need PB3.80+ !

  StartDrawing(WindowOutput(0)) 
    
    ; Mittelpunkt 
    Circle(x_mitte,y_mitte,10,RGB(255,255,0)) 
    
    ; Kreisbahn 
    DrawingMode(4) 
    Circle(x_mitte,x_mitte,radius,RGB(100,100,100)) 
    DrawingMode(0) 
    
    ; Punkt auf Kreisbahn 
    Circle(x.f,y.f,5,bg_color) ; Punkt löschen 
      ; Punktkoordinaten errechnen 
      x = radius * Cos(winkel *(2*3.1415/360)) + x_mitte ; Winkel als Bogenmaß 
      y = radius * Sin(winkel *(2*3.1415/360)) + y_mitte 
    Circle(x,y,5,RGB(0,50,255)) 
  
  StopDrawing() 
  
  Delay(10) 
Until WindowEvent() = #PB_Event_CloseWindow


;- Description
; Benutzung von Modulo für geometrische Berechnungen/Zeicheneffekte:
; ------------------------------------------------------------------
; Modulo gibt den Rest einer Division zurück.
; Nehmen wir an, du hast einen Punkt, der um einen anderen rotieren soll.
; Die Formel dafür ist 
;   x = radius * Cos(winkel) + x_mitte 
;   y = radius * Sin(winkel) + y_mitte 
; wobei winkel von 0 bis 360 läuft und dann wieder auf 0 'fällt'. 

; Beispiel:
; winkel + 1 % 360 wird dann so errechnet: 
; 
; winkel = 0 
; 0 + 1 = 1 
; 1 % 360 = 1 
; 
; winkel = 1 
; 1+1=2 
; 2 % 360 = 2 
; 
; ... 
; u.s.w. 
; ... 
; 
; winkel = 359 
; 359 + 1 = 360 
; 360 % 360 = 0, da 360/360 = Rest 0 
; 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
