; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2958&highlight=
; Author: Andreas
; Date: 30. November 2003
; OS: Windows
; Demo: No

Global mbHook.l,hThreadId.l
Procedure MsgBoxHookProc(uMsg,wParam,lParam)
  Protected Messagehandle.l
  Select uMsg
  Case #HCBT_ACTIVATE
    Messagehandle = GetDlgItem_(wParam,$FFFF)
    SetWindowLong_(Messagehandle,#GWL_STYLE,#WS_VISIBLE|#WS_CHILD|#SS_CENTER);Zentriert
    ;SetWindowLong_(Messagehandle,#GWL_STYLE,#WS_VISIBLE|#WS_CHILD|#SS_RIGHT);rechts
    UnhookWindowsHookEx_(mbHook)
  EndSelect
  ProcedureReturn 0
EndProcedure

Procedure MessageBoxH(parentWindow, title.s, message.s,flags)
  mbHook = SetWindowsHookEx_(#WH_CBT, @MsgBoxHookProc(), GetModuleHandle_(0), hThreadId)
  ProcedureReturn MessageBox_(parentWindow,title,message,flags)
EndProcedure

Debug MessageBoxH(0, "Meldung", "Titel",#MB_OKCANCEL)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
