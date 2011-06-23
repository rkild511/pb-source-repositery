; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6753&highlight=
; Author: Eddy
; Date: 29. June 2003
; OS: Windows
; Demo: No


; RunProgramEx : retrieve handle of opened window 

; /////////////////////// 
; Run Program Ex 
; /////////////////////// 

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


; ///////////////////////////// 
; System Directory 
; ///////////////////////////// 

Procedure.s GetSystemDir() 
   systemdir$=Space(255) 
   lg = GetSystemDirectory_(systemdir$, 255) 
   systemdir$=Left(systemdir$,lg) 
   ProcedureReturn systemdir$ 
EndProcedure 

app=RunProgramEx(GetSystemDir()+"\calc.exe","",GetSystemDir()+"\",#SW_SHOWNORMAL) 
   ExStyle.l  =GetWindowLong_(app,#GWL_EXSTYLE) 
   ExStyle = ExStyle | #WS_EX_TOOLWINDOW 
   SetWindowLong_(app,#GWL_EXSTYLE, ExStyle) ;Tool Style 
   SetWindowPos_(app,#HWND_TOPMOST,0,0,0,0,16|2|1)     ;Always on top  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
