; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2449&postdays=0&postorder=asc&start=10
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 04. October 2003
; OS: Windows
; Demo: Yes


; Small example for moving a player and shooting:
; use cursor key for moving, space for shooting

; Ein kleines Beispiel zum Figur bewegen und Schüsse abfeuern: 
; Pfeiltasten zum bewegen, Space zum schiessen.


; Screen 
xscreen = 640 
yscreen = 480 

; Kreis 
k_x.f = xscreen/2 
k_y.f = yscreen/2 
k_winkel.f = 180 
k_radius = 15 
k_speed.f = 2 

; Schüsse 
Structure kugel 
  x.f 
  y.f 
  winkel.f 
  speed.f 
EndStructure 

Global NewList schuss.kugel() 


InitKeyboard() 
InitSprite() 


If OpenScreen(xscreen,yscreen,16,"Schusstest") 
    
  Repeat 
    ExamineKeyboard() 
    
    
    ; Kreis bewegen 
    ; Drehen 
    If KeyboardPushed(#PB_Key_Left) : k_winkel - 4 :  If k_winkel <= 0 : k_winkel = 360 : EndIf : EndIf 
    If KeyboardPushed(#PB_Key_Right) : k_winkel + 4 : If k_winkel >= 360 : k_winkel = 0 : EndIf : EndIf 
    
    ; Vorwärts 
    If KeyboardPushed(#PB_Key_Up) 
      k_x + Cos(k_winkel *(2*3.1415/360)) * k_speed ; Grad zu Bogenmaß 
      k_y + Sin(k_winkel *(2*3.1415/360)) * k_speed 
    EndIf 
    
    ; Rückwärts 
    If KeyboardPushed(#PB_Key_Down) 
      k_x + Cos(k_winkel *(2*3.1415/360)) * -k_speed 
      k_y + Sin(k_winkel *(2*3.1415/360)) * -k_speed 
    EndIf    
    
    
    
    
    ; Schuss abfeuern 
    If KeyboardPushed(#PB_Key_Space) And geschossen = 0 
      AddElement(schuss()) 
      schuss()\x = k_radius * Cos(k_winkel *(2*3.1415/360)) + k_x ; Am Rand des Kreises 
      schuss()\y = k_radius * Sin(k_winkel *(2*3.1415/360)) + k_y 
      schuss()\winkel = k_winkel 
      schuss()\speed = 5 
      
      geschossen = 1 ; Erst die Taste wieder loslassen, kein Dauerfeuer 
    EndIf 
    
    If KeyboardReleased(#PB_Key_Space) : geschossen = 0 : EndIf 
    
    
    ; Schüsse bewegen 
    ResetList(schuss()) 
    While NextElement(schuss()) 
      schuss()\x + Cos(schuss()\winkel *(2*3.1415/360)) * schuss()\speed 
      schuss()\y + Sin(schuss()\winkel *(2*3.1415/360)) * schuss()\speed 
      
      ; Kommen sie am Rand an, löschen 
      If schuss()\x > xscreen Or schuss()\x < 0 Or schuss()\y > yscreen Or schuss()\y < 0 
        DeleteElement(schuss()) 
      EndIf 
      
    Wend 
    
    
    ; ------------------------------ 
    
    
    
    ; Zeichnen 
    StartDrawing(ScreenOutput()) 
    
    
    ; Kreis 
    DrawingMode(4) 
    Circle(k_x,k_y,k_radius,RGB(0,100,255)) 
    LineXY(k_x,k_y,k_radius * Cos(k_winkel *(2*3.1415/360)) + k_x,k_radius * Sin(k_winkel *(2*3.1415/360)) + k_y,RGB(0,255,255)) 
    
    
    ; Schüsse 
    ResetList(schuss()) 
    While NextElement(schuss()) 
      LineXY(schuss()\x,schuss()\y,8 * Cos(schuss()\winkel *(2*3.1415/360)) + schuss()\x,8 * Sin(schuss()\winkel *(2*3.1415/360)) + schuss()\y,RGB(255,100,0)) 
    Wend 
    
     ; Text 
    DrawingMode(1) 
    FrontColor(RGB(150,150,150)) 
    DrawText(1,1,"Winkel: " + Str(k_winkel)) 
    DrawText(1,16,"Schüsse: " + Str(CountList(schuss())))    
      
    StopDrawing() 
    
    
    FlipBuffers() 
    ClearScreen(RGB(0,0,0)) 
    
  Until KeyboardPushed(#PB_Key_Escape) 
  
  
Else 
  MessageRequester("Error","Funzt nich",0) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
