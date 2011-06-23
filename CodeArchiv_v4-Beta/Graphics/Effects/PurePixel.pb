; http://www.dingzbumz.de/
; Author: MLK (updated for PB 4.00 by Andre)
; Date: 05. January 2005
; OS: Windows
; Demo: Yes

InitSprite()
InitKeyboard()

Global blau.l,gruen.l,rot.l :blau=100:gruen=100:rot=100
Global BGcolor : BGcolor=$000000
Global SpeedFaktor.f : SpeedFaktor=13
ExamineDesktops()
Global ScreenX : ScreenX=DesktopWidth(0)
Global ScreenY : ScreenY=DesktopHeight(0)
Global ScreenXm : ScreenXm=ScreenX-1
Global ScreenYm : ScreenYm=ScreenY-1
Global ScreenXh : ScreenXh=ScreenX/2
Global ScreenYh : ScreenYh=ScreenY/2


Structure pixel
  x.f
  xz.l    ;x-ziel
  xaz.l   ;x-ausweichziel
  y.f
  yz.l
  yaz.l
  az.l    ;aktuelles ziel
EndStructure
Global NewList Pixel.pixel()

Procedure Wert(Zahl)
  If Zahl > 0
    ProcedureReturn Zahl
  Else
    ProcedureReturn -Zahl
  EndIf
EndProcedure

Procedure GetTextDatas(Text.s)
  FontSize=ScreenY/15
  FontID = LoadFont(#PB_Any,"",FontSize,#PB_Font_Bold)
  StartDrawing(ScreenOutput())
  DrawingFont(FontID(FontID))
  TextX=(ScreenX-TextWidth(Text))/2
  TextY=(ScreenY-FontSize)/2
  FrontColor(RGB(200,200,200))
  DrawingMode(1)
  DrawText(TextX, TextY, Text)
  For x=TextX To TextX+TextWidth(Text)
    For y=TextY To TextY+(FontSize*2)
      If Point(x,y)<>BGcolor
        AddElement(Pixel())
        Pixel()\xaz=Random(ScreenXm)
        Pixel()\yaz=Random(ScreenYm)
        Pixel()\xz=x
        Pixel()\yz=y
      EndIf
    Next y
  Next x
  StopDrawing()
  ClearScreen(RGB(0,0,0))
EndProcedure

Procedure MovePixel()
  Static Strahl,TotalMove,Mode,ModeLife

  If TotalMove
    TotalMove-1
  ElseIf Random(250)=0
    TotalMove=40+Random(50)
    Mode=Random(7)
    total=1
  ElseIf Random(80)=0
    MixIt=1
  ElseIf ModeLife
    ModeLife-1
  Else
    ModeLife=5+Random(70)
    Mode=Random(10)
  EndIf

  ;alle pixel sofort zu text formieren
  If Random(400)=0 : TextNow=1 : EndIf
  ;einen teil zu text formieren
  If Random(90)=0 : Format=1 : EndIf
  ;pixelstrahl zu text aussenden
  If Strahl
    Strahl-1
  ElseIf Random(200)=0
    Strahl=Random(150)+30
  EndIf

  FrontColor(RGB(rot,gruen,blau))
  ForEach Pixel()
    If TextNow
      Pixel()\az=2
    ElseIf MixIt
      If Random(3) :
        Pixel()\az=0
      Else
        Pixel()\az=1
      EndIf
    ElseIf total
      Pixel()\az=0
    EndIf

    Select Pixel()\az
      Case 0
        ;einen teil zu text formieren
        If Format And Random(5)=0
          Pixel()\az=2
          Continue
        EndIf
        ;sorgt für riffelige struktur
        If Random(3)=0 : Continue : EndIf
        ;strahl
        If Strahl And Random(30)=0 : Pixel()\az=2 : EndIf
        ;zielkoordinaten des aktuellen modus wählen
        Select Mode
          ;links oben
          Case 0 : xz=0 : yz=0
            ;rechts unten
          Case 1 : xz=ScreenXm : yz=ScreenYm
            ;links unten
          Case 2 : xz=0 : yz=ScreenYm
            ;rechts oben
          Case 3 : xz=ScreenXm : yz=0
            ;mitte links
          Case 4 : xz=0 : yz=ScreenYh
            ;mitte rechts
          Case 5 : xz=ScreenXm : yz= ScreenYh
            ;oben mitte
          Case 6 : xz=ScreenXh : yz= 0
            ;unten mitte
          Case 7 : xz=ScreenXh : yz=ScreenYm
            ;horizontale streifen
          Case 8 : xz=Random(1)*ScreenXm
            ;vertikale steifen
          Case 9 : yz=Random(1)*ScreenYm
            ;kreis
          Case 10 : xz=Random(ScreenXm) : yz=Random(ScreenYm)
        EndSelect
        ;ausweichziel
      Case 1
        If Format Or TotalMove
          Pixel()\az=2
          Continue
        Else
          xz=Pixel()\xaz
          yz=Pixel()\yaz
        EndIf
        ;alternativ
        ; ElseIf Random(4)
        ; xz=Pixel()\xaz
        ; yz=Pixel()\yaz
        ; Else
        ; Pixel()\az=2

        ;textziel
      Default
        xz=Pixel()\xz
        yz=Pixel()\yz
    EndSelect

    ;pixel bewegen X
    xd=Wert(Pixel()\x-xz)
    If xd
      If xz > Pixel()\x
        Pixel()\x+0.9+(xd/SpeedFaktor)
      Else
        Pixel()\x-0.9-(xd/SpeedFaktor)
      EndIf
    EndIf
    ;pixel bewegen Y
    yd=Wert(Pixel()\y-yz)
    If yd
      If yz > Pixel()\y
        Pixel()\y+0.9+(yd/SpeedFaktor)
      Else
        Pixel()\y-0.9-(yd/SpeedFaktor)
      EndIf
    EndIf

    ;ziel erreicht
    If xd+yd=0 : Pixel()\az+1 : EndIf

    ;pixel setzen
    Plot(Pixel()\x,Pixel()\y)
  Next Pixel()
EndProcedure

Procedure Farbverlauf()
  Static bw,gw,rw,flife

  If flife
    flife-1
  Else
    flife=20+Random(30)
    bw=(Random(14)-7)
    gw=(Random(14)-7)
    rw=(Random(14)-7)
  EndIf

  If blau+bw>255 Or blau+bw<90
    bw=-bw
  EndIf
  blau+bw

  If gruen+gw>255 Or gruen+gw<90
    gw=-gw
  EndIf
  gruen+gw

  If rot+rw>255 Or rot+rw<90
    rw=-rw
  EndIf
  rot+rw
EndProcedure


MessageRequester("","Use arrows up/down to change speed")
; If OpenWindow(0,0,0,ScreenX,ScreenY,#PB_Window_ScreenCentered | #PB_Window_BorderLess ,"PurePixel")=0 : End : EndIf
; If OpenWindowedScreen(WindowID(),0,0,ScreenX,ScreenY,0,0,0)=0 : End : EndIf
;SetFrameRate(60)
If OpenScreen(ScreenX,ScreenY,32,"PurePixel")=0:End:EndIf

GetTextDatas("PureBasic")
dLay=1
Repeat
  ExamineKeyboard()
  If x
    x-1
  Else
    x=5
    Farbverlauf()
  EndIf
  ClearScreen(RGB(0,0,0))
  StartDrawing(ScreenOutput())
  MovePixel()
  StopDrawing()
  FlipBuffers()

  If KeyboardPushed(#PB_Key_Down)
    dLay+1
  ElseIf KeyboardPushed(#PB_Key_Up)
    If dLay>0
      dLay-1
    EndIf
  EndIf
  Delay(dLay)
  ;Until WindowEvent()=#PB_Event_CloseWindow Or KeyboardPushed(#PB_Key_Escape)
Until KeyboardPushed(#PB_Key_Escape)
;CloseScreen()
; CloseWindow(0)
;MessageRequester("",Str(CountList(Pixel()))+" Pixel!")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -