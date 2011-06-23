; English forum: 
; Author: Crown/Danilo (updated for PB4.00 by blbltheworm)
; Date: 21. October 2002
; OS: Windows
; Demo: No


; ProgressBar in SystemTray - crown.

TrayWnd       = FindWindow_("Shell_TrayWnd", 0)
TrayNofifyWnd = FindWindowEx_(TrayWnd, 0, "TrayNotifyWnd", 0)

GetWindowRect_(TrayNofifyWnd,win.RECT)

x=win\left : y=win\top
w=win\right-win\left : h=win\bottom-win\top

MessageRequester("Info", "Look at the clock in the systemtray", 0)

If OpenWindow(0,x,y,w,h,"", #PB_Window_BorderLess )
   CreateGadgetList(WindowID(0))
   ProgressBarGadget(1,0,0,w,h,0,100,#PB_ProgressBar_Smooth)
   SetWindowPos_(WindowID(0),#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE)

   For x = 1 To 100
       SetGadgetState(1,x)
       Delay(50)
   Next
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -