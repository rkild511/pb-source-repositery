; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3473&highlight=
; Author: Danilo (slightly modified/extended by Andre) (updated for PB4.00 by blbltheworm)
; Date: 18. January 2004
; OS: Windows
; Demo: Yes

OpenWindow(0,0,0,300,100,"Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0))
  TextGadget(0,20,20,250,20,"Press key 1 ... 7")
  For a = 1 To 7 : AddKeyboardShortcut(0,#PB_Shortcut_0+a,a) : Next 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow : End 
    Case #PB_Event_Menu 
      menu = EventMenu() 
      If menu >= 1 And menu <= 7 
        MessageRequester("INFO","Key "+Chr(menu+48)+" pressed") 
      EndIf 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
