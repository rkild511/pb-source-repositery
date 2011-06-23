; English forum: 
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 30. April 2003
; OS: Windows
; Demo: Yes

Procedure.f Num(value.s) 
   ; check if given string is numeric (result<>0) or not (result=0)
   result=0 
   compare.s="1234567890,-"; change the comma for point or viceversa. valid for positives or negatives numbers 
   For i=1 To Len(value) 
     res=FindString(compare,(Mid(value,i,1)),1) 
     If res=0 
     result=result+1 
     EndIf 
   Next 
   ProcedureReturn result 
EndProcedure 

OpenWindow(1,165,0,400,309,"Text Num",#PB_Window_SystemMenu) 
     CreateGadgetList(WindowID(1)) 

      StringGadget(1,10,30,100,20,"") 
      ButtonGadget(2,50,150,50,35,"Check") 

  Repeat 
    EventID=WaitWindowEvent() 
    Select EventID        
      Case #PB_Event_Gadget                
        EventGadget = EventGadget() 
        
        Select EventGadget 
        Case 1 
        ;You code 
        Case 2 
        Numeric$=GetGadgetText(1) 
        If Num(Numeric$)<>0 
        MessageRequester("Error", "No numerics",0) 
        Else 
        MessageRequester("OK","Numerics",0) 
        EndIf 
        EndSelect 
    EndSelect    

  Until EventID=#PB_Event_CloseWindow 
    CloseWindow(1) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP