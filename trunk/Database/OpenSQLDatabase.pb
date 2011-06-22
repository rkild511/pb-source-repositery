; English forum: http://purebasic.myforums.net/viewtopic.php?t=6655&highlight=
; Author: woki
; Date: 21. June 2003

 
win = OpenWindow(0, 10, 10, 800, 600, #PB_Window_TitleBar | #PB_Window_SystemMenu | #PB_Window_ScreenCentered, "Database Test") 

CreateGadgetList(win) 
StringGadget(0, 5, 5, 790, 590, result$, #PB_String_Multiline) 

If InitDatabase() 

  If OpenDatabaseRequester(0) 
    result$ = "Opened Database Successfully !" 
    UseDatabase(0) 
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
; ExecutableFormat=Windows
; CursorPosition=4
; FirstLine=1
; EOF