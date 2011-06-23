; www.purearea.net
; Author: Unknown (updated for PB4.00 by Andre)
; Date: 07. March 2003
; OS: Windows
; Demo: No

OpenConsole() 
PrintN("Piep") 

Repeat 
  w + 5 
  If w = 360: w = 0: EndIf 
  b.f = 2 * 3.141 * w / 360 ; Winkel zu Bogenmaﬂ 
  f = Sin(b) * 400 + 500 
  Beep_(f,10) 
Until Inkey() <> ""
CloseConsole()
End


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -