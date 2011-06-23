; http://www.purearea.net
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,220,150,"ClearGadgetItemList",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  ListViewGadget(0,10,10,200,100)
  For a=1 To 10 : AddGadgetItem (0, -1, "Item "+Str(a)) : Next    ; add 10 items
  ButtonGadget(1,10,120,150,20,"Clear Listview contents")
  Repeat
    ev.l= WaitWindowEvent()
    If ev = #PB_Event_Gadget
      If EventGadget()=1
        ClearGadgetItemList(0)
      EndIf
    EndIf
  Until ev = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP