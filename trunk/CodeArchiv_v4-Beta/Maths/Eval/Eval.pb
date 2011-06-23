; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2073&highlight=
; Author: freedimension
; Date: 23. August 2003
; OS: Windows
; Demo: Yes

;- Description
; Komma: , oder . für Nachkommastellen 
; Vorzeichen: +/- 
; Addition: + 
; Subtraktion: - 
; Multiplizieren: * 
; Dividieren: / oder : 
; Modulo: % 
; Potenzieren: ^ 
; Fakultät: ! (wandelt zu Int) 
; Bitweise And: & (wandelt zu Int) 
; Bitweise Or: | (wandelt zu Int) 
; Gleichheit: = (gibt 1 zurück wenn gleich, sonst 0) 
; Größer: > (gibt 1 zurück wenn größer, sonst 0) 
; Kleiner: < (gibt 1 zurück wenn kleiner, sonst 0) 
; Wiss. Notation: x.xxxE+xxx oder x.xxxE-xxx (+/- zwingend, ansonsten alles Variabel) 
; Trigonometrie: Sin, ASin, Cos, ACos, Tan, ATan 
; Logarithmen: Log (10er), Ln (natürlicher) 
; sonstiges: Abs (Absolutwert), Sqr (Wurzel), INV (invertiert Zahl 1/x) 
; letztes Ergebnis: LR 
; Wert speichern: :MEM (es wird das letzte Ergebnis gespeichert) 
; Wert abrufen: MEM 
; zus. Speicher: MEMx (1-9) 
; 
; 
; BEISPIELTERME 
; 
; Ergebnisse sind immer hinter dem letzten Doppelpunkt angeführt (leider hat's das Layout 
; HTML-Technisch etwas verhackt) 
; 
; Das erste Rechenbeispiel das ich mit einem neuen Rechner ausprobiere (wird die
; Operatorreihenfolge auch eingehalten) 
; 3+3*3 : 12 
; (3+3)*3 : 18 
; 
; Trigonometrie 
; Sin(pi/2) : 1 
; CosPi : -1 
; 
; beliebiger Logarithmus 
; ln1024/ln4 : 5 (entspr. dem Logarithmus von 1024 zur Basis 4) 
; 
; mehrere Rechenschritte (Am Beispiel der Quadratischen Gleichung 2x^2 + 5x + 3 
; +Sqr(5^2-4*2*3) : 1 
; :MEM : M+ 1 
; (-5+MEM)/(2*2) : -1 
; 2*lr^2 + 5*lr + 3 : 0 (Proberechnung) 
; (-5-MEM)/(2*2) : -1.5 
; 2*lr^2 + 5*lr + 3 = 0 : 1 (alternativer Test)


;- Example
IncludeFile "Eval_Include.pb" 

OpenConsole() 
Repeat 
  Print("Term: ") 
  in.s = Input() 
  If in="" : End : EndIf 
  PrintN("") 
  PrintN(Eval(in)) 
  PrintN("") 
ForEver 
CloseConsole() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
