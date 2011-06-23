; English forum: 
; Author: Richard Eikeland (updated for PB3.93 by ts-soft, updated + fixed for PB4.00 by Frank Zehner)
; Date: 12. April 2003
; OS: Windows
; Demo: No


; Apr. 12, 2003
; Converted to PB by Richard Eikeland
; This code is posted as is with out any waranties.
;

; Aug. 17, 2006
; Some fixes by Frank Zehner

EnableExplicit

Global ServiceStatus.SERVICE_STATUS
Global hServiceStatus.l
Global ServiceName.s
Global LogFile.s
Global Finish.l

Declare Handler(fdwControl.l)
Declare ServiceMain(dwArgc.l, lpszArgv.l)
Declare WriteLog(Value.s)

Procedure Main()
  Dim ServiceTableEntry.SERVICE_TABLE_ENTRY(1)
  Define hSCManager.l
  Define hService.l
  Define AppPath.s
  Define *sname.s
  Define cmd.s
  Define b.l
  
  ;Change ServiceName as needed
  ;AppPath = "C:\Temp\MyService.exe"
  AppPath = ProgramFilename()
  LogFile = GetPathPart(AppPath) + ReplaceString(GetFilePart(AppPath), ".exe",".log")
  ServiceName = "MyService"
  
  cmd = Trim(LCase(ProgramParameter()))
  Select cmd
    Case "install" ;Install service on machine
      hSCManager = OpenSCManager_(0, 0, #SC_MANAGER_CREATE_SERVICE)
      hService = CreateService_(hSCManager, ServiceName, ServiceName, #SERVICE_ALL_ACCESS, #SERVICE_WIN32_OWN_PROCESS, #SERVICE_DEMAND_START, #SERVICE_ERROR_NORMAL, AppPath, 0, 0, 0, 0, 0)
      CloseServiceHandle_(hService)
      CloseServiceHandle_(hSCManager)
      WriteLog("Service installed")
    Case "uninstall" ;Remove service from machine
      hSCManager = OpenSCManager_(0, 0, #SC_MANAGER_CREATE_SERVICE)
      hService = OpenService_(hSCManager, ServiceName, #SERVICE_ALL_ACCESS)
      DeleteService_(hService)
      CloseServiceHandle_(hService)
      CloseServiceHandle_(hSCManager)
      WriteLog("Service uninstalled")
    Default      ;Start the service
      Finish = 0
      *sname = ServiceName
      ServiceTableEntry(0)\lpServiceName = @ServiceName
      ServiceTableEntry(0)\lpServiceProc = @ServiceMain()
      ServiceTableEntry(1)\lpServiceName = #Null
      ServiceTableEntry(1)\lpServiceProc = #Null
      b = StartServiceCtrlDispatcher_(@ServiceTableEntry())
      WriteLog("Starting Service Result = " + Str(b))
  EndSelect
EndProcedure

Procedure Handler(fdwControl.l)
  Define b.l
  
  Select fdwControl
    Case #SERVICE_CONTROL_PAUSE
      ;** Do whatever it takes To pause here.
      ServiceStatus\dwCurrentState = #SERVICE_PAUSED
    Case #SERVICE_CONTROL_CONTINUE
      ;** Do whatever it takes To continue here.
      ServiceStatus\dwCurrentState = #SERVICE_RUNNING
    Case #SERVICE_CONTROL_STOP
      ServiceStatus\dwWin32ExitCode = 0
      ServiceStatus\dwCurrentState = #SERVICE_STOP_PENDING
      ServiceStatus\dwCheckPoint = 0
      ServiceStatus\dwWaitHint = 0 ;Might want a time estimate
      b = SetServiceStatus_(hServiceStatus, ServiceStatus)
      ;** Do whatever it takes to stop here.
      Finish = 1
      ServiceStatus\dwCurrentState = #SERVICE_STOPPED
    ;Case #SERVICE_CONTROL_INTERROGATE
      ;Fall through to send current status.
  EndSelect
  ;Send current status.
  b = SetServiceStatus_(hServiceStatus, ServiceStatus)
EndProcedure

Procedure ServiceMain(dwArgc.l, lpszArgv.l)
  Define b.l

  WriteLog("ServiceMain")
  ;Set initial state
  ServiceStatus\dwServiceType = #SERVICE_WIN32_OWN_PROCESS
  ServiceStatus\dwCurrentState = #SERVICE_START_PENDING
  ;ServiceStatus\dwControlsAccepted = #SERVICE_ACCEPT_STOP | #SERVICE_ACCEPT_PAUSE_CONTINUE | #SERVICE_ACCEPT_SHUTDOWN
  ServiceStatus\dwControlsAccepted = #SERVICE_ACCEPT_STOP | #SERVICE_ACCEPT_SHUTDOWN
  ServiceStatus\dwWin32ExitCode = 0
  ServiceStatus\dwServiceSpecificExitCode = 0
  ServiceStatus\dwCheckPoint = 0
  ServiceStatus\dwWaitHint = 0
  
  hServiceStatus = RegisterServiceCtrlHandler_(ServiceName, @Handler())
  ServiceStatus\dwCurrentState = #SERVICE_START_PENDING
  b = SetServiceStatus_(hServiceStatus, ServiceStatus)
  
  ;** Do Initialization Here
  
  ServiceStatus\dwCurrentState = #SERVICE_RUNNING
  b = SetServiceStatus_(hServiceStatus, ServiceStatus)
  
  ;** Perform tasks
  Repeat
    Delay(100)
  Until Finish = 1
  
  ;** If an error occurs the following should be used for shutting
  ;** down:
  ; SetServerStatus SERVICE_STOP_PENDING
  ; Clean up
  ; SetServerStatus SERVICE_STOPPED
EndProcedure

Procedure WriteLog(Value.s)
  If OpenFile(0, LogFile)
    FileSeek(0, Lof(0))
    WriteStringN(0, FormatDate("%YYYY-%MM-%DD %HH:%II:%SS - ", Date()) + Value)
    CloseFile(0)
  EndIf
EndProcedure

Main()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -