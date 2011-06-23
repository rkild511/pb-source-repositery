; German forum: 
; Author:
; Date: 28. April 2003
; OS: Windows
; Demo: Yes

DataSection 
  hilfeadresse: 
  IncludeBinary "test.txt" 
  Data.b 0 
EndDataSection 

hilfetext.s = PeekS(?hilfeadresse) 
MessageRequester("hilfe", hilfetext, 0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -