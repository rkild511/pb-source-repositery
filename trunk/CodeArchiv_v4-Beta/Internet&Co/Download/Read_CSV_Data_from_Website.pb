; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6642&highlight=
; Author: ricardo
; Date: 20. June 2003
; OS: Windows
; Demo: Yes

InitNetwork() 

ConnectionID = OpenNetworkConnection("table.finance.yahoo.com", 80) 

If ConnectionID 
  com$="GET http://itable.finance.yahoo.com/table.csv?s=IBM&amp;g=d HTTP/1.1"+Chr(13)+Chr(10) 
  com$=com$+"Accept: */*"+Chr(13)+Chr(10) 
  com$=com$+"Accept: text/html"+Chr(13)+Chr(10) 
  com$=com$+"Host: "+host$+Chr(13)+Chr(10) 
  com$=com$+"User-Agent: Yahoo CVS Parser"+Chr(13)+Chr(10) 
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

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
