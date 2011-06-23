; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2731&highlight=
; Author: Hroudtwolf (updated for PB 4.00 by Andre)
; Date: 30. March 2005
; OS: Windows
; Demo: No


;2005-Hroudtwolf
flags.l=#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SystemMenu|#PB_Window_SizeGadget
If OpenWindow (1,0,0,800,600,"EditorGadget - ohne Rahmen",flags.l)
  If CreateGadgetList (WindowID(1))
    EditorGadget(1, 10,10, WindowWidth(1)-20, WindowHeight (1)-20)
    style = GetWindowLong_(GadgetID(1), #GWL_EXSTYLE)
    newstyle = style &(~#WS_EX_CLIENTEDGE)
    SetWindowLong_(GadgetID(1), #GWL_EXSTYLE, newstyle)
    SetWindowPos_(GadgetID(1), 0, 0, 0, 0, 0, #SWP_SHOWWINDOW | #SWP_NOSIZE | #SWP_NOMOVE | #SWP_FRAMECHANGED)
  EndIf
  
  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -