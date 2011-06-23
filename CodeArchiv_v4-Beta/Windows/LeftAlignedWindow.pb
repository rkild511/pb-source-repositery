; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6701&highlight=
; Author: Freak (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: No


; Open your own window at the left of the screen, and force all other windows
; to not cover it when opened, but to have their left edge aligned with the
; right edge of your window.

; Note: 
; You only need to take care of MAXIMIZED windows, as non-maximized 
; windows can also be moved over the area of the real Taskbar, only 
; Maximized Windows do not overlap it. This code behaves like the real 
; Taskbar, the only difference is it's look, but maybe you can change that 
; with some flags also, to make it look the same. 
 

; Callback to update all non-child maximized windows 
Procedure.l UpdateWindowsProc(hWnd.l, *desktop.RECT) 
  If IsZoomed_(hWnd) 
    MoveWindow_(hWnd, *desktop\left, *desktop\top, *desktop\right-*desktop\left, *desktop\bottom-*desktop\top, #True) 
  EndIf 
  ProcedureReturn #True 
EndProcedure 


; Get actual desktop size (without Taskbar) 
SystemParametersInfo_(#SPI_GETWORKAREA, 0, @desktop.RECT, 0) 

If OpenWindow(0, desktop\left, desktop\top, 0, 0, "", #PB_Window_SystemMenu) 

  ; resize Window to not overlap the Taskbar, and to 50 pixel width 
  SetWindowPos_(WindowID(0),#HWND_TOPMOST,0,0,50,desktop\bottom-desktop\top,#SWP_NOMOVE) 
  
  ; now calculate the new desktop rectangle 
  desktopnew.RECT 
  desktopnew\left = desktop\left + WindowWidth(0) + GetSystemMetrics_(#SM_CXFIXEDFRAME)*2 
  desktopnew\right = desktop\right 
  desktopnew\top = desktop\top 
  desktopnew\bottom = desktop\bottom 
  
  ; set new desktop rectangle 
  SystemParametersInfo_(#SPI_SETWORKAREA, 0, @desktopnew, #SPIF_SENDWININICHANGE) 
  
  ; update all windows (because most do not react to the #WM_SETTINGCHANGE message 
  EnumWindows_(@UpdateWindowsProc(), @desktopnew) 

  ; here comes all the rest of your prog (in my case, only wait) 
  Repeat 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
  
  ; reset desktop to old size 
  SystemParametersInfo_(#SPI_SETWORKAREA, 0, @desktop, #SPIF_SENDWININICHANGE)  
  ; update windows again 
  EnumWindows_(@UpdateWindowsProc(), @desktop) 

EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
