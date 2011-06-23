; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7632&highlight=
; Author: Henrik (updated for PB4.00 by blbltheworm)
; Date: 23. September 2003
; OS: Windows
; Demo: No

#Window_0 = 0 

#Gadget_0 = 0 
#Gadget_1 = 1 
#Gadget_2 = 2 


Procedure Open_Window_0() 
    If OpenWindow(#Window_0, 216, 0, 252, 196, "DoubleClick",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
        If CreateGadgetList(WindowID(#Window_0)) 
            OptionGadget(#Gadget_0, 37, 25, 54, 25, "Test") 
            OptionGadget(#Gadget_1, 104, 26, 54, 25, "Test2") 
            StringGadget(#Gadget_2, 34, 75, 137, 32, "nothing yet") 
        EndIf 
    EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
    
    If GetTickCount_() >Dbc:DBClk=0:EndIf 
        EventID = WaitWindowEvent() 
        If EventID = #WM_LBUTTONDBLCLK 
            DBClk=1 
            Dbc=GetTickCount_()+GetDoubleClickTime_() 
        Else 
            
        EndIf 
        
        If EventID = #PB_Event_Gadget 
            
            GadgetID = EventGadget() 
            
            If GadgetID = #Gadget_0  And DBClk=0 
                SetGadgetText(#Gadget_2, "Test1 One Click") 
            ElseIf GadgetID = #Gadget_0 And DBClk=1 
                SetGadgetText(#Gadget_2, "Test1 DoubleClick**") 
                
            ElseIf GadgetID = #Gadget_1 And DBClk=0 
                SetGadgetText(#Gadget_2, "Test2 One Click") 
            ElseIf GadgetID =  #Gadget_1 And DBClk=1 
                SetGadgetText(#Gadget_2, "Test2 DoubleClick**") 
                
            EndIf 
            
            
        EndIf 
        
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
