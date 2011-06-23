; German forum:
; Author: Nickolas Göddel (updated for PB4.00 by blbltheworm)
; Date: 12. December 2002
; OS: Windows
; Demo: Yes


 Procedure AbsLNG(a.l)
  If a >> 31
    a * -1
  EndIf
  ProcedureReturn a
EndProcedure
Procedure Mod(a.l, b.l)
  Erg.l = a - a / b * b
  If a >> 31 : Erg + AbsLNG(b) : EndIf
  ProcedureReturn Erg
EndProcedure

If InitSprite() = #False Or InitKeyboard() = #False Or InitMouse() = #False
  MessageRequester("Fehler", "DirectX 7.0 oder höher nicht installiert.", 16)
  End
EndIf

;-- Konstanten
#Font = 3

Global XRes.l, YRes.l
XRes = 1024                      ;Auflösung: XRes x YRes (Normal im Verhältnis 4:3)
YRes = 768
BackColor = RGB(0, 0, 100)         ;Hintergrundfarbe

If LoadFont(#Font, "System", FontSizeY) = #False
  MessageRequester("Fehler", "Schriftart konnte nicht geladen werden.", 16)
  End
EndIf

;OpenWindow(0, 0, 0, XRes, YRes, #PB_Window_Systemmenu, "Dots-Returns")
;If OpenWindowedScreen(WindowID(),0, 0, XRes, YRes, 0, 0, 0) = #False
If OpenScreen(XRes, YRes, 32, "Dots-Returns") = #False
  If OpenScreen(XRes, YRes, 24, "Dots-Returns") = #False
    MessageRequester("Fehler", "Screen konnte nicht initialisiert werden.", 16)
    End
  EndIf
EndIf

;-- Font

Text.s = "Crazy Dots - (c) Nicolas Göddel 12-12-2002"
FontSizeY.l = 15                ;Anzahl an Dots auf der Y-Achse
FPosition.l = 0                 ;Anfangsposition im Schriftzug (Normal: 0)
FTimePerPixel.l = 5             ;Frames, die vergehen bis die Schriftposition um eins weitergeht
FTimeCount.l = FTimePerPixel    ;Zählvariable (Normal: FTimePerPixel)

StartDrawing(ScreenOutput())
  DrawingFont(FontID(#Font))
  FontSizeX.l = TextWidth(Text)
StopDrawing()

Global Dim TextGitter.l(FontSizeX - 1, FontSizeY - 1)

CreateImage(#Font, FontSizeX, FontSizeY)
StartDrawing(ImageOutput(#Font))
  Box(0, 0, FontSizeX, FontSizeY, RGB(255, 255, 255))
  FrontColor(RGB(0,0,0))
  DrawText(0, -2,Text)
  For x.l = 0 To FontSizeX - 1
    For y.l = 0 To FontSizeY - 1
      TextGitter(x, y) = 255 - Red(Point(x, y))
    Next
  Next
StopDrawing()
FreeImage(#Font)

;-- Dots
XMaxDots.l = 30                 ;Dots auf der X-Achse (Normal: 30)
YMaxDots.l = FontSizeY          ;Dots auf der Y-Achse (Normal: FontSizeY)
DotsRadius.l = 10               ;Radius der Dots (Normal: 10)
DotsReturn.f = 0.90             ;Geschwindikeit, mit der die Dots zurück an ihren Platz gehen (Normal: 0.90)
MinAbstand.f = DotsRadius * 16  ;Abstand zur Lichtkegelmitte, ab der sich die Dots bewegen
DotsJump.f = 10                 ;Geschwindigkeit der Dots bei Berührung mit dem Lichtkegelmitte

Structure Dots
  x.f
  y.f
  xrel.f
  yrel.f
  xstep.f
  ystep.f
  Winkel.l
  f.f
  Aktiv.l
  Color.l
EndStructure

Global Dim Dots.Dots(XMaxDots - 1, YMaxDots - 1)

For x.l = 0 To XMaxDots - 1
  For y.l = 0 To YMaxDots - 1
    Dots(x, y)\x = (XRes * x) / XMaxDots + (DotsRadius * 2)
    Dots(x, y)\y = (YRes * y) / YMaxDots + (DotsRadius * 2)
    Dots(x, y)\xrel = 0
    Dots(x, y)\yrel = 0
    Dots(x, y)\xstep = 0
    Dots(x, y)\ystep = 0
    Dots(x, y)\Color = Random(512)
  Next
Next

CreateSprite(1, DotsRadius * 2, DotsRadius * 2, 0)
StartDrawing(SpriteOutput(1))
Circle(DotsRadius, DotsRadius, DotsRadius, RGB(255, 255, 0))
StopDrawing()

;-- Lichtkegel
MX = XRes / 2                   ;Anfangsposition des Lichtkegels auf der X-Achse
MY = YRes / 2                   ;Anfangsposition des Lichtkegels auf der Y-Achse
MWinkel = Random(360)           ;Anfangswinkel, in desse Richtung sich der Lichtkegel bewegt
MaxSpeed.f = 20                 ;Maximale Geschwindikeit des Lichtkegels (Normal: 20)
MSpeed.f = 0                    ;Momentane Geschwindigkeit des Lichtkegels (Normal: 0)
MBSpeed.f = 0.05                ;Zunahme pro Frame der Geschwindigkeit des Lichtkegels (Normal: 0.05)
MAbstand = MinAbstand           ;(Normal: MinAbstand)
MOn.l = 0                       ;Status der Bewegung des Lichtkegels (Normal: 0 = An)
MStopFrames = 5                 ;Anzahl an Frames, die vergehen müssen, bevor MOn wieder 0 bzw. an ist

CreateSprite(0, MinAbstand * 2, MinAbstand * 2, 0)
StartDrawing(SpriteOutput(0))
For r.l = MinAbstand To 0 Step -1
  Pro.f = 1 - (r / MinAbstand)
  Circle(MinAbstand, MinAbstand, r, RGB(Red(BackColor), Pro * 255, Blue(BackColor)))
Next
StopDrawing()

;-- Lichter
Structure Lichter
  x.f
  y.f
  xstep.f
  ystep.f
  Frame.l
EndStructure
Global NewList Lichter.Lichter()

MaxLichter.l = 2000             ;Anzahl der sich im Hintergrund befindlichen Lichter
LMaxSpeed.f = 3                 ;Maximale Geschwindigkeit der Lichter
LROTSpeed.f = 0.1               ;Maximale Richtungsänderungsgeschwindigkeit der Lichter
LRand.l = 10                    ;(Normal: 10)

For a.l = 1 To MaxLichter
  AddElement(Lichter())
  Lichter()\x = Random(XRes)
  Lichter()\y = Random(YRes)
  Lichter()\xstep = (Random(2000) - 1000) / 1000
  Lichter()\ystep = (Random(2000) - 1000) / 1000
  Lichter()\Frame = Random(360)
Next

;-- Hauptschleife
Repeat
  If IsScreenActive() = #False
    ReleaseMouse(1)
    While IsScreenActive() = #False : Delay(100) : Wend
  EndIf
 
  ClearScreen(RGB(Red(BackColor),Green(BackColor),Blue(BackColor)))
 
  ;--   Mausabfrage
  ExamineMouse()
  MDX.l = MouseDeltaX()
  MDY.l = MouseDeltaY()
  If MDX Or MDY
    MX + MDX
    MY + MDY
    MOn = MStopFrames
  EndIf
  If MX + MinAbstand < 0 : MX = -MinAbstand : EndIf
  If MX - MinAbstand > XRes : MX = XRes + MinAbstand : EndIf
  If MY + MinAbstand < 0 : MY = -MinAbstand : EndIf
  If MY - MinAbstand > YRes : MY = YRes + MinAbstand : EndIf
 
  If Tmp
    FreeSprite(1)
    CreateSprite(1, DotsRadius * 2, DotsRadius * 2, 0)
    StartDrawing(SpriteOutput(1))
    Circle(DotsRadius, DotsRadius, DotsRadius, RGB(255, 255, 0))
    StopDrawing()
    Tmp = #False
  EndIf
 
  ;Berechnung des Winkels des Lichtkegels, falls er aus dem Bild laufen will
  If MOn = 0
    If MSpeed < MaxSpeed : MSpeed + MBSpeed : EndIf
    MX + Cos(MWinkel * 3.14159256 / 180) * MSpeed
    MY + Sin(MWinkel * 3.14159256 / 180) * MSpeed
    Zufall.l = 10 + Random(5)
    If MX < MAbstand
      If MWinkel < 180
        MWinkel - Zufall
      Else
        MWinkel + Zufall
      EndIf
    ElseIf MY < MAbstand
      If MWinkel < 270 And MWinkel > 90
        MWinkel - Zufall
      Else
        MWinkel + Zufall
      EndIf
    ElseIf MX > XRes - MAbstand
      If MWinkel < 180
        MWinkel + Zufall
      Else
        MWinkel - Zufall
      EndIf
    ElseIf MY > YRes - MAbstand
      If MWinkel < 270 And MWinkel > 90
        MWinkel + Zufall
      Else
        MWinkel - Zufall
      EndIf
    Else
      MWinkel + Random(20) - 10
    EndIf
  Else
    MOn - 1
    MSpeed = 0
  EndIf 
 
  MWinkel = Mod(MWinkel, 360)

  MW.l = MouseWheel()
  MinAbstand + MW * 5
  If MinAbstand < 1 : MinAbstand = 1 : MW = 0 : EndIf
  If MW <> 0
    FreeSprite(0)
    CreateSprite(0, MinAbstand * 2, MinAbstand * 2, 0)
    StartDrawing(SpriteOutput(0))
    For r.l = MinAbstand To 0 Step -1
      Pro.f = 1 - (r / MinAbstand)
      Circle(MinAbstand, MinAbstand, r, RGB(Red(BackColor), Pro * 255, Blue(BackColor)))
    Next
    StopDrawing()
  EndIf
 
  DisplayTransparentSprite(0, MX - MinAbstand, MY - MinAbstand)
 
  ;--   Lichter

  StartDrawing(ScreenOutput())
    ResetList(Lichter())
    While NextElement(Lichter())
      Lichter()\x + Lichter()\xstep * LMaxSpeed
      Lichter()\y + Lichter()\ystep * LMaxSpeed
      If Lichter()\x < LRand
        Lichter()\xstep + LROTSpeed
      EndIf
      If Lichter()\y < LRand
        Lichter()\ystep + LROTSpeed
      EndIf
      If Lichter()\x > XRes - LRand - 1
        Lichter()\xstep - LROTSpeed
      EndIf
      If Lichter()\y > YRes - LRand - 1
        Lichter()\ystep - LROTSpeed
      EndIf
      Lichter()\xstep + (Random(200) - 100) / 1000
      Lichter()\ystep + (Random(200) - 100) / 1000
      If Lichter()\xstep > 1 : Lichter()\xstep = 1 : EndIf
      If Lichter()\ystep > 1 : Lichter()\ystep = 1 : EndIf
      If Lichter()\xstep < -1 : Lichter()\xstep = -1 : EndIf
      If Lichter()\ystep < -1 : Lichter()\ystep = -1 : EndIf
      If Lichter()\x > 0 And Lichter()\x < XRes - 1 And Lichter()\y > 0 And Lichter()\y < YRes - 1
        Plot(Lichter()\x, Lichter()\y, $FFFFFF)
      EndIf
    Wend
 
  ;--   Dots_kompliziert
 
  For x.l = 0 To XMaxDots - 1
    For y.l = 0 To YMaxDots - 1
      PosX.f = Dots(x, y)\x + Dots(x, y)\xrel
      PosY.f = Dots(x, y)\y + Dots(x, y)\yrel
      Abs.f = Sqr(Pow(Abs(MX - PosX), 2) + Pow(Abs(MY - PosY), 2))
      ;Wenn Punkt innerhalb des Kreises liegt
      If Abs < MinAbstand
        Dots(x, y)\F = 1 - (Abs / MinAbstand)
       
        If Dots(x, y)\F < 0.1
          Dots(x, y)\xstep * -1
          Dots(x, y)\ystep * -1
          Dots(x, y)\Winkel = Random(360)
        EndIf
       
        If Dots(x, y)\Aktiv = #False
          Dots(x, y)\Winkel = Random(360)
        Else
          Dots(x, y)\Winkel + Random(10) - 5
        EndIf
       
        Dots(x, y)\xstep = (Cos(Dots(x, y)\Winkel * 3.14159256 / 180) * Dots(x, y)\F * DotsJump)
        Dots(x, y)\ystep = (Sin(Dots(x, y)\Winkel * 3.14159256 / 180) * Dots(x, y)\F * DotsJump)

        Dots(x, y)\Aktiv = #True
      ;Wenn Punkt außerhalb des Kreises liegt
      ElseIf Abs > MinAbstand
        Dots(x, y)\Winkel = 0
        Dots(x, y)\Aktiv = #False
        Dots(x, y)\F = 0
      EndIf

      Dots(x, y)\xrel + Dots(x, y)\xstep
      Dots(x, y)\yrel + Dots(x, y)\ystep
      If Dots(x, y)\Aktiv = #False
        Dots(x, y)\xstep * DotsReturn
        Dots(x, y)\ystep * DotsReturn
        Dots(x, y)\xrel * DotsReturn
        Dots(x, y)\yrel * DotsReturn
      EndIf
     
      ;--   Grafikausgabe
      Tmp.l = Dots(x, y)\Color
      If Tmp > 255 : Tmp = 511 - Tmp : EndIf
      Dots(x, y)\Color + Random(10)
      Dots(x, y)\Color = Mod(Dots(x, y)\Color, 512)
     
      If FPosition + x < FontSizeX And FPosition + x > 0
        PixelC.l = TextGitter(x + FPosition, y)
      Else
        PixelC.l = 0
      EndIf
     
      Color.l = RGB(255 * Dots(x, y)\F, PixelC, 255 - Tmp)
     
      If PixelC
        DrawingMode(0)
      Else
        DrawingMode(4)
      EndIf
     
      Circle(Dots(x, y)\x + Dots(x, y)\xrel, Dots(x, y)\y + Dots(x, y)\yrel, DotsRadius, Color)
    Next
  Next
 
  ;Überprüfung, ob der Schriftzug weiterrücken soll
  If FTimeCount = 0
    FPosition = Mod(FPosition + 1, FontSizeX)
    If FPosition = 0 : FPosition = - XMaxDots : EndIf
    FTimeCount = FTimePerPixel
  EndIf

  FTimeCount - 1

  StopDrawing()
  FlipBuffers()
 
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -