; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3695&highlight=
; Author: wayne1
; Date: 30. January 2002
; OS: Windows
; Demo: No

Procedure CaptureScreen(Left.l, Top.l, Width.l, Height.l)
  dm.DEVMODE ;structure for CreateDC()
  srcDC.l
  trgDC.l
  BMPHandle.l
  srcDC = CreateDC_("DISPLAY", "", "", dm)
  trgDC = CreateCompatibleDC_(srcDC)
  BMPHandle = CreateCompatibleBitmap_(srcDC, Width, Height)
  SelectObject_( trgDC, BMPHandle)
  BitBlt_( trgDC, 0, 0, Width, Height, srcDC, Left, Top, #SRCCOPY)
  OpenClipboard_(#Null) 
  EmptyClipboard_()
  SetClipboardData_(2, BMPHandle)
  CloseClipboard_()
  DeleteDC_( trgDC)
  ReleaseDC_( BMPHandle, srcDC)
  ProcedureReturn
EndProcedure

CaptureScreen(100, 100, 800, 600)  ; grab part of the screen, depending on the given co-ordinates

MessageRequester("Message","OK, paste the current clipboard data to Microsoft Paint or whatever program you use to see the results of the screen capture.",#MB_ICONEXCLAMATION)


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
