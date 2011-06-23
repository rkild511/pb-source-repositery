; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3708&highlight=
; Author: Timo Gärtner
; Date: 15. February 2004
; OS: Windows
; Demo: No

; Funktioniert bei *.exe/*.com/*.bat - Dateien. 
Procedure.l RunProgramEx(Filename.s, Parameter.s, Directory.s, ShowFlag.l) 
   Info.STARTUPINFO 
   Info\cb          =SizeOf(STARTUPINFO)    
   Info\dwFlags     =1                    ;#STARTF_USESHOWWINDOW 
   Info\wShowWindow =ShowFlag 
   ProcessInfo.PROCESS_INFORMATION    
   ProcessPriority=$20                    ;NORMAL_PRIORITY 
  ;Create a window and retrieve its process 
  If CreateProcess_(@Filename, @Parameter, 0, 0, 0, ProcessPriority, 0, @Directory, @Info, @ProcessInfo) 
      ;Process Values      
      ProcessID.l =ProcessInfo\dwProcessId 
      ;Find Window Handle of Process 
      Repeat 
         win=FindWindow_(0,0) 
         While win<>0 And quit=0 
            GetWindowThreadProcessId_(win, @pid.l) 
            If pid=ProcessID 
               WinHandle=win 
               quit=1 
            EndIf 
            win=GetWindow_(win, #GW_HWNDNEXT)          
         Wend 
      Until WinHandle 
   EndIf 
   ;Retrieve Window Handle 
   ProcedureReturn WinHandle 
EndProcedure  


command$="c:\windows\winhlp32.exe" 
app=RunProgramEx(command$,"",GetPathPart(command$), #SW_NORMAL) 
SetWindowPos_(app,#HWND_TOPMOST,0,0,0,0,16|2|1)     ;Always on top 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -