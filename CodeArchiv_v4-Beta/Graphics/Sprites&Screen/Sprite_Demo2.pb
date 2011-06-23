; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=655&highlight=
; Author: Froggerprogger (updated for PB4.00 by blbltheworm)
; Date: 18. April 2003
; OS: Windows
; Demo: Yes

; some nonsense-code from Froggerprogger 
InitKeyboard() : InitSprite() : InitMouse() 
#scr_x = 1024 
#scr_y = 768 

le.s = Chr(13) + Chr(10) + Chr(13) + Chr(10) 
MessageRequester("Grafik Test Programm", "Maus hoch/runter = Ballgröße ändern (hoch=größer / runter=kleiner)"+le+"Maus links/rechts = Ballspeed ändern (links=schneller / rechts=langsamer)"+le+"Space = Toggle ClearScreen on/off (+Maus bewegen für tolle Grafikeffekte)",#MB_ICONASTERISK) 

SetRefreshRate(60)    ; TFT monitors mostly allow only 60 Hz, you can chage the rate to 85 or higher if it runs for you...

If OpenScreen(#scr_x, #scr_y, 32, "Grafik Test Programm") 
  
  Y=100 : x=100 : spd = 8 
  a = spd :b = spd 
  r = 20  ;Radius 
  fr = 254 ;Farbwert rot 
  fr_up = 0 ;toggled zwischen 0 und 2 
  
  toggle = 1 ;1 = Clearscreen JA, 0 = Clearscreen NEIN 
  
  Repeat 
    ExamineMouse() 
    
    r - MouseDeltaY()/10 
    If r < 2 : r = 2 : ElseIf r > #scr_y/2 : r = #scr_y/2 : EndIf 
    spd - MouseDeltaX() / 40 
    If spd < 0 : spd = 0 : EndIf 
    If a < 0 : a = -spd : Else : a = spd : EndIf 
    If b < 0 : b = -spd : Else : b = spd : EndIf 
    
    x + a 
    Y + b 
    
    If (x + a > #scr_x-r And a > 0) Or (x - a < r And a < 0) 
        a = -a 
    EndIf 
    
    If (Y + b > #scr_y-r And b > 0 ) Or (Y - b < r And b < 0) 
        b = -b 
    EndIf 
    
    If toggle : ClearScreen(RGB(125,125,125)) : EndIf 
    
    StartDrawing(ScreenOutput()) 
        Circle(x, y, r,RGB(fr,fg,fb)) ;male Kreis 
        If fr = 255 Or fr = 100 : fr_up!2 : EndIf ; Farbblödsinn 
        fr + fr_up - 1 
    
        If toggle 
            DrawingMode(1) : FrontColor(RGB(0,0,0)) 
            DrawText(10, 30,Str(r)+"  Ballradius  ") 
            DrawText(10, 50,Str(spd)+"  Ballspeed  ") 
        EndIf 
    StopDrawing() 
    
    FlipBuffers() 
    
    ExamineKeyboard() 
    If KeyboardReleased(#PB_Key_Space) : toggle!1 : ClearScreen(RGB(125,125,125)) : FlipBuffers() : ClearScreen(RGB(125,125,125)) : EndIf 
  
  Until KeyboardPushed(#PB_Key_Escape) 

EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
