; www.purearea.net (Sourcecode collection by cnesm)
; Author: Mischa (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Procedure.s MainPart(text.s) 
  ;Simple text-Box 
  OpenWindow(0,0,0,240,160,"Notes",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  StringGadget(0,5,5,230,150,text,#ES_MULTILINE|#WS_VSCROLL|#WS_HSCROLL|#ES_AUTOHSCROLL|#ES_AUTOVSCROLL) 
  Repeat:Until WaitWindowEvent() = #PB_Event_CloseWindow 
  ProcedureReturn GetGadgetText(0) 
EndProcedure 


;Get program and temp-folder name 
program.s= Space(1000):GetModuleFileName_(0,program,1000) 
temp.s=    Space(1000):GetTempPath_(1000,temp) 

;Construct Clone-Name 
clone.s=   temp+"_"+GetFilePart(program) 


;Check mode by parameter 
mode.s=ProgramParameter() 
If mode="clone" ;I am the clone 
  ;Check if another instance is running (cause makes no sense here) 
  Mutex=CreateMutex_(0,1,"Mischas Notes") 
  Error=GetLastError_() 
  If Mutex<>0 And Error=0 
    program=ProgramParameter() 
    size=FileSize(program) 
    
    ReadFile(0,program) 
      FileSeek(0,size-12) 
      If ReadLong(0) = 1234321 ;this is a sign for us that there are resources inside 
        size=ReadLong(0) 
        resourcesize=ReadLong(0) 
        FileSeek(0,size) 
        *res=AllocateMemory(resourcesize) 
        ReadData(0,*res,resourcesize) 
        resource.s=PeekS(*res) 
      EndIf 
      FileSeek(0,0) 
      *header=AllocateMemory(size) 
      ReadData(0,*header,size) ;Put the small main-program in the pocket (alternate do this in the end) 
    CloseFile(0) 
    
    newtext.s=MainPart(resource) ;The main-program 
    
    If newtext <> resource ;Ok, now we construct new program with new resources 
      resourcesize=Len(newtext) + 1 
      *res=AllocateMemory(resourcesize) 
      PokeS(*res,newtext) 
      SetFileAttributes_(program,#FILE_ATTRIBUTE_NORMAL) ;maybe its write-protected 
      
      CreateFile(1,program) 
        WriteData(1,*header,size)         ;program-part 
        WriteData(1,*res,resourcesize)    ;resource-part 
        WriteLong(1,1234321)              ;Our sign 
        WriteLong(1,size)                 ;Adress of resources 
        WriteLong(1,resourcesize)         ;Size of resources 
      CloseFile(1) 
    EndIf 
    RunProgram(program,"killclone","",0)  
  EndIf 
  CloseHandle_(Mutex) 
ElseIf mode="killclone" ;Delete clone of program 
  Sleep_(500) 
  DeleteFile(clone) 
Else ;normal mode  
  ;Create and start clone 
  If FileSize(clone) = -1 
    CopyFile(program,clone) 
  EndIf 
  RunProgram(clone,"clone "+Chr(34)+program+Chr(34),"",0)  
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP