; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7073&highlight=
; Author: Paul
; Date: 30. July 2003
; OS: Windows
; Demo: No

Buffer$=Space(512) 
FileName$="client.db" 

GetFullPathName_(FileName$,Len(Buffer$),@Buffer$,@FilePart) 

Debug Buffer$
Debug PeekS(FilePart) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
