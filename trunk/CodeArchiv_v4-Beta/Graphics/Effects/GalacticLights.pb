; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3439&start=10
; Author: Ypser (code modified by GPI, fixed + updated for PB 4.00 by Andre)
; Date: 15. January 2004
; OS: Windows
; Demo: Yes

;  Lustige Weltraum-Licht-Effekte
;   (c) Frank Hubricht   ("Ypser")   01/04
;___________________________________________________

;Wieviele Lichteffekte (Kometenschweife)
Global In,Out:In=5:Out=15
Lights = 19

;Bildschirmauflösung
ExamineDesktops()
ScreenSizeX.l = DesktopWidth(0)
ScreenSizeY.l = DesktopHeight(0)

InitSprite ()
InitSprite3D ()
InitKeyboard ()
OpenScreen (ScreenSizeX, ScreenSizeY, 32, "")
Sprite3DQuality (1)
InitMouse ()

Enumeration
  #Grabbed
  #Darker
EndEnumeration

Structure LightStream
  X.f
  Y.f
  pX.f
  pY.f
  ppX.f
  ppY.f
  Size.l
  T.l
  I.l
EndStructure

Structure Lights
  X.f
  Y.f
  S.f
  T.l
  I.l
  A.l
EndStructure

Structure Star
  PosX.f
  PosY.f
  Col.l
EndStructure

NewList Stream.LightStream ()
NewList Light.Lights ()
Dim Star.Star(499)

For I = 0 To 499
  Star(I)\PosX = Random (ScreenSizeX)
  Star(I)\PosY = Random (ScreenSizeY)
  If I > 400: Star(I)\Col = Int (Random (50) + 200): EndIf
  If I <= 400: Star(I)\Col = Int (Random (50) + 100): EndIf
  If I < 300: Star(I)\Col = Int (Random (50) + 50): EndIf
Next

For I = 0 To Lights
  AddElement (Stream ())
  Stream()\X    = Random (ScreenSizeX)
  Stream()\Y    = Random (ScreenSizeY)
  Stream()\pX   = Random ( 10) - 5
  Stream()\pY   = Random (  8) - 4
  Stream()\ppX  = Random ( 10) - 5
  Stream()\ppY  = Random (  8) - 4
  Stream()\T    = Random (4.9) + 1
  Stream()\Size = Random ( 20) + 15
  Stream ()\I   = 10
Next


; CreateLights procedure added by Andre, for creating lights on the fly instead of loading images
Procedure CreateLights(SpriteID, color)
  CreateSprite(SpriteID, 100, 100, #PB_Sprite_Texture)
  StartDrawing(SpriteOutput(SpriteID))
  Circle(50, 50, 50, color)
  StopDrawing()
EndProcedure

;{  Sprites laden
CreateSprite (#Darker, ScreenSizeX, ScreenSizeY, #PB_Sprite_Texture)
StartDrawing (SpriteOutput (#Darker))
Box (0, 0, ScreenSizeX, ScreenSizeY, RGB (0, 0, 0))
StopDrawing ()
CreateSprite3D (#Darker, #Darker)

;CatchSprite (11, ?Light1, #PB_Sprite_Texture)
CreateLights(11, RGB(50, 70, 250))
;TransparentSpriteColor (11, 0, 0, 0)
CreateSprite3D (11, 11)

;CatchSprite (12, ?Light2, #PB_Sprite_Texture)
CreateLights(12, RGB(80, 250, 50))
;TransparentSpriteColor (12, 0, 0, 0)
CreateSprite3D (12, 12)

;CatchSprite (13, ?Light3, #PB_Sprite_Texture)
CreateLights(13, RGB(250, 70, 50))
;TransparentSpriteColor (13, 0, 0, 0)
CreateSprite3D (13, 13)

;CatchSprite (14, ?Light4, #PB_Sprite_Texture)
CreateLights(14, RGB(250, 70, 250))
;TransparentSpriteColor (14, 0, 0, 0)
CreateSprite3D (14, 14)

;CatchSprite (15, ?Light5, #PB_Sprite_Texture)
CreateLights(15, RGB(250, 250, 250))
;TransparentSpriteColor (15, 0, 0, 0)
CreateSprite3D (15, 15)   ;}

InX=0:OutX=0
Repeat
  ExamineKeyboard (): ExamineMouse ()
  If MyTimer < ElapsedMilliseconds()
    MyTimer = ElapsedMilliseconds() + 50
    Gosub Render
  EndIf
  If KeyboardPushed(#PB_Key_W)
    If InX=#False
      In+1:If In>24:In=0:EndIf
      InX=#True
    EndIf
  ElseIf KeyboardPushed(#PB_Key_Q)
    If InX=#False
      In-1:If In<0:In=24:EndIf
      InX=#True
    EndIf
  Else
    InX=#False
  EndIf

  If KeyboardPushed(#PB_Key_S)
    If OutX=#False
      Out+1:If Out>24:Out=0:EndIf
      OutX=#True
    EndIf
  ElseIf KeyboardPushed(#PB_Key_A)
    If OutX=#False
      Out-1:If Out<0:Out=24:EndIf
      OutX=#True
    EndIf
  Else
    OutX=#False
  EndIf
Until KeyboardReleased (#PB_Key_Escape); Or MouseDeltaX () Or MouseDeltaY ()

End


Render:
StartDrawing (ScreenOutput ())
DrawingMode (0): BackColor (RGB(0, 0, 0))
Box (0, 0, ScreenSizeX, ScreenSizeY, 0)
For I = 0 To 499
  Star (I)\PosX + ((Star (I)\PosX - (ScreenSizeX / 2)) / 250)
  Star (I)\PosY + ((Star (I)\PosY - (ScreenSizeY / 2)) / 250)
  If (Star (I)\PosX < 1) Or (Star (I)\PosX > ScreenSizeX-1) Or (Star (I)\PosY < 1) Or (Star (I)\PosY > ScreenSizeY-1)
    Star (I)\PosX    = Random (ScreenSizeX-1)
    Star (I)\PosY    = Random (ScreenSizeY-1)
  EndIf
  Plot (Star(I)\PosX, Star(I)\PosY,RGB(Star(I)\Col, Star(I)\Col, Star(I)\Col))
Next
StopDrawing()

Start3D ()
Sprite3DBlendingMode (In, Out)

ForEach Light ()
  Light ()\X + ((Light ()\X - (ScreenSizeX / 2)) / 30)
  Light ()\Y + ((Light ()\Y - (ScreenSizeY / 2)) / 30)
  Light ()\I * 0.92
  Light ()\S * 1.066
  Light ()\A + 1

  If (Light ()\I < 1) Or (Light ()\S > 1000) Or (Light ()\A > 150)
    DeleteElement (Light ())
  Else
    Spr = 10 + Light ()\T
    M = (Light ()\S / 2)
    If (Light ()\I < 5): DeleteElement (Light ()): EndIf
    ZoomSprite3D    (Spr,  Light ()\S,     Light ()\S)
    I = Light ()\I
    If (I > 255): I = 255: EndIf
    DisplaySprite3D (Spr,  Light ()\X - M, Light ()\Y - M, I)
  EndIf
Next




ForEach Stream ()
  If (Stream ()\I < 255)
    Stream ()\I + 5
    If (Stream ()\I > 255): Stream ()\I = 255: EndIf
  EndIf
  If Random (40) < 1: Stream ()\pX  = Random ( 10) - 5: EndIf
  If Random (20) < 1: Stream ()\ppX = Random ( 10) - 5: EndIf
  If Random (40) < 1: Stream ()\pY  = Random (  8) - 4: EndIf
  If Random (20) < 1: Stream ()\ppY = Random (  8) - 4: EndIf
  If Random (50) < 1: Stream ()\T   = Random (4.9) + 1: EndIf

  Stream ()\pX + (Stream ()\ppX / 10)
  Stream ()\pY + (Stream ()\ppY / 10)
  Stream ()\X  + ((Stream ()\pX  / 40) * Stream ()\Size)
  Stream ()\Y  + ((Stream ()\pY  / 40) * Stream ()\Size)

  If Abs(Stream ()\pX > 8): Stream ()\ppX = -Stream ()\ppX: EndIf
  If Abs(Stream ()\pY > 8): Stream ()\ppY = -Stream ()\ppY: EndIf

  If (Stream ()\X < 0) Or (Stream ()\X > ScreenSizeX) Or (Stream ()\Y < 0) Or (Stream ()\Y > ScreenSizeY) Or (Random (300) < 2)
    Stream ()\X    = Random (ScreenSizeX)
    Stream ()\Y    = Random (ScreenSizeY)
    Stream ()\pX   = Random ( 10) - 5
    Stream ()\pY   = Random (  8) - 4
    Stream ()\ppX  = Random ( 10) - 5
    Stream ()\ppY  = Random (  8) - 4
    Stream ()\T    = Random (4.9) + 1
    Stream ()\Size = Random ( 20) + 15
    Stream ()\I    = 0
  EndIf

  M = (Stream ()\Size / 2)
  ZoomSprite3D (10 + Stream ()\T, Stream ()\Size, Stream ()\Size)
  DisplaySprite3D (10 + Stream ()\T, Stream ()\X - M, Stream ()\Y - M)

  AddElement (Light ())
  Light ()\A = 0
  Light ()\X = Stream ()\X
  Light ()\Y = Stream ()\Y
  Light ()\T = Stream ()\T
  Light ()\S = Stream ()\Size
  Light ()\I = Stream ()\I
Next

Stop3D ()
;CreateSprite3D (#Grabbed, #Grabbed)

StartDrawing (ScreenOutput ())
DrawText(1, 1, Str(In)+" "+Str(Out))
StopDrawing()

FlipBuffers ()
Return

DataSection
  ;   Light1: IncludeBinary "blu.bmp"
  ;   Light2: IncludeBinary "grn.bmp"
  ;   Light3: IncludeBinary "red.bmp"
  ;   Light4: IncludeBinary "pnk.bmp"
  ;   Light5: IncludeBinary "wht.bmp"
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger