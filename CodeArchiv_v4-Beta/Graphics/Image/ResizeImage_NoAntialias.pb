; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9182&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 17. January 2004
; OS: Windows
; Demo: No

Procedure ResizeImage_NoAntialias(image,w,h) 
  ; 
  ; resize PB image without antialiasing 
  ; 
  ; by Danilo, 17.01.2004 - english forum 
  ; 
  hBmp_orig = ImageID(image) 
  width    = ImageWidth(image) 
  height   = ImageHeight(image) 
  hDesk = GetDesktopWindow_() 
  hDC_orig = GetWindowDC_(hDesk) 
  If hDC_orig 
    hDC = CreateCompatibleDC_(hDC1) 
    If hDC 
      hBmp = CreateCompatibleBitmap_(hDC_orig,width,height) 
      If hBmp 
        SelectObject_(hDC,hBmp) 
        hDC_orig = StartDrawing(ImageOutput(image)) 
        If hDC_orig 
          BitBlt_(hDC,0,0,width,height,hDC_orig,0,0,#SRCCOPY) 
          StopDrawing() 
          hBmp_orig = CreateImage(image,w,h) 
          hDC_orig  = StartDrawing(ImageOutput(image)) 
          If hDC_orig 
            StretchBlt_(hDC_orig,0,0,w,h,hDC,0,0,width,height,#SRCCOPY) 
            StopDrawing() 
            result = #True 
          EndIf 
        EndIf 
        DeleteObject_(hBmp) 
      EndIf 
      DeleteDC_(hDC) 
    EndIf 
    ReleaseDC_(hDesk,hDC_orig) 
  EndIf 
  ProcedureReturn result 
EndProcedure 

CreateImage(1,50,50) 
  StartDrawing(ImageOutput(1)) 
    For a = 0 To 10000:Plot(Random(50),Random(50),Random($FFFFFF)):Next a 
  StopDrawing() 

CopyImage(1,2) 

ResizeImage_NoAntialias(2,450,450) 

OpenWindow(0,0,0,500,500,"ResizeImage",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(0, 0, 0, 50, 50,ImageID(1)) 
  ImageGadget(1,50,50,450,450,ImageID(2)) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
