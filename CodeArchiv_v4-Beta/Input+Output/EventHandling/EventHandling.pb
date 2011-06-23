; www.purearea.net
; Author: Andre (based on NicTheQuick event loop, updated for PB4.00 by blbltheworm)
; Date: 23. August 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,300,200,"Event handling example...",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(0))
    ButtonGadget(1, 10, 10,200, 20, "Button 1")
    ButtonGadget(2, 10, 40,200, 20, "Button 2")
    ButtonGadget(3, 10, 70,200, 20, "Button 3")
    StringGadget(4, 10,100,200, 20, "String....")
  EndIf
  If CreateMenu(0, WindowID(0))
    MenuTitle("Menu")
    MenuItem(1, "Item 1")
    MenuItem(2, "Item 2")
    MenuItem(3, "Item 3")
  EndIf
  Repeat
    EventID.l = WaitWindowEvent()
    Select EventID
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Gadget
      Select EventGadget()
      Case 1 : Debug "Button 1 clicked!"
      Case 2 : Debug "Button 2 clicked!"
      Case 3 : Debug "Button 3 clicked!"
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
      Case 1 : Debug "Menu item 1 clicked!"
      Case 2 : Debug "Menu item 2 clicked!"
      Case 3 : Debug "Menu item 3 clicked!"
      EndSelect
    Case #WM_KEYFIRST
      Select EventwParam()
      Case #VK_RETURN : Debug "Return in Gadget " + Str(EventGadget()) + " - Entered text: "+GetGadgetText(EventGadget())
      Case #VK_ESCAPE : Debug "Escape in Gadget " + Str(EventGadget())
        ; Case #VK_...    ; hier weitere Tastaturabfragen einfügen...
      EndSelect
    EndSelect
  ForEver
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP