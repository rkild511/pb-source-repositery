; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8179&highlight=
; Author: Num3 (updated for PB4.00 by blbltheworm)
; Date: 03. November 2003
; OS: Windows
; Demo: No

; Made this one to send and receive net send messages on NT networks.. 
;
; The code is a bit swapy, and sometimes, just sometimes it crashes,
; i haven't located that bug yet... but it runs stable for days ! 
;
; This code traps the netsend incoming messages, so you get no
; inconvinient popups in the middle of the screen for everyone
; to Read  (good for office flirting)  


; PureBasic Visual Designer v3.72 
; 
; ********** Final Version, no memory leaks, no cpu hogging ********* 
; 
; 
Global Text.s,kill.l 

;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#Gadget_0 = 0 
#Gadget_2 = 1 
#Gadget_3 = 2 
#Gadget_4 = 3 
#Gadget_5 = 5 
#Gadget_6 = 6 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 268, 328, 482, 140, "NetSend Pro - Freeware",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TextGadget(#Gadget_0, 3, 12, 36, 18, "Para:") 
      StringGadget(#Gadget_2, 42, 9, 126, 21,"") 
      TextGadget(#Gadget_3, 183, 9, 60, 21, "Mensagem:") 
      StringGadget(#Gadget_4, 243, 9, 180, 21, "") 
      SendMessage_(GadgetID(#Gadget_4), #EM_LIMITTEXT, 200, 0) 
      ButtonGadget(#Gadget_6, 426, 9, 54, 21, "Enviar") 
      ListViewGadget(#Gadget_5, 3, 42, 477, 95)      
    EndIf 
  EndIf 
EndProcedure 



Structure info 
  handle.l 
  process.l 
  class$ 
  name$ 
EndStructure 
;#PROCESS_ALL_ACCESS=$FFF 

Global info.info 
;Global AllHandle.AllHandle 

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

  quit=0 
  i=0 

  info\handle=handle 
  info\process=process 
  info\class$=class$ 
  info\name$=name$ 

EndProcedure 


Procedure TerminateProcess(processid) 
  process=OpenProcess_(#PROCESS_ALL_ACCESS,1,processid) 
  If process 
    TerminateProcess_(process,0) 
    CloseHandle_(process) 
  EndIf 
EndProcedure 


Procedure refreshlist() 
  
  
  handle=GetWindow_(WindowID(0),#GW_HWNDFIRST) 
  
  
  Repeat 
    handle=GetWindow_(WindowID(0),#GW_HWNDFIRST) 
    
    AddInfo(handle) 
    test.s=info\name$ 
    
    If Mid(test,1,10)="Messenger " 
      
      kill=info\handle 
      
      x=GetWindow_(handle,#GW_CHILD) 
      If x 
        handle=x 
      EndIf 
      
      AddInfo(handle) 
      test.s=info\name$ 
      
      If Mid(test,1,7)="Message" 
        Text=test 
        AddGadgetItem(#Gadget_5,-1,"<--Recebida: "+Text) 
      EndIf 
      
      x=GetWindow_(handle,#GW_HWNDNEXT) 
      If x 
        handle=x 
      EndIf 
      
      AddInfo(handle) 
      test.s=info\name$ 
      If Mid(test,1,7)="Message" 
        Text=test 
        AddGadgetItem(#Gadget_5,-1,"<--Recebida: "+Text) 
        FlashWindow_(WindowID(0),1) 
      EndIf 
      
      
    EndIf 
    
    If kill<>0 
      PostMessage_(kill,#WM_CLOSE,0,0) 
      kill=0 
    EndIf 
    
    
    Delay(5) 
  ForEver 
EndProcedure 


cr.s=Chr(10)+Chr(13) 

Buffer.s=Space(256) 
nSize.l=256 

GetUserName_(@Buffer,@nSize) 

ret.s=UCase(Buffer) 

Open_Window_0() 

SetActiveGadget(#Gadget_2) 

tr=CreateThread(@refreshlist(),0) 

Repeat 
  
  
  Event = WaitWindowEvent() 
  
    If IsIconic_(WindowID(0)) 
      If icon=0 
       icon=1 
      EndIf 
    Else 
      If icon=1 
        icon=0 
        FlashWindow_(WindowID(0),0) 
;         w=CountGadgetItems(#Gadget_5) 
;         SetGadgetItemState(#Gadget_5,w-1,1) 
      EndIf 
    EndIf 

    GadgetID = EventGadget() 
    
    If GadgetID = #Gadget_6 
      
      If GetGadgetText(#Gadget_4)<>"" 
        ShellExecute_(null,null,"net","send "+GetGadgetText(#Gadget_2)+" ["+ret+"] "+ GetGadgetText(#Gadget_4) ,null,#SW_HIDE   ) 
        SetGadgetText(#Gadget_4,"") 
        AddGadgetItem(#Gadget_5,-1,"--> Enviada para: "+GetGadgetText(#Gadget_2)) 
        
      Else 
        MessageRequester("Erro","Não existe mensagem para enviar!",#MB_ICONERROR ) 
        SetActiveGadget(#Gadget_4) 
      EndIf 
      
    ElseIf GadgetID =#Gadget_5 
      
      If EventType() = #PB_EventType_LeftDoubleClick 
        MessageRequester("Mensagem", GetGadgetText(#Gadget_5), #PB_MessageRequester_Ok) 
      EndIf 
      
    EndIf 

  
  
Until Event = #PB_Event_CloseWindow 
KillThread(tr) 
End 
; 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
