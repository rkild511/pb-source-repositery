; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5278&highlight=
; Author: nochecker386
; Date: 10. August 2004
; OS: Windows
; Demo: No

 
; Get further informations about the signed on user of a workstation
; Weitere Angaben über einen angemeldeten Benutzer der Workstation herausfinden

Define.l lRetVal,lHKeyhandle,lhkey 
Define.s vValue 
#ERROR_NONE = 0 

Procedure.l QueryValueEx(lhkey.l,szValueName.s) 
  Define.l cch,lrc,lType,lValue 
  Define.s sValue  ;,vValue 
  Shared vValue.s
  cch=255 
  sValue=Space(255) 
  lrc=RegQueryValueEx_(lhkey,szValueName,0,@lType,0,@cch) 
  Select lType 
    Case #REG_SZ ;Für Strings 
      lrc=RegQueryValueEx_(lhkey,szValueName,0,@lType,@sValue,@cch) 
      If lrc=#ERROR_NONE: vValue=Left(sValue,cch-1): Else: vValue="Leer": EndIf 
    Case #REG_DWORD ;Für Dwords 
      lrc=RegQueryValueEx_(lhkey,szValueName,0,@lType,@lValue,@cch) 
      If lrc=#ERROR_NONE: vValue=Str(lValue): Else: vValue="Leer": EndIf 
    Default ;Für alle anderen 
      lrc=-1: vValue="Falscher Typ" 
  EndSelect 
  ProcedureReturn lrc 
EndProcedure 

Erstwert$="" 
If InitNetwork(): Erstwert$=Hostname(): EndIf 
Tester$=InputRequester("Computernamen eingeben","Bitte geben Sie einen Computernamen ein.",Erstwert$) 

lRetVal=RegConnectRegistry_(Tester$,#HKEY_LOCAL_MACHINE,@lHKeyhandle) 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"DefaultUserName") 
TesterUserName$=vValue 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"DefaultDomainName") 
TesterDomainName$=vValue 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"Productname") 
TesterOsName$=vValue 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"CurrentVersion") 
TesterOsVersion$=vValue 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"CSDVersion") 
TesterCSDVersion$=vValue 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"RegisteredOwner") 
TesterRegName$=vValue 
lRetVal=RegOpenKeyEx_(lHKeyhandle,"SOFTWARE\Microsoft\Windows NT\CurrentVersion",0,#KEY_ALL_ACCESS,@lhkey) 
lRetVal=QueryValueEx(lhkey,"RegisteredOrganization") 
TesterRegOrg$=vValue 
RegCloseKey_(lhkey) 

If Tester$="": Informcomp$="Informationen über lokalen PC": Else: Informcomp$="Informationen über "+Tester$: EndIf 

Infogreat$="--- Benutzerinformationen ---"+Chr(10)+Chr(10) 
Infogreat$=Infogreat$+"Benutzername: "+Chr(9)+TesterUserName$+Chr(10) 
Infogreat$=Infogreat$+"Anmeldedomäne: "+Chr(9)+TesterDomainName$+Chr(10)+Chr(10) 
Infogreat$=Infogreat$+"--- Betriebssysteminformationen ---"+Chr(10)+Chr(10) 
Infogreat$=Infogreat$+"Betriebssystem: "+Chr(9)+TesterOsName$+" ["+TesterOsVersion$+"] - "+TesterCSDVersion$+Chr(10) 
Infogreat$=Infogreat$+"Registriert auf: "+Chr(9)+TesterRegName$+" - "+TesterRegOrg$+Chr(10)+Chr(10) 

MessageRequester(Informcomp$,Infogreat$,#MB_ICONINFORMATION) 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -