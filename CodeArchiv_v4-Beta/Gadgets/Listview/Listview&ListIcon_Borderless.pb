; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3024&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 05. December 2003
; OS: Windows
; Demo: Yes

OpenWindow(0,0,0,200,400,"LV",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ContainerGadget(0,5,5,190,190) 
    ListViewGadget(1,-2,-2,194,194) 
  CloseGadgetList() 

  ContainerGadget(2,5,200,190,190) 
    ListIconGadget(3,-2,-2,194,194,"title",190,#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
  CloseGadgetList() 

  For a = 1 To 3 Step 2 
    For b = 1 To 10:AddGadgetItem(a,-1,"entry "+Str(b)):Next b 
  Next a 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #PB_Event_Gadget 
      If EventType()=#PB_EventType_LeftClick 
        ID=EventGadget() 
        A$=GetGadgetItemText(ID,GetGadgetState(ID),0) 
        MessageRequester("Gadget: "+Str(ID),A$,0) 
      EndIf 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
