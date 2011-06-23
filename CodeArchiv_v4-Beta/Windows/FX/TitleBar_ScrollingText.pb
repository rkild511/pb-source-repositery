; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3866&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 29. February 2004
; OS: Windows
; Demo: No

;{- Titlebar-Scrolling 
Global Scroll_Text.s, Scroll_TextLength.l, Scroll_WindowID.l, Scroll_Delay.l 
Global Scroll_State.l, Scroll_TextPos.l 

Enumeration 0 
  #Scroll_Nothing 
  #Scroll_OK 
  #Scroll_Quit 
EndEnumeration 

Procedure Scroll_WindowText() 
  Scroll_State = #Scroll_OK 
  Scroll_TextPos = 0 
  Repeat 
    SetWindowText_(WindowID(Scroll_WindowID), @Scroll_Text + Scroll_TextPos) 
    Scroll_TextPos + 1 
    If Scroll_TextPos = Scroll_TextLength + 5 
      Scroll_TextPos = 0 
    EndIf 
    Delay(Scroll_Delay) 
  Until Scroll_State = #Scroll_Quit 
  Scroll_State = #Scroll_Nothing 
EndProcedure 

Procedure Scroll(WindowID.l, Delay.l, Text.s) 
  If WindowID(WindowID) 
    Scroll_WindowID = WindowID 
    Scroll_Delay = Delay 
    Scroll_Text = Text + " *** " + Text 
    Scroll_TextLength = Len(Text) 
    If CreateThread(@Scroll_WindowText(), 0) 
      Repeat : Until Scroll_State = #Scroll_OK 
    EndIf 
  EndIf 
EndProcedure 

Procedure Scroll_SetText(Text.s) 
  Scroll_Text = Text + " *** " + Text 
  Scroll_TextLength = Len(Text) 
EndProcedure 

Procedure Scroll_SetDelay(Delay.l) 
  Scroll_Delay = Delay 
EndProcedure 

Procedure Scroll_Quit() 
  If Scroll_State = #Scroll_OK 
    Scroll_State = #Scroll_Quit 
    Repeat : Until Scroll_State = #Scroll_Nothing 
  EndIf 
EndProcedure 
;} 

Enumeration  ;Windows 
  #Win_Main 
EndEnumeration 

If OpenWindow(#Win_Main, 0, 0, 500, 20, "", #PB_Window_SystemMenu) 
  Scroll(#Win_Main, 100, "Hallo, das ist ein Scrolltext, der möglichst lang sein sollte, damit man auch viel scrollen kann!") 
  Repeat 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
  Scroll_Quit() 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger