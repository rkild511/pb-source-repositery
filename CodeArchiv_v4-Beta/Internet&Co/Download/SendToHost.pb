; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1109
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 04. December 2004
; OS: Windows
; Demo: Yes

Procedure.s SendToHost(Host$, File$, _Data$) 
  InitNetwork() 
  
  ConnectionID = OpenNetworkConnection(Host$, 80) 
  
  If ConnectionID 
  
    String$ = "" 
    If _Data$ <> "" 
      String$ + "POST " + File$ + " HTTP/1.1" + Chr(13) + Chr(10) 

      String$ + "Content-Length: " + Str(Len(_Data$)) + Chr(13) + Chr(10) 
    Else 
      String$ + "GET " + File$ + " HTTP/1.1" + Chr(13) + Chr(10) 
    EndIf 
  
    String$ + "Host: " + Host$ + Chr(13) + Chr(10) 
    String$ + "Content-Type: application/x-www-form-urlencoded" + Chr(13) + Chr(10) 
    String$ + "Connection: close" + Chr(13) + Chr(10) 
    String$ + Chr(13) + Chr(10) 
    String$ + _Data$ + Chr(13) + Chr(10) 
  
    SendNetworkString(ConnectionID, String$) 
    While NetworkClientEvent(ConnectionID) <> 2 
      Delay(1) 
    Wend 
    size = 100000 
    *Buffer = AllocateMemory(size) 
    
    laenge = 1 
    While laenge <> 0 
      laenge.l = ReceiveNetworkData(ConnectionID, *Buffer, size) 
      If laenge <> 0 And Len(string.s)+laenge < 63999 
        string.s = string.s + PeekS(*Buffer, laenge) 
      EndIf 
    Wend 
  
    Text.s = string.s 
    FreeMemory(*Buffer) 
    Start = FindString(Text, Chr(13)+Chr(10)+Chr(13)+Chr(10), 0)+9 
    CloseNetworkConnection(ConnectionID) 
    ProcedureReturn Mid(Text, Start+1, (Len(Text)-Start)-1) 
  EndIf 
  
EndProcedure 
  
  
Debug SendToHost("www.bradan.net", "/index.php", "visited=1")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -