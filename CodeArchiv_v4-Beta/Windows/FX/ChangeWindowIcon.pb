; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1961&highlight=
; Author: Franky (updated for PB4.00 by blbltheworm)
; Date: 10. August 2003
; OS: Windows
; Demo: No

If OpenWindow(1,100,100,100,100,"Icontest",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(1))
  ButtonGadget(0,0,0,100,100,"Change Icon")
  
  If LoadImage(1,"..\..\Graphics\Gfx\computer.ico")
    
    Repeat
      event=WaitWindowEvent()
      
      If event=#PB_Event_Gadget
        Select EventGadget()
        Case 0
          SendMessage_(WindowID(1),#WM_SETICON,#False,ImageID(1))
        EndSelect
      EndIf
      
    Until event=#WM_CLOSE
  EndIf
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
