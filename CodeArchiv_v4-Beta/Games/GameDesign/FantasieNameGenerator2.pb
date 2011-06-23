; German forum: http://www.purebasic.fr/english/viewtopic.php?t=861&start=10
; Author: Kaeru Gaman (updated for PB 4.00 by Andre)
; Date: 14. November 2004
; OS: Windows
; Demo: Yes

; ich hab jetzt auch mal 'ne routine entworfen... 
; ... der erzeugt die WILDESTEN Fantasienamen... 
; ... keinerlei geschlechtlicher oder kultureller bezug...  
; ...mir ging es hier hauptsächlich um die FLAG-Idee 

; Flags: 
; 0 = kann von bel. 2. gefolgt werden 
; 1 = kann von bel. 2. ausser selbst gefolgt werden 
; 2 = kann von bel. 2. ausser Special gefolgt werden 
; 4 = ist special 
; 
; z.B.: 6 = ist Special und kann nur von sich selbst gefolgt werden 
; 
; Diese Flags sind ziemlich willkürlich gesetzt, kann man noch überarbeiten... 
; wer mehr als 3-Bit für flags benötigt, kann Grossbuchstaben als flags verwenden, 
; asc() statt val(), und die 64 einfach ignorieren 

Global Dim Char$(2) 
Global Dim ChFl$(2) 

Char$(0) = "aeiouy" 
ChFl$(0) = "002015" 
Char$(1) = "bcdfghjklmnpqrstvwxz" 
ChFl$(1) = "00000111000030000040" 

Procedure.s Create_Name(Lang.l) 

  n.l 
  Nummer.l 
  NumFlg.l 
  DopFlg.l = 0 
  Out$ = "" 
  Wrk$ = "" 
  Typ.l = Random(1) ; Vokal oder Konsonant als erstes... 
  
  For n = 1 To Lang 
  
    Repeat 
  
      Nummer = 1+Random(5+Typ*14) ; 6 Vokale, 20 Konsonanten.... 
      NumFlg = Val( Mid( ChFl$(Typ), Nummer, 1) ) 
      Weiter = 1 
      
      If (LastFlg & 1)= 1 And Nummer = LastNum : Weiter=0 : EndIf 
      ; Flag & 1 darf nicht selbst folgen 
      
      If (LastFlg & 2)= 2 And (NumFlg & 4)= 4 : Weiter=0 : EndIf 
      ; special darf nicht Flag & 2 folgen 
      
    Until Weiter = 1 
    
    Wrk$ + Mid(Char$(Typ), Nummer , 1) 
    
    If Random(3) = 0 And DopFl = 0 And n>1 And n<Lang-1 
    ; nächster Buchst. gleicher Typ ? 
      DopFl = 1 
      LastNum = Nummer 
      LastFlg = NumFlg 
    Else 
      Typ = 1-Typ ; Typwechsel 
      DopFl = 0 
    EndIf 
    
  Next 

  Out$ = UCase(Left(Wrk$,1))+Mid(Wrk$,2,Lang) 
  ; ich schenke mir das -1, weil wird eh abgeschnitten... 
  
  ProcedureReturn Out$ 

EndProcedure 

For x = 0 To 50 
  LO = 3+Random(6) 
  Debug Create_Name(LO) 
Next

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -