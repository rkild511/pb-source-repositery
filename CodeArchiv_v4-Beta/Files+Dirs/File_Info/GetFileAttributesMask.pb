; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6065&highlight=
; Author: PB
; Date: 05. May 2003
; OS: Windows
; Demo: No

Procedure.s GetAttribMask(file$) 
  mask$="-----" : r=GetFileAttributes_(file$) 
  If r & #FILE_ATTRIBUTE_ARCHIVE : mask$="A"+Mid(mask$,2,5) : EndIf 
  If r & #FILE_ATTRIBUTE_COMPRESSED : mask$=Left(mask$,1)+"C"+Mid(mask$,3,3) : EndIf 
  If r & #FILE_ATTRIBUTE_HIDDEN : mask$=Left(mask$,2)+"H"+Mid(mask$,4,2) : EndIf 
  If r & #FILE_ATTRIBUTE_READONLY : mask$=Left(mask$,3)+"R"+Mid(mask$,5,1) : EndIf 
  If r & #FILE_ATTRIBUTE_SYSTEM : mask$=Left(mask$,4)+"S" : EndIf 
  ProcedureReturn mask$ 
EndProcedure 
; 
Debug GetAttribMask("c:\test.txt") 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
