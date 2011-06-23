; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 29. January 2003
; OS: Windows
; Demo: Yes

; change Text of a Menu Item

OpenWindow(0, 0,0, 100, 100, "Menu", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)

hMenu.l = CreateMenu(1, WindowID(0))  ; you need to save the Handle to the Menu like this.

  MenuTitle("Test")   
  MenuItem(5, "Click to change...")  ; add an Item (Number doesn't matter)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow: End
    Case #PB_Event_Menu               ; Item was clicked.
      
   ;With API:
      ;Text.s = "changed."             ; new Text
      ;ModifyMenu_(hMenu, 5, #MF_BYCOMMAND | #MF_STRING, 0, @Text) 
   
   ;With PB:
      SetMenuItemText(1,5,"changed.")
        ; Set new Text:
        ; fist one is the Handle you got from CreateMenu()
        ; second one is the Item Number from MenuItem()
        ; last one is the String Pointer
        ; the other ones just need to be like that.
      
  EndSelect
ForEver


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -