; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6680&highlight=
; Author: fsw
; Date: 25. June 2003
; OS: Windows
; Demo: No


; If you know the Window name of a Requester you can place it... 
; (c) 2003 - Franco's Template - absolutely free 

Procedure CenterFutureWindowThread(WindowTitle$) 
  Repeat 
    WindowID = FindWindow_(0,WindowTitle$) 
    Pos.RECT : GetWindowRect_(WindowID,Pos) 
    SetWindowPos_(WindowID,#HWND_TOPMOST,(GetSystemMetrics_(#SM_CXSCREEN)/2)-((Pos\right-Pos\left)/2),(GetSystemMetrics_(#SM_CYSCREEN)/2)-((Pos\bottom-Pos\top)/2),Pos\right-Pos\left,Pos\bottom-Pos\top, 0) 
    ;MoveWindow_(WindowID,(GetSystemMetrics_(#SM_CXSCREEN)/2)-((Pos\right-Pos\left)/2),(GetSystemMetrics_(#SM_CYSCREEN)/2)-((Pos\bottom-Pos\top)/2),Pos\right-Pos\left,Pos\bottom-Pos\top, #TRUE) 
    ShowWindow_(WindowID,#SW_SHOW) 
  Until WindowID 
EndProcedure 


; Set window name
WinName$="Browse for Folder"   ; english
;WinName$="Ordner suchen"       ; deutsch

ThreadID=CreateThread(@CenterFutureWindowThread(),WinName$) 
OpenProject$ = PathRequester("Select Directory:", Path$) 
KillThread(ThreadID) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
