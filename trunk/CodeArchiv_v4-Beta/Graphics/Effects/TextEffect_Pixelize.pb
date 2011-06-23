; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3447&start=20
; Author: Dingzbumz (updated for PB 4.00 by Andre)
; Date: 13. February 2004
; OS: Windows
; Demo: Yes

InitSprite()
InitKeyboard()

Global mode.l
Global farbe.l
Global blau.l,gruen.l,rot.l :blau=100:gruen=100:rot=100
Global flife.l

Declare wert(zahl)

#font=0
#xscreen=800
#yscreen=600

Structure ziele
  a.l
  b.l
EndStructure
Structure pixel
  x.f
  xz.ziele
  y.f
  yz.ziele
  az.l
EndStructure
Global NewList pixel.pixel()

Procedure GetTextDatas(text.s)
  fontsize=30
  StartDrawing(ScreenOutput())
  LoadFont(#font,"arial",fontsize,#PB_Font_Bold)
  DrawingFont(FontID(#font))
  TextX=(#xscreen-TextWidth(text))/2
  TextY=(#yscreen-fontsize)/2
  FrontColor(RGB(200,200,200))
  DrawingMode(1)
  DrawText(TextX,TextY,text)
  For x=TextX To TextX+TextWidth(text)
    For y=TextY To 599
      If Point(x,y)<>$000000
        AddElement(pixel())
        pixel()\xz\a=Random(799)    ;ausweichziel..
        pixel()\yz\a=Random(599)    ;<<
        pixel()\xz\b=x  ;endziel..
        pixel()\yz\b=y  ;<<
        pixel()\az=Random(2)    ;Aktuelles Ziel (erklärung von az=0 weiter unten)
      EndIf
    Next y
  Next x
  StopDrawing()
EndProcedure

Procedure MovePixel()
  If Random(65)=0 ;siehe weiter unten
    stay=3
  Else
    stay=2
  EndIf

  ForEach pixel()
    If pixel()\az=1 ;ausweichziel
      xz=pixel()\xz\a
      yz=pixel()\yz\a
    ElseIf pixel()\az=2 ;endziel
      xz=pixel()\xz\b
      yz=pixel()\yz\b
    Else
      If mode=1 ;schwinger links oben :-)
        xz=0
        yz=0
      ElseIf mode=2   ;rechts unten
        xz=799
        yz=599
      ElseIf mode=3   ;links unten
        xz=0
        yz=599
      ElseIf mode=4   ;rechts oben
        xz=799
        yz=0
      ElseIf mode=5 Or mode=6
        ;horizontale streifen
        If Random(1)=0
          xz=0
        Else
          xz=799
        EndIf
      ElseIf mode=7 Or mode=8
        ;vertikale steifen
        If Random(1)=0
          yz=0
        Else
          yz=599
        EndIf
      EndIf
    EndIf


    xd=wert(pixel()\x-xz)
    If xd > 0
      If xz > pixel()\x
        pixel()\x+0.9+xd/15     ;0.9 damit er nicht so langsam wird -> die geschwindigkeit ist = abstand zwischen position und aktuellem ziel / 15 (+0.9) [+1 führt zu fehler]
      ElseIf xz < pixel()\x
        pixel()\x-0.9-xd/15
      EndIf
    Else
      If pixel()\az<stay  ;bestimmt wie lange der pixel auf seiner endzielposition bleibt
        pixel()\az+1
      EndIf
    EndIf

    yd=wert(pixel()\y-yz)
    If yd > 0
      If yz > pixel()\y
        pixel()\y+0.9+yd/15
      ElseIf yz < pixel()\y
        pixel()\y-0.9-yd/15
      EndIf
    Else
      If pixel()\az<stay
        pixel()\az+1
      EndIf
    EndIf
    Plot(pixel()\x,pixel()\y,RGB(rot,gruen,blau))
  Next pixel()
EndProcedure

Procedure wert(zahl)
  If zahl>0
    ProcedureReturn zahl
  Else
    ProcedureReturn -zahl
  EndIf
EndProcedure

Procedure farbverlauf()
  flife-1
  If flife<0
    bw=(Random(18)-9)/10
    gw=(Random(18)-9)/10
    rw=(Random(18)-9)/10
    flife=Random(90)+20
  EndIf

  If blau+bw<255 And blau+bw>30
    blau+bw
  Else
    bw*-1
  EndIf
  If gruen+gw<255 And gruen+gw>90
    gruen+gw
  Else
    gw*-1
  EndIf
  If rot+rw<255 And rot+rw>90
    rot+rw
  Else
    rw*-1
  EndIf
EndProcedure

If OpenWindow(0,200,100,#xscreen,#yscreen,"",#PB_Window_SystemMenu)=0 : End : EndIf
If OpenWindowedScreen(WindowID(0),0,0,#xscreen,#yscreen,0,0,0)=0 : End : EndIf

;If OpenScreen(#xscreen,#yscreen,16,"")=0:End:EndIf

GetTextDatas("PUREBASIC")

Repeat
  ;ExamineKeyboard()
  x+1
  If x>70 And Random(70)=0
    x=0
    ForEach pixel()
      pixel()\az=0    ;dies ist, was die pixel formatiert/zu paketen bündelt
    Next
  EndIf

  life-1
  If life<0
    If Random(9)=0
      life=Random(150)+5
      mode=Random(3)+5    ;linien (vertikal/horizontal)
    Else
      If Random(15)=0
        life=Random(60)+30
        mode=Random(3)+1    ;schwinger in 4 mögliche ecken
      Else
        life=Random(100)+30
        mode=0          ;normales verhalten (echte ziele suchen, formatieren)
      EndIf
    EndIf
  EndIf
  ClearScreen(RGB(0,0,0))
  farbverlauf()
  StartDrawing(ScreenOutput()) : MovePixel() : StopDrawing()
  FlipBuffers()
Until WindowEvent()=#PB_Event_CloseWindow
;Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger