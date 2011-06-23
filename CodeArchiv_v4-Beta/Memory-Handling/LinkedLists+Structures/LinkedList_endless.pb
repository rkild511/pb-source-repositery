; German forum: 
; Author: NicTheQuick
; Date: 01. February 2003
; OS: Windows
; Demo: Yes


;Das ist die vereinfachte Darstellung der Struktur einer LinkedList 
; 
;Structure LinkedList 
;  Next.Element 
;  Previous.Element 
;  [UserTypes] 
;EndStructure 
; 
;Angenommen unsere LinkedList hat den Namen "LinkedList" und die Struktur LONG. Dann gibt uns 
;das vorangestellte @-Zeichen die Speicheradresse unseres LONGs zurück. Subtrahieren wir also 
;von der zurückgegebenen Speicheradresse 8, erhalten wir die Adresse des nächsten Elementes in 
;der LinkedList. Um den LONG aus dem nächsten Element auszulesen, nehmen wir diese Adresse, ad- 
;dieren 8 dazu und lesen mit PeekL() den Wert aus. Wie in dem folgenden Beispiel: 

NewList LinkedList.l()                      ;LinkedList erstellen 
AddElement(LinkedList())                     ;2 neue Element hinzufügen und 
LinkedList() = 1                             ;die Werte 1 und 2 zuweisen 
AddElement(LinkedList()) 
LinkedList() = 2 
FirstElement(LinkedList())                   ;Wieder zum ersten Element springen 

Address.l = @LinkedList()                    ;Speicheradresse auslesen 
Debug "Should be 1: " + Str(LinkedList()) 

Address - 8 
NextAddress.l = PeekL(Address)               ;Speicheradresse des nächsten Elements auslesen 

NextAddress + 8                              ;8 addieren 
ShouldBe2.l = PeekL(NextAddress)             ;Wert des zweiten Elements auslesen 
Debug "Should be 2: " + Str(ShouldBe2) 
ClearList(LinkedList()) 
Debug "--------" 

;Annahme: LinkedList mit x Elementen: 
;Wenn wir den Zeiger des letzten Elements in einer jeden LinkedList auf das erste Element 
;zeigen lassen, ist es möglich, dass beim Aufruf der NextElement()-Funktion beim letzten 
;Element zum ersten Element gespungen wird. Beispiel: 

x.l = 10 

For a.l = 1 To x                             ;x Elemente erstellen mit x versch. Werten 
  AddElement(LinkedList()) 
  LinkedList() = a 
  If a = 1 
    FirstAddress.l = @LinkedList() - 8        ;Speicheradresse des ersten Elements festhalten 
  EndIf 
Next 
LastAddress.l = @LinkedList() - 8             ;Speicheradresse des letzten Elements festhalten 

PokeL(LastAddress, FirstAddress)              ;Zeiger des letzten Elements auf das erste stellen 

Debug "Should be " + Str(x) + ": " + Str(LinkedList()) 

NextElement(LinkedList())                     ;Vom letzten Element das nächste aufrufen, also 
                                              ;das erste 

Debug "Should be 1: " + Str(LinkedList()) 

;Das einzigste Problem, das wir jetzt noch haben, ist, dass wir vom ersten Element nicht mehr 
;per PreviousElement() auf der letzte Element springen können. Also müssen wir beim ersten 
;Element auch den Zeiger für das Element davor umstellen auf das letzte Element. Weiter: 

PokeL(FirstAddress + 4, LastAddress)          ;Previous.Element (s. Struktur oben) umstellen 

PreviousElement(LinkedList())                 ;Zum vorherigen Element springen, als zum Letzten 

Debug "Should be " + Str(x) + ": " + Str(LinkedList()) 

;Eigentlich könnte man NextElement() oder PreviousElement() beliebig oft aufrufen, ohne dass 
;als Result Null zurückgegeben wird. Wir haben eine Endlosschleife innerhalb einer LinkedList 
;gemacht. 
; 
;by NicTheQuick 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -