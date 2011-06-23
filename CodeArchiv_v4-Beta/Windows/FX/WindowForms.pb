; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1872&highlight=
; Author: cnesm  (updated for PB4.00 by blbltheworm)
; Date: 30. July 2003
; OS: Windows
; Demo: No

StandartFenster=OpenWindow(0, 10, 10, 300, 300, "Beispiel für Fensterformen", #PB_Window_ScreenCentered ) 

;=================================================================== 
;1. Beispiel 
EntgueltigesFenster=CreateRectRgn_(0,0,0,0) 
AnzuzeigenderBereich=CreateRectRgn_(0,0,306,325) 
UnsichtbarerBereich=CreateRectRgn_(50,65,256,275) 
CombineRgn_(EntgueltigesFenster,AnzuzeigenderBereich,UnsichtbarerBereich,3) 
SetWindowRgn_(StandartFenster,EntgueltigesFenster,1) 
;=================================================================== 

;=================================================================== 
;2. Beispiel 
;EntgueltigesFenster=CreateRectRgn_(0,0,0,0) 
;AnzuzeigenderBereich=CreateRectRgn_(0,0,0,0) 
;AnzuzeigenderBereich2=CreateEllipticRgn_(50,10,250,210) 
;CombineRgn_(EntgueltigesFenster,AnzuzeigenderBereich,AnzuzeigenderBereich2,3) 
;SetWindowRgn_(StandartFenster,EntgueltigesFenster,1) 
;=================================================================== 

Repeat 
  EventID.l = WaitWindowEvent() 

  If EventID = #PB_Event_CloseWindow  
     Quit = 1 
  EndIf 

  Until Quit = 1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
