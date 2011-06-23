; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=759&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 01. May 2003
; OS: Windows
; Demo: No

Procedure NewWindowStyle(hwnd.l) 
  GRgn.l 
  RgnA.l 
  RgnB.l 
  
  ;  Erzeugen der Regionen 
  RgnB = CreateEllipticRgn_(0,0, 100, 200) 
  RgnA = CreateRoundRectRgn_(98, 0, 200, 200, 30, 30) 

  ;Regionen kombinieren 
  GRgn = RgnA 
  CombineRgn_(GRgn, GRgn, RgnB, #RGN_OR) 

  ;auf das Fenster anwenden 
  SetWindowRgn_(hwnd, GRgn, True) 

  HideWindow(0,0) ; Das Fenster anzeigen 
EndProcedure 

hwnd.l = OpenWindow(0, 100, 100, 200, 200, "PureBasic Window",#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_Invisible) 
If hwnd 
NewWindowStyle(hwnd) 
  Repeat 
    EventID.l = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
