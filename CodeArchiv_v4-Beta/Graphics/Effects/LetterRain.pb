; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3920&highlight=
; Author: AndyMars (updated for PB 4.00 by Andre)
; Date: 21. May 2004
; OS: Windows
; Demo: Yes

#ScrW=1024
#ScrH=768

Structure CharDat
  x.l
  y.l
  c.l ;Farbe Grün...
  v.l ;Geschwindigkeit
  s.s
EndStructure

Global NewList Chars.CharDat()

Procedure _MakeSign()
  Chars()\x=Random(#ScrW)
  Chars()\y=Random(#ScrH)
  Chars()\c=Random(200)+50
  Chars()\v=Random(5)+1
  Chars()\s=Chr(32+Random(220))
EndProcedure

For i=1 To 1000
  AddElement(Chars())
  _MakeSign()
Next

If InitSprite()=0
  End
EndIf

If OpenScreen(#ScrW, #ScrH, 16,"Matrix")=0
  End
EndIf

If InitKeyboard()=0
  End
EndIf

Repeat
  FlipBuffers()
  ClearScreen(RGB(0,0,0))
  If StartDrawing(ScreenOutput())
    DrawingMode(1)
    ForEach Chars()
      ;erst alte Position löschen
      FrontColor(RGB(0,0,0))
      DrawText(Chars()\x,Chars()\y,Chars()\s)
      Chars()\y+Chars()\v
      If Chars()\y>#ScrH
        ;Bilschirm verlassen? Hopp - ein neuer Anfang
        _MakeSign()
      EndIf
      ;dann an neuer Position neu zeichnen
      FrontColor(RGB(0,Chars()\c,0))
      DrawText(Chars()\x,Chars()\y,Chars()\s)
    Next
    StopDrawing()
  EndIf
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger