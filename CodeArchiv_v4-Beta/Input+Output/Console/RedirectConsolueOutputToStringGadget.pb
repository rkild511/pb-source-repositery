; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2893&highlight=
; Author: Unknown (posted by MXVA)
; Date: 09. April 2005
; OS: Windows
; Demo: No


; Redirecting the (static) console output to a stringgadget 
; Umleiten der (statischen) Konsolen-Ausgabe in ein StringGadget

#D_ReadBufferSize = 1024 

Structure D_ProgramInfo 
  StartUpInfo.STARTUPINFO 
  ProcessInfo.PROCESS_INFORMATION 
  SECURITYATTRIBUTES.SECURITY_ATTRIBUTES 
  hOutputPipeRead.l 
  hOutputPipeWrite.l 
  hInputPipeRead.l 
  hInputPipeWrite.l 
  hReadThread.l 
  ReadThreadStat.l 
  ReadBuffer.l 
  ReadDataLen.l 
EndStructure 

Procedure D_ReadConsoleOutputThread(*ProgramInfo.D_ProgramInfo) 
  *ProgramInfo\ReadBuffer = AllocateMemory(#D_ReadBufferSize) 
  *ProgramInfo\ReadThreadStat = 1 
  Repeat 
    If *ProgramInfo\ReadThreadStat = 1 
      If ReadFile_(*ProgramInfo\hOutputPipeRead,*ProgramInfo\ReadBuffer,#D_ReadBufferSize,@*ProgramInfo\ReadDataLen,0) 
        *ProgramInfo\ReadThreadStat = 2 
      EndIf 
    EndIf 
    Delay(1) 
  Until *ProgramInfo\ReadThreadStat = 0 
  FreeMemory(*ProgramInfo\ReadBuffer) 
  *ProgramInfo\hReadThread = #Null 
EndProcedure 

Procedure D_RunProgram(EXEFileName.s,Parameter.s,*ProgramInfo.D_ProgramInfo) 
  Protected result 
  result = #False 
  *ProgramInfo\SECURITYATTRIBUTES\nLength = SizeOf(SECURITY_ATTRIBUTES) 
  *ProgramInfo\SECURITYATTRIBUTES\bInheritHandle = 1 
  *ProgramInfo\SECURITYATTRIBUTES\lpSecurityDescriptor = 0 
  
  If CreatePipe_(@*ProgramInfo\hOutputPipeRead, @*ProgramInfo\hOutputPipeWrite, @*ProgramInfo\SECURITYATTRIBUTES, 0) And CreatePipe_(@*ProgramInfo\hInputPipeRead, @*ProgramInfo\hInputPipeWrite, @*ProgramInfo\SECURITYATTRIBUTES, 0) 
    *ProgramInfo\StartUpInfo\cb = SizeOf(STARTUPINFO) 
    *ProgramInfo\StartUpInfo\dwFlags = #STARTF_USESTDHANDLES | #STARTF_USESHOWWINDOW 
    *ProgramInfo\StartUpInfo\hStdOutput = *ProgramInfo\hOutputPipeWrite 
    *ProgramInfo\StartUpInfo\hStdError = *ProgramInfo\hOutputPipeWrite 
    *ProgramInfo\StartUpInfo\hStdInput = *ProgramInfo\hInputPipeRead 
    If CreateProcess_(#Null,Chr(34)+EXEFileName+Chr(34)+" "+Parameter,@*ProgramInfo\SECURITYATTRIBUTES,@*ProgramInfo\SECURITYATTRIBUTES,1,#NORMAL_PRIORITY_CLASS,#Null,#Null,@*ProgramInfo\StartUpInfo,@*ProgramInfo\ProcessInfo) 
      *ProgramInfo\hReadThread = CreateThread(@D_ReadConsoleOutputThread(),*ProgramInfo) 
      If *ProgramInfo\hReadThread 
        Delay(10) 
        result = #True 
      EndIf 
    EndIf 
    CloseHandle_(*ProgramInfo\hOutputPipeWrite) 
    CloseHandle_(*ProgramInfo\hInputPipeRead) 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure D_CloseProgram(*ProgramInfo.D_ProgramInfo) 
  *ProgramInfo\ReadThreadStat = 0 
  CloseHandle_(*ProgramInfo\ProcessInfo\hThread) 
  CloseHandle_(*ProgramInfo\hOutputPipeRead) 
  CloseHandle_(*ProgramInfo\hInputPipeWrite) 
  TerminateProcess_(*ProgramInfo\ProcessInfo\hProcess,0) 
  CloseHandle_(*ProgramInfo\ProcessInfo\hProcess) 
  If *ProgramInfo\hReadThread 
    KillThread(*ProgramInfo\hReadThread) 
  EndIf 
EndProcedure 

Procedure D_GetOutput(*ProgramInfo.D_ProgramInfo,Buffer) 
  Delay(5) 
  If *ProgramInfo\ReadThreadStat = 2 
    Debug *ProgramInfo\ReadBuffer 
    Debug OemToCharBuff_(*ProgramInfo\ReadBuffer,Buffer,*ProgramInfo\ReadDataLen) 
    *ProgramInfo\ReadThreadStat = 1 
    ProcedureReturn *ProgramInfo\ReadDataLen 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

Procedure D_SendInputString(*ProgramInfo.D_ProgramInfo,string.s) 
  Protected tmp.l 
  CharToOemBuff_(string,string,Len(string)) 
  If WriteFile_(*ProgramInfo\hInputPipeWrite,string,Len(string),@tmp,0) 
    ProcedureReturn tmp 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

Procedure D_SendInput(*ProgramInfo.D_ProgramInfo,Buffer.l,Bufferlen.l) 
  Protected tmp.l 
  If WriteFile_(*ProgramInfo\hInputPipeWrite,Buffer,Bufferlen,@tmp,0) 
    ProcedureReturn tmp 
  EndIf 
  ProcedureReturn #False 
EndProcedure 


#Gadget_String = 0 

CreateGadgetList(OpenWindow(0,0,0,400,200,"Console-Zeugs",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)) 
StringGadget(#Gadget_String,0,0,400,200,"",#ES_MULTILINE|#PB_String_ReadOnly) 


Mem = AllocateMemory(#D_ReadBufferSize) 

If D_RunProgram("ping","localhost",@ProgramInfo.D_ProgramInfo) ; In ProgramInfo werden die Daten gespeichert 
  
  Repeat 
    len = D_GetOutput(@ProgramInfo,Mem) 
    If len 
      SetGadgetText(#Gadget_String,GetGadgetText(#Gadget_String)+PeekS(Mem,len)) 
    EndIf 
  Until len = 0 
  
  tmpstring.s = "netstat"+Chr(13)+Chr(10) ; !WICHTIG! CHR(10) muss vorkommen, sonst wird der Befehl nicht angenommen 
  D_SendInputString(@ProgramInfo,tmpstring) 
  
  Repeat 
    len = D_GetOutput(@ProgramInfo,Mem) 
    If len 
      SetGadgetText(#Gadget_String,GetGadgetText(#Gadget_String)+PeekS(Mem,len)) 
      Received + len 
    EndIf 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
  
  D_CloseProgram(@ProgramInfo) 
Else 
  MessageRequester("","Konnte Programm nicht ausführen!",16) 
EndIf 

FreeMemory(Mem)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --