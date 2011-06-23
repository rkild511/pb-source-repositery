; http://www.purebasic-lounge.de
; Author: Hellhound66
; Date: 11. October 2005
; OS: Windows
; Demo: Yes

#ResX                   = 1024
#ResY                   = 768
#BPP                    = 32
#MaxSprites             = 10
#Gravitation            = 0.4
#Sprungkraft            = -10.0
#PlayerSpeed            = 4.0
#PlayerBeschleunigung   = 0.7


#BodenSprite        = 0
#PlayerSprite       = 1
#SeitenSprite       = 2

Structure _Entity
  x.f
  y.f
  Sprite.l
  Vx.f
  Vy.f
EndStructure

Global Player._Entity
Global Kontakt.l
Global NewList Level._Entity()
Global Dim Sprites.l(#MaxSprites)


Procedure Init()
  InitSprite()
  InitKeyboard()
  OpenScreen(#ResX,#ResY,#BPP,"Bla")
  ClearScreen(RGB(0,0,0))
  FlipBuffers(1)
  ClearScreen(RGB(0,0,0))
EndProcedure


Procedure InitSprites()
  Sprites(#BodenSprite) = CreateSprite(#PB_Any,100,20)
  StartDrawing(SpriteOutput(Sprites(#BodenSprite)))
  DrawingMode(1)
  Box(0,0,100,20,$FF00FF)
  Circle(50,-10,20,$000000)
  StopDrawing()
  Sprites(#SeitenSprite) = CreateSprite(#PB_Any,20,100)
  StartDrawing(SpriteOutput(Sprites(#SeitenSprite)))
  DrawingMode(1)
  Box(0,0,20,100,$FF00FF)
  Circle(20,-10,15,$000000)
  StopDrawing()
  Sprites(#PlayerSprite) = CreateSprite(#PB_Any,40,40)
  StartDrawing(SpriteOutput(Sprites(#PlayerSprite)))
  Circle(20,20,20,$0000FF)
  StopDrawing()
  For i=0 To 20
    AddElement(Level())
    Level()\x =i*40+Random(10)
    Level()\y = 490+Random(20)
    Level()\Sprite = #BodenSprite
  Next
  For i=0 To 10
    AddElement(Level())
    Level()\x =Random(800)
    Level()\y =Random(600)
    Level()\Sprite = #BodenSprite
  Next
  For i=0 To 20
    AddElement(Level())
    Level()\y =i*40+Random(10)
    Level()\x = Random(20)
    Level()\Sprite = #SeitenSprite
    AddElement(Level())
    Level()\y =i*40+Random(10)
    Level()\x = 800+Random(20)
    Level()\Sprite = #SeitenSprite
  Next
  Player\x = 100
  Player\y = 50
  Player\Sprite = #PlayerSprite
EndProcedure


Procedure DrawWorld()
  ClearScreen(RGB(0,0,0))
  ForEach Level()
    DisplayTransparentSprite(Sprites(Level()\Sprite),Level()\x,Level()\y)
  Next
  DisplayTransparentSprite(Sprites(Player\Sprite),Player\x,Player\y)
  FlipBuffers(1)
  Delay(1)
EndProcedure

Procedure CheckInput()
  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Escape)
    End
  EndIf
  If KeyboardPushed(#PB_Key_Up)
    If Player\Vy=0 And Kontakt
      Player\Vy = #Sprungkraft
      Kontakt = 0
    EndIf
  EndIf
  If Player\Vy=0
    If KeyboardPushed(#PB_Key_Left)
      If Player\Vx>-#PlayerSpeed
        Player\Vx-#PlayerBeschleunigung
      EndIf
    Else
      If Player\Vx<0
        Player\Vx+#PlayerBeschleunigung
        If Player\Vx>0
          Player\Vx = 0
        EndIf
      EndIf
    EndIf
    If  KeyboardPushed(#PB_Key_Right)
      If Player\Vx<#PlayerSpeed
        Player\Vx+#PlayerBeschleunigung
      EndIf
    Else
      If Player\Vx>0
        Player\Vx-#PlayerBeschleunigung
        If Player\Vx<0
          Player\Vx = 0
        EndIf
      EndIf
    EndIf
  EndIf   
EndProcedure

Procedure CheckCollision()
  Player\Vy + #Gravitation
  Player\y + Player\Vy
  ForEach Level()
    If SpriteCollision(Sprites(Player\Sprite),Player\x,Player\y,Sprites(Level()\Sprite),Level()\x,Level()\y)
      If SpritePixelCollision(Sprites(Player\Sprite),Player\x,Player\y,Sprites(Level()\Sprite),Level()\x,Level()\y)
        If Player\Vy>0
          Kontakt = #True
        EndIf
        Player\y -Player\Vy
        Player\Vy = 0
      EndIf
    EndIf
  Next
  Steigungstest = 0
  Player\x + Player\Vx
  ForEach Level()
    If SpriteCollision(Sprites(Player\Sprite),Player\x,Player\y,Sprites(Level()\Sprite),Level()\x,Level()\y)
      If SpritePixelCollision(Sprites(Player\Sprite),Player\x,Player\y,Sprites(Level()\Sprite),Level()\x,Level()\y)
        Steigungstest +1
        If Steigungstest=5
          Player\x -Player\Vx
          Player\Vx = -Player\Vx/2
          Player\y+4
          Break
        Else
          Player\y-1
          ResetList(Level())
        EndIf
      EndIf
    EndIf
  Next
 
EndProcedure


;*********************** MAIN *******************************
Init()
InitSprites()

Repeat
  DrawWorld()
  CheckInput()
  CheckCollision()
Until 0=1

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -