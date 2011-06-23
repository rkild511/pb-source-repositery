; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14314&highlight=
; Author: HeX0R (updated for PB 4.00 by Andre)
; Date: 08. March 2005
; OS: Windows
; Demo: Yes


; Sending a string via Internet (TCP/IP connection) 
; This is the server! Look for the related client code example!

InitNetwork() 
If ExamineIPAddresses() 
  IP.l = NextIPAddress() 
EndIf 
*buffer = AllocateMemory(2000) 
If CreateNetworkServer(0, 6654) 
  OpenConsole() 
  PrintN("Server Online Listening on IP (" + IPString(IP) + ")") 
  Repeat 
    Select NetworkServerEvent() 
      Case 0 
        If Left(Inkey(), 1) = Chr(13) 
          Quit = 1 
        EndIf 
        Delay(5) 
      Case 1 
        PrintN("Ein neuer Client hat Connectet") 
        ClientID.l = EventClient() 
      Case 2 
        length.l = ReceiveNetworkData(ClientID, *buffer, 2000) 
        String$ = PeekS(*buffer, 2000) 
        PrintN("Received:" + String$) 
    EndSelect  
  Until Quit = 1 
EndIf 
FreeMemory(*buffer) 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -