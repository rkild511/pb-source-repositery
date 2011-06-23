; German forum: http://www.purebasic.fr/german/viewtopic.php?t=600&highlight=
; Author: Mischa
; Date: 04. November 2004
; OS: Windows
; Demo: No

; Keyboard control in a none GUI application, so we can't use the normal 
; event handling with WaitWindowEvent() & Co.
; instead with use the WinAPI function GetAsyncKeyState_() 

; Tastaturabfrage in Programmen ohne GUI, weshalb wir das normale
; Event-Handling mittel WaitWindowEvent() & Co. nicht verwenden kˆnnen.
; Stattdessen nutzen wir die WinAPI Funktion GetAsyncKeyState_()

; Hinweise:
; Die Abfrage in Etappen gestalten, um eine Tasten-Reihenfolge zu 
; erzwingen. 
; Betrachte den Main-Loop R¸ckw‰rts: 
; -Kontrolle ob Return/F4 NICHT aber ALT(Gr) schon gedr¸ckt wird. 
; -Wenn ja (altpressed=1) -> Feinkontrolle 
; -Im letzten Schritt (keystate<>0) Tasten-Release abwarten 
; 
; Auﬂerdem ist es notwendig, vor den Tasten-Kontrollen den 
; Tastaturpuffer zu leeren. 


; Check for ALT+F4 keypress
; Esc for end
Repeat 
  If keystate 
    If GetAsyncKeyState_(keystate)=0 
      keystate=0 
      Debug "(released)" 
    EndIf 
  ElseIf altpressed 
    If GetAsyncKeyState_(#VK_MENU) 
      If GetAsyncKeyState_(#VK_RETURN) 
        keystate=#VK_RETURN 
        Debug "Alt + Return" 
      ElseIf GetAsyncKeyState_(#VK_F4) 
        keystate=#VK_F4 
        Debug "Alt + F4" 
      EndIf 
    Else 
      altpressed=0  
    EndIf 
  Else 
    ;Tastaturpuffer leeren 
    GetAsyncKeyState_(#VK_MENU) 
    GetAsyncKeyState_(#VK_ESCAPE) 
    GetAsyncKeyState_(#VK_RETURN) 
    GetAsyncKeyState_(#VK_F4) 
    
    If GetAsyncKeyState_(#VK_RETURN)=0 And GetAsyncKeyState_(#VK_F4)=0 And GetAsyncKeyState_(#VK_MENU) 
      altpressed=1 
    ElseIf GetAsyncKeyState_(#VK_ESCAPE) 
      End 
    EndIf 
  EndIf 
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger