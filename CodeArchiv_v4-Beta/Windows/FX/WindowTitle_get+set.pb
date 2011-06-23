; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2067&highlight=
; Author: Danilo (example added by Andre, updated for PB3.93 by Donald, updated for PB4.00 by blbltheworm)
; Date: 22. August 2003
; OS: Windows
; Demo: No

; Note: in PB v4 there are also natice commands available: GetWindowTitle() + SetWindowTitle()
; Hinweis: in PB v4 sind auch native Befehle verfügbar: GetWindowTitle() + SetWindowTitle()

Procedure.s GetWindowTitle_(Window) 
  A$ = Space(1024) 
  GetWindowText_(WindowID(Window),A$,1024) 
  ProcedureReturn A$ 
EndProcedure 

Procedure SetWindowTitle_(Window,Title$) 
  ProcedureReturn SetWindowText_(WindowID(Window),Title$) 
EndProcedure

If OpenWindow(0,0,0,300,50,"Window Title",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(0,10,10,280,20,"Change Window Title") 
  EndIf 
  Repeat 
    ev.l = WaitWindowEvent() 
    If ev = #PB_Event_Gadget 
      Select EventGadget() 
        Case 0
          SetWindowTitle_(0,"New Window Title")
      EndSelect 
    EndIf
  Until ev = #PB_Event_CloseWindow 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
