; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7338&highlight= 
; Author: TerryHough (updated for PB 4.00 by KeyPusher)
; Date: 16. September 2003 
; OS: Windows
; Demo: No


;PING2 - Sep 08, 2003 - Terry Hough based on work by 
;  1) PING by Siegfried Rings (known as the 'CodeGuru' ), 
;  2) URLtoIPAddress by PWS32 (from German forum), and 
;  3) LocalHostName by AlphaSnd (Fred) on main forum. 
; 
;PING2 is a Windows GUI version of the DOS based PING available on 
;Windows systems usually located as \WINDOWS\PING.EXE. PING2 add a 
;Windows interface and slightly extends the capabilites, yet remains 
;about 50 percent smaller. 
; 
;Plan to add an Error code interpretation in the future as time permits. 
; 

Global Dim bytes.w(4) 
Global Dim PingResult.w(6) 
Global Dim ttls.b(4) 
; 
Global PacketCount.w 
Global RecdPackets.w 
Global LostPackets.w 
Global LostPercent.f 
Global CheckOut.s 
Global message.s 
Global Command$ 
Global TheIPAddress.s 
Global MsgLen.b 
Global AvgTrip.f     : AvgTrip = 0 
Global MaxTrip.w     : MaxTrip = 0 
Global MinTrip.w     : MinTrip = 0 
; 
Declare lngNewAddress(strAdd.s) 
Declare Ping(strAdd.s) 
Declare.s GetIPbyName(NameIP.s) 
Declare.w Minimum(a.w,b1.w) 
Declare.w Maximum(a.w,b1.w) 
Declare GoDoIt(CheckStr.s) 
; 
If Not InitNetwork() 
    MessageRequester("InitNetwork()", "Can't initialize the network !", #PB_MessageRequester_Ok|#MB_ICONSTOP)      
    End 
EndIf 
Command$ = "" 
Command$ = LCase(ProgramParameter()) 
If Len(Command$)>0 
  If Asc(Mid(Command$,1,1)) < 48 Or Asc(Mid(Command$,1,1)) > 57 
    url$ = Command$                     ; This is a URL instead of an IP Address, eg. www.google.com 
    IP$ = "" 
  Else 
    IP$ = Command$                      ; This is an IP Address in a string 
    url$ = "" 
  EndIf    
EndIf 

If OpenWindow(0, 1, 1, 600, 409, "PING2", #PB_Window_WindowCentered|#PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
  HideWindow(0,1) 
  CreateGadgetList(WindowID(0)) 
  TextGadget(1, 10, 30,160, 20, "Enter a URL", #PB_Text_Right) 
  StringGadget(2, 180, 30, 300, 20, url$) 
  TextGadget(1, 490, 30, 60, 20, "or") 
  TextGadget(1, 10, 60,160, 20, "Enter an IP Address", #PB_Text_Right) 
  IPAddressGadget(4, 180, 60, 150, 20) 
  If Len(IP$) 
    Field1.w = Val(StringField(IP$, 1, ".")) 
    Field2.w = Val(StringField(IP$, 2, ".")) 
    Field3.w = Val(StringField(IP$, 3, ".")) 
    Field4.w = Val(StringField(IP$, 4, ".")) 
    SetGadgetState(4,MakeIPAddress(Field1,Field2,Field3,Field4)) 
  EndIf    
  ButtonGadget(6, 270, 90, 60, 30, "Proceed") 
  SetActiveGadget(2) 
  While WindowEvent():Wend 
EndIf 
  ; ---------------- This is the main processing loop ---------------------- 
  If Len(Command$) 
    GoDoIt(CheckOut) 
    End                                 ; End it if running with a command tail 
  EndIf 

  HideWindow(0,0)    
  Repeat 
    EventID = WaitWindowEvent() 
      
    ; ------------------ Process the gadget events ------------------------- 

    Select EventGadget() 
        Case 6    ; Proceed button chosen 
        GoDoIt(CheckOut) 
        
    EndSelect 
      
    If EventID =  #WM_CLOSE ;  #PB_EventCloseWindow 
      Quit = 1      
    EndIf 

  ; ------------ Insure changes are saved when quit received --------------- 
  If Quit = 1 
  EndIf  

  Until Quit = 1 
  ; -------------------End of the main processing loop --------------------- 

; --------------------------------------------------------------------- 
; End of Main program code 
; --------------------------------------------------------------------- 

; Procedures 
Procedure lngNewAddress(strAdd.s) 
  sDummy.s=strAdd 
  Position = FindString(sDummy, ".",1) 
  If Position>0 
    a1=Val(Left(sDummy,Position-1)) 
    sDummy=Right(sDummy,Len(sDummy)-Position) 
    Position = FindString(sDummy, ".",1) 
    If Position>0 
      A2=Val(Left(sDummy,Position-1)) 
      sDummy=Right(sDummy,Len(sDummy)-Position) 
      Position = FindString(sDummy, ".",1) 
      If Position>0 
        A3=Val(Left(sDummy,Position-1)) 
        sDummy=Right(sDummy,Len(sDummy)-Position) 
        A4=Val(sDummy) 
        dummy.l=0 
        PokeB(@dummy,a1) 
        PokeB(@dummy+1,A2) 
        PokeB(@dummy+2,A3) 
        PokeB(@dummy+3,A4) 
        ProcedureReturn dummy 
      EndIf 
    EndIf 
  EndIf 
EndProcedure 

Procedure Ping(strAdd.s) 
  #PING_TIMEOUT = 1000 
  lngHPort.l 
  lngDAddress.l 
  strMessage.s 
  lngResult.l 
  ECHO.ICMP_ECHO_REPLY 
  
  PacketCount=0 
  LostPackets=0 
  RecdPackets=0 
  PingResult(0)=0 
  
  strMessage.s = "Echo This Information Back To Me" 
  MsgLen = Len(strMessage) 
  message.s="Pinging "+CheckOut 
  If Asc(Mid(strAdd,1,1)) < 48 Or Asc(Mid(strAdd,1,1)) > 57 
    ; This is a URL instead of an IP Address, eg. www.google.com 
    GetIPbyName(strAdd)                 ; Get the IP Address for the URL 
    If Asc(Mid(TheIPAddress,1,1)) < 58  ; If successful, convert to numeric 
      lngDAddress = lngNewAddress(TheIPAddress) 
      message.s= message + " ["+TheIPAddress+"] with " 
    EndIf    
  Else 
    ; This is an IP Address in a string 
    TheIPAddress = strAdd 
    lngDAddress = lngNewAddress(strAdd) ; Convert to a numeric 
    message.s = message + " with " 
  EndIf    
  If TheIPAddress = "The Network can't be initialized." 
    message = message + Chr(10) + Chr(10) + TheIPAddress 
  ElseIf TheIPAddress = "A non-IP address was returned." 
    message = message + Chr(10) + Chr(10) + TheIPAddress 
  ElseIf TheIPAddress = "Unable to resolve domain name" 
    message = message + Chr(10) + Chr(10) + TheIPAddress 
  Else  
  lngHPort = IcmpCreateFile_() 

  message = message + Str(MsgLen)+" bytes of data:"+Chr(10)+Chr(10) 
  *buffer=AllocateMemory(SizeOf(ICMP_ECHO_REPLY)+MsgLen) 
  For i = 1 To 4 
    PacketCount+1 
    lngResult = IcmpSendEcho_(lngHPort, lngDAddress, @strMessage, MsgLen , #Null,*buffer, SizeOf(ICMP_ECHO_REPLY)+MsgLen,#PING_TIMEOUT) 

    If lngResult = 0 
      message=message + "Reply from "+TheIPAddress+":  " 
      message= message + "Error no: "+ StrQ(GetLastError_()) + Chr(10) 
      PingResult(i) = -1 
      LostPackets+1 
    Else 
      CopyMemory(*buffer,@ECHO,SizeOf(ICMP_ECHO_REPLY)) 
      PingResult(i) = ECHO\RoundTripTime 
      bytes(i) = ECHO\DataSize 
      ttls(i) =  ECHO\Options 
      RemoteIP.s = IPString(ECHO\Address) 
      message=message + "Reply from "+RemoteIP+":  bytes = "+Str(bytes(i))+" time = "+Str(PingResult(i))+"ms TTL = "+StrU(ttls(i),#Byte)+Chr(10) 
      RecdPackets+1 
      SuccessTrip+1 
    EndIf 
    Delay(100) 
  Next 
  FreeMemory(*buffer) 
  message=message + Chr(10) + "Ping statistics for "+CheckOut+":"+Chr(10) 
  message=message + "   Packets: Sent = " + Str(PacketCount) 
  message=message + ", Received = " + Str(RecdPackets) 
  message=message + ", Lost = " + Str(LostPackets) 
  If LostPackets = 0 
    LostPercent = 0 
  Else 
    LostPercent = (LostPackets/PacketCount)*100 
  EndIf 
  message=message + " ("+StrF(LostPercent,0)+"% loss)"+Chr(10)+Chr(10) 
  PingResult(5)=255 
  PingResult(6)=0 
  For i = 1 To 4 
    If PingResult(i)> 0 
      PingResult(6) = Maximum(PingResult(6),PingResult(i)) 
      PingResult(5) = Minimum(PingResult(5),PingResult(i)) 
      PingResult(0)+PingResult(i) 
    EndIf 
  Next 
  MinTrip = PingResult(5) 
  MaxTrip = PingResult(6) 
  If RecdPackets 
    AvgTrip = PingResult(0)/RecdPackets 
  Else 
    AvgTrip = PingResult(6) 
  EndIf 
  If AvgTrip > 0 
    message=message + "Approximate round trip times in milli-seconds:"+Chr(10) 
    message=message + "    Minimum = "+Str(MinTrip)+"ms,  Maximum = "+Str(MaxTrip)+",  Average = "+StrF(AvgTrip,2)+"ms" 
  EndIf 
  lngResult = IcmpCloseHandle_(lngHPort) 
  ProcedureReturn PingResult 
EndIf 
EndProcedure 

Procedure.s GetIPbyName(NameIP.s) 
  TheIPAddress.s 
    pHostinfo = gethostbyname_(NameIP) 
    If pHostinfo = 0 
      TheIPAddress = "Unable to resolve domain name" 
     Else 
      CopyMemory (pHostinfo, hostinfo.HOSTENT, SizeOf(HOSTENT)) 
      If hostinfo\h_addrtype <> #AF_INET 
        TheIPAddress = "A non-IP address was returned." 
      Else 
        While PeekL(hostinfo\h_addr_list+AdressNumber*4) 
          ipAddress = PeekL(hostinfo\h_addr_list+AdressNumber*4) 
          TheIPAddress = StrU(PeekB(ipAddress),0)+"."+StrU(PeekB(ipAddress+1),0)+"."+StrU(PeekB(ipAddress+2),0)+"."+StrU(PeekB(ipAddress+3),0) 
          AdressNumber+1 
        Wend 
      EndIf 
    EndIf 
  ProcedureReturn TheIPAddress 
EndProcedure 

Procedure.w Minimum(a.w,b1.w) 
  If a < b1 
    c1.w = a 
  Else 
    c1.w = b1 
  EndIf 
  ProcedureReturn c1 
EndProcedure 

Procedure.w Maximum(a.w,b1.w) 
  If a > b1 
    c1 = a 
  Else 
    c1 = b1 
  EndIf 
  ProcedureReturn c1 
EndProcedure 

Procedure GoDoIt(CheckStr.s) 
  CheckOut = GetGadgetText(2) 
  CheckOut = RemoveString(CheckOut, "http://") 
  CheckOut = RemoveString(CheckOut, "ftp://") 
  If Len(CheckOut)  
    Ping(CheckOut) 
  Else 
    CheckOut.s = GetGadgetText(4) 
    Ping(CheckOut) 
  EndIf    
  MessageRequester("PING2", message, #MB_ICONINFORMATION) 
  ;SetGadgetText(2,"") 
  ;SetGadgetText(4,"") 
  SetActiveGadget(2) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
