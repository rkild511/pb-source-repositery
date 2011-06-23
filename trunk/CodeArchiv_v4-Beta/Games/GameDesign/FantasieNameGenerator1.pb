; German forum: http://www.purebasic.fr/german/viewtopic.php?t=861&highlight=
; Author: MLK
; Date: 13. November 2004
; OS: Windows
; Demo: Yes

; Fantasie name generator
; Generator für Fantasienamen

vokal.s="aeiou" 
Doppelvokal.s="aeo" 
Konsonant.s="bcdfghjklmnpqrstvwxyz" 
Doppelkonsonant.s="bcfklmnprstz" 

For x=1 To 1000 
    Laenge=3+Random(3) 
    ;erster buchstabe - vokal oder konsonant 
    If Random(1) 
        Name.s+Mid(Konsonant,Random(Len(Konsonant)-1)+1,1) 
    Else 
        Name.s+Mid(vokal,Random(Len(vokal)-1)+1,1) 
    EndIf 
    
    ;einer geht noch.. 
    While Laenge>1 
        ;letzter buchstabe ist ein vokal 
        If CountString(vokal,Right(Name,1)) 
            ;einen konsonanten dazu 
            Name+Mid(Konsonant,Random(Len(Konsonant)-1)+1,1) 
            Laenge-1 
            ;wenn dieser ein möglicher doppelkonsonant und der zufall es will 
            If CountString(Doppelkonsonant,Right(Name,1)) And doppel=#True And Laenge>1 And Random(4)=0 
                ;verdoppeln 
                Name+Right(Name,1) 
                Laenge-1 
            EndIf 
        ;letzter buchstabe ist ein konsonant 
        Else 
            ;einen vokal dazu 
            Name+Mid(vokal,Random(Len(vokal)-1)+1,1) 
            Laenge-1 
            ;wenn dieser ein möglicher doppelvokal und der zufall es will 
            If CountString(Doppelvokal,Right(Name,1)) And doppel=#True And Laenge>1 And Random(4)=0 
                ;verdoppeln 
                Name+Right(Name,1) 
                Laenge-1 
            EndIf 
        EndIf 
        ;wenn die letzten beiden buchstaben gleich sind 
        If Right(Right(Name,2),1)=Left(Right(Name,2),1) 
            ;verhindern dass noch zwei doppelte dazu kommen 
            doppel=#False 
        Else 
            ;ansonsten ist es erlaubt 
            doppel=#True 
        EndIf 
    Wend 
    Name+"|" 
    Debug StringField(Name,x,"|") 
Next 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -