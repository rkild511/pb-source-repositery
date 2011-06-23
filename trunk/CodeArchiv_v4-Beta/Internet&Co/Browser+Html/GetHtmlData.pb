; http://athecks.com:88/?source=52
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 18. September 2005
; OS: Windows
; Demo: Yes


InitNetwork() 

ConnectionID = OpenNetworkConnection("www.purearea.net", 80) 

If ConnectionID 
  com$="GET / HTTP/1.1"+Chr(13)+Chr(10) 
  com$=com$+"Accept: */*"+Chr(13)+Chr(10) 
  com$=com$+"Accept: text/html"+Chr(13)+Chr(10) 
  com$=com$+"Host: purearea.net"+Chr(13)+Chr(10) 
  com$=com$+"User-Agent: "+Chr(13)+Chr(10) 
  com$=com$+Chr(13)+Chr(10) 
  Res = SendNetworkData(ConnectionID,@com$,Len(com$)) 

    Repeat 
    Delay(10) 
    Result = NetworkClientEvent(ConnectionID) 
  
    Select Result 
  
    Case 2 
      Content$ = Space(14500) 
      ReceiveNetworkData(ConnectionID,@Content$,14500) 
      Ok = 1 
      MessageRequester("Done!","Your Data" + Chr(13) + Chr(10) + Content$,0) 
      CloseNetworkConnection(ConnectionID) 
    EndSelect 
    
    Until Ok = 1 
EndIf 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP