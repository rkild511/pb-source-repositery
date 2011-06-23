; German forum: http://www.purebasic.fr/german/viewtopic.php?t=166&highlight=
; Author: Lebostein (procedure, example added by Andre)
; Date: 16. September 2004
; OS: Windows
; Demo: Yes


; ZoomSprite(#sprite, zoomfaktor) - Funktion
Procedure ZoomSprite(sprite1, zoom)

  widx = SpriteWidth(sprite1)
  widy = SpriteHeight(sprite1)

  sprite2 = CopySprite(sprite1, #PB_Any)
  CreateSprite(sprite1, widx * zoom, widy * zoom)

  StartDrawing(ScreenOutput())
  Select DrawingBufferPixelFormat()
    Case #PB_PixelFormat_8Bits      : bperpix = 1
    Case #PB_PixelFormat_15Bits     : bperpix = 2
    Case #PB_PixelFormat_16Bits     : bperpix = 2
    Case #PB_PixelFormat_24Bits_RGB : bperpix = 3
    Case #PB_PixelFormat_24Bits_BGR : bperpix = 3
    Case #PB_PixelFormat_32Bits_RGB : bperpix = 4
    Case #PB_PixelFormat_32Bits_BGR : bperpix = 4
  EndSelect
  StopDrawing()

  StartDrawing(SpriteOutput(sprite1))
  adress1 = DrawingBuffer()
  breite1 = DrawingBufferPitch()
  StopDrawing()

  StartDrawing(SpriteOutput(sprite2))
  adress2 = DrawingBuffer()
  breite2 = DrawingBufferPitch()
  StopDrawing()

  For posy = 0 To widy - 1
    For posx = 0 To widx - 1

      source = adress2 + posy * breite2 + posx * bperpix
      destin = adress1 + posy * breite1 * zoom + posx * bperpix * zoom
      For lupe = 0 To zoom - 1: CopyMemory(source, destin + lupe * bperpix, bperpix): Next lupe

    Next posx

    destin = adress1 + posy * breite1 * zoom
    For lupe = 1 To zoom - 1: CopyMemory(destin, destin + lupe * breite1, breite1): Next lupe

  Next posy

  FreeSprite(sprite2)

EndProcedure


InitSprite()
InitKeyboard()
ExamineDesktops()
OpenScreen(DesktopWidth(0),DesktopHeight(0),DesktopDepth(0),"")
CreateSprite(1,100,100)
StartDrawing(SpriteOutput(1))
Box( 0, 0,100,100,RGB(250,20,20))
Box(10,10, 80, 80,RGB(50,20,220))
Circle(50,50,30,RGB(200,200,50))
StopDrawing()


; Create a copy of the 1st sprite
CopySprite(1,2)

; Zoom this 2nd sprite by factor 3
ZoomSprite(2,3)

Repeat
  ExamineKeyboard()

  DisplaySprite(1,20,20)
  DisplaySprite(2,150,150)
  FlipBuffers()

Until KeyboardPushed(1)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -