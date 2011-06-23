; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8592&highlight=
; Author: Karbon (updated for PB4.00 by blbltheworm)
; Date: 02. December 2003
; OS: Windows
; Demo: Yes


#Combo = 0 
#Text = 1  ; to loose the focus to 

Procedure.l Callback(Window, Message, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  
  If Message = #WM_COMMAND  
  
    If (wParam>>16) = #CBN_KILLFOCUS And lParam = GadgetID(#Combo) 
      Debug "Gadget lost focus" 
      
    ElseIf (wParam>>16) = #CBN_SETFOCUS And lParam = GadgetID(#Combo) 
      Debug "Gadget has focus" 
    
    EndIf 
  
  EndIf 
  
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 0, 0, 400, 100, "ComboBox focus", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
  
    SetWindowCallback(@Callback()) 
  
    ComboBoxGadget(#Combo, 10, 10, 380, 300) 
    AddGadgetItem(#Combo, -1, "Item Number 0") 
    AddGadgetItem(#Combo, -1, "Item Number 1") 
    AddGadgetItem(#Combo, -1, "Item Number 2") 
    AddGadgetItem(#Combo, -1, "Item Number 3") 
    
    StringGadget(#Text, 10, 40, 380, 20, "") 


   Repeat 
     Event = WaitWindowEvent() 
   Until Event = #PB_Event_CloseWindow 
    
  EndIf 
EndIf 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
