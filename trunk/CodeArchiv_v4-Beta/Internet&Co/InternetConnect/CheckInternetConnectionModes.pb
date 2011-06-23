; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=3919
; Author: Droopy
; Date: 06. November 2005
; OS: Windows
; Demo: No


; Return : 
; 0x40 INTERNET_CONNECTION_CONFIGURED : Local system has a valid connection To the Internet, but it might Or might not be currently connected. 
; 0x02 INTERNET_CONNECTION_LAN : Local system uses a Local area network To connect To the Internet. 
; 0x01 INTERNET_CONNECTION_MODEM : Local system uses a modem To connect To the Internet. 
; 0x08 INTERNET_CONNECTION_MODEM_BUSY : No longer used. 
; 0x20 INTERNET_CONNECTION_OFFLINE : Local system is in offline mode. 
; 0x04 INTERNET_CONNECTION_PROXY : Local system uses a proxy server To connect To the Internet. 
; 0x10 INTERNET_RAS_INSTALLED : Local system has RAS installed 
; or 0 if  there is no Internet connection 

#INTERNET_CONNECTION_CONFIGURED =$40 
#INTERNET_CONNECTION_LAN = $02 
#INTERNET_CONNECTION_MODEM =$1 
#INTERNET_CONNECTION_MODEM_BUSY =$8 
#INTERNET_CONNECTION_OFFLINE =$20 
#INTERNET_CONNECTION_PROXY =$4 
#INTERNET_RAS_INSTALLED =$10 

ProcedureDLL CheckInternetConnection() 
  InternetGetConnectedState_(@Retour, 0) 
  ProcedureReturn Retour 
EndProcedure 

;/ Test 

State=CheckInternetConnection() 

If State=0 
  Temp.s="No Internet Connection" 
EndIf 
  
If State & #INTERNET_CONNECTION_CONFIGURED 
  Temp="INTERNET_CONNECTION_CONFIGURED"+#CRLF$ 
EndIf 

If State &#INTERNET_CONNECTION_LAN 
  Temp+"INTERNET_CONNECTION_LAN"+#CRLF$ 
EndIf 

If State &#INTERNET_CONNECTION_MODEM 
  Temp+"INTERNET_CONNECTION_MODEM"+#CRLF$ 
EndIf 

If State &#INTERNET_CONNECTION_MODEM_BUSY 
  Temp+"INTERNET_CONNECTION_MODEM_BUSY"+#CRLF$ 
EndIf 

If State &#INTERNET_CONNECTION_OFFLINE 
  Temp+"INTERNET_CONNECTION_OFFLINE"+#CRLF$ 
EndIf 

If State &#INTERNET_CONNECTION_PROXY 
  Temp+"INTERNET_CONNECTION_PROXY"+#CRLF$ 
EndIf 

If State &#INTERNET_RAS_INSTALLED 
  Temp+"INTERNET_RAS_INSTALLED"+#CRLF$ 
EndIf 

MessageRequester("Internet Connexion",Temp)  

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP