; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13874&highlight=
; Author: PB (updated for PB 4.00 by Andre)
; Date: 01. February 2005
; OS: Windows
; Demo: Yes

If OpenWindow(1,300,250,400,200,"PanelGadget",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) 
  pic1=LoadImage(1,"..\..\Graphics\Gfx\File.ico") 
  pic2=LoadImage(2,"..\..\Graphics\Gfx\CDRom.ico") 
  PanelGadget(1,10,10,300,150) 
    AddGadgetItem(1,-1,"One",pic1) : ButtonGadget(2,20,50,60,25,"Button1") 
    AddGadgetItem(1,-1,"Two",pic2) : ButtonGadget(3,100,50,60,25,"Button2") 
  CloseGadgetList() 
  Repeat 
    ev=WaitWindowEvent() 
    If ev=#PB_Event_Gadget 
      If GetGadgetState(1)=0 
        ResizeGadget(1,10,10,300,150) 
      Else 
        ResizeGadget(1,10,10,250,110) 
      EndIf 
    EndIf 
  Until ev=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP