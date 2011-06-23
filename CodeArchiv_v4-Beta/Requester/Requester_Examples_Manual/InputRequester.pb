; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 18. May 2003
; OS: Windows
; Demo: Yes

Input$ = InputRequester("Title","Please make your input:","I'm the default input.")

If Input$ > ""
  a$ = "You've written following in the requester:" + Chr(10)  ; Chr(10) only needed
  a$ + Input$                                                  ; for line-feed
Else  
  a$ = "The requester was canceled or the were no input."
EndIf
MessageRequester("Information",a$,0)
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -