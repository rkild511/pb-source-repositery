; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3261&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 28. December 2003
; OS: Windows
; Demo: Yes

; Own error window - advantage vs. MessageRequester: you can copy & paste the contents ;)
Procedure ErrorWindow(WinID.l, GadID.l, Titel.s, Text.s) 
  If OpenWindow(WinID, 0, 0, 400, 100, Titel, #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(WinID)) 
      Text = ReplaceString(Text, "|", Chr(13) + Chr(10)) 
      StringGadget(GadID, 0, 0, 400, 100, Text, #PB_String_ReadOnly | #ES_MULTILINE | #PB_String_BorderLess | #WS_VSCROLL | #WS_HSCROLL) 
      Repeat 
      Until WaitWindowEvent() = #PB_Event_CloseWindow 
      CloseWindow(WinID) 
    EndIf 
  EndIf 
EndProcedure 

ErrorWindow(0, 0, "Error", "Das|ist|ein|kopierbarer|Fehler.")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
