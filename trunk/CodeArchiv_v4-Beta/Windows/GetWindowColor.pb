; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Procedure GetWindowBkColor(hWnd)
  A$=Space(40)
  GetObject_(GetClassLong_(hWnd,#GCL_HBRBACKGROUND),40,@A$)
  ProcedureReturn PeekL(@A$+4)
EndProcedure

OpenWindow(1,0,0,99,99,"Fenster",1|#WS_SYSMENU)

hBrush=CreateSolidBrush_(RGB(96,200,255))
SetClassLong_(WindowID(1),#GCL_HBRBACKGROUND,hBrush)     ; Fensterfarbe setzen
InvalidateRect_(WindowID(1),#Null,#True)



Debug "Window color: "+Hex(GetWindowBkColor(WindowID(1))) ; Fensterfarbe auslesen

Repeat:Until WaitWindowEvent()=#WM_CLOSE
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -