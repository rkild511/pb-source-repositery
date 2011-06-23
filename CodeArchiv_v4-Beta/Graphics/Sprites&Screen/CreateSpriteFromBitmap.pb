; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13844&highlight=
; Author: S.M. (extended the example + updated for PB 4.00 by Andre)
; Date: 28. February 2005
; OS: Windows
; Demo: No


; Procedure which makes a sprite out of a image
; Prozedur zur Erstellung eines Sprites aus einem Image

Procedure CreateSpriteFromBitmap(Sprite,ImageID)
  GetObject_(ImageID,SizeOf(BITMAP),bmp.BITMAP)
  CreateSprite(Sprite,bmp\bmWidth,bmp\bmHeight)
  MemDC=CreateCompatibleDC_(0)
  OldBitmap=SelectObject_(MemDC,ImageID)
  hDC=StartDrawing(SpriteOutput(Sprite))
  BitBlt_(hDC,0,0,bmp\bmWidth,bmp\bmHeight,MemDC,0,0,#SRCCOPY)
  SelectObject_(MemDC,OldBitmap)
  DeleteDC_(MemDC)
  StopDrawing()
EndProcedure


;Example:
InitSprite()
InitKeyboard()

ExamineDesktops()
width  = DesktopWidth(0)
height = DesktopHeight(0)

OpenScreen(width,height,16,"CreateSpriteFromBitmap()")

ImageID=LoadImage(1,"..\Gfx\PureBasic.bmp")

CreateSpriteFromBitmap(1,ImageID)

Repeat
  DisplaySprite(1,Random(width),Random(height))
  FlipBuffers()
  ClearScreen(0)
  ExamineKeyboard()
  Delay(100)
Until KeyboardPushed(#PB_Key_Escape)

CloseScreen()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger