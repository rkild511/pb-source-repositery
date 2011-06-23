; German forum: http://www.purebasic.fr/german/viewtopic.php?t=360&highlight=
; Author: nco2k (updated for PB 4.00 by Andre)
; Date: 07. October 2004
; OS: Windows
; Demo: No


Procedure ClientX(WindowID.l, WinNumber) 
  ClientRect.RECT 
  GetWindowRect_(WindowID, @ClientRect) 
  ClientPoint.POINT 
  ClientToScreen_(WindowID, @ClientPoint) 
  Result = WindowX(WinNumber) + (ClientPoint\X - ClientRect\left) 
  ProcedureReturn Result.l 
EndProcedure 

Procedure ClientY(WindowID.l, WinNumber) 
  ClientRect.RECT 
  GetWindowRect_(WindowID, @ClientRect) 
  ClientPoint.POINT 
  ClientToScreen_(WindowID, @ClientPoint) 
  Result = WindowY(WinNumber) + (ClientPoint\Y - ClientRect\top) 
  ProcedureReturn Result.l 
EndProcedure 

Procedure ClientBorder(WindowID.l, WinNumber) 
  Result = ClientX(WindowID, WinNumber) - WindowX(WinNumber) 
  ProcedureReturn Result.l 
EndProcedure 

Procedure ClientTitleBar(WindowID.l, WinNumber) 
  Result = ClientY(WindowID, WinNumber) - WindowY(WinNumber) 
  ProcedureReturn Result.l 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 31
; Folding = -