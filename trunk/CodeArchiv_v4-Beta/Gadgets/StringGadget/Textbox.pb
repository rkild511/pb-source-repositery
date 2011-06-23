; German forum:
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 07. August 2002
; OS: Windows
; Demo: Yes

 
If OpenWindow(0, 100, 100, 500,400, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
 If CreateGadgetList(WindowID(0))
   Textbox=StringGadget(0,  10, 10, 480, 380, "Codeguru is there!",#ES_MULTILINE|#ES_AUTOVSCROLL|#WS_VSCROLL |#WS_HSCROLL)
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_CloseWindow  
      Quit = 1
    EndIf
  Until Quit = 1
  ; Debug GetGadgetText(0)
 EndIf 
EndIf
End     

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP