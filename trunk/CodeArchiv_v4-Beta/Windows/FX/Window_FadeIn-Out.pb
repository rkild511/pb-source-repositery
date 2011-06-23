; English forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 10. January 2003
; OS: Windows
; Demo: No


;#define LWA_COLORKEY            0x00000001 
;#define LWA_ALPHA               0x00000002 

Procedure SetWinTransparency (WinHandle.l, Transparency_Level.l) 
  SetWindowLong_(WinHandle,#GWL_EXSTYLE,$00080000)                 ; #WS_EX_LAYERED = $00080000 
  SetLayeredWindowAttributes_(WinHandle,0,Transparency_Level,2)    ; 
EndProcedure 

  hwnd = OpenWindow(0,0,0,400,360, "Layered Window by Danilo",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 

  SetWinTransparency(hwnd,0) 
  HideWindow(0,0) 

  For a = 1 To 255 
    SetWinTransparency(hwnd,a) : While WindowEvent():Wend 
  Next a 

  Repeat 
    Select WaitWindowEvent() 
      ; IF LeftMouseButton pressed... 
      Case #WM_LBUTTONDOWN 
        SendMessage_(hwnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
      Case #PB_Event_CloseWindow 
        For a = 255 To 1 Step -1 
           SetWinTransparency(hwnd,a) : While WindowEvent():Wend 
        Next a 
        End 
    EndSelect 
  ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -