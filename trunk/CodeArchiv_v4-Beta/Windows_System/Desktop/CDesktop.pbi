; www.PureArea.net
; Author: DNA
; Date: 14. December 2006
; OS: Windows
; Demo: No


; Written and tested on WinXP Home
; 
; Nutzung des Codes auf eigene Gefahr
; Autor haften nicht bei Schäden
;
; Code darf nicht für Viren oder andere schädliche Programme genutzt werden
; Ebenso nicht für kommerziellen Dingen, ansonsten steht der Code jedem frei

m_hDesktopThreadOld = GetThreadDesktop_(GetCurrentThreadId_())
m_hDesktopInputOld = OpenInputDesktop_(0, #False, #DESKTOP_SWITCHDESKTOP)

; #########################  Definitionen  ###########################

Interface I_Desktop
  KillDesktop()
  CreateDesktop(sDesktopName.s)
  StartProcess(sPath.s)
EndInterface

Structure Desktop_Function
  KillDesktop.l
  CreateDesktop.l
  StartProcess.l
EndStructure

Structure DesktopObjekt
  *VT.Desktop_Function
  m_sDesktop.s
  m_hDesktopThreadOld.l
  m_hDesktopInputOld.l
  m_hDesktop.l  
EndStructure

; ###########################  Methoden  #############################

Procedure KillDesktop(*obj.DesktopObjekt)
  If *obj\m_hDesktopInputOld <> 0
    ;SwitchDesktop_(*obj\m_hDesktopInputOld)
    SwitchDesktop_(m_hDesktopInputOld)
    *obj\m_hDesktopInputOld = 0
  EndIf
  If *obj\m_hDesktopThreadOld <> 0
    ;SetThreadDesktop_(*obj\m_hDesktopThreadOld)
    SetThreadDesktop_(m_hDesktopThreadOld)
    *obj\m_hDesktopThreadOld = 0
  EndIf
  If *obj\m_hDesktop <> 0
    CloseDesktop_(*obj\m_hDesktop)
    *obj\m_hDesktop = 0
  EndIf
EndProcedure

Procedure CreateDesktop(*obj.DesktopObjekt, sDesktopName.s)
  ;Protected lR.l

  ; aktuellen DesktopThread und Input auslesen und merken

  *obj\m_hDesktopThreadOld = GetThreadDesktop_(GetCurrentThreadId_())
  If *obj\m_hDesktopThreadOld = 0
    Debug "Fehler - konnte Thread vom Desktop nicht ermitteln"
  EndIf
  *obj\m_hDesktopInputOld = OpenInputDesktop_(0, #False, #DESKTOP_SWITCHDESKTOP)
  If *obj\m_hDesktopInputOld = 0
    Debug "Fehler - konnte keinen Input öffnen"
  EndIf
  
  ;hier nun einen neuen Desktop erstellen und darauf wechseln
  *obj\m_hDesktop = CreateDesktop_(@sDesktopName, 0, 0, 0, #GENERIC_ALL, 0)

  If *obj\m_hDesktop = 0
    Debug "Fehler - konnte kein neues Desktop erstellen"
  Else
    ;lR = SetThreadDesktop_(*obj\m_hDesktop)
    ;lR = SwitchDesktop_(*obj\m_hDesktop)
    *obj\m_sDesktop = sDesktopName
  EndIf
EndProcedure

Procedure StartProcess(*obj.DesktopObjekt, sPath.s)
  Protected tSi.STARTUPINFO
  Protected tPi.PROCESS_INFORMATION
  Protected lR.l
  Protected ExitCode
  
  ; den vorgegebenen Prozess auf dem neuen Desktop starten
  ; und warten bis dieser beendet wird

  tSi\cb = SizeOf(tSi)
  tSi\lpTitle = @*obj\m_sDesktop
  tSi\lpDesktop = @*obj\m_sDesktop

  lR = CreateProcess_(0, sPath, 0, #Null, 1, 0, 0, #Null, @tSi, @tPi)
  If lR = 0
    Debug "Ein Fehler ist aufgetreten beim erstellen eines Prozesses"
    ; desktop schließen und zum alten welchseln
    KillDesktop(*obj)
  Else
  ; Wenn die nächste Zeile nicht mehr auskommentiert ist,
  ; kann jeweils immer nur ein Desktop erstellt werden
  
;    WaitForSingleObject_(tPi\hProcess, #INFINITE)
    CloseHandle_(tPi\hProcess)
    CloseHandle_(tPi\hThread)
    
    ;da der Prozess beendet wurde, Desktop löschen und zum alten wechseln
    KillDesktop(*obj)
  EndIf
EndProcedure

; ############################# Objekt ###############################

Structure DesktopHolder
  VT.Desktop_Function
  Impl.DesktopObjekt
EndStructure

Global NewList Instances.DesktopHolder()

Procedure.l createObject()
  AddElement(Instances())
  
  Instances()\VT\KillDesktop = @KillDesktop()
  Instances()\VT\CreateDesktop = @CreateDesktop()
  Instances()\VT\StartProcess = @StartProcess()

  Instances()\Impl\VT = Instances()\VT
  
  Instances()\Impl\m_sDesktop = ""
  Instances()\Impl\m_hDesktopThreadOld = 0
  Instances()\Impl\m_hDesktopInputOld = 0
  Instances()\Impl\m_hDesktop = 0
  
  ProcedureReturn Instances()\Impl
EndProcedure

Procedure deleteObject(Objekt)
  ResetList(Instances())
  While NextElement(Instances())
    If Objekt = Instances()\Impl
      DeleteElement(Instances())
      Break
    EndIf
  Wend
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = g