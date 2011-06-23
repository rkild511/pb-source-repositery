; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1898&highlight=
; Author: CSprengel (updated for PB4.00 by blbltheworm)
; Date: 03. August 2003
; OS: Windows
; Demo: No


; Press the left mouse button to switch between the two demo modes
; Drücke die linke Maustaste, um zwischen den beiden Demo-Modi umzuschalten

;Danke an Reiner (von ihm stammt die Grafik), der viele Sprites auf seiner Page frei zur Verfügung 
;stellt: http://www.reinerstileset.4players.de:1059/ 

;-DirectX 
If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse()= 0 
  MessageRequester("Fehler", "DirectX ist nicht aktuell.", 0) 
  End 
EndIf 

;-Konstanten setzen 
#MausClip = 0 
#SpriteWandern = 1 

;-Variablen bestimmen 
ClipX = 0 
WandernX = 0 
Ablauf_pro_Sekunde = 4   ; Gibt an, wie oft die Animation in der Sekunden ablaufen soll. 
Bilder_pro_Animation = 14; Gibt die Anzahl der Bilder pro Animation an. 

;-Vollbild darstellen 
If OpenScreen(640, 480, 16, "Vollbild") = 0 
  MessageRequester("Fehler", "Auflösung konnte nicht dargestellt werden", 0) 
  End 
EndIf 

;-Sprite laden 
If LoadSprite(#MausClip, "clipsprite.bmp") = 0 
  MessageRequester("Fehler", "Der Sprite konnte nicht geladen werden.", 0) 
  End 
EndIf 
CopySprite(#MausClip, #SpriteWandern) 

TransparentSpriteColor(#MausClip, RGB(106, 76, 48))
TransparentSpriteColor(#SpriteWandern, RGB(106, 76, 48))

MouseLocate(320, 240); Startposition der Maus festlegen 
;-Schleife 
Repeat 
  ExamineKeyboard() 
  ExamineMouse() 
  
  If MausKnopf = #False 
    If SpriteSichtbar = #True And MouseButton(1) = #True 
      SpriteSichtbar = #False 
      MausKnopf = #True ;Maustaste wird gesperrt, da sie betätigt wurde 
    ElseIf SpriteSichtbar = #False And MouseButton(1) = #True 
      SpriteSichtbar = #True 
      MausKnopf = #True ;Maustaste wird gesperrt, da sie betätigt wurde 
    EndIf 
  EndIf 
  
  ClearScreen(RGB(0, 0, 0))
  
    If ElapsedMilliseconds() => Zeit + 1000 / (Bilder_pro_Animation * Ablauf_pro_Sekunde) 
      ;Es bringt natürlich nichts, wenn Bilder_pro_Animation * Ablauf_pro_Sekunde die FPS überschreiten. 
      Zeit = GetTickCount_() 
      ClipX + 64 
      WandernX + 4 
    EndIf  
  
    ClipSprite(#MausClip, ClipX, 0, 64, 64)        
    ClipSprite(#SpriteWandern, WandernX, 0, 64, 64) 
  
    If SpriteSichtbar = #False 
      DisplayTransparentSprite(#SpriteWandern, 288, 208) 
    ElseIf SpriteSichtbar = #True 
      DisplayTransparentSprite(#MausClip, MouseX() - 32, MouseY() - 32) 
    EndIf 
  
    StartDrawing(ScreenOutput()) 
      ;DrawText("Bitte Linke Maustaste drücken") 
      Plot(MouseX(), MouseY(), $0000FF) ;Cursor-Position 
    StopDrawing() 
  
  FlipBuffers() 
  
  If ClipX    => 832: ClipX = 0   : EndIf 
  If WandernX => 832: WandernX = 0: EndIf 
  
  ;Gibt Maustaste wieder frei, wenn sie nicht mehr gedrückt ist 
  If MausKnopf = #True And MouseButton(1) = #False 
    MausKnopf = #False 
  EndIf 
Until KeyboardPushed(#PB_Key_Escape) 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -