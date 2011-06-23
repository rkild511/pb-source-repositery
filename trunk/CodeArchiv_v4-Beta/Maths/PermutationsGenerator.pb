; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3147&highlight=
; Author: SiBru  (output changed from MessageRequester to Debug by Andre)
; Date: 16. December 2003
; OS: Windows
; Demo: Yes


; Routine for generating permutations.
; Routine zur Permutations-Generierung.

;       Ú–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––¿
;       ³  Dieses Programm ist Eigentum vom ALSTER-SOFT Computerservice !!    ³
;       ³                                                                     ³
;       ³  Modul: PERMUTAT   Version 3.00  vom 19.05.2002                     ³
;       ³  generiert alle möglichen Kombinationen eines Strings               ³
;       ³  Erstellung am 07.09.2001 durch SiBru                               ³
;       À–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––Ù
;
;       Diese Routine dient der Permutation von Zeichen innerhalb eines Strings.
;       Bei jedem Aufruf wird eine einmalige Zusammensetzung der Zeichen inner=
;       halb des Strings geliefert. Sind alle möglichen Kombinationen durch=
;       laufen, so liefert diese Funktionen einen Leerstring.
;       Obwohl diese Routine bereits laufzeit-optimiert ist, kann das Ganze
;       je nach String-Länge erhebliche Zeit in Anspruch nehmen:
;       Zeichen Kombinationen   Zeit (ca, Compilat, 2. Zeit=MultiTask, 1.Zeit=
;         8        40.320           1 Sek - 2 Sec               SingleMode)
;         9       362.880          9 Sek - 21 Sec
;        10     3.638.800        1:35 -  3:50 Min
;        11    39.916.800       17:07 - 42:10 Min
;        12   497.001.600        3:27 -  8:30 Std
;
;A:     PERM.BASE$ = STRING$
;       LOOP:   ...do whathever to do with PERM.BASE$...
;       GOSUB PERMUTAT
;       IF PERM.BASE$>"" THEN GOTO LOOP ;nächste Kombination abarbeiten...
;
;GI:    PERM.BASE$= Basis-Zeichenkette, es werden alle Zeichenkombinationen
;                   der hier enthaltenen Zeichen geliefert, ohne jede Ein=
;                   schränkung (Doppelt-Zeichen möglich, Zeichenbereich
;                   0 bis 255, Zeichenlänge 3 bis 69 möglich {ab 11 Zeichen
;                   geht´s in die Zeit, siehe oben...})
;                   Bei jedem Aufruf wird in dieser Variablen eine neue
;                   Zeichen-Kombination geliefert, wenn alle möglichen
;                   Kombinationen durchlaufen wurden, so ist diese Variable
;                   leer.
;GI:    PERM.POS% = aktueller Positions-Zeiger, wenn dieser auf 0 steht, so
;                   werden sämtliche aktuellen Permutations-Daten gelöscht und
;                   eine neue Permutation mit PERM.BASE$ wird gestartet. Somit
;                   kann eine Permutation vorzeitig abgebrochen werden, indem
;                   diese Variable genullt wird.
;
;GO:    Die Variablen PERM.CNT%, PERM.POS%, PERM.LEN%, PERM.BASE$ und
;       PERM.QUEUE$ dürfen nicht verändert werden !!!
;       Anwendungs-Beispiel:
;       DIM PERM.CNT%(6) ;Dimensionierung muß max. Länge von PERM.BASE$
;                        ;entsprechen (besonders, wenn >10)
;       PERM.BASE$ = "abcdef"   ;zu permulatierende Zeichenkette
;       WHILE PERM.BASE$>""
;          ...do whathever with PERM.BASE$...
;          GOSUB PERMUTAT
;       WEND
;
;

;---------------- die Steuerung (individuell ersetzten...) ----------------
PERM_BASE$="1234"   ;set Permutations-Basis

Debug "Possible permutations of: " + PERM_BASE$

Dim PERM_CNT(Len(PERM_BASE$)+1) ;entsprechende Dimensionierung

While PERM_BASE$>""
  ;MessageRequester("",PERM_BASE$)
  Debug PERM_BASE$
  ;irgendwas mit dem Permutations-String anfangen
  Gosub PERMUTAT ;nächste Permutation holen (Ende, wenn PERM_BASE$="")
Wend

End


;========== die Routine ==========
PERMUTAT:
  If PERM_POS.l=0
    PERM_CNT.l=0
    PERM_QUEUE$=""
    PERM_LEN.l = Len(PERM_BASE$)
  EndIf
  PERM_POS.l = 1
  PERM_LVL:
  If PERM_CNT.l(PERM_POS.l)>=PERM_POS.l
    PERM_P.l = PERM_POS.l+1
    While Asc(PERM_QUEUE$)<PERM_P.l And PERM_QUEUE$>""
      PERM_POS.l = Asc(PERM_QUEUE$)
      PERM_QUEUE$ = Right(PERM_QUEUE$,Len(PERM_QUEUE$)-1)
      Gosub PERM_CHG
    Wend
    PERM_POS.l = PERM_P.l
    While PERM_P.l
      PERM_P.l = PERM_P.l-1
      PERM_CNT.l(PERM_P.l) = 0
    Wend
    If PERM_POS.l<PERM_LEN.l
      Goto PERM_LVL
    EndIf
    PERM_BASE$=""
    PERM_POS.l=0
    Return
  EndIf
  Gosub PERM_CHG
  PERM_QUEUE$ = Chr(PERM_POS.l)+PERM_QUEUE$
  PERM_CNT.l(PERM_POS.l) = PERM_CNT.l(PERM_POS.l)+1
Return

PERM_CHG:
  PERM_BASE$ = Mid(PERM_BASE$,PERM_POS.l+1,1)+Left(PERM_BASE$,PERM_POS.l)+Right(PERM_BASE$,Len(PERM_BASE$)-(PERM_POS.l+1))
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
