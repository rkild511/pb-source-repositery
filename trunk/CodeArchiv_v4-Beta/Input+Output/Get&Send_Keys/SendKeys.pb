; German forum:
; Author: Danilo
; Date: 07. April 2003
; OS: Windows
; Demo: No


; Posted 07 April 2003 by Danilo on german forum

;SendKeys(handel,Window$,Keys$) 

;Handel ......... ist ein Handel zu einen Fenster bekommst du wenn du das Fenster erzeugst. 
;Window$ ........ Ist der Name des Fesnters, wenn du den Handel nicht kennst. In dem Fall gibt man dan Handel = 0 an. 
;Keys$ .......... Sind die Tasten die du schicken möchtest, wobei du Sondertasten in {} Einschliest (zb. {CONTROLDOWN}) 

; SendKeys procedure by PB -- do whatever you want with it. :) 
; Syntax: r=SendKeys(handle,window$,keys$) ; r = 0 for failure. 
; Specify either a handle or window$ title to type to, but not both! 
; You cannot type curly braces { } as part of the keystrokes, sorry! 
; 
Procedure SendKeys(handle,window$,keys$) 
If window$<>"" : handle=FindWindow_(0,window$) : EndIf ; Use window$ instead of handle. 
   If IsWindow_(handle)=0 ; Does the target window actually exist? 
      ProcedureReturn 0 ; Nope, so report 0 for failure to type. 
   Else 
   ; This block gives the target window the focus before typing. 
   thread1=GetWindowThreadProcessId_(GetForegroundWindow_(),0) 
   thread2=GetWindowThreadProcessId_(handle,0) 
   If thread1<>thread2 : AttachThreadInput_(thread1,thread2,#True) : EndIf 
      SetForegroundWindow_(handle) ; Target window now has the focus for typing. 
      Delay(125) ; 1/8 second pause before typing, to prevent fast CPU problems. 
      ; Now the actual typing starts. 
      For r=1 To Len(keys$) 
          vk$=Mid(keys$,r,1) 
          If vk$="{" ; Special key found. 
             s=FindString(keys$,"}",r+1)-(r+1) ; Get length of special key. 
             s$=Mid(keys$,r+1,s) ; Get special key name. 
             Select s$ ; Get virtual key code of special key. 
                Case "ALTDOWN" : keybd_event_(#VK_MENU,0,0,0) ; Hold ALT down. 
                Case "ALTUP" : keybd_event_(#VK_MENU,0,#KEYEVENTF_KEYUP,0) ; Release ALT. 
                Case "BACKSPACE" : vk=#VK_BACK 
                Case "CONTROLDOWN" : keybd_event_(#VK_CONTROL,0,0,0) ; Hold CONTROL down. 
                Case "CONTROLUP" : keybd_event_(#VK_CONTROL,0,#KEYEVENTF_KEYUP,0) ; Release CONTROL. 
                Case "DELETE" : vk=#VK_DELETE 
                Case "DOWN" : vk=#VK_DOWN 
                Case "END" : vk=#VK_END 
                Case "ENTER" : vk=#VK_RETURN 
                Case "F1" : vk=#VK_F1 
                Case "F2" : vk=#VK_F2 
                Case "F3" : vk=#VK_F3 
                Case "F4" : vk=#VK_F4 
                Case "F5" : vk=#VK_F5 
                Case "F6" : vk=#VK_F6 
                Case "F7" : vk=#VK_F7 
                Case "F8" : vk=#VK_F8 
                Case "F9" : vk=#VK_F9 
                Case "F10" : vk=#VK_F10 
                Case "F11" : vk=#VK_F11 
                Case "F12" : vk=#VK_F12 
                Case "ESCAPE" : vk=#VK_ESCAPE 
                Case "HOME" : vk=#VK_HOME 
                Case "INSERT" : vk=#VK_INSERT 
                Case "LEFT" : vk=#VK_LEFT 
                Case "PAGEDOWN" : vk=#VK_NEXT 
                Case "PAGEUP" : vk=#VK_PRIOR 
                Case "PRINTSCREEN" : vk=#VK_SNAPSHOT 
                Case "RETURN" : vk=#VK_RETURN 
                Case "RIGHT" : vk=#VK_RIGHT 
                Case "SHIFTDOWN" : shifted=1 : keybd_event_(#VK_SHIFT,0,0,0) ; Hold SHIFT down. 
                Case "SHIFTUP" : shifted=0 : keybd_event_(#VK_SHIFT,0,#KEYEVENTF_KEYUP,0) ; Release SHIFT. 
                Case "TAB" : vk=#VK_TAB 
                Case "UP" : vk=#VK_UP 
             EndSelect 
             If Left(s$,3)<>"ALT" And Left(s$,7)<>"CONTROL" And Left(s$,5)<>"SHIFT" 
                keybd_event_(vk,0,0,0) : keybd_event_(vk,0,#KEYEVENTF_KEYUP,0) ; Press the special key. 
             EndIf 
             r=r+s+1 ; Continue getting the keystrokes that follow the special key. 
          Else 
             vk=VkKeyScanEx_(Asc(vk$),GetKeyboardLayout_(0)) ; Normal key found. 
             If vk>304 And shifted=0 : keybd_event_(#VK_SHIFT,0,0,0) : EndIf ; Due to shifted character. 
             keybd_event_(vk,0,0,0) : keybd_event_(vk,0,#KEYEVENTF_KEYUP,0) ; Press the normal key. 
             If vk>304 And shifted=0 : keybd_event_(#VK_SHIFT,0,#KEYEVENTF_KEYUP,0) : EndIf ; Due to shifted character. 
          EndIf 
      Next 
      If thread1<>thread2 : AttachThreadInput_(thread1,thread2,#False) : EndIf ; Finished typing to target window! 
      keybd_event_(#VK_MENU,0,#KEYEVENTF_KEYUP,0) ; Release ALT key if user forgot. 
      keybd_event_(#VK_CONTROL,0,#KEYEVENTF_KEYUP,0) ; Release CONTROL key if user forgot. 
      keybd_event_(#VK_SHIFT,0,#KEYEVENTF_KEYUP,0) ; Release SHIFT key if user forgot. 
      ProcedureReturn 1 ; Report successful typing! :) 
   EndIf 
EndProcedure 
; 
m$= "This example types some text to Notepad, then clears and closes it."+Chr(13) 
m$=m$+"Open a new Notepad window, then click the OK button and watch! :)" 
MessageRequester("SendKeys example",m$,#MB_ICONINFORMATION) 
; 
RunProgram("c:\winnt\notepad.exe","","",0) 
w$="Untitled - Notepad" ; Specifies target window name. 
Delay(1000) : SendKeys(0,w$,"This is a test!") ; Type some dummy text. 
Delay(1000) : SendKeys(0,w$,"{CONTROLDOWN}a{CONTROLUP}") ; Select it all. 
Delay(1000) : SendKeys(0,w$,"{DELETE}")      ; Delete it. 

Delay(1000) : SendKeys(0,w$,"{CONTROLDOWN}p{CONTROLUP}") 

;Delay(1000) : SendKeys(0,w$,"{ALTDOWN}{F4}") ; Close the Notepad Window
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -