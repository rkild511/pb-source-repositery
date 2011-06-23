; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2680&highlight=
; Author: MVXA (updated for PB 4.00 by Andre)
; Date: 28. March 2005
; OS: Windows
; Demo: No

Procedure.s ConnectToIPServer(strURL.s) 
    Define.l hINet, hData, Byte 
    Define.s Agent, NetBuffer 
    
    Agent     = "Mozilla/4.0 (compatible; ST)" 
    hINet     = InternetOpen_   (@Agent.s, 0, 0, 0, 0) 
    hData     = InternetOpenUrl_( hINet, @strURL, "", 0, $8000000, 0 ) 
    NetBuffer = Space(256) 
    
    If hData > 0: InternetReadFile_(hData, @NetBuffer, 255, @Byte ): EndIf 
    NetBuffer = Trim(NetBuffer) 
    
    InternetCloseHandle_ (hINet) 
    InternetCloseHandle_ (hFile) 
    InternetCloseHandle_ (hData)        
    
    ProcedureReturn Trim(NetBuffer) 
EndProcedure

Procedure.s GetNetworkIP() 
    Define.s strIP 
    
    strIP = ConnectToIPServer("http://easteregg.dyndns.biz:4664/littlefurz/IP.php") 
    If Len(strIP) = 0: strIP = ConnectToIPServer("http://www.panten.org/ip.php3"): EndIf 
    
    If Len(strIP) = 0 Or Len(strIP) > 15 
        ExamineIPAddresses() 
        strIP = IPString(NextIPAddress()) 
    EndIf 
    
    ProcedureReturn Trim(strIP) 
EndProcedure 

InitNetwork()
Debug GetNetworkIP()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -