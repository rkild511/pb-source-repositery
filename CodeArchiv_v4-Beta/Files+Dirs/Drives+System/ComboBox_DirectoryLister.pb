; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1990&highlight=
; Author: freedimension + GPI (extended event loop by Andre, updated for PB4.00 by blbltheworm)
; Date: 15. August 2003
; OS: Windows
; Demo: No

#CBG_DIRECTORY = 1 
#txt_Directory = 2 

hWndMain = OpenWindow(0, 100, 200, 400, 40, "ComboBoxDirectoryList", #PB_Window_SystemMenu) 
CreateGadgetList(hWndMain) 
TextGadget(#txt_Directory, 10,10,150,20,"") 
ComboBoxGadget(#CBG_DIRECTORY, 220, 10, 170, 200) 
DlgDirListComboBox_(hWndMain, "C:\", #CBG_DIRECTORY, #txt_Directory, #DDL_DIRECTORY | #DDL_EXCLUSIVE) 

Repeat 
  event = WaitWindowEvent() 
  If event = #PB_Event_Gadget
    If EventGadget()=#CBG_DIRECTORY
      SetGadgetText(#txt_Directory,GetGadgetText(#CBG_DIRECTORY))
    EndIf
  EndIf
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
