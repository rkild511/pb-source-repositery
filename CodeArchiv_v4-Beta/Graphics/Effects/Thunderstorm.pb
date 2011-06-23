; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1019&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 15. May 2003
; OS: Windows
; Demo: Yes


; Thunderstorm effect
; Gewittersturm Effekt

Procedure InitDirectX() 
  If InitSprite() And InitKeyboard() And InitMouse() And InitSound() 
    ProcedureReturn #True 
  EndIf 
EndProcedure 

Global Width.l, Height.l 
Width = 1024 
Height = 768 

Procedure Gewitter(x1.l, y1.l, Anzahl.l, Rekursion.l) 
  If x1 = -1 : x1 = Random(Width) : EndIf 
  If y1 = -1 : y1 = Random(Height) : EndIf 
  Rekursion - 1 
  For a.l = 1 To Anzahl 
    x2.l = x1 + Random(200) - 100 
    If x2 < 0 : x2 = 0 : EndIf 
    If x2 > Width : x2 = Width : EndIf 
    y2.l = (Height - y1) / (2 + Random(4)) + y1 

    LineXY(x1, y1, x2, y2, $FFFFFF) 
    Dicke.l = Rekursion 
    For b.l = 1 To Dicke 
      ColorSW.l = (Dicke - b + 1) * 255 / Dicke 
      LineXY(x1 - b, y1, x2 - b, y2, RGB(ColorSW, ColorSW, ColorSW)) 
      LineXY(x1 + b, y1, x2 + b, y2, RGB(ColorSW, ColorSW, ColorSW)) 
    Next 
    
    If Rekursion 
      Gewitter(x2, y2, Random(2) + 1, Rekursion) 
    EndIf 
  Next 
EndProcedure 

InitDirectX() 

If OpenScreen(Width, Height, 16, "Gewitter") 
  NextTS.l = ElapsedMilliseconds() + Random(2000) 
  Repeat 
    ClearScreen(RGB(backlight,backlight,backlight)) 
    StartDrawing(ScreenOutput()) 
      If NextTS <= ElapsedMilliseconds() 
        Gewitter(-1, Random(100), 1, 4) 
        
        backlight = 250 
        
        NextTS.l = ElapsedMilliseconds() + Random(2000) 
      EndIf 
      
      If backlight 
        backlight - 10 
      EndIf 
      
      
      DrawText(0, 0,Str(NextTS - ElapsedMilliseconds()) + " ms") 
    StopDrawing() 
    FlipBuffers() 
    ExamineKeyboard() 
  Until KeyboardReleased(#PB_Key_Escape) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
