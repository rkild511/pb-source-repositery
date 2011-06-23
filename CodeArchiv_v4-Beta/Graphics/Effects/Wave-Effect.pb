; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3942&highlight=
; Author: Franky (updated for PB 4.00 by Andre)
; Date: 08. March 2004
; OS: Windows
; Demo: Yes

Structure welle
  x.l
  y.l
  radius.l
  posmode.b
EndStructure

If InitSprite()=0
  End
EndIf
If InitMouse()=0
  End
EndIf
If InitKeyboard()=0
  End
EndIf
Declare MyCircle(x.l,y.l,radius.l,wert.b)

If OpenScreen(1024,768,32,"Wellen")
  Global Dim punkt.b(128,96)
  Global NewList klicks.welle()
  CreateSprite(0,8,8)
  StartDrawing(SpriteOutput(0))
  FrontColor(RGB(0,0,255))
  Circle(4,4,4)
  StopDrawing()
  CreateSprite(1,8,8)
  StartDrawing(SpriteOutput(1))
  FrontColor(RGB(0,0,200))
  Circle(4,4,4)
  StopDrawing()
  CreateSprite(2,8,8)
  StartDrawing(SpriteOutput(2))
  FrontColor(RGB(0,0,155))
  Circle(4,4,4)
  StopDrawing()
  CreateSprite(3,8,8)
  StartDrawing(SpriteOutput(3))
  FrontColor(RGB(0,0,100))
  Circle(4,4,4)
  StopDrawing()
  CreateSprite(4,8,8)
  StartDrawing(SpriteOutput(4))
  FrontColor(RGB(0,0,55))
  Circle(4,4,4)
  StopDrawing()
  CreateSprite(5,8,8)
  StartDrawing(SpriteOutput(5))
  FrontColor(RGB(0,0,0))
  Circle(4,4,4)
  StopDrawing()

  ;Mousecursor
  CreateSprite(6,20,20)
  StartDrawing(SpriteOutput(6))
  FrontColor(RGB(255,0,0))
  Circle(1,1,10)
  Line(1,1,20,20)
  Line(2,1,19,20)
  Line(1,2,20,19)
  Line(3,1,18,20)
  Line(1,3,20,18)

  StopDrawing()
  TransparentSpriteColor(6,RGB(0,0,0))
  Repeat
    ClearScreen(RGB(0,0,250))
    For lang=0 To 128
      For hoch=0 To 96
        zahl=punkt(lang,hoch)
        If zahl>0
          zahl=5-(5-(zahl-5))
        EndIf
        DisplaySprite(zahl,(lang)*8,(hoch)*8)
      Next
    Next
    ExamineMouse()
    DisplayTransparentSprite(6,MouseX(),MouseY())
    FlipBuffers()
    If MouseButton(1)=1
      Repeat :ExamineMouse() :Until MouseButton(1)=0  ;Mausklick
      LastElement(klicks())
      AddElement(klicks())
      klicks()\x=MouseX()/8
      klicks()\y=MouseY()/8
      klicks()\radius=1
      If klicks()\x>128-klicks()\x
        If klicks()\y>128-klicks()\y
          klicks()\posmode=0
        Else
          klicks()\posmode=1
        EndIf
      Else
        If klicks()\y>128-klicks()\y
          klicks()\posmode=2
        Else
          klicks()\posmode=3
        EndIf

      EndIf
    EndIf
    ForEach klicks()
      If klicks()\radius>6
        MyCircle(klicks()\x,klicks()\y,klicks()\radius-6,0)
      EndIf
      If klicks()\radius>5
        MyCircle(klicks()\x,klicks()\y,klicks()\radius-5,1)
      EndIf
      If klicks()\radius>4
        MyCircle(klicks()\x,klicks()\y,klicks()\radius-4,2)
      EndIf
      If klicks()\radius>3
        MyCircle(klicks()\x,klicks()\y,klicks()\radius-3,3)
      EndIf
      If klicks()\radius>2
        MyCircle(klicks()\x,klicks()\y,klicks()\radius-2,4)
      EndIf
      If klicks()\radius>1
        MyCircle(klicks()\x,klicks()\y,klicks()\radius-1,5)
      EndIf
      MyCircle(klicks()\x,klicks()\y,klicks()\radius+6,10)
      MyCircle(klicks()\x,klicks()\y,klicks()\radius+5,9)
      MyCircle(klicks()\x,klicks()\y,klicks()\radius+4,8)
      MyCircle(klicks()\x,klicks()\y,klicks()\radius+3,7)
      MyCircle(klicks()\x,klicks()\y,klicks()\radius+2,6)
      MyCircle(klicks()\x,klicks()\y,klicks()\radius+1,5)

      klicks()\radius=klicks()\radius+1
      Select klicks()\posmode
        Case 0
          If klicks()\x*klicks()\x+klicks()\y*klicks()\y<=(klicks()\radius+5)*(klicks()\radius+5)
            DeleteElement(klicks())
          EndIf
        Case 1
          If klicks()\x*klicks()\x+(96-klicks()\y)*(96-klicks()\y)<=(klicks()\radius+5)*(klicks()\radius+5)
            DeleteElement(klicks())
          EndIf
        Case 2
          If (128-klicks()\x)*(128-klicks()\x)+klicks()\y*klicks()\y<=(klicks()\radius+5)*(klicks()\radius+5)
            DeleteElement(klicks())
          EndIf
        Case 3
          If (128-klicks()\x)*(128-klicks()\x)+(96-klicks()\y)*(96-klicks()\y)<=(klicks()\radius+5)*(klicks()\radius+5)
            DeleteElement(klicks())
          EndIf
      EndSelect
    Next
    ExamineKeyboard()
  Until KeyboardPushed(1)
  CloseScreen()
EndIf
End

Procedure MyCircle(x.l,y.l,radius.l,wert.b)
  For lang=0 To radius
    ymax.l=Sqr(radius*radius-lang*lang)
    For hoch=0 To ymax
      If x-lang=>0 And y-hoch=>0
        punkt(x-lang,y-hoch)=wert
      EndIf
      If x+lang=<128 And y-hoch=>0
        punkt(x+lang,y-hoch)=wert
      EndIf
      If x-lang=>0 And y+hoch=<96
        punkt(x-lang,y+hoch)=wert
      EndIf
      If x+lang=<128 And y+hoch=<96
        punkt(x+lang,y+hoch)=wert
      EndIf
    Next
  Next
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -