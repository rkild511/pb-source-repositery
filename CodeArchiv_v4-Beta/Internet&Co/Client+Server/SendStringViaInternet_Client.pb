; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14314&highlight=
; Author: HeX0R (updated for PB 4.00 by Andre)
; Date: 08. March 2005
; OS: Windows
; Demo: Yes


; Sending a string via Internet (TCP/IP connection) 
; This is the client! Look for the related server code example,
; which must be started first!

If InitNetwork() = 0 
  MessageRequester("Error", "Error") 
EndIf 
ip$ = InputRequester("","bitte server ip eingeben!","") 
Debug ip$ 
ConnectionID = OpenNetworkConnection(ip$, 6654) 
If ConnectionID 
  OpenConsole() 
  PrintN("Erfolgreich zum server Verbunden") 
  String$ = InputRequester("","String zum versenden eingeben","") 
  If String$ 
    SendNetworkData(ConnectionID, @String$, Len(String$)) 
  EndIf 
  Input() 
Else 
  Debug "error" 
EndIf 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger