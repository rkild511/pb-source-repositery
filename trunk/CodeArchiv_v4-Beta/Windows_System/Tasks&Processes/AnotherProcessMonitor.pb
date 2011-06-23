; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6967&highlight=
; Author: LJ (based on original code by GPI, updated for PB4.00 by blbltheworm)
; Date: 20. July 2003
; OS: Windows
; Demo: No


;Process Monitor 
;By GPI 
;Modified by Lance Jepsen 

#winMain=1

LoadFont (3, "Arial", 14) 
SetGadgetFont(#PB_Default, 3) 

Structure info 
  handle.l 
  process.l 
  class$ 
  name$ 
EndStructure 
;#PROCESS_ALL_ACCESS=$FFF 

Global NewList info.info() 
Global NewList AllHandle() 

Procedure.s GetClassName(handle) 
  class$=Space(1024) 
  GetClassName_(handle,@class$,Len(class$)) 
  ProcedureReturn Left(class$,Len(class$)) 
EndProcedure 
Procedure.s GetTitle(handle) 
  name$=Space(1024) 
  GetWindowText_(handle,@name$,Len(name$)) 
  ProcedureReturn Left(name$,Len(name$)) 
EndProcedure 
Procedure AddInfo(handle) 
  process=0 
  GetWindowThreadProcessId_(handle,@process) 
  class$=GetClassName(handle) 
  name$=GetTitle(handle) 
  
  ResetList(info()) 
  quit=0 
  i=0 
  Repeat 
    If NextElement(info()) 
      If process < info()\process 
        quit=1 
      ElseIf process=info()\process 
        If class$ < info()\class$ 
          quit=1 
        ElseIf UCase(class$)=UCase(info()\class$) 
          If name$ < info()\name$ 
            quit=1 
          ElseIf UCase(name$)=UCase(info()\name$) 
            If handle < info()\handle 
              quit=1 
            ElseIf handle=info()\handle 
              quit=3 
            EndIf 
          EndIf 
        EndIf 
      EndIf 
    Else 
      quit=2 
    EndIf 
  Until quit 
  If quit<3 
    If quit=1 
      If PreviousElement(info())=0: ResetList(info()) :EndIf 
    EndIf 
    AddElement(info()) 
    info()\handle=handle 
    info()\process=process 
    info()\class$=class$ 
    info()\name$=name$ 
  EndIf 
EndProcedure 
Procedure TerminateProcess(processid) 
  process=OpenProcess_(#PROCESS_ALL_ACCESS,1,processid) 
  If process 
    TerminateProcess_(process,0) 
    CloseHandle_(process) 
  EndIf 
EndProcedure 

Procedure RefreshList() 
  ClearGadgetItemList(0) 

  ClearList(AllHandle()) 
  ClearList(info()) 
  handle=GetWindow_(WindowID(#winMain),#GW_HWNDFIRST) 
  ClearList(AllHandle()) 
  quit=0 
  Repeat 
    AddInfo(handle) 
    x=GetWindow_(handle,#GW_CHILD) 
    If x 
      AddElement(AllHandle()) 
      AllHandle()=x 
    EndIf 
    x=GetWindow_(handle,#GW_HWNDNEXT) 
    If x 
      handle=x 
    Else 
      If LastElement(AllHandle()) 
        handle=AllHandle() 
        DeleteElement(AllHandle()) 
      Else 
        quit=1 
      EndIf 
    EndIf 
  Until quit 
  
  ResetList(info()) 
  
    
  While NextElement(info()) 
    If oldprocess<>info()\process 
      oldprocess=info()\process 
      a$=Hex(oldprocess) 
    Else 
      a$="              ''" 
    EndIf 
    AddGadgetItem(0,-1,a$+Chr(10)+info()\class$+Chr(10)+info()\name$+Chr(10)+Hex(info()\handle)) 

  Wend 
  
  SetGadgetState(0,0) 
EndProcedure 

If OpenWindow(#winMain,100,50,612,450,"Process Monitor",#PB_Window_SystemMenu) 
  

  If CreateGadgetList(WindowID(#winMain)) 
    ListIconGadget(0, 30,125,550,300, "Process",70) 
    AddGadgetColumn(0,1,"Class",210) 
    AddGadgetColumn(0,2,"Name",250) 
    AddGadgetColumn(0,3,"Handle",80) 
    ButtonGadget(3, 256,30, 128,22,"Post Message") 
    Frame3DGadget(2,252, 26,136,30,"",#PB_Frame3D_Single) 
    Frame3DGadget(6,20, 70,570,370,"Windows") 
    ButtonGadget(4, 395,90, 128,20,"Refresh List") 
    TextGadget(5,90,12,60, 20, "Message") 

   ComboBoxGadget(309, 30, 30, 200, 160) 
    AddGadgetItem(309,0,"*Select*") 
    AddGadgetItem(309,-1,"WM_DESTROY") 
    AddGadgetItem(309,-1,"WM_CLOSE") 
    AddGadgetItem(309,-1,"WM_QUIT") 
   SetGadgetState(309,0) 

    RefreshList() 
    
    Repeat 
   event=WaitWindowEvent() 
      Select event 
        Case #PB_Event_Gadget 
        stat=GetGadgetState(0) 
          If stat>-1 
            SelectElement(info(),stat) 
           stat=1 
          Else 
            stat=0 
          EndIf 

          Select EventGadget() 
          
             Case 3;Post Message 

               If  GetGadgetText(309)="WM_CLOSE" 
                   PostMessage_(info()\handle,#WM_CLOSE,0,0) 
               EndIf 
                
               If  GetGadgetText(309)="WM_DESTROY" 
                   PostMessage_(info()\handle,#WM_DESTROY,0,0) 
               EndIf 

              If  GetGadgetText(309)="WM_QUIT" 
                   PostMessage_(info()\handle,#WM_QUIT,0,0) 
               EndIf 

                
             Case 4 
               RefreshList() 
          EndSelect 
     EndSelect 
          
    Until event=#PB_Event_CloseWindow 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
