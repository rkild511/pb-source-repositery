; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1203&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 12. December 2004
; OS: Windows
; Demo: No

; Additional note: with PB v4 there are also native commands for setting/changing the
;                  text of a menu item or title now. Look at the SetMenuXXX() commands.
; 
; We just have to open a window and see when an event happen on the menu 
; MenuEintrag tauschen, hinzufügen und löschen. 

If OpenWindow(0, 100, 150, 195, 260, "PureBasic - Menu", #PB_Window_SystemMenu) 

  ; 
  ; Create the menu. The indent is very important here for a good lisibility 
  ; 

  hMenu = CreateMenu(0, WindowID(0)) 
  If hMenu 
    MenuTitle("File") 
      MenuItem( 1, "&Load...") 
      MenuItem( 2, "Save") 
      MenuItem( 3, "Save As...") 
      MenuBar() 
      OpenSubMenu("Recents") 
        MenuItem( 5, "C:\Autoexec.bat") 
        MenuItem( 6, "D:\Test.txt") 
        OpenSubMenu("Even more !") 
          MenuItem( 12, "Test") 
        CloseSubMenu() 
        MenuItem( 13, "C:\Ok.bat") 
      CloseSubMenu() 
      MenuBar() 
      MenuItem( 7, "&Quit") 

    MenuTitle("Edition") 
      MenuItem( 8, "Cut") 
      MenuItem( 9, "Copy") 
      MenuItem(10, "Paste") 
      
    MenuTitle("?") 
      MenuItem(11, "About") 
      MenuItem(14, "Men_Wechseln") 
      MenuItem(15, "Men_Hinzufügen") 
      MenuItem(16, "Men_Hinzufügen_löschen") 
      MenuItem(17, "Men_disabled") 
  EndIf 
  
  DisableMenuItem(0, 3, 1) 
  DisableMenuItem(0, 13, 1) 
  
  ; 
  ; This is the 'event loop'. All the user actions are processed here. 
  ; It's very easy to understand: when an action occurs, the EventID 
  ; isn't 0 and we just have to see what have happened... 
  ; 
  Repeat 

    Select WaitWindowEvent() 

      Case #PB_Event_Menu 

        Select EventMenu()  ; To see which menu has been selected 

          Case 14 ; Men_Wechseln 
            ModifyMenu_(hMenu, 1, #MF_BYPOSITION,1, "Editieren"); Titel in Deutsch ersetzen 
            ModifyMenu_(hMenu, 1, #MF_BYCOMMAND,1, "Datei&Laden");Item in Deutsch ersetzen 
                        
          Case 15 ; Men_Hinzufügen 
            InsertMenu_(hMenu,3,#MF_BYPOSITION ,18,"Hinzugefügt");Titel erweitern 
            DrawMenuBar_(WindowID(0)) 
          Case 16 ; Men_Hinzufügen_löschen 
            DeleteMenu_(hMenu,3,#MF_BYPOSITION);Titel löschen 
          Case 17 ; Men_Hinzufügen_löschen 
            EnableMenuItem_(hMenu,1,#MF_BYPOSITION|#MF_GRAYED);Titel disabled 

          Default 
            MessageRequester("Info", "MenuItem: "+Str(EventMenu()), 0) 
          EndSelect 
          DrawMenuBar_(WindowID(0)) 
      Case #WM_CLOSE ; #PB_EventCloseWindow 
        Quit = 1 

    EndSelect 

  Until Quit = 1 

EndIf 

End  
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -