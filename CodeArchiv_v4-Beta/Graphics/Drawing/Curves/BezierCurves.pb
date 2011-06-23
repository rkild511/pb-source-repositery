; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2515&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 09. October 2003
; OS: Windows
; Demo: Yes


; Bezier-Kurven Funktion:
; Im Beispiel: Mit der Maus die Punkte bewegen, mit der linken Maustaste den aktiven Punkt ändern. 

cw = RGB(255,255,255) 
cr = RGB(255,0,0) 

Procedure bezier(x1,y1,x2,y2,x3,y3,x4,y4,color) 
  oldx=x1 
  oldy=y1 
  cx.f=3*(x2-x1) 
  bx.f=3*(x3-x2)-cx 
  ax.f=x4-x1-cx-bx 
  cy.f=3*(y2-y1) 
  by.f=3*(y3-y2)-cy 
  ay.f=y4-y1-cy-by 
  While i.f < 1 
    i+0.05 
    x=((ax*i+bx)*i+cx)*i+x1 
    y=((ay*i+by)*i+cy)*i+y1 
    If i>0: LineXY(oldx,oldy,x,y,color) : EndIf 
    oldx=x 
    oldy=y 
  Wend 
EndProcedure 

InitSprite() 
InitKeyboard() 
InitMouse() 

OpenScreen(640,480,16,"Bezier") 

x1=0 : y1=0 
x2=640 : y2=0 
x3=0 : y3=480 
x4=640 : y4=480 

key = 1 

Repeat 
  ExamineKeyboard() 
  ExamineMouse() 
  
  ; Punkt wechseln 
  If MouseButton(1) And mousepush=0 ; Punkte rotieren: 1-4 
    key = (key % 4) + 1 
    If key=1 : MouseLocate(x1,y1) : EndIf 
    If key=2 : MouseLocate(x2,y2) : EndIf 
    If key=3 : MouseLocate(x3,y3) : EndIf 
    If key=4 : MouseLocate(x4,y4) : EndIf 
  EndIf 
  mousepush=MouseButton(1) 

  StartDrawing(ScreenOutput()) 
  DrawingMode(4) 
  ; Punkte zeichnen 
  If key=1 : x1=MouseX() : y1=MouseY() : Circle(x1,y1,5,cr) : Else : Circle(x1,y1,5,cw) : EndIf 
  If key=2 : x2=MouseX() : y2=MouseY() : Circle(x2,y2,5,cr) : Else : Circle(x2,y2,5,cw) : EndIf 
  If key=3 : x3=MouseX() : y3=MouseY() : Circle(x3,y3,5,cr) : Else : Circle(x3,y3,5,cw) : EndIf 
  If key=4 : x4=MouseX() : y4=MouseY() : Circle(x4,y4,5,cr) : Else : Circle(x4,y4,5,cw) : EndIf 
  
  ; Bezierkurve zeichnen 
  bezier(x1,y1,x2,y2,x3,y3,x4,y4,cw) 

  StopDrawing() 
    
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
Until KeyboardPushed(1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
