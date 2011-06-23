; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2477&start=20
; Author: DataMiner (updated for PB 4.00 by Andre)
; Date: 10. April 2005
; OS: Windows
; Demo: No


;- KONSTANTEN  STRUKTUREN  PROZEDUREN 
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
#wbemFlagReturnImmediately=16 
#wbemFlagForwardOnly=32 
#IFlags = #wbemFlagReturnImmediately + #wbemFlagForwardOnly 
#WBEM_INFINITE=$FFFFFFFF 

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

Procedure bstr2string (bstr) 
  Shared result.s 
  result.s = "" 
  pos=bstr 
  While PeekW (pos) 
    result=result+Chr(PeekW(pos)) 
    pos=pos+2 
  Wend 
  ProcedureReturn @result 
EndProcedure 

;- WMI 

; --- Step 1: Initialize COM parameters with a call to CoInitializeEx 
CoInitializeEx_(0,#COINIT_MULTITHREAD) 
  
  ; --- Step 2: Initialize COM process security by calling CoInitializeSecurity. 

hres=CoInitializeSecurity_(0, -1,0,0,#RPC_C_AUTHN_LEVEL_CONNECT,#RPC_C_IMP_LEVEL_IDENTIFY,0,#EOAC_NONE,0) 
If hres <> 0: MessageRequester("ERROR", "unable to call CoInitializeSecurity", #MB_OK): Goto cleanup: EndIf 

  ; --- Step 3: Obtain the initial locator to WMI by calling CoCreateInstance. 

hres=CoCreateInstance_(?CLSID_WbemLocator,0,#CLSCTX_INPROC_SERVER,?IID_IWbemLocator,@loc.IWbemLocator) 
If hres <> 0: MessageRequester("ERROR", "unable to call CoCreateInstance", #MB_OK): Goto cleanup: EndIf  

  ; --- Step 4: Obtain a pointer to IWbemServices for the root\cimv2 namespace on the local computer by calling IWbemLocator::ConnectServer. 

hres=loc\ConnectServer(ansi2bstr("root\cimv2"),0,0,0,0,0,0,@svc.IWbemServices) 
If hres <> 0: MessageRequester("ERROR", "unable to call IWbemLocator::ConnectServer", #MB_OK): Goto cleanup: EndIf  
hres=svc\queryinterface(?IID_IUnknown,@pUnk.IUnknown) 
  
  ; --- Step 5: Set IWbemServices proxy security so the WMI service can impersonate the client by calling CoSetProxyBlanket. 

hres=CoSetProxyBlanket_(svc,#RPC_C_AUTHN_WINNT,#RPC_C_AUTHZ_NONE,0,#RPC_C_AUTHN_LEVEL_CALL,#RPC_C_IMP_LEVEL_IMPERSONATE,0,#EOAC_NONE) 
If hres <> 0: MessageRequester("ERROR", "unable to call CoSetProxyBlanket", #MB_OK): Goto cleanup: EndIf  
hres=CoSetProxyBlanket_(pUnk,#RPC_C_AUTHN_WINNT,#RPC_C_AUTHZ_NONE,0,#RPC_C_AUTHN_LEVEL_CALL,#RPC_C_IMP_LEVEL_IMPERSONATE,0,#EOAC_NONE) 
If hres <> 0: MessageRequester("ERROR", "unable to call CoSetProxyBlanket", #MB_OK): Goto cleanup: EndIf  
pUnk\release() 
  
  ; --- Step 6: Use the IWbemServices pointer to make requests of WMI. This example executes a query for the name of the operating system by calling 
  ; ---             IWbemServices::ExecQuery And passing in the following WQL query as one of the method arguments: 
  ; ---                                                    Select * FROM Win32_OperatingSystem 
  ; ---             The result of this query is stored in an IEnumWbemClassObject pointer. This allows the data objects from 
  ; ---             the query to be retrieved semisynchronously with the IEnumWbemClassObject Interface. 

hres=svc\ExecQuery(ansi2bstr("WQL"),ansi2bstr("SELECT * FROM Win32_OperatingSystem"), #IFlags,0,@pEnumerator.IEnumWbemClassObject) 
If hres <> 0: MessageRequester("ERROR", "unable to call IWbemServices::ExecQuery", #MB_OK): Goto cleanup: EndIf  

  ; --- Step 7: Get and display the data from the WQL query. The IEnumWbemClassObject pointer is linked to the data objects that the query returned, 
  ; ---            and the data objects can be retrieved with the IEnumWbemClassObject::Next method. This method links the data objects to an IWbemClassObject pointer 
  ; ---            that is passed into the method. Use the IWbemClassObject::Get method to get the desired information from the data objects. 
  ; ---            In this example, the name of the operating system is the desired information. 

mem=AllocateMemory(1000) 
hres=pEnumerator\reset() 

Repeat 

  hres=pEnumerator\Next(#WBEM_INFINITE, 1, @pclsObj.IWbemClassObject, @uReturn) 
hres=pclsObj\get(ansi2bstr("Name"), 0, mem, 0, 0) 

type=PeekW(mem) 

Select type 
  Case 8 
    val.s=PeekS(bstr2string(PeekL(mem+8))) 
  Case 3 
    val.s=Str(PeekL(mem+8)) 
  Default 
    val.s="" 
EndSelect 

If uReturn <> 0: MessageRequester("WMI-Message:", val, #MB_OK): EndIf 

Until uReturn = 0 

; --- Step 8: Cleanup 
cleanup: 
svc\release() 
loc\release() 
pEnumerator\release() 
pclsObj\release() 
CoUninitialize_() 

End 

;- DATA 
DataSection 
CLSID_IEnumWbemClassObject: 
   ;1B1CAD8C-2DAB-11D2-B604-00104B703EFD 
Data.l $1B1CAD8C 
Data.w $2DAB, $11D2 
Data.b $B6, $04, $00, $10, $4B, $70, $3E, $FD 
IID_IEnumWbemClassObject: 
   ;7C857801-7381-11CF-884D-00AA004B2E24 
Data.l $7C857801 
Data.w $7381, $11CF 
Data.b $88, $4D, $00, $AA, $00, $4B, $2E, $24 
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