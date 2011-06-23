; German forum: http://www.purebasic.fr/german/viewtopic.php?t=637&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 27. October 2004
; OS: Windows
; Demo: 
; OS; Windows
; Demo: Yes


; New for PB3.92
; directly support for right-click of mousebutton (API function not longer needed/supported)

If OpenWindow(0, 0, 0, 300, 300, "ListIcon", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
    ListIconGadget(0, 0,   0, 300, 100, "ListIcon 1", 290) 
    ListIconGadget(1, 0, 100, 300, 100, "ListIcon 2", 290) 
    ListIconGadget(2, 0, 200, 300, 100, "ListIcon 3", 290) 
    
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_CloseWindow 
          Break 
        Case #PB_Event_Gadget 
          If EventType() = #PB_EventType_RightClick 
            Select EventGadget() 
              Case 0 : MessageRequester("Rechtsklick", "ListIcon 1") 
              Case 1 : MessageRequester("Rechtsklick", "ListIcon 2") 
              Case 2 : MessageRequester("Rechtsklick", "ListIcon 3") 
            EndSelect 
          EndIf 
      EndSelect 
    ForEver 
  EndIf 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
