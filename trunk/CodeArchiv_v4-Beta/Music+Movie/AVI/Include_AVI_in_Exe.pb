; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7639&highlight=
; Author: Fred (updated for PB4.00 by blbltheworm + Andre)
; Date: 25. September 2003
; OS: Windows
; Demo: Yes


If CreateFile(1, "output.avi")
  L1= ?ExitProc-?Inc
  WriteData(1,?Inc,L1)
  CloseFile(1)

  DataSection
    Inc:
    IncludeBinary "test.avi"
    ExitProc:
  EndDataSection
EndIf

InitMovie()
LoadMovie( 1, "output.avi")
OpenWindow(0,10,10,MovieWidth(1),MovieHeight(1),"IncludeAvi-Test",#PB_Window_SystemMenu | #PB_Window_ScreenCentered)
PlayMovie(1,WindowID(0))

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -