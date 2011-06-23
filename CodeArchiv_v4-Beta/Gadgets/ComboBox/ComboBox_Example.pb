; English forum: 
; Author: Franco (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: Yes


; Autor: Franco
; (c) 2002 - Franco's template - absolutely freeware
; Little example for the right use of the ComboBox Event
;
OpenWindow(1,200, 200, 320,240,"Window",#PB_Window_SystemMenu|#PB_Window_SizeGadget)
CreateGadgetList(WindowID(1))

CreateMenu(1, WindowID(1))
MenuTitle("File")
MenuItem(1,"New")
MenuItem(2,"Open")
MenuItem(3,"Save")

CreateToolBar(1, WindowID(1))
ToolBarStandardButton(4,#PB_ToolBarIcon_New)
ToolBarStandardButton(5,#PB_ToolBarIcon_Open)
ToolBarStandardButton(6,#PB_ToolBarIcon_Save)

ButtonGadget(1, 10, 30, 100, 25,"Button 1")

ComboBoxGadget(2, 10, 120, 100, 250)
AddGadgetItem(2, -1, "ComboBox Item 1") 
AddGadgetItem(2, -1, "ComboBox Item 2") 
AddGadgetItem(2, -1, "ComboBox Item 3") 
AddGadgetItem(2, -1, "ComboBox Item 4") 

Repeat
  EventID = WaitWindowEvent()
  
  Select EventID
    ; Menu/ToolBarEvent
    Case #PB_Event_Menu
      MessageRequester("Menu or Toolbar","Item #: "+Str(EventGadget()),0)
    
    ; GadgetsEvents
    Case #PB_Event_Gadget
      
      Select EventGadget()
        
        ; ButtonGadget
        Case 1
          Select EventType()
            Case #PB_EventType_LeftClick
              MessageRequester("Gadget","Button",0)
          EndSelect
    
        ; ComboBoxGadget
        Case 2
          Select EventType()
            Case #PB_EventType_RightClick
              MessageRequester("Gadget","ComboBox",0)
          EndSelect
    
      EndSelect
    
  EndSelect
  
Until EventID = #PB_Event_CloseWindow

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP