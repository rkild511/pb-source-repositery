; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14280&highlight=
; Author: olejr (updated for PB 4.00 by Andre)
; Date: 07. March 2005
; OS: Windows, Linux
; Demo: No


; Note: With PB v4 there is a native GetClientIP() command available now, so I've
;       renamed this procedure to MyGetClientIP().


; This one work with windows & linux: 
Procedure.s MyGetClientIP(ClientID) 
  Structure IPType 
   Reserved.w 
   Port.w 
   StructureUnion 
    IPLong.l 
    IP.b[4] 
   EndStructureUnion 
   Zeros.l[2] 
  EndStructure 
  
  s = SizeOf(IPType) 
  
  res = getpeername_(ClientID, @IP.IPType, @s) 
  If res = 0 
   remotip$ = StrU(IP\IP[0], #Byte)+"."+StrU(IP\IP[1],#Byte)+"."+StrU(IP\IP[2], #Byte)+"."+StrU(IP\IP[3], #Byte) 
  Else 
   remotip$ = "" 
  EndIf 

  ProcedureReturn remotip$ 

EndProcedure


If InitNetwork() 
  If CreateNetworkServer(0, 8181) = 0 
    MessageRequester("Error", "Can't Create Server", 0) 
    End 
  EndIf 

  Repeat 

   event = NetworkServerEvent() 
    
   If event = 1 ; Someone connected 
    Debug MyGetClientIP(EventClient()); Here you go 
   EndIf 
  ForEver 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -