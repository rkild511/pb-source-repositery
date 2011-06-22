; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=906&highlight=
; Author: Volker
; Date: 06. May 2003

; Klartext 
; 
; ändert die EM_SETPASSWORDCHAR-Eigenschaft eines Textfeldes via API, 
; so dass das Auslesen des Passwortes im Klartext möglich wird. 
; Nach dem Start den Cursor über ein Passwort-Textfeld bewegen. 
; 
; 06.05.2003 Volker 

#SWP_NOMOVE = $2 
#SWP_NOSIZE = $1 
#HWND_TOPMOST = -1 
#HWND_NOTOPMOST = -2 

#EM_SETPASSWORDCHAR = $CC 

#Text1 = 1 
#Label2 = 2 

Global hwnd.l 

Structure POINTAPI 
X.l 
Y.l 
EndStructure 


;/////////////////////////////////////////////////////////// 
Procedure getWindowUM() 
;/////////////////////////////////////////////////////////// 
Dim P.POINTAPI(1) 
lo.l 
str.s 

;Cursorposition auslesen 
GetCursorPos_(P(0)) 

;Das entsprechende Fenster finden 
lo = WindowFromPoint_(P(0)\X, P(0)\Y) 

;Den Titel auslesen 
str = Str(GetWindowTextLength_(lo)) 
GetWindowText_ (lo, str, 100) 

;Ergebnis anzeigen 
SetGadgetText (#Text1, str) 

;Den Passwortcharacter entfernen 
SendMessage_ (lo, #EM_SETPASSWORDCHAR, 0, "") 

Delay (10) 

EndProcedure 


;/////////////////////////////////////////////////////////// 
Procedure Open_Window() 
;/////////////////////////////////////////////////////////// 
hwnd = OpenWindow(#Label2, 352, 182, 270, 98, #PB_Window_MinimizeGadget |#PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar , "Klartext") 
If CreateGadgetList(WindowID()) 
StringGadget(#Text1, 10, 10, 250, 30, "") 
EndIf 
EndProcedure 



;-Main //////////////////////////////////////////////////////////////////////////////// 

Open_Window() 

;Formular immer oben halten 
SetWindowPos_ (hwnd, #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE) 

Repeat 
Event = WaitWindowEvent() 
getWindowUM() 
Delay (10) 
Until Event = #PB_EventCloseWindow 
End
; ExecutableFormat=Windows
; CursorPosition=4
; FirstLine=1
; EOF