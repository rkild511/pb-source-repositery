; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=24985#24985
; Author: Falko  (updated for PB4.00 by Falko)
; Date: 19. December 2003
; OS: Windows
; Demo: No

; Set the last menu item to the top-right corner...

;Menü mit Help rechts per API-Funktion und Structure.
;Für Redraw habe ich einfach Menü aus und dann wieder eingeschaltet


#MIIM_TYPE = 16
#MFT_RIGHTJUSTIFY = 16384

LPTSTR.s="Hilfe Rechts"
Eintrag.MENUITEMINFO
Eintrag\cbSize = SizeOf(MENUITEMINFO)
Eintrag\fMask = #MIIM_TYPE
Eintrag\ftype = #MFT_RIGHTJUSTIFY
Eintrag\dwTypeData = @LPTSTR
   
If OpenWindow(0, 100, 150, 595, 260, "PureBasic - Menu", #PB_Window_SystemMenu)
  
  
  hMenu.l=CreateMenu(0, WindowID(0))
  If hMenu
    MenuTitle("File")
    MenuItem( 1, "&Load...")
    MenuItem( 2, "Save")
    MenuItem( 3, "Save As...")
    
    MenuTitle("Bearbeiten")
    MenuItem(4, "Markieren")
    MenuTitle("Neu")
    MenuItem(5, "oh je, jetzt mehr")
    
    MenuTitle(""); Dummyplatzhalter eingefügt, damit SetMenuItem darauf zugreifen kann
    MenuItem(6,"jetzt hast du hilfe")
  EndIf
  
  ; MenuTitle ein Label geben und rechts ausrichten
  SetMenuItemInfo_(hMenu,3,1,@Eintrag) ; Menütitel ist von 0-1-2-3 gerechnet
  HideMenu(0, 1)
  HideMenu(0, 0)
  
  
  ;
  ; This is the 'event loop'. All the user actions are processed here.
  ; It's very easy to understand: when an action occurs, the EventID
  ; isn't 0 and we just have to see what have happened...
  ;
  
  Repeat
    
    Select WaitWindowEvent()
      
      Case #PB_Event_Menu
        
        Select MenuID(0)  ; To see which menu has been selected
          
          Case 11 ; About
            MessageRequester("About", "Cool Menu example", 0)
            
          Default
            MessageRequester("Info", "MenuItem: "+Str(MenuID(0)), 0)
            
        EndSelect
        
      Case #WM_CLOSE ; #PB_EventCloseWindow
        Quit = 1
        
    EndSelect
    
  Until Quit = 1
  
EndIf
FreeMenu(0)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
