; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1596&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm + Andre)
; Date: 05. July 2003
; OS: Windows
; Demo: No

#LoadImage = #True     ; set to #False if you want to use a on-the-fly created image

#Window_0 = 0
#Gadget_0 = 0
#Gadget_1 = 1

Procedure Rotate(Image$)

  Image1Dc = CreateCompatibleDC_(0)
  Image1 = LoadImage_(0,Image$,0,0,0,$2050)
  OldObject = SelectObject_(Image1Dc,Image1)
  GetObject_(Image1,SizeOf(BITMAP),bmp.BITMAP)

  Image2Dc = CreateCompatibleDC_(0)
  Image2 = CreateCompatibleBitmap_(Image1Dc,bmp\bmHeight,bmp\bmWidth)
  SelectObject_(Image2Dc,Image2)

  ia = bmp\bmHeight
  While ia > 0
    i = 0
    While i < bmp\bmWidth
      BitBlt_(Image2Dc,bmp\bmHeight-ia,i,1,1,Image1Dc,i,ia,#SRCCOPY)
      i = i + 1
    Wend
    ia = ia - 1
  Wend

  CreateImage(2,bmp\bmHeight,bmp\bmWidth)
  Windc = StartDrawing(ImageOutput(2))
  StretchBlt_(Windc,0,0,bmp\bmHeight,bmp\bmWidth,Image2Dc,0,0,bmp\bmHeight,bmp\bmWidth,#SRCCOPY)
  StopDrawing()

  ReleaseDC_(0,Image1Dc)
  DeleteObject_(Image1)
  ReleaseDC_(0,Image2Dc)
  DeleteObject_(Image2)
EndProcedure

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 381, 90, 313, 556, "Image Rotation...", #PB_Window_SystemMenu | #PB_Window_TitleBar )
    If CreateGadgetList(WindowID(#Window_0))
      ImageGadget(#Gadget_0, 5, 5, 300, 200, ImageID(0))
      ImageGadget(#Gadget_1, 40, 270, 0, 0,0)
    EndIf
  EndIf
EndProcedure

CompilerIf #LoadImage = #True
  UsePNGImageDecoder()
  LoadImage(0,"..\Gfx\PureBasicLogoNew.png")
CompilerElse
  font = LoadFont(0, "Arial", 40)
  CreateImage(0,300,200)
  StartDrawing(ImageOutput(0))
  DrawingFont(font)
  DrawText(100,100,"Test")
  StopDrawing()
CompilerEndIf

Open_Window_0()
SaveImage(0,"~~temp.bmp",#PB_ImagePlugin_BMP)
rotate("~~temp.bmp")
DeleteFile("~~temp.bmp")
SetGadgetState(#Gadget_1,ImageID(2))


Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP