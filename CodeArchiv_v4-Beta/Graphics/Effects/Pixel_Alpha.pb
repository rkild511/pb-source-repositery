; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9695&highlight=
; Author: venom (updated for PB 4.00 by Andre)
; Date: 01. March 2004
; OS: Windows
; Demo: Yes

; Heres somthing I was fooling around with, it supports a different alpha value
; in every pixel. The normal image is a color image, and the alpha image is a
; grayscale (it actually only takes the red into account) image. In the alpha
; image every pixel of 255 is solid while 0 is fully clear. Currently it only
; supports 32-bit screens and only been tested in BGR pixel format, RGB screens
; should work. *It does very little error checking.

InitSprite()
InitKeyboard()

ExamineDesktops()
ScreenWidth  = DesktopWidth(0)
ScreenHeight = DesktopHeight(0)
OpenScreen(ScreenWidth, ScreenHeight, 32, "")

#Image=0
#Alpha=1

#Background=2

CreateImage(#Image,256,256)
StartDrawing(ImageOutput(#Image))
For i=0 To 255
  Line(i,0,1,256,RGB(255-i,128-i/2,i))
Next
StopDrawing()

CreateImage(#Alpha,256,256)
StartDrawing(ImageOutput(#Alpha))
For i=0 To 255
  Line(0,i,256,1,RGB(i,0,0))
Next
StopDrawing()


CreateImage(#Background,ScreenWidth,ScreenHeight)
StartDrawing(ImageOutput(#Background))
For i=0 To 150
  Circle(Random(ScreenWidth),Random(ScreenHeight),Random(30)+5,Random($FFFFFF))
Next
StopDrawing()

Global Dim AlphaMask(ImageWidth(#Image)-1,ImageHeight(#Image)-1)
Global Dim ColTable(ImageWidth(#Image)-1,ImageHeight(#Image)-1)

iw=ImageWidth(#Image)
ih=ImageHeight(#Image)


For x=0 To iw-1
  For y=0 To ih-1
    StartDrawing(ImageOutput(#Alpha))
    AlphaMask(x,y)=(Red(Point(x,y))*100)/255
    StopDrawing()
    StartDrawing(ImageOutput(#Image))
    ColTable(x,y)=Point(x,y)
    StopDrawing()
  Next
Next

Procedure Draw(x1,y1)
  iw=ImageWidth(#Image)
  ih=ImageHeight(#Image)
  StartDrawing(ScreenOutput())
  outbuf=DrawingBuffer()
  If outbuf=0
    End
  EndIf
  *pbuf.LONG
  hline=DrawingBufferPitch()
  format=DrawingBufferPixelFormat()
  For x=0 To iw-1
    bufxoff=outbuf+(x+x1)*4
    For y=0 To ih-1
      *pbuf=bufxoff+(y+y1)*hline
      ocol=*pbuf\l
      rcol=ColTable(x,y)
      alpha=AlphaMask(x,y)
      alpham=100-alpha

      If format=#PB_PixelFormat_32Bits_BGR
        nRed=(Blue(ocol)*alpham+Red(rcol)*alpha)/100
        nGreen=(Green(ocol)*alpham+Green(rcol)*alpha)/100
        nBlue=(Red(ocol)*alpham+Blue(rcol)*alpha)/100
        *pbuf\l=nBlue+nGreen<<8+nRed<<16

      ElseIf format=#PB_PixelFormat_32Bits_RGB
        nRed=(Red(ocol)*alpham+Red(rcol)*alpha)/100
        nGreen=(Green(ocol)*alpham+Green(rcol)*alpha)/100
        nBlue=(Blue(ocol)*alpham+Blue(rcol)*alpha)/100
        *pbuf\l=nRed+nGreen<<8+nBlue<<16
      EndIf
    Next
  Next
  StopDrawing()
EndProcedure

t=ElapsedMilliseconds()
Repeat
  ClearScreen(RGB(0,0,0))
  StartDrawing(ScreenOutput())
  DrawImage(ImageID(#Background),0,0)
  DrawText(400,20,"fps: "+Str(ofps))
  If ElapsedMilliseconds()>t+1000
    t=ElapsedMilliseconds()
    ofps=fps
    fps=0
  EndIf
  StopDrawing()

  Draw(10,10)
  FlipBuffers()
  fps+1
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger