; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2491&highlight=
; Author: KuschelTeddy82
; Date: 08. October 2003
; OS: Windows
; Demo: Yes

;ktGetAngleX errechnet x2 aus: x1, winkel, radius 
;ktGetAngleY errechnet y2 aus: y1, winkel, radius 
;ktGetRadius errechnet den Radius aus x1, y1, x2, y2 
;ktGetAngle  errechnet den Winkel aus x1, y1, x2, y2, radius 

#Wpi2 = 2*3.1415926 
#Wpi180 = 3.1415926/180 


Procedure ktGetAngleX(Wx1.f, Ww.f, Wr.f) 
  Wsin.f = Sin(Ww*#Wpi180) 
  Wx2.f = Wx1+Wsin*Wr 
  ProcedureReturn Wx2 
EndProcedure 

Procedure ktGetAngleY(Wy1.f, Ww.f, Wr.f) 
  Wcos.f = Cos(Ww*#Wpi180) 
  Wy2.f = Wy1+Wcos*Wr 
  ProcedureReturn Wy2 
EndProcedure 

Procedure ktGetAngle(Wx1.f, Wy1.f, Wx2.f, Wy2.f, Wr.f) 
  Wdx.f=Wx1-Wx2 : Wdy.f=Wy1-Wy2 
  Ww.f=ACos(Wdx/Wr) : Ww=Ww*#Wpi180 
  If Wdx <= 0 And Wdy <= 0 : Ww = 180 + (180 - Ww):EndIf 
  If Wdx > 0 And Wdy > 0 : Ww = 270 + (90 - Ww) :EndIf 
  ProcedureReturn Ww 
EndProcedure 

Procedure ktGetRadius(Wx1.f, Wy1.f, Wx2.f, Wy2.f) 
  Wr.f = Sqr(Pow(Wx2-Wx1,2)+Pow(Wy2-Wy1,2)) 
  ProcedureReturn Wr 
EndProcedure


;- Examples
Debug ktGetAnglex(200,90,5)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -