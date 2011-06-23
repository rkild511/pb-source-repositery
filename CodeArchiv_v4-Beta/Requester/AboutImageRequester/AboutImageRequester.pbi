Procedure AboutImageRequester(WindowID.l,Title$,Text1$,Text2$,Image$)
  LoadImage(1, Image$) : Image.l=ImageID(1) : ShellAbout_(WindowID, Title$+" # "+Text1$, Text2$, Image)
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 3
; Folding = -
; EnableXP