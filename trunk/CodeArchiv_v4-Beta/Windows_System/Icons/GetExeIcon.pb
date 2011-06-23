; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1746
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 20. July 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 20.07.2003 - german forum 
; 
Procedure GetExeIcon() 
  hMod  = GetModuleHandle_(0) 
  Name$ = Space(1024) 
  GetModuleFileName_(0,Name$,1024) 
  hIcon = ExtractIcon_(hMod,Name$,0) 
  If hIcon 
    ProcedureReturn hIcon 
  Else 
    GetSystemDirectory_(Name$,1024) 
    ProcedureReturn ExtractIcon_(hMod,Name$+"\shell32.dll",2) 
    ;ProcedureReturn LoadIcon_(0,#IDI_APPLICATION) ; alternatively 
  EndIf 
EndProcedure 


OpenWindow(0,200,200,200,200,"Test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(0,0,0,32,32,GetExeIcon()) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
