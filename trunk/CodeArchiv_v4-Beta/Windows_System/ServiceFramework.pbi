; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14488
; Author: akee (updated for PB 4.00 by Andre)
; Date: 21. March 2005
; OS: Windows
; Demo: No

; A re-made example to create a Windows Service faster. 
; -------------------------------------------------------
; 1. Just include the .pbi into your .pb. 
; 2. Create a procedure ServiceProcedure(state.l) and monitor the 
;    state when the service is "Running" Or "Paused". 
; 3. Execute ServiceInit with the name of your service as the parameter. 
; 4. To install the service, run the executable with -i as the parameter. 
;    And in Windows Services, Start your service. 
; 5. To uninstall the service, stop the service and use -u to remove it 
;    from Windows Services. 

; To see what is happening, there will be a .log file created in the same 
; folder as your executable with status every 1/10 of a sec. 



; *** This is an include file, which can be used by other examples. ***



Global AppHandle.l 
Global AppHome.s 
Global AppExeName.s 
Global AppExeFileName.s 
Global AppIniFileName.s 

AppHandle.l = GetModuleHandle_(0) 
AppIniFileName = Space(255) 
GetModuleFileName_(AppHandle, @AppIniFileName, 255) 
AppHome.s = GetPathPart(AppIniFileName) 
AppExeFileName.s = GetFilePart(AppIniFileName) 
AppExeName.s = Left(AppExeFileName, Len(AppExeFileName) - Len(GetExtensionPart(AppIniFileName)) - 1) 
AppIniFileName.s = AppExeName + ".ini" 

#READ_CONTROL = $20000 
#STANDARD_RIGHTS_ALL = $1F0000 
#STANDARD_RIGHTS_EXECUTE = (#READ_CONTROL) 
#STANDARD_RIGHTS_READ = (#READ_CONTROL) 
#STANDARD_RIGHTS_REQUIRED = $F0000 
#STANDARD_RIGHTS_WRITE = (#READ_CONTROL) 

#SERVICE_WIN32_OWN_PROCESS = $10 
#SERVICE_WIN32_SHARE_PROCESS = $20 
#SERVICE_WIN32 = #SERVICE_WIN32_OWN_PROCESS + #SERVICE_WIN32_SHARE_PROCESS 

#SC_MANAGER_CONNECT = $1 
#SC_MANAGER_CREATE_SERVICE = $2 
#SC_MANAGER_ENUMERATE_SERVICE = $4 
#SC_MANAGER_LOCK = $8 
#SC_MANAGER_QUERY_LOCK_STATUS = $10 
#SC_MANAGER_MODIFY_BOOT_CONFIG = $20 
#SC_MANAGER_ALL_ACCESS_2 = (#STANDARD_RIGHTS_REQUIRED | #SC_MANAGER_CONNECT | #SC_MANAGER_CREATE_SERVICE | #SC_MANAGER_ENUMERATE_SERVICE | #SC_MANAGER_LOCK | #SC_MANAGER_QUERY_LOCK_STATUS | #SC_MANAGER_MODIFY_BOOT_CONFIG) 

#SERVICE_ACCEPT_STOP = $1 
#SERVICE_ACCEPT_PAUSE_CONTINUE = $2 
#SERVICE_ACCEPT_SHUTDOWN = $4 
#SERVICE_ACTIVE = $1 
#SERVICE_ALL_ACCESS_2 = (#STANDARD_RIGHTS_REQUIRED | #SERVICE_QUERY_CONFIG | #SERVICE_CHANGE_CONFIG | #SERVICE_QUERY_STATUS | #SERVICE_ENUMERATE_DEPENDENTS | #SERVICE_START | #SERVICE_STOP | #SERVICE_PAUSE_CONTINUE | #SERVICE_INTERROGATE | #SERVICE_USER_DEFINED_CONTROL) 
#SERVICE_CHANGE_CONFIG = $2 
#SERVICE_CONTINUE_PENDING = $5 
#SERVICE_CONTROL_CONTINUE = $3 
#SERVICE_CONTROL_INTERROGATE = $4 
#SERVICE_CONTROL_PAUSE = $2 
#SERVICE_CONTROL_SHUTDOWN = $5 
#SERVICE_CONTROL_STOP = $1 
#SERVICE_DEMAND_START = $3 
#SERVICE_ENUMERATE_DEPENDENTS = $8 
#SERVICE_ERROR_NORMAL = $1 
#SERVICE_INACTIVE = $2 
#SERVICE_INTERROGATE = $80 
#SERVICE_NO_CHANGE = $FFFF 
#SERVICE_PAUSE_CONTINUE = $40 
#SERVICE_PAUSE_PENDING = $6 
#SERVICE_PAUSED = $7 
#SERVICE_QUERY_CONFIG = $1 
#SERVICE_QUERY_STATUS = $4 
#SERVICE_RUNNING = $4 
#SERVICE_START = $10 
#SERVICE_START_PENDING = $2 
#SERVICE_STATE_ALL = (#SERVICE_ACTIVE | #SERVICE_INACTIVE) 
#SERVICE_STOP = $20 
#SERVICE_STOP_PENDING = $3 
#SERVICE_STOPPED = $1 
#SERVICE_USER_DEFINED_CONTROL = $100 
#SERVICE_CONFIG_DESCRIPTION = $1 
#SERVICE_CONFIG_FAILURE_ACTIONS = $2 


Global X_SERVICE_STATUS.SERVICE_STATUS 
Global X_SERVICE_STATUS_HANDLE.l 
Global X_SERVICE_RUNNING.l 


Declare ServiceProcedure(ServiceState.l) 
; 
; 
; 
Procedure _WriteLog(LogMessage.s) 
  T_LOGFILE.s = AppHome + AppExeName + ".log" 
  T_HANDLE.l 
  If FileSize(T_LOGFILE) = -1 
    T_HANDLE = CreateFile(#PB_Any, T_LOGFILE) 
  Else 
    T_HANDLE = OpenFile(#PB_Any, T_LOGFILE) 
    FileSeek(T_HANDLE, Lof(T_HANDLE)) 
  EndIf 
  WriteStringN(T_HANDLE, FormatDate("%yyyy/%mm/%dd,%hh:%ii:%ss,", Date()) + LogMessage) 
  CloseFile(T_HANDLE) 
EndProcedure 

; 
; 
; 
Procedure ServiceHandler(OperationCode.l) 
  Select OperationCode 
    Case #SERVICE_CONTROL_PAUSE 
      X_SERVICE_STATUS\dwCurrentState = #SERVICE_PAUSED 
      SetServiceStatus_(X_SERVICE_STATUS_HANDLE, X_SERVICE_STATUS) 
    Case #SERVICE_CONTROL_CONTINUE 
      X_SERVICE_STATUS\dwCurrentState = #SERVICE_RUNNING 
      SetServiceStatus_(X_SERVICE_STATUS_HANDLE, X_SERVICE_STATUS) 
    Case #SERVICE_CONTROL_STOP 
      X_SERVICE_STATUS\dwWin32ExitCode = 0 
      X_SERVICE_STATUS\dwCheckPoint = 0 
      X_SERVICE_STATUS\dwWaitHint = 0 
      X_SERVICE_STATUS\dwCurrentState = #SERVICE_STOPPED 
      SetServiceStatus_(X_SERVICE_STATUS_HANDLE, X_SERVICE_STATUS) 
      X_SERVICE_RUNNING = #False 
    Case #SERVICE_CONTROL_INTERROGATE 
      X_SERVICE_RUNNING = #False 
  EndSelect 
EndProcedure 

; 
; 
; 
Procedure ServiceMain() 
  X_SERVICE_STATUS\dwServiceType = #SERVICE_WIN32 
  X_SERVICE_STATUS\dwCurrentState = #SERVICE_START_PENDING 
  X_SERVICE_STATUS\dwControlsAccepted = #SERVICE_ACCEPT_STOP | #SERVICE_ACCEPT_PAUSE_CONTINUE 
  X_SERVICE_STATUS\dwWin32ExitCode = 0 
  X_SERVICE_STATUS\dwServiceSpecificExitCode = 0 
  X_SERVICE_STATUS\dwCheckPoint = 0 
  X_SERVICE_STATUS\dwWaitHint = 0 

  X_SERVICE_STATUS_HANDLE = RegisterServiceCtrlHandler_(AppExeName, @ServiceHandler()) 

  X_SERVICE_STATUS\dwCurrentState = #SERVICE_RUNNING 
  SetServiceStatus_(X_SERVICE_STATUS_HANDLE, X_SERVICE_STATUS) 

  X_SERVICE_RUNNING = #True 
  While X_SERVICE_RUNNING 
    Sleep_(100) 
    ServiceProcedure(X_SERVICE_STATUS\dwCurrentState) 
  Wend 
EndProcedure 

; 
; 
; 
Procedure ServiceInit(ServiceName.s) 
  T_TABLE_ENTRY.SERVICE_TABLE_ENTRY 
  T_SCMANAGER.l 
  T_SERVICE.l = 0 
  T_RETURNS.l = 1 
  T_PARAMETER.s = Trim(LCase(ProgramParameter())) 

  X_SERVICE_RUNNING = #False 

  If T_PARAMETER = "" 
    T_TABLE_ENTRY\lpServiceName = @AppExeName 
    T_TABLE_ENTRY\lpServiceProc = @ServiceMain() 
    If StartServiceCtrlDispatcher_(@T_TABLE_ENTRY) 
      _WriteLog("Service " + AppExeName + " dispatched.") 
      T_RETURNS = 0 
    EndIf 
  Else 
    T_SCMANAGER = OpenSCManager_(0, 0, #SC_MANAGER_ALL_ACCESS_2) 
    If T_SCMANAGER 
      Select T_PARAMETER 
        Case "-i" 
          _WriteLog("Installing service " + AppExeName + ".") 
          ServiceName = Trim(ServiceName) 
          If ServiceName = "" 
            ServiceName = AppExeName 
          EndIf 
          T_SERVICE = CreateService_(T_SCMANAGER, AppExeName, ServiceName, #SERVICE_ALL_ACCESS, #SERVICE_WIN32_OWN_PROCESS, #SERVICE_DEMAND_START, #SERVICE_ERROR_NORMAL, AppHome + AppExeFileName, 0, 0, 0, 0, 0) 
          If T_SERVICE 
            _WriteLog("Service installed succesfully.") 
            T_RETURNS = 0 
          Else 
            _WriteLog("Error installing service.") 
          EndIf 
          CloseServiceHandle_(T_SERVICE) 
        Case "-u" 
          _WriteLog("Uninstalling service " + AppExeName + ".") 
          T_SERVICE = OpenService_(T_SCMANAGER, AppExeName, #SERVICE_ALL_ACCESS_2) 
          If T_SERVICE 
            DeleteService_(T_SERVICE) 
            _WriteLog("Service uninstalled succesfully.") 
            T_RETURNS = 0 
          Else 
            _WriteLog("Error uninstalling service.") 
          EndIf 
          CloseServiceHandle_(T_SERVICE) 
        Default 
          _WriteLog("Unknown parameter " + T_PARAMETER + ". Use -i to install or -u to uninstall service.") 
      EndSelect 
    Else 
      _WriteLog("Error opening service control manager.") 
    EndIf 
    CloseServiceHandle_(T_SCMANAGER) 
  EndIf 
  _WriteLog("Program returned " + Str(T_RETURNS) + ".") 
  End T_RETURNS 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -