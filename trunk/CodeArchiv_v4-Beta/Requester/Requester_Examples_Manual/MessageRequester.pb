; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 18. May 2003
; OS: Windows
; Demo: Yes

; Simple MessageRequester  (normally used for information purposes only)
; (result will be always the same, so we don't check it here)
MessageRequester("Information","Just a short information text.",#PB_MessageRequester_Ok)

; MessageRequester with Yes / No buttons  (normally used for questions)
; (result will be shown in the following information requester)
Result = MessageRequester("Title","Please make your input:",#PB_MessageRequester_YesNo)
a$ = "Result of the previously requester was: "
If Result = 6     ; pressed Yes button (Result = 6)
  a$ + "Yes"
Else              ; pressed No button (Result = 7)
  a$ + "No"
EndIf
MessageRequester("Information",a$,#PB_MessageRequester_Ok)

; MessageRequester with Yes / No / Cancel buttons  (normally used for questions)
; (result will be shown in the following information requester)
Result = MessageRequester("Title","Please make your input:",#PB_MessageRequester_YesNoCancel) 
a$ = "Result of the previously requester was: "
If Result = 6        ; pressed Yes button (Result = 6)
  a$ + "Yes"
ElseIf Result = 7    ; pressed No button (Result = 7)
  a$ + "No"
Else                 ; pressed Cancel button or Esc (Result = 2)
  a$ + "Cancel"
EndIf
MessageRequester("Information",a$,#PB_MessageRequester_Ok)

End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -