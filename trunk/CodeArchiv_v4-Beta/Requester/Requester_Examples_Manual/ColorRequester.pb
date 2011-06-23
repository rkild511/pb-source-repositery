; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 13. May 2003
; OS: Windows
; Demo: Yes

Color.l = ColorRequester()
If Color > -1
  a$ = "You have selected following color value:" + Chr(10)  ; Chr(10) only needed
  a$ + "24 Bit value: " + Str(Color)              + Chr(10)  ; for line-feed
  a$ + "Red value:    " + Str(Red(Color))         + Chr(10)
  a$ + "Green value:  " + Str(Green(Color))       + Chr(10)
  a$ + "Blue value:   " + Str(Blue(Color))
Else  
  a$ = "The requester was canceled."
EndIf
MessageRequester("Information",a$,0)
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -