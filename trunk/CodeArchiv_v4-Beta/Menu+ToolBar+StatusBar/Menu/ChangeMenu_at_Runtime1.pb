; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1203&highlight=
; Author: FloHimself (updated for PB 4.00 by Andre)
; Date: 12. December 2004
; OS: Windows
; Demo: No

; Additional note: with PB v4 there are also native commands for setting/changing the
;                  text of a menu item or title now. Look at the SetMenuXXX() commands.

OpenWindow(0, 0,0, 150, 200, "Menu", #PB_Window_ScreenCentered|#PB_Window_SystemMenu) 

  hMenu_Deutsch.l = CreateMenu(1, WindowID(0)) 
  MenuTitle("Datei")    
  MenuTitle("Einstellungen") 
  MenuItem(1, "Englische Menüs") 
  
  hMenu_English.l = CreateMenu(2, WindowID(0)) 
  MenuTitle("File")    
  MenuTitle("Options")    
  MenuItem(1, "German Menus") 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #PB_Event_Menu 
      If flag = 0 
        SetMenu_(WindowID(0), hMenu_Deutsch) 
        flag = 1 
      Else 
        SetMenu_(WindowID(0), hMenu_English) 
        flag = 0 
      EndIf 
      
  EndSelect 
ForEver 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -