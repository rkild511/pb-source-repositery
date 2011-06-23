; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1371&highlight=
; Author: schic (updated for PB 4.00 by Andre)
; Date: 25. December 2004
; OS: Windows
; Demo: No


; FireFox starter with auto-dial and auto-hangup
; FireFox-Starter mit Auto-Dial und Auto-Hangup
; (Auto-Hangup wird nur angeboten, wenn kein anderes Programm mehr aktiv verbunden ist.)


;Const for AutoDial
#INTERNET_AUTODIAL_FORCE_ONLINE = 1     ;ask for dial
#INTERNET_AUTODIAL_FORCE_UNATTENDED = 2 ;dial without asking
;Const and var for reg
#STANDARD_RIGHTS_REQUIRED = $000F0000
#SYNCHRONIZE = $00100000
#PROCESS_ALL_ACCESS = #STANDARD_RIGHTS_REQUIRED+#SYNCHRONIZE+$0FFF
Global GetValue.s

;const and var for GetTcpTable
#ERROR_SUCCESS            = 0
#MIB_TCP_STATE_CLOSED     = 1
#MIB_TCP_STATE_LISTEN     = 2
#MIB_TCP_STATE_SYN_SENT   = 3
#MIB_TCP_STATE_SYN_RCVD   = 4
#MIB_TCP_STATE_ESTAB      = 5
#MIB_TCP_STATE_FIN_WAIT1  = 6
#MIB_TCP_STATE_FIN_WAIT2  = 7
#MIB_TCP_STATE_CLOSE_WAIT = 8
#MIB_TCP_STATE_CLOSING    = 9
#MIB_TCP_STATE_LAST_ACK   = 10
#MIB_TCP_STATE_TIME_WAIT  = 11
#MIB_TCP_STATE_DELETE_TCB = 12
Structure MIB_TCPROW
  dwState.l
  dwLocalAddr.l
  dwLocalPort.l
  dwRemoteAddr.l
  dwRemotePort.l
EndStructure

Procedure.b InternetTraffic()
  TcpRow.MIB_TCPROW
  lngRequired.l
  lngStrucSize.l
  lngRows.l
  lngCnt.l
  strTmp.s
  strRemoteIP.s
  Dim RemoteIP.l (3)
  IPState.s
  
  check = #False
  GetTcpTable_(0, @lngRequired, 1)
  If lngRequired > 0
    Dim buff.b(lngRequired - 1)
    If GetTcpTable_(@buff(0), @lngRequired, 1) = #ERROR_SUCCESS
      lngStrucSize = SizeOf(TcpRow)
      CopyMemory(@buff(0),@lngRows,4)
      For lngCnt = 1 To lngRows
        ;moves past the four bytes obtained above
        ;to get Data And cast into a TcpRow stucture
        CopyMemory(@buff(4 + (lngCnt - 1) * lngStrucSize), @TcpRow, lngStrucSize)
        
        strRemoteIP = IPString(TcpRow\dwRemoteAddr)
        Debug "strRemoteIP= " + strRemoteIP + " state: " + Str(TcpRow\dwState)
        For i = 0 To 3
          RemoteIP(i)=IPAddressField(TcpRow\dwRemoteAddr,i)
        Next
        
        If FindString("5 10 ", Str(TcpRow\dwState)+" ", 1)
          
          ;if state is #MIB_TCP_STATE_ESTAB or #MIB_TCP_STATE_LAST_ACK (or #MIB_TCP_STATE_TIME_WAIT or MIB_TCP_STATE_CLOSE_WAIT)
          ;and not private address
          ;1 × Klasse A    10.0.0.0 – 10.255.255.255
          ;16 × Klasse b    172.16.0.0 – 172.31.255.255
          ;256 × Klasse C    192.168.0.0 – 192.168.255.255
          
          ;and if not special IP-address
          ;127.0.0.1     Internal host loopback Address.
          ;255.255.255.255    Limited broadcast (To local network hosts only).
          ;0.0.0.0    Used To identify the current host in the current network.
          
          If RemoteIP(0)=172
            If RemoteIP(1)< 16 And RemoteIP(1)> 31
              ProcedureReturn #True
            EndIf
          ElseIf RemoteIP(0)<>10 And FindString(strRemoteIP, "192.168.", 1)=0 And FindString("127.0.0.1 255.255.255.255 0.0.0.0", strRemoteIP, 1)=0
            ProcedureReturn #True
          EndIf
          
        EndIf ;FindString("5 10 11 ", Str(TcpRow\dwState)+" ", 1)
      Next
    EndIf ;GetTcpTable_(@buff(0), @lngRequired, 1) = #ERROR_SUCCESS
  EndIf ;lngRequired > 0
  ProcedureReturn #False
EndProcedure

Procedure.l SetRegValue(topKey.l, sKeyName.s, sValueName.s, vValue.s, lType.l, ComputerName.s)
  GetHandle.l
  hKey.l
  lType.l
  lpcbData.l
  lpData.s
  lReturnCode.l
  lhRemoteRegistry.l
  
  If Left(sKeyName, 1) = "\"
    sKeyName = Right(sKeyName, Len(sKeyName) - 1)
  EndIf
  
  If ComputerName = ""
    GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
  Else
    lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry)
    GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
  EndIf
  
  If GetHandle = #ERROR_SUCCESS
    lpcbData = 255
    lpData = Space(255)
    
    Select lType
    Case #REG_SZ
      GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_SZ, @vValue, Len(vValue) + 1)
    Case #REG_DWORD
      lValue = Val(vValue)
      GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_DWORD, @lValue, 4)
    EndSelect
    
    RegCloseKey_(hKey)
    Ergebnis = 1
    ProcedureReturn Ergebnis
  Else
    MessageRequester("Fehler", "Ein Fehler ist aufgetreten", 0)
    RegCloseKey_(hKey)
    Ergebnis  = 0
    ProcedureReturn Ergebnis
  EndIf
EndProcedure

Procedure.l GetRegValue(topKey, sKeyName.s, sValueName.s, ComputerName.s)
  GetHandle.l
  hKey.l
  lpData.s
  lpDataDWORD.l
  lpcbData.l
  lType.l
  lReturnCode.l
  lhRemoteRegistry.l
  
  
  If Left(sKeyName, 1) = "\"
    sKeyName = Right(sKeyName, Len(sKeyName) - 1)
  EndIf
  
  If ComputerName = ""
    GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
  Else
    lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry)
    GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey)
  EndIf
  
  If GetHandle = #ERROR_SUCCESS
    lpcbData = 255
    lpData = Space(255)
    
    GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lType, @lpData, @lpcbData)
    If GetHandle = #ERROR_SUCCESS
      Select lType
      Case #REG_SZ
        GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lType, @lpData, @lpcbData)
        If GetHandle = 0
          GetValue = Left(lpData, lpcbData - 1)
        Else
          GetValue = ""
        EndIf
        
      Case #REG_DWORD
        GetHandle = RegQueryValueEx_(hKey, ValueName, 0, @lpType, @lpDataDWORD, @lpcbData)
        If GetHandle = 0
          GetValue = Str(lpDataDWORD)
        Else
          GetValue = "0"
        EndIf
      EndSelect
    EndIf
  EndIf
  RegCloseKey_(hKey)
  ProcedureReturn GetHandle
EndProcedure


;{-Main
;set this registry-keys by hand to associate hhtp, https and urls with the starter
;HKEY_CLASSES_ROOT\HTTP\shell\open\command -> D:\MOZILL~1\FIREFO~1.EXE -url "%1"
;HKEY_CLASSES_ROOT\https\shell\open\command -> D:\MOZILL~1\FIREFO~1.EXE -url "%1"
;FIREFO~1.EXE = DOS-name for 'FireFox Starter.exe', may be different
;ToDo: make an options-window and do this by klick

;get parameter if starting from url
lpCmdLine = GetCommandLine_()
Url$ = Trim(PeekS(lpCmdLine))
If FindString(Url$,"-url",1)
  Url$=Right(Url$,Len(Url$)-FindString(Url$,"-url",1)+1)
Else
  Url$=""
EndIf

;dial if there is no connection
If InternetGetConnectedState_(0, 0) = 0
  If InternetAutodial_(#INTERNET_AUTODIAL_FORCE_ONLINE, 0)
    WasNotOnline=#True
    start = GetTickCount_()
    Repeat ;wait until connected or 60 seconds are over
      Delay(20)
    Until InternetGetConnectedState_(0, 0) Or GetTickCount_() > start + 60000
    If InternetGetConnectedState_(0, 0) = 0 ;waited more than 60 seconds
      MessageRequester("Error!", "Timeout, AutoDial failed.")
      ;End
    EndIf
  Else ;InternetAutodial_
    ;if user canceled
    ;End
  EndIf;InternetAutodial_
EndIf ;CheckInternetConnection

sKeyNameGS.s = "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe"
sTopKeyGS.l = #HKEY_LOCAL_MACHINE
If GetRegValue(sTopKeyGS,sKeyNameGS,"Path","")
  MessageRequester("Fehler!","FireFox not installed.",0)
  Goto aus
EndIf

Prog.s = GetValue + "firefox.exe"
Ergebnis = RunProgram(Prog,Url$,"",1)

aus:
Delay(3000)
; ask for hanging up only if no Mozilla App is running
MozillaAppIsRunning = FindWindowEx_(0, 0, "MozillaWindowClass", 0)
If MozillaAppIsRunning = 0 And InternetGetConnectedState_(0, 0) And InternetTraffic() = 0
  ;checking InternetTraffic is useful if a downloadmanager is running, for not disconnecting accidentally
  ;but may only work if not behind a router, cause private addresses are filtered
  If MessageRequester("Automatische Trennung!", "Soll die Verbindung getrennt werden?",#PB_MessageRequester_YesNo)=6
    InternetAutodialHangup_(0)
  EndIf
EndIf
;}

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -