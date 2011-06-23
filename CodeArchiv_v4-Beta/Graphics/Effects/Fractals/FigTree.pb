; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2911&highlight=
; Author: remi_meier (updated for PB4.00 by blbltheworm)
; Date: 23. November 2003
; OS: Windows
; Demo: Yes

; kleines Fraktal, das Feigenbaum-Szenario
#faktor = 400 
#yKorr = 500 
#anzIterationen = 500 
#von = 1 
#bis = 400  ;max 400 

farbe=RGB(255,0,0) 

If OpenWindow(1,100,100,800,600,"Feigenbaumszenario",#PB_Window_SystemMenu) 
  StartDrawing(WindowOutput(1)) 
  For z = #von To #bis 
    y.f = 0.7 
    x.f = z / 100 
    For i = 1 To #anzIterationen 
      y = x * y * (1 - y) 
      Plot(z, Round(y * #faktor,1) * (-1) + #yKorr,farbe) 
    Next 
  Next 
  StopDrawing() 
  
  Repeat 
  Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
