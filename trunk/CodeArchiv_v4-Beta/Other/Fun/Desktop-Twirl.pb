; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2083&highlight=
; Author: ChaOsKid (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 24. August 2003
; OS: Windows
; Demo: No

; Note: need 32Bit Desktop screenmode....

; ChaOsKid's Desktop Twirl v0.1a b030824 
; PureBasic v3.72 
; 
; Tasten: 
; Escape        beendet das programm 
; s             wechselt den Quellspeicher 
; Space         schaltet das licht aus 
; Up            winkel (+1) 
; Down          winkel (-1) 
; Left          size (+1) 
; Right         size (-1) 
; 
; Maus: 
; Button1       zeichnet eine box um den bereich 
; Button2       zeigt Winkel & FPS & Pixel 
; Wheel         ändert den winkel (+-5) 
; Button1+Wheel size (+-5) 
; 
Procedure.f gSin(Winkel.f) 
  result.f = Sin(Winkel*0.01745329) 
  ProcedureReturn result 
EndProcedure 

Procedure.f gCos(Winkel.f) 
  result.f = Cos(Winkel*0.01745329) 
  ProcedureReturn result 
EndProcedure 

Global sek.l, fps.l, fps$ 
Procedure FPS() 
  time = GetTickCount_() 
  fps + 1 
  If sek < time 
    sek = time + 1000 
    fps$ = Str(fps) + " FPS" 
    fps = 0 
  EndIf 
EndProcedure 

If InitSprite() = 0 Or InitMouse() = 0 Or InitKeyboard() = 0 
  End 
EndIf 

Maus.POINT 
; Mausposition einlesen 
GetCursorPos_(Maus) 

; Screenshot vom desktop 
Breite.l = GetSystemMetrics_(#SM_CXSCREEN) 
Hoehe.l = GetSystemMetrics_(#SM_CYSCREEN) 
hdc.l = GetDC_(0) 
Tiefe.b = GetDeviceCaps_(hdc, #BITSPIXEL) 
BmpID.l = CreateImage(0, Breite, Hoehe) 
MemDC.l = CreateCompatibleDC_(hdc) 
SelectObject_(MemDC, BmpID) 
BitBlt_(MemDC, 0, 0, Breite, Hoehe, hdc, 0, 0, #SRCCOPY) 
DeleteDC_(MemDC) 
ReleaseDC_(0, hdc) 

; Vollbildfenster starten 
If OpenScreen(Breite, Hoehe, Tiefe, "ChaOsKid's Desktop Twirl") = 0 
  MessageRequester("fehler !", "Fehler", #PB_MessageRequester_Ok) 
  Goto Ende 
EndIf 

; Mausposition setzen 
MouseLocate(Maus\x, Maus\y) 

; GetDIBits vorbereiten 
bmi.BITMAPINFO 
bmi\bmiHeader\biPlanes = 1 
bmi\bmiHeader\biBitCount = 32 
bmi\bmiHeader\biCompression = #BI_RGB 
bmi\bmiHeader\biWidth  = Breite 
bmi\bmiHeader\biHeight = Hoehe 
bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 

; Screenshot mit GetDIBits in Speicher kopieren 
hdc.l = StartDrawing(ImageOutput(0)) 
  AllPixels.l = Breite * Hoehe * 4 
  Mem.l = AllocateMemory(AllPixels) 
  If GetDIBits_(hdc, BmpID, 0, Hoehe, Mem, bmi, #DIB_RGB_COLORS) = 0 
    StopDrawing() 
    Debug "GetDIBits fehler !" 
    Goto Ende 
  EndIf 
StopDrawing() 
  
; Hintergrundsprite zeichnen 
CreateSprite(0, Breite, Hoehe, 0) 
StartDrawing(SpriteOutput(0)) 
  QuellBuffer.l = DrawingBuffer() 
  DrawImage(BmpID,0,0) 
StopDrawing() 
FreeImage(0) 
  
; Variablen festlegen 
Size.l = 250 
Winkel.f = 360 
tempWinkel.f 
Licht.b = #True 
MausPosSetzen.l = #False 
HalfSize.f = Size / 2 
Line.l = Breite * 4 
zLine.l 
Speicher.l = Mem ; QuellBuffer 
Buffer.l 
MausX.l 
MausY.l 
mx.f 
my.f 
Radius.f 
Ratio.f 
cosx.f 
siny.f 
VerschubX.l 
VerschubY.l 
    
Repeat 
  FPS() 
  
  ExamineKeyboard() 
  ;If KeyboardPushed(#PB_Key_All) 
    If KeyboardPushed(#PB_Key_Up) 
      Winkel + 1 
    EndIf 
    If KeyboardPushed(#PB_Key_Down) 
      Winkel - 1 
    EndIf 
    If KeyboardPushed(#PB_Key_Right) 
      Size + 1 
      Gosub Check 
    EndIf 
    If KeyboardPushed(#PB_Key_Left) 
      Size - 1 
      Gosub Check 
    EndIf 
    If KeyboardPushed(#PB_Key_Escape) 
      Quit = #True 
    EndIf 
  ;EndIf 
  If KeyboardReleased(#PB_Key_S) 
    If Speicher = Mem 
      Speicher = QuellBuffer 
    Else 
      Speicher = Mem 
    EndIf 
  EndIf 
  If KeyboardReleased(#PB_Key_Space) 
    If Licht ; = #True 
      Licht = #False 
    Else 
      Licht = #True 
    EndIf 
  EndIf 
  
  ExamineMouse() 
  MausX.l = MouseX() 
  If MausX > Breite - Size 
    MausX = Breite - Size 
    MausPosSetzen = #True 
  EndIf 
  MausY = MouseY() 
  If MausY > Hoehe - Size 
    MausY = Hoehe - Size 
    MausPosSetzen = #True 
  EndIf 
  If MausPosSetzen 
    MouseLocate(MausX, MausY) 
    MausPosSetzen = #False 
  EndIf 
  Wheel.l = MouseWheel() 
  If Wheel 
    If MouseButton(1) 
      Size + Wheel * 5 
      Gosub Check 
    Else 
      Winkel + Wheel * 5 
    EndIf 
  EndIf 
  
  ClearScreen(RGB(0,0,0))
  
  If Licht 
    DisplaySprite(0, 0, 0) ; Hintergrundbild 
  EndIf 
  StartDrawing(ScreenOutput()) 
    Buffer = DrawingBuffer() 
    zLine = DrawingBufferPitch() 
    For y = 0 To Size - 1 
      *ZielPixel.Long = Buffer + (MausX * 4) + (MausY + y) * zLine 
      For x = 0 To Size - 1 
        mx = (x - HalfSize) 
        my = (y - HalfSize) 
        Radius = Sqr( mx * mx + my * my ) 
        If Radius <= HalfSize 
          Ratio = 1 - Radius / HalfSize 
          tempWinkel = Winkel * ( Ratio * Tan(Ratio) ) 
          cosx = gCos(tempWinkel) 
          siny = gSin(tempWinkel) 
          VerschubX = ( MausX + x + Int( ( cosx * mx ) - ( siny * my ) - mx ) ) * 4 
          If Speicher = Mem ; Arbeitsspeicher 
            VerschubY = ( Hoehe - 1 - MausY - y - Int( ( siny * mx ) + ( cosx * my ) - my ) ) * Line 
          Else              ; Sprite 
            VerschubY = ( MausY + y + Int( ( siny * mx ) + ( cosx * my ) - my ) ) * Line 
          EndIf 
          ;If Speicher + VerschubX + VerschubY >= Speicher And Speicher + VerschubX + VerschubY <= Speicher + AllPixels  
            *QuellPixel.Long = Speicher + VerschubX + VerschubY 
            *ZielPixel\l = *QuellPixel\l 
          ;Else 
          ;  *ZielPixel\l = 0 
          ;EndIf 
        EndIf 
        *ZielPixel + 4 
      Next x 
    Next y 
  
    DrawingMode(4) 
    If MouseButton(1) 
      Box(MausX, MausY, Size+1, Size+1) 
    EndIf 
    If MouseButton(2) 
      DrawText(MausX + 10, MausY + Size - 22, Str(Winkel) + " Grad " + fps$ + " bei " + Str(Size*Size) + " Pixeln") 
    EndIf 
  StopDrawing() 
  FlipBuffers() 
  
  Delay(1) 
Until Quit 
Ende: 
FreeMemory(Mem) 
End 
  
Check: 
  If Size < 200 
    Size = 200 
  EndIf 
  If Size > Hoehe - 200 
    Size = Hoehe - 200 
  EndIf 
  HalfSize = Size/2 
Return

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger