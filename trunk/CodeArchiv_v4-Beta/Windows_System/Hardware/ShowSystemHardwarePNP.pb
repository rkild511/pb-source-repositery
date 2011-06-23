; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1833&highlight=
; Author: bingo (updated for PB 4.00 by Andre)
; Date: 28. January 2005
; OS: Windows
; Demo: No

; Shows the system hardware by PBPs
; (active components from HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum)

; Macht anhand der PNPs die Hardware des Systemes "sichtbar": 
; (im Prinzip alles was unter HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum aktiv ist)

#DIGCF_PRESENT                     =   2 
#DIGCF_ALLCLASSES                  =   4 

hDeviceInfoSet = SetupDiGetClassDevs_(0,0,0,#DIGCF_PRESENT|#DIGCF_ALLCLASSES) 

Structure SP_DEVINFO_DATA 
  cbSize.l 
  ClassGuid.GUID 
  DevInst.l 
  Reserved.l 
EndStructure 

DeviceInfoData.SP_DEVINFO_DATA 

DeviceInfoData\cbSize=SizeOf(DeviceInfoData) 

i=0 
OpenLibrary(1,"cfgmgr32.dll") 
*F1 = GetFunction(1, "CM_Get_Device_IDA") 
Repeat 
If SetupDiEnumDeviceInfo_(hDeviceInfoSet,i,@DeviceInfoData) = 0 
Break 
EndIf 
i+1 
pnplen = 255 
pnp.s = Space(bufferlen) 
CallFunctionFast(*F1,DeviceInfoData\DevInst,@pnp,pnplen,0) 
Debug pnp 
ForEver 
CloseLibrary(1) 

SetupDiDestroyDeviceInfoList_(hDeviceInfoSet) 
 


; IDE Options = PureBasic v4.02 (Windows - x86)
; CursorPosition = 1
; Folding = -