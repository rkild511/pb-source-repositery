; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1676&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 15. July 2003
; OS: Windows
; Demo: Yes


; Example for using LinkedLists in LinkedLists
; Beispiel zur Verwendung von LinkedLists in LinkedLists

;Hier werden die Speicheradressen der einzelnen LinkedLists gespeichert 
Global NewList Speicher.l() 
;Hier sind die einzelnen LinkedLists gespeichert 
Global NewList LinkedList.l() 

Procedure NewLinkedList()           ;Erstellt eine neue LinkedList und ein neues Element in der Liste 
  If LastElement(LinkedList()) 
    AddressLast.l = @LinkedList() 
  EndIf 
  
  AddElement(LinkedList()) 
  Address.l = @LinkedList() 
  PokeL(Address - 8, 0) 
  PokeL(Address - 4, 0) 
  
  If AddressLast 
    PokeL(AddressLast - 8, 0) 
  EndIf 
  AddElement(Speicher()) 
  Speicher() = Address 
EndProcedure 

Procedure NextLinkedList()          ;Springt zur nächsten dynamischen LinkedList 
  If NextElement(Speicher()) 
    ChangeCurrentElement(LinkedList(), Speicher()) 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure PreviousLinkedList()      ;Springt zur vorherigen dynamischen LinkedList 
  If PreviousElement(Speicher()) 
    ChangeCurrentElement(LinkedList(), Speicher()) 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure FirstLinkedList()         ;Springt zur ersten LinkedList 
  If FirstElement(Speicher()) 
    ChangeCurrentElement(LinkedList(), Speicher()) 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure LastLinkedList()          ;Springt zur letzten LinkedList 
  If LastElement(Speicher()) 
    ChangeCurrentElement(LinkedList(), Speicher()) 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure DeleteLinkedList()        ;Löscht eine LinkedList mit allen Elementen 
  If @Speicher() 
    ChangeCurrentElement(LinkedList(), Speicher()) 
    DeleteElement(LinkedList()) 
    While NextElement(LinkedList()) 
      DeleteElement(LinkedList()) 
    Wend 
    DeleteElement(Speicher()) 
    ProcedureReturn #TRUE 
  Else 
    ProcedureReturn #FALSE 
  EndIf 
EndProcedure 

Procedure FirstLinkedListElement()  ;Springt zum ersten Element in der LinkedList 
  If Speicher() 
    ChangeCurrentElement(LinkedList(), Speicher()) 
  EndIf 
EndProcedure 

;BEISPIEL-CODE 
;¯¯¯¯¯¯¯¯¯¯¯¯¯ 
NewLinkedList()             ;Wir erstellen eine LinkedList mit 2 Elementen 
LinkedList() = 1 
AddElement(LinkedList()) 
LinkedList() = 2 

NewLinkedList()             ;Und noch eine mit 3 Elementen 
LinkedList() = 3 
AddElement(LinkedList()) 
LinkedList() = 4 
AddElement(LinkedList()) 
LinkedList() = 5 

NewLinkedList()             ;Noch eine mit 4 Elementen 
LinkedList() = 6 
AddElement(LinkedList()) 
LinkedList() = 7 
AddElement(LinkedList()) 
LinkedList() = 8 
AddElement(LinkedList()) 
LinkedList() = 9 

FirstLinkedList()           ;Wir springen zur ersten LinkedList 
Debug LinkedList() 
While NextElement(LinkedList()) 
  Debug LinkedList()        ;und gehen alle Elemente durch 
Wend 

LastLinkedList()            ;Die letzte LinkedList 
Debug LinkedList() 
While NextElement(LinkedList()) 
  Debug LinkedList() 
Wend 

PreviousLinkedList()        ;Die vorherige LinkedList 
Debug LinkedList() 
While NextElement(LinkedList()) 
  Debug LinkedList() 
Wend
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
