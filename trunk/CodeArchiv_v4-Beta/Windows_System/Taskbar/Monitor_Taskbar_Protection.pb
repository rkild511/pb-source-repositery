; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6225
; Author: LJ
; Date: 24. May 2003
; OS: Windows
; Demo: No


; Prevents opening of any IExplorer windows (also closes all opened IE windows!!!)

;-ini 
Structure info 
  handle.l 
  process.l 
  class$ 
  name$ 
EndStructure 
;#PROCESS_ALL_ACCESS=$FFF 

Global NewList info.info() 
Global NewList AllHandle() 

Procedure.s GetClassName(handle) 
  class$=Space(1024) 
  GetClassName_(handle,@class$,Len(class$)) 
  ProcedureReturn Left(class$,Len(class$)) 
EndProcedure 
Procedure.s GetTitle(handle) 
  name$=Space(1024) 
  GetWindowText_(handle,@name$,Len(name$)) 
  ProcedureReturn Left(name$,Len(name$)) 
EndProcedure 
Procedure AddInfo(handle) 
  process=0 
  GetWindowThreadProcessId_(handle,@process) 
  class$=GetClassName(handle) 
  name$=GetTitle(handle) 
  
  ResetList(info()) 
  quit=0 
  i=0 
  Repeat 
    If NextElement(info()) 
      If process < info()\process 
        quit=1 
      ElseIf process=info()\process 
        If class$ < info()\class$ 
          quit=1 
        ElseIf UCase(class$)=UCase(info()\class$) 
          If name$ < info()\name$ 
            quit=1 
          ElseIf UCase(name$)=UCase(info()\name$) 
            If handle < info()\handle 
              quit=1 
            ElseIf handle=info()\handle 
              quit=3 
            EndIf 
          EndIf 
        EndIf 
      EndIf 
    Else 
      quit=2 
    EndIf 
  Until quit 
  If quit<3 
    If quit=1 
      If PreviousElement(info())=0: ResetList(info()) :EndIf 
    EndIf 
    AddElement(info()) 
    info()\handle=handle 
    info()\process=process 
    info()\class$=class$ 
    info()\name$=name$ 
    If class$ = "IEFrame" 
      PostMessage_(info()\handle,#WM_CLOSE,0,0) 
     EndIf 
    
  EndIf 
EndProcedure 

Procedure RefreshList() 
  handle=GetWindow_(WindowID(0),#GW_HWNDFIRST) 
;  ClearList(allhandle()) 
  quit=0 
  Repeat 
    AddInfo(handle) 
    x=GetWindow_(handle,#GW_CHILD) 
    If x 
      AddElement(AllHandle()) 
      AllHandle()=x 
    EndIf 
    x=GetWindow_(handle,#GW_HWNDNEXT) 
    If x 
      handle=x 
    Else 
      If LastElement(AllHandle()) 
        handle=AllHandle() 
        DeleteElement(AllHandle()) 
      Else 
        quit=1 
      EndIf 
    EndIf 
  Until quit 

  ResetList(info()) 
  
    
  While NextElement(info()) 
    If oldprocess<>info()\process 
      oldprocess=info()\process 
      a$=Hex(oldprocess) 
    Else 
      a$="              ''" 
    EndIf 
;   AddGadgetItem(0,-1,a$+Chr(10)+info()\class$+Chr(10)+info()\name$+Chr(10)+Hex(info()\handle)) 

  Wend 
  

EndProcedure 
Procedure ResizeWebWindow() 
  ResizeGadget(10,#PB_Ignore,#PB_Ignore, WindowWidth(0), WindowHeight(0)-52) 

EndProcedure 

OpenWindow(0, 0, 0, 797, 550, "Browser", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget) 

  CreateGadgetList(WindowID(0)) 
    
    
  appdir$=Space(255) : GetCurrentDirectory_(255,@appdir$) : If Right(appdir$,1)<>"\" : appdir$+"\" : EndIf 
  url$=appdir$+"bisect.ldj" 

If WebGadget(10, 0, 31, 0, 0, url$) = 0 : MessageRequester("Error", "ATL.dll not found", 0) : End : EndIf 
  
  ;AddKeyboardShortcut(0, #PB_Shortcut_Return, 0) 
  ResizeWebWindow() 
    

RefreshList() 
  
  Repeat 
  RefreshList() 
    Event = WaitWindowEvent() 
    
    Select Event 
      Case #PB_Event_Gadget 
      
        Select EventGadget() 
        
            
        EndSelect      
          
    EndSelect 
      
  Until Event = #PB_Event_CloseWindow 

RefreshList() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
