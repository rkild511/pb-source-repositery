; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6668&highlight=
; Author: TerryHough (updated for PB3.93 by ts-soft)
; Date: 23. June 2003
; OS: Windows
; Demo: Yes

;----------------------------------------------------------------------- 
; POP3 - Check number of messages 
; Written by TerryHough - last updated 06/23/2003 
;----------------------------------------------------------------------- 

EOL$ = Chr(13)+Chr(10) 
*Buffer = AllocateMemory(5000) 

If InitNetwork() = 0 
  MessageRequester("Error", "Can't initialize the network !", #MB_ICONSTOP) 
  End 
Else 
  ConnectionID = OpenNetworkConnection("pop2.server.???", 110) 
  If ConnectionID 
    ; most POP3 servers send an ID message back upon connection 
    ; check if OK and respond with USER ID 
    Reply$ = "" 
    *Buffer = AllocateMemory(5000) 
    RequestLength.l = ReceiveNetworkData(ConnectionID, *Buffer, 5000)  
    Reply$ = PeekS(*Buffer) 
    Result$ = Reply$ 
    If Mid(Reply$,1,3) = "+OK" 
      ; Send the USER ID now.  Some POP3 servers don't prompt for it, 
      ; but expect it to be sent here. 
      SendNetworkString(ConnectionID, "USER userid"+EOL$) 
      Reply$ = "" 
      *Buffer = AllocateMemory(5000) 
      ; Should get back a password request if USER ID is valid 
      RequestLength.l = ReceiveNetworkData(ConnectionID, *Buffer, 5000)  
      Reply$ = PeekS(*Buffer) 
      Result$ = Result$ + Reply$ 
      If Mid(Reply$,1,3) = "+OK" 
        Reply$ = "" 
        *Buffer = AllocateMemory(5000) 
        ; Send the PASSWORD now 
        SendNetworkString(ConnectionID, "PASS password"+EOL$) 
        Reply$ = "" 
        *Buffer = AllocateMemory(5000) 
        ; Should get back a welcome message if password is accepted 
        RequestLength.l = ReceiveNetworkData(ConnectionID, *Buffer, 5000)  
        Reply$ = PeekS(*Buffer) 
        Result$ = Result$ + Reply$ 
        If Mid(Reply$,1,3) = "+OK" 
          ; Send the LIST command to get number of available messages 
          SendNetworkString(ConnectionID, "LIST"+EOL$) 
          Reply$ = "" 
          *Buffer = AllocateMemory(5000) 
          ; Should get back a number of available messages 
          ; Interpret based on the response receive, they vary and may 
          ; include info about the message ids 
          RequestLength.l = ReceiveNetworkData(ConnectionID, *Buffer, 5000)  
          Reply$ = PeekS(*Buffer) 
;          Result$ = Result$ + Reply$      ; not generally needed 
          Position = FindString(Reply$, "messages", 1) 
          If Position > 0 
            Result$ = Result$ + Reply$ 
            messages = Val(Trim(Mid(Reply$, Position +2 ,Len(Reply$)))) 
            MessageRequester("Info",Result$ +Chr(10)+"You have " + Str(messages) + " messages.",#MB_ICONINFORMATION) 
          EndIf 
        Else 
          MessageRequester("Error","POP3 server didn't accept the PASSWORD.",#MB_ICONERROR) 
        EndIf    
      Else 
        MessageRequester("Error","POP3 server didn't accept the USER ID.",#MB_ICONERROR) 
      EndIf 
    EndIf 
    CloseNetworkConnection(ConnectionID) 
  Else 
    MessageRequester("Error","Unable to connect to POP3 server.",#MB_ICONERROR) 
  EndIf 
EndIf 
End 
;----------------------------------------------------------------------- 
; End of code for POP3 - Check number of messages 
;-----------------------------------------------------------------------  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
