; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3920&highlight=
; Author: AndyMars (updated for PB 4.00 by Andre)
; Date: 22. May 2004
; OS: Windows
; Demo: No

#ScrW=640 
#ScrH=480 
#MaxIndex=1000 

Global Dim x.l(#MaxIndex) 
Global Dim y.l(#MaxIndex) 
Global Dim c.l(#MaxIndex) ;Farbe Grün... 
Global Dim v.l(#MaxIndex) ;Geschwindigkeit 
Global Dim l.l(#MaxIndex) ;Länge des Nachzuges 
Global Dim s.l(#MaxIndex) 

Procedure _MakeSign(Index.l,Initial.b) ;Index, erstes Mal? 
  x(Index)=Random(#ScrW) 
  If Initial 
    y(Index)=Random(#ScrH) 
  Else 
    y(Index)=-12 
  EndIf 
  c(Index)=Random(200)+55 
  v(Index)=Random(5)+1 
  l(Index)=Random(7)+3 
  s(Index)=33+Random(93) 
EndProcedure 

For i=0 To #MaxIndex 
  _MakeSign(i,1) 
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

FontID=LoadFont(1, "Matrix Code NFI", 12) 
If FontID=0 
  Beep_(2000,20) 
EndIf 

Repeat 
  FlipBuffers() 
  ClearScreen(RGB(0, 0, 0))
  If StartDrawing(ScreenOutput()) 
    DrawingMode(1) 
    DrawingFont(FontID) 
    For ci=0 To #MaxIndex 
      y(ci)+v(ci) 
      For i=10 To 1 Step -1 
        color=c(ci)-20*i:If color<0:color=0:EndIf 
        FrontColor(RGB(0, color, 0))
        x = x(ci) :  y = y(ci)-(i*l(ci))
        z=ci+i 
        If z>#MaxIndex : z=i : EndIf 
        DrawText(x, y, Chr(s(z))) 
      Next 
      z=Random(100) 
      If z<5 
        s(ci)=33+Random(93) 
      EndIf 
      FrontColor(RGB(0, c(ci), 0))
      DrawText(x(ci), y(ci), Chr(s(ci))) 
      If y(ci)>#ScrH+v(ci)*5 
        ;Bilschirm verlassen? Hopp - ein neuer Anfang 
        _MakeSign(ci,0) 
      EndIf 
    Next 
    StopDrawing() 
  EndIf    
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger