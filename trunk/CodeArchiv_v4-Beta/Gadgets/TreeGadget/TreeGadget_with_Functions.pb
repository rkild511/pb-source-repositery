; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1135&highlight=
; Author: CS2001 (updated for PB 4.00 by mardanny71)
; Date: 25. May 2003
; OS: Windows
; Demo: Yes

#Window_0 = 0 

;- Gadget Constants 
  
#Gadget_0 = 0 
#Gadget_1 = 1 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 216, 0, 600, 300, "TreeGadget with Functions", #PB_Window_TitleBar  ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TreeGadget(#Gadget_0, 10, 10, 270, 190) 
      StringGadget(#Gadget_1, 300, 10, 280, 40, "") 
      AddGadgetItem(#Gadget_0, 0, "Login") 
      AddGadgetItem(#Gadget_0, 1, "Logoff") 
      AddGadgetItem(#Gadget_0, 2, "End") 
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 
  
Repeat 
  
  Event = WaitWindowEvent() 
    If Event=#PB_Event_Gadget 
      Select EventGadget() 
        Case #Gadget_0 
          Eintrag=GetGadgetState(#Gadget_0) 
          If Eintrag=0 
           SetGadgetText(#Gadget_1, "Login") 
          ElseIf Eintrag=1 
           SetGadgetText(#Gadget_1, "Logoff") 
          EndIf 
      EndSelect 
    EndIf 
  
Until Eintrag=2 

; IDE Options = PureBasic v4.01 (Windows - x86)
; Folding = -
; EnableXP