; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3655&highlight=
; Author: Lars (updated for PB 4.00 by Andre)
; Date: 07. February 2004
; OS: Windows
; Demo: Yes

If OpenWindow(0, 312, 113, 317, 216, "Realtime editing of ListIcon items", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
  If CreateGadgetList(WindowID(0))
    ListIconGadget(0, 20, 20, 140, 180, "", 140,#PB_ListIcon_AlwaysShowSelection)
    AddGadgetItem(0,-1,"Eintrag 1")
    AddGadgetItem(0,-1,"Eintrag 2")
    AddGadgetItem(0,-1,"Eintrag 3")
    StringGadget(1, 170, 20, 120, 20, "")
  EndIf
EndIf

Repeat
  EventID.l=WaitWindowEvent()
  Select EventID
  Case #PB_Event_Gadget
    Select EventGadget()
    Case 0
      If EventType() = #PB_EventType_LeftClick
        SetGadgetText(1,GetGadgetItemText(0,GetGadgetState(0),0))
      EndIf
      While WindowEvent(): Wend
    Case 1
      SetGadgetItemText(0,GetGadgetState(0),GetGadgetText(1),0)
      While WindowEvent(): Wend
    EndSelect
  EndSelect
Until EventID=#PB_Event_CloseWindow
CloseWindow(0)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger