; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7530&highlight=
; Author: sec
; Date: 13. September 2003
; OS: Windows
; Demo: Yes

Dim SortmeF(100) 

OpenConsole() 
PrintN("before sorting...") 
For i=0 To 10 
   SortmeF(i)=Random(500) 
   Print(Str(SortmeF(i))+" ") 
Next i 
PrintN("") 
PrintN("after sorting...") 

l = 0 
r = 10 

qsort: 
    i = l 
    j = r 
    pivot = SortmeF(l) 


    While (i<=j) 
        While SortmeF(i)<pivot: i+1: Wend 
        While SortmeF(j)>pivot: j-1: Wend 

        If (i<=j) 
            temp=SortmeF(i) : SortmeF(i)=SortmeF(j) : SortmeF(j)=temp 
            i+1 
            j-1 
        EndIf 
    Wend 
    If (l<j) : r=j : Goto qsort : EndIf 
    If (i<r) : l=i : Goto qsort : EndIf 


For i=0 To 10 
   Print(Str(SortmeF(i))+" ") 
Next i 
Input() 
CloseConsole() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
