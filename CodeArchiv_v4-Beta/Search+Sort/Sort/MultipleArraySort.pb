; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6071&highlight=
; Author: geoff (updated for PB4.00 by blbltheworm)
; Date: 05. May 2003
; OS: Windows
; Demo: Yes

; The PureBasic command SortArray() is fast and convenient but you 
; often need to put several arrays into consistent order. 

; For example, if you have the arrays word$() and meaning$() And want to 
; create a dictionary then you would need to sort both arrays using the alphabetical 
; order of the word$() array. 

;Instead of sorting the arrays you can create an index array, sort this using 
; one of the arrays and then use the sorted index to access all the arrays. 
; This can be quicker than sorting the actual arrays. 

; My Procedure QuickSortIndex() does this index sort. 
; It works with any variable types defined in the Dim statement 


max=10000 
Global Dim sort(max);could be defined as long, float, string etc 
Global Dim indx.l(max) 
Global Dim word(max); angepasst von Falko da word(i) undefiniert war

Procedure QuickSortIndex(s,e) 
  i=s 
  j=e 
  k=indx((i+j)/2) 
  Repeat 
    While sort(indx(i))<sort(k): i=i+1: Wend 
    While sort(indx(j))>sort(k): j=j-1: Wend 
    If i<=j 
      tem=indx(i): indx(i)=indx(j): indx(j)=tem 
      i=i+1: j=j-1 
    EndIf 
  Until i>j 
  If j>s:QuickSortIndex(s,j):EndIf 
  If i<e:QuickSortIndex(i,e):EndIf 
EndProcedure 


; Example of procedure use 

For i=0 To max 
  sort(i)=word(i)   ; as in the dictionary example, sort using word() 
  indx(i)=i         ; set up initial index order 
Next i 
QuickSortIndex(0,max) 

;now access element i of each array using word(indx(i)), meaning(indx(i)) etc 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
