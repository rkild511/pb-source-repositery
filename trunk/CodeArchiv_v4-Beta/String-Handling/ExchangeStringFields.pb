; German forum: http://www.purebasic.fr/german/viewtopic.php?t=957&highlight=
; Author: MLK (idea by DarkDragon)
; Date: 21. November 2004
; OS: Windows
; Demo: Yes

;
Procedure$ ExchangeStringFields(String.s, Index1, Index2, Separator.s) 
    ; Index1 and Index2 mark the two fields to exchange
    
    If StringField(String,Index1,Separator)="" Or StringField(String,Index2,Separator)="" Or Index1<1 Or Index2<1 
        ProcedureReturn "" 
    EndIf 
    
    For i=1 To CountString(String,Separator)+1 
        If i=Index1 
            Ergebnis.s+StringField(String,Index2,Separator)+Separator 
        ElseIf i=Index2 
            Ergebnis.s+StringField(String,Index1,Separator)+Separator 
        ElseIf StringField(String,i,Separator) 
            Ergebnis.s+StringField(String,i,Separator)+Separator 
        EndIf 
    Next 
    If Right(String,1)<>Separator 
        ProcedureReturn Left(Ergebnis,Len(Ergebnis)-1) 
    Else 
        ProcedureReturn Ergebnis 
    EndIf 
EndProcedure 

Debug ExchangeStringFields("Test1|Test12|Test123", 1, 2, "|") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -