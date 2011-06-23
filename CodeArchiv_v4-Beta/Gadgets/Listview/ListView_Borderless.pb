; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14629&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 02. April 2005
; OS: Windows
; Demo: No

If OpenWindow(0,0,0,270,140,"ListViewGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ListViewGadget(0,10,10,250,120) 
  SetWindowLong_(GadgetID(0), #GWL_EXSTYLE, GetWindowLong_(GadgetID(0), #GWL_EXSTYLE) &(~#WS_EX_CLIENTEDGE)) 
  SetWindowPos_(GadgetID(0), 0, 0, 0, 0, 0, #SWP_SHOWWINDOW | #SWP_NOZORDER | #SWP_NOSIZE | #SWP_NOMOVE | #SWP_FRAMECHANGED) 
  For a=0 To 5 
    AddGadgetItem (0,-1,"Item "+Str(a)+" of the Listview") 
  Next 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -