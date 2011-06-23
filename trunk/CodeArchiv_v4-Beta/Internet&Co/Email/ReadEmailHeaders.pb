; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8096&highlight=
; Author: willib (updated for PB3.93 by ts-soft)
; Date: 28. October 2003
; OS: Windows
; Demo: Yes

; A short code to see your e-Mail headers from a pop3 server !
; You must adapt the IP, User and PASS to your needs...
*Buffer = AllocateMemory(10000) 
If InitNetwork() = 0 
  MessageRequester("Error", "Can't initialize the network !", 0) 
  End 
EndIf 

Port = 110 
crlf$=Chr(13)+Chr(10) 
; ============CHANGE HERE =================== 
IP$   = "pop3.web.de" ; "pop3.t-online.de" 
User$ = "blabla@web.de" 
PASS$ = "dummie" 
; ============CHANGE HERE =================== 
ConnectionID = OpenNetworkConnection(IP$, Port) 
If ConnectionID 
  
  ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
  a$ = PeekS(*Buffer,ab.l) 

  SendNetworkString(ConnectionID, "USER "+User$+crlf$) 
  ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
  a$ = PeekS(*Buffer,ab.l) 
  
  SendNetworkString(ConnectionID, "PASS "+PASS$+crlf$) 
  ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
  a$ = PeekS(*Buffer,ab.l) 

  If Left(a$,4)="-ERR" 
    MessageRequester("PureBasic POPPER", a$+" OK", 0) 
    End 
  EndIf  
  SendNetworkString(ConnectionID, "LIST"+crlf$) 
  ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
  b$ = PeekS(*Buffer,ab.l) 

  ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
  a$ = PeekS(*Buffer,ab.l) 
  ;MessageRequester("PureBasic - Client2", b$+" OK", 0) 
  
  ERg = Val( StringField(b$, 2," ")) 
  If ERg=0 
    MessageRequester("PureBasic - Client", "NO MAIL", 0) 
  Else 
    For g=1 To ERg 
      a$="" : b$="" 
      SendNetworkString(ConnectionID, "TOP "+Str(g)+" 0"+crlf$) 
      ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
      b$ = PeekS(*Buffer,ab.l) 
      ;  MessageRequester("PureBasic - Client2", b$, 0) 
      Delay(50) 
      ab.l= ReceiveNetworkData(ConnectionID, *Buffer , 10000) 
      a$ = PeekS(*Buffer,ab.l) 
      MessageRequester("PureBasic POPPER "+Str(g)+" / "+Str(ERg), a$+" "+Str(ab.l), 0) 
    Next g 
  EndIf 
  CloseNetworkConnection(ConnectionID) 
Else 
  MessageRequester("PureBasic - Client", "Can't find the server (Is it launched ?).", 0) 
EndIf 

End   

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
