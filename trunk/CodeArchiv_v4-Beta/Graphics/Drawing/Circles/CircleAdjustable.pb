; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5144&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 26. July 2004
; OS: Windows
; Demo: Yes

; Das 3. Beispiel zeigt dann gleich wie man damit verschiedene 
; Formen malen kann, zum Beispiel 6-Ecke, 8-Ecke, kurz gesagt n-Ecke... 
; ----------------------------------------------------------------------
; Durch die Schrittweite (die man hier mit den Tasten F1 und F2 
; verstellen kann) wird angegeben, wie oft man die 360 Grad 
; eines Kreises einteilt. 
; 360 / 4 ist 90, d.h. alle 90 Grad befindet sich ein Punkt, und 
; der vorhergehende wird immer mit dem nächsten Punkt verbunden. 
; 
; Bei kleinen Schrittweiten (4,6, erhält man immer entsprechende 
; n-Ecke. 
; Nimmt man dabei nun größere Zahlen, dann ergibt sich daraus 
; ein Kreis. 
; 
; Im Modus "1" (Taste F3) werden zusätzlich noch Linien vom Mittelpunkt 
; zu den jeweiligen Ecken gezeichnet... und das ist das schon 
; wie ein Kegel von oben gesehen. Die Mitte ist die Spitze und 
; der Kreis (n-Ecke) ist die Unterseite des Kegels. 
; Bei einer Schrittweite von 4 (90 Grad) ergibt sich so also von 
; oben gesehen eine Pyramide. 

Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

;----- 

#sw = 1024 
#sh = 768
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


Procedure DrawCircle(schritt,modus) 
  If schritt < 4 : schritt = 4 : EndIf 

  If StartDrawing(SpriteOutput(1)) 
    Box(0,0,300,300,$000000) 

    FrontColor(RGB($FF,$FF,$00)) 
    
    old_x = 150 + GSin(0) * 140 
    old_y = 150 + GCos(0) * 140 

    While grad.f < 360+schritt 
      new_x = 150 + GSin(grad) * 140 
      new_y = 150 + GCos(grad) * 140 
      If modus ; linien vom mittelpunkt ziehen 
        LineXY(150,150,new_x,new_y) 
      EndIf 
      LineXY(old_x,old_y,new_x,new_y) 
      old_x = new_x 
      old_y = new_y 
      grad + 360/schritt 
    Wend 

    StopDrawing() 
  EndIf 

EndProcedure 

If CreateSprite(1,300,300)=0 
  CloseScreen() 
  MessageRequester("ERROR","Cant create sprite !"):End 
Else 
  DrawCircle(4,0) 
EndIf 

Schrittweite = 4 
Modus        = 1 

Repeat 
    ExamineKeyboard() 
    FlipBuffers() 
    If IsScreenActive() 
      ClearScreen (RGB(0,0,0)) 

      DisplayTransparentSprite(1,#sw/2-150,#sh/2-150) 
      
      If KeyboardPushed(#PB_Key_F1) And keypressed = 0 
        Schrittweite + 1 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_F2) And keypressed = 0 
        Schrittweite - 1 
        If Schrittweite < 4 : Schrittweite = 4.0 : EndIf 
        keypressed = 5 
      ElseIf KeyboardPushed(#PB_Key_F3) And keypressed = 0 
        Modus!1 
        keypressed = 5 
      EndIf 
      If keypressed : keypressed - 1 : EndIf      
      

      If StartDrawing(ScreenOutput()) 
        FrontColor(RGB(255,255,255)) 
        DrawingMode(1) 
        DrawText(50,30,"Schrittweite (F1/F2): " + Str(Schrittweite)) 
        DrawText(50,50,"Modus (F3): " + Str(Modus)) 
        StopDrawing() 
      EndIf 

      DrawCircle(Schrittweite,Modus) 
      Delay(20) 

    EndIf 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -