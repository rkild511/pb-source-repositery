; German forum: 
; Author: Froggerprogger (updated for PB 4.00 by Andre)
; Date: 20. November 2004
; OS: Windows, Linux
; Demo: Yes

; Permutation Caller
; ==================
; Folgender Code erzeugt sämtliche Permutationen mit den Zahlen 1 bis 
; p_numElems und ruft für jede Permutation die übergebene Funktion 
; *p_callbackProc auf, welche mit den permutierten Zahlen dann alles 
; mögliche anstellen kann. (siehe z.B. example 2 für Stringkonkatenation) 
; 
; Dabei können beliebig viele Elemente permutiert werden, selbst wenn die 
; Anzahl ihrer Permutationen die 2^31-Grenze überschreitet. 
; 
; [Anm: Permutation = Aneinanderreihung von Elementen der Ausgangsmenge 
; (hier der Zahlen 1..p_numElems), wobei jedes genau einmal und an einer 
; beliebigen Position auftaucht] 

;/ PermutationCaller(p_numElems.l, *p_callbackProc.l) 
;/ >> generates all permutations of numbers 1..p_numElems and calls *p_callbackProc on 
;/ >> each permutation to use it for any purpose 
;/ 
;/ p_numElems:       the number of elements to permutate (1..) 
;/ *p_callbackProc:    pointer to function to call each time a new permutation 
;/                   was generated. This function has to be of the form: 
;/                   ProcName (*p_array.l, p_numElems.l, p_counter.l) 
;/                   where [*p_array] will hold a pointer to an array 
;/                   of [p_numElems] permutated long-values each in 
;/                   range 1..[p_numElems] 
;/                   p_counter just counts from 1.. 
;/                   This callbackfunction has to return 0 (or nothing) to let 
;/                   PermutationCaller() continue, 
;/                   or may return anything <> 0 to let PermutationCaller() 
;/                   stop immediately. 
;/ 
;/ by Froggerprogger, 20.11.2004 
Procedure.l PermutationCaller(p_numElems.l, *p_callbackProc.l) 
  Dim Permutation.l (p_numElems - 1) ; holds the actual permutation 
  Dim TempFreedValues.l (p_numElems - 1) ; entry 0=used, 1=(temporarily) not used value 
    
  Protected resume.l : resume = 1 
  Protected runPos.l : runPos = p_numElems - 2 
  Protected tempL.l 
  Protected lastVal.l 
  Protected counter.l 
  
  ; nothing to permutate with p_numElems <= 1 
  If p_numElems <= 1 
    ProcedureReturn 0 
  EndIf 
  
  ; fill in the first permutation 
  For i=0 To p_numElems - 1 
    Permutation(i) = i+1 
  Next 

  Repeat 
    counter + 1 
    ; call the custom function 
    tempL = CallFunctionFast(*p_callbackProc, @Permutation(), p_numElems, counter) 
    If tempL <> 0  
      ProcedureReturn tempL 
    EndIf 
    
    ; free all entries from runPos to end 
    descending = 1 
    lastVal = Permutation(runPos) 
    TempFreedValues(lastVal - 1) = 1 
    For i = runPos + 1 To p_numElems - 1 
      tempL = Permutation(i) 
      TempFreedValues(tempL - 1) = 1 
      If descending And tempL > lastVal 
        descending = 0 
      ElseIf descending 
        lastVal = tempL 
      EndIf 
    Next 

    While descending 
      ; if at runPos the local maximum is, then free it and go one more left to increase it 
      runPos - 1 
      ; quit if this was the most left position 
      If runPos < 0 : ProcedureReturn counter : EndIf 
      tempL = Permutation(runPos) 
      TempFreedValues(tempL-1) = 1 
      lastVal = Permutation(runPos+1) 
      If tempL < lastVal 
        descending = 0 
      EndIf 
    Wend 

    ; write nearest greater value to runPos 
    i = Permutation(runPos) 
    Repeat 
      i+1 
    Until TempFreedValues(i-1) = 1 
    TempFreedValues(i-1) = 0 
    Permutation(runPos) = i 
    
    ; write back the other freed values in descending order 
    j = runPos + 1 
    For i=0 To p_numElems - 1 
      If TempFreedValues(i) = 1 
        TempFreedValues(i) = 0 
        Permutation(j) = i+1 
        j+1 
      EndIf 
    Next 
    runPos = p_numElems - 2 
  ForEver 
EndProcedure 

;- 
;- 2 Examples 
;- 
;/ example 1 - simple number permutation 
#max1 = 4 
Debug "example 1: simple number permutation" 
Procedure SimpleDebugArray(*p_array.l, p_numElems.l, p_counter.l) 
  ;( >>sniff<< there are no arrays as parameters in PB) 
  Protected res.s 
  res = "" 
  For i=0 To p_numElems-1 
    res + Str(PeekL(*p_array + 4*i)) + "  |  " 
  Next 
  Debug res 
  ProcedureReturn 0 
EndProcedure 

Debug Str(PermutationCaller(#max1, @SimpleDebugArray())) + " permutations" 
Debug "" : Debug "" 

;/ example 2 - using permutationcaller for another purepose (strings' combination here) 
#max2 = 5 
Global Dim MyStringArray.s(#max2 - 1) 

Debug "example 2: using permutationcaller() for strings' combination" 
Procedure DebugStrings(*p_array.l, p_numElems.l, p_counter.l) 
  ;( >>sniff<< there are no arrays as parameters in PB) 
  Protected res.s 
  res = "" 
  For i=0 To p_numElems-1 
    res + MyStringArray(PeekL(*p_array + 4*i)-1) + " " 
  Next 
  Debug res 
  ProcedureReturn 0 
EndProcedure 

; fill some strings into an array 

For i=0 To #max2-1 
  MyStringArray(i) = Chr(65 + i) + Str(i) + Chr(97 + i) 
Next 

Debug Str(PermutationCaller(#max2, @DebugStrings())) + " permutations" 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -