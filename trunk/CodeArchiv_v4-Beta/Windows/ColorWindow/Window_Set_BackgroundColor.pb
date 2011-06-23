; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 16. April 2003
; OS: Windows
; Demo: No

hWnd1 = OpenWindow(0, 100, 200, 250, 260, "Hintergrundfarbe 1", #PB_Window_SystemMenu ) 
hWnd2 = OpenWindow(1, 400, 200, 250, 260, "Hintergrundfarbe 2", #PB_Window_SystemMenu ) 

  hBrush1 = CreateSolidBrush_(RGB(255, 255, 255)) 
  SetClassLong_(hWnd1, #GCL_HBRBACKGROUND, hBrush1) 

  hBrush2 = CreateSolidBrush_(RGB(100, 100, 100)) 
  SetClassLong_(hWnd2, #GCL_HBRBACKGROUND, hBrush2) 

  InvalidateRect_(hWnd1, #Null, #True) 
  InvalidateRect_(hWnd2, #Null, #True) 

  Repeat 
    EventID.l = WaitWindowEvent() 

    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf 

  Until Quit = 1 
  DeleteObject_(hBrush1) ; Brush löschen/freigeben! 
  DeleteObject_(hBrush2) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -