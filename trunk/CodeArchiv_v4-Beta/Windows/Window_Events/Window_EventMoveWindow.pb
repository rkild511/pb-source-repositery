; German forum: http://www.purebasic.fr/german/viewtopic.php?t=523&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 23. October 2004
; OS: Windows
; Demo: Yes


;Vorläufiges Event MoveWindow für Windows
;Falko
Procedure WinCallback(hWnd,Msg,wParam,lParam)
  Result=#PB_ProcessPureBasicEvents
  Select Msg
    Case #WM_MOVE ;
      Debug "moving Window" ; hier könnte man dann die Ereignisse weiter ausführen
      xPos= lParam & $FFFF
      yPos= lParam>>16 & $FFFF
      Debug "xPos: "+ Str(xPos)
      Debug "yPos: "+ Str(yPos)
  EndSelect
  ProcedureReturn Result
EndProcedure

OpenWindow(0,200,200,200,200,"Test",#PB_Window_SystemMenu)
SetWindowCallback(@WinCallback())

Repeat
  eventID=WaitWindowEvent()
  Select eventID
    Case #PB_Event_CloseWindow
      End
  EndSelect
ForEver
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -