; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7503&highlight=
; Author: Andre (description by sec)
; Date: 11. September 2003
; OS: Windows
; Demo: Yes

; Selection-Sort:
; ------------

; Description:
; ++++
; This is an agothirm simple sort, how it do? you image: we have an array A
; have n element , and need sort to A[0]<A[1]<...<A[n].
; First we look at A[0] and search from A[1] To A[n] , a element that minimum
; that <A[0] , we will swap this element with A[0]
; As after this step mini-est is first element of array A
; Next, we look at A[1] , and search from A[2] to A[n], a element that
; min(A[2],..,A[n]), If have we will swap with A[1]
; Next, Until A[n-1]
; and we will have a array sorted.

; Code:

n=50   ; Define number of array elements
Dim a(n)

; Fill array with random values
For i=0 To n ;-1
  a(i)=Random(n*10)
Next

Debug "Contents of unsorted array:"
Gosub output

; Sorting algorithm
For i=0 To n-1
  k=i
  For j=i+1 To n
    If a(j)<a(k) : k=j : EndIf
  Next j
  If k>i
    temp = a(i)
    a(i)=a(k)
    a(k)=temp
  EndIf
Next i

Debug "Contents of sorted array:"
Gosub output
End

output:
; Print out the array content
For i=0 To n-1
  Debug a(i)
Next
Return
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
