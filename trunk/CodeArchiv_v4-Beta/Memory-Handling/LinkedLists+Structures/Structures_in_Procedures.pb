; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1541&highlight=
; Author: NicTheQuick
; Date: 28. June 2003
; OS: Windows
; Demo: Yes


; Correct handling of (global) structures inside procedures

Structure StrucTest 
  Name.s 
  Alter.l 
EndStructure 

Global Person1.StrucTest        ;<- Jetzt ist Person1 auch in Procedures verfügbar 
;Person1.StrucTest               ;<- Damit nicht mehr 

Procedure Anzeigen(Nummer.l) 
  Person2.StrucTest              ;<- Strukturen sind allgemein global, daher kann man 
  Person2\Name = "Friedrich"     ;   in einer Procedure einer Variablen diese Struktur 
  Person2\Alter = 34             ;   zuweisen. 
  
  Select Nummer 
    Case 1 
      Debug Person1\Name + ", " + Str(Person1\Alter) 
    Case 2 
      Debug Person2\Name + ", " + Str(Person2\Alter) 
  EndSelect 
EndProcedure 

Person1\Name = "Günther"    : Person1\Alter = 21 

Anzeigen(1) 
Anzeigen(2)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
