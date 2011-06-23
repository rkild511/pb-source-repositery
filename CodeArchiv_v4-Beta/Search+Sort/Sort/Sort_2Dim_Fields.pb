; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1758
; Author: agsontix
; Date: 23. July 2003
; OS: Windows
; Demo: Yes

; PRGNAME=sort2dimarray 
; VERSION=1,0,0,0 
; DESCRIP=Sortieren 2 dimensionaler Felder 
; COMPANY=JL 
; AUTHOR=Jens Lange 
; E-MAIL=lange-jens@freenet.de 
; WEB=www.lange-jens.de 

Dim namen.s(9,2) 
Dim sort.s(9) 

DataSection 
daten: 
Data.s "1","Peter","3","Werner","5","Otto","7","Alfred","9","Paul" 
Data.s "8","Karsten","6","Hans","4","Leo","2","Sven","0","Jan" 
EndDataSection 

Restore daten: 
For k=0 To 9 
Read index.s 
namen.s(k,1)=index.s 
Read vorname.s 
namen.s(k,2)=vorname.s 
Next k 

;Sortieren: 
;Aufbau des Sortiefeldes: 
;sort.s(x)= sortierkriterium + "|" + index.s + "|" vorname.s 
; das "|" ist als Trennzeichen zum Aufsplitten gedacht 
For k=0 To 9 
sort.s(k) = namen.s(k,1) + "|" + namen.s(k,1) + "|" + namen.s(k,2) 
Next k 

;Ausgabe unsortiert 
ergebnis.s="" 
For k=0 To 9 
ergebnis.s=ergebnis.s + StringField(sort.s(k),2,"|") +Chr(9) +StringField(sort.s(k),3,"|")+Chr(13) 
Next k 
MessageRequester("Ausgabe unsortiert",ergebnis.s,#PB_MessageRequester_Ok) 

;Ausgabe nach Index aufsteigend 
SortArray(sort.s(),0) 
ergebnis.s="" 
For k=0 To 9 
ergebnis.s=ergebnis.s + StringField(sort.s(k),2,"|") +Chr(9) +StringField(sort.s(k),3,"|")+Chr(13) 
Next k 
MessageRequester("Sortieren nach Index aufsteigend",ergebnis.s,#PB_MessageRequester_Ok) 

;Ausgabe nach Index absteigend 
SortArray(sort.s(),1) 
ergebnis.s="" 
For k=0 To 9 
ergebnis.s=ergebnis.s + StringField(sort.s(k),2,"|") +Chr(9) +StringField(sort.s(k),3,"|")+Chr(13) 
Next k 
MessageRequester("Sortieren nach Index absteigend",ergebnis.s,#PB_MessageRequester_Ok) 

;Sortieren nach Index 
For k=0 To 9 
sort.s(k) = namen.s(k,2) + "|" + namen.s(k,1) + "|" + namen.s(k,2) 
Next k 

;Ausgabe nach Vorname aufsteigend 
SortArray(sort.s(),2) 
ergebnis.s="" 
For k=0 To 9 
ergebnis.s=ergebnis.s + StringField(sort.s(k),2,"|") +Chr(9) +StringField(sort.s(k),3,"|")+Chr(13) 
Next k 
MessageRequester("Sortieren nach Vorname aufsteigend",ergebnis.s,#PB_MessageRequester_Ok) 

;Ausgabe nach Vorname absteigend 
SortArray(sort.s(),3) 
ergebnis.s="" 
For k=0 To 9 
ergebnis.s=ergebnis.s + StringField(sort.s(k),2,"|") +Chr(9) +StringField(sort.s(k),3,"|")+Chr(13) 
Next k 
MessageRequester("Sortieren nach Vorname absteigend",ergebnis.s,#PB_MessageRequester_Ok) 

;ist nur als Beispiel zu verstehen, muß nach eigenen Erfordernissen angepasst werden 
;sortiertes Feld muß wieder in Original- Feld zurückkopiert werden 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
