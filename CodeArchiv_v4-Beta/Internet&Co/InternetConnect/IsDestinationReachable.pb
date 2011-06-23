; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1654&highlight=
; Author: Danilo + ChipMunk
; Date: 09. July 2003
; OS: Windows
; Demo: No

#NETWORK_ALIVE_AOL = $4 
#NETWORK_ALIVE_LAN = $1 
#NETWORK_ALIVE_WAN = $2 

Structure QOCINFO 
    dwSize.l     ; As Long 
    dwFlags.l    ; As Long 
    dwInSpeed.l  ; As Long 'in bytes/second 
    dwOutSpeed.l ; As Long 'in bytes/second 
EndStructure 

Procedure IsDestinationReachable(lpszDestination.s,*lpQOCInfo.QOCINFO) 
  hLib = LoadLibrary_("SENSAPI.DLL") 
  If hLib 
    hProc = GetProcAddress_(hLib,"IsDestinationReachableA") 
    If hProc 
      ProcedureReturn CallFunctionFast(hProc,lpszDestination,*lpQOCInfo) 
    EndIf 
    FreeLibrary_(hLib) 
  EndIf 
EndProcedure 

; 
; KPD-Team 2001 
; URL: http://www.allapi.net/ 
; E-Mail: KPDTeam@Allapi.net 
; 
; PureBasic-Translation 
; by Danilo, 09.07.2003 
; 
Ret.QOCINFO 
Ret\dwSize = SizeOf(QOCINFO) 

CrLf.s = Chr(13)+Chr(10) 

If IsDestinationReachable("www.PureBasic.com",Ret) = 0 
  MessageRequester("ERROR","The destination cannot be reached!",#MB_ICONERROR) 
Else 
  MessageRequester("INFO","The destination can be reached!"+CrLf+"The speed of data coming in from the destination is "+StrU(Ret\dwInSpeed/1024,#Long)+".0 Kb/s,"+CrLf+"and the speed of Data sent To the destination is "+StrU(Ret\dwOutSpeed/1024,#Long)+".0 Kb/s.",#MB_ICONINFORMATION) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
