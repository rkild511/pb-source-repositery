; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2904&highlight=
; Author: cnesm (updated for PB4.00 by blbltheworm)
; Date: 29. November 2003
; OS: Windows
; Demo: No

hparent=OpenWindow(1,100,100,175,200,"Test",#PB_Window_SystemMenu) 
CreateGadgetList(hparent) 
hwstatus=CreateWindowEx_(0, "STATIC", "",$54000000,6,15,160,177,WindowID(1), 0, GetModuleHandle_(0), 0) 
CreateGadgetList(hwstatus) 
ListViewGadget(2,-2,-2,180,180) 
          
For a=0 To 200 
  AddGadgetItem(2,a,Str(a)) 
Next 
  
Repeat 

Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
