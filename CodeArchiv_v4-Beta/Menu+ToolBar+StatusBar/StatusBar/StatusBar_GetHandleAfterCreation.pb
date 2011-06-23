; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13895&highlight=
; Author: PB (adapted + updated for PB 4.00 by Andre)
; Date: 02. February 2005
; OS: Windows
; Demo: No


; Get the handle of statusbar AFTER creation 
; Handle der Statusleiste ermitteln, nachdem diese bereits erstellt ist

Procedure.l GetAllChildWins(hWnd) 
  r=GetWindow_(hWnd,#GW_CHILD) 
  Repeat 
    c$=Space(999) : GetClassName_(r,c$,999) 
    If c$="msctls_statusbar32" : pr=r : EndIf 
    r=GetWindow_(r,#GW_HWNDNEXT) 
  Until r=0
  ProcedureReturn pr 
EndProcedure 

If OpenWindow(1,300,250,400,200,"test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(1)) : ListViewGadget(0,0,0,400,200) 
  sb = CreateStatusBar(0,WindowID(1)) 
  pr = GetAllChildWins(WindowID(1)) 
  AddGadgetItem(0,-1,"Handle when created = "+Str(sb)) 
  AddGadgetItem(0,-1,"Handle by procedure = "+Str(pr)) 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -