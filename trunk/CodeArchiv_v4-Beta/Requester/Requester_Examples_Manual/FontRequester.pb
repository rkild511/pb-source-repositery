; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 13. May 2003
; OS: Windows
; Demo: Yes

FontName$ = "Arial"   ; set initial font  (could also be blank)
FontSize  = 14        ; set initial size  (could also be null)
Result.l = FontRequester(FontName$,FontSize,0)
If Result
  a$ = "You have selected following font:"  + Chr(10)  ; Chr(10) only needed
  a$ + "Name:  " + SelectedFontName()       + Chr(10)  ; for line-feed
  a$ + "Size:  " + Str(SelectedFontSize())  + Chr(10)
  a$ + "Color: " + Str(SelectedFontColor())
Else  
  a$ = "The requester was canceled."
EndIf
MessageRequester("Information",a$,0)
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -