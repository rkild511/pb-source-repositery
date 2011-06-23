; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5144&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 26. July 2004
; OS: Windows
; Demo: Yes


; Hier gleich mal noch das letzte Beispiel als Pseudo-3D (nur zur 
; Anschauung, ohne Perspektivenkorrektur etc.) hinterher: 

; Da gibt es jetzt noch die Taste F4, mit der man einstellen 
; kann ob die Verbindungen in 2 Dreiecke zerlegt werden. 
; 
; Dieses Beispiel zeigt die Theorie wie man einen Zylinder 
; oder n-Eck-Röhren in 3D erstellen kann. 
; Die Kreise am Ende sind letztendlich bei einem Model nur 
; virtuell und werden nur zum rechnen genommen. Aus den 
; Verbindungslinien zwischen 2 virtuellen Kreisen (die ja nur 
; in der Z-Axe verschoben sein sollen) bekommt man ein Viereck, 
; welches man wiederum in 2 Dreiecke teilen kann. 



Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

;----- 

#sw = 800 
#sh = 600 
#sn = "Sinus" 

If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init game engine !"):End 
EndIf 

If OpenScreen(#sw,#sh,32,#sn)=0 
  If OpenScreen(#sw,#sh,24,#sn)=0 
    If OpenScreen(#sw,#sh,16,#sn)=0 
      If OpenScreen(#sw,#sh,08,#sn)=0 
        MessageRequester("ERROR","Cant open screen !"):End 
EndIf:EndIf:EndIf:EndIf 


Procedure DrawCircle(schritt,modus,Zeige_Dreiecke) 
  If schritt < 4 : schritt = 4 : EndIf 

  If StartDrawing(SpriteOutput(1)) 
    Box(0,0,500,500,$000000) 

    ; Hinteres n-Eck 
    offX = 100 
    offY = -50 
    FrontColor(RGB($80,$80,$80)) 
    old_x = 150 + GSin(0) * 140 
    old_y = 250 + GCos(0) * 140 
    While grad.f < 360+schritt 
      new_x = 150 + GSin(grad) * 140 
      new_y = 250 + GCos(grad) * 140 
      If modus ; linien vom mittelpunkt ziehen 
        LineXY(150+offX,250+offY,new_x+offX,new_y+offY) 
      EndIf 
      LineXY(old_x+offX,old_y+offY,new_x+offX,new_y+offY) 
      old_x = new_x 
      old_y = new_y 
      grad + 360/schritt 
    Wend 

    ; verbindungslinien 
    grad = 0 
    old_x = 150 + GSin(0) * 140 
    old_y = 250 + GCos(0) * 140 
    While grad.f < 360+schritt 
      new_x = 150 + GSin(grad) * 140 
      new_y = 250 + GCos(grad) * 140 
      LineXY(old_x,old_y,old_x+offX,old_y+offY,$FF0000) 
      ; In 3-Ecke Spalten: 
      If Zeige_Dreiecke 
        LineXY(old_x,old_y,new_x+offX,new_y+offY,$800000) 
      EndIf 
      old_x = new_x 
      old_y = new_y 
      grad + 360/schritt 
    Wend 

    ; Vorderes n-Eck 
    offX = 0 
    offY = 0 
    grad = 0 
    old_x = 150 + GSin(0) * 140 
    old_y = 250 + GCos(0) * 140 

    FrontColor(RGB($FF,$FF,$FF)) 
    While grad.f < 360+schritt 
      new_x = 150 + GSin(grad) * 140 
      new_y = 250 + GCos(grad) * 140 
      If modus ; linien vom mittelpunkt ziehen 
        LineXY(150,250,new_x,new_y) 
      EndIf 
      LineXY(old_x,old_y,new_x,new_y) 
      old_x = new_x 
      old_y = new_y 
      grad + 360/schritt 
    Wend 


    StopDrawing() 
  EndIf 

EndProcedure 

If CreateSprite(1,500,500)=0 
  CloseScreen() 
  MessageRequester("ERROR","Cant create sprite !"):End 
Else 
  DrawCircle(5,0,0) 
EndIf 

Schrittweite = 5 
Modus        = 0 

Repeat 
    ExamineKeyboard() 
    FlipBuffers() 
    If IsScreenActive() 
      ClearScreen (RGB(0,0,0)) 

      DisplayTransparentSprite(1,#sw/2-250,#sh/2-250) 
      
      If KeyboardPushed(#PB_Key_F1) And keypressed = 0 
        Schrittweite + 1 
        keypressed = 5 
        DrawCircle(Schrittweite,Modus,Zeige_Dreiecke) 
      ElseIf KeyboardPushed(#PB_Key_F2) And keypressed = 0 
        Schrittweite - 1 
        If Schrittweite < 4 : Schrittweite = 4.0 : EndIf 
        keypressed = 5 
        DrawCircle(Schrittweite,Modus,Zeige_Dreiecke) 
      ElseIf KeyboardPushed(#PB_Key_F3) And keypressed = 0 
        Modus!1 
        keypressed = 5 
        DrawCircle(Schrittweite,Modus,Zeige_Dreiecke) 
      ElseIf KeyboardPushed(#PB_Key_F4) And keypressed = 0 
        Zeige_Dreiecke!1 
        keypressed = 5 
        DrawCircle(Schrittweite,Modus,Zeige_Dreiecke) 
      EndIf 
      If keypressed : keypressed - 1 : EndIf      
      

      If StartDrawing(ScreenOutput()) 
        FrontColor(RGB(255,255,255)) 
        DrawingMode(1) 
        DrawText(50,30,"Schrittweite (F1/F2): " + Str(Schrittweite)) 
        DrawText(50,50,"Modus (F3): " + Str(Modus)) 
        DrawText(50,70,"Zeige Dreiecke (F4): " + Str(Zeige_Dreiecke)) 
        StopDrawing() 
      EndIf 

      Delay(20) 

    EndIf 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -