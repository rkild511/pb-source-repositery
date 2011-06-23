; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13520
; Author: HeX0R
; Date: 28. December 2004
; OS: Windows
; Demo: No


; http, SOCKS4,5 - Proxy-Connection
; ---------------------------------
; The user / pass - authorization is untested, cause it's really difficult 
; to find such proxys.
; User comment: "Invaluable for networking apps where you may need to connect 
;                via a user defined proxy like an IRC client...."


;+----------------------------------+ 
; Proxy_Connect 
; 
; (c)HeX0R 2004 
; 
; Procedure for giving your online-applications the 
; possibility to connect through different proxys 
; like http, socks4 and socks5. 
; 
; NOT meant for connecting to websites! 
; For this check Num3's example here: 
; http://purebasic.myforums.net/viewtopic.php?t=10327 
; 
;+----------------------------------+ 

InitNetwork() 

Procedure.l IsIP( ip.s ) 
  ;ReturnValues : 
  ;0 = no ip 
  ;1 = IPv4 - IP 
  ;2 = IPv6 - IP 
  count.l = CountString(ip, ".") 
  If count = 3 
    ret.l = 1 
  ElseIf count = 5 
    ret.l = 2 
  Else 
    ProcedureReturn 0 
  EndIf 
  For i = 0 To count 
    a$ = StringField(ip, i + 1, ".") 
    If a$ = "" Or Str(Val(a$)) <> a$ Or Val(a$) > 255 Or Val(a$) < 0 
      ProcedureReturn 0 
    EndIf 
  Next i 
  ProcedureReturn ret 
EndProcedure 

Procedure.l Proxy_Connect( proxy_ip.s, proxy_port.l, ip_to_connect.s, port_to_connect.l, type.l, username.s, userpass.s, timeout.l ) 
  ;proxy_ip        = IP or URL of the Proxy-Server 
  ;proxy_port      = Port of the Proxy-Server 
  ;ip_to_connect   = IP or URL of where you want to connect through proxy. ATTENTION: 
  ;  SOCKS4 only supports IP in IPv4-format! You have to get the IP first before using this on urls, otherwise it will fail! 
  ;port_to_connect = Port of where you want to connect through proxy 
  ;type            = 0 -> http-proxy 
  ;type            = 1 -> socks4-proxy 
  ;type            = 2 -> socks5-proxy 
  ;If no authorization is needed set username and userpass = "" 
  ;timeout         -> Time after connection-trial will time out (in SECONDS) 
  ;Return-Value    = 0 -> error ; Return-Value > 0 -> ConnectionID 
  
  *buffer = AllocateMemory(1024) 
  If *buffer = 0 
    ProcedureReturn #False 
  EndIf 
  
  netid.l = OpenNetworkConnection(proxy_ip, proxy_port) 
  
  If netid = 0 
    FreeMemory(*buffer) 
    ProcedureReturn #False 
  EndIf 

  Select type 
  
    Case 0 
      ;==================== 
      ;-HTTP - Proxy 
      ;==================== 
      ;Based on Num3's http-proxy-snippet , THX! -> 
      ;http://purebasic.myforums.net/viewtopic.php?t=10327 
      
      text$ = "CONNECT " + ip_to_connect + ":" + Str(port_to_connect) + " HTTP/1.0" + #CRLF$ 
      
      If username And userpass 
        user$ = username + ":" + userpass 
        length.l = Len(user$) * 2 
        If length < 64 
          length = 64 
        EndIf 
        Base64Encoder(@user$, Len(user$), *buffer, length) 
        encoded$ = PeekS(*buffer) 
        text$ + "Authorization: Basic " + encoded$ + #CRLF$ 
        text$ + "Proxy-Authorization: Basic " + encoded$ + #CRLF$ 
      EndIf 
      text$ + #CRLF$ 

      SendNetworkData(netid, @text$, Len(text$)) 
      check_timeout.l = ElapsedMilliseconds() + ( timeout * 1000 ) 
      Repeat 
        Delay(10) 
        If NetworkClientEvent(netid) = 2 
          Content$ = Space(14500) 
          length.l = ReceiveNetworkData(netid, @Content$, 14500) 
          While length = 14500 
            ;Clear Input-Buffer 
            length = ReceiveNetworkData(netid, *buffer, 14500) 
          Wend 
          Break 
        EndIf 
      Until check_timeout < ElapsedMilliseconds() 
      Result.l = 0 
      For i = 1 To CountString(Content$, Chr(10)) 
        a$ = Trim(StringField(Content$, i, Chr(10))) 
        If Left(a$, 7) = "HTTP/1." 
          Result = Val(StringField(Content$, 2, Chr(32))) 
          Break 
        EndIf 
      Next i 
      If check_timeout < ElapsedMilliseconds() Or Result <> 200 
        FreeMemory(*buffer) 
        CloseNetworkConnection(netid) 
        ProcedureReturn #False 
      EndIf 
      FreeMemory(*buffer) 
      ProcedureReturn netid 

    Case 1 
      ;==================== 
      ;-Socks4 - Proxy 
      ;==================== 
      
      ;Socks4 only supports IPv4 ! 
      ;You have to do a DNS-Lookup before using this on urls, otherwise it will fail! 
      If IsIP(ip_to_connect) <> 1 
        FreeMemory(*buffer) 
        CloseNetworkConnection(netid) 
        ProcedureReturn #False 
      EndIf 
      ;-Phase 1 SOCK4 
      ;Send Request 
      PokeB(*buffer, 4) 
      PokeB(*buffer + 1, 1) 
      hi.l = Int(port_to_connect / 256) 
      lo.l = port_to_connect - (256 * hi) 
      PokeB(*buffer + 2, hi) 
      PokeB(*buffer + 3, lo) 
      For i = 1 To 4 
        PokeB(*buffer + 3 + i, Val(StringField(ip_to_connect, i, ".")) & 255) 
      Next i 
      PokeS(*buffer + 8, username) 
      length.l = 9 + Len(username) 
      SendNetworkData(netid, *buffer, length) 
      ;Check if connection is established 
      check_timeout.l = ElapsedMilliseconds() + ( timeout * 1000 ) 
      Repeat 
        Delay(10) 
        If NetworkClientEvent(netid) = 2 
          ReceiveNetworkData(netid, *buffer, 1024) 
          ver.l = PeekB(*buffer) & 255 
          CD.l = PeekB(*buffer + 1) & 255 
          port.l = (PeekB(*buffer + 2) & 255) * 256 
          port + (PeekB(*buffer + 3) & 255) 
          ip.s = Str(PeekB(*buffer + 4) & 255) + "." + Str(PeekB(*buffer + 5) & 255) + "." 
          ip + Str(PeekB(*buffer + 6) & 255) + "." + Str(PeekB(*buffer + 7) & 255) 
          Break 
        EndIf 
      Until check_timeout < ElapsedMilliseconds() 
      If check_timeout < ElapsedMilliseconds() Or ver <> 0 Or CD <> 90 
        FreeMemory(*buffer) 
        CloseNetworkConnection(netid) 
        ProcedureReturn #False 
      EndIf 
      ;IP and Port should be the same like ip_to_connect/port_to_connect and is just for information 
      Debug "Connected to IP:" + ip 
      Debug "Connected to Port:" + Str(port) 
      FreeMemory(*buffer) 
      ProcedureReturn netid 
      
    Case 2 
      ;==================== 
      ;-Socks5 - Proxy 
      ;==================== 

      ;-Phase 1 SOCK5 
      ;Send wished method 
      If username = "" And userpass = "" 
        length.l = 3 
        PokeB(*buffer, 5) 
        PokeB(*buffer + 1, 1) 
        PokeB(*buffer + 2, 0) 
      Else 
        length.l = 4 
        PokeB(*buffer, 5) 
        PokeB(*buffer + 1, 2) 
        PokeB(*buffer + 2, 0) 
        PokeB(*buffer + 3, 2) 
      EndIf 
      SendNetworkData(netid, *buffer, length) 
      ;Check if method is allowed 
      check_timeout.l = ElapsedMilliseconds() + ( timeout * 1000 ) 
      Repeat 
        Delay(10) 
        If NetworkClientEvent(netid) = 2 
          ReceiveNetworkData(netid, *buffer, 2) 
          ver.l = PeekB(*buffer) & 255 
          method.l = PeekB(*buffer + 1) & 255 
          Break 
        EndIf 
      Until check_timeout < ElapsedMilliseconds() 
      If check_timeout < ElapsedMilliseconds() Or ver <> 5 Or method = 255 
        FreeMemory(*buffer) 
        CloseNetworkConnection(netid) 
        ProcedureReturn #False 
      EndIf 
      If method = 2 
        ;-Phase 2 SOCK5 
        ;Send Username/Password (if allowed) 
        PokeB(*buffer, 1) 
        PokeB(*buffer + 1, Len(username)) 
        PokeS(*buffer + 2, username) 
        k = 2 + Len(username) 
        PokeB(*buffer + k, Len(userpass)) 
        PokeS(*buffer + k + 1, userpass) 
        SendNetworkData(netid, *buffer, Len(userpass) + 1 + k) 
        ;Check if Username/Password is accepted 
        check_timeout.l = ElapsedMilliseconds() + ( timeout * 1000 ) 
        Repeat 
          Delay(10) 
          If NetworkClientEvent(netid) = 2 
            ReceiveNetworkData(netid, *buffer, 2) 
            passver.l = PeekB(*buffer) & 255 
            status.l = PeekB(*buffer + 1) & 255 
            Break 
          EndIf 
        Until check_timeout < ElapsedMilliseconds() 
        If check_timeout < ElapsedMilliseconds() Or passver <> 1 Or status <> 0 
          FreeMemory(*buffer) 
          CloseNetworkConnection(netid) 
          ProcedureReturn #False 
        EndIf 
      EndIf 
      ;-Phase 3 SOCK5 
      ;Send Connect-Request 
      PokeB(*buffer, 5) 
      PokeB(*buffer + 1, 1) 
      PokeB(*buffer + 2, 0) 
      Select IsIP( ip_to_connect ) 
        Case 0 
          PokeB(*buffer + 3, 3) 
          PokeB(*buffer + 4, Len(ip_to_connect)) 
          For i = 1 To Len(ip_to_connect) 
            PokeB(*buffer + 4 + i, Asc(Mid(ip_to_connect, i, 1))) 
          Next i 
          cont.l = 4 + i 
        Case 1 
          PokeB(*buffer + 3, 1) 
          For i = 1 To 4 
            PokeB(*buffer + 3 + i, Val(StringField(ip_to_connect, i, ".")) & 255) 
          Next i 
          cont.l = 8 
        Case 2 
          PokeB(*buffer + 3, 4) 
          For i = 1 To 6 
            PokeB(*buffer + 3 + i, Val(StringField(ip_to_connect, i, ".")) & 255) 
          Next i 
          cont.l = 10 
      EndSelect 
      hi.l = Int(port_to_connect / 256) 
      lo.l = port_to_connect - (256 * hi) 
      PokeB(*buffer + cont, hi) 
      PokeB(*buffer + cont + 1, lo) 
      SendNetworkData(netid, *buffer, cont + 2) 
      ;Now Check the reply 
      check_timeout.l = ElapsedMilliseconds() + ( timeout * 1000 ) 
      Repeat 
        Delay(10) 
        If NetworkClientEvent(netid) = 2 
          length.l = ReceiveNetworkData(netid, *buffer, 1024) 
          ver.l = PeekB(*buffer) & 255 
          reply.l = PeekB(*buffer + 1) & 255 
          reserved.l = PeekB(*buffer + 2) & 255 
          atyp.l = PeekB(*buffer + 3) & 255 
          Break 
        EndIf 
      Until check_timeout < ElapsedMilliseconds() 
      If check_timeout < ElapsedMilliseconds() Or ver <> 5 Or reply <> 0 Or reserved <> 0 
        FreeMemory(*buffer) 
        CloseNetworkConnection(netid) 
        ProcedureReturn #False 
      EndIf 
      Select atyp 
        Case 1 
          ;IPv4 
          ip.s = Str(PeekB(*buffer + 4) & 255) + "." + Str(PeekB(*buffer + 5) & 255) + "." 
          ip + Str(PeekB(*buffer + 6) & 255) + "." + Str(PeekB(*buffer + 7) & 255) 
          port.l = (PeekB(*buffer + 8) & 255) * 256 
          port + (PeekB(*buffer + 9) & 255) 
        Case 3 
          ;Name 
          ip.s = "" 
          For i = 1 To (PeekB(*buffer + 4) & 255) 
            ip + Chr(PeekB(*buffer + 4 + i) & 255) 
          Next i 
          port.l = (PeekB(*buffer + 4 + i) & 255) * 256 
          port + (PeekB(*buffer + 5 + i) & 255) 
        Case 4 
          ;IPv6 
          ip.s = Str(PeekB(*buffer + 4) & 255) + "." + Str(PeekB(*buffer + 5) & 255) + "." 
          ip + Str(PeekB(*buffer + 6) & 255) + "." + Str(PeekB(*buffer + 7) & 255)  + "." 
          ip + Str(PeekB(*buffer + 8) & 255) + "." + Str(PeekB(*buffer + 9) & 255) 
          port.l = (PeekB(*buffer + 10) & 255) * 256 
          port + (PeekB(*buffer + 11) & 255) 
      EndSelect 
      ;Following IP and Port is just for information... 
      ;this is proxy-internal and not necessarily the same as ip_to_connect/port_to_connect 
      Debug "Internal Proxy-IP:" + ip 
      Debug "Internal Proxy-Port:" + Str(port) 
      FreeMemory(*buffer) 
      ProcedureReturn netid 

  EndSelect 

EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -