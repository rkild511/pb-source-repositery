; German forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 22. May 2003
; OS: Windows
; Demo: Yes

; Use MenuItem's directly in the menu bar
OpenWindow(0,200,200,300,200,"Menu",#PB_Window_SystemMenu) 

If CreateMenu(0, WindowID(0)) 

    OpenSubMenu("File") 
      MenuItem(01,"New") 
      MenuItem(02,"Open") 
      MenuBar() 
      MenuItem(03,"eXit") 
    CloseSubMenu() 

    OpenSubMenu("Edit") 
      MenuItem(11,"Cut") 
      MenuItem(12,"Copy") 
      MenuItem(13,"Paste") 
    CloseSubMenu() 

    MenuItem( 20, "Menu 3") 
    MenuItem( 21, "Menu 4") 
    MenuItem( 22, "Menu 5") 
    MenuItem( 24, "About") 

EndIf 

  
Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Menu 
      Select EventMenu()  ; To see which menu has been selected 
        Case  3 ; eXit 
          End 
        Case 24 ; About 
          MessageRequester("ABOUT","Mein Programm, (c) 1923 bei Zonk!",0) 
        Default 
          MessageRequester("Info", "MenuItem: "+Str(EventMenu()), 0) 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -