; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2477&highlight=
; Author: bingo (updated for PB 4.00 by Andre)
; Date: 20. March 2005
; OS: Windows
; Demo: No


; Tested under WinXP, don't run under Win2000!

; Example for using WMI to get the PNP's (PNPDeviceID)
; here displaying Gfx card details

#COINIT_MULTITHREAD=0 
#RPC_C_AUTHN_LEVEL_CONNECT=2 
#RPC_C_IMP_LEVEL_IDENTIFY=2 
#EOAC_NONE=0 
#RPC_C_AUTHN_WINNT=10 
#RPC_C_AUTHZ_NONE=0 
#RPC_C_AUTHN_LEVEL_CALL=3 
#RPC_C_IMP_LEVEL_IMPERSONATE=3 
#CLSCTX_INPROC_SERVER=1 
#WBEM_S_NO_ERROR = 0 

; Structure d 
;   l.l 
;   h.l 
; EndStructure 

Procedure.l ansi2bstr(ansi.s) 
  size.l=MultiByteToWideChar_(#CP_ACP,0,ansi,-1,0,0) 
  Dim unicode.w(size) 
  MultiByteToWideChar_(#CP_ACP, 0, ansi, Len(ansi), unicode(), size) 
  ProcedureReturn SysAllocString_(@unicode()) 
EndProcedure 

Procedure.s unicode2ansi(mem) 
  ansi.s="" 
  Repeat 
    a=PeekW(mem) 
    ansi=ansi+Chr(a) 
    mem+2 
  Until a=0 
  ProcedureReturn ansi 
EndProcedure 

CoInitializeEx_(0,#COINIT_MULTITHREAD) 
hres=CoInitializeSecurity_(0, -1,0,0,#RPC_C_AUTHN_LEVEL_CONNECT,#RPC_C_IMP_LEVEL_IDENTIFY,0,#EOAC_NONE,0) 
hres=CoCreateInstance_(?CLSID_WbemLocator,0,#CLSCTX_INPROC_SERVER,?IID_IWbemLocator,@loc.IWbemLocator) 
hres=loc\ConnectServer(ansi2bstr("root\cimv2"),0,0,0,0,0,0,@svc.IWbemServices) 
hres=svc\queryinterface(?IID_IUnknown,@pUnk.IUnknown) 
hres=CoSetProxyBlanket_(svc,#RPC_C_AUTHN_WINNT,#RPC_C_AUTHZ_NONE,0,#RPC_C_AUTHN_LEVEL_CALL,#RPC_C_IMP_LEVEL_IMPERSONATE,0,#EOAC_NONE) 
hres=CoSetProxyBlanket_(pUnk,#RPC_C_AUTHN_WINNT,#RPC_C_AUTHZ_NONE,0,#RPC_C_AUTHN_LEVEL_CALL,#RPC_C_IMP_LEVEL_IMPERSONATE,0,#EOAC_NONE) 
pUnk\release() 
hres=CoCreateInstance_(?CLSID_WbemRefresher,0,#CLSCTX_INPROC_SERVER,?IID_IWbemRefresher,@pRefresher.IWbemRefresher) 
hres=pRefresher\queryinterface(?IID_IWbemConfigureRefresher,@pConfig.IWbemConfigureRefresher) 
hres=pConfig\AddEnum(svc,ansi2bstr("Win32_VideoController"),0,0,@penum.IWbemHiPerfEnum,@id) 
pConfig\release() 
Dim tab.IWbemObjectAccess(300) 
For x=1 To 2 
pRefresher\refresh(0) 
hres=penum\GetObjects(0,100*SizeOf(IWbemObjectAccess),@tab(),@retour.l) 
If x=1 
  hres=tab(0)\GetPropertyHandle(ansi2bstr("Caption"),0,@caption) 
  hres=tab(0)\GetPropertyHandle(ansi2bstr("AdapterDACType"),0,@AdapterDACType) 
  hres=tab(0)\GetPropertyHandle(ansi2bstr("VideoProcessor"),0,@VideoProcessor) 
  hres=tab(0)\GetPropertyHandle(ansi2bstr("CurrentRefreshRate"),0,@CurrentRefreshRate) 
EndIf 
If x>1 

*MemoryID = AllocateMemory(500) 

For i=0 To retour-1 
  tab(i)\Readpropertyvalue(caption,500,@len,*MemoryID) 
  Debug "Name:" 
  Debug unicode2ansi(*MemoryID) 
  Debug ""
  tab(i)\Readpropertyvalue(AdapterDACType,500,@len,*MemoryID) 
  Debug "AdapterDACType:"
  Debug unicode2ansi(*MemoryID) 
  Debug ""
  tab(i)\Readpropertyvalue(VideoProcessor,500,@len,*MemoryID) 
  Debug "VideoProcessor:"
  Debug unicode2ansi(*MemoryID) 
  Debug ""
  tab(0)\ReadDWORD(CurrentRefreshRate,@rr) 
  Debug "CurrentRefreshRate:"
  Debug rr 
  tab(i)\release() 
Next i 

FreeMemory(*MemoryID) 

EndIf 
Delay(100) 
Next 
penum\release() 
pRefresher\release(); 
svc\release() 
loc\release() 
CoUninitialize_() 
End 

DataSection 

CLSID_WbemLocator: 
    ;4590f811-1d3a-11d0-891f-00aa004b2e24 
Data.l $4590F811 
Data.w $1D3A, $11D0 
Data.b $89, $1F, $00, $AA, $00, $4B, $2E, $24 
IID_IWbemLocator: 
    ;dc12a687-737f-11cf-884d-00aa004b2e24 
Data.l $DC12A687 
Data.w $737F, $11CF 
Data.b $88, $4D, $00, $AA, $00, $4B, $2E, $24 
IID_IUnknown: 
    ;00000000-0000-0000-C000-000000000046 
Data.l $00000000 
Data.w $0000, $0000 
Data.b $C0, $00, $00, $00, $00, $00, $00, $46 
IID_IWbemRefresher: 
;49353c99-516b-11d1-aea6-00c04fb68820 
Data.l $49353C99 
Data.w $516B, $11D1 
Data.b $AE, $A6, $00, $C0, $4F, $B6, $88, $20 
CLSID_WbemRefresher: 
;c71566f2-561E-11D1-AD87-00C04FD8FDFF 
Data.l $C71566F2 
Data.w $561E, $11D1 
Data.b $AD,$87,$00,$C0,$4F,$D8,$FD,$FF 
IID_IWbemConfigureRefresher: 
;49353c92-516b-11d1-aea6-00c04fb68820 
Data.l $49353C92 
Data.w $516B, $11D1 
Data.b $AE, $A6, $00, $C0, $4F, $B6, $88, $20 
IID_IWbemObjectAccess: 
;49353c9a-516b-11d1-aea6-00c04fb68820 
Data.l $49353C9A 
Data.w $516B, $11D1 
Data.b $AE, $A6, $00, $C0, $4F, $B6, $88, $20 

EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -