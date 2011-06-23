; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1037&highlight=
; Author: CyberRun8 (updated for PB4.00 by blbltheworm)
; Date: 18. May 2003 
; OS: Windows
; Demo: Yes

If InitSprite() = 0 Or InitKeyboard() = 0 
  MessageRequester("Fehler", "DirectX ist nicht aktuell.", 0) 
  End 
EndIf 

If OpenScreen(640, 480, 16, "Vollbild") = 0 
  MessageRequester("Fehler", "Auflösung konnte nicht dargestellt werden", 0) 
  End 
EndIf 
  
If LoadSprite(0, "..\Gfx\PB2.bmp") = 0 
  MessageRequester("Info", "Sprite konnte nicht geladen werden.", 0) 
  End 
EndIf 

ChangeGamma(0, 0, 0, 1) 

Repeat 
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_All) 
; Press any key to start / Zum starten eine Taste drücken 

For a = 0 To 255 Step 1 
  ClearScreen(RGB(0,0,0)) 
  ChangeGamma(a, a, a, 0) 
  DisplaySprite(0, 304, 224) 
  FlipBuffers() 
Next 

For b = 255 To 0 Step -1 
  ClearScreen(RGB(0,0,0)) 
  ChangeGamma(b, b, b, 0) 
  DisplaySprite(0, 304, 224) 
  FlipBuffers() 
Next 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
