; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Debug "Drücke Escape zum Beenden"
If InitNetwork()
  port.l = 21
  Ergebnis = CreateNetworkServer(#PB_Any,port)
  Debug "port " + Str(port) + " wird überwacht"
  Repeat
    Select NetworkServerEvent()
    Case 1
      Client.l = EventClient()
      Debug "Client(" + Str(Client) + ") greift auf den port " + Str(port) + " zu"
    Case 2
      *mem = AllocateMemory(4096)
      rSize.l = ReceiveNetworkData(Client, *mem, 4096)
      Debug "von Client(" + Str(Client) + ") wurden daten empfangen"
      Debug Str(rSize) + " Byte"
      Debug PeekS(*mem, rSize)
    Case 3
      Debug "datei wurde empfangen "
    Case 4
      Debug "Client(" + Str(Client) + ") hat die verbindung getrennt"
    EndSelect
    If GetAsyncKeyState_(#VK_ESCAPE)
      Quit = #True
    EndIf
  Until Quit
  CloseNetworkServer(Ergebnis)
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -