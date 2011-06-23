; English forum: http://www.purebasic.fr/english/viewtopic.php?t=11852&highlight=
; Author: sverson (updated for PB 4.00 by Andre)
; Date: 12. March 2005
; OS: Windows
; Demo: Yes


; Example using the ampersand(&) in the ButtonGadget text, for underlining 
; an associated accelerator key...

If OpenWindow(0, 100, 100, 220, 175, "Tab Test", #PB_Window_SystemMenu) And CreateGadgetList(WindowID(0)) 
  If CreateMenu(0, WindowID(0)) 
    MenuTitle("&Project") 
    MenuItem(1, "&Open"   +Chr(9)+"Ctrl+O") 
    MenuItem(2, "&Save"   +Chr(9)+"Ctrl+S") 
    MenuItem(3, "Save &As"+Chr(9)+"Ctrl+A") 
    MenuItem(4, "&Close"  +Chr(9)+"Ctrl+C") 
  EndIf 
  StringGadget(0, 10, 10, 200, 20, "") 
  CheckBoxGadget(1, 10, 40,200, 20, "&CheckBox1") 
  ButtonGadget(2, 10, 70, 200, 20, "Button&1") 
  StringGadget(3, 10, 100, 200, 20, "") 
  ButtonGadget(4, 10, 130, 200, 20, "Button&2") 
  SetActiveGadget(0) 
  Repeat 
    Event = WaitWindowEvent() 
  Until Event = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP