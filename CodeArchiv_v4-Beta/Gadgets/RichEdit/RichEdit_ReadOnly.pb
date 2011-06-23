; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2688&highlight=
; Author: nicolaus (corrected example of Michael)
; Date: 29. October 2003
; OS: Windows
; Demo: No

OpenWindow(1, 300, 300, 510, 310, "Hilfe", #PB_Window_SystemMenu|#PB_Window_TitleBar)
OpenRichEdit(WindowID(1), 0, 5, 5, 500, 300, "")
ChangeRichEditOptions(#ES_READONLY)
file$ = "hilfe.txt"
If StreamFileIn(file$, #SF_TEXT )
Else
  MessageRequester("Fehler", "Hilfedatei hilfe.txt nicht gefunden.", 0)
EndIf
Repeat
  EventID.l = WaitWindowEvent()
  If EventID = #PB_Event_CloseWindow
    Quit = 1
  EndIf
Until Quit = 1
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
