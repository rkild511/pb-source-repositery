; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2587&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. October 2003
; OS: Windows
; Demo: No


; Need PB 3.80+ (fixed PB3.80 compiler)!!
Procedure LoadPictureFile(image,szFile.s) 
  ; 
  ; Loads 
  ;        BMP, GIF, JPG, WMF, EMF, ICO 
  ; 
  hFile = CreateFile_(szFile, #GENERIC_READ, 0, #Null, #OPEN_EXISTING, 0, #Null) 
  If hFile 
    dwFileSize = GetFileSize_(hFile, #Null) 
    HGLOBAL    = GlobalAlloc_(#GMEM_MOVEABLE, dwFileSize) 
    If HGLOBAL 
      pvData = GlobalLock_(HGLOBAL) 

      bRead = ReadFile_(hFile, pvData, dwFileSize, @dwBytesRead, #Null) 
      GlobalUnlock_(HGLOBAL) 
      
      If bRead 
        If CreateStreamOnHGlobal_(HGLOBAL, #True, @pstm.IStream) = #S_OK 
          If OleLoadPicture_(pstm, dwFileSize, #False,?IID_IPicture, @Bild.IPicture) = #S_OK 

            ; Here we got the IPicture Object 

            Bild\get_Height(@Height) 
            Bild\get_Width(@Width) 
            
            hDC = GetDC_(GetDesktopWindow_()) 
            ScreenPixels_X = GetDeviceCaps_(hDC,#LOGPIXELSX) 
            ScreenPixels_Y = GetDeviceCaps_(hDC,#LOGPIXELSY) 
            ReleaseDC_(GetDesktopWindow_(),hDC) 

            PicHeight = (Height * ScreenPixels_X) / 2540 
            PicWidth  = (Width  * ScreenPixels_Y) / 2540 
            
            result = CreateImage(image,PicWidth,PicHeight) 
            
            If result 
              hDC = StartDrawing(ImageOutput(image)) 
                Bild\Render(hDC,0,PicHeight,PicWidth,-PicHeight,0,0,Width,Height,0) 
              StopDrawing() 
            EndIf 
            
            Bild\Release() 
          EndIf 
          pstm\Release() 
        EndIf 
      EndIf 
    EndIf 
    CloseHandle_(hFile) 
  EndIf 
  ProcedureReturn result 

  DataSection 
    IID_IPicture: 
      Data.l $7BF80980 
      Data.w $BF32,$101A 
      Data.b $8B,$BB,$00,$AA,$00,$30,$0C,$AB 
  EndDataSection 
EndProcedure 

A$ = ProgramParameter() 
If A$ = "" 
  A$ = OpenFileRequester("OPEN IMAGE","","Images (BMP,GIF,JPG,ICO,WMF,EMF) | *.bmp;*.gif;*.jpg;*.jpeg;*.wmf;*.emf;*.ico",1) 
EndIf 

If A$ 
  image = LoadPictureFile(1,A$) 
  If image 
    OpenWindow(1,0,0,ImageWidth(1),ImageHeight(1),"ImageV!ew",#PB_Window_BorderLess|#PB_Window_ScreenCentered) 
    CreateGadgetList(WindowID(1)) 
    ImageGadget(1,0,0,ImageWidth(1),ImageHeight(1),image) 
    
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_CloseWindow : End 
        Case #WM_RBUTTONUP         : End 
        Case #WM_LBUTTONDOWN       : SendMessage_(WindowID(1),#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
      EndSelect 
    ForEver 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
