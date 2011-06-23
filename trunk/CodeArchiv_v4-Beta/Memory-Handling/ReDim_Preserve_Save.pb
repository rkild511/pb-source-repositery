; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2133&highlight=
; Author: The_Pharao (updated for PB 4.00 by Deeem2031)
; Date: 29. August 2003
; OS: Windows
; Demo: Yes


; Important note: starting with PureBasic v4 ReDim is now natively included, 
; so this example is for demonstration only!


; Example for saving array contents before ReDim'ing it and using the content again 


;*** Erstellt: 29. August 2003 *** 

;*** Die Funktion "RedimPreserveSave" speichert den Inhalt eines Arrays *** 
;*** in den Puffer RedimPuffer                                 *** 

Global Dim RedimPuffer.b(0) 
RedimPufferSize.l = 1 

Procedure RedimPreserveSave(PtrToArray.l, LengthOfArray.l) 

  Shared RedimPufferSize.l 
  Dim RedimPuffer.b(LengthOfArray) 
    
  CopyMemory(PtrToArray, @RedimPuffer(), LengthOfArray) 

  RedimPufferSize = LengthOfArray 
EndProcedure 

;*** Die Funktion "RedimPreserveRestore" speichert den Inhalt des Puffer*** 
;*** in das Array zurück und berücksichtigt dabei die Länge             *** 

Procedure RedimPreserveRestore(PtrToArray.l, LengthOfArray.l) 

Shared RedimPufferSize.l 

  If LengthOfArray > RedimPufferSize 
  
    CopyMemory(@RedimPuffer(), PtrToArray, RedimPufferSize) 
    
  Else 
  
    CopyMemory(@RedimPuffer(), PtrToArray, LengthOfArray) 
    
  EndIf 

EndProcedure 


; *** Hier wird getestet, ob es auch funktioniert 

; *** Definieren einer Struktur: 

Structure strctPosition 
  X.f 
  Y.f 
EndStructure 
Structure strctShip 
  Pos.strctPosition 
  Name.s[10] 
EndStructure 

; *** Erzeugen unseres Arrays, das später "Preserved" (d.h. geschützt) re-dimensioniert werden soll 



Dim Ship.strctShip(5) 

ShipCount = 6 ; 0,1,2,3,4,5 

For k = 0 To 5 

  Ship(k)\Pos\x = 100 + k ; Jedem Schiff eine X-Position zuweisen 


Next k 

; Hier wird die Array-Information zwischengespeichert 
RedimPreserveSave (@Ship(0), SizeOf(strctShip) * ShipCount) 

;Array neu dimensionieren 
ShipCount = 10 
Dim Ship.strctShip(ShipCount - 1) 
;Jetzt ist das Array zurückgesetzt, d.h. die X-Position, 
;die oben festgelegt wurde, ist verloren! 


;Aber zum Glück haben wir die ja zwischengespeichert ;) 
RedimPreserveRestore(@Ship(0), SizeOf(strctShip) * ShipCount) 

;Die X-Position der Schiffe 0-5 ist also wieder da, 
;die Schiffe 6-Obergrenze sind natürlich leer. 

For k = 0 To ShipCount-1 

  MessageRequester ("X-Position von Ship #" + Str(k) , Str(Ship(k)\Pos\X), 0) 

Next k 

;The End! 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
