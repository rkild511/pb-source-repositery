; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2518&highlight=
; Author: QuickBasic
; Date: 09. October 2003
; OS: Windows
; Demo: Yes


; Das Programm zeigt den Verlauf von Lindenmeyer-Systemen (näheres bei GOOGLE) 

; Einfach mal für 
; -Regel "F" eingeben 
; -Axiom 1 "F++F++F" eingeben 
; -Axiom 2 "F--F" eingeben 
; -Iterationen "2" oder "3" eingeben 
; 
; und schauen, was passiert! 
; 
;----------------------------------------------------------------------------------- 
RegelName.s 
Axiom1.s 
Axiom2.s 
Verlauf.s 
JaNein.s 
Anzahl.l 
i.l 

OpenConsole() 
Repeat 
  ClearConsole() 
  PrintN("Textbasierte Darstellung der Lindenmeyer-Systeme") 
  PrintN("") 
  PrintN("") 
  Print("Bitte Name der Regel eingeben......: ") 
  RegelName = Input() 
  PrintN("") 
  Print("Bitte Axiom 1 eingeben.............: ") 
  Axiom1 = Input() 
  PrintN("") 
  Print("Bitte Axiom 2 eingeben.............: ") 
  Axiom2 = Input() 
  PrintN("") 
  Print("Anzahl der Iterationen.............: ") 
  Anzahl = Val(Input()) 
  ClearConsole() 
  Verlauf = Axiom1 
  If ((Anzahl > 0) And (Anzahl < 11)) 
     For i = 1 To Anzahl 
        Verlauf = ReplaceString(Verlauf, RegelName, Axiom2, 1) 
        PrintN("Iteration..: "+Str(i)) 
        PrintN("Verlauf....: "+Verlauf) 
     Next i 
  EndIf 
  PrintN("") 
  Print("Neustart (J/N)? ") 
  JaNein = Input() 
Until ((JaNein = "N") Or (JaNein = "n")) 
CloseConsole() 
End 
;----------------------------------------------------------------------------------- 
 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
