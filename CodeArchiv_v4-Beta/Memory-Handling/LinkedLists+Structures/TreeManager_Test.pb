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

; Da eine Liste in dieser Library als Pointer zur�ck 
; gegeben (und auch so behandelt) wird, kann man eine 
; Liste auch als Element hinzuf�gen. 

; Ein Kleines Beispiel: Du machst zun�chst Zwei Listen 
; wie hier: 
; *Liste1.TM_List = TM_CreateList() 
; *Liste2.TM_List = TM_CreateList() 

; Nun kannst du den Pointer von Liste2 als Element zu 
; Liste1 angeben. Wie hier: 
; TM_AddElement(*Liste1, *Liste2) 

; Wenn du sp�ter die Liste in der Liste durchgehen 
; willst, dann musst du einfach eine zus�tzliche 
; Schleife machen. Wie du alle Elemente durchscanst 
; wird hier im Code nun gezeigt. Der rest bleibt 
; dein logisches Denken �berlassen. 

; Wichtiger Hinweis!!! 
; -------------------- 
; Diese Library sieht auf den ersten Blick etwas mager 
; aus. Aber wenn man mit Pointer umzugehen weis, der 
; wird wissen wie unn�tig Childs und Parents wirklich 
; sind - woraus z.B. NicTheQuick's Library aufbaut. 


; Inkludiere die Library 
IncludeFile("TreeManager.pb") 

; Hier ist die Test Struktur 
Structure TestStruct 
  MyString.s 
EndStructure 

; Nun wird die Liste erstellt. 
*TestList.TM_List = TM_CreateList() 

; Erstelle 10 mal ein Element f�r die Liste. 
For I = 1 To 10 
  ; Zun�chst wird pro Durchlauf eine Test Struktur in Speicher 
  ; hergerichtet. MyString wird "Blub" + .. zugewiesen. 
  *Test.TestStruct = AllocateMemory(SizeOf(TestStruct)) 
  *Test\MyString = "Blub" + Str(I) 

  ; Nun kommt der eigentliche Sinn einer Pointerliste: F�ge ein 
  ; Element mit den Pointer des gerade reservierten Speichers 
  ; hinzu. 
  TM_AddElement(*TestList, *Test.TestStruct) 
Next 

; �ffne Konsole 
OpenConsole() 

; Scane die Liste R�ckw�rts ... 
TM_ScanInverse(*TestList, #True) 

; Neues Scanen. 
TM_ScanNew(*TestList) 

; Gehe jedes Element durch der Liste "*TestList" durch. 
While TM_ScanNextElement(*TestList) 
  ; Nun wird ein Pointer belegt. In dem fall muss man 
  ; .TestStruct angeben, weil es sich hierbei ja um 
  ; solch eine struktur handelt. 
  
  ; In den Pointer kommt nun die Adresse die im Element 
  ; Gespeichert ist. 
  *ScanPoint.TestStruct = TM_ElementPointer(*TestList) 

  ; Nun ist es m�glich anhand des Pointers seine Daten 
  ; (in dem fall ein String) auszugeben - wie man hier 
  ; sehen kann: 
  PrintN(*ScanPoint\MyString) 
Wend 

; Warte auf Return. 
Input() 

; Schlie�e Konsole. 
CloseConsole() 

; L�sche Liste 
TM_DeleteList(*TestList)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -