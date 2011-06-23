; German forum: 
; Author: Danilo (updated for PB 4.00 by HeX0R)
; Date: 02. April 2003 
; OS: Windows
; Demo: No

; Zeigt wie man Links-, Rechts-, DoppelLinks- und DoppelRechts-Klicks für das ButtonGadget() abfragt. 
; Nützlich z.B. wenn man ein Popup-Menu nach RechtsClick auf einen Button anzeigen will. 

OpenWindow(0,0,0,170,106,"Button Events",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(0)) 
   ButtonGadget(1,10,10,150,20,"Links-Klick") 
   ButtonGadget(2,10,32,150,20,"Rechts-Klick") 
   ButtonGadget(3,10,54,150,20,"Doppel-Links-Klick") 
   ButtonGadget(4,10,76,150,20,"Doppel-Rechts-Klick") 
  
Procedure GetGadget(WindowID.l) 
   Protected cursorpos.POINT 
   GetCursorPos_(@cursorpos) 
   MapWindowPoints_(0, WindowID(WindowID), cursorpos, 1) 
   ProcedureReturn ChildWindowFromPoint_(WindowID(WindowID), cursorpos\x, cursorpos\y) 
EndProcedure 

Procedure Message(Gadget.l) 
   MessageRequester("Button "+Str(Gadget),GetGadgetText(Gadget),0) 
EndProcedure 

Repeat 
   Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
         End 
      Case #WM_RBUTTONDOWN 
         If GetGadget(0) = GadgetID(2) 
            Message(2) 
         EndIf 
      Case #WM_RBUTTONDBLCLK 
         If GetGadget(0) = GadgetID(4) 
            Message(4) 
         EndIf 
      Case #WM_LBUTTONDBLCLK 
         If GetGadget(0) = GadgetID(3) 
            Message(3) 
         EndIf 
      Case #PB_Event_Gadget 
         If EventGadget() = 1 And EventType() = #PB_EventType_LeftClick 
            Message(1) 
         EndIf 
   EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP