; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1602&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 04. July 2003
; OS: Windows
; Demo: No

;/ 
;/ Advanced Spin Gadgets 
;/ 
;/ GPI - 04.07.2003 
;/ 
Structure SpinGadgets_ 
  Nr.l 
  max.l 
  min.l 
EndStructure 

Global NewList SpinGadgets_.SpinGadgets_() 

Procedure FindSpin_(Nr) 
  ok=0 
  ResetList(SpinGadgets_()) 
  Repeat 
    If NextElement(SpinGadgets_()) 
      If SpinGadgets_()\Nr=Nr 
        ok=1 
      EndIf 
    Else 
      ok=-1 
    EndIf 
  Until ok 
  If ok=1 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure DoSpinGadgetEX(Nr,EventType) 
  If FindSpin_(Nr) 
    a$=GetGadgetText(Nr) 
    a=Val(a$) 
    b=GetGadgetState(Nr) 
    If a>SpinGadgets_()\max : a=SpinGadgets_()\max : do=#True : EndIf 
    If a<SpinGadgets_()\min : a=SpinGadgets_()\min : do=#True : EndIf 
    If b>SpinGadgets_()\max : b=SpinGadgets_()\max : do=#True : EndIf 
    If b<SpinGadgets_()\min : b=SpinGadgets_()\min : do=#True : EndIf 
    If b<>a Or a$<>Str(a) Or do 
      If EventType=#PB_EventType_Change Or EventType=#PB_EventType_Focus Or EventType=#PB_EventType_ReturnKey 
        SetGadgetState(Nr,a) 
        If Str(a)<>a$ 
          SetGadgetText(Nr,Str(a)) 
          SendMessage_(GadgetID(Nr),#EM_SETSEL,0,-1) 
        EndIf 
      Else 
        SetGadgetText(Nr,Str(b)) 
        SetGadgetState(Nr,b) 
      EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure DoSpinGadget(Nr) 
  ProcedureReturn DoSpinGadgetEX(Nr,EventType()) 
EndProcedure 

Procedure SetSpinGadget(Nr,state) 
  If FindSpin_(Nr) 
    SetGadgetState(Nr,state) 
    SetGadgetText(Nr,Str(state)) 
    DoSpinGadgetEX(Nr,0) 
  EndIf 
EndProcedure 

Procedure GetSpinGadget(Nr) 
  ProcedureReturn GetGadgetState(Nr) 
EndProcedure 

Procedure CreateSpinGadget(Nr,X,Y,Width,Height,max,min,Start) 
  SpinGadget(Nr,X,Y,Width,Height,0 ,32767) ; no bug! 
  AddElement(SpinGadgets_()) 
  SpinGadgets_()\Nr=Nr 
  SpinGadgets_()\max=max 
  SpinGadgets_()\min=min 
  SetSpinGadget(Nr,Start) 
EndProcedure 

Procedure FreeSpinGadget(Nr) 
  If FindSpin_(Nr) 
    DeleteElement(SpinGadgets_()) 
    FreeGadget(Nr) 
  EndIf 
EndProcedure 

Procedure SetSpinGadgetMax(Nr,max) 
  If FindSpin_(Nr) 
    SpinGadgets_()\max=max 
    DoSpinGadgetEX(Nr,0) 
  EndIf 
EndProcedure 

Procedure SetSpinGadgetMin(Nr,min) 
  If FindSpin_(Nr) 
    SpinGadgets_()\min=min 
    DoSpinGadgetEX(Nr,0) 
  EndIf 
EndProcedure 

Procedure GetSpinGadgetMax(Nr) 
  If FindSpin_(Nr) 
    ProcedureReturn SpinGadgets_()\max 
  EndIf 
EndProcedure 

Procedure GetSpinGadgetMin(Nr) 
  If FindSpin_(Nr) 
    ProcedureReturn SpinGadgets_()\min 
  EndIf 
EndProcedure 

Procedure ResizeSpinGadget(Nr,X,Y,w,h) 
  ResizeGadget(Nr,X,Y,w,h) 
EndProcedure 

;- Little example 

OpenWindow(0,0,200,200,200,"Spin-Test",#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
CreateSpinGadget(10, 10,10, 100,32, 0,50, 40) 

SetSpinGadgetMin(10,0) 
SetSpinGadgetMax(10,20) 
SetSpinGadget(10,15);neuer Wert 

ResizeSpinGadget(10,#PB_Ignore,#PB_Ignore,#PB_Ignore,20) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Case #PB_Event_Gadget 
      If EventGadget()=10 
        DoSpinGadget(10) 
      EndIf 
  EndSelect 
ForEver 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
; EnableXP
