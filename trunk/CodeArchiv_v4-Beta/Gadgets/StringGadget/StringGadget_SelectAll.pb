; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8371&highlight=
; Author: Andre (based on the procedure provided by PB, updated for PB4.00 by blbltheworm)
; Date: 16. November 2003
; OS: Windows
; Demo: No

; Select the content of a StringGadget and activate it...
Procedure SelectAll(gad) 
  SendMessage_(GadgetID(gad),#EM_SETSEL,0,99999) 
  SetActiveGadget(gad) 
EndProcedure 

If OpenWindow(0,0,0,322,70,"StringGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  StringGadget(0,8,10,306,20,"StringGadget...")
  ButtonGadget(1,8,40,306,20,"Select all in StringGadget")
  Repeat
    ev.l = WaitWindowEvent()
    If ev = #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 : SelectAll(0)
      EndSelect 
    EndIf
  Until ev = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
