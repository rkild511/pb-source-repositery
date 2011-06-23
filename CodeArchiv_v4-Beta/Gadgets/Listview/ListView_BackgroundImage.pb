; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5208&highlight=
; Author: El_Choni  (updated for PB3.92+ by Andre)
; Date: 26. February 2003
; OS: Windows
; Demo: No


; The CallCom() command need the userlib: .....

Global OldListViewProc, mDC, width, height

Declare ListViewProc(hWnd, uMsg, wParam, lParam)
Declare OleOpen(File$)

OleInitialize_(0)
If OpenWindow(0, 128, 96, 640, 480, "ListView background image example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget)
  If CreateGadgetList(WindowID(0))
    ListViewGadget = ListViewGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
    AddGadgetItem(0, 0, "Aaa 1")
    AddGadgetItem(0, 1, "Aab 2")
    AddGadgetItem(0, 2, "Abb 3")
    Buffer = AllocateMemory(512)
    GetModuleFileName_(GetModuleHandle_(0), Buffer, 512)
    InitialDir$ = GetPathPart(PeekS(Buffer))
    FreeMemory(Buffer)
    File$ = OpenFileRequester("Select image", InitialDir$, "Supported images|*.bmp;*.ico;*.gif;*.jpg;*.wmf;*.emf", 0)
    If File$
      OleOpen(File$)
      ; For bitmaps only, delete OleOpen(), delete the above line and use:
      ; LoadImage(0, File$)
      ; hDC = GetDC_(WindowID)
      ; mDC = CreateCompatibleDC_(hDC)
      ; OldObject = SelectObject_(mDC, UseImage(0))
    EndIf
    OldListViewProc = SetWindowLong_(ListViewGadget, #GWL_WNDPROC, @ListViewProc())
    Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow
    SelectObject_(mDC, OldObject)
    DeleteDC_(mDC)
  EndIf
EndIf
OleUninitialize_()
End

Procedure ListViewProc(hWnd, uMsg, wParam, lParam)
  result = 0
  Select uMsg
    Case #WM_LBUTTONDOWN
      result = CallWindowProc_(OldListViewProc, hWnd, uMsg, wParam, lParam)
      SendMessage_(hWnd, #WM_PAINT, 0, 0)
    Case #WM_PAINT
      result = CallWindowProc_(OldListViewProc, hWnd, uMsg, wParam, lParam)
      hDC = GetDC_(hWnd)
      BitBlt_(hDC, 0, 0, width, height, mDC, 0, 0, #SRCAND)
      ReleaseDC_(hWnd, hDC)
    Default
      result = CallWindowProc_(OldListViewProc, hWnd, uMsg, wParam, lParam)
  EndSelect
  ProcedureReturn result
EndProcedure

;#E_POINTER = $80000005
;#E_NOINTERFACE = $80000004
;#E_OUTOFMEMORY = $80000002

#IPicture_Release = 8
#IPicture_Get_Width = 24
#IPicture_Get_Height = 28
#IPicture_Render = 32

Procedure OleOpen(ImageFile$)
  Shared pstm, gpPicture, hmwidth, hmheight, OldObject
  hBitmap = 0
  If ReadFile(0, ImageFile$)
    FileSize = FileSize(ImageFile$)
    hGlobal = GlobalAlloc_(#GMEM_MOVEABLE, FileSize)
    pvData = GlobalLock_(hGlobal)
    ReadData(0,pvData, FileSize)
    CloseFile(0)
    GlobalUnlock_(hGlobal)
    CreateStreamOnHGlobal_(hGlobal, #True, @pstm)
    If gpPicture
      CallCOM(#IPicture_Release, gpPicture)
    EndIf
    ErrorNumber = 0
    Select OleLoadPicture_(pstm, FileSize, #False, ?IID_IPicture, @gpPicture)
      Case #E_POINTER
        ErrorNumber = 222
      Case #E_NOINTERFACE
        ErrorNumber = 223
      Case #E_OUTOFMEMORY
        ErrorNumber = 224
    EndSelect
    CallCOM(#IPicture_Release, pstm)
    GlobalFree_(hGlobal)
    If ErrorNumber=0
      CallCOM(#IPicture_Get_Width, gpPicture, @hmwidth)
      CallCOM(#IPicture_Get_Height, gpPicture, @hmheight)
      WindowID = WindowID(0)
      hDC = GetDC_(WindowID)
      xScreenPixels = GetDeviceCaps_(hDC, #LOGPIXELSX)
      yScreenPixels = GetDeviceCaps_(hDC, #LOGPIXELSY)
      width = Abs((hmwidth*xScreenPixels)/2540)
      height = Abs((hmheight*yScreenPixels)/2540)
      rc.RECT
      rc\left = 0
      rc\top = 0
      rc\right = width
      rc\bottom = height
      mDC = CreateCompatibleDC_(hDC)
      hBitmap = CreateCompatibleBitmap_(hDC, width, height)
      SelectObject_(mDC, hBitmap)
      CallCOM(#IPicture_Render, gpPicture, mDC, 0, 0, width, height, 0, hmheight, hmwidth, -hmheight, rc)
      ReleaseDC_(WindowID, hDC)
      CallCOM(#IPicture_Release, gpPicture)
    EndIf
  EndIf
  ProcedureReturn hBitmap
EndProcedure

!section '.data' Data readable writeable
IID_IPicture:
!DD $07BF80980
!DW $0BF32, $0101A
!DB $08B, $0BB, 0, $0AA, 0, $030, $0C, $0AB


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
