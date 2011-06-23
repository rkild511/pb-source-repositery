; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7194&highlight=
; Author: Flype
; Date: 13. August 2003
; OS: Windows
; Demo: No

; Get the IP address associated with a machine connected to a PureBasic server socket.
; This code make use of the API win32 and the IPHlpApi lib.

#MAX_IP = 5

Structure IPINFO
  dwAddr.l
  dwIndex.l
  dwBCastAddr.l
  dwReasmSize.l
  unused1.l
  unused2.l
EndStructure

Structure MIB_IPADDRTABLE
  dwEntries.l
  mIPInfo.IPINFO[ #MAX_IP ]
EndStructure

; #TRUE or #FALSE --> Sort the ip table or not !

Ret.l
GetIpAddrTable_( #Null, @Ret, #True )
GetIpAddrTable_( @test.MIB_IPADDRTABLE , @Ret, #True )

For i=0 To test\dwEntries - 1
  
  Debug IPString( test\mIPInfo[i]\dwAddr )
  Debug Hex( test\mIPInfo[i]\dwBCastAddr )
  Debug test\mIPInfo[i]\dwReasmSize
  Debug "---------------------------------"
  
Next

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
