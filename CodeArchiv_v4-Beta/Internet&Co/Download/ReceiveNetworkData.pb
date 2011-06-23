; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13549&highlight=
; Author: Henrik
; Date: 31. December 2004
; OS: Windows
; Demo: Yes

If InitNetwork() = 0
  MessageRequester("Error", "Can't initialize the network !", 0)
  End
EndIf

Lengt=4096
mem = AllocateMemory(Lengt)

ConnectionID = OpenNetworkConnection("www.purebasic.com",80)
If ConnectionID = #False
  MessageRequester("No Connection", "Click to close.", 0)
  End
EndIf

SendNetworkString(ConnectionID, "GET http://www.purebasic.com/ HTTP/1.0"+ Chr(13)+Chr(10))
SendNetworkString(ConnectionID,  Chr(13)+Chr(10))
Repeat

  NEvent = NetworkClientEvent(ConnectionID)
  If NEvent =0
    If start
      If ElapsedMilliseconds()-StartTime >3000 :  Quit = 1 : EndIf
    EndIf

  ElseIf  NEvent =2
    Start=1
    ;<- Resets timer every time Nevent=2 ->
    StartTime = ElapsedMilliseconds()
    Received_Lengt = ReceiveNetworkData(ConnectionID, mem, Lengt)
    Debug PeekS(mem,Received_Lengt)
    If Received_Lengt = Lengt : Quit = 2 : EndIf
  EndIf
Until Quit

If Quit = 1
  MessageRequester("Time-out", "Click to close Connetion.", 0)
ElseIf Quit = 2
  MessageRequester("Download sucessful", "Click to close Connetion.", 0)
EndIf

CloseNetworkConnection(ConnectionID)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -