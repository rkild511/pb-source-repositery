; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=837&highlight=
; Author: PureFan (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 30. April 2003
; OS: Windows, Linux
; Demo: Yes

; Beschreibung (von blbltheworm):
;    Das Beispiel erstellt einen Einfachen Webserver, der auf Anfrage ein HTML-Dokument übermittelt
;    Zum Testen einfach das Beispiel starten und mit dem Browser dann zu "http://127.0.0.1/" verbinden

EOL$ = Chr(13)+Chr(10) 

OpenConsole() 
If InitNetwork()=0 
  PrintN("Das Netzwerksystem konnte nicht initialisiert werden") 
EndIf 
If CreateNetworkServer(1,80)=0 
  PrintN("Server konnte nicht auf Port 80 erstellt werden") 
Else 
  PrintN("server wurde auf Port 80 erstellt") 
EndIf 

Repeat 
  Event= NetworkServerEvent() 
  If Event=2 
    client = EventClient() 
    
    *Buffer = AllocateMemory(1000) 
    Repeat 
      gelesen=ReceiveNetworkData(client,*Buffer,1000) 
    Until gelesen<=0 
    
    PrintN("Nachfrage von "+ IPString(GetClientIP(client))) 
    
    DatenZuSenden.s="Hallo!" + Str(GetTickCount_()) 
    
    Define HtmlFile.s
    
    HtmlFile=  "HTTP/1.1 200 OK"+EOL$
    HtmlFile+  "Date: Wed, 07 Aug 1996 11:15:43 GMT"+EOL$
    HtmlFile+  "Server: Atomic Web Server 0.2b"+EOL$
    HtmlFile+  "Content-Length: "+Str(Len(DatenZuSenden))+EOL$
    HtmlFile+  "Content-Type: text/html" +EOL$
    HtmlFile+  EOL$
    HtmlFile+  DatenZuSenden
    
    SendNetworkString(client,HtmlFile)
  EndIf 
  
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
