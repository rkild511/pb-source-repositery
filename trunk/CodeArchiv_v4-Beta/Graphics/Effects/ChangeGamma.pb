; German forum:
; Author: CyberRun8 (updated for PB4.00 by blbltheworm)
; Date: 21. March 2003
; OS: Windows
; Demo: Yes

;-Variablen bestimmen 
Kanal$ = "rot" 
rot = 255 
gruen = 255 
blau = 255 

Infotext$ = "Farbkanal wählen mit F1 (rot), F2 (grün) und F3 (blau)." + Chr(13) 
Infotext$ + "Intensität erhöhen/vermindern mit +/- vom Zifferblock." 
MessageRequester("Info", Infotext$, 0) 

;-DirectX 
If InitSprite() = 0 Or InitKeyboard() = 0 
  MessageRequester("Fehler", "DirectX ist nicht aktuell.", 0) 
  End 
EndIf 

;-Vollbild darstellen 
If OpenScreen(640, 480, 16, "Vollbild") = 0 
  MessageRequester("Fehler", "Auflösung konnte nicht dargestellt werden", 0) 
  End 
EndIf 

;-Sprite laden 
If LoadSprite(0, "..\Gfx\PureBasic.bmp") = 0 
  MessageRequester("Info", "Sprite konnte nicht geladen werden.", 0) 
  End 
EndIf 

ChangeGamma(0, 0, 0, 1) ; <---- Startgamma. Vor dem manipulieren des Gammawertes muß Gamma mit dem 
                        ; Flag 1 angegeben werden. 

;-Schleife 
Repeat 
  ExamineKeyboard() 
  
  ClearScreen(RGB(0,0,0)) 
    
  For x = 0 To 624 Step 163 
    For y = 32 To 464 Step 35 
      DisplaySprite(0, x, y) 
    Next y 
  Next x 
  
  Gosub Gamma_aendern 
    
  ChangeGamma(rot, gruen, blau, 0); <---- Neuer Gammawert 
  FlipBuffers() 
            
Until KeyboardPushed(#PB_Key_Escape) 
End 

Gamma_aendern: 
  If KeyboardPushed(#PB_Key_F1) 
    Kanal$ = "rot" 
  ElseIf KeyboardPushed(#PB_Key_F2) 
    Kanal$ = "grün" 
  ElseIf KeyboardPushed(#PB_Key_F3) 
    Kanal$ = "blau"  
  EndIf 
  
  If KeyboardPushed(#PB_Key_Add) 
    If Kanal$ = "rot" 
      rot + 1 
      If rot > 255: rot = 255: EndIf 
    ElseIf Kanal$ = "grün" 
      gruen + 1 
      If gruen > 255: gruen = 255: EndIf 
    ElseIf Kanal$ = "blau" 
      blau + 1 
      If blau > 255: blau = 255: EndIf 
    EndIf    
  EndIf 
  
  If KeyboardPushed(#PB_Key_Subtract) 
    If Kanal$ = "rot" 
      rot - 1 
      If rot < 0: rot = 0: EndIf 
    ElseIf Kanal$ = "grün" 
      gruen - 1 
      If gruen < 0: gruen = 0: EndIf 
    ElseIf Kanal$ = "blau" 
      blau - 1 
      If blau < 0: blau = 0: EndIf 
    EndIf  
  EndIf 
  
  StartDrawing(ScreenOutput()) 
    Text$ = "Aktueller Farbkanal: " + Kanal$ + " |   rot: " + Str(rot) 
    Text$ + "   gruen: " + Str(gruen) + "   blau: " + Str(blau) 
    DrawText(0,0,Text$)    
  StopDrawing() 
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -