; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2116&highlight=
; Author: ShadowTurtle (updated for PB 4.00 by Andre)
; Date: 18. February 2005
; OS: Windows
; Demo: Yes


; Tree Linkedlists without child and parents (fully based on pointers)
; Tree Linkedlists ohne Childs und Parents

; Einleitung                        Lib. by ShadowTurtle 
; ----------                        Fr., 18. Februar 2005 
; 
; Die Library basiert vollkommen auf Pointer. Entgegen 
; gesetzt der eingebauten Purebasic Linkedlist Funktionen. 

; Da eine Liste in dieser Library als Pointer zurück 
; gegeben (und auch so behandelt) wird, kann man eine 
; Liste auch als Element hinzufügen. 

; Ein Kleines Beispiel: Du machst zunächst Zwei Listen 
; wie hier: 
; *Liste1.TM_List = TM_CreateList() 
; *Liste2.TM_List = TM_CreateList() 

; Nun kannst du den Pointer von Liste2 als Element zu 
; Liste1 angeben. Wie hier: 
; TM_AddElement(*Liste1, *Liste2) 

; Wenn du später die Liste in der Liste durchgehen 
; willst, dann musst du einfach eine zusätzliche 
; Schleife machen. Wie du alle Elemente durchscanst 
; wird hier im Code nun gezeigt. Der rest bleibt 
; dein logisches Denken überlassen. 

; Wichtiger Hinweis!!! 
; -------------------- 
; Diese Library sieht auf den ersten Blick etwas mager 
; aus. Aber wenn man mit Pointer umzugehen weis, der 
; wird wissen wie unnötig Childs und Parents wirklich 
; sind - woraus z.B. NicTheQuick's Library aufbaut. 


Structure TM_Element 
  *Element_Next.TM_Element 
  *Element_Prev.TM_Element 
  *Pointer 
EndStructure 

Structure TM_List 
  *Element_Last.TM_Element 
  *Element_First.TM_Element 
  *Element_Actual.TM_Element 
  
  ScanInverse.l 
  ScanPos.l 
  Elements.l 
EndStructure 

Procedure TM_CreateList() 
  *List.TM_List = AllocateMemory(SizeOf(TM_List)) 
  *List\Elements = 0 

  ProcedureReturn *List 
EndProcedure 

Procedure TM_AddElement(*List.TM_List, *Pointer) 
  *Element.TM_Element = AllocateMemory(SizeOf(TM_Element)) 
  *Element\Pointer = *Pointer 

  If *List\Elements = 0 
    *List\Element_First = *Element 
  Else 
    *List\Element_Last\Element_Prev = *Element 
  EndIf 

  *Element\Element_Next = *List\Element_Last 
  *List\Element_Last = *Element 

  *List\Elements = *List\Elements + 1 
EndProcedure 

Procedure TM_ScanInverse(*List.TM_List, Mode.b) 
  *List\ScanInverse = Mode 
EndProcedure 

Procedure TM_ScanNew(*List.TM_List) 
  *List\ScanPos = 0 
EndProcedure 

Procedure.b TM_ScanNextElement(*List.TM_List) 
  *List\ScanPos = *List\ScanPos + 1 

  If *List\ScanInverse = #True 
    If *List\ScanPos = 1 
      *List\Element_Actual = *List\Element_First 
    Else 
      *List\Element_Actual = *List\Element_Actual\Element_Prev 
    EndIf 
  Else 
    If *List\ScanPos = 1 
      *List\Element_Actual = *List\Element_Last 
    Else 
      *List\Element_Actual = *List\Element_Actual\Element_Next 
    EndIf 
  EndIf 

  If *List\ScanPos-1 = *List\Elements 
    ProcedureReturn 0 
  Else 
    ProcedureReturn 1 
  EndIf 
EndProcedure 

Procedure TM_ElementPointer(*List.TM_List) 
  ProcedureReturn *List\Element_Actual\Pointer 
EndProcedure 

Procedure TM_EditElement(*List.TM_List, Pos.l) 
  ScanPos.l = 0 
  
  TM_ScanNew(*List) 
  While ScanPos > -1 
    ScanPos = ScanPos + 1 
    If ScanPos = Pos + 1 
      ScanPos = -1 
    Else 
      If TM_ScanNextElement(*List) = 0 
        ScanPos = -1 
      EndIf 
    EndIf 
  Wend 
EndProcedure 

Procedure TM_DeleteElement(*List.TM_List) 
  *Element_Delete.TM_Element = *List\Element_Actual 
  
  If *Element_Delete = *List\Element_First 
    *List\Element_First = *List\Element_Actual\Element_Prev 
    *List\Element_Actual = *List\Element_First 
  ElseIf *Element_Delete = *List\Element_Last 
    *List\Element_Last = *List\Element_Actual\Element_Next 
    *List\Element_Actual = *List\Element_Last 
  Else 
    *List\Element_Actual\Element_Next\Element_Prev = *List\Element_Actual\Element_Prev 
    *List\Element_Actual\Element_Prev\Element_Next = *List\Element_Actual\Element_Next 
    *List\Element_Actual = *List\Element_Actual\Element_Prev 
  EndIf 

  FreeMemory(*Element_Delete) 

  If *List\Elements > 0 
    *List\Elements = *List\Elements - 1 
  EndIf 
EndProcedure 

Procedure TM_DeleteList(*List.TM_List) 
  While *List\Elements > 0 
    TM_EditElement(*List, 1) 
    TM_DeleteElement(*List) 
  Wend 

  FreeMemory(*List) 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --