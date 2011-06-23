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
;das vorangestellte @-Zeichen die Speicheradresse unseres LONGs zur�ck. Subtrahieren wir also 
;von der zur�ckgegebenen Speicheradresse 8, erhalten wir die Adresse des n�chsten Elementes in 
;der LinkedList. Um den LONG aus dem n�chsten Element auszulesen, nehmen wir diese Adresse, ad- 
;dieren 8 dazu und lesen mit PeekL() den Wert aus. Wie in dem folgenden Beispiel: 

NewList LinkedList.l()                      ;LinkedList erstellen 
AddElement(LinkedList())                     ;2 neue Element hinzuf�gen und 
LinkedList() = 1                             ;die Werte 1 und 2 zuweisen 
AddElement(LinkedList()) 
LinkedList() = 2 
FirstElement(LinkedList())                   ;Wieder zum ersten Element springen 

Address.l = @LinkedList()                    ;Speicheradresse auslesen 
Debug "Should be 1: " + Str(LinkedList()) 

Address - 8 
NextAddress.l = PeekL(Address)               ;Speicheradresse des n�chsten Elements auslesen 

NextAddress + 8                              ;8 addieren 
ShouldBe2.l = PeekL(NextAddress)             ;Wert des zweiten Elements auslesen 
Debug "Should be 2: " + Str(ShouldBe2) 
ClearList(LinkedList()) 
Debug "--------" 

;Annahme: LinkedList mit x Elementen: 
;Wenn wir den Zeiger des letzten Elements in einer jeden LinkedList auf das erste Element 
;zeigen lassen, ist es m�glich, dass beim Aufruf der NextElement()-Funktion beim letzten 
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

NextElement(LinkedList())                     ;Vom letzten Element das n�chste aufrufen, also 
                                              ;das erste 

Debug "Should be 1: " + Str(LinkedList()) 

;Das einzigste Problem, das wir jetzt noch haben, ist, dass wir vom ersten Element nicht mehr 
;per PreviousElement() auf der letzte Element springen k�nnen. Also m�ssen wir beim ersten 
;Element auch den Zeiger f�r das Element davor umstellen auf das letzte Element. Weiter: 

PokeL(FirstAddress + 4, LastAddress)          ;Previous.Element (s. Struktur oben) umstellen 

PreviousElement(LinkedList())                 ;Zum vorherigen Element springen, als zum Letzten 

Debug "Should be " + Str(x) + ": " + Str(LinkedList()) 

;Eigentlich k�nnte man NextElement() oder PreviousElement() beliebig oft aufrufen, ohne dass 
;als Result Null zur�ckgegeben wird. Wir haben eine Endlosschleife innerhalb einer LinkedList 
;gemacht. 
; 
;by NicTheQuick 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -