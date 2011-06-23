; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2929&highlight=
; Author: sack (updated for PB 4.00 by Andre)
; Date: 26. November 2003
; OS: Windows
; Demo: Yes


; Note: the code need the "Code-128" font, get from http://www.will-software.com

; Einführung:
; Ich hatte das Problem, dass ich fuer unseren Betrieb Barcodes mit dem Klasse Code128
; (nachher auch EAN128) schreiben musste. Ich hatte lange gesucht, bis ich was gefunden
; hatte und bin bei WILL-Software haengen geblieben. 
; Den Font gibt es hier : http://www.will-software.com/
; Um den Font zu aktivieren bzw. ausdrucken zu koennen, habe ich eine Berechnng noetig,
; die Ihr hier nachfolgend seht. 
; 
; Aufgerufen wird der Font mit : rechn_128 (sNutzZiffer.s) 
; 
; Das Programm ist soweit optimiert, das auch EAN128 mit diesem Font ausgedruckt werden kann. 


; ###################################################################### 
; Als Global zu definierende Variablen: 

Global Start_Code_A.s 
Global Start_Code_B.s 
Global Start_Code_C.s 

Declare.l IsDigit(cToTest.s) 
Declare.l IsCharacter(cToTest.s) 
Declare.l Gerad_Anzahl(cBarCode.s) 
Declare.s Optim_128(sNutzZiffer.s) 
Declare.s rechn_128(sNutzZiffer.s) 
Declare.s PruefZ_128(sNutzZiffer.s) 
Declare.s array_128(lChar.l) 

; ##########################  Example  #################################
; Es wir ein Fensteraufgebaut in dem ein CODE128 Barcode dargestellt wird 
; mit dem Barcode-Inhalt "123456789" 

If OpenWindow(0, 100, 100, 600, 500, "CODE128 Barcode TEST") 

   LoadFont(0, "Code-128",50)   ;hier wird der TT Fontgeladen 
   StartDrawing(WindowOutput(0)) 
   DrawingFont(FontID(0))              
   DrawText(100, 100, rechn_128("123456789"))   ;via Drawtext die Umrechenfunktion aufrufen 
   StopDrawing() 
    
   Repeat 
      EventID = WaitWindowEvent() 
   Until EventID = #PB_Event_CloseWindow ; If the user has pressed on the close button 

EndIf 
End

; ########################  Procedures  ################################
; ---------------------------------------------------------------------- 
; Erstellt ein Array für die Zeichen des Code 128 
; ---------------------------------------------------------------------- 
Procedure.s array_128(lChar.l) 
; ---------------------------------------------------------------------- 
   Protected cChar.s 
    
   cChar = Chr(lChar+32) 

   Select lChar 
      Case 95 
         cChar = Chr(180)      
      Case 96 
         cChar = Chr(228) 
      Case 97 
         cChar = Chr(246) 
      Case 98 
;        cChar = Chr(200) 
         cChar = Chr(252) 
      Case 99 
         cChar = Chr(196) 
      Case 100 
;        cChar = Chr(214) 
         cChar = "Ö"  
      Case 101 
         cChar = Chr(220) 
      Case 102 
         cChar = Chr(181) 
      Case 103 
         cChar = "À"    ; Startzeichen Code A 
      Case 104 
         cChar = "Á"    ; Startzeichen Code B 
      Case 105 
         cChar = "Â"    ; Startzeichen Code C 

   EndSelect 
   ProcedureReturn cChar 
EndProcedure 


; ---------------------------------------------------------------------- 
; Optimiert die eingegebene Nutzziffer nach den Regeln der größten 
; Informationsdichte. Siehe hierzu Hansen/Lenk, Seite 117. 
; param1 = Nutzziffer 
; Hinweis: durch die Funktion 'ersetze(tmp_nutz, FNC1, "")' bleibt das 
; Steuerzeichen FNC1 bei der Komprimierung 'von Ziffernfolgen 
; unberücksichtigt, da dieses im Zeichensatz "C" vorkommen darf. 
; ---------------------------------------------------------------------- 
Procedure.s optim_128(sNutzZiffer.s) 
; ---------------------------------------------------------------------- 
   Protected cNoets.s 
   Protected Tmp_Nutz.s 
   Protected Zeichen.s 
   Protected Akt_Code.s 
   Protected Nutz_Rein.s 

   Protected FNC1.s 
   Protected Code_C.s                   ; Zum Umschalten im Zeichensatz B auf C 
   Protected Code_B.s                   ; Zum Umschalten im Zeichensatz C auf B 
    
   nutz_rein    = "" 
   tmp_nutz     = sNutzZiffer 
   zahl         = 0 
   akt_code     = "C"        ; Wir befinden uns gerade im Code B oder C ? (Global) 
   FNC1         = "µ" 
   Start_Code_A = "À" 
   Start_Code_B = "Á" 
   Start_Code_C = "Â" 

;  Code_C       = "Ä"        
;  Code_B       = "Ö"      

   ; Zuerst den richtigen Startcode wählen (B oder C): 
   cNoets = ReplaceString(Tmp_Nutz, FNC1, "") 
   If IsDigit(cNoets) And IsDigit(Mid(cNoets,2,1)) And IsDigit(Mid(cNoets,3,1)) And IsDigit(Mid(cNoets,4,1))       ;Falls erste 4 Stellen Ziffern, 
      While IsDigit(cNoets) And IsDigit(Mid(cNoets, 2,1)) ; Solange links mindestens 2 Ziffern vorhanden sind. 
         zahl      = Val(Left(cNoets, 2))                 ; Jeweils 2 Ziffern bilden eine zahl 
         If Zahl>95 
            Break 
         EndIf    
         cNoets = Right(cNoets, Len(cNoets)-2)            ; Die linken 2 Stellen werden entfernt. 
      Wend 
   EndIf    
   If Len(cNoets)>0 Or Len(Tmp_Nutz) = 0 
      nutz_rein = Start_Code_B 
      Akt_Code  = "B" 
   Else 
      nutz_rein = Start_Code_C                              ; fangen wir mit Code C an. 
      akt_code  = "C" 
   EndIf 

   While Len(tmp_nutz) > 0                                  ; Solange von tmp_nutz noch was übrig ist: 
      Select akt_code 
         Case "C" 
            While IsDigit(Tmp_Nutz) And IsDigit(Mid(tmp_nutz, 2,1)) ; Solange links mindestens 2 Ziffern vorhanden sind. 
               zahl      = Val(Left(tmp_nutz, 2))           ; Jeweils 2 Ziffern bilden eine zahl 
               zeichen   = array_128(zahl)                  ; Das entspr. Zeichen ist in der Array-Zeile, die der "zahl" entspr. 
               nutz_rein = nutz_rein + zeichen 
               tmp_nutz  = Right(tmp_nutz, Len(Tmp_Nutz)-2) ; Die linken 2 Stellen werden entfernt. 
            Wend 
            If Left(tmp_nutz, 1) = FNC1                     ; FNC1 kann in "C" vorkommen, 
               nutz_rein = nutz_rein + FNC1                 ; dann direkt rein damit 
               tmp_nutz  = Right(tmp_nutz, Len(Tmp_Nutz)- 1); und weiter. 
;           ElseIf Len(tmp_nutz) > 0 
;              nutz_rein = nutz_rein + Code_B               ; "Code_B" rein und 
;              akt_code  = "B"                              ; auf "B" umschalten! 
            EndIf 
         Case "B" 
            ; Erst Umschalten auf Code C, wenn wir eine gerade Anzahl von Ziffern haben: 
            cNoets = Left(ReplaceString(tmp_nutz, FNC1, ""), 4) 
;           If Val(Left(cNoets,2)) <= 95 And Val(Right(cNoets,2)) <= 95 And IsDigit(cNoets) And IsDigit(Mid(cNoets,2,1)) And IsDigit(Mid(cNoets,3,1)) And IsDigit(Mid(cNoets,4,1)) And gerad_anzahl(tmp_nutz) 
;              nutz_rein = nutz_rein + Code_C               ; Umschalten auf Code C 
;              akt_code  = "C" 
;           Else 
               nutz_rein = nutz_rein + Left(tmp_nutz, 1) 
               tmp_nutz  = Right(tmp_nutz, Len(Tmp_Nutz)-1) 
;           EndIf 
      EndSelect 
   Wend 

   ProcedureReturn nutz_rein                      
EndProcedure 

; ---------------------------------------------------------------------- 
; Ermittelt, ob im übergebenen Parameter-String links eine gerade Anzahl 
; Ziffern ist 
; ---------------------------------------------------------------------- 
Procedure Gerad_Anzahl(cBarCode.s) 
; ---------------------------------------------------------------------- 
   Protected Gerad_Anzahl.l 
   Protected TestString.s 
    
   teststring   = cBarCode 
   Gerad_anzahl = 0 

   While IsDigit(Mid(teststring, Gerad_Anzahl+1,1)) And Gerad_Anzahl<Len(TestString) 
      Gerad_Anzahl = Gerad_Anzahl+1 
   Wend 

   Gerad_Anzahl = (Gerad_Anzahl % 2) - 1 
   ; Oneven, dan 0 anders -1 

   ProcedureReturn Gerad_Anzahl 
EndProcedure 

; ---------------------------------------------------------------------- 
; Prüfziffernberechnung wie bei 128B 
; Das entspr. Startzeichen muß in param1 schon enthalten sein, 
; dies ist anders als bei den anderen Codes! 
; ---------------------------------------------------------------------- 
Procedure.s pruefz_128(param1.s) 
; ---------------------------------------------------------------------- 
   Protected Tmp_String.s 
   Protected sZeichen.s 
   Protected lZeichen.l 
   Protected lPruefZiffer.l 
   Protected RefZahl.l 
   Protected j.l 
   Protected i.l 
    
   Start_Code_A = "À" 
   Start_Code_B = "Á" 
   Start_Code_C = "Â" 

   lPruefziffer = 0 
   tmp_string   = param1 

   Select Left(tmp_string, 1)                     ; Linkes Zeichen = Startzeichen 
      Case Start_Code_B                           ; Start_Code_B = "Á" (ANSI 0193), Global definiert 
         lPruefziffer = 104 
      Case Start_Code_C                           ; Start_Code_C = "Â" (ANSI 0194), Global definiert 
         lPruefziffer = 105 
   EndSelect 
   tmp_string = Right(tmp_string, Len(Tmp_String)-1) ; Linkes Zeichen ( = Startzeichen) weg. 

   For i = 1 To Len(tmp_string)                   ; Jetzt kann der ganze Rest zerlegt werden. 
      sZeichen = Mid(tmp_string, i, 1) 
      lZeichen = Asc(sZeichen) 
      refzahl  = 0 
      If lZeichen < 128 
         If lZeichen > 32 
            RefZahl = lZeichen - 32 
         EndIf    
      Else    
         For j = 95 To 105                        ; Wir suchen die entspr. Array-Zeile. 
            If sZeichen = array_128(j)            ; Einige P.-Sprachen unterscheiden nicht zw. GROß und klein !!! 
               refzahl  = j                       ; Referenzzahl = akt. Array-Zeile. 
               j        = 105                     ; Jetzt kann die FOR-Schleife auch verlassen werden. 
            EndIf 
         Next j 
      EndIf    
      lPruefziffer = lPruefziffer + (refzahl * i) ; Die Prüfzahl wird mit der vorhergehenden 
                                                  ; aufsummiert, und zwar mit dem Faktor i ab der ersten Nutzziffer. 
   Next i 

   lPruefziffer = lPruefziffer  % 103             ; Modulo 103 ergibt die Referenzzahl der Prüfziffer. 
    
;  If lPruefZiffer < 99 
      sZeichen = array_128(lPruefziffer) 
;  Else 
;     sZeichen = Chr(lPruefZiffer+100) 
;     sZeichen = "" 
;  EndIf 
   ProcedureReturn sZeichen                       ; Die Prüfziffer befindet sich im Array in der Zeile 
                                                  ; der berechneten Referenzzahl. 
EndProcedure 

; ###################################################################### 
Procedure.s rechn_128 (sNutzZiffer.s) 
; ###################################################################### 
   ; Berechnung der gesamten Zeichenfolge für Code 128 
   ; param1 = Startzeichen + Nutzziffer, param2 = prüfziffer 
   Protected stopzeichen.s 
   Protected leerzeichen.s 
   Protected nutz_rein.s 
   Protected nutz.s 

   Start_Code_A = "À" 
   Start_Code_B = "Á" 
   Start_Code_C = "Â" 

;  stopzeichen = "È" 
;  StopZeichen = Chr(212) 
   StopZeichen = Chr(200) 
   leerzeichen = "ß" 
   Nutz        = Optim_128(sNutzZiffer) 
   Nutz        = Nutz + Pruefz_128(Nutz) 

   ; Space liegt auf "ß": 
   nutz_rein = ReplaceString(Nutz, " ", LeerZeichen) 

   ProcedureReturn nutz_rein + stopzeichen 
EndProcedure 

; ###################################################################### 
Procedure.l IsDigit(cToTest.s) 
; ###################################################################### 
   Protected lIsDigit.l 
    
   lIsDigit =0 
   If Asc(Left(cToTest,1)) >= Asc("0") And Asc(Left(cToTest, 1)) <=Asc("9") 
      lIsDigit =-1 
   EndIf 
   ProcedureReturn lIsDigit 
EndProcedure 
    
; ###################################################################### 
Procedure.l IsCharacter(cToTest.s) 
; ###################################################################### 
   Protected lIsCharacter.l 
    
   lIsCharacter = 0 
   If (Asc(Left(cToTest,1)) >= Asc("A") And Asc(Left(cToTest, 1)) <=Asc("Z")) Or (Asc(Left(cToTest,1)) >= Asc("a") And Asc(Left(cToTest, 1)) <= Asc("z") ) 
      lIsCharacter = -1 
   EndIf 
   ProcedureReturn lIsCharacter 
EndProcedure
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
