; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7829&highlight=
; Author: blueznl (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 09. October 2003
; OS: Windows
; Demo: No

IncludeFile "x_lib.pb"
  
Procedure ws_044x_031008EJN()
  ;
  ; *** winsock procedures
  ;
  ; version history
  ; ---------------
  ; 
  ; ws044:
  ;
  ; - conversion to purebasic
  ; - i don't think i will ever use this as enough functionality appears to be built into
  ;   the standard command set of purebasic... but it's a good excercise :-)
  ; - removed most of the procedures and used the dll calls directly...
  ; - moved away from global vars
  ;
  ; ws042:
  ; 
  ; - turning sample into real library
  ; - changed constant naming scheme (removed ws_)
  ; - due to gfa implementation of structs the naming scheme there is NOT matching the one in c
  ; 
  ; ws037:
  ; 
  ; - variable types now match calls (using ws_retval& and ws_retval%)
  ; - samples for structures as well as strings
  ; 
  ;  credits and thanks
  ;  ------------------
  ; 
  ;  - Russell Hayward for helping me out with C++ conversions
  ;  - Roland Walter for his POP3 example
  ;
EndProcedure

Procedure ws_init()
  Global ws_retval.l
  ;
  ; *** intitialise winsock dll and set constants
  ;
  ; in:        none
  ; out:       ws_winsock_h<>0           dll loaded
  ;
  ; *** this is not a complete declaration of winsock.dl, see winsock.h for more details
  ;      multiple functions and values are commented out to save space and time
  ;      not everything is implemented or tested yet... have fun :-)
  ;
  ; *** declare and load winsock library
  ;
  ; in pure this will be done automatically on the first call to a function from this dll
  ; so there's no need to open the wsock32.dll...
  ;
  Global ws_winsock_pbh.l , ws_winsock_h.l
  ws_winsock_pbh = x_pbh()                                  ; purebasic has its own handles
  ws_winsock_h = OpenLibrary(ws_winsock_pbh,"WSOCK32.DLL")  ; load the DLL and get back the DLL handle
  ;
  ; note that i have used regular uppercase c-like declarations for constants
  ; structs, however, have an inconsistent naming scheme!
  ;
  #SOCK_STREAM = 1                ; stream socket
  #SOCK_DGRAM = 2                 ; datagram socket
  #SOCK_RAW = 3                   ; raw-protocol interface
  #SOCK_RDM = 4                   ; reliably-delivered message
  #SOCK_SEQPACKET = 5             ; sequenced packet stream
  ;
  ; *** address / protocol families:
  ;     (AF and PF are differently named but have the same valus)
  ;
  #AF_INET = 2                    ; internetwork: UDP, TCP, etc.
  #PF_INET = #AF_INET             
  ;
  ;   AF_UNSPEC = 0               ; unspecified
  ;   AF_UNIX = 1                 ; local to host (pipes, portals)
  ;   AF_IMPLINK = 3              ; arpanet imp addresses
  ;   AF_PUP = 4                  ; pup protocols: e.g. BSP
  ;   AF_CHAOS = 5                ; mit CHAOS protocols
  ;   AF_NS = 6                   ; XEROX NS protocols
  ;   AF_ISO = 7                  ; ISO protocols
  ;   AF_OSI = AF_ISO             ; OSI is ISO
  ;   AF_ECMA = 8                 ; european computer manufacturers
  ;   AF_DATAKIT = 9              ; datakit protocols
  ;   AF_CCITT = 10               ; CCITT protocols, X.25 etc
  ;   AF_SNA = 11                 ; IBM SNA
  ;   AF_DECnet = 12              ; DECnet
  ;   AF_DLI = 13                 ; Direct data link interface
  ;   AF_LAT = 14                 ; LAT
  ;   AF_HYLINK = 15              ; NSC Hyperchannel
  ;   AF_APPLETALK = 16           ; AppleTalk
  ;   AF_NETBIOS = 17             ; NetBios-style addresses
  ;   AF_MAX = 18
  ;
  ; *** protocols:
  ;
  #IPPROTO_TCP = 6                ; tcp
  #IPPROTO_RAW = 255              ; raw IP packet
  ;
  ;   IPPROTO_IP = 0              ; dummy for IP
  ;   IPPROTO_ICMP = 1            ; control message protocol
  ;   IPPROTO_GGP = 2             ; gateway^2 (deprecated)
  ;   IPPROTO_PUP = 12            ; pup
  ;   IPPROTO_UDP = 17            ; user datagram protocol
  ;   IPPROTO_IDP = 22            ; xns idp
  ;   IPPROTO_ND = 77             ; UNOFFICIAL net disk proto
  ;   IPPROTO_MAX = 256           ; ?
  ;
  ; *** ioctlsocket
  ;     (couldn't get this call to work, use wsaasyncselect instead)
  ;
  #FIONREAD=1074030207        ; enable / disable non blocking mode 
  ;
  ; FIONBIO%=2147772030       ; determine amount of data that can be read
  ; FIONBIO_NONBLOCK%=1       ; use as parameter to switch to non blocking
  ; FIONBIO_BLOCKING%=0       ; use as parameter to siwtch to blocking
  ; FIOASYNC%=125             ; ? not implemented in winsock under windows
  ;
  ; *** setsockopt
  ;
  #SOL_SOCKET = $FFFF             
  #SO_KEEPALIVE = $8            ; send keepalive messages
  #SO_LINGER = $80              ; linger on close if unsent data is present
  #TCP_NODELAY = $1            ; disable nagle algorithm
  ;
  ; SO_DONTLINGER               ; don't block close() waiting for unsent data to be sent
  ; SO_BROADCAST                ; allow transmission of broadcast messages on the socket
  ; SO_DEBUG	                  ; record debugging information
  ;                             ; (equivalent to setting SO_LINGER with l_onoff = zero)
  ; SO_DONTROUTE                ; don't route: send directly to interface
  ; SO_OOBINLINE                ; receive out of band data in the normal data stream
  ; SO_RCVBUF	                  ; buffer size for receives
  ; SO_REUSEADDR                ; allow bind to reuse an address
  ; SO_SNDBUF                   ; specify send buffer size
  ; 
  ; *** wsaasyncselect
  ;     parameters for notification
  ;
  #FD_READ = 1                            ; readiness for reading
  #FD_WRITE = 2                           ; readiness for writing
  #FD_OOB = 4                             ; arrival of out of band data
  #FD_ACCEPT = 8                          ; incoming connects
  #FD_CONNECT = 16                        ; completed connections
  #FD_CLOSE = 32                          ; socket closure
  #FD_QOS = 64                            ; qos changes
  #FD_GROUP_QOS = 128                     ; qos changes
  #FD_ROUTING_INTERFACE_CHANGE = 256      ; ?
  #FD_ADDRESS_LIST_CHANGE = 512           ; ?
  #FD_ALL_EVENTS = 1024                   ; all events
  ;
  ; *** send / recv
  ;
  #MSG_OOB = $1                           ; process out of band data
  #MSG_PEEK = $2                          ; peek at incoming messages
  #MSG_DONTROUTE = $4                     ; send without using routing tables
  #MSG_PARTIAL = $8000                    ; ?
  ;
  ; *** select
  ;
  Structure ws_timeval
    ws_seconds.l
    ws_microseconds.l
  EndStructure
  ;
  ; *** standard port numbers
  ;
  #WS_POP3 = 110                          ; pop3 port 110
  #WS_SMTP = 25                           ; smtp port 25
  #WS_HTTP = 80                           ; http port 80
  #WS_FTP = 21                            ; ftp port 21
  ;
  ; *** structures
  ;
  ; ws_wsadata: struct used for socket initialization
  ;
  Structure ws_wsadata
    ws_wversion.w                         ; +0
    ws_whighversion.w                     ; +2
    ws_description.b[257]                 ; +4
    ws_systemstatus.b[129]                ; +261
    ws_imaxsockets.w                      ; +390
    ws_imaxudpdg.w                        ; +392
    ws_vendorinfo.l                       ; +394
  EndStructure                            ; total 398 bytes
  ;
  ; ws_sockaddr: struct used to store socket information and addresses
  ;
  Structure ws_sockaddr
    ws_in_family.w                      ; +0
    ws_in_port.w                        ; +2
    ws_in_addr.l                        ; +4
    ws_in_zero.b[8]                     ; +8
  EndStructure                          ; total 16 bytes
  ;
  ; ws_hostent: used for looking up names
  ;
  Structure ws_hostent
    ws_he_ptrname.l            ; +0  pointer to the official name of the host (pc)
    ws_he_ptralias.l           ; +4  pointer to a null-terminated array of alternate names
    ws_he_waddrType.w          ; +8  type of address being returned (windows sockets always PF_INET)
    ws_he_wlen.w               ; +10 length, in bytes, of each address (for PF_INET, this is always 4)
    ws_he_ptrList.l            ; +12 pointer to a null-terminated list of addresses for the host (addresses in network byte order)
  EndStructure                 ; total 16 bytes
  ;
  ; ws_fd_set: used for the select command, can be used for checking multiple sockets for some winsock commands
  ;   
  ;   this is a struct with a variable length, can't do that in pure
  ;   let's stick to a max of 16... i will basically only use one anyway :-)
  ;
  ;   +0  - word        number of entries in the set
  ;   +2  - word        socketnr. #1
  ;   +4  - word        socketnr. #2
  ;   +6  - ...         etc.
  ;
  Structure ws_fd_set
    ws_fd_number.w      ; number of entries in the set
    ws_fd_socket.w[16]  ; one word per socket    
  EndStructure
  ;
  ; *** error codes (1) used
  ;
  ; uncomment what you need
  ;
  ; regular microsoft c error constants
  ;
  #WSABASEERR = 10000
  #WSAEINTR = #WSABASEERR+4
  #WSAEWOULDBLOCK = #WSABASEERR+35
  ;
  ; winsock equivalents or berkeley constants
  ;
  #WSAENOTSOCK = #WSABASEERR + 38
  ;
  ; *** error codes (2) not (yet) used or converted to gfa / pure
  ;
  ; regular microsoft c error constants
  ;
  ; #define WSAEBADF                (WSABASEERR+9)
  ; #define WSAEACCES               (WSABASEERR+13)
  ; #define WSAEFAULT               (WSABASEERR+14)
  ; #define WSAEINVAL               (WSABASEERR+22)
  ; #define WSAEMFILE               (WSABASEERR+24)
  ;
  ; winsock equivalents or berkeley constants
  ;
  ; #define WSAEINPROGRESS          (WSABASEERR+36)
  ; #define WSAEALREADY             (WSABASEERR+37)
  ; #define WSAEDESTADDRREQ         (WSABASEERR+39)
  ; #define WSAEMSGSIZE             (WSABASEERR+40)
  ; #define WSAEPROTOTYPE           (WSABASEERR+41)
  ; #define WSAENOPROTOOPT          (WSABASEERR+42)
  ; #define WSAEPROTONOSUPPORT      (WSABASEERR+43)
  ; #define WSAESOCKTNOSUPPORT      (WSABASEERR+44)
  ; #define WSAEOPNOTSUPP           (WSABASEERR+45)
  ; #define WSAEPFNOSUPPORT         (WSABASEERR+46)
  ; #define WSAEAFNOSUPPORT         (WSABASEERR+47)
  ; #define WSAEADDRINUSE           (WSABASEERR+48)
  ; #define WSAEADDRNOTAVAIL        (WSABASEERR+49)
  ; #define WSAENETDOWN             (WSABASEERR+50)
  ; #define WSAENETUNREACH          (WSABASEERR+51)
  ; #define WSAENETRESET            (WSABASEERR+52)
  ; #define WSAECONNABORTED         (WSABASEERR+53)
  ; #define WSAECONNRESET           (WSABASEERR+54)
  ; #define WSAENOBUFS              (WSABASEERR+55)
  ; #define WSAEISCONN              (WSABASEERR+56)
  ; #define WSAENOTCONN             (WSABASEERR+57)
  ; #define WSAESHUTDOWN            (WSABASEERR+58)
  ; #define WSAETOOMANYREFS         (WSABASEERR+59)
  ; #define WSAETIMEDOUT            (WSABASEERR+60)
  ; #define WSAECONNREFUSED         (WSABASEERR+61)
  ; #define WSAELOOP                (WSABASEERR+62)
  ; #define WSAENAMETOOLONG         (WSABASEERR+63)
  ; #define WSAEHOSTDOWN            (WSABASEERR+64)
  ; #define WSAEHOSTUNREACH         (WSABASEERR+65)
  ; #define WSAENOTEMPTY            (WSABASEERR+66)
  ; #define WSAEPROCLIM             (WSABASEERR+67)
  ; #define WSAEUSERS               (WSABASEERR+68)
  ; #define WSAEDQUOT               (WSABASEERR+69)
  ; #define WSAESTALE               (WSABASEERR+70)
  ; #define WSAEREMOTE              (WSABASEERR+71)
  ;
  ; extended windows sockets errors
  ;
  ; #define WSASYSNOTREADY          (WSABASEERR+91)
  ; #define WSAVERNOTSUPPORTED      (WSABASEERR+92)
  ; #define WSANOTINITIALISED       (WSABASEERR+93)
  ; #define WSAEDISCON              (WSABASEERR+101)
  ; #define WSAENOMORE              (WSABASEERR+102)
  ; #define WSAECANCELLED           (WSABASEERR+103)
  ; #define WSAEINVALIDPROCTABLE    (WSABASEERR+104)
  ; #define WSAEINVALIDPROVIDER     (WSABASEERR+105)
  ; #define WSAEPROVIDERFAILEDINIT  (WSABASEERR+106)
  ; #define WSASYSCALLFAILURE       (WSABASEERR+107)
  ; #define WSASERVICE_NOT_FOUND    (WSABASEERR+108)
  ; #define WSATYPE_NOT_FOUND       (WSABASEERR+109)
  ; #define WSA_E_NO_MORE           (WSABASEERR+110)
  ; #define WSA_E_CANCELLED         (WSABASEERR+111)
  ; #define WSAEREFUSED             (WSABASEERR+112)
  ;
  ; error return codes for gethostbyname() and gethostbyaddr()
  ;
  ; #define WSAHOST_NOT_FOUND       (WSABASEERR+1001)           ; host not found
  ; #define WSATRY_AGAIN            (WSABASEERR+1002)           ; host not found or server fail
  ; #define WSANO_RECOVERY          (WSABASEERR+1003)           ; non recoverable
  ; #define WSANO_DATA              (WSABASEERR+1004)           ; no data record of requested type
  ;
  ; QOS related error return codes
  ;
  ; #define  WSA_QOS_RECEIVERS               (WSABASEERR + 1005)        ; at least one reserve
  ; #define  WSA_QOS_SENDERS                 (WSABASEERR + 1006)        ; at least one path
  ; #define  WSA_QOS_NO_SENDERS              (WSABASEERR + 1007)        ; no senders
  ; #define  WSA_QOS_NO_RECEIVERS            (WSABASEERR + 1008)        ; no receivers
  ; #define  WSA_QOS_REQUEST_CONFIRMED       (WSABASEERR + 1009)        ; reserve confirmed
  ; #define  WSA_QOS_ADMISSION_FAILURE       (WSABASEERR + 1010)        ; not enough resources
  ; #define  WSA_QOS_POLICY_FAILURE          (WSABASEERR + 1011)        ; bad credentials
  ; #define  WSA_QOS_BAD_STYLE               (WSABASEERR + 1012)        ; unknown / conflicting style
  ; #define  WSA_QOS_BAD_OBJECT              (WSABASEERR + 1013)        ; filterspec or providerspec
  ; #define  WSA_QOS_TRAFFIC_CTRL_ERROR      (WSABASEERR + 1014)        ; flowspec
  ; #define  WSA_QOS_GENERIC_ERROR           (WSABASEERR + 1015)        ; general error
  ;    
  ; *** start winsock services
  ;
  ; winsock dll: wsastartup
  ;
  Global ws_wsastartup.ws_wsadata
  WSAStartup_($101,@ws_wsastartup)   
  ;  
EndProcedure

Procedure ws_end()
  ;
  WSACleanup_()                   ; clean up and deregister winsock stuff
  CloseLibrary(ws_winsock_pbh)    ; stop using the dll
  x_freepbh(ws_winsock_pbh)       ; and free the handle
  ;
EndProcedure

Procedure.s ws_biptoip(bip.l)
  ;
  ; convert binairy network order ip address to human readable dotted address
  ;
  ; in:   bip         binary network order ip address
  ; out:  return      string with dotted address
  ;
  ProcedureReturn(StrU(PeekB(@bip),#Byte)+"."+StrU(PeekB(@bip+1),#Byte)+"."+StrU(PeekB(@bip+2),#Byte)+"."+StrU(PeekB(@bip+3),#Byte))
  ;
EndProcedure

Procedure.s ws_biptoname(bip.l)
  Protected *retval
  ;
  ; *** find the name of a specific ip (reverse dns)
  ;
  *retval = gethostbyaddr_(@bip,4,#PF_INET)
  If *retval > 0
    ProcedureReturn PeekS(PeekL(*retval))
  Else
    ProcedureReturn ""
  EndIf
  ;
EndProcedure

Procedure.l ws_iptobip(ip.s)
  ;
  ; convert dotted ip address to binairy form
  ;
  ProcedureReturn inet_addr_(ip)
  ;
EndProcedure

Procedure.l ws_nametobip(name.s)
  Protected *retval
  ;
  ; *** find the bip of a specific server (dns lookup) and return it in binairy form
  ;
  *retval = gethostbyname_(@name)
  If *retval <> 0
    ;
    ProcedureReturn PeekL(PeekL(PeekL(*retval+12)))
    ;    
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure.s ws_nametoip(name.s)
  ProcedureReturn(ws_biptoip(ws_nametobip(name)))
EndProcedure

Procedure.s ws_iptoname(ip.s)
  ProcedureReturn(ws_biptoname(ws_iptobip(ip)))
EndProcedure

Procedure.s ws_hostname()
  Protected name.s , retval.l
  ;
  ; *** find the name of this computer
  ;
  name = Space(30)
  retval = gethostname_(@name,30)
  If retval<>0
    name=""
  EndIf
  ProcedureReturn name
EndProcedure

Procedure ws_sample()
  ;
  x_init()                                                ; some general stuff
  ws_init()                                               ; load dll and start winsock
  ;
  InitKeyboard()                                          ; to enable keyboard commands and constants
  OpenConsole()                                           ; console for input / output
  ;
  host_name.s = ws_hostname()                             ; get hostname
  host_ip.s = ws_nametoip(host_name)
  ;
  PrintN("this is "+host_name+" at "+host_ip)
  ;
  Repeat
    PrintN("[c] client [s] server [x] exit")
    Repeat
      choice.s = x_waitkey()
      If choice = Chr(27)
        choice = "X"
      EndIf
    Until choice>""
    Select choice
      Case "S"
        ;
        ; open socket for tcp/ip
        ;
        PrintN("")
        PrintN("SERVER")
        PrintN("")
        ;
        server_socket.l = SOCKET_(#AF_INET,#SOCK_STREAM,#IPPROTO_TCP)    
        PrintN("server socket "+Str(server_socket))
        ;
        server_port.l = 6000
        server_bport.l = htons_(server_port)                        ; port number to tcp/ip network byte order
        PrintN("server port "+Str(server_port))
        ;  
        ; bind a socket (reserve socket and port for exclusive use by the application)
        ;
        server_sockaddr.ws_sockaddr                                 ; create a struct
        server_sockaddr\ws_in_family = #AF_INET                     ; udp / tcp
        server_sockaddr\ws_in_port = server_bport                   ; port
        retval = bind_(server_socket,@server_sockaddr,16)           ; and bind it
        PrintN("bind "+Str(retval))
        ;
        ; set socket usage to nonblocking
        ;
        ; use either wsaasyncselect which allows windows event messages:
        ;
        ;   retval = WSAAsyncSelect_(socket,window_handle,message,#FD_READ|#FD_ACCEPT|#FD_CONNECT|#FD_CLOSE)
        ;
        ; or use ioctlsocket_():
        ;
        server_mode.l = 1                                            ; 1 = non-blocking, 0 = blocking
        retval = ioctlsocket_(server_socket,#FIONBIO,@server_mode)  ; 0 = no error
        PrintN("set (non)blocking mode "+Str(retval))
        ;
        ; listen for incoming calls on bound port, set queue size (1..5, here 4)
        ;
        retval = listen_(server_socket,4)                
        PrintN("listen "+Str(retval))
        ;
        PrintN("waiting for clients (any key to abort)")
        ;
        Repeat
          ;
          ; accept incoming connections and assign them to new sockets
          ; this is a blocking function if not set to non-blocking
          ;
          ; if you don't care about the callers identity:
          ;
          ;   retval = accept_(server_socket,0,0)
          ;
          ; if you do care, you can retrieve some info from a struct:
          ;
          accept_sockaddr.ws_sockaddr                   ; structure for more info
          accept_sockaddr_l=16                          ; length of the structure
          accept_socket.l = accept_(server_socket,@accept_sockaddr,@accept_sockaddr_l)
          ;
          If accept_socket > 0
            ;
            ; there was a call and a socket was created to handle it
            ;
            PrintN("connection accepted on socket "+Str(accept_socket))
            caller_bip.l = accept_sockaddr\ws_in_addr
            caller_ip.s = ws_biptoip(caller_bip)
            caller_name.s = ws_biptoname(caller_bip)
            PrintN("from "+caller_name+" at "+caller_ip)
            ;
            ; note on socket options: SO_DONTLINGER is set by default
            ; it's possible to enable a 'heartbeat' on a socket / connection
            ;
            ; socket_keepalive.b=1
            ; retval = setsockopt_(accept_socket,#SOL_SOCKET,#SO_KEEPALIVE,@socket_keep_alive,1)
            ; PrintN("socket option: keep alive "+STR(retval))
            ;
            done.l = #False      ; if done then close socket, either gracefull or due to an error
            Repeat
              ;
              ; check if something can be received
              ; 
              ; status gives the number of sockets that have data
              ; if a socket is gracefully closed select_() will also report that recv_() can be used
              ;
              ; timeout.ws_timeval
              ; timeout\ws_seconds=0
              ; timeout\ws_microseconds=1
              ; accept_fdset.ws_fd_set
              ; accept_fdset\ws_fd_number = 1                     ; number of entries in the set
              ; accept_fdset\ws_fd_socket[1] = accept_socket      ; one word per socket    
              ; status.l=select_(0,@accept_fdset,0,0,@timeout)
              ;
              ; receive data
              ;
              buffer_l.l = 1024       ; buffer of 1024 kbytes            
              buffer_pbh.l = x_pbh()
              buffer_p = AllocateMemory(buffer_l)
              received.l = recv_(accept_socket,buffer_p,buffer_l,0)
              ;
              ; received>0   number of bytes received aka transferred to buffer
              ; received=0   gracefull disconnect (properly closed by other side)
              ; received<0   error, or no data
              ;
              If received > 0                           ; data to receive
                Print(PeekS(buffer_p,buffer_l)) 
              ElseIf received = 0                       ; gracefull disconnect
                done = #True                            ; so close the socket
              Else
                error.l = WSAGetLastError_()
                If error=#WSAEWOULDBLOCK                ; when non-blocking: no more data to read
                  ;
                  ; PrintN("Error #WSAEWOULDBLOCK "+Str(error))                       
                  ;
                  Delay(100)
                Else                                    ; otherwise a real problem
                  PrintN("Error "+Str(error))                       
                  close = 1                             ; so close the socket
                EndIf
              EndIf
              ;
              FreeMemory(buffer_pbh)                    ; free the read buffer
              x_freepbh(buffer_pbh)
              ;
            Until done = #True
            ;
            closesocket_(accept_socket)                 ; close socket
            PrintN("")
            ;
          Else
            ;
            ; no incoming calls, so let's free up some cpu resources
            ;
            Delay(100)
          EndIf
          ;
        Until Inkey()>""
        PrintN("")
        ;
      Case "C"
        ;
        PrintN("CLIENT")
        PrintN("")
        ;
        server_ip.s = host_ip
        server_bip.l = ws_iptobip(server_ip)
        server_port.l = 6000
        server_bport.l = htons_(server_port)    
        ;
        PrintN("trying to connect to "+server_ip+" port "+Str(server_port))
        PrintN("(any key to abort)")
        ;
        n.l = 0
        ;
        Repeat
          ;
          n = n+1
          PrintN("attempt "+Str(n))
          ;
          client_socket.l = SOCKET_(#AF_INET,#SOCK_STREAM,#IPPROTO_TCP)    
          PrintN("client socket "+Str(client_socket))
          ;
          ; *** connect to another server / port using an empty socket
          ;
          client_sockaddr.ws_sockaddr                   
          client_sockaddr\ws_in_family = #AF_INET
          client_sockaddr\ws_in_port = server_bport
          client_sockaddr\ws_in_addr = server_bip
          client_sockaddr_l.l = 16
          retval = connect_(client_socket,@client_sockaddr,client_sockaddr_l)
          ;
          PrintN("connect "+Str(retval))
          ;
          message.s = "call " +Str(n)+" from "+host_name+" at "+host_ip
          send.l = send_(client_socket,@message,Len(message),0)
          ;
          closesocket_(client_socket)               
          ;
        Until Inkey()>""
        PrintN("")
    EndSelect
  Until choice="X"  
  ;
  ws_end()
  x_end()
EndProcedure
  
ws_sample()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
