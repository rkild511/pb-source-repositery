; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1364&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 15. June 2003
; OS: Windows
; Demo: Yes


; Move the cursor keys to see effect !
; Bewegen Sie die Cursor-Tasten, um den Effekt sehen zu können!

#Hintergrundbild =  1 
#Mauszeiger      =  2 
#Spieler         =  3 

Structure Spieler 
  x.f 
  y.f 
  Groesse.l 
  Geschwindigkeit.l 
EndStructure 
Define.Spieler Spieler 

Breite = 800 
Hoehe = 600 
Tiefe = 32 
Titel$ = "ChaOsGameScreenScroller" 
SpielfeldBreite = 1600 
SpielfeldHoehe = 1200 
Spieler\x = Breite/2 
Spieler\y = Hoehe/2 
Spieler\Groesse = 64 
Spieler\Geschwindigkeit = 2 

If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  ;Dieser Befehl versucht, DirectX 7 zu initialisieren. 
  MessageRequester("DirectX fehler !", "Fehler", #PB_MessageRequester_Ok) 
  End 
EndIf 

If OpenScreen(Breite, Hoehe, Tiefe, Titel$) = 0 
  End 
EndIf 

CreateSprite(#Hintergrundbild, SpielfeldBreite, SpielfeldHoehe, 0) 
CreateSprite(#Mauszeiger, 32, 32, 0) 
CreateSprite(#Spieler, Spieler\Groesse, Spieler\Groesse, 0) 

StartDrawing(SpriteOutput(#Mauszeiger)) ;Grafiken werden direkt auf dem Sprite gerendert 
  DrawingMode(4) 
  Circle(16, 16, 16, $ffffff) 
StopDrawing() 
StartDrawing(SpriteOutput(#Spieler)) ;Grafiken werden direkt auf dem Sprite gerendert 
  Box(1, 1, Spieler\Groesse, Spieler\Groesse, $ffff00) 
StopDrawing() 

Quit = 0 
Repeat 
  FlipBuffers() 
  ExamineMouse() 
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) 
    Quit = 1 
  EndIf 
  If Spieler\x < 0 : Spieler\x = 0 : EndIf 
  If Spieler\y < 0 : Spieler\y = 0 : EndIf 
  If Spieler\x + HintergrundX + Spieler\Groesse > Breite 
    Spieler\x = Breite - HintergrundX - Spieler\Groesse 
  EndIf 
  If Spieler\y + HintergrundY + Spieler\Groesse > Hoehe 
    Spieler\y = Hoehe - HintergrundY - Spieler\Groesse 
  EndIf 
  ; 
  If KeyboardPushed(#PB_Key_Left) Or KeyboardPushed(#PB_Key_A) 
    Spieler\x - Spieler\Geschwindigkeit 
  EndIf 
  If KeyboardPushed(#PB_Key_Right) Or KeyboardPushed(#PB_Key_D) 
    Spieler\x + Spieler\Geschwindigkeit 
  EndIf 
  ; 
  If KeyboardPushed(#PB_Key_Up) Or KeyboardPushed(#PB_Key_W) 
    Spieler\y - Spieler\Geschwindigkeit 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) Or KeyboardPushed(#PB_Key_S) 
    Spieler\y + Spieler\Geschwindigkeit 
  EndIf 

  ;- HintergrundVerschieben 
  Einteilungsfaktor.b = 5 
  If Spieler\x + HintergrundX > Breite / Einteilungsfaktor * 3 
    HintergrundX - Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\y + HintergrundY > Hoehe / Einteilungsfaktor * 3 
    HintergrundY - Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\x + HintergrundX < Breite / Einteilungsfaktor * 2 
    HintergrundX + Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\y + HintergrundY < Hoehe / Einteilungsfaktor * 2 
    HintergrundY + Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\x + HintergrundX > Breite / Einteilungsfaktor * 4 
    HintergrundX - Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\y + HintergrundY > Hoehe / Einteilungsfaktor * 4 
    HintergrundY - Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\x + HintergrundX < Breite / Einteilungsfaktor 
    HintergrundX + Spieler\Geschwindigkeit/2 
  EndIf 
  If Spieler\y + HintergrundY < Hoehe / Einteilungsfaktor 
    HintergrundY + Spieler\Geschwindigkeit/2 
  EndIf 
  If HintergrundX > 0 
    HintergrundX = 0 
  EndIf 
  If HintergrundY > 0 
    HintergrundY = 0 
  EndIf 
  If HintergrundX < Breite - Spielfeldbreite 
    HintergrundX = Breite - Spielfeldbreite 
  EndIf 
  If HintergrundY < Hoehe - SpielfeldHoehe 
    HintergrundY = Hoehe - SpielfeldHoehe 
  EndIf 
  ; 
  ;ClearScreen(0,0,0) ;  kann man sich sparen weil das Hintergrundbild alles plattmacht 
  StartDrawing(SpriteOutput(#Hintergrundbild)) ;Grafiken werden direkt auf dem Hintergrundbildsprite gerendert 
    ; Spuren zeichnen 
    Plot(Spieler\x + Spieler\Groesse/2,Spieler\y + Spieler\Groesse/2, $f0f0f0) 
  StopDrawing() 
  DisplaySprite(#Hintergrundbild, HintergrundX, HintergrundY) 
  DisplayTransparentSprite(#Spieler, Spieler\x + HintergrundX, Spieler\y + HintergrundY) 
  DisplayTransparentSprite(#Mauszeiger, MouseX(), MouseY()) 
  
Until Quit = 1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
