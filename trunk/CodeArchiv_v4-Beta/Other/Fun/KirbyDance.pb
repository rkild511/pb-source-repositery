; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2140
; Author: MVXA (improved by Deeem2031, updated for PB 4.00 by Andre)
; Date: 20. February 2005
; OS: Windows
; Demo: No


; Dance the Kirby Dance !

Global frmMain.l, lblKyrbe.l, fntArial.l, lngStep.l 

frmMain = OpenWindow(#PB_Any, 0, 0, 100, 25, "Kirby", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
SetTimer_(WindowID(frmMain),1,500,0) 

If frmMain <> 0 
  fntArial = LoadFont(1, "Arial", 9) 
  If CreateGadgetList(WindowID(frmMain)) 
    lblKyrbe = TextGadget(#PB_Any, 25, 5, 50, 20, "(>^_^)>") 
    SetGadgetFont(lblKyrbe, fntArial) 
  EndIf 
  
  Repeat 
    Select WaitWindowEvent() 
      Case #WM_TIMER 
        Select lngStep 
          Case 0: SetGadgetText(lblKyrbe, "<(^_^<)") 
          Case 1: SetGadgetText(lblKyrbe, "^(^_^)^") 
          Case 2: SetGadgetText(lblKyrbe, "(>^_^)>") 
          Default: lngStep = -1 
        EndSelect 
        lngStep + 1 
      Case #PB_Event_CloseWindow 
        quit = 1 
    EndSelect 
  Until quit 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger