; German forum:
; Author: Redzack (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


; Capture desktop area and print via WinAPI
; Desktop Ausschnitt "Capturen" und drucken mit WinApi


#WindowWidth  = 700
#WindowHeight = 600

hWnd.l = OpenWindow(0, 100, 120, #WindowWidth, #WindowHeight, "PureBasic - Gadget Demonstration", #PB_Window_MinimizeGadget)

If hWnd
 
  hBmp.l       = CreateImage(0,2000,2000)
  hdcWnd.l     = GetDC_(hWnd)
  hDektop.l    = GetDesktopWindow_()
  hdcDesktop.l = GetDC_(hdcDesktop)
  hdcBmp.l     = CreateCompatibleDC_(hdcWnd)
 
  SelectObject_(hdcBmp,hBmp)

  ; Dektopausschnitt in das Image kopieren und gleich vergrﬂern.
 
  StretchBlt_(hdcBmp,0,0,ImageWidth(0) ,ImageHeight(0) ,hdcDesktop,0,0,100,100,#SRCCOPY)

  If PrintRequester()

    If StartPrinting("Print")
 
      If StartDrawing(PrinterOutput())

        DrawImage(ImageID(0), 0, 0)
       
        StopDrawing()
   
      EndIf
   
      StopPrinting()
 
    EndIf
 
  EndIf
 
  Repeat

    EventID = WaitWindowEvent()

  Until EventID = #PB_Event_CloseWindow

EndIf
DeleteDC_(hdcBmp)
FreeImage(0)
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -