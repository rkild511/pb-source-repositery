; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2671&start=10
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 28. March 2005
; OS: Windows
; Demo: No

Structure TBSize 
  x.l 
  y.l 
EndStructure 

Procedure MAKELONG(low, high) 
  ProcedureReturn low | (high<<16) 
EndProcedure 

#WindowWidth  = 640 
#WindowHeight = 480 
#WindowFlags  = #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_SystemMenu 

hWnd = OpenWindow(0, 0, 0, #WindowWidth, #WindowHeight, "", #WindowFlags) 

hToolbar = CreateToolBar(0, hWnd) 
ToolBarStandardButton(0, #PB_ToolBarIcon_New) 
size.TBSize 
size\x = 128 
size\y = 128 

SendMessage_(hToolbar, #TB_SETBUTTONSIZE, 0, MAKELONG(size\x, size\y)) 
ResizeWindow(0, #PB_Ignore, #PB_Ignore, WindowWidth(0)+1, WindowHeight(0)+1) : ResizeWindow(0, #PB_Ignore, #PB_Ignore, WindowWidth(0)-1, WindowHeight(0)-1) 

Repeat 
  Event = WindowEvent() 
  Delay(10) 
Until Event = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -