; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8397&highlight=
; Author: Berikco (updated for PB4.00 by blbltheworm)
; Date: 18. November 2003
; OS: Windows
; Demo: Yes

;Code: 
#Menu_EscapeKey = 123  ; keyboardshortcut, will return 123 as if it was a menuitem selected 

;-Open a window --------------------- 
If OpenWindow(0, 330, 250, 395, 260, "Menus and Keyboard in Purebasic", #PB_Window_SystemMenu) 
  
  ;-Create the menu-------------------- 
  If CreateMenu(0, WindowID(0)) 
    MenuTitle("File") 
    MenuItem( 1, "&Open...") 
    MenuItem( 2, "Save") 
    MenuItem( 3, "Save As...") 
    MenuBar() 
    OpenSubMenu("Recent") 
    MenuItem( 5, "C:\OneFile.bat") 
    MenuItem( 6, "D:\OtherFile.txt") 
    OpenSubMenu("Even more !") 
    MenuItem( 12, "YetOtherItem") 
    CloseSubMenu() 
    MenuItem( 13, "C:\Ok.bat") 
    CloseSubMenu() 
    MenuBar() 
    MenuItem( 7, "E&xit") 
    
    MenuTitle("Edit") 
    MenuItem( 8, "Cut") 
    MenuItem( 9, "Copy") 
    MenuItem(10, "Paste") 
    
    MenuTitle("Help") 
    MenuItem(15, "Help Topics") 
    MenuItem(11, "About") 
    
  EndIf 
  
  DisableMenuItem(0,3, 1) ; these items become grayed-out, disabled 
  DisableMenuItem(0,13, 1) 
  
  
  ; ---------------------------------------------------------------- 
  ;-the 'event loop'. 
  ; ---------------------------------------------------------------- 
  
  
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, #Menu_EscapeKey) ; will fire event #Menu_EscapeKey when esc key pressed for window 0 
  
  
  Repeat 
    Quit = 0 ;makes sure condition never starts as 1, which would trigger Quit 
    
    ; LINE BELOW TRIGGERS ERROR : 
    
    
    
    
    
    Select WaitWindowEvent() 
      Case #PB_Event_Menu 
        Select EventMenu() ; To see which menu has been selected 
          Case #Menu_EscapeKey ; esc key 
            MessageRequester("Hint", "You pressed ESC", 0) 
            Quit = 1 
          Case 7 ; File, Exit 
            Quit = 1 
          Case 11 ; About 
            MessageRequester("About", "This is just an exercise!", 0) 
          Default 
            MessageRequester("Info", "MenuItem: "+Str(EventMenu()), 0) 
        EndSelect 
        
      Case #WM_CLOSE ; #PB_EventCloseWindow 
        MessageRequester("Exit", "One more click, please!", 0) 
        Quit = 1 
        
    EndSelect 
    
    
    
  Until Quit = 1 
  
  
  
EndIf 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
