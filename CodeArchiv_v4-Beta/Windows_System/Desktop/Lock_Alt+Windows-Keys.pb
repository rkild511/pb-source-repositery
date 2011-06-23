; English forum: 
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 26. September 2002
; OS: Windows
; Demo: No

; Important note!
; Please be aware of the right code to unlock the screen: 123

; 
; by Danilo, Posted - 26 Sep 2002 :  03:14:34  (engl. forum) 
; 

; merendo, 
; 
; on winNT/2000/XP no program is allowed To 
; block the CTRL+ALT+DEL, because this would 
; be a security risc. 
; Every program could block CTRL+ALT+DEL And 
; do what it wants... And the user couldnt stop 
; it anymore. 
; 
; If you use Windows98, you can do it by telling 
; windows your app is a screensaver. 
; 
; This code disables ALT+TAB, ATL+ESC, And Windows-Keys... 
; ...also on Win2000: 



; The line " SystemParametersInfo_( #SPI_SCREENSAVERRUNNING, 1, @Dummy, 0) " 
; is For Windows 9x Systems. 
; It tells Windows that a screensaver is running, so it blocks 
; all other input on Win9x. 
SystemParametersInfo_( #SPI_SCREENSAVERRUNNING, 1, @Dummy, 0); 



OpenLibrary(1,"kernel32.dll") 
CallFunction(1,"RegisterServiceProcess", GetCurrentProcessId_(), 1 ) 
  
Structure KBDLLHOOKSTRUCT 
  vkCode.l 
  scanCode.l 
  flags.l 
  time.l 
  dwExtraInfo.l 
EndStructure 

Global hook 
  
Procedure.l myKeyboardHook(nCode, wParam, *p.KBDLLHOOKSTRUCT) 
   If nCode = #HC_ACTION 
      If wParam = #WM_KEYDOWN Or wParam = #WM_SYSKEYDOWN Or wParam = #WM_KEYUP Or wParam = #WM_SYSKEYUP 
         #LLKHF_ALTDOWN = $20 
         If ((*p\vkCode = #VK_TAB) And (*p\flags & #LLKHF_ALTDOWN)) Or ((*p\vkCode = #VK_ESCAPE) And (*p\flags & #LLKHF_ALTDOWN)) Or ((*p\vkCode & #VK_ESCAPE) And (GetKeyState_(#VK_CONTROL) & $8000)) ;Or 
            ProcedureReturn 1 
         ElseIf (*p\vkCode = #VK_LWIN) Or (*p\vkCode = #VK_RWIN) 
            ProcedureReturn 1 
         EndIf 
       EndIf 
    EndIf 
;beep_(800,1) 
ProcedureReturn CallNextHookEx_(hook, nCode, wParam, lParam) 
EndProcedure 
  
  
; Win NT 
#WH_KEYBOARD_LL = 13 
hook = SetWindowsHookEx_(#WH_KEYBOARD_LL,@myKeyboardHook(),GetModuleHandle_(0),0) 
;If hook = 0: End: EndIf 
  
hWnd = OpenWindow(1,10,10,100,100,"",#PB_Window_BorderLess) 
       ShowWindow_(hWnd, #SW_MAXIMIZE) 
       ;SetWinBackgroundColor(hWnd,0) 
  
       CreateGadgetList(hWnd) 
       hString = StringGadget(1,GetSystemMetrics_(#SM_CXSCREEN)/2-100/2, GetSystemMetrics_(#SM_CYSCREEN)/2,100,20,"Enter Password",#PB_String_Numeric) 
  
       SetFocus_(hString) 
       GetWindowRect_(hString, winrect.RECT) 
       ;SetThreadPriority_(GetCurrentThread_(),#REALTIME_PRIORITY_CLASS) 
  
Repeat 
   Message = WindowEvent() 
             SetActiveWindow_(hWnd) 
             SetWindowPos_(hWnd,#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
             ClipCursor_(winrect) 
             SendMessage_(hString,#WM_KEYDOWN,#VK_END,0) 
             SetFocus_(hString) 
   If Message 
      Select Message 
         Case #PB_Event_Gadget 
             Select EventGadget() 
                Case 1 
                     If GetGadgetText(1) = "123" 
                        UnhookWindowsHookEx_(hook) 
                        ClipCursor_(0) 
                        SystemParametersInfo_( #SPI_SCREENSAVERRUNNING, 0, @Dummy, 0); 
                        End 
                     EndIf 
             EndSelect 
      EndSelect 
   Else 
      Delay(1) 
   EndIf 
ForEver 

; But CTRL+ALT+DEL can on win2000 only be disabled 
; by writing a lowlevel system device driver For the keyboard. 
; Info about this should be in the MS DDK. 
; 
; Best way For you would be To install win98 
; on your disco machine... 
; 
; cya, 
; ...Danilo 
; 
; (registered PureBasic user) 
; 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger