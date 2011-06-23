; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3893&start=15
; Author: paulr
; Date: 14. November 2003
; OS: Windows
; Demo: No


; Send a string to a specified program window, we are using the NotePad as example...

WinTitle$ = "Untitled - Notepad"    ; english window title of NotePad
; WinTitle$ = "Unbenannt - Editor"    ; german window title of NotePad

Procedure SendAKey(key.s) 
  vk = VkKeyScan_(Asc(key)) 
  If vk>320:keybd_event_(#VK_LSHIFT,1,0,0):EndIf 
  keybd_event_(vk,1,0,0) 
  keybd_event_(vk,1,#KEYEVENTF_KEYUP,0) 
  If vk>320 
    keybd_event_(#VK_LSHIFT,1,0,0) 
    keybd_event_(#VK_LSHIFT,1,#KEYEVENTF_KEYUP,0) 
  EndIf 
EndProcedure 

RunProgram("Notepad.exe") 
Delay(3000) 
handle.l=FindWindow_(0, WinTitle$) 
If handle>0 
  OpenIcon_(handle) 
  SetForegroundWindow_(handle) 
  SetActiveWindow_(handle) 
  Delay(3000) 
  a$="abc-123-XYZ" 
  For r=1 To Len(a$) 
    SendAKey(Mid(a$,r,1)) 
  Next 
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
