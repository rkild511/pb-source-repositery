; English forum: http://www.purebasic.fr/english/viewtopic.php?t=23329
; Author: Joakim Christiansen
; Date: 22. August 2006
; OS: Windows
; Demo: Yes

;Game menu example by Joakim L. Christiansen
;v1.0 - 2006.08.22
;Have fun ;)

;-Constants
#Name      = "The Game"
#Version   = "v1.0 Alpha 1"
#Copyright = "Copyright © 2006 Some Stupid Guy."
#ScreenWidth  = 1024
#ScreenHeight = 768
#ScreenDepth  = 32

;-Enumeration
Enumeration ;Menues
  #mnu_None
  #mnu_Main
  #mnu_SinglePlayer
  #mnu_HostGame
  #mnu_JoinGame
  #mnu_Options
EndEnumeration
Enumeration ;Fonts
  #fnt_Impact_18
  #fnt_Impact_24
  #fnt_Impact_120
EndEnumeration
Enumeration ;Sprites
  #spr_Cursor
  #spr_ScreenShot
EndEnumeration

;-Variables
Global MB_Left, Menu = #mnu_Main

;-Procedures
Procedure DrawTextCentered(X,Y,String$)
  DrawText(X-TextWidth(String$)/2,Y-TextHeight(String$)/2,String$)
EndProcedure

Procedure DrawTextXCentered(X,Y,String$)
  DrawText(X-TextWidth(String$)/2,Y,String$)
EndProcedure

Procedure MB_Left() ;0 = False, 1 = Pressed, 2 = Down, 3 = Released
  If MouseButton(1)
    If MB_Left = 0
      MB_Left = 1
    Else
      MB_Left = 2
    EndIf
  Else
    If MB_Left = 3
      MB_Left = 0
    ElseIf MB_Left = 2
      MB_Left = 3
    EndIf
  EndIf
EndProcedure

Procedure SaveScreen()
  Static Number
  Number + 1
  GrabSprite(#spr_ScreenShot,0,0,#ScreenWidth,#ScreenHeight)
  SaveSprite(#spr_ScreenShot,"screenshot"+Str(Number)+".bmp")
  FreeSprite(#spr_ScreenShot)
EndProcedure

Procedure.l DrawMenuButton(X,Y,Text$)
  Protected Pressed, Width = 300, Height = 48
  X - Width/2

  Box(X,Y,Width,Height,RGB(0,96,64))
  If MouseX() > X And MouseX() < X+Width And MouseY() > Y And MouseY() < Y+Height
    If MB_Left = 3
      Pressed = #True
      MB_Left = 0
    EndIf
    Box(X+3,Y+3,Width-6,Height-6,RGB(0,184,64))
    FrontColor(RGB(200,0,0))
  Else
    Box(X+3,Y+3,Width-6,Height-6,RGB(0,128,64))
    FrontColor(RGB(100,0,0))
  EndIf

  DrawingFont(FontID(#fnt_Impact_24))
  DrawTextCentered(X+Width/2,Y+Height/2,Text$)

  ProcedureReturn Pressed
EndProcedure

Procedure.l MainMenu()
  Protected Selected = -1

  Repeat
    ExamineKeyboard(): ExamineMouse(): MB_Left()
    If KeyboardReleased(#PB_Key_Escape)
      Selected = 4
    ElseIf KeyboardReleased(#PB_Key_F12)
      SaveScreen()
    EndIf

    Delay(2): FlipBuffers(): ClearScreen(#Black)

    StartDrawing(ScreenOutput())
    DrawingMode(#PB_2DDrawing_Transparent)

    FrontColor(RGB(0,0,198))
    DrawingFont(FontID(#fnt_Impact_120))
    DrawTextXCentered(#ScreenWidth/2,68,#Name)

    FrontColor(RGB(198,0,0))
    DrawingFont(FontID(#fnt_Impact_24))
    DrawTextXCentered(#ScreenWidth/2,240,#Version)

    DrawingFont(FontID(#fnt_Impact_18))
    DrawTextXCentered(#ScreenWidth/2,620,#Copyright)
    DrawTextXCentered(#ScreenWidth/2,645,"All rights reserved.")

    If DrawMenuButton(#ScreenWidth/2,300,"Single player")
      Selected = 0
    ElseIf DrawMenuButton(#ScreenWidth/2,362,"Host game")
      Selected = 1
    ElseIf DrawMenuButton(#ScreenWidth/2,424,"Join game")
      Selected = 2
    ElseIf DrawMenuButton(#ScreenWidth/2,486,"Options")
      Selected = 3
    ElseIf DrawMenuButton(#ScreenWidth/2,548,"Exit")
      Selected = 4
    EndIf
    StopDrawing()

    DisplayTransparentSprite(#spr_Cursor,MouseX()-16,MouseY()-16)
  Until Selected > -1

  ProcedureReturn Selected
EndProcedure

Procedure.l Options()
  Protected Selected = -1

  Repeat
    ExamineKeyboard(): ExamineMouse(): MB_Left()
    If KeyboardReleased(#PB_Key_Escape)
      Selected = 0
    ElseIf KeyboardReleased(#PB_Key_F12)
      SaveScreen()
    EndIf

    Delay(2): FlipBuffers(): ClearScreen(#Black)

    StartDrawing(ScreenOutput())
    DrawingMode(#PB_2DDrawing_Transparent)

    FrontColor(RGB(0,0,198))
    DrawingFont(FontID(#fnt_Impact_120))
    DrawTextXCentered(#ScreenWidth/2,68,"Options")

    FrontColor(RGB(198,0,0))
    DrawingFont(FontID(#fnt_Impact_24))
    DrawTextXCentered(#ScreenWidth/2,240,"Game options")

    If DrawMenuButton(#ScreenWidth/2,548,"Back")
      Selected = 0
    EndIf
    StopDrawing()

    DisplayTransparentSprite(#spr_Cursor,MouseX()-16,MouseY()-16)
  Until Selected > -1

  ProcedureReturn Selected
EndProcedure

;-Initialize and open screen
If Not (InitKeyboard() And InitMouse() And InitSprite())
  MessageRequester("Warning!","DirectX 7 or later not found!",#MB_ICONWARNING)
  End
EndIf
If Not OpenScreen(#ScreenWidth,#ScreenHeight,#ScreenDepth,#Name)
  MessageRequester("Warning!","Can't open a "+Str(#ScreenWidth)+"x"+Str(#ScreenHeight)+" "+Str(#ScreenDepth)+"bit screen!",#MB_ICONWARNING)
  End
EndIf

;-Load resources
;LoadFont(#fnt_Arial_08_Bold,"Arial",8,#PB_Font_Bold)
LoadFont(#fnt_Impact_18,"Impact",18)
LoadFont(#fnt_Impact_24,"Impact",24)
LoadFont(#fnt_Impact_120,"Impact",120)
;Create a crappy mouse cursor
CreateSprite(#spr_Cursor,32,32)
StartDrawing(SpriteOutput(#spr_Cursor))
  DrawingMode(#PB_2DDrawing_Outlined)
  Circle(16,16,16,#Red)
  Circle(16,16,1,#Red)
StopDrawing()

MouseLocate(#ScreenWidth/2,415)

;-Main loop start
Repeat
  ;-Menu handling
  Select Menu
    Case #mnu_Main
      Select MainMenu()
        Case 0: Menu = #mnu_None ;Single player
        Case 1: ;Host game
        Case 2: ;Join game
        Case 3: Menu = #mnu_Options
        Case 4: Break
      EndSelect
    Case #mnu_Options
      Select Options()
        Case 0: Menu = #mnu_Main
      EndSelect
  EndSelect
  If Menu <> #mnu_None: Continue: EndIf

  ;-The game...
  Delay(2): FlipBuffers(): ClearScreen(#Black)

  StartDrawing(ScreenOutput())
    DrawingMode(#PB_2DDrawing_Transparent)
    FrontColor(RGB(0,0,198))
    DrawingFont(FontID(#fnt_Impact_18))
    DrawTextXCentered(#ScreenWidth/2,100,"You lose! Press escape to continue! (really fun game)")
  StopDrawing()

  ExamineKeyboard()
  If KeyboardReleased(#PB_Key_Escape)
    Menu = #mnu_Main
  EndIf
ForEver
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP