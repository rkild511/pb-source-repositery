; English forum: http://www.purebasic.fr/english/viewtopic.php?t=10999&highlight=
; Author: Froggerprogger
; Date: 28. May 2004
; OS: Windows
; Demo: Yes


; The following sort algorithm is VERY fast. 
; But it has 2 handicaps: 
; 1st: You have to keep the range of values small ~ < 1.000.000 
; 2nd: It does only work for integer values in this version 

;- 
;-  CountingIntSort 1.1 (PB - Windows) 
;-  
;- 
;-  PRO: 
;-  This algo is really fast (here > 6 times faster than SortArray()-Quicksort at 2.000.000 elements 
;-  in range -5.000 To 5.000), and it's speed increases just linear with arraysize, 
;-  so it's getting faster !! [speed is Theta(n) and not Theta(n*log2(n)) ] 
;-  Further it's speed is independant of the given order of the elements. 
;-  It works for Linked Lists, too. 
;-  
;-  CONTRA: 
;-  You'll probably need A LOT of memory: 
;-  memory usage: 4 Bytes * number_of_different_values_in_array 
;-  So don't use this algo for LONG-values in the whole range (you'll need to allocate 16GB memory) 
;-  So use it for values that lay in a maximum range of ~1.000.000, because the greater the range 
;-  the longer the memory-allocation lasts. 
;-  Further it doesn't work with floats or strings. 
;- 
;- 
;-  USAGE: 
;-  You can simply call one of the two 'interface'-procedures: 
;- 
;-  CountingIntSort(    pointerToData [e.g. Arrayname()], 
;-                      minValueInArray, 
;-                      maxValueInArray) 
;- 
;-  CountingIntSortLL(  pointerToListelement [e.g. FirstElement(MyList())], 
;-                      dataType [#Long - you may use #LL_Long also], 
;-                      minValueInArray, 
;-                      maxValueInArray) 
;- 
;-                      (Independant of pointerToListelement the whole list will be sorted) 
;- 
;- 
;-  ...or alternatively you might mention the required data explicitely: 
;- 
;-  CountingIntSortEx(  pointerToDataInMemory, [or to ListElement] 
;-                      maximumID [e.g. numberOfElements-1, or CountList(MyList())-1], 
;-                      dataType [#Long | #LL_Long - use #LL_Long for a Linked List] 
;-                      minValueInArray, 
;-                      maxValueInArray) 
;- 
;- 
;-  The values max/minValueInArray might be any integers 
;- 
;- 
;-  by Froggerprogger, 27.05.04 
;- 
;- 

;- declarations 
; constants 
#LL_Long = $FFFFFFFF ! #Long 

; structures 
Structure LL_ELEM 
  nextElem.l 
  prevElem.l 
  StructureUnion 
    l.l 
    f.f 
    s.s 
  EndStructureUnion 
EndStructure 

; declares 
Declare.l CountingIntSort(*p_array.l, p_minVal.l, p_maxVal.l) 
Declare.l CountingIntSortLL(*p_LL.LL_ELEM, p_arrType.l, p_minVal.l, p_maxVal.l) 
Declare.l CountingIntSortEx(*p_array.l, p_maxID.l, p_arrType.l, p_minVal.l, p_maxVal.l) 

;- procedures 
Procedure.l CountingIntSort(*p_array.l, p_minVal.l, p_maxVal.l) 
  ; call the main-routine with the correct parameters 
  If *p_array = 0 Or PeekL(*p_array - 4) <> 5 
    ProcedureReturn #False 
  Else 
    ProcedureReturn CountingIntSortEx(*p_array, PeekL(*p_array - 8) - 1, #Long, p_minVal, p_maxVal) 
  EndIf 
EndProcedure 

Procedure.l CountingIntSortLL(*p_LL.LL_ELEM, p_arrType.l, p_minVal.l, p_maxVal.l) 
  Protected maxID.l 
  Protected *LLelem.LL_ELEM ; [esp+20] 
  
  If *p_LL = 0 Or *p_LL = 8 
    ProcedureReturn #False 
  EndIf 
  
  ; search the first element 
  While *p_LL\prevElem <> 0 
    *p_LL = *p_LL\prevElem 
  Wend 
    
  ; copy the pointer to the first element 
  *LLelem = *p_LL 
  
  ; count the elements - as fast as CountList() 
  While *LLelem\nextElem <> 0 
    *LLelem = *LLelem\nextElem 
    maxID + 1 
  Wend 

  ; call the main-routine with the correct parameters 
  If (p_arrType <> #Long And p_arrType <> #LL_Long) Or maxID = 0 
    ProcedureReturn #False 
  Else 
    ProcedureReturn CountingIntSortEx(*p_LL, maxID, #LL_Long, p_minVal, p_maxVal) 
  EndIf 
EndProcedure 

Procedure.l CountingIntSortEx(*p_array.l, p_maxID.l, p_arrType.l, p_minVal.l, p_maxVal.l) 
  
  ; used generally 
  Protected *mem.l 
  Protected i.l, j.l 
  Protected *offset.l  
  Protected range.l 
  
  ; used by stream out 
  Protected hits.l 
  Protected actVal.l 
  
  ; used by Linked Lists 
  Protected *LLelem.LL_ELEM 

  ; check for valid parameters 
  If *p_array = 0 Or (p_arrType <> #Long And p_arrType <> #LL_Long) 
    ProcedureReturn #False 
  EndIf 
  
  ; if it is a list then search for the first element 
  If p_arrType = #LL_Long 
    If *p_array = 8 
      ProcedureReturn #False 
    EndIf 
    *LLelem = *p_array 
    ; search the first element 
    While *LLelem\prevElem <> 0 
      *LLelem = *LLelem\prevElem 
    Wend 
    *p_array = *LLelem 
  EndIf 
  
  ; Exchange p_minVal <--> p_maxVal if necessary 
  If p_minVal > p_maxVal 
     actVal = p_minVal 
     p_minVal = p_maxVal 
     p_maxVal = actVal 
  EndIf 

  ; calculate the range 
  range = p_maxVal - p_minVal + 1 

  ; allocate Memory for sorting and quit if not successful 
  *mem = AllocateMemory(4 * (range + 1)) 
  If *mem = 0 
    ProcedureReturn #False 
  EndIf 


  ;- do the main sorting for type LONG 
  If p_arrType = #Long 
  
    ; Jump in and count the number of hits 
    For i=0 To p_maxID 
      actVal = PeekL(*p_array + 4*i) 
      If actVal < p_minVal Or actVal > p_maxVal 
        FreeMemory(*mem) 
        ProcedureReturn #False 
      EndIf 
      *offset = *mem + (actVal - p_minVal) * 4 
      PokeL(*offset, PeekL(*offset) + 1) 
      hits + 1 
    Next 
    
    ; Stream out the values of the hits in sorted order 
    *offset = 0 
    For i=0 To 4 * range Step 4 
      hits = PeekL(*mem + i) 
      If hits > 0 
        actVal = p_minVal + i / 4 
        For j = 1 To hits 
          PokeL(*p_array + *offset, actVal) 
          *offset + 4 
        Next  
      EndIf 
    Next 
    
    
  ;- do the main sorting for type LL_LONG 
  ElseIf p_arrType = #LL_Long 
    ; set *LLelem to our first element 
    *LLelem = *p_array 
    
    ; Jump in and count the number of hits 
    For i=0 To p_maxID 
      actVal = *LLelem\l 
      If actVal < p_minVal Or actVal > p_maxVal 
        FreeMemory(*mem) 
        ProcedureReturn #False 
      EndIf 
      *offset = *mem + (actVal - p_minVal) * 4 
      PokeL(*offset, PeekL(*offset) + 1) 
      *LLelem = *LLelem\nextElem 
    Next 

    ; set *LLelem back to our first element 
    *LLelem = *p_array 
    
    ; Stream out the values of the hits in sorted order 
    For i=0 To 4 * range Step 4 
      hits = PeekL(*mem + i) 
      If hits > 0 
        actVal = p_minVal + i / 4 
        For j = 1 To hits 
          *LLelem\l = actVal 
          *LLelem = *LLelem\nextElem 
        Next  
      EndIf 
    Next 
  EndIf 
  
  FreeMemory(*mem) 
  
  ProcedureReturn #True 
EndProcedure 









;- 
;- example / speed comparison 
;- 
#maxID = 2000000 ; (2.000.000) 
Dim A.l(#maxID) 
Dim B.l(#maxID) 
NewList LL.l() 

lower = -5000 
upper = 5000 

; create 3 times the same data 
For i=0 To #maxID 
  A(i) = Random(upper - lower) + lower 
  B(i) = A(i) 
  AddElement(LL()) 
  LL() = A(i) 
Next 

MessageRequester("","Ready to start comparison...",0) 

start = ElapsedMilliseconds() 
  CountingIntSort(A(), lower, upper) 
stop1 = ElapsedMilliseconds() - start 

start = ElapsedMilliseconds() 
  CountingIntSortLL(FirstElement(LL()), #Long, lower, upper) 
stop2 = ElapsedMilliseconds() - start 

start = ElapsedMilliseconds() 
  SortArray(B(), 0) 
stop3 = ElapsedMilliseconds() - start 

; Check if the result is in correct order 
last = $80000000 
For i=0 To #maxID 
  If A(i) < last 
    MessageRequester("","Error in CountingIntSort() : " + Str(A(i)) + " < " + Str(last),0) 
    Break 
  EndIf 
  last = A(i) 
Next 
last = $80000000 
ForEach LL() 
  If LL() < last 
    MessageRequester("","Error in CountingIntSortLL() : " + Str(LL()) + " < " + Str(last) ,0) 
    Break 
  EndIf 
  last = LL() 
Next 
last = $80000000 
For i=0 To #maxID 
  If B(i) < last 
    MessageRequester("","Error in SortArray() : " + Str(B(i)) + " < " + Str(last),0) 
    Break 
  EndIf 
  last = B(i) 
Next 

MessageRequester("","CountingIntSort: " + Str(stop1) + " ms" + Chr(13)+Chr(10)+ "CountingIntSortLL: " + Str(stop2)+" ms"+Chr(13)+Chr(10)+"PB-Sort: " + Str(stop3) + " ms") 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger