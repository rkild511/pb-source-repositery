; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13810&highlight=
; Author: GPI (+ Andras, updated for PB 4.00 by Andre)
; Date: 01. February 2005
; OS: Windows
; Demo: Yes


Procedure.s MidSet(string$,position,length,ReplaceString$); - Replace a part in the string and return the result 
  ProcedureReturn Left(string$,position-1)+ReplaceString$+Right(string$,Len(string$)-position-length+1) 
EndProcedure 

Procedure MidSetDirect(*string.BYTE,position,*ReplaceString.BYTE); - Replace a part in the string direct! 
  *string+(position-1) 
  While *ReplaceString\b 
    *string\b=*ReplaceString\b:*string+1:*ReplaceString+1 
  Wend 
EndProcedure 

strTest.s="Hello" 
MessageRequester("Before",strTest) 

strTest = MidSet(strTest, 3, 2, "Booh") 
MessageRequester("After",strTest)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -