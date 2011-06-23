; German forum: http://www.purebasic.fr/german/viewtopic.php?t=374&highlight=
; Author: nco2k (updated for PB 4.00 by Andre)
; Date: 08. October 2004
; OS: Windows
; Demo: No


; Beispielcode, welcher solange das fenster aktiv ist, die Maus in ihrer 
; Bewegungsfreiheit einschränkt und somit nur innerhalb des Client-windows 
; zulässt. 

IncludeFile "ClientSize.pbi" 

#Window = 0

If OpenWindow(#Window, 0, 0, 320, 240, "Lock Mouse Demo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(#Window)) 
    ButtonGadget(0, 210, 205, 100, 25, "Exit", #PB_Button_Default) 
  EndIf 
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 0) 
EndIf 

Repeat 
  
  If GetForegroundWindow_() = WindowID(#Window) 
    MouseRect.RECT 
    MouseRect\left = ClientX(WindowID(#Window), #Window) 
    MouseRect\top = ClientY(WindowID(#Window), #Window) 
    MouseRect\right = ClientX(WindowID(#Window), #Window) + WindowWidth(#Window) 
    MouseRect\bottom = ClientY(WindowID(#Window), #Window) + WindowHeight(#Window) 
    ClipCursor_(MouseRect.RECT) 
  Else 
    ClipCursor_(0) 
  EndIf 
  
  Select WaitWindowEvent() 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case 0 
          End 
      EndSelect 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 0 
          End 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
  
ForEver 

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP