; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1793&highlight=
; Author: schic
; Date: 25. January 2005
; OS: Windows
; Demo: Yes

; 
; Phonetic text search with the DoubleMetaphone code from Lawrence Philips 
; coded in PureBasic from SchiC 
; 
; best viewed with jaPBe 


; Phonetische Text-Suche mit "DoubleMetaphone" Code von Lawrence Philipps

; Zu verwenden als Grundlage für Rechtschreibprüfung oder 
; einfach als flexiblere Suchfunktion da fehlertolerant. 
; 

; Verschiedene Fragen:
;   Wie funktioniert das im Vergleich zu Soundex und anderen Verfahren? 
;   Ist das eine patentierte Variante? 
;   Für welche Sprache (deutsch, englisch...) ist es am besten geeignet? 
;   Erstellt es ähnlich Soundex einen Phonetischen String? 

; DAS Verfahren ist nicht patentiert. Es gibt mehrere 
; Implementationen im Netz in PHP, Ruby, C++ etc. 
; einige auch im OpenSource Bereich (GNU Aspell). 
; Siehe Google [doublemetaphone spelling]. 
; 
; Im Gegensatz zu Soundex, sind nicht Zahlen 
; bestimmten Buchstaben zugeordnet und das erste 
; Zeichen ein Buchstabe, sondern alle Buchstaben 
; werden auf 14 Konsonanten zurückgeführt und der 
; resultierende Code wird immer auf 4 Zeichen 
; gekürzt. Soweit ist es Soundex etwas ähnlich. Aber 
; bei bestimmten Zeichen-Kombinationen wird auf 
; die individuellen Ausspracheeigenheiten in 
; verschiedenen Sprachen eingegangen (siehe Code 
; und Kommentare). Daraus resultieren dann auch 
; öfters 2 verschiedene phonetische Codes (deshalb 
; DoubleMetaphone). 
; DAS macht den Hauptunterschied zu Soundex (außer 
; der viel größeren Komplexität). 
; 
; DAS Verfahren soll dadurch für alle Sprachen gut 
; geeignet sein (jedenfalls deutlich besser als Soundex). 
; Ich habe jedoch festgestellt, daß Kombinationen mit 
; sz, cz, sch usw. aus dem slawischen Sprachraum 
; nicht immer optimal umgesetzt werden. 
; 
; Der DoubleMetaphone Algorithmus ist eine 
; Verbesserung des Metaphone Algorithmus vom 
; gleichen Autor. 
; 
; Aber schau Dir einfach die Beispiele an, da sind 
; einige Rechtschreibfehler drin (besonders "a search 
; example in english"  ) 
; Die Fehlertoleranz für falsch buchstabierte Suchbegriffe 
; ist teilweise wirklich erstaunlich. 


Structure DblMet 
  i.s 
  II.s 
  n.l 
EndStructure 

Structure WordInTxt 
  strTxt.s 
  Pos.l 
EndStructure 

Procedure getTPLMTFN(txt$, StartPos.l, numChars.l) 
  
  ; Source        : DoubleMetaphone - A phonetic search algorithm, much better than Soundex() 
  ;               : Converted from Lawrence Philips; CUJ June 2000 C++ "Double Metaphone" code. 
  ; Version       : 1 Beta 
  ; Author(s)     : Lawrence Philips for the "Original" C++ code, and 
  ;               : SchiC for the PureBasic conversion of the C++ code. 
  ; -------------------------------------------------------------------- 
  ; References    : Philips, Lawrence. C/C++ Users Journal (CUJ), June, 2000 
  ;               : 
  ; Note          : Reduces alphabet to the 14 consonant sounds: 
  ;               : X S K J T F H L M N P R 0 W 
  ;               : drop vowels except at the beginning 
  ; -------------------------------------------------------------------- 
  ; 
  ; Useful links: 
  ; The original C++ double Metaphone algorithm from Lawrence Philips: 
  ; ftp://ftp.cuj.com/pub/2000/1806/philips.zip 
  ; 
  ; as reference for testing results look at 
  ; http://swoodbridge.com/DoubleMetaPhone/mptest.php3 

  Shared RetTxt.DblMet 
  #vowels = "AEIOUY" 
  Static slavogermanic.b 
  
  RetTxt\i = "" 
  RetTxt\II = "" 
  current = StartPos 
  Length = numChars;Len(txt$) 
  last = Length-1;Len(txt$) - 1 
  
  txt$=UCase(txt$) 
  
  If StartPos = 1 
    ;skip these when at start of word 
    If FindString("GN KN PN WR PS",Left(txt$,2),1)  ;skip these when at start of word 
      current + 1 
    ElseIf Left(txt$,1)="X" ;Initial "X" is pronounced "Z" e.g. "Xavier" 
      RetTxt\i = RetTxt\i + "S" 
      RetTxt\II = RetTxt\II + "S" 
      current + 1 
    ElseIf FindString(#vowels,Left(txt$,1),1) ;all init vowels now map to "A" 
      RetTxt\i = RetTxt\i + "A" 
      RetTxt\II = RetTxt\II + "A" 
      current + 1 
    ElseIf Left(txt$,6)="CAESAR"  ;special case "caesar" 
      RetTxt\i = RetTxt\i + "S" 
      RetTxt\II = RetTxt\II + "S" 
      current + 2 
    EndIf 
    
    slavogermanic = #False 
    If FindString(txt$,"W",1) Or FindString(txt$,"K",1) Or FindString(txt$,"CZ",1) Or FindString(txt$,"WITZ",1) 
      slavogermanic = #True 
    EndIf 
  EndIf 
  
  txt$ = Space(6) + txt$ + Space(6) 
  current + 6 
  Length = current + numChars-1 
  last = 7 + last 
  
  While current <= Length;Len(RetTxt\I) < 4 Or Len(RetTxt\II) < 4 
    
    If Len(RetTxt\i) >= 4: Break: EndIf 
    
    strcur.s  = Mid(txt$,current,1) 
    strprv1.s = Mid(txt$,current-1,1) 
    strprv2.s = Mid(txt$,current-2,1) 
    strnxt1.s = Mid(txt$,current+1,1) 
    strnxt2.s = Mid(txt$,current+2,1) 
    
    Select strcur 
        
      Case "B";-B 
        RetTxt\i = RetTxt\i + "P" 
        RetTxt\II = RetTxt\II + "P" 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "Ç";-Ç 
        RetTxt\i = RetTxt\i + "S" 
        RetTxt\II = RetTxt\II + "S" 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "C";-C 
        ;various germanic 
        If current > 8 And FindString(#vowels,strprv2,1)=0 And Mid(txt$,current-1,3)="ACH" And FindString("EI",strnxt2,1)=0 Or FindString("BACHER MACHER,",Mid(txt$,current-2,6),1) 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "K" 
          current + 2 
        ElseIf Mid(txt$,current,4)="CHIA" ;italian "chianti" 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "K" 
          current + 2 
        ElseIf Mid(txt$,current,2)="CH" 
          If current > 7 And Mid(txt$,current,4)="CHAE" 
            ;find "michael" 
            RetTxt\i = RetTxt\i + "K" 
            RetTxt\II = RetTxt\II + "X" 
            current + 2 
          ElseIf current = 7 
            ;greek roots e.g. "chemistry", "chorus" 
            If (FindString("HARAC HARIS ",Mid(txt$,current+1,5),1) Or FindString("HOR HYM HIA HEM",Mid(txt$,current+1,3),1)) And Mid(txt$,7,5) <> "CHORE" 
              RetTxt\i = RetTxt\i + "K" 
              RetTxt\II = RetTxt\II + "K" 
            Else 
              RetTxt\i = RetTxt\i + "X" 
              RetTxt\II = RetTxt\II + "X" 
            EndIf 
            current + 2 
            ;germanic, greek, or otherwise "ch" for "kh" sound 
            ;"architect but not "arch", "orchestra", "orchid" 
            ;e.g., "wachtler", "wechsler", but not "tichner" 
          ElseIf ((FindString("VAN  VON ",Mid(txt$,7,4),1) Or Mid(txt$,7,3)="SCH") Or FindString("ORCHES ARCHIT, ORCHID",Mid(txt$,current-2,6),1) Or FindString("TS",strnxt2,1) Or ((FindString("AOUE",strprv1,1) Or current=7) And FindString("LRNMBHFVW ",strnxt2,1))) 
            RetTxt\i = RetTxt\i + "K" 
            RetTxt\II = RetTxt\II + "K" 
            current + 2 
          ElseIf current > 7 
            If Mid(txt$,7,2)="MC" ;e.g., "McHugh" 
              RetTxt\i = RetTxt\i + "K" 
              RetTxt\II = RetTxt\II + "K" 
            Else 
              RetTxt\i = RetTxt\i + "X" 
              RetTxt\II = RetTxt\II + "K" 
            EndIf 
            current + 2 
          EndIf 
          ;End "CH" 
        ElseIf Mid(txt$,current,2)="CZ" And Mid(txt$,current-2,4)<>"WICZ" ;e.g, "czerny" 
          RetTxt\i = RetTxt\i + "S" 
          RetTxt\II = RetTxt\II + "X" 
          current + 2 
        ElseIf Mid(txt$,current+1,3)="CIA" ;e.g., "focaccia" 
          RetTxt\i = RetTxt\i + "X" 
          RetTxt\II = RetTxt\II + "X" 
          current + 3 
          ;double "C", but not if e.g. "McClellan" 
        ElseIf Mid(txt$,current,2)="CC" And Mid(txt$,7,3)<>"MCC" 
          ;"bellocchio" but not "bacchus" 
          If FindString("IEH",strnxt2,1) And Mid(txt$,current+2,2)<>"HU" 
            ;"accident", "accede" "succeed" 
            If (current = 8 And strprv1="A") Or FindString("UCCEE UCCES",Mid(txt$,current-1,5),1) 
              RetTxt\i = RetTxt\i + "KS" 
              RetTxt\II = RetTxt\II + "KS" 
            Else  ;"bacci", "bertucci", other italian 
              RetTxt\i = RetTxt\i + "X" 
              RetTxt\II = RetTxt\II + "X" 
            EndIf 
            current + 3 
          Else ;Pierce"s rule 
            RetTxt\i = RetTxt\i + "K" 
            RetTxt\II = RetTxt\II + "K" 
            current + 2 
          EndIf 
        ElseIf FindString("CK CG CQ",Mid(txt$,current,2),1) 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "K" 
          current + 2 
        ElseIf FindString("CI CE CY",Mid(txt$,current,2),1) 
          ;italian vs. english 
          If FindString("CIO CIE CIA,",Mid(txt$,current,3),1) 
            RetTxt\i = RetTxt\i + "S" 
            RetTxt\II = RetTxt\II + "X" 
          Else 
            RetTxt\i = RetTxt\i + "S" 
            RetTxt\II = RetTxt\II + "S" 
          EndIf 
          current + 2 
        Else 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "K" 
          ;name sent in "mac caffrey", "mac gregor" 
          If FindString(" C  Q  G",Mid(txt$,current+1,2),1) 
            current + 3 
          ElseIf FindString("CKQ",strnxt1,1) And FindString("CE CI",strnxt1+strnxt2,1)=0 
            current + 2 
          Else 
            current + 1 
          EndIf 
        EndIf 
        
      Case "D";-D 
        If Mid(txt$,current,2)="DG" 
          If FindString("IEY",strnxt2,1) 
            RetTxt\i = RetTxt\i + "J" 
            RetTxt\II = RetTxt\II + "J" 
            current + 3 
          Else 
            RetTxt\i = RetTxt\i + "TK" 
            RetTxt\II = RetTxt\II + "TK" 
            current + 2 
          EndIf 
        ElseIf FindString("DT DD",Mid(txt$,current,2),1) 
          RetTxt\i = RetTxt\i + "T" 
          RetTxt\II = RetTxt\II + "T" 
          current + 2 
        Else 
          RetTxt\i = RetTxt\i + "T" 
          RetTxt\II = RetTxt\II + "T" 
          current + 1 
        EndIf 
        
      Case "F";-F 
        RetTxt\i = RetTxt\i + strcur 
        RetTxt\II = RetTxt\II + strcur 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "G";-G 
        If strnxt1 = "H" 
          If current > 7 And FindString(#vowels,strprv1,1) = 0 
            RetTxt\i = RetTxt\i + "K" 
            RetTxt\II = RetTxt\II + "K" 
            current + 2 
          ElseIf current = 7 ;"ghislane", ghiradelli 
            If strnxt2 = "I" 
              RetTxt\i = RetTxt\i + "J" 
              RetTxt\II = RetTxt\II + "J" 
            Else 
              RetTxt\i = RetTxt\i + "K" 
              RetTxt\II = RetTxt\II + "K" 
            EndIf 
            current + 2 
            ;Parker"s rule (with some further refinements) - e.g., "hugh" 
            ;e.g., "bough" 
          ElseIf (((current > 8) And FindString("BHD",strprv2,1)) Or (current > 2 And FindString("BHD",Mid(txt$,current-3,1),1)) Or (current > 3 And FindString("BH",Mid(txt$,current-4,1),1))) 
            current + 2 
          Else ;e.g., "laugh", "McLaughlin", "cough", "gough", "rough", "tough" 
            If current > 9 And strprv1 = "U" And FindString("CGLRT",Mid(txt$,current-3,1),1) 
              RetTxt\i = RetTxt\i + "F" 
              RetTxt\II = RetTxt\II + "F" 
            Else 
              If current > 7 And strprv1 <> "I" 
                RetTxt\i = RetTxt\i + "K" 
                RetTxt\II = RetTxt\II + "K" 
              EndIf 
            EndIf 
            current + 2 
          EndIf 
        ElseIf strnxt1 = "N" 
          If current = 8 And FindString(#vowels,Mid(txt$,7,1),1) And slavogermanic = #False 
            RetTxt\i = RetTxt\i + "KL" 
            RetTxt\II = RetTxt\II + "L" 
            current + 2 
          Else  ;not e.g. "cagney" 
            If Mid(txt$,current + 2,2) <> "EY" And strnxt1 <> "Y" And slavogermanic = #False 
              RetTxt\i = RetTxt\i + "N" 
              RetTxt\II = RetTxt\II + "KN" 
            Else 
              RetTxt\i = RetTxt\i + "KN" 
              RetTxt\II = RetTxt\II + "KN" 
            EndIf 
            current + 2 
          EndIf 
        ElseIf strnxt1+strnxt2="LI" And slavogermanic = #False ;"tagliaro" 
          RetTxt\i = RetTxt\i + "KL" 
          RetTxt\II = RetTxt\II + "L" 
          current + 2 
          ; -ges-,-gep-,-gel-, -gie- at beginning 
        ElseIf current = 7 And (strnxt1 = "Y" Or FindString("ES EP EB EL EY IB IL IN IE EI ER",Mid(txt$,current+1,2),1)) 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "J" 
          current + 2 
          ; -ger-,  -gy- 
        ElseIf (strnxt1+strnxt2="ER" Or strnxt1="Y") And FindString("DANGER RANGER MANGER",Mid(txt$,7,6),1)=0 And FindString("EI",strprv1,1)=0 And FindString("RGY OGY",Mid(txt$,current-1,3),1)=0 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "J" 
          current + 2 
          ; italian e.g, "biaggi" 
        ElseIf FindString("EIY",strnxt1,1) Or FindString("AGGI OGGI",Mid(txt$,current-1,4),1) 
          ;obvious germanic 
          If (FindString("VAN  VON ",Mid(txt$,7,4),1) Or Mid(txt$,7,3)="SCH" ) Or strnxt1+strnxt2="ET" 
            RetTxt\i = RetTxt\i + "K" 
            RetTxt\II = RetTxt\II + "K" 
          ElseIf Mid(txt$,current + 1,4)="IER " ;always soft if french ending 
            RetTxt\i = RetTxt\i + "J" 
            RetTxt\II = RetTxt\II + "J" 
          Else 
            RetTxt\i = RetTxt\i + "J" 
            RetTxt\II = RetTxt\II + "K" 
          EndIf 
          current + 2 
        ElseIf strnxt1="G" 
          current + 2 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "K" 
        Else 
          current + 1 
          RetTxt\i = RetTxt\i + "K" 
          RetTxt\II = RetTxt\II + "K" 
        EndIf 
        
      Case "H";-H 
        If (current = 7 Or FindString(#vowels, strprv1, 1)) And FindString(#vowels, strnxt1, 1) 
          current + 2 
          RetTxt\i = RetTxt\i + "H" 
          RetTxt\II = RetTxt\II + "H" 
        Else 
          current + 1 
        EndIf 
        
      Case "J";-J 
        ;obvious spanish, "jose", "san jacinto" 
        If Mid(txt$,current,4)="JOSE" Or Mid(txt$,7,4)="SAN " 
          If (current = 7 And Mid(txt$,current+4,1)=" ") Or Mid(txt$,7,4)="SAN " 
            RetTxt\i = RetTxt\i + "H" 
            RetTxt\II = RetTxt\II + "H" 
          Else 
            RetTxt\i = RetTxt\i + "J" 
            RetTxt\II = RetTxt\II + "H" 
          EndIf 
          current + 1 
        ElseIf current = 7  ;Yankelovich/Jankelowicz 
          RetTxt\i = RetTxt\i + "J" 
          RetTxt\II = RetTxt\II + "A" 
          current + 1 
          ;spanish pron. of e.g. "bajador" 
        ElseIf FindString(#vowels,strprv1,1) And slavogermanic = #False And (strnxt1="A" Or strnxt1="O") 
          RetTxt\i = RetTxt\i + "J" 
          RetTxt\II = RetTxt\II + "H" 
          current + 1 
        ElseIf current = last 
          RetTxt\i = RetTxt\i + "J" 
          RetTxt\II = RetTxt\II + " " 
          current + 1 
        ElseIf FindString("LTKSNMBZ",strnxt1,1)=0 And FindString("SKL",strprv1,1)=0 
          RetTxt\i = RetTxt\i + "J" 
          RetTxt\II = RetTxt\II + "J" 
          current + 1 
        ElseIf strnxt1 = "J" 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "K";-K 
        RetTxt\i = RetTxt\i + strcur 
        RetTxt\II = RetTxt\II + strcur 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "L";-L 
        If strnxt1 = "L" 
          ;spanish e.g. "cabrillo", "gallegos" 
          If (current = (Length-2) And FindString("ILLO ILLA ALLE,",Mid(txt$,current-1,4),1)) Or ((FindString("AS OS,",Mid(txt$,last-1,2),1) Or FindString("A O",Mid(txt$,last,1),1)) And Mid(txt$,current-1,4)="ALLE") 
            RetTxt\i = RetTxt\i + "L" ;alternate is silent 
          Else 
            RetTxt\i = RetTxt\i + "L" 
            RetTxt\II = RetTxt\II + "L" 
          EndIf 
          current + 2 
        Else 
          current + 1 
          RetTxt\i = RetTxt\i + "L" 
          RetTxt\II = RetTxt\II + "L" 
        EndIf 
        
      Case "M";-M 
        RetTxt\i = RetTxt\i + strcur 
        RetTxt\II = RetTxt\II + strcur 
        ;"dumb", "thumb" 
        If (Mid(txt$,current-1,3)="UMB" And (current+1=last Or Mid(txt$,current+2,2)="ER")) Or strnxt1 = "M" 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "N";-N 
        RetTxt\i = RetTxt\i + strcur 
        RetTxt\II = RetTxt\II + strcur 
        If strnxt1=strcur Or strnxt1="Ñ" 
          current + 2 
        Else 
          current + 1 
        EndIf 
      Case "Ñ";-Ñ 
        RetTxt\i = RetTxt\i + "N" 
        RetTxt\II = RetTxt\II + "N" 
        If strnxt1="N" Or strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "P";-P 
        If strnxt1 = "H" 
          current = current + 2 
          RetTxt\i = RetTxt\i + "F" 
          RetTxt\II = RetTxt\II + "F" 
        ElseIf strnxt1="P" Or strnxt1="B" 
          ; also account FOR "campbell" AND "raspberry" 
          current + 2 
          RetTxt\i = RetTxt\i + strcur 
          RetTxt\II = RetTxt\II + strcur 
        Else 
          current + 1 
          RetTxt\i = RetTxt\i + strcur 
          RetTxt\II = RetTxt\II + strcur 
        EndIf 
        
      Case "Q";-Q 
        RetTxt\i = RetTxt\i + "K" 
        RetTxt\II = RetTxt\II + "K" 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "R";-R 
        ;french e.g. "rogier", but exclude "hochmeier" 
        If current = last And slavogermanic = 0 And Mid(txt$,current-2, 2)="IE" And FindString("ME MA",Mid(txt$,current-4,2),1)=0 
          RetTxt\II = RetTxt\II + strcur 
        Else 
          RetTxt\i = RetTxt\i + strcur 
          RetTxt\II = RetTxt\II + strcur 
        EndIf 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "S";-S 
        ;special cases "island", "isle", "carlisle", "carlysle" 
        If FindString("ISL YSL",Mid(txt$, current-1, 3),1) 
          current + 1 
        ElseIf Mid(txt$, current, 2) = "SH" 
          ;germanic 
          If FindString("HEIM HOEK HOLM Holz",Mid(txt$, current + 1,4),1) 
            RetTxt\i = RetTxt\i + strcur 
            RetTxt\II = RetTxt\II + strcur 
          Else 
            RetTxt\i = RetTxt\i + "X" 
            RetTxt\II = RetTxt\II + "X" 
          EndIf 
          current + 2 
        Else 
          ; italian & armenian 
          If FindString("SIO SIA",Mid(txt$, current,3),1) Or Mid(txt$, current,4)="SIAN" 
            If slavogermanic = 0 
              RetTxt\i = RetTxt\i + "S" 
              RetTxt\II = RetTxt\II + "X" 
            Else 
              RetTxt\i = RetTxt\i + "S" 
              RetTxt\II = RetTxt\II + "S" 
            EndIf 
            current + 3 
          Else 
            ; german & anglicisations, e.g. "smith" match "schmidt", "snider" match "schneider" 
            ; also, -sz- in slavic language altho in hungarian it is pronounced "s" 
            If (current = 7 And FindString("M N L W", strnxt1,1)) Or strnxt1 ="Z" 
              RetTxt\i = RetTxt\i + "S" 
              RetTxt\II = RetTxt\II + "X" 
              If strnxt1 ="Z" 
                current + 2 
              Else 
                current + 1 
              EndIf 
            Else 
              If Mid(txt$, current, 2) = "SC" 
                ; Schlesinger"s RULE 
                If strnxt2 = "H" 
                  If FindString("OO ER EN UY ED EM", Mid(txt$, current+3, 2),1); dutch origin, e.g. "school", "schooner" 
                    If FindString("ER EN", Mid(txt$, current+3, 2),1);"schermerhorn", "schenker" 
                      RetTxt\i = RetTxt\i + "X" 
                      RetTxt\II = RetTxt\II + "SK" 
                    Else 
                      RetTxt\i = RetTxt\i + "SK" 
                      RetTxt\II = RetTxt\II + "SK" 
                    EndIf 
                    current + 3 
                  Else 
                    If current = 7 And FindString(#vowels, Mid(txt$, 10, 1),1) = 0 And Mid(txt$, current+3, 1) <> "W" 
                      RetTxt\i = RetTxt\i + "X" 
                      RetTxt\II = RetTxt\II + "S" 
                    Else 
                      RetTxt\i = RetTxt\i + "X" 
                      RetTxt\II = RetTxt\II + "X" 
                    EndIf 
                    current + 3 
                  EndIf 
                Else 
                  If FindString("I E Y", strnxt2,1) 
                    RetTxt\i = RetTxt\i + "S" 
                    RetTxt\II = RetTxt\II + "S" 
                  Else 
                    RetTxt\i = RetTxt\i + "SK" 
                    RetTxt\II = RetTxt\II + "SK" 
                  EndIf 
                  current + 3 
                EndIf 
              Else 
                If current = 7 And Mid(txt$, current, 5) = "SUGAR"; special CASE "sugar-" 
                  RetTxt\i = RetTxt\i + "X" 
                  RetTxt\II = RetTxt\II + "S" 
                  current + 1 
                Else 
                  ; french e.g. "resnais", "artois" 
                  If current = last And FindString("AI OI", Mid(txt$, current-2, 2),1) 
                    RetTxt\II = RetTxt\II + "S" 
                  Else 
                    RetTxt\i = RetTxt\i + "S" 
                    RetTxt\II = RetTxt\II + "S" 
                  EndIf 
                  If FindString("S Z", strnxt1, 1) 
                    current + 2 
                  Else 
                    current + 1 
                  EndIf 
                EndIf 
              EndIf 
            EndIf 
          EndIf 
        EndIf 
        
      Case "T";-T 
        If Mid(txt$, current, 4) = "TION" 
          RetTxt\i = RetTxt\i + "X" 
          RetTxt\II = RetTxt\II + "X" 
          current + 3 
        ElseIf FindString("TIA TCH", Mid(txt$, current, 3),1) 
          RetTxt\i = RetTxt\i + "X" 
          RetTxt\II = RetTxt\II + "X" 
          current + 3 
        ElseIf Mid(txt$, current, 2) = "TH" Or Mid(txt$, current, 3) = "TTH" 
          ; special CASE "thomas", "thames" or germanic 
          If FindString("OM AM", Mid(txt$, current+2, 2),1) Or FindString("VAN  VON", Mid(txt$, 7, 4),1) Or Mid(txt$, 7, 4) = "SCH" 
            RetTxt\i = RetTxt\i + "T" 
            RetTxt\II = RetTxt\II + "T" 
          Else 
            RetTxt\i = RetTxt\i + "O" 
            RetTxt\II = RetTxt\II + "T" 
          EndIf 
          current + 2 
        ElseIf FindString("T D", strnxt1,1) 
          RetTxt\i = RetTxt\i + "T" 
          RetTxt\II = RetTxt\II + "T" 
          current + 2 
        Else 
          RetTxt\i = RetTxt\i + "T" 
          RetTxt\II = RetTxt\II + "T" 
          current + 1 
        EndIf 
        
      Case "V";-V 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
          RetTxt\i = RetTxt\i + "F" 
          RetTxt\II = RetTxt\II + "F" 
        EndIf 
        
      Case "W";-W 
        ; can also be IN middle OF word 
        If Mid(txt$, current, 2) = "WR" 
          RetTxt\i = RetTxt\i + "R" 
          RetTxt\II = RetTxt\II + "R" 
          current + 2 
        Else 
          If current = 7 And (FindString(#vowels, strnxt1, 1) Or Mid(txt$, current, 2) = "WH") 
            If FindString(#vowels, strnxt1, 1); Wasserman should match Vasserman 
              RetTxt\i = RetTxt\i + "A" 
              RetTxt\II = RetTxt\II + "F" 
              current + 1 
            Else 
              RetTxt\i = RetTxt\i + "A"; need Uomo TO match Womo 
              RetTxt\II = RetTxt\II + "A" 
              current + 1 
            EndIf 
          Else 
            ; Arnow should match Arnoff 
            If (current = last And FindString(#vowels, strprv1, 1)) Or FindString("EWSKI EWSKY OWSKI OWSKY", Mid(txt$, current-1, 5),1) Or Mid(txt$, 7, 3) = "SCH" 
              RetTxt\II = RetTxt\II + "F" 
              current + 1 
            Else 
              ; polish e.g. "filipowicz" 
              If FindString("WICZ WITZ", Mid(txt$, current, 4),1) 
                RetTxt\i = RetTxt\i + "TS" 
                RetTxt\II = RetTxt\II + "FX" 
                current + 4 
              Else 
                current + 1  ;else skip it 
              EndIf 
            EndIf 
          EndIf 
        EndIf 
        
      Case "X";-X 
        ; french e.g. breaux 
        If (current <> last And (FindString("WIAU EAU", Mid(txt$, current-3, 3),1)=0 Or FindString("AU OU", Mid(txt$, current-2, 3),1)=0)) 
          RetTxt\i = RetTxt\i + "KS" 
          RetTxt\II = RetTxt\II + "KS" 
        EndIf 
        If FindString("C X", strnxt1,1) 
          current + 2 
        Else 
          current + 1 
        EndIf 
        
      Case "Z";-Z 
        If strnxt1 = strcur 
          RetTxt\i = RetTxt\i + "S" 
          RetTxt\II = RetTxt\II + "S" 
          current + 2 
        Else 
          If strnxt1 = "H"; chinese pinyin e.g. "zhao" 
            RetTxt\i = RetTxt\i + "J" 
            RetTxt\II = RetTxt\II + "J" 
            current + 2 
          Else 
            If FindString("ZO ZI ZA", Mid(txt$, current+1, 2),1) Or (slavogermanic = 1 And (current > 7 And strprv1 <> "T")) 
              RetTxt\i = RetTxt\i + "S" 
              RetTxt\II = RetTxt\II + "TS" 
            Else 
              RetTxt\i = RetTxt\i + "S" 
              RetTxt\II = RetTxt\II + "S" 
            EndIf 
          EndIf 
          current + 1 
        EndIf 
        
      Default 
        If strnxt1=strcur 
          current + 2 
        Else 
          current + 1 
        EndIf 
    EndSelect 
  Wend 
  RetTxt\i = Left(RetTxt\i,4) 
  RetTxt\II= Left(RetTxt\II,4) 
  RetTxt\n = current - 6 
  ProcedureReturn @RetTxt 
EndProcedure 

Procedure.l MemCharPos(*Source, strChar.s, StartPos) 
  ; ASM-code to find one byte (character) in memory 
  ; end of memoryblock has to be null 
  
  Result.l 
  
  MOV Ebx,strChar ; Ebx = Pointer to Char 
  MOV Ecx,*Source ; Ecx = Pointer to akt. Char in source 
  DEC StartPos    ; StartPos - 1 
  ADD Ecx,StartPos; set source-pointer to startposition 
  
  ! rpt_Src:      ; startpoint for loop scanning through the source 
  MOV al,[Ecx] 
  INC Ecx         ; Ecx + 1 
  CMP al,0        ; if null (end of source-string) 
  JZ endProc      ; -> end Procedure, Result=0 
  
  CMP byte[Ebx],al; if found Char 
  JE gotit        ; -> got it 
  JMP rpt_Src     ; else go on with next (endpoint for loop scanning through the source) 
  
  ! gotit:        ; Result = Ecx - Source, to get the place in the source-string not the memory-address 
  SUB Ecx,*Source ; position of found character minus startpoint of memoryblock 
  MOV Result,Ecx  ; copy result of subtraction to Result 
  
  ! endProc: 
  ProcedureReturn Result 
EndProcedure 

;-wrapping procedures for the DoubleMetaphone proc 
Procedure.b PhoneticMatch(word1.s, word2.s) 
  ; to compare word by word 
  
  *str2Str.DblMet 
  strErgebnis.s 
  
  *str2Str = getTPLMTFN(word1,1,Len(word1)) 
  strErgebnis = *str2Str\i + " " + *str2Str\II 
  *str2Str = getTPLMTFN(word2,1,Len(word2)) 
  If FindString(strErgebnis, *str2Str\i, 1) Or FindString(strErgebnis, *str2Str\II, 1) 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure PhoneticSearch(*scannedtxt, word2find.s) 
  ; does split a text in memory to single words 
  ; and comparing each phonetic charcter of this 
  ; to the corresponding character in the phonetic 
  ; code of the searched word. 
  ; Words are skipped after the first character that 
  ; does not match. For longer words this is faster 
  ; than calculating the whole phonetic code of each  
  ; word, cause most words do not match at the first 
  ; two characters. 

  *str2Str.DblMet 
  PhonStr.DblMet 
  strResult.s 
  Shared Word.WordInTxt 
  match.b = #False 
  
  ; get the phonetic code of word2find 
  *str2Str = getTPLMTFN(word2find, 1, Len(word2find)) 
  If Len(*str2Str\i) < Len(*str2Str\II) 
    PhonStr\i = *str2Str\II 
    PhonStr\II = *str2Str\i 
  Else 
    PhonStr\i = *str2Str\i 
    PhonStr\II = *str2Str\II 
  EndIf 

  strResult = PhonStr\i + " " + PhonStr\II 
  LenErgebnis = Len(PhonStr\i) 
  
  WordStart = 1 
  WordEnd = MemCharPos(*scannedtxt, " ", WordStart) 
  While WordEnd And match = #False ; loop as long a space (end of word)  
                                   ; or word2search is found 
    WordLen=WordEnd-WordStart 
    Word\strTxt = PeekS(*scannedtxt+WordStart-1, WordLen) 
    PosInWord = 1 
    PosInPhonWord = 1 
    Word1$="" 
    Word2$="" 
    Repeat ; if one character does not match, leave this loop at once. 
      *str2Str = getTPLMTFN(Word\strTxt, PosInWord, 1); get the phonetic code of 1 char 
      Word1$ + *str2Str\i 
      Word2$ + *str2Str\II 
      If Len(*str2Str\i) > Len(*str2Str\II) 
        PosInPhonWord + Len(*str2Str\i) 
      Else 
        PosInPhonWord + Len(*str2Str\II) 
      EndIf 
      
      If *str2Str\i <> "" ; phonetic code is as before 
        strResult=Left(PhonStr\i, PosInPhonWord-1) + " " + Left(PhonStr\II, PosInPhonWord-1) 
        If FindString(strResult, Word1$, 1) Or FindString(strResult, Word2$, 1) 
          match = #True 
          If PosInWord = 1: Word\Pos=WordStart: EndIf; remember the beginning of word 
        Else 
          match = #False 
          Word\Pos=0 
        EndIf 
      EndIf 
      PosInWord = *str2Str\n 
    Until match=#False Or PosInPhonWord > LenErgebnis Or PosInWord > WordLen 
    ; set match back to #False if the phonetic code from text-word is shorter than from word to find 
    If PosInWord > WordLen And PosInPhonWord < LenErgebnis: match=#False: EndIf 
    
    ; set position of next word 
    WordStart = WordEnd + 1 
    WordEnd = MemCharPos(*scannedtxt, " ", WordStart) 
  Wend 
  
  ProcedureReturn @Word 
  
EndProcedure 


;-Beispiele 

;{-Beispiel phonetischer Code eines Wortes 
*str2Str.DblMet 
strResult.s 

strTxt$="kurz" 

*str2Str = getTPLMTFN(strTxt$, 1, Len(strTxt$)) 
Debug "der phonetische Code für " + strTxt$ + " ist " + *str2Str\i + " oder auch " + *str2Str\II 
;} 

;{-Beispiel Textsuche 
*WordStruct.WordInTxt 
scannedTxt.s = "das ist ein ziemlich kurtzer Text, mit nur 77 Zeichen, der zu durchsuchen ist" 
               ;123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234567 

Debug "zu durchsuchender Text: " 
Debug "'" + scannedTxt + "'" 
*WordStruct = PhoneticSearch(@scannedTxt, strTxt$) 
Debug "'" + strTxt$ + "' gefunden an Position " + Str(*WordStruct\Pos) + " als '" + *WordStruct\strTxt + "'" 

strTxt$="ziehmlich" 
*WordStruct = PhoneticSearch(@scannedTxt, strTxt$) 
If *WordStruct\Pos 
  Debug "'" + strTxt$ + "' gefunden an Position " + Str(*WordStruct\Pos) + " als '" + *WordStruct\strTxt + "'" 
Else 
  Debug strTxt$+" nicht gefunden" 
EndIf

;-a search examples in english 
;text from http://www.mrcranky.com/movies/spiceworld/191/11.html  :-)) 
scannedTxt.s = "I LUV THE SPICE GRLS... Tehy RoK!!! YOU SUCK!!!! YOU GOT NO TALINT AND Thay cin do it way better then you can. Your JUST JELOUS... becuz there the BESTEST PEOPLE IN THE WHOLE WIDE WORLD" 

Debug "text to be scanned: " 
Debug "'" + scannedTxt + "'" 

strTxt$="love" 
*WordStruct = PhoneticSearch(@scannedTxt, strTxt$) 
Debug "'" + strTxt$ + "' found at position " + Str(*WordStruct\Pos) + " as '" + *WordStruct\strTxt + "'" 

strTxt$="because" 
*WordStruct = PhoneticSearch(@scannedTxt, strTxt$) 
Debug "'" + strTxt$ + "' found at position " + Str(*WordStruct\Pos) + " as '" + *WordStruct\strTxt + "'" 

strTxt$="they" 
*WordStruct = PhoneticSearch(@scannedTxt, strTxt$) 
Debug "'" + strTxt$ + "' found at position " + Str(*WordStruct\Pos) + " as '" + *WordStruct\strTxt + "'" 
Debug ":-(" 
;} 


;{-Beispiel Textvergleich 
txt1.s = "abbrechen" 
txt2.s = "Abruch" 

If PhoneticMatch(txt1, txt2) 
  Debug "'" + txt1 + "'" + " entspricht phonetisch " + "'" + txt2 + "'" 
Else 
  Debug "'" + txt1 + "'" + " entspricht nicht " + "'" + txt2 + "'" 
EndIf 

;-example english/german spelling 
txt1.s = "english" 
txt2.s = "englisch" 

If PhoneticMatch(txt1, txt2) 
  Debug "'" + txt1 + "'" + " does match phonetic with " + "'" + txt2 + "'" 
Else 
  Debug "'" + txt1 + "'" + " does not match phonetic with " + "'" + txt2 + "'" 
EndIf 
;} 

End 
 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableAsm