; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=753&start=10
; Author: PWS32 (updated for PB4.00 by blbltheworm)
; Date: 25. April 2003
; OS: Windows
; Demo: No

#MainWindow=100 

hWnd = OpenWindow(#MainWindow, 10, 10, 30, 20, "Uhr", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget) 

If CreateStatusBar(0, hWnd ) 
  AddStatusBarField(120) 
EndIf 

Procedure Uhr() 
  Time$ = FormatDate("%hh:%ii:%ss", Date()) 
  StatusBarText(0, 0, Time$,#PB_StatusBar_Center ) 
EndProcedure 

SetTimer_(WindowID(#MainWindow), 1,200, @Uhr() ) ;alle 200 mS die Uhr aktualisieren 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      KillTimer_(WindowID(#MainWindow),1) 
      End 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
