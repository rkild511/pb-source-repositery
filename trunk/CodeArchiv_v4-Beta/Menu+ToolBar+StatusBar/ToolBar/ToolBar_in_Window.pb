; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 10. March 2003
; OS: Windows
; Demo: No

OpenWindow(0,0,0,300,300,"oink",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
    hWndPanel = PanelGadget(1,50,100,200,25)
    hWndTB = CreateToolBar(1,WindowID(0));// win = Source of events
    ToolBarStandardButton(100,#PB_ToolBarIcon_New)
    ToolBarStandardButton(101,#PB_ToolBarIcon_Open)
;
    SetParent_(hWndTB,hWndPanel);//move into panel
;
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
    Case #PB_Event_Menu
      Select EventMenu()
        Case 100: Beep_( 800,100)
        Case 101: Beep_(1000,100)
      EndSelect
  EndSelect
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -