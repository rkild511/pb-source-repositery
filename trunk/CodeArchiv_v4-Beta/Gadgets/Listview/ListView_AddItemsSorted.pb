; English forum:
; Author: Danilo
; Date: 07. October 2002
; OS: Windows
; Demo: No

;Danilo, 07. Okt. 02


;You simply create a ListBox with the styles:
;#LBS_SORT | #LBS_NOINTEGRALHEIGHT | #LBS_HASSTRINGS
;and for adding new stuff you use:
;SendMessage_(handle, #LB_ADDSTRING, 0, String).


hWnd = OpenWindow(1,100,100,400,300,"ListBox Sort",#PB_Window_SystemMenu)
CreateGadgetList(hWnd)
ListViewGadget(1, 10,10,280,280,#LBS_SORT | #LBS_NOINTEGRALHEIGHT | #LBS_HASSTRINGS)
StringGadget  (2,300,50, 90, 20, "Type here")
ButtonGadget  (3,320,75, 50, 20, "Add")

Repeat
  Select WaitWindowEvent()
  Case #PB_Event_CloseWindow: End
  Case #PB_Event_Gadget
    Select EventGadget()
    Case 1 ; ListView
      If EventType() = #PB_EventType_LeftDoubleClick
        ; show the selected listview entry on doubleclick
        MessageRequester("INFO",GetGadgetItemText(1,GetGadgetState(1),0),0)
      EndIf
    Case 3 ; Button: Add
      SendMessage_( GadgetID(1), #LB_ADDSTRING, 0, GetGadgetText(2))
    EndSelect
  EndSelect
ForEver



; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; Executable = C:\GeoWorld\Census2000-US\zips_viewer.exe