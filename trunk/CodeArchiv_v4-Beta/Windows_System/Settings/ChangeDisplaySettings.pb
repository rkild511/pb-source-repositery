; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8173&highlight=
; Author: VPureBasic (updated for PB 4.00 by Andre)
; Date: 03. November 2003
; OS: Windows
; Demo: No

; Change the screenmode and switch back to regular display setup at the end
; ** Need ScreenEx userlib, get it on www.purearea.net **

If IsScreenMode(800,600,16) 
  SetScreenMode() 
  OpenWindow( 0,0,0,800,600,"",#PB_Window_SystemMenu) 

  Repeat 
  Until WaitWindowEvent() = #PB_Event_CloseWindow  

EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
