; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1156&start=10
; Author: DarkDragon
; Date: 10. December 2004
; OS: Windows
; Demo: Yes

Procedure.s PostToHost(Host$, File$, _Data$) 
  ConnectionID = OpenNetworkConnection(Host$, 80) 
  If ConnectionID 
    String$ = "" 
    If _Data$ <> "" 
      String$ + "POST " + File$ + " HTTP/1.1" + Chr(13) + Chr(10) 
    Else 
      String$ + "GET " + File$ + " HTTP/1.1" + Chr(13) + Chr(10) 
    EndIf 
    String$ + "Host: " + Host$ + Chr(13) + Chr(10) 
    String$ + "Content-Type: application/x-www-form-urlencoded" + Chr(13) + Chr(10) 
    String$ + "Connection: close" + Chr(13) + Chr(10) 
    If _Data$ <> "" 
      String$ + "Content-Length: " + Str(Len(_Data$)) + Chr(13) + Chr(10) 
    EndIf 
    String$ + Chr(13) + Chr(10) 
    String$ + _Data$ + Chr(13) + Chr(10) 
    SendNetworkString(ConnectionID, String$) 
    If _Data$ = "" 
      Repeat : Until NetworkClientEvent(ConnectionID) = 2 
      Buffer = AllocateMemory(10000) 
      ReceiveNetworkData(ConnectionID, Buffer, 10000) 
      CloseNetworkConnection(ConnectionID) 
      ProcedureReturn PeekS(Buffer) 
    EndIf 
    CloseNetworkConnection(ConnectionID) 
  EndIf 
EndProcedure 

Procedure.s NewHighscore(RoomUser.s, Name.s, Score.l) ;Creates a new highscore 
  PostToHost("mitglied.lycos.de", "/dani008/HS/new.php", "room="+RoomUser+"&name="+Name+"&score="+Str(score)) 
  ProcedureReturn PostToHost("mitglied.lycos.de", "/dani008/HS/"+RoomUser+"/index.txt", "") 
EndProcedure

InitNetwork()
Debug NewHighScore("TestRoom","TestUser",100)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -