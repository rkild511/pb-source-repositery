; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3435&highlight=
; Author: Rings (updated for PB3.93 by ts-soft)
; Date: 14. January 2004
; OS: Windows
; Demo: No

; Small example how to read and receive data over the serial Connector(ComPort)
; with only API's and with a Timer driven non blocking Receiving. 
; I have written this to test a modem and its settings (AT-Hayes-Commands).

; Beispiel zum Senden/Empfangen von Daten über die serielle Schnittstelle.
; Setzt PB Vollversion v3.81+ und Windows vorraus, da einige API's genutzt werden. 


;  ComPort (RS232) example , Write and Read-data, timer driven 
;  good for a small terminal or a modem-configurator 
;  Windows only, done on january, 14th. 2004 
;  Copyright 2004 Siegfried Rings (CodeGuru) 
;
OnErrorGoto(?Errorhandling) ;Enable Errorhandling (enable Linenumbering!) 

;User Structure for all the ComPort-Stuff 
Structure structComport 
  Port.l 
  Inbuffersize.l 
  OutBuffersize.l 
  Handle.l 
  ct.COMMTIMEOUTS 
  dcb.DCB 
  Receivebuffer.l 
  ReceivebufferLength.l 
EndStructure 

Enumeration 
  #Gadget_TextSend 
  #Gadget_TextReceive 
  #Gadget_ButtonSend 
  #Gadget_ButtonReceive 
EndEnumeration 

#Win=1 
#ReceiveSendbuffer=1 
#MaxReceiveBuffer=1024 


Procedure.l SR_OpenComPort(*RS232.structComport) 
  *RS232\Handle =0 
  Device.s="COM"+Str(*RS232\Port)+":" 
  Result = CreateFile_(@Device, $C0000000, 0, 0, 3, 0, 0); create and open a existing device/file ;) 
  If Result = -1 
    MessageRequester("info", "Com Port " + Str(*RS232\Port) + " not available. Use Serial settings (on the main menu) To setup your ports.", 48) 
    ProcedureReturn 0 
  EndIf 
  If Result 
    *RS232\Handle=Result 
    mydcb.DCB 
    If GetCommState_(*RS232\Handle, @mydcb) ;First retrieve the Settings from ComPort 
  
     ;Set Baudrate etc. 
     mydcb\Baudrate=*RS232\dcb\Baudrate ;Change the Settings to our needs 
     mydcb\Bytesize=*RS232\dcb\Bytesize 
     mydcb\Parity=*RS232\dcb\Parity 
     mydcb\StopBits=*RS232\dcb\StopBits 
     Result=SetCommState_(*RS232\Handle, @mydcb) ;and write them back to Comport 
     ;Debug "SetCommState="+Str(result)    
  
     Result=SetCommTimeouts_(*RS232\Handle,*RS232\ct) ;set the Timeouts set longer for problems :) 
     ;Debug "SetCommTimeouts="+Str(Result) 
  
     ;Set In/Outbuffers 
     If Result 
      Result=SetupComm_(*RS232\Handle,*RS232\Inbuffersize,*RS232\OutBuffersize) 
     EndIf 
    EndIf 
  Else 
    CloseHandle_(Result) 
  EndIf 
  ProcedureReturn *RS232\Handle 
EndProcedure 

Procedure SR_CloseComPort(*RS232.structComport) 
  If *RS232\Handle 
    CloseHandle_(*RS232\Handle) 
    *RS232\Handle=0 
  EndIf 
EndProcedure 

Procedure SR_WriteComPort(*RS232.structComport,Rawdata.l,RawDataLength.l) 
  If *RS232\Handle=0 
    ProcedureReturn 
  EndIf 
  Written.l 
  Result=WriteFile_(*RS232\Handle,Rawdata,RawDataLength,@Written,0)  ;WriteData now to ComPort 
  FlushFileBuffers_(*RS232\Handle);Release buffer directly 
  ProcedureReturn Written 
EndProcedure 

Procedure SR_ReadComPort(*RS232.structComport) 
  If *RS232\Handle=0 
    ProcedureReturn 
  EndIf 
  Repeat 
    Result=ReadFile_(*RS232\Handle , *RS232\Receivebuffer+Offset, 256, @RetBytes, 0) ;Read content 
    If RetBytes>0 
     Offset=Offset+RetBytes 
    EndIf 
  Until RetBytes=0 Or Offset>#MaxReceiveBuffer 
  *RS232\ReceivebufferLength=Offset 
  ; FlushFileBuffers_(*RS232\Handle);Release buffer directly 
  ProcedureReturn Offset 
EndProcedure 


;- Begin of MainCode 

MyRS232.structComport ;set my own Structure For all the ComPorthandling 
MyRS232\Port=2 
MyRS232\dcb\Baudrate=9600 
MyRS232\dcb\Bytesize=8 
MyRS232\dcb\StopBits=1 ;#ONESTOPBIT 
MyRS232\dcb\Parity=#NOPARITY 

MyRS232\Inbuffersize=256 ;size is enough 
MyRS232\OutBuffersize=256 

MyRS232\ct\ReadIntervalTimeOut =200; in milliseconds '#MAXDWORD 
MyRS232\ct\ReadTotalTimeoutMultiplier = 1 
MyRS232\ct\ReadTotalTimeoutConstant = 1 
MyRS232\ct\WriteTotalTimeoutConstant = 10 
MyRS232\ct\WriteTotalTimeoutMultiplier = 1 
    
MyRS232\Receivebuffer=AllocateMemory(#MaxReceiveBuffer) ;Reserve mem For it 
MyRS232\ReceivebufferLength=0 


;- Open Window 
hwnd=OpenWindow(#Win, 1, 300, 400, 400, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
If hwnd 
If CreateGadgetList(WindowID(#Win)) 

  ;- CreateGadgets 
  StringGadget(#Gadget_TextSend, 5, 5, 200, 20, "AT") 
  StringGadget(#Gadget_TextReceive, 5, 55, 390, 340, "",#ES_MULTILINE  ) 
  ButtonGadget(#Gadget_ButtonSend,210,5,90,20,"Send") 
  ButtonGadget(#Gadget_ButtonReceive,305,5,90,20,"Receive") 

  ;- Setup Timer 
  Result=SetTimer_(hwnd,1,100,0) ;Setup our timer For receiveing Data every 100 msecs 

  ;- Setup and Open Comport 
  Result=SR_OpenComPort(MyRS232) 
  
  
  ;- Eventloop 
  Repeat 
   EventID.l = WaitWindowEvent() 

   ;- Timer-Routine to read Data from ComPort 
   If EventID =#WM_TIMER 
     If MyRS232\Handle<>0 
       Readed=SR_ReadComPort(MyRS232) 
      If MyRS232\ReceiveBufferlength>0 
        Buffer.s=Buffer.s+PeekS(MyRS232\ReceiveBuffer,MyRS232\ReceiveBufferlength) 
        SetGadgetText(#Gadget_TextReceive,Buffer.s) 
        MyRS232\ReceiveBufferlength=0 
      EndIf 
     EndIf 
   EndIf 

   If EventID =#PB_Event_Gadget 
     GadgetNR = EventGadget() 
      
     ;- Send Data to Comport 
     If GadgetNR =#Gadget_ButtonSend 
      SendText.s=GetGadgetText(#Gadget_TextSend) + Chr(13) ;add a CarriageReturn to send to modem 
      ;Debug SendText 
      Buffer.s="" 
      SetGadgetText(#Gadget_TextReceive,Buffer.s);Reset inbuffer gadget 
      Result=SR_WriteComPort(MyRS232,@SendText.s,Len(SendText.s)); Check Modem 
      Debug "Characters sended:"+Str(Result) 
     EndIf 

     ;- Read Data from Comport 
     If GadgetNR=#Gadget_ButtonReceive 
      Readed=SR_ReadComPort(MyRS232) ; Read Incoming 
      If Readed 
       Debug "Characters readed="+Str(Readed) 
       Buffer.s=Buffer.s+PeekS(MyRS232\ReceiveBuffer,MyRS232\ReceiveBufferlength) 
       SetGadgetText(#Gadget_TextReceive,Buffer.s) 
       MyRS232\ReceiveBufferlength=0 ;Shorten buffer now 
      EndIf 
     EndIf 
   EndIf 
    
  Until EventID = #PB_Event_CloseWindow 
EndIf 
EndIf 
SR_CloseComPort(MyRS232) ;Comport Close 
End  

;- Error-handler 
Errorhandling: 
MessageRequester("Error","in line "+Str(GetErrorLineNR() ),0) 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
