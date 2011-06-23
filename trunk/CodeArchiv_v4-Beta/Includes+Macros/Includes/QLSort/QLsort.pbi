; ------------------------------------------------------------
; Linked List Quick Sort with variable comparison function
; Freeware by horst.schaeffer@gmx.net 
; ------------------------------------------------------------

; SortListR() is the (recursive) QuickSort procedure that can be 
; used with any linked list. 
;
; It requires a small startup procedure für your individual 
; linked list, and one or more comparison functions according 
; to your needs (see below).

Procedure SortListR(*a,*b,elements)
  Shared *cmp, temp.s, sz
  *first = *a 
  *last = *b

  *mid = *a 
  If elements > 3  ; go to mid element (for pivot) 
    For i = 1 To elements>>1 : *mid = PeekL(*mid-8) +8 : Next 
  EndIf 
  CopyMemory(*mid,@temp,sz)   ; pivot to temp 
  CopyMemory(*a,*mid,sz)      ; now there is a gap at *a 
  #a = 0 : #b = 1             ; initial: gap = #a 
  
  While *a <> *b 
    If gap = #b 
      If CallFunctionFast(*cmp,*a,@temp) = #False 
        CopyMemory(*a,*b,sz) : gap = #a  
      EndIf 
    Else ; gap = #a
      If CallFunctionFast(*cmp,*b,@temp) = #True
        CopyMemory(*b,*a,sz) : gap = #b 
      EndIf 
    EndIf 
    If gap = #b 
      countlo +1 : *a = PeekL(*a-8) +8  ; succeeding *a  
    Else ; gap = #a
      counthi +1 : *b = PeekL(*b-4) +8  ; preceding *b
    EndIf 
  Wend 
  CopyMemory(@temp,*a,sz)     ; fill gap with pivot  
 
  If countlo > 1 
    *a = PeekL(*a-4) +8 : SortListR(*first,*a,countlo) 
  EndIf 
  If counthi > 1 
    *b = PeekL(*b-8) +8 : SortListR(*b,*last,counthi) 
  EndIf 
EndProcedure 

; ------------------------------------------------------------
  CompilerIf 0  ; comments 
; ------------------------------------------------------------
; This is an example how you use the QuickSort. 
; Let's assume you have the following linked list: 

Structure your
 name.s
 other.l 
EndStructure 

NewList LinkedList.your() 

; Here is the startup procedure that you call for each sort 
; operation. Change the name as you wish.
;   Replace "LinkedList()" with the name of your linked list
;   Replace "your" (SizeOf statement) with the structure type.

Procedure SortMyList(*cmp_function)
  Shared *cmp, temp.s, sz   ; following variables 
  sz = SizeOf(your)         ; are shared with SortListR()
  temp.s = Space(sz)
  *cmp = *cmp_function
  
  n = CountList(LinkedList())
  If n > 1                  ; pointers (first, last element)
    FirstElement(LinkedList()) : *a = @LinkedList() 
    LastElement(LinkedList())  : *b = @LinkedList()
    SortListR(*a,*b,n) 
  EndIf 
EndProcedure 

; The SortMyList() command  requires only one parameter: 
; the comparison function (by pointer).

; This is a trivial one: 

Procedure ByNameAscending(*a.your,*b.your) 
  If *a\name <= *b\name : ProcedureReturn #True : EndIf 
EndProcedure 

; The parameters *a and *b supply two elements of the linked list
; (note that the type of your linked list must be specified).
; You can compare any fields of the element structure, and do
; any kind of conversions.
; However: do NOT modify the given elements (use locals variables)!

; *** The procedure must return #TRUE (non-zero)  ***
; *** if the two operands are in the right order. ***

; That means, to return #true
;   for ascending sort:  the first element must be <= the second. 
;   for descending sort: the first element must be >= the second. 
; Note that "equal" should always return #TRUE, because
; NOT #TRUE causes an exchange operation (which takes more time).

; You can write one or more procedures with any names.
; The procedure is passed to the sort process by pointer:
; e.g.:   SortList(@ByNameAscending())

CompilerEndIf ; ----------------------------------------------

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = C:\Programme\PureBasic\Projects\Test\sortX\QLsort.exe
; DisableDebugger