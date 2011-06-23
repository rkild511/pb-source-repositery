; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7424
; Author: Fred (example by blbltheworm, updated for PB4.00 by blbltheworm)
; Date: 03. September 2003
; OS: Windows
; Demo: No


; Here is a snippet I need for my work, to really put a window in the foreground,
; instead of flashing taskbar for Win98/2000 or XP. Warning, use it with care and
; only when needed, as it's not very smart to grab the user input without notice 

; Code by Elvis Rox erox@etree.com 

Procedure ReallySetForegroundWindow(Window) 

  hWnd = WindowID(Window) 

  ; If the window is in a minimized state, maximize now 
  
  If GetWindowLong_(hWnd, #GWL_STYLE) & #WS_MINIMIZE 
    ShowWindow_(hWnd, #SW_MAXIMIZE) 
    UpdateWindow_(hWnd) 
  EndIf 
  
  ; Check To see If we are the foreground thread 
  
  foregroundThreadID = GetWindowThreadProcessId_(GetForegroundWindow_(), 0) 
  ourThreadID = GetCurrentThreadId_() 
  ; If not, attach our thread's 'input' to the foreground thread's 
  
  If (foregroundThreadID <> ourThreadID) 
    AttachThreadInput_(foregroundThreadID, ourThreadID, #True); 
  EndIf 
  
  ; Bring our window To the foreground 
  SetForegroundWindow_(hWnd) 
  
  ; If we attached our thread, detach it now 
  If (foregroundThreadID <> ourThreadID) 
    AttachThreadInput_(foregroundThreadID, ourThreadID, #False) 
  EndIf  
  
  ; Force our window To redraw 
  InvalidateRect_(hWnd, #Null, #True) 
EndProcedure 
 
OpenWindow(1,0,0,200,100,"Don't Minimize me ;)",#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget)
While WindowEvent()<>#PB_Event_CloseWindow
  ReallySetForegroundWindow(1)
  Delay(1)
Wend

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
