; German forum: http://www.purebasic.fr/german/viewtopic.php?t=574&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 24. October 2004
; OS: Windows
; Demo: No

#WindowWidth = 640
#WindowHeight = 480

Global hWnd.l, Event

;Achte auf die Flags
If OpenWindow(0, 0, 0, #WindowWidth, #WindowHeight, "Fullscreen", #PB_Window_BorderLess | #WS_CLIPSIBLINGS)

  ;Hier musst du den Bildschirmmodus ändern
  dmScreenSettings.DEVMODE
  dmScreenSettings\dmSize = SizeOf(dmScreenSettings)
  dmScreenSettings\dmPelsWidth = #WindowWidth
  dmScreenSettings\dmPelsHeight = #WindowHeight
  dmScreenSettings\dmBitsPerPel = 32
  dmScreenSettings\dmFields = 262144 | 524288 | 1048576
  If ChangeDisplaySettings_(@dmScreenSettings, 4)  <> 0 : End : EndIf

  ;Damit auch alles glatt läuft wird einfach Maximiert
  ShowWindow_(WindowID(0), #SW_SHOWMAXIMIZED)

  Repeat
    Delay(10)
  Until WindowEvent() = #WM_KEYDOWN And EventwParam() = #VK_ESCAPE
  End
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -