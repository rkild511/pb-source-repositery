; English forum:
; Author: Unknown
; Date: 21. January 2003
; OS: Windows
; Demo: No


; Change dialog box buttons... crashes PBCompiler, but the program itself works!

; Try creating an .exe file -- PB will crash, but the .exe version will work just fine when run :)

#IDOK = 1
#IDCANCEL = 2
#IDABORT = 3
#IDRETRY = 4
#IDIGNORE = 5
#IDYES = 6
#IDNO = 7
#IDPROMPT = $FFFF

Global hHook
Global mbtitle$, mbmsg$, mbopt1$, mbopt2$, mbopt3$

; Have to pre-allocate maximum string length, as the dialog box is created with message/title
; with this many spaces (the width of the box comes from this), then the text is hacked into it.

#StringSpace = 80

Procedure MsgBoxHookProc (uMsg, wParam, lParam)
   If uMsg = #HCBT_ACTIVATE
      SetWindowText_ (wParam, mbtitle$)
      SetDlgItemText_ (wParam, #IDABORT, mbopt1$)
      SetDlgItemText_ (wParam, #IDRETRY, mbopt2$)
      SetDlgItemText_ (wParam, #IDIGNORE, mbopt3$)
      SetDlgItemText_ (wParam, #IDPROMPT, mbmsg$)
      UnhookWindowsHookEx_ (hHook)
   EndIf
   ProcedureReturn #False
EndProcedure

Procedure MessageBoxH (parentWindow, title$, message$, button1$, button2$, button3$)
   mbtitle$ = title$
   mbmsg$ = message$
   mbopt1$ = button1$
   mbopt2$ = button2$
   mbopt3$ = button3$
   hInstance = GetModuleHandle_ (0)
   hThreadId = GetCurrentThreadId_ ()
   hHook = SetWindowsHookEx_ (#WH_CBT, @MsgBoxHookProc (), hInstance, hThreadId)
   ProcedureReturn MessageBox_ (parentWindow, Space (#StringSpace), Space (#StringSpace), #MB_ABORTRETRYIGNORE | #MB_ICONINFORMATION)
EndProcedure

MessageBoxH (0, "Search for program...", "Please select the drive to search...", "Search C:\", "Search D:\", "Cancel")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -