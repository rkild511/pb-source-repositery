; English forum:
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 21. January 2003
; OS: Windows
; Demo: No

Procedure CaptureScreen(Left.l, Top.l, handle.l,Factor)
  DC.l = GetDC_(0)
  MemDC.l = CreateCompatibleDC_(DC)
  If handle = 0
    BmpID.l = CreateCompatibleBitmap_(DC, 200, 200)
  Else
    BmpID.l = handle
  EndIf
  SelectObject_( MemDC, BmpID)
  StretchBlt_( MemDC, 0, 0,200*Factor,200*Factor, DC,Left, Top, 200, 200, #SRCCOPY )
  DeleteDC_( MemDC)
  ReleaseDC_(0,DC)
  ProcedureReturn BmpID ;same BUG if Bitmap or BmpID is used...
EndProcedure
;
If OpenWindow(0,200,200,200,200,"Loupe",#PB_Window_SystemMenu) : Else : End : EndIf
If CreateGadgetList(WindowID(0)) : Else : End : EndIf
;
CursorPosition.POINT
hImage = CaptureScreen( CursorPosition\x, CursorPosition\y, 0,1)
hGadget = ImageGadget(0, 0, 0, 200,200, hImage)
;
Repeat
  EventID.l = WindowEvent()
  Delay(10)
  GetCursorPos_(CursorPosition)
  hImage = CaptureScreen( CursorPosition\x, CursorPosition\y, hImage,4)
  SendMessage_(hGadget, #STM_SETIMAGE, #IMAGE_BITMAP, hImage)
Until EventID=#PB_Event_CloseWindow
;
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger