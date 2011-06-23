; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2502&highlight=
; Author: NicTheQuick
; Date: 09. October 2003
; OS: Windows
; Demo: No

; Functions for creating linked lists with tree structure...

; Oft wurde es schon verlangt. Eine LinkedList mit Baumstruktur. Nun ist sie endlich da.
; Im Anschluss folgt der Code f�r die TreeLL. Dann die Dokumentation und schlie�lich ein
; kleines Beispiel, weil die Doku allein nicht ausreicht. Die TreeLL-Funktion funktioniert
; nur mit der Vollversion von PureBasic V3.80 und unter Windows! 

; Feedback auf evtl. Fehler ist erw�nscht. 

; Was ich noch nachtr�glich hinzuf�gen wollte: Falls jemand diesen Code in seinem Projekt
; benutzt, w�rde ich das gerne wissen und auch in die Credits geschrieben werden.  

; Da dieser Code daf�r geeignet ist, eine eigene Datenbank aufzubauen, hab ich auch noch
; vor eine universelle Funktion zum Speichern und Einlesen der Daten zu bauen. Sowohl f�r
; Longsm Words, Bytes, Floats und auch Strings. 

;- TreeLL-Procedure
Procedure TreeLL(Modus.l, *TreeLL_In) 
  Enumeration 1 
    #NewTreeLL    ;Erstellt eine neue TreeLinkedList mit der Structuregr��e *TreeLL_in und gibt ihr Handle zur�ck 
    #NewChild     ;Erstellt unter dem aktuellen Element eine neue Childliste oder springt zum aktuellen Child des aktuellen Elementes 
    
    #Add          ;Erstellt ein neues Element nach dem aktuellen oder in der neuen Childliste 
    #Insert       ;Erstellt ein neues Element vor dem aktuellen 
    #Delete_      ;L�scht das aktuelle Element und seine Childs, falls vorhanden 
    #AllDelete    ;L�scht alle Elemente 
    
    #Reset        ;Resetet die aktuelle Liste, nicht die ganze 
    #ResetAll     ;Resetet jede einzelne Liste 
    #First        ;Springt zum ersten Element in der aktuellen Liste 
    #Last         ;Springt zum letzten Element in der aktuellen Liste 
    
    #Prev         ;Springt zu dem Element vor dem aktuellen 
    #Next         ;Springt zu dem Element nach dem aktuellen oder zum ersten, wenn die Liste resetet wurde 
    #NextEx       ;Springt zum n�chsten Element oder 
    #Child        ;Springt zum aktuellen Child des aktuellen Elementes oder vor die Childliste 
    #Parent       ;Springt zum Parent des aktuellen Elementes 
    
    #GetPointer   ;Gibt den Pointer zum aktuellen Element zur�ck 
    
    #IsPrev       ;Gibt 0 zur�ck, wenn kein Element vor dem aktuellen existiert, sonst Pointer zum vorherigen Element 
    #IsNext       ;Gibt 0 zur�ck, wenn kein Element nach dem aktuellen existiert, sonst Pointer zum folgenden Element 
    #IsChild      ;Gibt 0 zur�ck, wenn das aktuelle Element kein Child hat, sonst Pointer zum Child 
    #IsParent     ;Gibt 0 zur�ck, wenn das aktuelle Element kein Parent hat, sonst Pointer zum Parent 
    
    #CountChilds  ;Z�hlt die Childs des aktuellen Elements 
    #CountList    ;Z�hlt die Elemente der aktuellen Liste 
    #CountElements;Z�hlt die Elemente der gesamten Liste 
    #CountColumn  ;Z�hlt die Rekursion eines Childs 
  EndEnumeration 
  Structure TreeLinkedListElement 
    *pNext.TreeLinkedListElement 
    *pPrev.TreeLinkedListElement 
    *pParent.TreeLinkedListElement 
    *pChild.TreeLinkedListElement 
    *pChildLast.TreeLinkedListElement 
    *pAktChild.TreeLinkedListElement 
  EndStructure 
  Structure TreeLinkedList 
    *pAktElement.TreeLinkedListElement 
    *pFirstElement.TreeLinkedListElement 
    *pLastElement.TreeLinkedListElement 
    ElementSize.l 
  EndStructure 
  
  ;{ Init 
  #HEAP_ZERO_MEMORY = $8 
  Protected *New.TreeLinkedListElement, *TreeLL.TreeLinkedList 
  Protected TreeLLSize.l, Count.l, OK.l, AktElementSize.l, Heap.l 
  
  !MOV Eax, dword [_PB_MemoryBase] 
  MOV Heap, Eax 
  
  If Modus = #NewTreeLL       ;Reserviert Speicher f�r eine neue TreeLL und gibt das Handle zur�ck 
    *TreeLL = HeapAlloc_(Heap, #HEAP_ZERO_MEMORY, SizeOf(TreeLinkedList)) 
    *TreeLL\ElementSize = *TreeLL_In 
    ProcedureReturn *TreeLL 
  EndIf 
  
  *TreeLL = *TreeLL_In 
  If *TreeLL\ElementSize = 0  ;�berpr�ft das Handle auf G�ltigkeit 
    ProcedureReturn 0 
  EndIf 
  
  TreeLLSize = SizeOf(TreeLinkedListElement) 
  AktElementSize = TreeLLSize + *TreeLL\ElementSize 
  ;} 
  
  ;{ Select 
  Select Modus 
    Case #Add           ;{ F�ge ein neues Element hinter dem Aktuellen ein 
      *New = HeapAlloc_(Heap, #HEAP_ZERO_MEMORY, AktElementSize) 
      
      If *TreeLL\pAktElement And *TreeLL\pAktElement\pAktChild <> -1    ;Wenn Element aktiv ist 
        If *TreeLL\pAktElement\pChild = -1        ;Wenn ein Child erstellt werden soll 
          *TreeLL\pAktElement\pChild = *New 
          *TreeLL\pAktElement\pChildLast 
          *New\pParent = *TreeLL\pAktElement 
        Else 
          *New\pNext = *TreeLL\pAktElement\pNext 
          *New\pPrev = *TreeLL\pAktElement 
          *TreeLL\pAktElement\pNext = *New 
          If *New\pNext 
            *New\pNext\pPrev = *New 
          EndIf 
          *New\pParent = *TreeLL\pAktElement\pParent 
          If *New\pPrev = 0           ;Wenn 1. Pos hat 
            If *New\pParent 
              *New\pParent\pChild = *New 
            Else 
              *TreeLL\pFirstElement = *New 
            EndIf 
          EndIf 
          If *New\pNext = 0           ;Wenn letzte Pos hat 
            If *New\pParent 
              *New\pParent\pChildLast = *New 
            Else 
              *TreeLL\pLastElement = *New 
            EndIf 
          EndIf 
        EndIf 
      ElseIf *TreeLL\pFirstElement       ;Wenn resettet wurde 
        *New\pNext = *TreeLL\pFirstElement 
        *TreeLL\pFirstElement\pPrev = *New 
        *TreeLL\pFirstElement = *New 
      Else                      ;Wenn noch kein Element vorhanden war 
        *TreeLL\pFirstElement = *New 
        *TreeLL\pLastElement = *New 
      EndIf 
      *TreeLL\pAktElement = *New 
      ProcedureReturn *New + TreeLLSize;} 
    
    Case #Insert        ;{ F�ge ein neues Element ein 
      *New = HeapAlloc_(Heap, #HEAP_ZERO_MEMORY, AktElementSize) 
      If *TreeLL\pAktElement And *TreeLL\pAktElement\pAktChild <> -1    ;Wenn Element aktiv ist 
        If *TreeLL\pAktElement\pChild = -1        ;Wenn ein Child erstellt werden soll 
          *TreeLL\pAktElement\pChild = *New 
          *TreeLL\pAktElement\pChildLast 
          *New\pParent = *TreeLL\pAktElement 
        Else 
          *New\pNext = *TreeLL\pAktElement 
          *New\pPrev = *TreeLL\pAktElement\pPrev 
          *TreeLL\pAktElement\pPrev = *New 
          If *New\pPrev 
            *New\pPrev\pNext = *New 
          EndIf 
          *New\pParent = *TreeLL\pAktElement\pParent 
          If *New\pPrev = 0           ;Wenn 1. Pos hat 
            If *New\pParent 
              *New\pParent\pChild = *New 
            Else 
              *TreeLL\pFirstElement = *New 
            EndIf 
          EndIf 
          If *New\pNext = 0           ;Wenn letzte Pos hat 
            If *New\pParent 
              *New\pParent\pChildLast = *New 
            Else 
              *TreeLL\pLastElement = *New 
            EndIf 
          EndIf 
        EndIf 
      ElseIf *TreeLL\pFirstElement   ;Wenn resettet wurde 
        *New\pNext = *TreeLL\pFirstElement 
        *TreeLL\pFirstElement\pPrev = *New 
        *TreeLL\pFirstElement = *New 
      Else                      ;Wenn noch kein Element vorhanden war 
        *TreeLL\pFirstElement = *New 
        *TreeLL\pLastElement = *New 
      EndIf 
      *TreeLL\pAktElement = *New 
      ProcedureReturn *New + TreeLLSize;} 
    
    Case #NewChild      ;{ Erstelle das Grundger�st f�r ein neues Child oder springe zum Child 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pChild = 0 
          *TreeLL\pAktElement\pChild = -1 
          ProcedureReturn -1 
        ElseIf *TreeLL\pAktElement\pChild <> -1 
          If *TreeLL\pAktElement\pAktChild = 0 Or *TreeLL\pAktElement\pAktChild = -1 
            *TreeLL\pAktElement\pAktChild = -1 
            ProcedureReturn -1 
          Else 
            *TreeLL\pAktElement = *TreeLL\pAktElement\pAktChild 
          EndIf 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #Child         ;{ Springe zum aktuellen Child 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pChild And *TreeLL\pAktElement\pChild <> -1 
          If *TreeLL\pAktElement\pAktChild = 0 Or *TreeLL\pAktElement\pAktChild = -1 
            *TreeLL\pAktElement\pAktChild = -1 
            ProcedureReturn -1 
          Else 
            *TreeLL\pAktElement = *TreeLL\pAktElement\pAktChild 
            ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
          EndIf 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #Parent        ;{ Springe zum Parent 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          *TreeLL\pAktElement\pAktChild = 0 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pChild = -1 
          *TreeLL\pAktElement\pChild = 0 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pParent 
          *TreeLL\pAktElement\pParent\pAktChild = *TreeLL\pAktElement 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pParent 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #IsParent      ;{ Hat dieses Element ein Parent? 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pParent And *TreeLL\pAktElement\pAktChild <> -1 
          ProcedureReturn *TreeLL\pAktElement\pParent + TreeLLSize 
        Else 
          ProcedureReturn 0 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #Last          ;{ Springe zum letzten Element 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          *TreeLL\pAktElement\pAktChild = 0 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pChild 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pParent 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pParent\pChildLast 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        Else 
          *TreeLL\pAktElement = *TreeLL\pLastElement 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #First         ;{ Springe zum ersten Element 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          *TreeLL\pAktElement\pAktChild = 0 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pChild 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pParent 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pParent\pChild 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        Else 
          *TreeLL\pAktElement = *TreeLL\pFirstElement 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #Next          ;{ Springe zum n�chsten Element 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          *TreeLL\pAktElement\pAktChild = 0 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pChild 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pNext 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pNext 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      ElseIf *TreeLL\pFirstElement 
        *TreeLL\pAktElement = *TreeLL\pFirstElement 
        ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #IsNext        ;{ Folgt diesem Element noch eins? 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          ProcedureReturn *TreeLL\pAktElement\pChild + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pNext 
          ProcedureReturn *TreeLL\pAktElement\pNext + TreeLLSize 
        Else 
          ProcedureReturn 0 
        EndIf 
      ElseIf *TreeLL\pFirstElement 
        ProcedureReturn *TreeLL\pFirstElement + TreeLLSize 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #NextEx        ;{ Springe zum n�chsten Element oder zum Parent und zu dessen Nachfolger 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          *TreeLL\pAktElement\pAktChild = 0 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pChild 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pChild 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pChild 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        ElseIf *TreeLL\pAktElement\pNext 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pNext 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        Else 
          While *TreeLL\pAktElement\pParent And *TreeLL\pAktElement\pNext = 0 
            *TreeLL\pAktElement = *TreeLL\pAktElement\pParent 
          Wend 
          If *TreeLL\pAktElement\pNext 
            *TreeLL\pAktElement = *TreeLL\pAktElement\pNext 
            ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
          Else 
            ProcedureReturn 0 
          EndIf 
        EndIf 
      ElseIf *TreeLL\pFirstElement 
        *TreeLL\pAktElement = *TreeLL\pFirstElement 
        ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #IsChild       ;{ Hat dieses Element ein Child? 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pChild And *TreeLL\pAktElement\pAktChild <> -1 
          ProcedureReturn *TreeLL\pAktElement\pChild + TreeLLSize 
        Else 
          ProcedureReturn 0 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #Prev          ;{ Springe zum vorherigen Element 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pPrev And *TreeLL\pAktElement\pAktChild <> -1 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pPrev 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #IsPrev        ;{ Geht diesem Element eins voraus? 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pPrev And *TreeLL\pAktElement\pAktChild <> -1 
          ProcedureReturn *TreeLL\pAktElement\pPrev + TreeLLSize 
        Else 
          ProcedureReturn 0 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #CountChilds   ;{ Gibt die Anzahl der Childs zur�ck 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pChild 
          *New = *TreeLL\pAktElement\pChild 
          Count = 1 
          While *New\pNext 
            *New = *New\pNext 
            Count + 1 
          Wend 
          ProcedureReturn Count 
        Else 
          ProcedureReturn 0 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #CountList     ;{ Gibt die Anzahl der Elemente in dieser Rekursion zur�ck 
      If *TreeLL\pAktElement 
        *New = *TreeLL\pAktElement 
      ElseIf *TreeLL\pFirstElement 
        *New = *TreeLL\pFirstElement 
      Else 
        ProcedureReturn 0 
      EndIf 
      
      Count = 1 
      While *New\pNext 
        *New = *New\pNext 
        Count + 1 
      Wend 
      ProcedureReturn Count;} 
    
    Case #CountElements ;{ Gibt die Anzahl aller Elemente zur�ck 
      If *TreeLL\pFirstElement 
        *New = *TreeLL\pFirstElement 
        Count = 0 
        Repeat 
          If *New\pChild 
            *New = *New\pChild 
            Count + 1 
          Else 
            While *New\pNext = 0 And *New\pParent 
              *New = *New\pParent 
            Wend 
            *New = *New\pNext 
            Count + 1 
          EndIf 
        Until *New = 0 
        ProcedureReturn Count 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #CountColumn   ;{ Gibt die Anzahl der Rekursion des Elements zur�ck 
      If *TreeLL\pAktElement 
        Count = 0 
        If *TreeLL\pAktElement\pAktChild = -1 
          *New = *TreeLL\pAktElement\pAktChild 
        Else 
          *New = *TreeLL\pAktElement 
        EndIf 
        While *New\pParent 
          Count + 1 
          *New = *New\pParent 
        Wend 
        ProcedureReturn Count 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #Reset         ;{ Resete die aktuelle Rekursion 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pParent 
          *TreeLL\pAktElement\pParent\pAktChild = -1 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pParent 
          ProcedureReturn 1 
        Else 
          *TreeLL\pAktElement = 0 
          ProcedureReturn 1 
        EndIf 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #ResetAll      ;{ Resetet jede Liste 
      If *TreeLL\pFirstElement 
        *New = *TreeLL\pFirstElement 
        c = 0 
        Repeat 
          If *New\pChild 
            *New\pAktChild = 0 
            *New = *New\pChild 
          Else 
            While *New\pNext = 0  And *New\pParent 
              *New = *New\pParent 
            Wend 
            *New = *New\pNext 
          EndIf 
          c + 1 
        Until *New = 0 
        *TreeLL\pAktElement = 0 
        ProcedureReturn 1 
      EndIf 
      ProcedureReturn 0 
      ;} 
    
    Case #Delete_       ;{ L�scht das aktuelle Element samt seinen Childs 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pChild 
          *New = *TreeLL\pAktElement\pChild 
          Repeat 
            If *New\pChild 
              *New = *New\pChild 
            Else 
              While *New\pNext = 0 And *New\pParent <> *TreeLL\pAktElement 
                *New\pParent\pChild = *New 
                *New = *New\pParent 
                HeapFree_(Heap, 0, *New\pChild) 
              Wend 
              If *New\pNext 
                *New = *New\pNext 
                HeapFree_(Heap, 0, *New\pPrev) 
              Else 
                HeapFree_(Heap, 0, *New) 
                *New = 0 
              EndIf 
            EndIf 
          Until *New = 0 
        EndIf 
        ;{ Hier gehts weiter 
        *New = *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pPrev 
          *TreeLL\pAktElement\pPrev\pNext = *TreeLL\pAktElement\pNext 
        Else 
          If *TreeLL\pAktElement\pParent 
            *TreeLL\pAktElement\pParent\pChild = *TreeLL\pAktElement\pNext 
          Else 
            *TreeLL\pFirstElement = *TreeLL\pAktElement\pNext 
          EndIf 
        EndIf 
        If *TreeLL\pAktElement\pNext 
          *TreeLL\pAktElement\pNext\pPrev = *TreeLL\pAktElement\pPrev 
        EndIf 
        If *TreeLL\pAktElement\pParent 
          If *TreeLL\pAktElement\pParent\pAktChild = *TreeLL\pAktElement 
            *TreeLL\pAktElement\pParent\pAktChild = 0 
          EndIf 
        EndIf 
        
        If *TreeLL\pAktElement\pPrev = 0 
          If *TreeLL\pAktElement\pParent 
            *TreeLL\pAktElement = *TreeLL\pAktElement\pParent 
            *TreeLL\pAktElement\pAktChild = -1 
          Else 
            *TreeLL\pAktElement = 0 
          EndIf 
        Else 
          *TreeLL\pAktElement = *TreeLL\pAktElement\pPrev 
        EndIf 
        HeapFree_(Heap, 0, *New) 
        ProcedureReturn 1 
      EndIf;} 
      ProcedureReturn 0;} 
    
    Case #AllDelete     ;{ L�scht alle Elemente 
      If *TreeLL\pFirstElement 
        *New = *TreeLL\pFirstElement 
        Repeat 
          If *New\pChild 
            *New = *New\pChild 
          Else 
            While *New\pNext = 0 And *New\pParent 
              *New\pParent\pChild = *New 
              *New = *New\pParent 
              HeapFree_(Heap, 0, *New\pParent) 
            Wend 
            If *New\pNext 
              *New = *New\pNext 
              HeapFree_(Heap, 0, *New\pPrev) 
            Else 
              HeapFree_(Heap, 0, *New) 
              *New = 0 
            EndIf 
          EndIf 
        Until *New = 0 
        *TreeLL\pAktElement = 0 
        *TreeLL\pFirstElement = 0 
        *TreeLL\pLastElement = 0 
        ProcedureReturn 1 
      EndIf 
      ProcedureReturn 0;} 
    
    Case #GetPointer    ;{ Gibt den Pointer zum aktuellen Element zur�ck 
      If *TreeLL\pAktElement 
        If *TreeLL\pAktElement\pAktChild = -1 
          ProcedureReturn -1 
        Else 
          ProcedureReturn *TreeLL\pAktElement + TreeLLSize 
        EndIf 
      ElseIf *TreeLL\pFirstElement 
        ProcedureReturn -1 
      EndIf 
      ProcedureReturn 0;} 
    
    Default 
      ProcedureReturn 0 
  EndSelect;} 
EndProcedure 

;- Dokumentation 
; TreeLinkedList by NicTheQuick 
; 
; Mit der TreeLinkedList (kurz TreeLL) kann man eine dynamische Baumstruktur 
; aufbauen. Man kann sich das ganze folgenderma�en vorstellen: (Die Zahl in 
; der Klammer hinter dem R gibt einfach nur die Ebene eines Elementes an) 
; 
; TreeLL 
; |-Element1 R(0) 
; |  |-Element1 R(1) 
; |  |-Element2 R(1) 
; |  |-Element3 R(1) 
; |  |  |-Element1 R(2) 
; |  |  |-Element2 R(2) 
; |  |  |  |-Element1 R(3) 
; |  |  |  |-Element2 R(3) 
; |  |  |-Element3 R(2) 
; |  |-Element4 R(1) 
; |     |-Element1 R(2) 
; |        |-Element3 R(3) 
; |-Element2 R(0) 
;     |-Element1 R(1) 
; 
; Es stehen bisher insgesamt 24 Befehle zur Verf�gung: 
; 1. #NewTreeLL 
;    Beschreibung: 
;     Erstellt eine neue TreeLL. 
;    Anwendung: 
;     *TreeLL = TreeLL(#NewTreeLL, SizeOf(Structure)) 
;     
;     *TreeLL = Handle zur TreeLL. Dieses Handle wird bei allen anderen Funk- 
;         tionen nicht wieder erkl�rt. 
;     StructureSize.l = Gr��e der Structure, die sp�ter benutzt wird um Daten 
;         in einem Element zu speichern. 
;    R�ckgabewert: 
;     Gibt das Handle der TreeLL zur�ck. Es wird f�r s�mtliche nachfolgende 
;     Funktionen gebraucht. 
; 
; 2. #Add, #Insert 
;    Beschreibung: 
;     Erstellt ein neues Element nach dem aktuellen (#Add) bzw. vor dem aktu- 
;     ellen (#Insert). 
;    Anwendung: 
;     *Element.Structure = TreeLL(#Add / #Insert, *TreeLL) 
;    R�ckgabewert: 
;     Pointer zum neuen Element. 
; 
; 3. #Delete_ 
;    Beschreibung: 
;     L�scht das aktuelle Element samt seinen Unterelementen (Childs) und 
;     springt zum vorherigen Element oder resetet die Ebene, wenn das aktu- 
;     elle Element das erste in der Ebene war. 
;    Anwendung: 
;     Result.l = TreeLL(#Delete_, *TreeLL) 
;    R�ckgabewert: 
;     0, wenn kein aktuelles Element da war. 1, wenn das Element gel�scht 
;     wurde. 
; 
; 4. #AllDelete 
;    Beschreibung: 
;     L�scht alle Elemente der TreeLL. 
;    Anwendung: 
;     Result.l = TreeLL(#AllDelete, *TreeLL) 
;    R�ckgabewert: 
;     0, wenn kein Element vorhanden war. 1, wenn alles gel�scht wurde. 
; 
; 5. #First, #Last 
;    Beschreibung: 
;     Springt zum ersten Element (#First) bzw. zum letzten Element (#Last) 
;     der aktuellen Ebene. 
;    Anwendung: 
;     *Element.Structure = TreeLL(#First / #Last, *TreeLL) 
;    R�ckgabewert: 
;     Pointer zum angesprungenen Element oder 0, wenn kein aktuelles Element 
;     da war. 
; 
; 6. #Reset 
;    Beschreibung: 
;     Springt vor das erste Element der aktuellen Ebene. 
;    Anwendung: 
;     Result.l = TreeLL(#Reset, *TreeLL) 
;    R�ckgabewert: 
;     1, wenn die Ebene resetet wurde. 0, wenn kein aktuelles Element da war. 
; 
; 7. #ResetAll 
;    Beschreibung: 
;     Springt in jeder Ebenen vor das erste Element. 
;    Anwendung: 
;     Result.l = TreeLL(#ResetAll, *TreeLL) 
;    R�ckgabewert: 
;     1, wenn jede Ebene resetet wurde. 0, wenn keine Element vorhanden sind. 
; 
; 8. #Prev, #Next 
;    Beschreibung: 
;     Springt zum n�chsten Element (#Next) bzw. zum vorherigen (#Prev). 
;     F�r #Next: Wenn die Ebene resetet wurde, wird zum ersten Element der 
;     Ebene gesprungen. 
;    Anwendung: 
;     *Element.Structure = TreeLL(#Prev / #Next, *TreeLL) 
;    R�ckgabewert: 
;     Pointer zum angesprungenen Element oder 0, wenn kein Element zur Verf�- 
;     gung steht. 
; 
; 9. #NextEx 
;    Beschreibung: 
;     Springt zum n�chsten logischen Element. Im folgenden Beispiel wird die 
;     Reihenfolge angegeben: 
;         TreeLL 
;          |-1 
;          |-2 
;          | |-3 
;          | | |-4 
;          | | |-5 
;          | |-6 
;          |-7 
;          | |-8 
;          | |-9 
;          |-10 
;     Anwendung: 
;      *Element.Structure = TreeLL(#NextEx, *TreeLL) 
;     R�ckgabewert: 
;      Pointer zum n�chsten logischen Element oder 0, wenn das letzte Element 
;      erreicht wurde. 
; 
; 10. #NewChild 
;    Beschreibung: 
;     Erstellt eine neue Ebene unter dem aktuellen Element. Mit #New oder 
;     #Insert k�nnen in diese Ebene Element eingef�gt werden. Falls schon Un- 
;     terelemente vorhanden sind, wird zum ersten Element der Unterebene ge- 
;     sprungen. 
;    Anwendung: 
;     *Element.Structure = TreeLL(#NewChild, *TreeLL) 
;     ...oder... 
;     Result.l = TreeLL(#NewChild, *TreeLL) 
;    R�ckgabewert: 
;     0, wenn kein aktuelles Element da war, 
;     -1, wenn eine neue Ebene unter dem aktuellen Element erstellt wurde, 
;     oder der Pointer zum ersten Element der Unterebene. 
; 
; 11. #Child 
;    Beschreibung: 
;     Springt zum aktuellen Unterelement (Child) des aktuellen Elementes oder 
;     vor das erste Element, wenn die Unterebene resetet wurde oder noch nie 
;     aufgerufen wurde. 
;    Anwendung: 
;     *Element.Structure = TreeLL(#Child, *TreeLL) 
;     ...oder... 
;     Result.l = TreeLL(#Child, *TreeLL) 
;    R�ckgabewert: 
;     0, wenn kein aktuelles Element da war, 
;     -1, wenn vor die Unterebene gesprungen wurde, 
;     oder der Pointer zum Unterelement. 
; 
; 12. #Parent 
;    Beschreibung: 
;     Springt zum �bergeordneten Element (Parent) des aktuellen Elementes. 
;     Wenn der Befehl #NewChild zuvor ausgef�hrt wurde, wird dies wieder 
;     r�ckg�ngig gemacht. Bei wiederholtem Aufruf wird dann erst zum Parent 
;     gesprungen. 
;    Anwendung: 
;     *Element.Structure = TreeLL(#Parent, *TreeLL) 
;    R�ckgabewert: 
;     0, wenn kein aktuelles Element da war, sonst der Pointer zum Parent 
;     oder zum Element vor dem letzten #NewChild-Aufruf. 
; 
; 13. #IsPrev, #IsNext, #IsChild, #IsParent 
;    Beschreibung: 
;     Gibt nur den selben R�ckgabewert wie die gleichnamigen Befehl ohne "Is" 
;     zur�ck. Der Befehl selbst wird intern nicht ausgef�hrt. 
;    Anwendung: 
;     *Element.Structure = TreeLL(#IsPrev / ..., *TreeLL) 
;     ...oder... 
;     Result.l = TreeLL(#IsPrev / ..., *TreeLL) 
;    R�ckgabewert: 
;     Siehe entsprechende Befehle: #Prev, #Next, #Child, #Parent 
; 
; 14. #GetPointer 
;    Beschreibung: 
;     Gibt den Pointer zum aktuellen Element oder einen Statuswert zur�ck 
;    Anwendung: 
;     *Element.Structure = TreeLL(#GetPointer, *TreeLL) 
;     ...oder... 
;     Result.l = TreeLL(#GetPointer, *TreeLL) 
;    R�ckgabewert: 
;     0, wenn kein aktuelles Element da war, 
;     -1, wenn die aktuelle Ebene resetet wurde, 
;     oder den Pointer zum aktuellen Element. 
; 
; 15. #CountChilds 
;    Beschreibung: 
;     Gibt die Anzahl der Unterelemente (Childs) des aktuellen Elements 
;     zur�ck. 
;    Anwendung: 
;     Anzahl.l = TreeLL(#CountChilds, *TreeLL) 
; 
; 16. #CountList 
;    Beschreibung: 
;     Gibt die Anzahl der Elemente in der aktuellen Ebene zur�ck. 
;    Anwendung: 
;     Anzahl.l = TreeLL(#CountList, *TreeLL) 
; 
; 17. #CountElements 
;    Beschreibung: 
;     Gibt die Anzahl aller Element der TreeLL zur�ck. 
;    Anwendung: 
;     Anzahl.l = TreeLL(#CountElements, #TreeLL) 
; 
; 18. #CountColumn 
;    Beschreibung: 
;     Gibt die Tiefe der aktuellen Ebene an. Beispiel: Das erste Elemen in 
;     der TreeLL hat die Tiefe 0; hat dieses Element weitere Untelemente, so 
;     haben diese die Tiefe 1, usw... 
;    Anwendung: 
;     Tiefe.l = TreeLL(#CountColumn, *TreeLL) 

;- Beispiel 
Structure test 
  a.l 
  b.l 
  c.s 
EndStructure 

Tree.l = TreeLL(#NewTreeLL, SizeOf(test)) 

*testelement.test 

For a.l = 1 To 2 
  *testelement = TreeLL(#Add, Tree) 
  *testelement\b = a 
  *testelement\c = "|-----" 
  TreeLL(#NewChild, Tree) 
  For b.l = 1 To 5 
    *testelement = TreeLL(#Add, Tree) 
    *testelement\b = b 
    *testelement\c = "|    |-----" 
    TreeLL(#NewChild, Tree) 
    For c.l = 1 To 2 
      *testelement = TreeLL(#Add, Tree) 
      *testelement\b = c 
      *testelement\c = "|    |    |-----" 
    Next 
    TreeLL(#Parent, Tree) 
  Next 
  TreeLL(#Parent, Tree) 
Next 
Debug "Elementanzahl: " + Str(TreeLL(#CountElements, Tree)) 

Debug "L�sche Elemente mit der Nummer 3:" 
TreeLL(#ResetAll, Tree)     ;Durchsuche die Liste nach Eintr�gen mit der Nummer 3 und l�sche diese 
While TreeLL(#NextEx, Tree) 
  *testelement = TreeLL(#GetPointer, Tree) 
  If *testelement\b = 3 
    Debug TreeLL(#Delete_, Tree) 
  EndIf 
Wend 

Debug "Elementanzahl: " + Str(TreeLL(#CountElements, Tree)) 

Debug "Zeige die TreeLL an:" 
TreeLL(#ResetAll, Tree)     ;Zeige den Inhalt der gesamten Liste an 
While TreeLL(#NextEx, Tree) 
  *testelement = TreeLL(#GetPointer, Tree) 
  Debug *testelement\c + " (Nummer: " + Str(*testelement\b) + ")    [Childs: " + Str(TreeLL(#CountChilds, Tree)) + "]" 
Wend 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -----
; EnableAsm
