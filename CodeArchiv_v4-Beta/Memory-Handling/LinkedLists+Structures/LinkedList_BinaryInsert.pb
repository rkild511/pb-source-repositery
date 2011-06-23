; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8906&highlight=
; Author: einander (updated for PB 4.00 by Andre)
; Date: 28. December 2003
; OS: Windows
; Demo: Yes


;Binary insertion of new elements in sorted List. Non recursive. 
; by Einander - december 27-2003 - Pb 3.81 
;Instead of sorting the list, each element is added on place by binary search 
;Allow or avoid repeated values. 
;Improvements welcomed! 

Global Min,AllowRepeated 
AllowRepeated=1     ; <============ zero to avoid repeated values, nonzero to allow 
Global NewList Sorted.l() 

Procedure BinSearch(A, Z, key)    
    While (A <= Z) 
        Median = (A + Z) / 2 
        SelectElement(Sorted(), Median) 
        If key > Sorted() 
            R = 0 : A = Median + 1 
        ElseIf key < Sorted() 
            R = -1 : Z = Median - 1 ; 
        Else 
            ProcedureReturn Median 
        EndIf 
    Wend 
    ProcedureReturn - (Median + R)  ; return negative = non existent element 
EndProcedure 

Procedure ShowList() 
    ResetList(Sorted()) 
    While NextElement(Sorted()) 
        Debug Str(n) + "  " + Str(Sorted()) 
        n + 1 
    Wend 
EndProcedure 

Procedure NewElement(Insert)     ;            add new element in sorted list 
    Size=CountList(Sorted())          
    If Size 
        SelectElement(Sorted(), Size)                                                    
        If Sorted() < Insert                                                                      
            Swp = Sorted() ;                                         value of last element                                    
            InsertElement(Sorted()) : Sorted() = Swp ;        assign value to the new element 
            SelectElement(Sorted(), CountList(Sorted())) ; select last 
            Sorted() = Insert ;                                      insert new value in last element 
         ElseIf Insert <= Min ;                         new value to add on the list 
            SelectElement(Sorted(), 0) 
            If Sorted() <> Insert ;                               if new value is not on the list 
                InsertElement(Sorted()) :Sorted() = Insert 
                Min = Insert  ;                               new minimum 
            EndIf 
        Else  
            X = BinSearch(0, Size, Insert) 
             If X <= 0 Or AllowRepeated;                             0 or negative values =  new value on the list 
                SelectElement(Sorted(), Abs(X) + 1) 
                InsertElement (Sorted()) : Sorted() = Insert 
            EndIf 
        EndIf 
    Else   ;                                               only for the first element 
        AddElement(Sorted()) : Sorted() = insert     ; new element is the minimumm (and only) 
        Min=Insert 
    EndIf 
EndProcedure 
;____________________________________________ 
;;;;;;TEST  - add random elements 
OpenWindow(0, x,y,500,60, "Binary insert in sorted list", #WS_OVERLAPPEDWINDOW | #PB_Window_WindowCentered) 
StartDrawing(WindowOutput(0)) 

Elements=1200 :Value= 100    ; allow from 0 to Value 
DrawText(10,10,"Comparing, sorting and adding "+Str(Elements)+" elements - Values 0 to "+Str(Value)) 
For i=0 To Elements 
    NewElement(Random(Value))  ;        choose any value for random 
    If i % 2000=0 
        DrawText(10,30,Str(i)) 
    EndIf 
Next 

ShowList() 
  Repeat 
       Event = WaitWindowEvent() 
  Until Event= #PB_Event_CloseWindow  
End  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
