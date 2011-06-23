; German forum: http://www.purebasic.fr/german/viewtopic.php?t=8673&start=380
; Author: Thorsten1867
; Date: 24. January 2007
; OS: Windows
; Demo: No


; Set standard UnInstaller - entry on Windows
; Standard UnInstaller - Eintrag von Windows setzen

Procedure SetUninstall(keyname$, GUID$, name$,  pub$, url$, email$, dicon$, uexe$) 
  If GUID$ : Key$ = GUID$ : Else : Key$ = keyname$ : EndIf 
  uKey=0 
  If RegCreateKey_(#HKEY_LOCAL_MACHINE,"Software\Microsoft\Windows\CurrentVersion\Uninstall\"+Key$,@uKey)=0 
    RegSetValueEx_(uKey,"DisplayName",0,#REG_SZ,@name$,Len(name$)+1) 
    RegSetValueEx_(uKey,"DisplayIcon",0,#REG_SZ,@dicon$,Len(dicon$)+1) 
    RegSetValueEx_(uKey,"Publisher",0,#REG_SZ,@pub$,Len(pub$)+1) 
    RegSetValueEx_(uKey,"URLInfoAbout",0,#REG_SZ,@url$,Len(url$)+1) 
    RegSetValueEx_(uKey,"HelpLink",0,#REG_SZ,@url$,Len(url$)+1) 
    RegSetValueEx_(uKey,"Contact",0,#REG_SZ,@email$,Len(email$)+1) 
    RegSetValueEx_(uKey,"UninstallString",0,#REG_SZ,@uexe$,Len(uexe$)+1) 
    RegCloseKey_(uKey) 
  EndIf 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP