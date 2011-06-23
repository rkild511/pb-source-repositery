; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. March 2003
; OS: Windows
; Demo: No

;Mögliche Konstanten für das Ereignis 
#MOUSEEVENTF_MOVE = $1 
#MOUSEEVENTF_ABSOLUTE = $8000 
#MOUSEEVENTF_LEFTDOWN = $2 
#MOUSEEVENTF_LEFTUP = $4 
#MOUSEEVENTF_MIDDLEDOWN = $20 
#MOUSEEVENTF_MIDDLEUP = $40 
#MOUSEEVENTF_RIGHTDOWN = $8 
#MOUSEEVENTF_RIGHTUP = $10 


Procedure MouseEvent(Ereignis.l) 
  Mem.l=GlobalAlloc_(0,8) 
  GetCursorPos_(Mem) 
  mouse_event_(Ereignis|#MOUSEEVENTF_ABSOLUTE,PeekL(Mem)*($FFFF/GetSystemMetrics_(0)),PeekL(Mem+4)*($FFFF/GetSystemMetrics_(1)),0,GetMessageExtraInfo_()) 
  GlobalFree_(Mem) 
EndProcedure 

;Simuliert einen Klick mit der Rechten Maustaste an der aktuellen Cursorposition 
MouseEvent(#MOUSEEVENTF_RIGHTDOWN) 
MouseEvent(#MOUSEEVENTF_RIGHTUP) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -