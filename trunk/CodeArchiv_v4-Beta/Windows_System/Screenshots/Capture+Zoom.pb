; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 14. June 2003
; OS: Windows
; Demo: No

;Desktop Capturen und vergrössern/verkleinern mit WinApi-Befehlen

hWnd.l = OpenWindow(0, 200, 200, 1024, 768, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)

If hWnd  
   hWndDesktop.l = GetDesktopWindow_()
   hdcDesktop.l  = GetDC_(hWndDesktop)
   hdcWindow.l = GetDC_(hWnd)
   hdcTemp.l = CreateCompatibleDC_(hdcWindow)
   hBitmap.l = CreateImage(0,1024,768)         
 
   SelectObject_(hdcTemp,hBitmap)  ; Speicherkontext mit Image    verbinden
; Desktop in das Image kopieren, und wenn mann will auch gleich
; scalieren   
StretchBlt_(hdcTemp,0,0,ImageWidth(0),ImageHeight(0),hdcDesktop,0,0,1024,1068,#SRCCOPY)   
   
; Rein damit in mein Fenster
BitBlt_(hdcWindow,0,0,ImageWidth(0),ImageHeight(0),hdcTemp,0,0,#SRCCOPY)

Sleep_(5000) ; Rumbummeln
   
   Repeat

    EventID.l = WaitWindowEvent()
   
    ; und einen Teil davon etwas Zoomen.   
    StretchBlt_(hdcWindow,0,0,ImageWidth(0)*2,ImageHeight(0)*2,hdcTemp,0,0,ImageWidth(0),ImageHeight(0),#SRCCOPY)

Until EventID = #PB_Event_CloseWindow
   
EndIf
DeleteDC_(hdcTemp)
FreeImage(0)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -