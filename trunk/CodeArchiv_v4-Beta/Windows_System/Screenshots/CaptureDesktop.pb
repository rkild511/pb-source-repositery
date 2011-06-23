; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

InitKeyboard()
InitMouse()
InitSprite()
DC.l = GetDC_(0)
MemDC.l = CreateCompatibleDC_(DC)
ScreenWidth = GetSystemMetrics_(#SM_CXSCREEN)
ScreenHeight = GetSystemMetrics_(#SM_CYSCREEN)
ColorDepth = GetDeviceCaps_(DC,#BITSPIXEL)
BmpID.l = CreateImage(0,ScreenWidth,ScreenHeight)
SelectObject_(MemDC, BmpID)
BitBlt_(MemDC, 0, 0, ScreenWidth, ScreenHeight,DC, 0, 0, #SRCCOPY)
DeleteDC_(MemDC)
ReleaseDC_(0,DC)
OpenScreen(ScreenWidth,ScreenHeight,ColorDepth,"")
StartDrawing(ScreenOutput())
DrawImage(BmpID,MouseX(),MouseY())
StopDrawing()
GrabSprite(0,0,0,ScreenWidth,ScreenHeight)
Repeat
  
  ExamineKeyboard()
  ExamineMouse()
  ClearScreen(RGB(0,0,0))
  DisplaySprite(0,MouseX(),MouseY())
  FlipBuffers()
  
Until KeyboardPushed(#PB_Key_All) Or MouseButton(1)

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -