; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1505&highlight=
; Author: Wichtel (updated for PB4.00 by blbltheworm)
; Date: 26. June 2003
; OS: Windows
; Demo: Yes


PI2.f=ATan(1)*8 ; ergint 2 * PI = 360° 
PI.f=ATan(1)*4 ; ergibt PI 
PId4.f=ATan(1) ; ergibt PI/4 zum weiterrechnen. 

box = CreateImage(0, 300,300) 
StartDrawing(ImageOutput(0)) 
Box(0, 0,300, 300,$FFFFFF) 


;Kreis malen 
xm=50 ; x Mittelpunkt des Kreises 
ym=50 ; y Mittelpunkt des Kreises 
radius=40 ; Größe des Kreises 
schritt=600 ; Anzahl der zu berechnenden Punkte 

a.f=PI2 ; Anfangswinkel setzen 
While a >= 0 
  x=Sin(a+PI)*radius+xm ; x Koordinate berechnen 
;  x=(Sin(a+PI)+Cos(a+PI))*radius/2+xm ; gedrehte Ellipse 

  y=Cos(a+PI)*radius+ym ; y Koordinate berechnen 
  Plot(x,y,$0000FF) ; und in Rot plotten 
   a-PI2/schritt 
Wend 


;Ellipse malen 
xm=150 ; x Mittelpunkt des Kreises 
ym=50 ; y Mittelpunkt des Kreises 
radius=40 ; Größe des Kreises 
schritt=600 ; Anzahl der zu berechnenden Punkte 

a.f=PI2 ; Anfangswinkel setzen 
While a >= 0 
  x=(Sin(a+PI)+Cos(a+PI))*radius/2+xm ; gedrehte Ellipse 
  y=Cos(a+PI)*radius+ym ; y Koordinate berechnen 
  Plot(x,y,$0000FF) ; und in Rot plotten 
   a-PI2/schritt 
Wend 


;Herz malen 
xm=50 ; x Mittelpunkt des Kreises 
ym=150 ; y Mittelpunkt des Kreises 
radius=40 ; Größe des Kreises 
schritt=600 ; Anzahl der zu berechnenden Punkte 

a.f=PId4*6 ; Anfangswinkel setzen 
While a >= PId4*2 
  x1=xm+Cos(a)*radius 
  x2=xm-Cos(a)*radius 
  y=ym+( Sin(a) + Cos(a) ) *radius/2 
  Plot(x1,y,$0000FF) ; und in Rot plotten 
  Plot(x2,y,$0000FF) ; und in Rot plotten 
  a-PI2/schritt 
Wend 


;Brille malen 
xm=150 ; x Mittelpunkt des Kreises 
ym=150 ; y Mittelpunkt des Kreises 
radius=40 ; Größe des Kreises 
schritt=600 ; Anzahl der zu berechnenden Punkte 

a.f=PId4*7 ; Anfangswinkel setzen 
While a >= -PId4 
  x1=xm+a*radius/2 
  y1=ym+( Sin(a) + Cos(a) ) *radius/2 
  y2=ym-( Sin(a) + Cos(a) ) *radius/2 

  Plot(x1,y1,$0000FF) ; und in Rot plotten 
  Plot(x1,y2,$0000FF) ; und in Rot plotten 
  a-PI2/schritt 
Wend 

;Schleife malen 
xm=50 ; x Mittelpunkt des Kreises 
ym=230 ; y Mittelpunkt des Kreises 
radius=40 ; Größe des Kreises 
schritt=600 ; Anzahl der zu berechnenden Punkte 

a.f=PI2 ; Anfangswinkel setzen 
While a >= 0 
  x=xm+Sin(a)*radius 
  y=ym+Cos(a)*Sin(a) *radius 
; y=ym-( Sin(a) + Cos(a) ) *radius/2 

  Plot(x,y,$0000FF) ; und in Rot plotten 
  ;Plot(x1,y2,$0000FF) ; und in Rot plotten 
  a-PI2/schritt 
Wend 

;einfachen Sinus malen 
xm=150 ; x Mittelpunkt des Kreises 
ym=230 ; y Mittelpunkt des Kreises 
radius=40 ; Größe des Kreises 
schritt=600 ; Anzahl der zu berechnenden Punkte 

a.f=PI2 ; Anfangswinkel setzen 
While a >= 0 
  x=xm+a*radius/2 
  y=ym+Sin(a) *radius 
  Plot(x,y,$0000FF) ; und in Rot plotten 
  a-PI2/schritt 
Wend 


StopDrawing() 



OpenWindow(0,0,0,300,300,"ANACLOX",#PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget|#PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
CreateGadgetList(WindowID(0)) 
ImageGadget(0,0,0,300,300,box) 


Repeat 
  EventID = WaitWindowEvent() 
  Select EventID 
;   Case #PB_EventGadget 
;     GadgetID = EventGadgetID() 
;     Select GadgetID 
;      
;     EndSelect 
;   Case #PB_EventMenu 
;     MenuID = EventMenuID() 
;     Select MenuID 
; 
;     EndSelect 
  EndSelect 
Until EventID = #PB_Event_CloseWindow 

CloseWindow(0) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
