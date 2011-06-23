; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Declare WndProc(hWnd, uMsg, wParam, lParam)

#EN_LINK = $70B
#ENM_LINK = $4000000

Procedure WndProc(hWnd, uMsg, wParam, lParam)
  result = #PB_ProcessPureBasicEvents
  Select uMsg
  Case #WM_NOTIFY
    *el.ENLINK = lParam
    If *el\nmhdr\code=#EN_LINK
      If *el\msg=#WM_LBUTTONDOWN
        StringBuffer = AllocateMemory(512)
        txt.TEXTRANGE
        txt\chrg\cpMin = *el\chrg\cpMin
        txt\chrg\cpMax = *el\chrg\cpMax
        txt\lpstrText = StringBuffer
        SendMessage_(GadgetID(0), #EM_GETTEXTRANGE, 0, txt)
        Debug PeekS(StringBuffer)
        FreeMemory(StringBuffer)
      EndIf
    EndIf
  EndSelect
  ProcedureReturn result
EndProcedure

If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)=0:End:EndIf
If CreateGadgetList(WindowID(0))=0:End:EndIf
EditorGadget(0, 0, 0, WindowWidth(0), WindowHeight(0))
SendMessage_(GadgetID(0), #EM_SETEVENTMASK, 0, #ENM_LINK|SendMessage_(GadgetID(0), #EM_GETEVENTMASK, 0, 0))
SendMessage_(GadgetID(0), #EM_AUTOURLDETECT, #True, 0)
SetGadgetText(0, "http://www.purebasic.com"+Chr(10))
SetWindowCallback(@WndProc())
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP