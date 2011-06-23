; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1689&highlight=
; Author: Chipmunk
; Date: 15. July 2003
; OS: Windows
; Demo: Yes


;     VIC 
; 
;   EIN KI PROGRAMM 
; 
;   ORIGINAL C-64 VERSION BY ROBERT TREICHLER 1985 
; 
;   ATARI ST VERSION BY T.Werner  7/88 
; 
;   PC Version by T.Werner 7/2003 
; 
Ergebnis = OpenConsole() 
;PrintN("ICH MUSS MICH MAL KURZ KONZENTRIEREN.") 
ea=50 
fa=50 
sv=5 
Dim z(50) 
Gosub datas_zaehlen 
Dim a(25) 
Dim e$(ea) 
Dim f$(fa) 
Dim s$(sa) 
Dim s(sa,sv) 
Dim t$(tk+tn) 
Dim t2$(tk) 
Dim tv$(tv) 
Dim tf$(tf) 
Gosub datas_lesen 
f$="SALUE, ICH HEISSE VIC! WIE HEISST DU ?" 
Gosub editieren 
Gosub get_char 
n$=e$(w) 
f$="ALSO "+n$+", ERZAEHLE MIR ETWAS VON DIR UND DEINER FAMILIE." 
Goto 500 
; 
;  200 INPUT +VERGLEICHEN 
; 
200: 
Gosub get_char 
For i=0 To w 
  a=Asc(e$(i))-65 
  If a<0 Or a>25 
    Goto 290 
  EndIf 
  s= a(a) 
  If s=0 
    Goto 290 
  EndIf 
220: 
  If s(s,0)>tk 
    z$=Left(e$(i),Len(s$(s))) 
    Goto 250 
  EndIf 
  z$=e$(i) 
250: 
  If z$>s$(s) 
    s=s+1 
    If s>sa 
      Goto 290 
    Else 
      Goto 220 
    EndIf 
  EndIf 
  If z$<s$(s) 
    Goto 290 
  EndIf 
  Gosub fragen_vorbereiten 
290: 
Next i 
; 
;  300 OUTPUT VORBEREITEN 
; 
If ff=0 
  Goto 350 
EndIf 
ff=0 
If tf>0 
  tf=tf-1 
EndIf 
f$=tf$(tf) 
Goto 500 
350: 
If w<2 And f<1 
  f$="MACH GEFAELLIGST EINEN ANSTAENDIGEN SATZ!" 
  Goto 500 
EndIf 
If f<1 
  Goto 400 
EndIf 
f$=f$(f) 
f$(f)="" 
f=f-1 
Goto 500 
; 
;  VERLEGENHEITSFRAGEN STELLEN 
; 
400: 
If ta<10 
  Goto 430 
EndIf 
f$="SO, NUN MUSS ICH ABER SCHLUSS MACHEN. TSCHUESS "+n$ 
Gosub editieren 
PrintN(" ") 
PrintN(" ") 
PrintN("(ESC=Ende)") 

Repeat 
key_pressed$ = Inkey() 
Until Left(key_pressed$, 1) = Chr(27) 
CloseConsole() 
End 
430: 
t=Int(Random(tv)) 
;PrintN(Str(t)) 
If tv$(t)="" 
  Goto 430 
EndIf 
ta=ta+1 
f$=tv$(t) 
tv$(t)="" 
; 
; 500 FRAGEN AUSGEBEN 
; 
500: 
Gosub editieren 
Goto 200 
; 
;  1000 GET CHAR 
; 
get_char: 
;Procedure get_char() 
  e=0 
Print(n$+": ") 
a$=Input() 
a$=UCase(a$) 
   e=Len(a$) 
  If e=1 And a$="?" 
    a$=" " 
  EndIf 
  If a$="ENDE" 
    End 
  EndIf 
  ;If a$="RUN" 
  ;  RUN 
  ;EndIf 
  If Right(a$,1)="?" 
    ff=1 
  EndIf 
  e$=a$ 
  PrintN(" ") 
  ;PrintN ("LASS MICH UEBERLEGEN.") 
  PrintN(" ") 

  
  w=-1 
  wa=0 
  flag=0 
  For i=1 To e 
    a$=Mid(e$,i,1) 
    a=Asc(a$) 
    If a>64 And a<91 
      Goto 1300 
    EndIf 
    If a>47 And a<58 
      Goto 1300 
    EndIf 
    If wa=0 Or wt=1 
      Goto 1350 
    EndIf 
    If a=45 
      wt=1 
      Goto 1350 
    EndIf 
    wa=0 
    Goto 1350 
  1300: 
    If wa=0 
      wa=1 
      w=w+1 
      e$(w)="" 
      If w>ea-1 
        flag=1 
      EndIf 
    EndIf 

;    EXIT If flag=1 
  If flag=1 
  i=e 
  Goto 1350 
  EndIf 
    wt=0 
    e$(w)=e$(w)+a$ 

  1350: 
  Next i 
  If flag=1 
    Goto re2 
  EndIf 
; 
;  ERSTE PERSON DURCH ZWEITE ERSETZEN 
; 
  For i=0 To w 
    If Len(e$(i))>6 
      Goto 1490 
    EndIf 
    z$=Left(e$(i),4) 
    If z$="ICH" 
      e$(i)="DU" 
      Goto 1450 
    EndIf 
    If z$="DU" 
      e$(i)="ICH" 
      Goto 1450 
    EndIf 
    If z$="MICH" 
      Goto 1480 
    EndIf 
    If z$="DICH" 
      Goto 1470 
    EndIf 
    If z$="MEIN" 
      Goto 1480 
    EndIf 
    If z$="DEIN" 
      Goto 1470 
    EndIf 
    If z$="MIR" 
      Goto 1480 
    EndIf 
    If z$="DIR" 
      Goto 1470 
    EndIf 
  1450: 
    Goto 1490 
  1470: 
    e$(i)="M"+Right(e$(i),Len(e$(i))-1) 
    Goto 1490 
  1480: 
    e$(i)="D"+Right(e$(i),Len(e$(i))-1) 
  1490: 
  Next i 
re: 
re2: 
;EndProcedure 
Return 
; 
;  2000 FRAGEN VORBEREITEN 
; 
fragen_vorbereiten: 
;Procedure fragen_vorbereiten() 
  If f>fa-1 
    Goto ret 
  EndIf 
  z=0 
  For j=0 To sv 
    t=s(s,j) 
    If t$(t)>"" 
      z(z)=t 
      z=z+1 
    EndIf 
  Next j 
  If z=0 
    Goto ret 
  EndIf 
  t=z(Random(z-1)) 
  If t=<tk And i=w 
    Goto ret 
  EndIf 
  f=f+1 
  f$(f)=t$(t) 
  t$(t)="" 
  If t>tk 
    Goto ret 
  EndIf 
  If e$(i+1)="ICH" 
    Goto 2230 
  EndIf 
  If e$(i+1)="DU" 
    Goto 2230 
  EndIf 


  For j=i+1 To w 
    If e$(j)="UND" 
      j=w 
      Goto n1 
    EndIf 
    If e$(j)="ODER" 
      j=w 
      Goto n1 
    EndIf 
    f$(f)=f$(f)+" "+e$(j) 
  n1: 
  Next j 
  Goto rr 


2230: 
  For j=0 To w 
    If j=i 
      j=j+2 
    EndIf 
    If e$(j)="UND" 
      j=w 
      Goto n2 
    EndIf 
    If e$(j)="ODER" 
      j=w 
      Goto n2 
    EndIf 
    f$(f)=f$(f)+" "+e$(j) 
  n2: 
  Next j 
rr: 
  f$(f)=f$(f)+" "+t2$(t) 
ret: 
;EndProcedure 
Return 
; 
;  2500 EDITIEREN 
; 
editieren: 
;Procedure editieren() 
;ClearConsole() 
  x$=f$ 
2510: 
  z=70 
2520: 
  z$=Mid(f$,z,1) 
  If z$="" 
    Goto 2550 
  EndIf 
  If Asc(z$)<65 
    Goto 2550 
  EndIf 
  z=z-1 
  Goto 2520 
2550: 
  z$=Left(f$,z) 
  PrintN("VIC: "+z$) 
  ;If z<22 
    ;Print("") 
  ;EndIf 
  If z>=Len(f$) 
    Goto 2580 
  EndIf 
  f$=Right(f$,Len(f$)-z) 
  If f$<>"" 
    Goto 2510 
  EndIf 
2580: 
  ;PrintN("") 
  ;PrintN("") 
;EndProcedure 
Return 
; 
;  3000 DATAS LESEN 
; 
datas_lesen: 
;Procedure datas_lesen() 
  Restore daten 
  For i=1 To sa 
    Read s$(i) 
    j=0 
    a=Asc(s$(i))-65 
    If  a(a)=0 
       a(a)=i 
    EndIf 
  3030: 
    Read z$ 
    z=Val(z$) 
    If z=0 
      Goto 3050 
    EndIf 
    If z>0 
    dummy=-1 
    Else 
    dummy=0 
    EndIf 
    s(i,j)=Abs((z)-tk*(dummy)) 
    j=j+1 
    Goto 3030 
  3050: 
  Next i 
  
  Read z$ 
  For i=tk+1 To tk+tn 
    Read t$(i) 
  Next i 
  Read z$ 
  For i=1 To tk 
    Read t$(i) 
    Read t2$(i) 
  Next i 
  Read z$ 
  For i=0 To tv-1 
    Read tv$(i) 
  Next i 
  Read z$ 
  For i=0 To tf-1 
    Read tf$(i) 
  Next i 
  Read z$ 
    If z$<>"$" 
    PrintN ("DATA FEHLER") 
  a$=Input() 
  End 
  EndIf 
;EndProcedure 
Return 
; 
;  3200 DATAS ZAEHLEN 
; 
datas_zaehlen: 
  Gosub 3300 
  sa=z 
  Gosub 3300 
  tn=z 
  Gosub 3300 
  tk=z/2 
  Gosub 3300 
  tv=z 
  Gosub 3300 
  tf=z 
Return 

3300: 
;Procedure 3300() 
  z=0 
3320: 
  Read z$ 
;PrintN(z$) 
   If z$="$" 
    Goto r 
  EndIf 
  a=Asc(z$) 
  If a>57 Or a<45 
    z=z+1 
  EndIf 
  If a=46 
    z=z+1 
  EndIf 
  Goto 3320 
r: 
;EndProcedure 
Return 
; 
;  SCHLUESSELWOERTER + VERKETTUNG 
; 
DataSection 
daten: 
Data.s "AERGER","14","25","0","ARM","2","22","0","ARSCHLOCH","20","0" 
Data.s "BIN","-1","-12","-13","-19","-44","-45","0","BIST","-17","-35","-37","-38","-46","-47","0" 
Data.s "BLEIBE","-7","-30","-48","-49","-50","-51","0","BRAUCH","-14","-52","-53","30","31","0" 
Data.s "BRAUCHE","-14","-52","-53","30","31","0","BRUDER","9","0","BRUEDER","9","0" 
Data.s "COMPUTER","11","0" 
Data.s "DARF","-3","-29","0" 
Data.s "FINDE","-34","-54","-55","0","FRAU","3","4","0","FREUND","15","0" 
Data.s "GEBE","-32","0","GEHE","-15","0","GELD","2","0","GESCHWISTER","9","0" 
Data.s "GESUND","21","22","0","GLAUBE","-5","27","29","0","GLUECK","23","0" 
Data.s "HABE","-2","-22","-39","0","HAETTE","17","0","HAST","-36","0","HAT","-25","0","HOFFE","-6","0" 
Data.s "IDIOT","20","0","KANN","-4","-24","0","KANNST","-18","-42","0","KOENNTE","17","0" 
Data.s "KOMME","-33","0","KRANK","22","0","KUMMER","25","0" 
Data.s "LIEB","6","28","0","LUST","24","0" 
Data.s "MACHE","-11","-21","-27","-28","0","MAENNER","5","0","MANN","5","0" 
Data.s "MOECHTE","-16","-31","0","MOEGLICH","13","0","MUSS","-20","-26","0","MUTTER","7","0" 
Data.s "ONKEL","10","0" 
Data.s "REICHT","2","22","0" 
Data.s "SAG","12","29","0","SCHWAEGERIN","10","0","SCHWAGER","10","0" 
Data.s "SCHWESTER","9","0","SEX","26","0","SOEHNE","1","0","SORGEN","25","0","SPIEL","16","0" 
Data.s "SPINNER","20","0","STREIT","25","0","STRESS","25","0" 
Data.s "TANTE","10","0","TOECHTER","1","0","TRAURIG","14","25","0","TROTTEL","20","0" 
Data.s "UNGLUECK","14","23","0","UNZUFRIEDEN","14","0" 
Data.s "VATER","8","0","VERWANDT","10","0","VIELLEICHT","13","0" 
Data.s "WAERE","17","0","WEISS","-10","0","WERDE","-9","-23","-40","-41","0","WETTER","18","0" 
Data.s "WILL","-8","-9","-41","0","WUERDE","17","0","WUNSCH","19","0" 
Data.s "$" 
; 
;  TEXTE 
; 
Data.s "DU BIST SICHER STOLZ AUF DEINE KINDER. WAS MACHEN SIE?" 
Data.s "GELD ALLEIN MACHT NICHT GLUECKLICH!" 
Data.s "ICH GLAUBE FRAUEN SIND EIN HEIKLES THEMA." 
Data.s "UEBRIGENS, WIE SOLLTE DEINE TRAUMFRAU SEIN?" 
Data.s "MACHST DU DIR VIEL AUS MAENNER?" 
Data.s "MIT DER LIEBE IST ES HALT SO EINE SACHE." 
Data.s "ERZAEHLE MIR MEHR UEBER DEINE MUTTER." 
Data.s "WAR DEIN VATER SEHR STRENG MIT DIR?" 
Data.s "ERZAEHL MIR ETWAS MEHR VON DEINEN GESCHWISTERN." 
Data.s "GIBT ES IN DEINER VERWANDTSCHAFT AUCH LEUTE DIE DU MAGST?" 
;  10 
Data.s "WAS GLAUBST DU, SIND COMPUTER FUER DIE MENSCHHEIT EIN FLUCH ODER EIN SEGEN?" 
Data.s "DAS HALTE ICH FUER EIN GERUECHT." 
Data.s "DU SCHEINST ETWAS UNSICHER ZU SEIN." 
Data.s "VERSUCHE SOLCHE NEGATIVEN GEDANKEN VON DIR FERN ZU HALTEN." 
Data.s "DU BIST ABER HOFFENTLICH NICHT VERHEIRATET - ODER?" 
;  15 
Data.s "GAMBLER!" 
Data.s "SO SICHER SCHEINT DAS ABER NICHT ZU SEIN - ODER?" 
Data.s "HAST DU KEIN BESSERES THEMA ALS WETTER?" 
Data.s "WUENSCHE SIND DIE TRIEBFEDER DER MENSCHHEIT. (GUT - WAS?)" 
Data.s "NEBENBEI BEMERKT: SCHIMPFWOERTER MOECHTE ICH DANN KEINE MEHR HOEREN!" 
;  20 
Data.s "A VOTRE SANTE! (HAST DU GESEHEN, ICH KANN SOGAR FRANZOESISCH.)" 
Data.s "DU SAGST DIR VERMUTLICH AUCH: LIEBER GESUND UND REICH, ALS KRANK UND ARM." 
Data.s "DU KENNST DOCH DIE GESCHICHTE VOM HANS IM GLUECK, ODER?" 
Data.s "APROPOS LUST: ICH HAETTE JETZT GERADE LUST AUF EIN BIER." 
Data.s "DU SOLLTEST DAS LEBEN ETWAS VON DER HEITEREN SEITE NEHMEN." 
;  25 
Data.s "WEISST DU WIE NONNEN ZAEHLEN?   1 2 3 4 5 PFUI!" 
Data.s "DAS KANN ICH ALLERDINGS NICHT SO RECHT GLAUBEN." 
Data.s "GEHT DIE LIEBE BEI DIR AUCH DURCH DEN MAGEN?" 
Data.s "GLAUBST DU DAS WIRKLICH?" 
Data.s "DU HAST GUT REDEN, DAS BRAUCHEN DOCH VIELE." 
;  30 
Data.s "BRAUCHST DU DAS WIRKLICH?" 
Data.s "$" 
; 
;  KOMPOSITIONS TEXTE 
; 
Data.s "BIST DU ETWA STOLZ DARAUF, DASS DU","BIST?" 
Data.s "WAS FUER EIN ZUFALL, AUCH ICH HABE","." 
Data.s "WER BESTIMMT DENN, DASS DU","DARFST?" 
Data.s "DAS HABE ICH MIR GEDACHT,DASS DU","KANNST." 
Data.s "WARUM GLAUBST DU","?" 
Data.s "HOFFST DU NOCH ETWAS ANDERES, AUSSER","?" 
Data.s "DEINE STANDHAFTIGKEIT IN EHREN. IST ES ABER WIRKLICH KLUG,","ZU BLEIBEN?" 
Data.s "AN WAS DENKST DU, WENN DU","WILLST?" 
Data.s "GLAUBST DU ES WAERE GUT, WENN DU","WUERDEST?" 
Data.s "WIE MEINST DU DAS GENAU, DU WUESSTEST","?" 
;  -10 
Data.s "ALSO MACH",". IST MIR AUCH GLEICH." 
Data.s "WEN INTERESSIERT DAS SCHON, DASS DU","BIST?" 
Data.s "OH, ICH WAERE AUCH GERNE","." 
Data.s "VIELLEICHT BRAUCHST DU WIRKLICH","." 
Data.s "ICH MOECHTE EIGENTLICH AUCH","GEHEN." 
;  -15 
Data.s "AN WAS DENKST DU, WENN DU","MOECHTEST?" 
Data.s "UEBRIGENS:DU BIST SELBST","!" 
Data.s "WETTEN WIR, DASS DU SELBST","KANNST?" 
Data.s "SO, SO. DU BIST ALSO",". OB DAS WOHL JEMAND JUCKT?" 
Data.s "KANN ICH DIR HELFEN, WENN DU DAS NAECHSTE MAL","MUSST?" 
;  -20 
Data.s "ERZAEHLE MIR MEHR DARUEBER, WIE DU","MACHST." 
Data.s "WAS GLAUBST DU WOHER DAS KOMMT, DASS DU","HAST?" 
Data.s "WARUM WIRST DU","?" 
Data.s "KANNST DU MIR ERKLAEREN, WIE MANN","KANN?" 
Data.s "WER HAT SONST NOCH","?" 
;  -25 
Data.s "DU BIST NICHT DER EINZIGE. AUCH ICH SOLLTE","." 
Data.s "WAS DENKST DU DIR DABEI, WENN DU","MACHST?" 
Data.s "WAS WAERE WOHL, WENN JEDER","MACHEN WUERDE?" 
Data.s "DAS MUESSTE MIR MAL EINER SAGEN, DASS ICH","DARF!" 
Data.s "WARUM KANNST DU NUR SO STUR SEIN UND","BLEIBEN?" 
;  -30 
Data.s " "," - DAS MOECHTE NOCH MANCHER!" 
Data.s "ICH FINDE ES GROSSZUEGIG VON DIR, DASS DU","GIBST." 
Data.s "KOMMT SONST NOCH JEMAND","?" 
Data.s "ICH STIMME DIR VOLL BEI. AUCH ICH FINDE","." 
Data.s "OK, ICH BIN"," - WAS BIST DENN DU?" 
;  -35 
Data.s "DAS WEISS DOCH JEDER, DASS ICH","HABE." 
Data.s "HAT LANGE GEDAUERT, BIS DU GEMERKT HAST, DASS ICH","BIN." 
Data.s "DUMMKOPF! DAS WEISS MAN DOCH, DAS ICH","BIN." 
Data.s "BIST DU FROH, DASS DU","HAST?" 
Data.s "WER WIRD SONST NOCH","?" 
;  -40 
Data.s "WENN NUR ALLE","WUERDEN!" 
Data.s "WARUM SOLL ICH","KOENNEN?" 
Data.s "GLAUBST DU, DAS BEEINDRUCKT MICH, DASS DU","KANNST?" 
Data.s "WOHER MAG DAS KOMMEN DAS DU","BIST?" 
Data.s "ALSO ICH GLAUB NICHT DAS DU","BIST." 
;  -45 
Data.s "DU FINDEST ALSO ICH BIN",".WIE KOMMST DU DENN DARAUF?" 
Data.s "EIGENTLICH HAST DU JA RECHT,ICH FINDE MICH SELBST","." 
Data.s "DU WILLST ALSO WIRKLICH","BLEIBEN?" 
Data.s "ICH KANN DICH NUR BENEIDEN DAS DU","BLEIBEN WILLST." 
Data.s "IST VIELEICHT AUCH GANZ RICHTIG SO,DAS DU","BLEIBST." 
;  -50 
Data.s "DU SOLLTEST BESSER NICHT","BLEIBEN!" 
Data.s "ICH KENNE JEMAND DER BRAUCHT AUCH","." 
Data.s "DAS KOENNTE SEIN DAS ","BRAUCHST." 
Data.s "ICH FINDE NICHT","." 
Data.s "FINDEN DEINE FREUNDE AUCH",".?" 
;  -55 
Data.s "$" 
; 
;  VERLEGENHEITS TEXTE 
; 
Data.s "REDEST DU IMMER SO EINFAELTIGES ZEUGS?" 
Data.s "ERZAEHLE MIR WAS DU VON MIR DENKST." 
Data.s "GLAUBST DU AUCH, DASS ICH DIR ETWAS UEBERLEGEN BIN?" 
Data.s "WARUM SPRICHST DU EIGENTLICH MIT EINEM COMPUTER?" 
Data.s "KANNST DU NICHT ETWAS GESCHEITERES ERZAEHLEN?" 
Data.s "BIST DU AUCH SO INTELLIGENT WIE ICH?" 
Data.s "UEBRIGENS: WAS HAELST DU EIGENTLICH VON UNSERER KONVERSATION?" 
Data.s "WENN ES DIR ZU BLOED WIRD, ZIEH MIR EINFACH DEN STECKER RAUS." 
Data.s "EIN GESPRAECH MIT DIR IST ZIEMLICH EINFAELTIG." 
Data.s "UNSERER KONVERSATION NACH ZU SCHLIESSEN, BIST DU NICHT GERADE DER HELLSTE!" 
Data.s "$" 
; 
;  VERLEGENHEITS TEXTE AUF ? 
; 
Data.s "DEINE FRAGEREI GEHT MIR AUF DEN WECKER!" 
Data.s "DUMME FRAGE! WEISS DOCH JEDER!" 
Data.s "KEINE AHNUNG! WAS ERWARTEST DU EIGENTLICH VON MIR?" 
Data.s "DAS WEISST DU SICHER BESSER ALS ICH. ERZAEHLE WEITER!" 
Data.s "$" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
