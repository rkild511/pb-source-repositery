; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2764
; Author: acidburnearth (improved by ChaOsKid, updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 08. November 2003
; OS: Windows
; Demo: Yes

Port = 6060 
Buffer = AllocateMemory(10000) 

OpenConsole() 

If InitNetwork() = 0 
  ConsoleLocate(1,1) 
  ConsoleColor(12,0) 
  Print("- SERVERMESSAGE - ") 
  ConsoleColor(7,0) 
  Print("Fehler beim initialisieren des Netzwerks") 
  Delay(6000) 
  End 
Else 
  ConsoleLocate(1,1) 
  ConsoleColor(3,0) 
  Print("- SERVERMESSAGE - ") 
  ConsoleColor(7,0) 
  Print("Initialisierung des Netzwerks erfolgreich") 
EndIf 

If CreateNetworkServer(1,Port) 
  ConsoleLocate(1,2) 
  ConsoleColor(3,0) 
  Print("- SERVERMESSAGE - ") 
  ConsoleColor(7,0) 
  Print("gestartet an Port ") 
  ConsoleColor(10,0) 
  Print(Str(Port)) 
  ConsoleColor(7,0) 
  ConsoleLocate(0,4) 
  
  Repeat 
    Select NetworkServerEvent() 
      Case 1 
        PrintN(" - EVENT - Client verbunden") 
      Case 2 
        PrintN(" - EVENT - Client " + Str(EventClient()) + " hat Daten oder String übertragen ") 
        ReceiveNetworkData(EventClient(), Buffer, 10000) 
        PrintN("    InfoString: " + PeekS(Buffer)) 
      Case 3 
        PrintN(" - EVENT - Client " + Str(EventClient()) + " hat eine Datei übertragen ") 
        ReceiveNetworkFile(EventClient(), "C:\HiveServ\income\network.ftp3") 
      Case 4 
        PrintN(" - EVENT - Client " + Str(EventClient()) + " getrennt") 
    EndSelect 
  ForEver 
  CloseNetworkServer(1) 
  
Else 
  ConsoleLocate(1,4) 
  ConsoleColor(12,0) 
  Print("- SERVERMESSAGE - ") 
  ConsoleColor(7,4) 
  Print("Kann Port nicht initialisieren") 
  ConsoleLocate(19,5) 
  ConsoleColor(8,0) 
  Print("Vielleicht durch eine andere Anwendung belegt") 
  ConsoleLocate(19,6) 
  Print("oder Server bereits im Hintergrund gestartet.") 
  ConsoleColor(7,0) 
  Delay(10000) 
EndIf 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
