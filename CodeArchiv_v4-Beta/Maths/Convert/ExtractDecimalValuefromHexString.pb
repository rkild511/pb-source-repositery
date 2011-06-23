; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8828&highlight=
; Author: Froggerprogger
; Date: 23. December 2003
; OS: Windows
; Demo: Yes

; Some notes:
; -----------
; There's no difference between a hex-value and a decimal value except for the notation. 
; The functions that are writing into a file do always request even binary numbers - as
; every function in a programming language - but they don't care if they are notated as
; e.g. (decimal) 32 or $20 or %100000 

; So you'll have to parse the string and get the value from it (there it is important,
; that it is notated as a hex-value) and then store this value to your file. 
; If you view the file-content with a HEX-Editor, you'll see the values in HEX-notation,
; but they have the same value as the decimal. 
; So e.g. you have a string that contains $20, you'll get the decimal value 32 from it
; and store the value 32 to file. 
; A Hex-Editor will view it as '20' again, but it's value to calculate with is still 32. 

; Here's a routine to get the decimal value from a string that contains Hex-data: 


; 23.12.2003 by Froggerprogger 
; parses from right to left and retrieves the value of a maximum of 8 chars 
; interpretated as a HEX-number or if a non-valid char or the end is reached. 
; it works case-insensitive, so 'af' = 'AF' 
Procedure GetValueFromHexString(str.s) 
  If Len(str) = 0 
    ProcedureReturn -1 
  EndIf 
  
  str = UCase(str) 
  
  Protected actCharAsc.l, result.l 
  Protected strLen.l      : strLen = Len(str) 
  Protected parseAct.l    : parseAct = @str + strLen - 1 
  Protected parseEnd.l    : parseEnd = parseStart - 7 
  Protected posFact.l     : posFact = 1 
  Protected radix.l       : radix = 16 
    
  actCharAsc = PeekB(parseAct)&$FF 
  
  While ((actCharAsc >= 48 And actCharAsc <= 57) Or (actCharAsc >= 65 And actCharAsc <= 70)) And parseAct >= parseEnd 
    If actCharAsc >= 65 
      actCharAsc - 7 
    EndIf 
    actCharAsc - 48 ; so '0'-'F' has values 0 - 15 
    result + posFact * actCharAsc 
    parseAct - 1 
    posFact * 16 
    actCharAsc = PeekB(parseAct)&$FF 
  Wend 
  
  ProcedureReturn result 
EndProcedure 

Debug GetValueFromHexString("(§/346&(=20") 
Debug GetValueFromHexString("$7FFffFFf") 
Debug GetValueFromHexString("$80000000") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
