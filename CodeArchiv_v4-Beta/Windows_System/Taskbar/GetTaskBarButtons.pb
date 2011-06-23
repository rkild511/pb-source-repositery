; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2235&highlight=
; Author: bingo (updated for PB 4.00 by Andre)
; Date: 01. March 2005
; OS: Windows
; Demo: No


; Get taskbar button names (active processes)
; Namen der Schalter (aktive Programme) in der Startleiste anzeigen

taskbarhandle.l = FindWindow_("Shell_TrayWnd", 0) 

mstask.l = FindWindowEx_(taskbarhandle,0,"MSTaskSwWClass", 0) 

Procedure ListWindows(Window, Parameter) 
  WindowClass.s = Space(255) 
  WindowTitle.s = Space(255) 
  GetClassName_(Window, WindowClass, 255) 
  GetWindowText_(Window, WindowTitle, 255) 
  If WindowTitle And IsWindowVisible_(Window) 
    Debug WindowTitle + " | " + WindowClass 
  EndIf 
  
  ProcedureReturn #True  
EndProcedure 

EnumChildWindows_(mstask,@ListWindows(), 0) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -