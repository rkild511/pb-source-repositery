; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14118&highlight=
; Author: HeXor (updated for PB 4.00 by Andre)
; Date: 28. February 2005
; OS: Windows
; Demo: Yes


; ExplorerListGadget in reportmode without header

#LVM_GETHEADER = #LVM_FIRST + 31 
If OpenWindow(0,0,0,600,200,"ExplorerListGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ExplorerListGadget(0, 10, 10, 580, 180, "*.*", #PB_Explorer_MultiSelect) 
  lvHeader = SendMessage_(GadgetID(0), #LVM_GETHEADER, 0, 0) 
  SetWindowLong_(lvHeader, #GWL_STYLE, GetWindowLong_(lvHeader, #GWL_STYLE) | #HDS_HIDDEN) 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -