; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1855
; Author: ChaOsKid (updated for PB 4.00 by Andre)
; Date: 31. January 2005
; OS: Windows
; Demo: No


; Shows how you do regularly updating a BalloonToolTip for your window
; Zeigt, wie man einen Balloon-Tooltip für das Fenster regelmäßig updaten kann

Global Balloon.TOOLINFO, hBalloonTip.l, Quit.l 
;/ 
Procedure BalloonTipWindow(windowID, balloonText$, balloonTitle$, balloonIcon) 
  hBalloonTip = CreateWindowEx_(0, "ToolTips_Class32", "", #WS_POPUP | #TTS_NOPREFIX, 0, 0, 0, 0, 0, 0, GetModuleHandle_(0), 0) 
  SendMessage_(hBalloonTip, #TTM_SETTIPTEXTCOLOR, RGB(0, 0, 0), 0) 
  SendMessage_(hBalloonTip, #TTM_SETTIPBKCOLOR, RGB(150, 150, 150), 0) 
  Balloon\cbSize = SizeOf(TOOLINFO) 
  Balloon\uFlags = #TTF_IDISHWND | #TTF_SUBCLASS 
  Balloon\hwnd = WindowID(windowID) 
  Balloon\uID = WindowID(windowID) 
  Balloon\lpszText = @balloonText$ 
  SendMessage_(hBalloonTip, #TTM_ADDTOOL, 0, Balloon) 
  SendMessage_(hBalloonTip, #TTM_SETDELAYTIME, #TTDT_AUTOPOP, 10000) 
  If balloonTitle$ > "" 
    SendMessage_(hBalloonTip, #TTM_SETTITLE, balloonIcon, @balloonTitle$) 
  EndIf 
EndProcedure 
;/ 
Procedure UpdateBalloonTipWindow(windowID, balloonText$) 
  Balloon\cbSize = SizeOf(TOOLINFO) 
  Balloon\hwnd = WindowID(windowID) 
  Balloon\uID = WindowID(windowID) 
  Balloon\lpszText = @balloonText$ 
  SendMessage_(hBalloonTip, #TTM_UPDATETIPTEXT, 0, Balloon) 
EndProcedure 
;/ 
Procedure changetext() 
  Repeat 
    Zeit = ElapsedMilliseconds() 
    If Timer < Zeit 
      UpdateBalloonTipWindow(0, Str(Zeit)) 
      Timer = Zeit + 1000 
    EndIf 
    Delay(20) 
  Until Quit 
EndProcedure 
;/ 

OpenWindow(0,0,0,300,200,"GadgetTooltip",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
BalloonTipWindow(0, "huhu", "test", 0) 
CreateThread(@changetext(), 0) 
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      Quit = 1 
  EndSelect 
Until Quit

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -