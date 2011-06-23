; English forum: http://www.purebasic.fr/english/viewtopic.php?t=10895&highlight=
; Author: fweil (updated for PB 4.00 by Andre)
; Date: 19. May 2004
; OS: Windows
; Demo: No

;
; 3D rose
;
; The following code is an update from original Cederavic code posted on french forum formerly
;
; I don't give much more comments except best possible naming so that readers should understand quite easy what is there.
;
; Note that CreateSpriteObject has been changed since a previous post I made and makes now more things.
;
; FWeil 20050515
;
; 20050519
;
; - added a Letter type sprite object
; - added a mouse escape to release the mouse capture when trying to go outside the windowed screen from top left and a mouse capture back when pointing the windowed screen
; - added a small "X" sprite when the pointer is near to the top right of the windowed screen to let the user qui the program.
; - updated some code for better writing
; - updated the left / right mouse buttons management to interact on worm's parameter only when the pointer is the red cross
; - Enhanced the #BubbleMax constant because feedback about performances seem to be good enough
; - Added an advertising wink to PureBasic for fun.
;
#BubbleMax = 400
#Window_Main = 0
#FullScreen = #True

Enumeration #BubbleMax + 1
  #Pointer1
  #Pointer2
  #Pointer3
  #Pointer4
  #SplashPanel
  #Advertising
EndEnumeration
#BackgroundColor = #Black

Structure TEXTPANEL
  FontName.s
  FontSize.l
  Text.s
  TextColor.l
EndStructure

Structure LetterSprite
  ForegroundColor.l
  BackgroundColor.l
  Text.s
  FontName.s
  FontSize.l
  FontAttributes.l
EndStructure

Procedure CreateSpriteObject(SpriteNumber.l, Width.l, Height.l, ObjectName.s, Param1.l, Param2.l)
  ;
  ; CreateSpriteObject allows to create parameterized sprites
  ;
  If CreateSprite(SpriteNumber, Width, Height, #PB_Sprite_Texture)
    Select ObjectName
      Case "Cross"
        StartDrawing(SpriteOutput(SpriteNumber))
        DrawingMode(0)
        Box(0, 0, Width, Height, Param2)
        LineXY(0, Height / 2, Width, Height / 2, Param1)
        LineXY(Width / 2, 0, Width / 2, Height, Param1)
      Case "Arrow"
        StartDrawing(SpriteOutput(SpriteNumber))
        DrawingMode(0)
        Box(0, 0, Width, Height, Param2)
        LineXY(0, 0, 4, 13, Param1)
        LineXY(4, 13, 5, 8, Param1)
        LineXY(5, 8, 29, 32, Param1)
        LineXY(29, 32, 32, 29, Param1)
        LineXY(32, 29, 9, 6, Param1)
        LineXY(9, 6, 13, 5, Param1)
        LineXY(13, 5, 0, 0, Param1)
        FillArea(2, 2, Param1, Param1)
      Case "Letter"
        *SpriteLetter.LetterSprite = Param1
        LoadFont(23, *SpriteLetter\FontName, *SpriteLetter\FontSize, *SpriteLetter\FontAttributes)
        StartDrawing(SpriteOutput(SpriteNumber))
        DrawingMode(0)
        Box(0, 0, Width, Height, *SpriteLetter\BackgroundColor)
        DrawingFont(FontID(23))
        DrawingMode(1)
        FrontColor(*SpriteLetter\ForegroundColor)
        DrawText((Width - TextWidth(*SpriteLetter\Text)) / 2, (Width - TextWidth(*SpriteLetter\Text)) / 2, *SpriteLetter\Text)
      Case "TextPanel"
        *TextPanel.TEXTPANEL = Param1
        LoadFont(0, *TextPanel\FontName, *TextPanel\FontSize, #PB_Font_HighQuality)
        StartDrawing(SpriteOutput(SpriteNumber))
        DrawingFont(FontID(0))
        DrawingMode(0)
        For x = 0 To Width
          Fading.f = x / Width - 0.5
          If Fading < 0
            Fading = 0
          EndIf
          If Fading > 0.5
            Fading * 2
          EndIf
          LineXY(x, 0, 0, x, RGB(Red(Param2) * Fading, Green(Param2) * Fading, Blue(Param2) * Fading))
          LineXY(Width - x, Height, Width, Width - x, RGB(Red(Param2) * Fading, Green(Param2) * Fading, Blue(Param2) * Fading))
        Next
        DrawingMode(1)
        If FindString(*TextPanel\Text, " ", 1)
          FieldNumber = 1
          While StringField(*TextPanel\Text, FieldNumber, " ") <> ""
            FieldNumber + 1
          Wend
          FieldNumber - 1
          For h = 1 To FieldNumber
            For i = 1 To 4
              FrontColor(*TextPanel\TextColor >> (4 - i))
              DrawText((Width - TextWidth(StringField(*TextPanel\Text, h, " "))) / 2 + i, (Height + 3 * (h - 1) * *TextPanel\FontSize) / 2 - i, StringField(*TextPanel\Text, h, " "))
            Next
          Next
        Else
          For i = 1 To 4
            FrontColor(RGB(64 * i - 1, 64 * i - 1, 50 * i - 1))
            DrawText((Width - TextWidth(*TextPanel\Text)) / 2 + i, Height / 2 - i, *TextPanel\Text)
          Next
        EndIf
      Default
        LoadFont(0, "Verdana", 12, #PB_Font_Bold | #PB_Font_HighQuality)
        StartDrawing(SpriteOutput(SpriteNumber))
        DrawingMode(0)
        Box(0, 0, Width, Height, Param1)
        DrawingMode(1)
        Box(0, 0, Width, Height, Param2)
        DrawingMode(1)
        Label.s = "?"
        DrawingFont(FontID(0))
        FrontColor(RGB(255, 0, 0))
        DrawText((Width - TextWidth(Label)) / 2, (Height - 3 * FontSize / 2) / 2, Label)
    EndSelect
    StopDrawing()
  EndIf
EndProcedure

;
;
;
If InitSprite() And InitSprite3D() And InitKeyboard() And InitMouse()
  If #FullScreen
    WindowXSize = GetSystemMetrics_(#SM_CXSCREEN)
    WindowYSize = GetSystemMetrics_(#SM_CYSCREEN)
    ScreenXSize = WindowXSize
    ScreenYSize = WindowYSize
    OpenScreen(WindowXSize, WindowYSize, 32, "Rosace3D")
    Initialized = #True
  Else
    WindowXSize = 480
    WindowYSize = 360
    ScreenXSize = WindowXSize
    ScreenYSize = WindowYSize
    If OpenWindow(#Window_Main, 0, 0, WindowXSize, WindowYSize, "Rosace3D", #PB_Window_BorderLess | #PB_Window_ScreenCentered)
      AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Escape, #PB_Shortcut_Escape)
      If OpenWindowedScreen(WindowID(#Window_Main), 0, 0, ScreenXSize, ScreenYSize, #True, 0, 0)
        Initialized = #True
      EndIf
    EndIf
  EndIf
  If Initialized
    BackgroundImageID = CreateImage(0, ScreenXSize, ScreenYSize)
    StartDrawing(ImageOutput(0))
    For i = 0 To 31
      Box(i, i, ScreenXSize - 2 * i, ScreenYSize - 2 * i, RGB(0, 0, 255 - 8 * i))
    Next
    Box(32, 32, ScreenXSize - 64, ScreenYSize - 64, #Black)
    StopDrawing()
    Sprite3DQuality(1)
    CX = 3 * ScreenXSize / 7
    CY = ScreenYSize / 2
    CXZ = (1 + #FullScreen ) * ScreenXSize / 3
    CYZ = (1 + #FullScreen ) * ScreenYSize / 3
    s.l = 1
    s2.l = 1
    sk.l = 1
    j.f = 0.0
    j2.f = 50.0
    k.l = 0
    SpriteLightX.f = 0.5
    SpriteLightY.f = 0.5
    For t = 0 To #BubbleMax
      CreateSprite(t, 32, 32, #PB_Sprite_Texture)
      StartDrawing(SpriteOutput(t))
      ColorMask.l = Random(7) + 1
      Red = 32 * Random(4) * ((ColorMask & 4) >> 2)
      Green = 32 * Random(4) * ((ColorMask & 2) >> 1)
      Blue = 32 * Random(4) * ((ColorMask & 1))
      SpriteCX.f = 16.0
      SpriteCY.f = 16.0
      SpriteRadius = 10
      Circle(SpriteCX, SpriteCY, SpriteRadius, RGB(0, 0, 0))
      For SpriteRadius = 9 To 2 Step - 1
        Circle(SpriteCX, SpriteCY, SpriteRadius, RGB(Red, Green, Blue))
        SpriteCX + SpriteLightX
        SpriteCY + SpriteLightY
        Red + 16
        If Red > 255
          Red = 255
        EndIf
        Green + 32
        If Green > 255
          Green = 255
        EndIf
        Blue + 32
        If Blue > 255
          Blue = 255
        EndIf
      Next
      StopDrawing()
      CreateSprite3D(t, t)
    Next
    PointerXSize = 8
    PointerYSize = 8
    CreateSpriteObject(#Pointer1, PointerXSize, PointerYSize, "Cross", #White, #BackgroundColor)
    CreateSpriteObject(#Pointer2, PointerXSize, PointerYSize, "Cross", $8080FF, #BackgroundColor)
    SplashPanel.TEXTPANEL
    SplashPanel\FontName = "Verdana"
    SplashPanel\FontSize = 8 * (#FullScreen + 1)
    SPlashPanel\Text = "Visit www.francoisweil.com or email fweil@internext.fr"
    SPlashPanel\TextColor = $C0FFFF
    CreateSpriteObject(#Pointer3, 256, 256, "TextPanel", @SplashPanel, #Blue)
    SplashPanel\FontName = "Verdana"
    SplashPanel\FontSize = 8 * (#FullScreen + 1)
    SPlashPanel\Text = "Designed by fweil"
    SPlashPanel\TextColor = $C0FFFF
    CreateSpriteObject(#SplashPanel, 128 * (#FullScreen + 1), 128 * (#FullScreen + 1), "TextPanel", @SplashPanel, #White)
    Sprite4.LetterSprite
    Sprite4\ForegroundColor = #Red
    Sprite4\BackgroundColor = #Blue
    Sprite4\Text = "X"
    Sprite4\FontName = "Verdana"
    Sprite4\FontSize = 12
    Sprite4\FontAttributes = #PB_Font_Bold | #PB_Font_HighQuality
    CreateSpriteObject(#Pointer4, 2 * PointerXSize, 2 * PointerYSize, "Letter", @Sprite4, 0)
    Sprite4\ForegroundColor = $4020B0
    Sprite4\BackgroundColor = $300000
    Sprite4\FontAttributes = #PB_Font_HighQuality
    Sprite4\FontSize = 16
    AdvertisingString.s = "PureBasic will puzzle you !"
    lAdvertisingString.l = Len(AdvertisingString)
    For i = 1 To lAdvertisingString
      Sprite4\Text = Mid(AdvertisingString, i, 1)
      CreateSpriteObject(#Advertising + i, 2 * PointerXSize, 4 * PointerYSize, "Letter", @Sprite4, 0)
    Next
    CreateSprite3D(#SplashPanel, #SplashPanel)
    SplashPanelXSize = 0
    SplashPanelYSize = Random(256)
    sSplashPanelX = 1
    sSplashPanelY = 1
    Start3D()
    Repeat
      ExamineKeyboard()
      If KeyboardPushed(#PB_Key_Escape)
        Quit = #True
      EndIf
      If KeyboardPushed(#PB_Key_F1)
        Delay(50)
        RefreshRateFlag = 1 - RefreshRateFlag
        Refresh = 0
      EndIf
      FlipBuffers()
      ClearScreen(RGB(0, 0, 0))
      If #FullScreen = #False
        If WindowEvent() = #PB_Event_CloseWindow Or EventMenu() = #PB_Shortcut_Escape
          Quit = #True
        EndIf
        StartDrawing(ScreenOutput())
        DrawImage(BackgroundImageID, 0, 0)
        StopDrawing()
      EndIf
      For t = 0 To #BubbleMax
        j + s * 0.00025
        j2 + s2 * 0.00025
        If j <= 5
          s = 1
        EndIf
        If j => 35
          s = -1
        EndIf
        If j2 <= 5
          s2 = 1
        EndIf
        If j2 => 35
          s2 = -1
        EndIf
        Angle1.f = t / j / 2
        Alpha = Sin(Angle1) * 32
        If Alpha < 40
          Alpha = 128 - 3 * Alpha
        Else
          Alpha = 128 - Alpha / 3
        EndIf
        If Alpha > 255
          Alpha = 255
        ElseIf Alpha < 0
          Alpha = 0
        EndIf
        ZoomSprite3D(t, 32, 32)
        Angle1.f = 2 * Angle1
        Angle2.f = 2 * t / j2 + j2 / 2
        DisplaySprite3D(t, CX + CXZ * (Sin(Angle1) + Cos(Angle2)) * k / (ScreenXSize + Alpha), CY + CYZ * (Cos(Angle1) + Sin(Angle2)) * k / (ScreenYSize + Alpha), Alpha)
      Next
      If RefreshRateFlag
        Refresh + 1
        If ElapsedMilliseconds() - tz => 1000
          tz = ElapsedMilliseconds()
          RefreshRate = Refresh
          Refresh = 0
        EndIf
        StartDrawing(ScreenOutput())
        DrawingMode(1)
        For i = 1 To 4
          FrontColor(RGB(64 * i - 1, 64 * i - 1, 50 * i - 1))
          DrawText(10 + i, 10 - i, "Refresh rate : " + Str(RefreshRate))
        Next
        StopDrawing()
      EndIf
      If StartCounter < 1200
        StartCounter + 1
        If StartCounter < 950
          ThisFading = 255
        Else
          ThisFading = 1200 - StartCounter
        EndIf
        SplashPanelXSize + sSplashPanelX
        SplashPanelYSize + sSplashPanelY
        If SplashPanelXSize <= -128
          sSplashPanelX = 1
        EndIf
        If SplashPanelXSize > 128
          sSplashPanelX = -1
        EndIf
        If SplashPanelYSize <= -128
          sSplashPanelY = 1
        EndIf
        If SplashPanelYSize > 128
          sSplashPanelY = -1
        EndIf
        ZoomSprite3D(#SplashPanel, SplashPanelXSize, SplashPanelYSize)
        RotateSprite3D(#SplashPanel, SplashPanelAngle, 0)
        DisplaySprite3D(#SplashPanel, ScreenXSize - 100, ScreenYSize - 100, ThisFading)
        SplashPanelAngle + 1
        If StartCounter < 1000
          StartDrawing(ScreenOutput())
          DrawingMode(1)
          If StartCounter < 500
            ThisColor = 255 * StartCounter / 500
          Else
            ThisColor = 255 * (1000 - StartCounter) / 500
          EndIf
          FrontColor(ThisColor)
          Text.s = "Use left / right mouse buttons at screen center to change parameters"
          DrawText((ScreenXSize - TextWidth(Text)) / 2, ScreenYSize - 40, Text)
          Text.s = "Escape to exit - F1 to see frame refresh rate"
          DrawText((ScreenXSize - TextWidth(Text)) / 2, ScreenYSize - 20, Text)
          StopDrawing()
        EndIf
      EndIf
      If MouseReleased
        GetCursorPos_(@Point.POINT)
        If WindowFromPoint_(Point\x, Point\y) = WindowID(#Window_Main)
          ReleaseMouse(0)
          MouseLocate(ScreenXSize / 2, ScreenYSize / 2)
          MouseReleased = #False
          AdvertisingFlag = #False
        EndIf
      EndIf
      ExamineMouse()
      If MouseButton(1)
        If CursorType = 2
          j = Random(100) - 50
          j2 = Random(100) - 50
        ElseIf CursorType = 4
          Quit = #True
        EndIf
      ElseIf MouseButton(2) And k > 0 And CursorType = 2
        k = -k
      Else
        MouseX = MouseX()
        MouseY = MouseY()
        If MouseX > ScreenXSize / 4 And MouseX < 3 * ScreenXSize / 4 And MouseY > ScreenYSize / 4 And MouseY < 3 * ScreenYSize / 4
          DisplayTransparentSprite(#Pointer2, MouseX() - PointerXSize / 2, MouseY() - PointerYSize / 2)
          CursorType = 2
        ElseIf MouseX > ScreenXSize - 40 And MouseY < 30
          DisplayTransparentSprite(#Pointer4, MouseX() - PointerXSize / 2, MouseY() - PointerYSize / 2)
          MouseLocate(ScreenXSize - 2 * PointerXSize, PointerYSize)
          CursorType = 4
        ElseIf MouseY > 3 * ScreenYSize / 4
          DisplayTransparentSprite(#Pointer3, MouseX() - 256 / 2, MouseY() - 256 / 2)
          CursorType = 3
        ElseIf (MouseX <= 0 Or MouseX => ScreenXSize) And (MouseY <= 0 Or MouseY => ScreenYSize) And MouseReleased = #False And #FullScreen = #False
          ReleaseMouse(1)
          MouseReleased = #True
          AdvertisingFlag = #True
        Else
          DisplayTransparentSprite(#Pointer1, MouseX() - PointerXSize / 2, MouseY() - PointerYSize / 2)
          CursorType = 1
        EndIf
      EndIf
      k + sk
      If k <= 50
        sk = 1
      EndIf
      If k => 250
        sk = -1
      EndIf
      If AdvertisingFlag
        x = 0.8 * ScreenXSize / lAdvertisingString
        For i = 1 To lAdvertisingString
          Bend = lAdvertisingString - 2 * Abs(i - lAdvertisingString / 2)
          DisplayTransparentSprite(#Advertising + i, i * x + 30 + Random(2) - 1, 40 + y + Random(2) - 1 + Bend)
        Next
      EndIf
    Until Quit
    Stop3D()
    If #FullScreen
      CloseScreen()
    Else
      CloseWindow(#Window_Main)
    EndIf
  EndIf
EndIf
TerminateProcess_(GetCurrentProcess_(), 0)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger