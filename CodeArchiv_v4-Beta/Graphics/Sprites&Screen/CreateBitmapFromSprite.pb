; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13844&highlight=
; Author: S.M. (extended the example + updated for PB 4.00 by Andre)
; Date: 26. February 2005
; OS: Windows
; Demo: No


; Copy a 2DSprite to an image
; Ein 2DSprite in ein Image kopieren

Procedure CreateBitmapFromSprite(Sprite)
  hDC=StartDrawing(SpriteOutput(Sprite))
  bmp.BITMAP\bmWidth=SpriteWidth(Sprite)
  bmp\bmHeight=SpriteHeight(Sprite)
  bmp\bmPlanes=1
  bmp\bmBitsPixel=GetDeviceCaps_(hDC,#BITSPIXEL)
  bmp\bmBits=DrawingBuffer()
  bmp\bmWidthBytes=DrawingBufferPitch()
  hBmp=CreateBitmapIndirect_(bmp)
  StopDrawing()
  ProcedureReturn hBmp
EndProcedure

;Example:
InitSprite()
InitKeyboard()

; here we will display the image on a screen
OpenScreen(800,600,16,"TEST")

LoadSprite(1,"..\Gfx\PureBasic.bmp",#PB_Sprite_Memory)

ImageID=CreateBitmapFromSprite(1)

StartDrawing(ScreenOutput())
  DrawImage(ImageID,0,0,800,600)
StopDrawing()

FlipBuffers()

Repeat
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)

CloseScreen()


; here we will display the image in a window as imagegadget
If OpenWindow(0, 0, 0, 400, 300, "Show sprite as image....", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  CreateImage(0,400,300)
  StartDrawing(ImageOutput(0))
  DrawImage(ImageID,0,0,400,300)
  StopDrawing()
  ImageGadget(0, 0, 0, 400, 300, ImageID(0))


  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf


DeleteObject_(ImageID) ;Don't forget to free the bitmap

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -