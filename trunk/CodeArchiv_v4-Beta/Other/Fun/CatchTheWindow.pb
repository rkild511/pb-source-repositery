; German forum: http://www.purebasic.fr/german/viewtopic.php?t=717&highlight=
; Author: Sunny (updated for PB 4.00 by Andre)
; Date: 17. November 2004
; OS: Windows
; Demo: No

If OpenWindow(0, Random(500), Random(500), 195, 260, "PureBasic Window", #PB_Window_SystemMenu)

  SetTimer_(WindowID(0), 1, 50, 0)

  time =ElapsedMilliseconds()

  Repeat
    EventID.l = WaitWindowEvent()


    If EventID = #PB_Event_CloseWindow
      quit = 1

    ElseIf EventID = #WM_TIMER
      If Random(1) = 1
        ResizeWindow(0, WindowX(0)+25, WindowY(0), #PB_Ignore, #PB_Ignore)
      Else
        ResizeWindow(0, WindowX(0)-25, WindowY(0), #PB_Ignore, #PB_Ignore)
      EndIf

      If Random(1) = 1
        ResizeWindow(0, WindowX(0), WindowY(0)+25, #PB_Ignore, #PB_Ignore)
      Else
        ResizeWindow(0, WindowX(0), WindowY(0)-25, #PB_Ignore, #PB_Ignore)
      EndIf

      Delay(25)
    EndIf

  Until quit = 1

EndIf

MessageRequester("time", "Du hast " + Str(ElapsedMilliseconds() - time)  + " Millisekunden benötigt zum Schließen des Fensters." )

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -