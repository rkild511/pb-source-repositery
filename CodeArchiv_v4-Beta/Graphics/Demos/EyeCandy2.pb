; English forum:
; Author: chr1sb (updated for PB4.00 by blbltheworm)
; Date: 06. September 2002
; OS: Windows
; Demo: No


ScreenWidth = 640
ScreenHeight = 480
ScreenDepth = 32
PointCount=%11111111
ScreenTitle.s = "Mandaloid"

Declare InitSprites()
Declare FreeSprites()


Define.Point CursorPos
Global Dim PointArray.Point(PointCount)
mb_left.w=0
mb_right.w=0
CursorPos\x=0
CursorPos\y=0
angle.f=0
If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error", "Can't start DirectX", 0)
  End
EndIf
If InitSprite3D() = 0
  MessageRequester("Error", "Can't start DirectX 3D", 0)
  End
EndIf

If OpenScreen(ScreenWidth, ScreenHeight, ScreenDepth, ScreenTitle)

  CreateSprite(0,16,16,#PB_Sprite_Texture)
  StartDrawing(SpriteOutput(0))
  Box(0,0,16,16,RGB(128,128,128))
  Box(1,1,14,14,RGB(255,255,255))
  Box(2,2,12,12,RGB(128,128,128))
  Box(3,3,10,10,RGB(0,0,0))
  StopDrawing()
  CreateSprite3D(0,0)
  Sprite3DQuality(1) 

  Repeat

  FlipBuffers()

    ClearScreen(RGB(0,0,0))
    GetCursorPos_(@CursorPos)
    PointArray(count)\x=CursorPos\x
    PointArray(count)\y=CursorPos\y
    Start3D()
    For f=0 To PointCount 
    currentzoom=((PointCount-f)>>2)+1
    offset=currentzoom>>1
    currentpoint=((f+count) & PointCount)
    x=PointArray(currentpoint)\x
    y=PointArray(currentpoint)\y 
    Trans=f/2
    RotateSprite3D(0, 0, 0) 
    ZoomSprite3D(0, currentzoom, currentzoom) 
    RotateSprite3D(0, Angle, 1) 
    DisplaySprite3D(0,x-offset,y-offset,Trans)
    DisplaySprite3D(0,(ScreenWidth-x)-offset,(ScreenHeight-y)-offset,Trans)
    RotateSprite3D(0, 0, 0) 
    ZoomSprite3D(0, currentzoom, currentzoom) 
    RotateSprite3D(0, -Angle, 1)    
    DisplaySprite3D(0,(ScreenWidth-x)-offset,y-offset,Trans)
    DisplaySprite3D(0,x-offset,(ScreenHeight-y)-offset,Trans)
    Angle=Angle+0.1
    If angle=360
    angle=0
    EndIf
    Next
    Stop3D()
    count=(count+1) & PointCount
  ExamineKeyboard()
  Until KeyboardPushed(#PB_Key_All) 

  Else
  MessageRequester("Error", "Can't open screen", 0)
EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -