; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8616&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 05. December 2003
; OS: Windows
; Demo: No

; Note: with PB v4 there are now native commands available: SetMenuItemText() & SetMenuTitleText()

Procedure SetMenuText(menuHandle,nr,text$) 
  ModifyMenu_(menuHandle,nr,#MF_STRING,nr,text$) 
EndProcedure 

#win=1 
OpenWindow(#win,0,0,300,300,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
MenuID=CreateMenu(1,WindowID(#win)) 
MenuTitle("Test") 
#menu_item=10 
MenuItem(1,"Hello") 
MenuItem(#menu_item,"Rename me") 
MenuItem(2,"It's me mario") 
a=0 

Repeat 
  EventID=WaitWindowEvent() 
  If EventID=#PB_Event_Menu 
    If EventMenu()=#menu_item 
      a+1 
      Select a 
        Case 1
          ;With API
            ;SetMenuText(MenuID,#menu_item,"i have changed me") 
          ;With PB4
            SetMenuItemText(1,#menu_item,"i have changed me")
        Case 2
          ;SetMenuText(MenuID,#menu_item,"dada") 
          SetMenuItemText(1,#menu_item,"dada")
        Case 3
          ;SetMenuText(MenuID,#menu_item,"change the text")
          SetMenuItemText(1,#menu_item,"change the text")
        Case 4
          ;SetMenuText(MenuID,#menu_item,"And again") 
          SetMenuItemText(1,#menu_item,"And again")
        Case 5
          ;SetMenuText(MenuID,#menu_item,"Rename me")
          SetMenuItemText(1,#menu_item,"Rename me")
          a=0
      EndSelect 
    EndIf 
  EndIf 
Until EventID=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
