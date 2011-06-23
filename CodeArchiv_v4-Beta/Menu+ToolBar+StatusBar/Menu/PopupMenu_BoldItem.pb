; English forum: http://www.purebasic.fr/english/viewtopic.php?p=70325#70325 
; Author: GreenGiant (updated for PB 4.00 by edel)
; Date:  26. September 2004 
; OS: Windows 
; Demo: No 

#MIIM_STATE=1 
#MFS_DEFAULT=4096 

OpenWindow(0,0,0,400,400,"test",#PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
CreatePopupMenu(0) 
MenuItem(0,"Normal1") 
MenuItem(1,"Normal2") 
MenuItem(2,"Bold") 
MenuItem(3,"Normal3") 

bold.MENUITEMINFO 
bold\cbSize=SizeOf(bold) 
bold\fMask=#MIIM_STATE 
bold\fState=#MFS_DEFAULT 
SetMenuItemInfo_(MenuID(0),2,#True,bold) ;2 specifies the item to be made bold 

Repeat 
  ev=WaitWindowEvent() 
  If ev=#WM_RBUTTONUP 
    DisplayPopupMenu(0,WindowID(0)) 
  EndIf 
Until ev=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP