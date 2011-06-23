; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 10. June 2005
; OS: Windows
; Demo: Yes

InitSprite()
InitKeyboard()
InitMouse()

#ScreenWidth = 800 : #ScreenHeight = 600 : #ScreenName = "TEST"

If OpenScreen(#ScreenWidth,#ScreenHeight,32,#ScreenName) = 0
  If OpenScreen(#ScreenWidth,#ScreenHeight,24,#ScreenName) = 0
    If OpenScreen(#ScreenWidth,#ScreenHeight,16,#ScreenName) = 0
      MessageRequester("ERROR","Cant open "+Str(#ScreenWidth)+"x"+Str(#ScreenHeight)+" Screen",0):End
    EndIf
  EndIf
EndIf
SetFrameRate(60)

; Create Box Sprite
#BoxSprite = 1
Procedure DrawSpriteBox(color)
  StartDrawing(SpriteOutput(#BoxSprite)):Ellipse(50,38,50,37,color):StopDrawing()
EndProcedure

CreateSprite(#BoxSprite,100,75): DrawSpriteBox(RGB($FF,$FF,$00))
BoxX = (#ScreenWidth-SpriteWidth(#BoxSprite))/2
BoxY = (#ScreenHeight-SpriteHeight(#BoxSprite))/2

; Create Mouse Cursor Sprite
#MouseCursor = 2
CreateSprite(#MouseCursor,16,16)
StartDrawing(SpriteOutput(#MouseCursor)):Circle(8,8,8,RGB($77,$FF,$77)):StopDrawing()


Repeat
  FlipBuffers()
  If IsScreenActive() ; Check if Screen is active
    ClearScreen(RGB(BackR,BackG,BackB))

    StartDrawing(ScreenOutput())
      For a = 0 To 1000
        FrontColor(RGB(Random(255),Random(255),Random(255)))
        LineXY(Random(#ScreenWidth),Random(#ScreenHeight),Random(#ScreenWidth),Random(#ScreenHeight))
      Next a
    StopDrawing()

    If ExamineMouse() 
      ; Mouse functions
      MouseX = MouseX(): MouseY = MouseY()
    Else
      MouseX = 100: MouseY = 100
    EndIf

    ExamineKeyboard()
    ; Keyboard function

    ; Collisions
    If SpritePixelCollision(#BoxSprite,BoxX,BoxY,#MouseCursor,MouseX,MouseY)
      If BoxColorBlue = 0:DrawSpriteBox(RGB($00,$00,$FF)):EndIf
      BoxColorBlue = 1
    Else
      If BoxColorBlue = 1:DrawSpriteBox(RGB($FF,$FF,$00)):EndIf
      BoxColorBlue = 0
    EndIf

    ; Display Sprites
    DisplayTransparentSprite(#BoxSprite,BoxX,BoxY)
    DisplayTransparentSprite(#MouseCursor,MouseX,MouseY)

    ; Background Fader
    If BackgroundFader = 0
      BackR + 5: BackG + 5: BackB + 5
      If BackR > 250: BackgroundFader = -1: EndIf
    Else
      BackR - 5: BackG - 5: BackB - 5
      If BackR < 5: BackgroundFader = 0: EndIf
    EndIf

    Delay(1)
  Else
    Delay(200): ; If NOT active, do nothing...
  EndIf
Until KeyboardPushed(#PB_Key_Escape)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -