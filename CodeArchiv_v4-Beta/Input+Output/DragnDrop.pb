; English forum: 
; Author: Hi-Toro (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


; Original source code by James L.Boyd
; I only moved Procedures to progstart..
;
  Procedure.l DropFiles ()
    ProcedureReturn EventwParam ()
  EndProcedure
;
  Procedure GetNumDropFiles (*dropFiles)
    ProcedureReturn DragQueryFile_ (*dropFiles, $FFFFFFFF, temp$, 0)
  EndProcedure
;
  Procedure.s GetDropFile (*dropFiles, index)
    bufferNeeded = DragQueryFile_ (*dropFiles, index, 0, 0)
    For a = 1 To bufferNeeded: buffer$ + " ": Next ; Short by one character!
    DragQueryFile_ (*dropFiles, index, buffer$, bufferNeeded+1)
    ProcedureReturn buffer$
  EndProcedure
;
  Procedure FreeDropFiles (*dropFiles)
    DragFinish_ (*dropFiles)
  EndProcedure
;
If OpenWindow (0, 100, 100, 300, 100, "Drag 'n' drop", #PB_Window_SystemMenu)
  DragAcceptFiles_ (WindowID(0), 1)
  ; 
  Repeat
    Select WaitWindowEvent ()
      Case #WM_DROPFILES
      *dropped = DropFiles ()
      num.l = DragQueryFile_ (*dropped , $FFFFFFFF, temp$, 0)
      ;
      f$ = ""
      For files = 0 To num - 1
        f$ + GetDropFile (*dropped, files) + Chr (13)
      Next
      MessageBox_ (0, Str (num) + " file (s) dropped:" + Chr (13) + Chr (13) + f$, "Drag 'n' Drop", 0)
      FreeDropFiles (*dropped)
      ;
      Case #PB_Event_CloseWindow
      Quit = 1
      ;
    EndSelect
  Until Quit = 1
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -