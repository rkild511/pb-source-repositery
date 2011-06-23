; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7347 
; Author: AngelSoul (updated for PB 4.00 by ts-soft)
; Date: 26. August 2003 
; OS: Windows
; Demo: No

; List adapters with their respective IPs 
Declare GetAdaptersInfo() 
Structure IP_ADDR_STRING 
  Nxt.l 
  IP.b[16] 
  mask.b[16] 
  Context.l 
EndStructure 

Structure IP_ADAPTER_INFO 
  Nxt.l 
  ComboIndex.l 
  AdapterName.b[260] 
  Description.b[132] 
  AddressLength.l 
  Adr.b[8] 
  Index.l 
  Type.l 
  DhcpEnabled.l 
  CurrentIpAddress.l 
  IpAddressList.IP_ADDR_STRING 
  GatewayList.IP_ADDR_STRING 
  DhcpServer.IP_ADDR_STRING 
  HaveWins.w 
  PrimaryWinsServer.IP_ADDR_STRING 
  SecondaryWinsServer.IP_ADDR_STRING 
  LeaseObtained.l 
  LeaseExpires.l 
EndStructure 

Structure FIXED_INFO 
  HostName.b[132] 
  DomainName.b[132] 
  CurrentDnsServer.l 
  DnsServerList.IP_ADDR_STRING 
  NodeType.l 
  ScopeId.b[260] 
  EnableRouting.l 
  EnableProxy.l 
  EnableDns.l 
EndStructure 

Structure IP_INFO 
  AdapterName.s 
  IP.s 
  AdapterType.l 
  AdapterTypeDesc.s 
EndStructure 

Global Dim Adapters.IP_INFO(10) 

GetAdaptersInfo() 
If Total=-1:MessageRequester("Error","An error occured accessing adapter info",0):End:EndIf 
For gg=1 To Total 
  Debug "Adapter: "+Adapters(gg)\AdapterName 
  Debug "Type: "+Adapters(gg)\AdapterTypeDesc 
  Debug "IP: "+Adapters(gg)\IP 
  Debug Adapters(gg)\AdapterType 
  Debug "" 
Next 

End 




Procedure GetAdaptersInfo() 
  Shared Total 
  
  res=GetNetworkParams_(0,@FixedInfoSize.l) 
  If res<>0 
    If res<>#ERROR_BUFFER_OVERFLOW 
      Total=-1:ProcedureReturn 
      End 
    EndIf 
  EndIf 
  Dim FixedInfoBuffer.b(FixedInfoSize-1) 
  res = GetNetworkParams_(@FixedInfoBuffer(0), @FixedInfoSize) 
  If res=0 
    CopyMemory(@FixedInfoBuffer(0),@FixedInfo.FIXED_INFO,SizeOf(FIXED_INFO)) 
    Hostname$=PeekS(@FixedInfo\HostName) 
    DNSServer$=PeekS(@FixedInfo\DnsServerList\IP) 
    pAddrStr.l=@FixedInfo\DnsServerList\Nxt 
    Repeat 
      CopyMemory(pAddrStr,@Buffer.IP_ADDR_STRING,SizeOf(IP_ADDR_STRING)) 
      pAddrStr =Buffer\Nxt 
    Until pAddrStr=0 
  EndIf 
  
  AdapterInfoSize.l=0 
  res=GetAdaptersInfo_(0, @AdapterInfoSize) 
  If res<>0 
    If res<>#ERROR_BUFFER_OVERFLOW 
      Total=-1:ProcedureReturn 
    EndIf 
  EndIf 
  Dim AdapterInfoBuffer.b(AdapterInfoSize - 1) ;OK 
  res=GetAdaptersInfo_(@AdapterInfoBuffer(0), @AdapterInfoSize.l) ;OK 
  
  CopyMemory(@AdapterInfoBuffer(0),@AdapterInfo.IP_ADAPTER_INFO,SizeOf(IP_ADAPTER_INFO)) 
  pAdapt=AdapterInfo\Nxt 
  
  Repeat 
    CopyMemory(@AdapterInfo,@Buffer2.IP_ADAPTER_INFO,SizeOf(IP_ADAPTER_INFO)) 
    Select Buffer2\Type 
      Case 1:AdType$="Ethernet Adapter" 
      Case 2:AdType$="Token Ring Adapter" 
      Case 3:AdType$="FDDI Adapter" 
      Case 4:AdType$="PPP Adapter" 
      Case 5:AdType$="Loopback Adapter" 
      Case 6:AdType$="Slip Adapter" 
      Case 23:AdType$="PPPoE Adapter" 
      Default:AdType$="Unknown Adapter" 
    EndSelect 
    
    
    pAddrStr=Buffer2\IpAddressList\Nxt 
    Repeat 
      CopyMemory(@Buffer2\IpAddressList,@Buffer,SizeOf(IP_ADDR_STRING)) 
      Total=Total+1 
      Adapters(Total)\AdapterName=PeekS(@Buffer2\Description) 
      Adapters(Total)\AdapterType=Buffer2\Type 
      Adapters(Total)\IP=PeekS(@Buffer\IP) 
      Adapters(Total)\AdapterTypeDesc=AdType$ 
      pAddrStr=Buffer\Nxt 
      If pAddrStr<>0:CopyMemory(pAddrStr,@Buffer2\GatewayList,SizeOf(IP_ADDR_STRING)):EndIf 
    Until pAddrStr=0 
    
    pAdapt=Buffer2\Nxt 
    If pAdapt<>0:CopyMemory(pAdapt,@AdapterInfo,SizeOf(IP_ADAPTER_INFO)):EndIf 
    
  Until pAdapt=0 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
