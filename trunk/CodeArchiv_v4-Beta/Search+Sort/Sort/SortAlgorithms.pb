; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2123&highlight=
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 18. February 2005
; OS: Windows, Linux
; Demo: Yes


; Verschiedene Sortieralgorithmen
; Several sort algorithms

#N=10 
Global Dim a(#N) 

Procedure bubble() 
  i.l 
  j.l 
  t.l 
  For i=#N To 1 Step -1 
    For j=2 To i 
      If a(j-1)>a(j) 
        t=a(j-1) 
        a(j-1)=a(j) 
        a(j)=t 
      EndIf 
    Next 
  Next 
EndProcedure 


Procedure insertion() 
  i.l 
  j.l 
  v.l 
  For i=2 To #N 
    v=a(i) 
    j=i 
    While a(j-1)>v 
      a(j)=a(j-1) 
      j-1 
    Wend 
    a(j)=v 
  Next 
EndProcedure 


Procedure quicksort(l,r) 
  v.l 
  t.l 
  i.l 
  j.l 
  If r>l 
    v=a(r) 
    i=l-1 
    j=r 
    Repeat 
      Repeat 
        i+1 
      Until a(i)>=v 
      Repeat 
        j-1 
      Until a(j)<=v 
      t=a(i) 
      a(i)=a(j) 
      a(j)=t 
    Until j<=i 
    a(j)=a(i) 
    a(i)=a(r) 
    a(r)=t 
    quicksort(l,i-1) 
    quicksort(i+1,r) 
  EndIf 
EndProcedure 


Procedure selection() 
  i.l 
  j.l 
  min.l 
  t.l 
  For i=1 To #N-1 
    min=i 
    For j=i+1 To #N 
      If a(j)<a(min) 
        min=j 
      EndIf 
    Next 
    t=a(min) 
    a(min)=a(i) 
    a(i)=t 
  Next 
EndProcedure 


Procedure shellsort() 
  i.l 
  j.l 
  h.l 
  v.l 
  h=1 
  Repeat 
    h=3*h+1 
  Until h>#N 
  
  Repeat 
    h=Int(h/3) 
    For i=h+1 To #N 
      v=a(i) 
      j=i 
      While a(j-h)>v 
        a(j)=a(j-h) 
        j=j-h 
        If j<=h 
          Break 
        EndIf 
      Wend 
      a(j)=v 
    Next 
  Until h=1 
EndProcedure 


; +++++++++++++++++++++++++++++++++++++++++
Debug "Bubble Sort..."
Restore daten 
For z=1 To #N 
  Read a(z) 
  k.s+Str(a(z))+" " 
Next 
Debug k 
k="" 

bubble() 

For z=1 To #N 
  k.s+Str(a(z))+" " 
Next 
Debug k 



; +++++++++++++++++++++++++++++++++++++++++
Debug "Quick Sort..."
Restore daten 
For z=1 To #N 
  Read a(z) 
  k.s+Str(a(z))+" " 
Next 
Debug k 
k="" 

quicksort(1,#N) 

For z=1 To #N 
  k.s+Str(a(z))+" " 
Next 
Debug k 



; +++++++++++++++++++++++++++++++++++++++++
Debug "Insertion Sort..."
Restore daten 
For z=1 To #N 
  Read a(z) 
  k.s+Str(a(z))+" " 
Next 
Debug k 
k="" 

insertion() 

For z=1 To #N 
  k.s+Str(a(z))+" " 
Next 
Debug k 



; +++++++++++++++++++++++++++++++++++++++++
Debug "Selection Sort..."
Restore daten 
For z=1 To #N 
  Read a(z) 
  k.s+Str(a(z))+" " 
Next 
Debug k 
k="" 

selection() 

For z=1 To #N 
  k.s+Str(a(z))+" " 
Next 
Debug k 



; +++++++++++++++++++++++++++++++++++++++++
Debug "Shell Sort..."
Restore daten 
For z=1 To #N 
  Read a(z) 
  k.s+Str(a(z))+" " 
Next 
Debug k 
k="" 

shellsort() 

For z=1 To #N 
  k.s+Str(a(z))+" " 
Next 
Debug k 





;- Data section
DataSection 
  daten: 
    Data.l 5,1,3,9,2,4,6,8,7,0 
EndDataSection 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -