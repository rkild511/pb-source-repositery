; German forum: http://www.purebasic.fr/german/viewtopic.php?t=183&highlight=
; Author: Sylvia (updated for PB 4.00 by Andre)
; Date: 18. September 2004
; OS: Windows
; Demo: Yes


; Was bringt diese Funktion ?

; Anwendungsbeispiele:
; - Um zum Beispiel jedes Feld eines Array auf einen Anfangswert zu setzen 
; - Um einen Speicherbereich zu löschen 
; - Um einem Sprite eine einheitliche Farbe zuzuweisen (=ClearScreen) 
; - Um eine gelöschte Datei mit dem gefüllten Speicherbereich zu überschreiben


; Sep.2004 Sylvia, GermanForum 

Procedure MemoryFillL(Wert,Elemente,*Addr) 
; Füllt einen Speicherbereich mit LongWerten 

  CLD                    ; Aufsteigend 
  MOV EAX, Wert          
  MOV ECX, Elemente      
  MOV EDI, *Addr         ; ab Adresse 
 !REP STOSD              ; Repeat dwordTransfer          

EndProcedure 

Procedure MemoryFillB(Wert,Elemente,*Addr) 
; Füllt einen Speicherbereich mit ByteWerten 

  CLD                    ; Aufsteigend 
  MOV EAX, Wert          
  MOV ECX, Elemente      
  MOV EDI, *Addr         ; ab Adresse 
 !REP STOSB              ; Repeat ByteTransfer          

EndProcedure 



*Buffer=AllocateMemory(10000*4)    ; = 0- 9999 Longs 
                                   ; = 0-39999 Bytes 
MemoryFillL(100,10000,*Buffer) 
Debug PeekL(*Buffer+9999*4) 

MemoryFillB(Asc("A"),10000,*Buffer) 
Debug PeekB(*Buffer+9999)



; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm