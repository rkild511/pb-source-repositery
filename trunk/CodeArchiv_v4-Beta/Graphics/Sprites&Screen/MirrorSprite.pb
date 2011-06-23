; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2636&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 23. October 2003
; OS: Windows
; Demo: No

; Mirror a sprite, use Return or Space to see the effect, Esc for quit
; Spiegeln eines Sprites, benutze Return oder Space zum Ansehen des Effekts, Esc für Abbruch

; Die Funktion StretchBlt kopiert eine Bitmap aus einem Speicher-Gerätekontext in einen
; anderen Gerätekontext, wobei die Höhe und die Breite von Quell- und Zielbereich sich
; unterscheiden können und dadurch Vergößerungen und Verkleinerungen ebenso möglich werden
; wie Verzerrungen oder Spiegelungen um die horizonale und/oder vertikale Achse. Alle
; Koordinaten- und Größenangaben werden in Pixeln angegeben.

Breite.l = GetSystemMetrics_(#SM_CXSCREEN) 
Hoehe.l = GetSystemMetrics_(#SM_CYSCREEN) 
hdc.l = GetDC_(0) 
Tiefe.l = GetDeviceCaps_(hdc, #BITSPIXEL) 
ReleaseDC_(0, hdc) 
If InitSprite() = 0 Or InitKeyboard() = 0 Or OpenScreen(Breite, Hoehe, Tiefe, "") = 0 
  End 
EndIf 

Procedure MirrorSprite(SpriteID.l, Direction.l) 
  hdc = StartDrawing(SpriteOutput(SpriteID)) 
    Height = SpriteHeight(SpriteID) 
    Width = SpriteWidth(SpriteID) 
    If Direction 
      StretchBlt_(hdc, 0, Height, Width, -Height, hdc, 0, 0, Width, Height, #SRCCOPY) 
    Else 
      StretchBlt_(hdc, Width, 0, -Width, Height, hdc, 0, 0, Width, Height, #SRCCOPY) 
    EndIf 
  StopDrawing() 
EndProcedure 

Width = 100 
Height = 30 
CreateSprite(0,Width,Height) 
StartDrawing(SpriteOutput(SpriteID)) 
  DrawingMode(1) 
  FrontColor(RGB(255,255,255)) 
  DrawText(0,0,"1234567890") 
StopDrawing() 
  
Repeat 
  ClearScreen(RGB(0,0,0)) 
  ; Tastaturabfrage 
  If ExamineKeyboard() 
    If KeyboardPushed(#PB_Key_Escape) 
      Quit = 1 
    EndIf 
    If KeyboardReleased(#PB_Key_Space) 
      MirrorSprite(0, 0) 
    EndIf 
    If KeyboardReleased(#PB_Key_Return) 
      MirrorSprite(0, 1) 
    EndIf 
  EndIf 
  DisplayTransparentSprite(0, Breite/2-50, Hoehe/2-25) 
  FlipBuffers() 
Until Quit > 0

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
