; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2489&highlight=
; Author: Rob
; Date: 08. October 2003
; OS: Windows
; Demo: Yes


; Get the angle between two points and the Null-point
; [x1,y1], [x2,y2] und [0,0]... 

; Ermittelt den Winkel zwischen den beiden Punkten und dem Null-Punkt
; [x1,y1], [x2,y2] und [0,0]... 

Procedure.f winkel(x1.f,y1.f,x2.f,y2.f) 
  a.f = x2-x1 
  b.f = y2-y1 
  c.f = Sqr(a*a+b*b) 
  winkel.f = ACos(a/c)*57.29577 
  If y1 < y2 : winkel=360-winkel : EndIf 
  ProcedureReturn winkel 
EndProcedure

Procedure.f bwinkel(x1.f,y1.f,x2.f,y2.f)   ; Bogenmaß
  a.f = x2-x1 
  b.f = y2-y1 
  c.f = Sqr(a*a+b*b) 
  winkel.f = ACos(a/c)*57.29577 
  If y1 < y2 : winkel=360-winkel : EndIf 
  winkel*0.017453 
  ProcedureReturn winkel 
EndProcedure

Debug winkel(100,100,200,200)
Debug bwinkel(100,100,200,200)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
