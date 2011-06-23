; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=824&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Deeem2031)
; Date: 29. April 2003
; OS: Windows
; Demo: Yes

Structure stru_Artikel 
  Bezeichnung.s     ;Bezeichnung des Artikels 
  Preis.l           ;Preis in Cent des Artikels 
  Pointer.l         ;Pointer zum Kunden 
EndStructure 
Structure Stru_Kunde 
  Vorname.s         ;Vorname des Kunden 
  Nachname.s        ;Nachname des Kunden 
  Pointer.l         ;Pointer zum ersten Artikel 
  AnzahlArtikel.l   ;Anzahl der Artikel 
EndStructure 

Global NewList ll_Kunden.stru_Kunde() 
Global NewList ll_Artikel.stru_Artikel() 

;Erstellt einen neuen Kunden hinter dem ausgew�hlten 
;und weist gleichzeitig Vorname und Nachname zu 
Procedure NeuerKunde(Vorname.s, Nachname.s) 
  If AddElement(ll_Kunden()) 
    ll_Kunden()\Vorname = Vorname 
    ll_Kunden()\Nachname = Nachname 
    ProcedureReturn #True 
  EndIf 
EndProcedure 

;L�scht den ausgew�hlten Kunden samt seinen Artikeln 
Procedure LoescheKunde() 
  If @ll_Kunden() - 8 
    If ll_Kunden()\Pointer 
      ChangeCurrentElement(ll_Artikel(), ll_Kunden()\Pointer) 
      For a.l = 1 To ll_Kunden()\AnzahlArtikel 
        DeleteElement(ll_Artikel()) 
      Next 
    EndIf 
    DeleteElement(ll_Kunden()) 
    ProcedureReturn #True 
  EndIf 
EndProcedure 

;Wechselt zum angegebenen Kunden und seinem ersten Artikel. 
;Index beginnend bei 0. (Erster Kunden = 0, Zweiter Kunde = 1, ...) 
Procedure ChangeKunde(Index.l) 
  SelectElement(ll_Kunden(), Index) 
  If ll_Kunden()\Pointer 
    ChangeCurrentElement(ll_Artikel(), ll_Kunden()\Pointer) 
  EndIf 
EndProcedure 

Procedure AnzahlKunden() 
  ProcedureReturn CountList(ll_Kunden()) 
EndProcedure 

;- 

;Erstellt einen neuen Artikel beim ausgew�hlten Kunden 
;und weist gleichzeitig Bezeichnung und Preis zu 
Procedure NeuerArtikel(Bezeichnung.s, Preis.l) 
  ;Wenn der Kunde schon Artikel hat... 
  If ll_Kunden()\Pointer 
    ;...wechsele zum ersten Artikel,... 
    ChangeCurrentElement(ll_Artikel(), ll_Kunden()\Pointer) 
    
    ;...springe zum letzten Artikel,... 
    For a.l = 2 To ll_Kunden()\AnzahlArtikel 
      NextElement(ll_Artikel()) 
    Next 
    
    ;...erstelle einen neuen und weise Bezeichnung und Preis zu. 
    If AddElement(ll_Artikel()) 
      ll_Artikel()\Bezeichnung = Bezeichnung 
      ll_Artikel()\Preis = Preis 
      ll_Artikel()\Pointer = @ll_Kunden() 
      ll_Kunden()\AnzahlArtikel + 1 
      PokeL(@ll_Artikel() - 8, 0) 
      ProcedureReturn #True 
    EndIf 

  ;Wenn der Kunde noch keinen Artikel hat... 
  Else 
    ;...springe ans Ende von ll_Artikel()... 
    If LastElement(ll_Artikel()) 
      *Address = @ll_Artikel() - 8 
    EndIf
    
    ;...und f�ge einen neuen Artikel ein mit Bezeichnung und Preis. 
    If AddElement(ll_Artikel()) 
      ll_Kunden()\Pointer = @ll_Artikel() 
      ll_Kunden()\AnzahlArtikel = 1 
      ll_Artikel()\Bezeichnung = Bezeichnung 
      ll_Artikel()\Preis = Preis 
      ll_Artikel()\Pointer = @ll_Kunden() 
      PokeL(@ll_Artikel() - 4, 0) 
      If *Address : PokeL(*Address, 0) : EndIf 
      ProcedureReturn #True 
    EndIf 
  EndIf 
EndProcedure 

;Springt zum x-ten Artikel des ausgew�hlten Kunden 
;Index beginnend bei 0 (Erster Kunde = 0, Zweiter Kunde = 1, ...) 
Procedure ChangeArtikel(Index.l) 
  ;Wenn ein Kunde ausgew�hlt ist... 
  If ll_Kunden()\Pointer 
    
    ;...springe zu seinem ersten Artikel... 
    ChangeCurrentElement(ll_Artikel(), ll_Kunden()\Pointer) 
    
    ;...und dann zum gew�nschten Artikel. 
    For a.l = 1 To Index 
      NextElement(ll_Artikel()) 
    Next 
    ProcedureReturn @ll_Artikel() 
  EndIf 
EndProcedure 

;Gibt die Anzahl an Artikeln des ausgew�hlten Kundes zur�ck 
Procedure AnzahlArtikel() 
  ;Wenn ein Kunde ausgw�hlt ist. 
  If @ll_Kunden() - 8 
    ProcedureReturn ll_Kunden()\AnzahlArtikel 
  EndIf 
EndProcedure 

;L�scht den ausgew�hlten Artikel und springt wieder zum 
;ersten Artikel des dazugeh�rigen Kunden 
Procedure LoeschArtikel() 
  ;Wenn zum ausgew�hlten Artikel ein Kunde geh�rt... 
  If ll_Artikel()\Pointer 
    
    ;...wechsele zu diesem. 
    ChangeCurrentElement(ll_Kunden(), ll_Artikel()\Pointer) 
    
    ;Wenn er nur noch ein Artikel hat.. 
    If ll_Kunden()\AnzahlArtikel = 1 
      ;...l�sche ihn... 
      DeleteElement(ll_Artikel()) 
      ;...und setzte beim Kunden alle Werte zur�ck. 
      ll_Kunden()\AnzahlArtikel = 0 
      ll_Kunden()\Pointer = 0 
      ProcedureReturn #True 
    EndIf 
    
    ;Wenn der erste Artikel gel�scht werden soll... 
    If @ll_Artikel() = ll_Kunden()\Pointer 
      ;...l�sche ihn,... 
      DeleteElement(ll_Artikel()) 
      ;...weise ll_Kunden() den Pointer f�r den neuen ersten Artikel zu... 
      ll_Kunden()\Pointer = @ll_Artikel() 
      ;...und setzte den Counter um eins niedriger. 
      ll_Kunden()\AnzahlArtikel - 1 
      ProcedureReturn #True 
    EndIf 
    
    ;Wenn ein anderer Artikel gel�scht werden soll l�sche ihn... 
    DeleteElement(ll_Artikel()) 
    ll_Kunden()\AnzahlArtikel - 1 
    ;...und springe wieder zum ersten Artikel des Kunden. 
    ChangeCurrentElement(ll_Artikel(), ll_Kunden()\Pointer) 
    
  EndIf 
EndProcedure 

NeuerKunde("Aaron", "Herat") 
NeuerKunde("Benjamin", "Feit") 
NeuerKunde("Carolin", "Seiwert") 

ChangeKunde(0) 
NeuerArtikel("Holzschrauben 9 mm", 295) 
NeuerArtikel("Schaniere", 549) 

ChangeKunde(1) 
NeuerArtikel("Blumentopf (gro�)", 400) 

ChangeKunde(2) 
NeuerArtikel("Vogelfutter (gemischt)", 999) 
NeuerArtikel("Teichpumpe 1000 l/h", 4900) 
NeuerArtikel("Gartenschlauch 20 m", 1000) 
NeuerArtikel("Adapter 1332", 99) 

Kunden.l = AnzahlKunden() 

For a.l = 0 To Kunden - 1 
  ChangeKunde(a) 
  Debug ll_Kunden()\Vorname + " " + ll_Kunden()\Nachname + ":" 
  Artikel.l = AnzahlArtikel() 
  For b.l = 0 To Artikel - 1 
    ChangeArtikel(b) 
    Debug " |- " + ll_Artikel()\Bezeichnung 
  Next 
  Debug " " 
Next

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
