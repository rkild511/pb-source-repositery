; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3182&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 19. December 2003
; OS: Windows
; Demo: Yes

OpenWindow(0,200,200,300,200,"",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ListViewGadget(1,5,5,290,190)
  SetGadgetFont(1,LoadFont(1,"Arial",14)) 

  For a = 1 To 10 
    AddGadgetItem(1,-1,"Item "+Str(a))
  Next a 
  
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
