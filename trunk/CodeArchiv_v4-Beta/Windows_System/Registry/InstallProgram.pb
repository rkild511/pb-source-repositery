; www.purearea.net (Sourcecode collection by cnesm)
; Author: Manne (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No


; Author: Manne 
; Date: 30. March 2003 
; PrgName: SoftwareInventory 


;- Deklaration der Variablen 
Define.s NodeName, cName, OutDir, OutFile, tOutFile, columnheadings, sName, Subkey, zeile, datum 
Define.l check, hkey, Cnt, pos, lpdwDisposition 
Global NewList subName.s() 

;- Zuweisen der Werte 
#BUFFER_SIZE = 255 
NodeName = Space(256) 
cName = "COMPUTERNAME" 
columnheadings = "NodeName,DisplayName,Description,Publisher,sVersion,ProductID" 
Subkey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" 
OutDir = "C:\" 
hkey = 0 

;- Deklaration der Proceduren 
Procedure.s ExePath() 
  tmp$ = Space(1000) 
  GetModuleFileName_(0,@tmp$,1000) 
  ProcedureReturn GetPathPart(tmp$) 
EndProcedure 

Procedure.s ReadRegKey(OpenKey.l,Subkey.s,ValueName.s) 
  hkey.l=0 
  keyvalue.s=Space(255) 
  datasize.l=255 
  
  If RegOpenKeyEx_(OpenKey,Subkey,0,#KEY_READ,@hkey) 
    MessageBeep_(#MB_ICONEXCLAMATION) 
    End 
  Else 
    If RegQueryValueEx_(hkey,ValueName,0,0,@keyvalue,@datasize) 
        keyvalue = "" 
    Else  
        keyvalue=Left(keyvalue,datasize-1) 
    EndIf 
    RegCloseKey_(hkey) 
  EndIf 
    
  ProcedureReturn keyvalue 
EndProcedure  

;- Mainprogramm Registry bearbeiten, Ziel-File schreiben u.a. 
GetEnvironmentVariable_(cName, NodeName, 256) 

If NodeName = "" 
  End 
EndIf 

tOutFile = ExePath() + "tmp" + ".csv" 
OutFile = OutDir + NodeName + ".csv" 


check = CreateFile(0, tOutFile) 
WriteStringN(0,columnheadings) 

RegCreateKeyEx_(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\a", 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_CREATE_SUB_KEY, 0, @hkey, @lpdwDisposition) 
        
    If RegOpenKey_(#HKEY_LOCAL_MACHINE, Subkey, @hkey) = 0          
;       ;Enumerate the keys 
        While RegEnumKeyEx_(hkey, Cnt, sName.s, @Ret, 0, 0, 0, 0) <> #ERROR_NO_MORE_ITEMS 
            Cnt = Cnt + 1 
            AddElement(subName()) 
            subName() = sName 
            sName = Space(#BUFFER_SIZE) 
            Ret.l= #BUFFER_SIZE 
        Wend 
    Else 
        WriteString(0,"Fehler, konnte Registrierung nicht öffnen!") 
    EndIf        
RegCloseKey_(hkey) 

pos = 1 

While pos <= Cnt - 1 
  SelectElement(subName(), pos) 

  DisplayName.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\"+ subName(), "DisplayName") 
  Description.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\"+ subName(), "Comments") 
  Publisher.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\"+ subName(), "Publisher") 
  sVersion.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\"+ subName(), "DisplayVersion") 
  ProductID.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\"+ subName(), "ProductID") 

  If DisplayName = "" 
    DisplayName = subName() 
  EndIf 

  zeile = NodeName + "," + DisplayName + "," + Description + "," + Publisher + "," + sVersion + "," + ProductID 
  WriteStringN(0,zeile) 

  pos = pos + 1 
Wend 

datum = FormatDate("%dd.%mm.%yyyy", Date()) 
WriteStringN(0,"") 
WriteStringN(0,"SoftwareInventory vom "+ datum) 
CloseFile(0) 

RegDeleteKey_(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Uninstall\a") 

CopyFile(tOutFile, OutFile) 
DeleteFile(tOutFile) 

End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -