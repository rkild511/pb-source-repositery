; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7986&highlight=
; Author: einander (updated for PB 4.00 by Andre)
; Date: 21. October 2003
; OS: Windows
; Demo: Yes

; Special For GFA nostalgics: 2 small procedures To Insert And Delete array items. 

;By Einander - October 21 - 2003 - PB 3.80 
;Procedure DeleteL(@Array(),ELEM,DM) deletes the item indexed by ELEM from Array.L(). 
; All array items whose indices are >= ELEM are shifted one position up. 
; The value of the last element in the array is converted to 0. 

Procedure DeleteL(DIR.L,ELEM.L,DM.L)  
    CopyMemory(DIR+(elem+1)*4,DIR+elem*4,(DM-elem)*4) 
    PokeL(DIR+DM*4,0) 
EndProcedure 

; Procedure Insert(VA,@Array,ELEM,DM) inserts VA in Array.L() at position ELEM. 
; All items in Array.L  whose indices are >= ELEM are moved one position down. 
; The last element in ARRAY.L() is deleted with each Insert. 
; Would be nice to icrease the size of the array to fit the last element. 

Procedure InsertL(VA.L,DIR.L,ELEM.L,DM.L)  
    CopyMemory(DIR+elem*4,DIR+(elem+1)*4,(DM-elem)*4) 
    PokeL(DIR+ELEM*4,VA) 
EndProcedure 

::::::::::::::::::::::::::::::::::::::::: 

DM=10 
ELEM=5    ;Element to delete 

Dim A.L(DM) 
For I=0 To DM : A(I)=I  : Next 
Gosub TEST 
Debug " " 
Debug "Deleted "+Str(ELEM) 
DeleteL(@A(),ELEM,DM)  ;deletes item 5 

Gosub TEST 
InsertL(555,@A(),5,DM)  ; inserts 555 at posic 5 
Debug " " 
Debug "Inserted 555" 
Gosub TEST 
MessageRequester("DONE","",0) 
End 

::::::::::::::::::::::::::::::::::: 

TEST: 
For I=0 To DM 
    Debug Str(I)+"  "+Str(A(I)) 
Next I 
Return 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
