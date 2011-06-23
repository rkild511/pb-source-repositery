; http://www.purebasic-lounge.de 
; Author: hellhound66
; Date: 25. September 2006
; OS: Windows
; Demo: Yes


;############ 
;# PB 4.0 
;############ 
;# Mit Hilfe der Macros kann man unter PB so eine Art primitives Template 
;# erzeugen, mit dem man sehr effektiv Prozeduren an verschiedene Datentypen 
;# anpassen kann. 
;############ 
;# Coded by 
;# Hellhound66 
;############ 
;# 25.09.06 
;############ 

Macro template_recursive_QSortList(__TYPE,__SHORTCUT) 
    Procedure QSortList#__TYPE#(*LIST,min.l,max.l) 
    dummy.__SHORTCUT# 
    l = min 
    r = max 
    *ListPTR.__TYPE# = *LIST + ((l+r)/2)*SizeOf(dummy) 
    ref.__SHORTCUT# = *ListPTR\__SHORTCUT# 
    While(l<=r) 
        *ListPTR = *LIST+l*SizeOf(dummy) 
        While(*ListPTR\__SHORTCUT#<ref)And(l<max) 
            l+1 
            *ListPTR = *LIST+l*SizeOf(dummy) 
        Wend 
        
        *ListPTR = *LIST+r*SizeOf(dummy) 
        While(*ListPTR\__SHORTCUT#>ref)And(r>min) 
            r-1 
            *ListPTR = *LIST+r*SizeOf(dummy) 
        Wend 
        
        If(l<=r) 
            *ListPTR = *LIST+l*SizeOf(dummy) 
            dummy = *ListPTR\__SHORTCUT# 
            *ListPTR\__SHORTCUT# = peek#__SHORTCUT#(*LIST+r*SizeOf(dummy)) 
            Poke#__SHORTCUT#(*LIST+r*SizeOf(dummy),dummy) 
            r-1 
            l+1 
        EndIf 
    Wend 
    
    If(min<r) 
        QSortList#__TYPE#(*LIST,min,r) 
    EndIf 
    If(l<max) 
        QSortList#__TYPE#(*LIST,l,max) 
    EndIf 
EndProcedure 
EndMacro 

;########################################## 
;# Beispielhaft mal zwei Sortieralghorithmen verschiedener Datentypen erstellt. 
template_recursive_QSortList(Byte,b)    
template_recursive_QSortList(Double,d) 

;########################################## 
;# Beispielanwendung 
Dim List.d(100) 

For i = 0 To 100 
    List(i) =Random(3000)*Sin(i) 
Next 

QSortListDouble(List(),0,100) 

For i = 0 To 100 
    Debug List(i) 
Next 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP