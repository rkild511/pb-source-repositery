; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6510&highlight=
; Author: Franco, El_Choni
; Date: 12. June 2003
; OS: Windows
; Demo: No

OpenWindow(0,100,100,10,240,"Test",#PB_Window_SystemMenu) 
CreateMenu(0, WindowID(0)) 
MenuItem(1, "New") 
MenuItem(2, "Open") 
MenuItem(3, "Save") 

hToolbar = CreateToolBar(1, WindowID(0)) 
ToolBarStandardButton(1, #PB_ToolBarIcon_New) 
ToolBarStandardButton(2, #PB_ToolBarIcon_Open) 
ToolBarStandardButton(3, #PB_ToolBarIcon_Save) 
SendMessage_(hToolbar, #TB_AUTOSIZE, 0, 0) 

ResizeWindow(0,#PB_Ignore,#PB_Ignore,320, 240) 

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
