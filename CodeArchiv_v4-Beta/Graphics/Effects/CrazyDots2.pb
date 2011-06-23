; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=117&highlight=
; Author: NicTheQuick (based on code by Nicolas Göddel, updated for PB4.00 by blbltheworm)
; Date: 16. January 2004
; OS: Windows
; Demo: No


;{- Initialisierung 

If InitSprite() = #False Or InitKeyboard() = #False Or InitMouse() = #False 
  MessageRequester("Fehler", "DirectX 7.0 oder höher nicht installiert.", 16) 
  End 
EndIf 

#Font = 1 

Global XRes.l, YRes.l 
XRes = 1152                      ;Auflösung: XRes x YRes (Normal im Verhältnis 4:3) 
YRes = XRes * 3 / 4 
BackColor = RGB(0, 0, 50)         ;Hintergrundfarbe 

;OpenWindow(0, 0, 0, XRes, YRes, #PB_Window_SystemMenu, "Dots-Returns") 
;If OpenWindowedScreen(WindowID(),0, 0, XRes, YRes, 0, 0, 0) = #False 
If OpenScreen(XRes, YRes, 32, "Dots-Returns") = #False 
  If OpenScreen(XRes, YRes, 24, "Dots-Returns") = #False 
    If OpenScreen(XRes, YRes, 16, "Dots-Returns") = #False 
      MessageRequester("Fehler", "Screen konnte nicht initialisiert werden.", 16) 
      End 
    EndIf 
  EndIf 
EndIf 
SetFrameRate(50) 
;} 

;{- Schriftzug initialisieren 

If ReadFile(0, "???.txt") 
  Text.s = "" 
  While Eof(0) = #False 
    Zeile.s = Trim(ReadString(0)) 
    Text = Text + "  " + Zeile 
  Wend 
Else 
  Text.s = " * * * Feel the Pure Power! * * * " 
EndIf 

FontSizeY.l = 15                ;Anzahl an Dots auf der Y-Achse 
FPosition.l = 0                 ;Anfangsposition im Schriftzug (Normal: 0) 
FTimePerPixel.l = 2             ;Frames, die vergehen bis die Schriftposition um eins weitergeht 
FTimeCount.l = FTimePerPixel    ;Zählvariable (Normal: FTimePerPixel) 

If LoadFont(#Font, "System", FontSizeY) = #False 
  MessageRequester("Fehler", "Schriftart konnte nicht geladen werden.", 16) 
  End 
EndIf 

StartDrawing(ScreenOutput()) 
  DrawingFont(FontID(#Font)) 
  FontSizeX.l = TextWidth(Text) 
StopDrawing() 

Global Dim TextGitter.l(FontSizeX - 1, FontSizeY - 1) 

CreateImage(#Font, FontSizeX, FontSizeY) 
StartDrawing(ImageOutput(#Font)) 
  Box(0, 0, FontSizeX, FontSizeY, RGB(255, 255, 255)) 
  FrontColor(RGB(0,0,0)) 
  DrawText(0, 0,Text) 
  For x.l = 0 To FontSizeX - 1 
    For y.l = 0 To FontSizeY - 1 
      TextGitter(x, y) = 1 ! (Point(x, y) & 1) 
    Next 
  Next 
StopDrawing() 
;SaveImage(#Font, "f:\Schriftzug.bmp") 
FreeImage(#Font) 
;} 

;{- Dots 
XMaxDots.l = 30                 ;Dots auf der X-Achse (Normal: 30) 
YMaxDots.l = FontSizeY          ;Dots auf der Y-Achse (Normal: FontSizeY) 
DotsRadius.l = 15               ;Radius der Dots (Normal: 10) 
DotsReturn.f = 0.90             ;Geschwindikeit, mit der die Dots zurück an ihren Platz gehen (Normal: 0.90) 
MinAbstand.f = 150              ;Abstand zur Lichtkegelmitte, ab der sich die Dots bewegen 
DotsJump.f = 10                 ;Geschwindigkeit der Dots bei Berührung mit der Lichtkegelmitte 
#DSpriteID = 2 
DCircle.l = #False 

Structure Dots 
  x.f 
  y.f 
  xrel.f 
  yrel.f 
  xstep.f 
  ystep.f 
  Winkel.l 
  F.f 
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
;} 

;{- Lichtkegel 

DCircle = #True 

MX = XRes / 2                   ;Anfangsposition des Lichtkegels auf der X-Achse 
MY = YRes / 2                   ;Anfangsposition des Lichtkegels auf der Y-Achse 
MWinkel = Random(360)           ;Anfangswinkel, in dessen Richtung sich der Lichtkegel bewegt 
MaxSpeed.f = 10                 ;Maximale Geschwindikeit des Lichtkegels (Normal: 10) 
MSpeed.f = 0                    ;Momentane Geschwindigkeit des Lichtkegels (Normal: 0) 
MBSpeed.f = 0.05                ;Zunahme pro Frame der Geschwindigkeit des Lichtkegels (Normal: 0.05) 
MAbstand = MinAbstand           ;(Normal: MinAbstand) 
MOn.l = 0                       ;Status der Bewegung des Lichtkegels (Normal: 0 = An) 
MStopFrames = 5                 ;Anzahl an Frames, die vergehen müssen, bevor MOn wieder 0 bzw. an ist 

CreateSprite(0, MinAbstand * 2, MinAbstand * 2, 0) 
StartDrawing(SpriteOutput(0)) 
For r.l = MinAbstand To 0 Step -1 
  Pro.f = 1 - (r / MinAbstand) 
  Circle(MinAbstand, MinAbstand, r, RGB(Pro * 255, Green(BackColor), Blue(BackColor)))  ;Rot 
  ;Circle(MinAbstand, MinAbstand, r, RGB(Red(BackColor), Pro * 255, Blue(BackColor)))    ;Grün 
  ;Circle(MinAbstand, MinAbstand, r, RGB(Red(BackColor), Green(BackColor), Pro * 255))   ;Blau 
  
  ;Änderung muss auch in Zeile 262 erfolgen ("Keyboardabfrage und Scrollrad") 
Next 
StopDrawing() 
;} 

;{- Lichter 
Structure Lichter 
  x.f 
  y.f 
  xstep.f 
  ystep.f 
  frame.l 
EndStructure 
Global NewList Lichter.Lichter() 

MaxLichter.l = 2500             ;Anzahl der sich im Hintergrund befindlichen Lichter 
LMaxSpeed.f = 3                 ;Maximale Geschwindigkeit der Lichter 
LROTSpeed.f = 0.1               ;Maximale Richtungsänderungsgeschwindigkeit der Lichter 
LRand.l = 10                    ;(Normal: 10) 
LMaxFrames.l = 360 

For a.l = 1 To MaxLichter 
  AddElement(Lichter()) 
  Lichter()\x = Random(XRes) 
  Lichter()\y = Random(YRes) 
  Lichter()\xstep = (Random(2000) - 1000) / 1000 
  Lichter()\ystep = (Random(2000) - 1000) / 1000 
  Lichter()\frame = Random(LMaxFrames * 2) 
Next 
;} 

;{- FPS 
FPS_EndTime.l = GetTickCount_() + 1000 
FPS_Loops.l = 0 
FPS_Value.l = 0 
#Font_FPS = 2 
If LoadFont(#Font_FPS, "Arial", 16) = #False 
  MessageRequester("Fehler", "Schriftart konnte nicht geladen werden.", 16) 
  End 
Else 
EndIf 
;} 

;-- Hauptschleife 
Repeat 
  ;{ Prüfe, ob der Screen noch aktiv ist 
  If IsScreenActive() = #False 
    ReleaseMouse(1) 
    While IsScreenActive() = #False 
      WaitWindowEvent() 
    Wend 
  EndIf 
  ;} 
  
  ClearScreen(RGB(Red(BackColor),Green(BackColor),Blue(BackColor))) 
  
  ;{ Mausabfrage 
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
  ;} 
  
  ;{ Berechnung des Winkels des Lichtkegels, falls er aus dem Bild laufen will 
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
  
  MWinkel = MWinkel % 360 
  ;} 

  ;{ Keyboardabfrage und Scrollrad 
  ExamineKeyboard() 
  MW.l = MouseWheel() 

  If KeyboardPushed(#PB_Key_Add) : MW = 1 : EndIf 
  If KeyboardPushed(#PB_Key_Subtract) : MW = -1 : EndIf 
  
  MinAbstand + MW * 5 
  If MinAbstand < 1 : MinAbstand = 1 : MW = 0 : EndIf 
  If MW <> 0 
    FreeSprite(0) 
    CreateSprite(0, MinAbstand * 2, MinAbstand * 2, 0) 
    StartDrawing(SpriteOutput(0)) 
    For r.l = MinAbstand To 0 Step -1 
      Pro.f = 1 - (r / MinAbstand) 
      Circle(MinAbstand, MinAbstand, r, RGB(Pro * 255, Green(BackColor), Blue(BackColor)))  ;Rot 
      ;Circle(MinAbstand, MinAbstand, r, RGB(Red(BackColor), Pro * 255, Blue(BackColor)))    ;Grün 
      ;Circle(MinAbstand, MinAbstand, r, RGB(Red(BackColor), Green(BackColor), Pro * 255))   ;Blau 
    Next 
    StopDrawing() 
  EndIf 
  ;} 
  
  ; Lichtkegel anzeigen 
  DisplayTransparentSprite(0, MX - MinAbstand, MY - MinAbstand) 
  
  StartDrawing(ScreenOutput()) 
  
  ;{ Lichter 

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
    
    Tmp = Lichter()\frame 
    If Tmp > LMaxFrames : Tmp = 720 - Tmp : EndIf 
    
    Lichter()\frame + Random(5) 
    Lichter()\frame = Lichter()\frame % (LMaxFrames * 2) 

    Color.l = (Tmp * 255) / LMaxFrames 
    
    If Lichter()\x > 0 And Lichter()\x < XRes - 1 And Lichter()\y > 0 And Lichter()\y < YRes - 1 
      Plot(Lichter()\x, Lichter()\y, Color | Color << 8 | Color << 16) 
    EndIf 
  Wend 
  ;} 
  
  ;{ Dots sind kompliziert 
  
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
      
      ;{ Grafikausgabe 
      Tmp.l = Dots(x, y)\Color 
      If Tmp > 255 : Tmp = 511 - Tmp : EndIf 
      Dots(x, y)\Color + Random(10) 
      Dots(x, y)\Color = Dots(x, y)\Color % 512 
      
      PixelC.l = 0 
      If FPosition + x < FontSizeX And FPosition + x > 0 
        If TextGitter(x + FPosition, y) 
          PixelC = 255 
        EndIf 
      EndIf 
      
      Red.l = 255 * Dots(x, y)\F 
      Green.l = PixelC 
      Blue.l = 255 - Tmp 
      
      If PixelC 
        DrawingMode(0) 
      Else 
        DrawingMode(4) 
      EndIf 
      Circle(Dots(x, y)\x + Dots(x, y)\xrel, Dots(x, y)\y + Dots(x, y)\yrel, DotsRadius, RGB(Red, Green, Blue)) 
      ;} 
    Next 
  Next 
  ;} 
  
  ;{ Überprüfung, ob der Schriftzug weiterrücken soll 
  If FTimeCount = 0 
    FPosition = (FPosition + 1) % (FontSizeX + XMaxDots) 
    If FPosition = FontSizeX : FPosition = - XMaxDots: EndIf 
    FTimeCount = FTimePerPixel 
  EndIf 

  FTimeCount - 1 
  ;} 

  ;{ FPS errechnen und anzeigen 
  FPS_Loops + 1 
  If GetTickCount_() > FPS_EndTime 
    FPS_Value = FPS_Loops 
    FPS_Loops = 0 
    FPS_EndTime = GetTickCount_() + 1000 
  EndIf 
  DrawingMode(1) 
  FrontColor(RGB(255,255,255)) 
  DrawText(5, 5,"FPS: " + Str(FPS_Value)) 
  ;} 
  
  StopDrawing() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
