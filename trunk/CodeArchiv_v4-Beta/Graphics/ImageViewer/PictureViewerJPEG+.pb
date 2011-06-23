; English forum: 
; Author: Unknown (updated for PB 4.00 by Deeem2031)
; Date: 10. March 2003
; OS: Windows
; Demo: No

#E_POINTER2 = $80000005 
#E_NOINTERFACE2 = $80000004 
#E_OUTOFMEMORY2 = $80000002 

#IPicture_Release = 8 
#IPicture_Get_Width = 24 
#IPicture_Get_Height = 28 
#IPicture_Render = 32 

Global hWindow, pstm.IStream, gpPicture.IPicture, hmwidth, hmheight, width, height 

Procedure OleOpen(File$) 
  hBitmap = 0 
  If ReadFile(0, File$) 
    FileSize = FileSize(File$) 
    hGlobal = GlobalAlloc_(#GMEM_MOVEABLE, FileSize) 
    pvData = GlobalLock_(hGlobal) 
    ReadData(0,pvData, FileSize) 
    CloseFile(0) 
    GlobalUnlock_(hGlobal) 
    CreateStreamOnHGlobal_(hGlobal, #True, @pstm) 
    ErrorNumber = 0 
    Select OleLoadPicture_(pstm, FileSize, #False, ?IID_IPicture, @gpPicture) 
      Case #E_POINTER2 
        ErrorNumber = 222 
      Case #E_NOINTERFACE2 
        ErrorNumber = 223 
      Case #E_OUTOFMEMORY2 
        ErrorNumber = 224 
    EndSelect
    pstm\Release() ;CallCOM(#IPicture_Release, pstm) 
    GlobalFree_(hGlobal) 
    If ErrorNumber=0 
      gpPicture\Get_Width(@hmwidth) ;CallCOM(#IPicture_Get_Width, gpPicture, @hmwidth) 
      gpPicture\Get_Height(@hmheight) ;CallCOM(#IPicture_Get_Height, gpPicture, @hmheight) 
      hDC = GetDC_(hWindow) 
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
      OldBitmap = SelectObject_(mDC, hBitmap) 
      gpPicture\Render(mDC, 0, 0, width, height, 0, hmheight, hmwidth, -hmheight, rc) ;CallCOM(#IPicture_Render, gpPicture, mDC, 0, 0, width, height, 0, hmheight, hmwidth, -hmheight, rc) 
      SelectObject_(mDC, OldBitmap) 
      DeleteDC_(mDC) 
      ReleaseDC_(hWindow, hDC) 
      gpPicture\Release() ;CallCOM(#IPicture_Release, gpPicture)
    EndIf 
  EndIf 
  ProcedureReturn hBitmap 
EndProcedure 

If OleInitialize_(0)=#S_OK 
  hWindow = OpenWindow(0, 0, 0, 320, 256, "Load picture example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible|#PB_Window_SizeGadget) 
  If hWindow 
    FileName$ = OpenFileRequester("Open image", "", "BMP image (*.bmp)|*.bmp|Icon file (*.ico)|*.ico|Cursor file (*.cur)|*.cur|JPEG image (*.jpg;*.jpeg)|*.jpg;*.jpeg|GIF image (*.gif)|*.gif|Windows Metafile (*.wmf)|*.wmf|Enhanced Metafile (*.emf)|*.emf", 0) 
    If FileName$ 
      ImageID = OleOpen(FileName$) 
      If CreateGadgetList(hWindow) And ImageID 
        ButtonImageGadget(0, 0, 0, width, height, ImageID) 
        HideWindow(0, 0) 
        SetForegroundWindow_(hWindow) 
        Repeat 
          EventID = WaitWindowEvent() 
          If EventID=#PB_Event_Gadget 
            FileName$ = OpenFileRequester("Open image", "", "All supported formats|*.bmp;*.ico;*.cur;*.wmf;*.emf;*.gif;*.jpg;*.jpeg|BMP image (*.bmp)|*.bmp|Icon file (*.ico)|*.ico|Cursor file (*.cur)|*.cur|JPEG image (*.jpg;*.jpeg)|*.jpg;*.jpeg|GIF image (*.gif)|*.gif|Windows Metafile (*.wmf)|*.wmf|Enhanced Metafile (*.emf)|*.emf", 0) 
            If FileName$ 
              ImageID = OleOpen(FileName$) 
              If ImageID 
                FreeGadget(0) 
                ResizeWindow(0,#PB_Ignore,#PB_Ignore,width, height) 
                If CreateGadgetList(hWindow) 
                  ButtonImageGadget(0, 0, 0, width, height, ImageID) 
                EndIf 
              EndIf 
            EndIf 
          EndIf 
        Until EventID=#PB_Event_CloseWindow 
      EndIf 
    EndIf 
  EndIf 
  OleUninitialize_() 
EndIf 
End 

!section '.data' Data readable writeable 
IID_IPicture: 
!dd $07bf80980 
!dw $0bf32, $0101a 
!db $08b, $0bb, 0, $0aa, 0, $030, $0c, $0ab 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger