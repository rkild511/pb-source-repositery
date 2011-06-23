; German forum:
; Author: Feri (updated for PB4.00 by blbltheworm)
; Date: 04. January 2003
; OS: Windows
; Demo: No


; Note: need the SkinWin library of Danilo, get it from Ressource site or as part of his PureTools !

 ; Farben im ProgressBarGadget ändern
; ----------------------------------
OpenWindow(0,300,500,270,30,"Testfenster",#PB_Window_SystemMenu)
;
  SetWindowColor(0,RGB(0,0,0))             ;  Hintergrundfarbe des Window ändern
;
CreateGadgetList(WindowID(0))
  ProgressBarGadget(1,10,10,250,10,0,1000,#PB_ProgressBar_Smooth)
; 
  SendMessage_(GadgetID(1),#CCM_SETBKCOLOR,0,RGB(60,50,0))  ;  Hintergrundfarbe im ProgressBarGadget ändern
  SendMessage_(GadgetID(1),#WM_USER+9,0,RGB(250,220,80))    ;  Balkenfarbe des ProgressBarGadget ändern
;
SetGadgetState(1,500)    ;   als Beispielwert
;
Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -