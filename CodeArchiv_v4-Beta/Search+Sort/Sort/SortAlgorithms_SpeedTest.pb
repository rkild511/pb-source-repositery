; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7503&highlight=
; Author: Pupil (updated for PB4.00 by blbltheworm + Andre)
; Date: 16. September 2003
; OS: Windows
; Demo: Yes


; With this small assembly of previous post you can now easily compare the different
; sorting algorithms. The code below contains some algorithms that has already been
; posted, i.e. the basic BubbleSort and oldefoxx's "fastest" bubblesort variation.
; New sorting algoritms are the CombSort and the QuickSort algorithm (quicksort as
; found in the PB examples folder). 

; The CombSort algorithm is a modification of bubblesort that addresses the weakness
; of propagation from bottom to top in the bubblesort algorithm. CombSort was published
; by Box And Lacey in 1991. The algorithm is so much more efficient than the original
; bubblesort that it is in fact comparable to some of the best sorting algorithms
; there is, like QuickSort and HeapSort to name a few. In the CombSort algorithm the
; optimal value of the shrinkFactor vary from one array to another, but doesn't stray
; far away from the value 1.3. 


;- Code: 

; Compare sort algorithms: 
; BubbleSort, modified BubbleSort, CombSort, 
; QuickSort and PB internal SortArray() command 
; 
#NMAX = 5000 
Global Dim dummy.l(0) 
Global Dim array.l(#NMAX) 


; Simple Bubble sort. 
; 
Procedure BubbleSort(*ptr, n.l) 
Define.l i, j, temp, notSwitched, tmpAddress 
  tmpAddress = @dummy() 
  dummy() = *ptr 
  Repeat 
    notSwitched = #True 
    For i = 1 To n-1 
      j = i+1 
      If dummy(i) > dummy(j) 
        temp = dummy(i) 
        dummy(i) = dummy(j) 
        dummy(j) = temp 
        notSwitched = #False 
      EndIf 
    Next 
  Until notSwitched 
  dummy() = tmpAddress 
EndProcedure 

; Oldefoxxe's modified BubbleSort 
; 
Procedure BubbleSort2(*ptr, n.l) 
Define.l i, j, temp, a, b, c, tmpAddress 
  tmpAddress = @dummy() 
  dummy() = *ptr 
  For i=0 To n-1 
    If dummy(i)>dummy(i+1) 
      temp.l=dummy(i+1) 
      a.l=0 
      b.l=Int(i/2) 
      c=-1 
      Repeat             ;we replace the second loop with a 
        d=c               ;Binary Search to reduce the number 
        c=a+b             ;of compares required 
        If c>i 
          If b>1 
            b=Int(b/2)      ;overbounds, we cut our step in half    
          Else 
            b=0 
          EndIf 
        ElseIf temp<dummy(c) 
          If b>1 
            b=Int(b/2)      ;overreach, we cut our step in half 
          Else 
            b=0 
          EndIf 
        ElseIf temp>dummy(c) 
          a=c             ;we are edging up to the location 
        Else 
          a=c             ;we have a match 
          d=c             ;set the flag to show we are done 
        EndIf 
      Until c=d Or b=0   ;we are done or have no steps left 
      While temp<=dummy(a) 
        a+1 
      Wend 
      For j.l=i To a Step -1 
        dummy(j+1)=dummy(j)  ;open the spot for insertion 
      Next 
      dummy(a)=temp         ;put the entry in the right spot 
    EndIf 
  Next 
  dummy() = tmpAddress 
EndProcedure 

; Combsort - Modified Bubble sort 
; 
Procedure CombSort(*ptr, n.l) 
Define.l i, j, gap, top, temp, notSwitched, tmpAddress 
Define.f shrinkFactor 
  tmpAddress = @dummy() 
  dummy() = *ptr 
  
  shrinkFactor = 1.3 
  gap = n 
  Repeat 
    gap = Int(gap/shrinkFactor) 
    If gap < 1 
      gap = 1 
    EndIf 
    top = n - gap 
    notSwitched = #True 
    For i = 1 To top 
      j = i+gap 
      If dummy(i) > dummy(j) 
        temp = dummy(i) 
        dummy(i) = dummy(j) 
        dummy(j) = temp 
        notSwitched = #False 
      EndIf 
    Next 
  Until notSwitched And (gap = 1) 
  dummy() = tmpAddress 
EndProcedure 

; QuickSort - From PureBasic Advanced examples 
; 
Declare QuickSortRecursive(g.l, d.l) 

Procedure QuickSort(*ptr, n.l) 
  ; small dummy() wrapper. 
  tmpAddress.l = @dummy() 
  dummy() = *ptr 
  QuickSortRecursive(0, n) 
  dummy() = tmpAddress 
EndProcedure 

Procedure QuickSortRecursive(g.l, d.l) 
  If g < d 
    v = dummy(d) 
    i = g-1 
    j = d 
    Repeat 
      Repeat 
        i=i+1 
      Until dummy(i) >= v 
      ok = 0 
      Repeat 
        If j>0 
          j=j-1 
        Else 
          ok=1 
        EndIf 
        If dummy(j) <= v 
          ok=1 

        EndIf 
      Until ok<>0 
      tmp.l = dummy(i) 
      dummy(i) = dummy(j) 
      dummy(j) = tmp 
    Until j <= i 
    
    t = dummy(j) 
    dummy(j) = dummy(i) 
    dummy(i) = dummy(d) 
    dummy(d) = t 
    
    QuickSortRecursive(g, i-1) 
    QuickSortRecursive(i+1, d) 
  EndIf 
EndProcedure 

; Fill Array with random numbers 
For i = 0 To #NMAX 
  array(i) = Random($FFFF) 
Next 

; Need the exact conditions for both tests 
; so copy array. 
Mem = AllocateMemory(#NMAX*4+4)
If Mem = 0
  End 
EndIf 
CopyMemory(@array(0), Mem, #NMAX*4+4) 

; As the basic BubbleSort is quite slow you 
; might want to comment out that sort method 
; when increasing the #NMAX constant or the 
; sorting procedure will take forever :) 

; Time the BubbleSort algorithm 
BSStartTime.l = ElapsedMilliseconds() 
BubbleSort(Mem, #NMAX) 
BSEndTime.l = ElapsedMilliseconds() 

CopyMemory(@array(0), Mem, #NMAX*4+4) 

; Time the BubbleSort2 algorithm 
BS2StartTime.l = ElapsedMilliseconds() 
BubbleSort2(Mem, #NMAX) 
BS2EndTime.l = ElapsedMilliseconds() 

CopyMemory(@array(0), Mem, #NMAX*4+4) 

; Time the CombSort algorithm 
CSStartTime.l = ElapsedMilliseconds() 
CombSort(Mem, #NMAX) 
CSEndTime.l = ElapsedMilliseconds() 

CopyMemory(@array(0), Mem, #NMAX*4+4) 

; Time the QuickSort algorithm 
QSStartTime.l = ElapsedMilliseconds() 
QuickSort(Mem, #NMAX) 
QSEndTime.l = ElapsedMilliseconds() 

; Time the internal SortArray() command 
SAStartTime.l = ElapsedMilliseconds() 
SortArray(array(), 0) 
SAEndTime.l = ElapsedMilliseconds() 

message.s = "BubbleSort : "+Str(BSEndTime-BSStartTime)+"ms"+Chr(13)+Chr(10) 
message + "BubbleSort2 : "+Str(BS2EndTime-BS2StartTime)+"ms"+Chr(13)+Chr(10) 
message + "CombSort : "+Str(CSEndTime-CSStartTime)+"ms"+Chr(13)+Chr(10) 
message + "QuickSort : "+Str(QSEndTime-QSStartTime)+"ms"+Chr(13)+Chr(10) 
message + "SortArray : "+Str(SAEndTime-SAStartTime)+"ms"+Chr(13)+Chr(10) 
MessageRequester("Result", message, 0) 

FreeMemory(Mem) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
