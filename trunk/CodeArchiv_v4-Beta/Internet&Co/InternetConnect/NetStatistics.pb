; English forum: http://www.purebasic.fr/english/viewtopic.php?t=11061
; Author: fweil (updated for PB 4.00 by Andre)
; Date: 29. May 2004
; OS: Windows
; Demo: No

Enumeration
  #Window_Main
  #Gadget_Editor
EndEnumeration

#MIB_TCP_STATE_CLOSED = 0
#MIB_TCP_STATE_LISTEN = 1
#MIB_TCP_STATE_SYN_SENT = 2
#MIB_TCP_STATE_SYN_RCVD = 3
#MIB_TCP_STATE_ESTAB = 4
#MIB_TCP_STATE_FIN_WAIT1 = 5
#MIB_TCP_STATE_FIN_WAIT2 = 6
#MIB_TCP_STATE_CLOSE_WAIT = 7
#MIB_TCP_STATE_CLOSING = 8
#MIB_TCP_STATE_LAST_ACK = 9
#MIB_TCP_STATE_TIME_WAIT = 10
#MIB_TCP_STATE_DELETE_TCB = 11

Structure MIB_IPSTATS
  dwForwarding.l ; IP forwarding enabled Or disabled
  dwDefaultTTL.l ; Default time-to-live
  dwInReceives.l ; datagrams received
  dwInHdrErrors.l ; received header errors
  dwInAddrErrors.l ; received address errors
  dwForwDatagrams.l ; datagrams forwarded
  dwInUnknownProtos.l ; datagrams with unknown protocol
  dwInDiscards.l ; received datagrams discarded
  dwInDelivers.l ; received datagrams delivered
  dwOutRequests.l
  dwRoutingDiscards.l
  dwOutDiscards.l ; sent datagrams discarded
  dwOutNoRoutes.l ; datagrams For which no route
  dwReasmTimeout.l ; datagrams For which all frags didn't arrive
  dwReasmReqds.l ; datagrams requiring reassembly
  dwReasmOks.l ; successful reassemblies
  dwReasmFails.l ; failed reassemblies
  dwFragOks.l ; successful fragmentations
  dwFragFails.l ; failed fragmentations
  dwFragCreates.l ; datagrams fragmented
  dwNumIf.l ; number of interfaces on computer
  dwNumAddr.l ; number of IP address on computer
  dwNumRoutes.l ; number of routes in routing table
EndStructure

Structure MIB_TCPSTATS
  dwRtoAlgorithm.l ; timeout algorithm
  dwRtoMin.l ; minimum timeout
  dwRtoMax.l ; maximum timeout
  dwMaxConn.l ; maximum connections
  dwActiveOpens.l ; active opens
  dwPassiveOpens.l ; passive opens
  dwAttemptFails.l ; failed attempts
  dwEstabResets.l ; establised connections reset
  dwCurrEstab.l ; established connections
  dwInSegs.l ; segments received
  dwOutSegs.l ; segment sent
  dwRetransSegs.l ; segments retransmitted
  dwInErrs.l ; incoming errors
  dwOutRsts.l ; outgoing resets
  dwNumConns.l ; cumulative connections
EndStructure

Structure MIB_UDPSTATS
  dwInDatagrams.l ; received datagrams
  dwNoPorts.l ; datagrams For which no port
  dwInErrors.l ; errors on received datagrams
  dwOutDatagrams.l ; sent datagrams
  dwNumAddrs.l ; number of entries in UDP listener table
EndStructure

Structure MIBICMPSTATS
  dwMsgs.l ; number of messages
  dwErrors.l ; number of errors
  dwDestUnreachs.l ; destination unreachable messages
  dwTimeExcds.l ; time-to-live exceeded messages
  dwParmProbs.l ; parameter problem messages
  dwSrcQuenchs.l ; source quench messages
  dwRedirects.l ; redirection messages
  dwEchos.l ; echo requests
  dwEchoReps.l ; echo replies
  dwTimestamps.l ; timestamp requests
  dwTimestampReps.l ; timestamp replies
  dwAddrMasks.l ; address mask requests
  dwAddrMaskReps.l ; address mask replies
EndStructure

Structure MIBICMPINFO
  icmpInStats.MIBICMPSTATS ; stats For incoming messages
  icmpOutStats.MIBICMPSTATS ; stats For outgoing messages
EndStructure

Global ip.MIB_IPSTATS
Global tcp.MIB_TCPSTATS
Global udp.MIB_UDPSTATS
Global icmp.MIBICMPINFO

Global EOL.s, TAB.s
EOL = Chr(13) + Chr(10)
TAB = Chr(9)

Procedure.s Stats()
  txtOutput.s = ""
  If GetIpStatistics_(ip)
    txtOutput = txtOutput + "Unable to retrieve IP Statistics"
  Else
    txtOutput = txtOutput + "IP Statistics" + EOL + "==============================" + EOL
    txtOutput = txtOutput + "IP forwarding enabled or disabled:" + TAB + Str(ip\dwForwarding) + EOL
    txtOutput = txtOutput + "default time-to-live:" + TAB + Str(ip\dwDefaultTTL) + EOL
    txtOutput = txtOutput + "datagrams received:" + TAB + Str(ip\dwInReceives) + EOL
    txtOutput = txtOutput + "received header errors:" + TAB + Str(ip\dwInHdrErrors) + EOL
    txtOutput = txtOutput + "received address errors:" + TAB + Str(ip\dwInAddrErrors) + EOL
    txtOutput = txtOutput + "datagrams forwarded:" + TAB + Str(ip\dwForwDatagrams) + EOL
    txtOutput = txtOutput + "datagrams with unknown protocol:" + TAB + Str(ip\dwInUnknownProtos) + EOL
    txtOutput = txtOutput + "received datagrams discarded:" + TAB + Str(ip\dwInDiscards) + EOL
    txtOutput = txtOutput + "received datagrams delivered:" + TAB + Str(ip\dwInDelivers) + EOL
    txtOutput = txtOutput + "outgoing datagrams requested:" + TAB + Str(ip\dwOutRequests) + EOL
    txtOutput = txtOutput + "outgoing datagrams discarded:" + TAB + Str(ip\dwRoutingDiscards) + EOL
    txtOutput = txtOutput + "sent datagrams discarded:" + TAB + Str(ip\dwOutDiscards) + EOL
    txtOutput = txtOutput + "datagrams for which no route:" + TAB + Str(ip\dwOutNoRoutes) + EOL
    txtOutput = txtOutput + "datagrams for which all frags didn't arrive:" + TAB + Str(ip\dwReasmTimeout) + EOL
    txtOutput = txtOutput + "datagrams requiring reassembly:" + TAB + Str(ip\dwReasmReqds) + EOL
    txtOutput = txtOutput + "successful reassemblies:" + TAB + Str(ip\dwReasmOks) + EOL
    txtOutput = txtOutput + "failed reassemblies:" + TAB + Str(ip\dwReasmFails) + EOL
    txtOutput = txtOutput + "successful fragmentations:" + TAB + Str(ip\dwFragOks) + EOL
    txtOutput = txtOutput + "failed fragmentations:" + TAB + Str(ip\dwFragFails) + EOL
    txtOutput = txtOutput + "datagrams fragmented:" + TAB + Str(ip\dwFragCreates) + EOL
    txtOutput = txtOutput + "number of interfaces on computer:" + TAB + Str(ip\dwNumIf) + EOL
    txtOutput = txtOutput + "number of IP address on computer:" + TAB + Str(ip\dwNumAddr) + EOL
    txtOutput = txtOutput + "number of routes in routing table:" + TAB + Str(ip\dwNumRoutes) + EOL
    txtOutput = txtOutput + EOL
  EndIf

  If GetTcpStatistics_(tcp)
    txtOutput = txtOutput + "Unable to retrieve TCP Statistics"
  Else
    txtOutput = txtOutput + "TCP Statistics" + EOL + "==============================" + EOL
    txtOutput = txtOutput + "timeout algorithm:" + TAB + Str(tcp\dwRtoAlgorithm) + EOL
    txtOutput = txtOutput + "minimum timeout:" + TAB + Str(tcp\dwRtoMin) + EOL
    txtOutput = txtOutput + "maximum timeout:" + TAB + Str(tcp\dwRtoMax) + EOL
    txtOutput = txtOutput + "maximum connections:" + TAB + Str(tcp\dwMaxConn) + EOL
    txtOutput = txtOutput + "active opens:" + TAB + Str(tcp\dwActiveOpens) + EOL
    txtOutput = txtOutput + "passive opens:" + TAB + Str(tcp\dwPassiveOpens) + EOL
    txtOutput = txtOutput + "failed attempts:" + TAB + Str(tcp\dwAttemptFails) + EOL
    txtOutput = txtOutput + "establised connections reset:" + TAB + Str(tcp\dwEstabResets) + EOL
    txtOutput = txtOutput + "established connections:" + TAB + Str(tcp\dwCurrEstab) + EOL
    txtOutput = txtOutput + "segments received:" + TAB + Str(tcp\dwInSegs) + EOL
    txtOutput = txtOutput + "segment sent:" + TAB + Str(tcp\dwOutSegs) + EOL
    txtOutput = txtOutput + "segments retransmitted:" + TAB + Str(tcp\dwRetransSegs) + EOL
    txtOutput = txtOutput + "incoming errors:" + TAB + Str(tcp\dwInErrs) + EOL
    txtOutput = txtOutput + "outgoing resets:" + TAB + Str(tcp\dwOutRsts) + EOL
    txtOutput = txtOutput + "cumulative connections:" + TAB + Str(tcp\dwNumConns) + EOL
    txtOutput = txtOutput + EOL
  EndIf

  If GetUdpStatistics_(udp)
    txtOutput = txtOutput + "Unable to retrieve UDP Statistics"
  Else
    txtOutput = txtOutput + "UDP Statistics" + EOL + "==============================" + EOL
    txtOutput = txtOutput + "received datagrams:" + TAB + Str(udp\dwInDatagrams) + EOL
    txtOutput = txtOutput + "datagrams for which no port:" + TAB + Str(udp\dwNoPorts) + EOL
    txtOutput = txtOutput + "errors on received datagrams:" + TAB + Str(udp\dwInErrors) + EOL
    txtOutput = txtOutput + "sent datagrams:" + TAB + Str(udp\dwOutDatagrams) + EOL
    txtOutput = txtOutput + "number of entries in UDP listener table:" + TAB + Str(udp\dwNumAddrs) + EOL
    txtOutput = txtOutput + EOL
  EndIf

  If GetIcmpStatistics_(icmp)
    txtOutput = txtOutput + "Unable to retrieve ICMP Statistics"
  Else
    txtOutput = txtOutput + "ICMP Statistics" + EOL + "==============================" + EOL
    txtOutput = txtOutput + "*****  In  *****" + EOL
    txtOutput = txtOutput + "number of messages:" + TAB + Str(icmp\icmpInStats\dwMsgs) + EOL
    txtOutput = txtOutput + "number of errors:" + TAB + Str(icmp\icmpInStats\dwErrors) + EOL
    txtOutput = txtOutput + "destination unreachable messages:" + TAB + Str(icmp\icmpInStats\dwDestUnreachs) + EOL
    txtOutput = txtOutput + "time-to-live exceeded messages:" + TAB + Str(icmp\icmpInStats\dwTimeExcds) + EOL
    txtOutput = txtOutput + "parameter problem messages:" + TAB + Str(icmp\icmpInStats\dwParmProbs) + EOL
    txtOutput = txtOutput + "source quench messages:" + TAB + Str(icmp\icmpInStats\dwSrcQuenchs) + EOL
    txtOutput = txtOutput + "redirection messages:" + TAB + Str(icmp\icmpInStats\dwRedirects) + EOL
    txtOutput = txtOutput + "echo requests:" + TAB + Str(icmp\icmpInStats\dwEchos) + EOL
    txtOutput = txtOutput + "echo replies:" + TAB + Str(icmp\icmpInStats\dwEchoReps) + EOL
    txtOutput = txtOutput + "timestamp requests:" + TAB + Str(icmp\icmpInStats\dwTimestamps) + EOL
    txtOutput = txtOutput + "timestamp replies:" + TAB + Str(icmp\icmpInStats\dwTimestampReps) + EOL
    txtOutput = txtOutput + "address mask requests:" + TAB + Str(icmp\icmpInStats\dwAddrMasks) + EOL
    txtOutput = txtOutput + "address mask replies:" + TAB + Str(icmp\icmpInStats\dwAddrMaskReps) + EOL
    txtOutput = txtOutput + EOL
    txtOutput = txtOutput + "*****  Out  *****" + EOL
    txtOutput = txtOutput + "number of messages:" + TAB + Str(icmp\icmpOutStats\dwMsgs) + EOL
    txtOutput = txtOutput + "number of errors:" + TAB + Str(icmp\icmpOutStats\dwErrors) + EOL
    txtOutput = txtOutput + "destination unreachable messages:" + TAB + Str(icmp\icmpOutStats\dwDestUnreachs) + EOL
    txtOutput = txtOutput + "time-to-live exceeded messages:" + TAB + Str(icmp\icmpOutStats\dwTimeExcds) + EOL
    txtOutput = txtOutput + "parameter problem messages:" + TAB + Str(icmp\icmpOutStats\dwParmProbs) + EOL
    txtOutput = txtOutput + "source quench messages:" + TAB + Str(icmp\icmpOutStats\dwSrcQuenchs) + EOL
    txtOutput = txtOutput + "redirection messages:" + TAB + Str(icmp\icmpOutStats\dwRedirects) + EOL
    txtOutput = txtOutput + "echo requests:" + TAB + Str(icmp\icmpOutStats\dwEchos) + EOL
    txtOutput = txtOutput + "echo replies:" + TAB + Str(icmp\icmpOutStats\dwEchoReps) + EOL
    txtOutput = txtOutput + "timestamp requests:" + TAB + Str(icmp\icmpOutStats\dwTimestamps) + EOL
    txtOutput = txtOutput + "timestamp replies:" + TAB + Str(icmp\icmpOutStats\dwTimestampReps) + EOL
    txtOutput = txtOutput + "address mask requests:" + TAB + Str(icmp\icmpOutStats\dwAddrMasks) + EOL
    txtOutput = txtOutput + "address mask replies:" + TAB + Str(icmp\icmpOutStats\dwAddrMaskReps) + EOL
    txtOutput = txtOutput + EOL
  EndIf
  ProcedureReturn txtOutput
EndProcedure

WindowXSize = 640
WindowYSize = 480
Quit = #False
If OpenWindow(#Window_Main, 0, 0, WindowXSize, WindowYSize, "NetStats", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
  AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Escape, #PB_Shortcut_Escape)
  If CreateGadgetList(WindowID(#Window_Main))
    EditorGadget (#Gadget_Editor, 10, 10, WindowXSize - 20, WindowYSize - 20, #PB_Container_Raised)
  EndIf
  SetGadgetText(#Gadget_Editor, Stats())
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Quit = #True
      Case #PB_Event_Menu
        Select EventMenu()
          Case #PB_Shortcut_Escape
            Quit = #True
        EndSelect
    EndSelect
  Until Quit
  CloseWindow(#Window_Main)
EndIf
TerminateProcess_(GetCurrentProcess_(), 0)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger