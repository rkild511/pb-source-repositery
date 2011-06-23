; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6655&highlight=
; Author: woki (updated for PB 4.00 by Andre)
; Date: 21. June 2003
; OS: Windows
; Demo: Yes

 
win = OpenWindow(0, 10, 10, 800, 600, "Database Test", #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 

CreateGadgetList(win) 
StringGadget(0, 5, 5, 790, 590, result$, #ES_MULTILINE) 

If InitDatabase() 

  If OpenDatabaseRequester(0) 
    result$ = "Opened Database Successfully !" 
    SetGadgetText(0,result$) 
  EndIf 
Else 
  MessageRequester("Error","Can't initialize Database (ODBC v3 or better) environment",#PB_MessageRequester_Ok) 
  End 
EndIf 

Repeat 

  Select WaitWindowEvent() 

    Case #WM_CLOSE 

      Quit = 1 

  EndSelect 

Until Quit = 1 

End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
