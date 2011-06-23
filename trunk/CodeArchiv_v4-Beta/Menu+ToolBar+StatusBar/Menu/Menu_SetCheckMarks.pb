; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5406&highlight=
; Author: wichtel (updated for PB 4.00 by Andre)
; Date: 17. August 2004
; OS: Windows
; Demo: Yes

Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #MenuBar_0 
EndEnumeration 

Enumeration 
  #MENU_2 
  #MENU_3 
  #MENU_4 
EndEnumeration 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 216, 0, 600, 300, "MenuItems - Check marks", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
    If CreateMenu(#MenuBar_0, WindowID(#Window_0)) 
      MenuTitle("test") 
      MenuItem(#MENU_2, "Eintrag1") 
      MenuItem(#MENU_3, "Eintrag2") 
      MenuItem(#MENU_4, "Eintrag3") 
    EndIf 
    If CreateGadgetList(WindowID(#Window_0)) 
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Menu 
    MenuID = EventMenu() 
    If MenuID = #MENU_2 
      Debug "GadgetID: #MENU_2" 
       SetMenuItemState(#MenuBar_0,#MENU_2,GetMenuItemState(#MenuBar_0,#MENU_2)!1)        
    ElseIf MenuID = #MENU_3 
      Debug "GadgetID: #MENU_3" 
       SetMenuItemState(#MenuBar_0,#MENU_3,GetMenuItemState(#MenuBar_0,#MENU_3)!1)        
    ElseIf MenuID = #MENU_4 
      Debug "GadgetID: #MENU_4" 
       SetMenuItemState(#MenuBar_0,#MENU_4,GetMenuItemState(#MenuBar_0,#MENU_4)!1)        
    EndIf 
  EndIf 
  If Event = #PB_Event_Gadget 
    ;Debug "WindowID: " + Str(EventWindowID()) 
    GadgetID = EventGadget() 
  EndIf 
Until Event = #PB_Event_CloseWindow 
End 
; 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -