; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3098&highlight=
; Author: cnesm (updated for PB4.00 by blbltheworm)
; Date: 11. December 2003
; OS: Windows
; Demo: No

; Hinweis: Die Nutzung geschieht auf eigene Gefahr des Benutzers

If OpenWindow(0,20,150,270,140,"Liste von ComboBox anzeigen",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ComboBoxGadget(0,10,10,250,100)
  AddGadgetItem(0,-1,"ComboBox")
  ButtonGadget(2, 10, 70, 200, 20, "Liste von ComboBox anzeigen")
  
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
      
    Case #PB_Event_Gadget
      If EventGadget()=2
        SendMessage_(GadgetID(0),#CB_SHOWDROPDOWN,1,1)
      EndIf
    EndSelect
  Until EventID=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
