; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8692&highlight=
; Author: Paul  (updated for PB4.00 by blbltheworm)
; Date: 13. December 2003
; OS: Windows
; Demo: Yes

; Connect to a FTP server with 'pure' PB commands... ;-)

; This code will connect to an FTP server and login with user name and password. No API  
; Of course to do things properly, you can't be lazy... you must read up on
; the FTP protocol, add error checking, proper event checking, etc. 

#Window_Main=0 
#Gadget_Main_Info=1 

Server.s="ftp.arcor.de"
User.s="anonymous" ;<-added by blbltheworm
Password.s=""      ;<-added by blbltheworm
port.l=21 


Procedure send(hNet,msg$) 
  SendNetworkData(hNet,@msg$,Len(msg$)) 
EndProcedure 

Procedure wait(hNet) 
  Mem = AllocateMemory(1000)  
  If Mem
  length=ReceiveNetworkData(hNet,Mem,1000) 
  ProcedureReturn Mem 
EndIf
EndProcedure 

Procedure.l Window_Main() 
  If OpenWindow(#Window_Main,175,0,351,216,"FTP Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    If CreateGadgetList(WindowID(#Window_Main)) 
      EditorGadget(#Gadget_Main_Info,0,0,350,215) 
      HideWindow(#Window_Main,0) 
      ProcedureReturn WindowID(#Window_Main) 
    EndIf 
  EndIf 
EndProcedure 


;-------------------- 
If InitNetwork() 
  hNet=OpenNetworkConnection(Server,port) 
  If hNet 
    Window_Main() 
    
    AddGadgetItem(#Gadget_Main_Info,-1,PeekS(wait(hNet)) ) 
    Delay(100) 
    send(hNet,"USER "+User+Chr(13)+Chr(10)) 
    AddGadgetItem(#Gadget_Main_Info,-1,PeekS(wait(hNet)) ) 
    Delay(100) 
    send(hNet,"PASS "+Password+Chr(13)+Chr(10)) 
    AddGadgetItem(#Gadget_Main_Info,-1,PeekS(wait(hNet)) ) 
    Delay(100) 
    send(hNet,"QUIT"+Chr(13)+Chr(10)) 
    AddGadgetItem(#Gadget_Main_Info,-1,PeekS(wait(hNet)) ) 
    
    CloseNetworkConnection(hNet)    
    Repeat 
    Until WaitWindowEvent()=#PB_Event_CloseWindow 

    Else 
    MessageRequester("Connection Error","Could Not Connect to FTP Server",#MB_ICONERROR) 
  EndIf 
  
  Else 
  MessageRequester("Error","Could Not Initialize Network",#MB_ICONERROR) 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
