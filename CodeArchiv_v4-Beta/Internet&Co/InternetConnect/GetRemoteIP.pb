; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7197&highlight=
; Author: AngelSoul (updated for PB4.00 by blbltheworm)
; Date: 13. August 2003
; OS: Windows
; Demo: No

; GetpeerName_ will get the remote IP.
; GetsockName_ will get the local IP it was connected on.
;-----------------------------------------

If InitNetwork()=0:MessageRequester("Error","Can't initialize the network",0):EndIf
If CreateNetworkServer(1,8181)=0:MessageRequester("Error","can't bind to port 8181",0):End:EndIf

Repeat
  nn=NetworkServerEvent()
  If nn=1 ;someone connected to your computer
    cnid=EventClient() ;get connection ID
    
    Structure IPType
      Reserved.w
      Port.w
      StructureUnion
      IPLong.l
      IP.b[4]
    EndStructureUnion
      Zeros.l[2]
    EndStructure
    length.l = SizeOf(IPType)
    
    ;Get RemoteIP with API
    ;result.l = GetpeerName_(ConnectionID(cnid), @IP.IPType, @length)
    ;If result=0
    ;  remoteip$ = StrU(IP\IP[0],#Byte)+"."+StrU(IP\IP[1], #Byte)+"."
    ;  remoteip$ + StrU(IP\IP[2],#Byte)+"."+StrU(IP\IP[3], #Byte) ;+":"+StrU(IP\Port,#Word) ;remote port
    ;Else
    ;  result = WSAGetLastError_()
    ;EndIf
    
    remoteip$=IPString(GetClientIP(cnid)) ; <- Get RemotIP with PB
    
    result.l = getsockname_(ConnectionID(cnid), @IP.IPType, @length)
    If result=0
      localip$ = StrU(IP\IP[0],#Byte)+"."+StrU(IP\IP[1], #Byte)+"."
      localip$ + StrU(IP\IP[2],#Byte)+"."+StrU(IP\IP[3], #Byte) ;+":"+StrU(IP\Port,#Word) ;local port
    Else
      result = WSAGetLastError_()
    EndIf
    Debug remoteip$+" connected to your computer ("+localip$+")"
    
  EndIf
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
