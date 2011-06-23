; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3380&highlight=
; Author: zomtex2003 (updated for PB4.00 by blbltheworm)
; Date: 10. January 2004
; OS: Windows
; Demo: Yes


;######################################################## 
; 
;  PureBasic Beispiel: Schiefer Wurf 
;  Autor:              Michael Eberhardt (Zomtex2003) 
;  Datum:              10.01.2004 
;  
;                      German Forum 
; 
;######################################################## 

; Simuliert einen schiefen Wurf. Hat etwas mit Gravitation, Schub und
; Flug zu tun. Das Beispiel ist nicht ganz realitätsnah, da müßte noch
; der Maßstab und der zeitliche Verlauf angepasst werden - aber die
; Flugkurve stimmt. 

#COLOR_RES = 16 
#SCREEN_X  = 1024 
#SCREEN_Y  = 768 

h0.f      = 0.0   ; Starthöhe 
v0.f      = 80.0  ; Abschußgeschwindigkeit 
winkel.f  = 50.0  ; Abschußwinkel 
g.f       = 9.81  ; Erdbeschleunigung 

v_start.f = v0; 

Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel * (2 * 3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel * (2 * 3.14159265/360)) 
EndProcedure 

InitSprite() 
InitKeyboard() 


If OpenScreen(#SCREEN_X, #SCREEN_Y, #COLOR_RES, "Schiefer Wurf") 
  ;LoadSprite(0, "Kugel.bmp") 
  ;TransparentSpriteColor(0, 0, 0, 255) 
  Delay(2000) 
  Repeat 
    
    For t = 1 To 200 
      ExamineKeyboard() 
      StartDrawing(ScreenOutput()) 
        LineXY(50, 50, 50, 550, RGB(255, 0, 0)) 
        LineXY(50, 500, #SCREEN_X - 20, 500, RGB(255, 0, 0)) 

        For i = 1 To #SCREEN_Y Step 100 
          LineXY(0, i, #SCREEN_X, i, RGB(0, 255, 0)) 
          LineXY(i + 50, 0, i + 50, #SCREEN_Y, RGB(0, 255, 0)) 
        Next i 
        
        y = h0 + (v0 * t / 5 * GSin(winkel)) - ((g / 2) * t / 5 * t / 5) 
        x = v0 * t / 5 * GCos(winkel) 
      
        ;LineXY(x + 50, 500 - y, x + 50, 500, RGB(0, 0, 255)) 
        Circle(x + 50, 500 - y, 10, RGB(255, 0, 0)) 

      StopDrawing() 
      ;DisplayTransparentSprite(0, x + 50, 500 - y) 

      FlipBuffers() 
      ClearScreen(RGB(0,0,0)) 

      If KeyboardPushed(#PB_Key_Escape) 
        End 
      EndIf 
    Next t 
    v0 = v_start 

    Delay(1)    
  ForEver 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
