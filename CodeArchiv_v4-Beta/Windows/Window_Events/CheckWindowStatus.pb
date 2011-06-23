; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14328&highlight=
; Author: ABBKlaus (updated for PB 4.00 by Andre)
; Date: 08. March 2005
; OS: Windows
; Demo: No


; Purpose of this code snippet:
; I need to know when a window is focused (Active) or not. Lets say notepad, 
; if I have it focused then I want to show my program, if not, hide it. 
; Later on, I would like to "stick" my window to a location of lets say 
; notepad, let it be the bottom for example. 


ProgramToFind$ = "Rechner"

#Main=1 

Procedure StateWindow(handle,State) 
  MyWindpl.WINDOWPLACEMENT 
  MyWindpl\length=SizeOf(MyWindpl) 
  If GetWindowPlacement_(handle,@MyWindpl) 
    MyWindpl\length=SizeOf(MyWindpl) 
    MyWindpl\showCmd=State 
    SetWindowPlacement_(handle,@MyWindpl) 
  EndIf 
EndProcedure 

If OpenWindow(#Main,0,0,200,200,"Test",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar) 
  ThisHwnd=WindowID(#Main) 
  SetTimer_(WindowID(#Main),1,100,0) 
EndIf 

active.b=1 

Repeat 
  Event = WaitWindowEvent() 
  Select Event 
    Case #PB_Event_CloseWindow 
      Quit=1 
  EndSelect 

  Prog1=FindWindow_(0,ProgramToFind$) 
  FGW.l=GetForegroundWindow_() 
  If FGW=0 
    ; do nothing 
  ElseIf FGW=Prog1 
    If active=0 
      HideWindow(#Main,0) 
      ;StateWindow(WindowID(#Main),#SW_SHOWNOACTIVATE) 
      BringWindowToTop_(FGW) 
      active=1 
      Debug "Prog1 is active" 
    EndIf 
  ElseIf FGW=ThisHwnd 
    If active=0 
      HideWindow(#Main,0) 
      ;StateWindow(WindowID(#Main),#SW_SHOWNOACTIVATE) 
      BringWindowToTop_(FGW) 
      active=1 
      Debug "Test is active" 
    EndIf 
  Else 
    If active=1 
      HideWindow(#Main,1) 
      ;StateWindow(WindowID(#Main),#SW_SHOWMINNOACTIVE) 
      active=0 
      Debug "Test is inactive" 
    EndIf 
  EndIf 
Until Quit=1
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -