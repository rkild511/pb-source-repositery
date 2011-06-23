; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2786&highlight=
; Author: cnesm (updated for PB 4.00 by Andre)
; Date: 09. November 2003
; OS: Windows
; Demo: No

If OpenWindow(0, 100, 200, 195, 260, "Beispiel: MP3 Abspielen", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)

  Buffer$=Space(128)
  mciSendString_("OPEN TEST.MPEG TYPE MPEG VIDEO ALIAS FILM",Buffer$,128,0)
  mciSendString_("PLAY FILM",0,0,0)

  Repeat
    EventID.l = WaitWindowEvent()

    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button
      mciSendString_("CLOSE FILM",0,0,0)
      Quit = 1
    EndIf

  Until Quit = 1
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -