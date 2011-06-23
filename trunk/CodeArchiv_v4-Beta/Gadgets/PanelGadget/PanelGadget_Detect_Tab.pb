; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6127&highlight=
; Author: Henrik (updated for PB4.00 by blbltheworm + Andre)
; Date: 10. May 2003
; OS: Windows
; Demo: Yes


;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#Gadget_0 = 0 
#Gadget_1 = 1 
#Gadget_2 = 2 



Procedure Open_Window_0() 
    If OpenWindow(#Window_0, 216, 0, 600, 300, "PanelGadget",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
        If CreateGadgetList(WindowID(#Window_0)) 
; ****** 
           StringGadget(#Gadget_1, 90, 10, 170, 15, "") 
; ****** 
            ;- Panel2000 
            PanelGadget(#Gadget_0, 15, 30, 555, 185) 
            AddGadgetItem(#Gadget_0, -1, "Tab 1") 
            AddGadgetItem(#Gadget_0, -1, "Tab 2") 
            AddGadgetItem(#Gadget_0, -1, "Tab 3") 
; ****** 
            StringGadget(#Gadget_2, 43, 18, 225, 25, "") 
; ****** 
            AddGadgetItem(#Gadget_0, -1, "Tab 4") 
            AddGadgetItem(#Gadget_0, -1, "Tab 5") 
            AddGadgetItem(#Gadget_0, -1, "Tab 6") 
            CloseGadgetList()       ; until v3.62 ClosePanelGadget() was used
            
        EndIf 
    EndIf 
EndProcedure 


Open_Window_0() 

Repeat 
    Event = WaitWindowEvent() 
    If Event=#PB_Event_Gadget 
        AdNum =GetGadgetState(#Gadget_0) 
        Result$ = GetGadgetItemText(#Gadget_0, AdNum,0) 
        SetWindowTitle(#Window_0, "Pannel now activ: "+ Result$) 
    EndIf 
    
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
