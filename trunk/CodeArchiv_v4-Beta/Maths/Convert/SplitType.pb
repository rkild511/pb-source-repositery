; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7113&highlight=
; Author: venom (updated for PB4.00 by blbltheworm)
; Date: 03. August 2003
; OS: Windows
; Demo: Yes


; Heres a Split like function I made after the BCX version. 

; Stores all words in w 
Global Dim w.s(0) 

Procedure.l CountSep(str.s,sep.s) 
  o_si=1 
  For si=1 To Len(str) 
    sc.s=Mid(str,si,1) 
    If in_str.s="" And (sc="'" Or sc=Chr(34)) 
      in_str=sc 
    ElseIf sc=in_str 
      in_str="" 
    EndIf 
    If in_str="" 
      For i=1 To Len(sep) 
        c.s=Mid(sep,i,1) 
        If c=sc 
          word.s=Mid(str,o_si,si-o_si) 
          If word<>"" 
            wi+1 
          EndIf 
          wi+1 
          o_si=si+1 
        EndIf 
      Next 
    EndIf 
  Next 
  word=Mid(str,o_si,Len(str)) 
  If word<>"" 
    wi+1 
  EndIf 
  ProcedureReturn wi 
EndProcedure 


Procedure.l Split(str.s,sep.s) 
  o_si=1 
  For si=1 To Len(str) 
    sc.s=Mid(str,si,1) 
    If in_str.s="" And (sc="'" Or sc=Chr(34)) 
      in_str=sc 
    ElseIf sc=in_str 
      in_str="" 
    EndIf 
    If in_str="" 
      For i=1 To Len(sep) 
        c.s=Mid(sep,i,1) 
        If c=sc 
          word.s=Mid(str,o_si,si-o_si) 
          If word<>"" 
            w(wi)=word 
            wi+1 
          EndIf 
          w(wi)=c 
          wi+1 
          o_si=si+1 
        EndIf 
      Next 
    EndIf 
  Next 
  word=Mid(str,o_si,Len(str)) 
  If word<>"" 
    w(wi)=word 
    wi+1 
  EndIf 
  ProcedureReturn wi 
EndProcedure 
 

; Function and using
; ------------------

; ret=CountSep(str, sep) is used to count the separations in str. Returns the total number of 
; words for reDim'ng w with. 

; ret=Split(str, sep) just like CountSep but actually stores the words and separators in w(). 

; 'str' the string to split up. 
; 'sep' is a string holding the separator(s). 
; 'ret' is number of words including separators. 

; 'w()' array of words and separators. 

; *strings in 'str' beginning and ending with ' or " are preserved. 


;- Example: 

a.s="1+2+3-1 'hello+1-2'" 
sep.s=" +-" 

count=CountSep(a,sep) 
Global Dim w.s(count-1) 
Split(a,sep) 
For i=0 To count-1 
  Debug w(i) 
Next 
 

;- Result:
; In Debug it should be: 
; 1 
; + 
; 2 
; + 
; 3 
; - 
; 1 

; 'hello+1-2'

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
