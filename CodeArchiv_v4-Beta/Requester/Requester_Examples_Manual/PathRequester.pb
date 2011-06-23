; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 24. May 2003
; OS: Windows
; Demo: Yes

StandardPath$ = "C:\"   ; set initial path to display (could also be blank)
Path$ = PathRequester("Please choose your path", StandardPath$)
If Path$
  MessageRequester("Information", "You have selected following path:"+Chr(10)+Path$, 0)
Else
  MessageRequester("Information", "The requester was canceled.", 0) 
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -