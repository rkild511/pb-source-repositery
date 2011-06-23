; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1048
; Author: Dostej (updated for PB 4.00 by Andre)
; Date: 29. November 2004
; OS: Windows
; Demo: Yes


Procedure.s getname(art) 
  ;diese funktion gibt einen Namen zurück. die art des Namens kann mit dem Parameter festgelegt werden 
  ;1  Griechisch 
  ;2  Afrikansich 
  ;3  English 
  ;4  Elfisch 
  ;5  Hebräisch 
  ;6  Arabisch - Namen 
  ;7  Japanisch 
  ;8  Chinesisch 
  ;9  Griech Alphabet + name für Sternenbezeichnungen 
  ;+ 10  für benennungen 
  h$ = "" 
  
  Select art 
    Case 1  ;Griechisch 
      ;1. Teil 
      Restore Nameart1_1 
      For x = 1 To 1 + Random(19) 
        Read h$ 
      Next x 
      ;2. Teil 
      If Random(100) > 50  ;50%- Chance für mittlerenNamensteil 
        Restore Nameart1_2 
        For x = 1 To 1 + Random(9) 
          Read a$ 
        Next x 
        h$ = h$ + a$ 
      EndIf 
      ;3. Teil 
      Restore Nameart1_3 
      For x = 1 To 1 + Random(15) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      
    Case 2  ;Afrikanisch 
      ;1. Teil 
      Restore Nameart2_1 
      For x = 1 To 1 + Random(8) 
        Read h$ 
      Next x 
      ;2. Teil 
      Restore Nameart2_2 
      For x = 1 To 1 + Random(19) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      ;3. Teil 
      If Random(100) > 50  ;50%- Chance für mittleren Namensteil 
        Restore Nameart2_3 
        For x = 1 To 1 + Random(10) 
          Read a$ 
        Next x 
        h$ = h$ + a$ 
      EndIf 
      ;4. Teil 
      Restore Nameart2_4 
      For x = 1 To 1 + Random(10) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      
    Case 3  ; 
      ;1. Teil 
      Restore Nameart3_1 
      For x = 1 To 1 + Random(12) 
        Read h$ 
      Next x 
      ;2. Teil 
      If Random(100) > 50  ;50%- Chance für mittlerenNamensteil 
        Restore Nameart3_2 
        For x = 1 To 1 + Random(22) 
          Read a$ 
        Next x 
        h$ = h$ + a$ 
      EndIf 
      ;3. Teil 
      Restore Nameart3_3 
      For x = 1 To 1 + Random(12) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      
    Case 4  ; 
      Restore Nameart4_1 
      Dim nmsnip$(101) 
      For x = 1 To 101 
        Read nmsnip$(x) 
      Next x 
      For t = 1 To Random(2) + 2 
        h = 1 + Random(100) 
        h$ = h$ + nmsnip$(h) 
      Next t 
      
    Case 5  ;Hebräisch 
      ;1. Teil 
      Restore Nameart5_1 
      For x = 1 To 1 + Random(40) 
        Read h$ 
      Next x 
      ;2. Teil 
      If Random(100) > 50  ;50%- Chance für mittlerenNamensteil 
        Restore Nameart5_2 
        For x = 1 To 1 + Random(23) 
          Read a$ 
        Next x 
        h$ = h$ + a$ 
      EndIf 
      ;3. Teil 
      Restore Nameart5_3 
      For x = 1 To 1 + Random(47) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      
    Case 6  ;Arabisch 
      ;1. Teil 
      If Random(100) > 50  ;50%- Chance für mittleren Namensteil 
        Restore Nameart6_1 
        For x = 1 To 1 + Random(5) 
          Read h$ 
        Next x 
        h$ = h$ + " " 
      EndIf 
      ;2. Teil 
      Restore Nameart6_2 
      For x = 1 To 1 + Random(9) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      ;3. Teil 
      Restore Nameart6_3 
      For x = 1 To 1 + Random(12) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      ;4. Teil 
      If Random(100) > 50  ;50%- Chance für mittleren Namensteil 
        Restore Nameart6_4 
        For x = 1 To 1 + Random(6) 
          Read a$ 
        Next x 
        h$ = h$ + " " + a$ 
      EndIf 
      ;5. Teil 
      Restore Nameart6_5 
      For x = 1 To 1 + Random(22) 
        Read a$ 
      Next x 
      h$ = h$ + " " + a$ 
      
    Case 7  ;Japanisch 
      Restore Nameart7_1 
      Dim nmsnip$(60) 
      For x = 1 To 60 
        Read nmsnip$(x) 
      Next x 
      For t = 1 To Random(1) + 2 
        h = 1 + Random(59) 
        h$ = h$ + nmsnip$(h) 
      Next t 
      
    Case 8  ;Chinesisch 
      ;1. Teil 
      Restore Nameart8_1 
      For x = 1 To 1 + Random(13) 
        Read h$ 
      Next x 
      ;2. Teil 
      Restore Nameart8_2 
      For x = 1 To 1 + Random(10) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      
      ;1. Teil 
      Restore Nameart8_1 
      For x = 1 To 1 + Random(13) 
        Read a$ 
      Next x 
      h$ = h$ + " " + a$ 
      ;2. Teil 
      Restore Nameart8_2 
      For x = 1 To 1 + Random(10) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      ;3. Teil 
      If Random(100) > 50  ;50%- Chance für mittleren Namensteil 
        Restore Nameart8_3 
        For x = 1 To 1 + Random(11) 
          Read a$ 
        Next x 
        h$ = h$ + a$ 
      EndIf 
      
    Case 9  ;Griech Alphabet + name für Sternenbezeichnungen 
      ;1. Teil 
      Restore Nameart9_1 
      For x = 1 To 1 + Random(23) 
        Read h$ 
      Next x 
      ;2. Teil 
      Restore Nameart9_2 
      For x = 1 To 1 + Random(50) 
        Read a$ 
      Next x 
      h$ = h$ + " " + a$ 
      
    Case 10  ;Arabisch - benennung 
      ;4. Teil 
      Restore Nameart6_4 
      For x = 1 To 1 + Random(6) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      
      ;5. Teil 
      Restore Nameart6_5 
      For x = 1 To 1 + Random(22) 
        Read a$ 
      Next x 
      h$ = h$ + " " + a$ 
      
    Case 11  ;Chinesisch - benennung 
      ;1. Teil 
      Restore Nameart8_1 
      For x = 1 To 1 + Random(13) 
        Read h$ 
      Next x 
      ;2. Teil 
      Restore Nameart8_2 
      For x = 1 To 1 + Random(10) 
        Read a$ 
      Next x 
      h$ = h$ + a$ 
      ;2. Teil 
      If Random(100) > 50  ;50%- Chance für mittleren Namensteil 
        Restore Nameart8_3 
        For x = 1 To 1 + Random(11) 
          Read a$ 
        Next x 
        h$ = h$ + a$ 
      EndIf 
  EndSelect 
  h$ = UCase(Left(h$, 1)) + LCase(Right(h$, Len(h$)-1)) 
  ProcedureReturn h$ 
EndProcedure 

Debug "Namen in verschiedenen Sprachen"
Debug "Griechisch:   " + getname(1) 
Debug "Afrikanisch:  " + getname(2) 
Debug "Englisch:     " + getname(3) 
Debug "Elfisch:      " + getname(4) 
Debug "Hebräisch:    " + getname(5) 
Debug "Arabisch:     " + getname(6) 
Debug "Japanisch:    " + getname(7) 
Debug "Chinesisch:   " + getname(8) 
Debug "Griechische Sterne: " + getname(9) 
Debug "Arabische Namen:    " + getname(10) 
Debug "Chinesische Namen:  " + getname(11) 



;{- Data SECTION 
DataSection 
Nameart1_1: 
; anzahl  20 
Data.s "Ari", "So", "Pla", "Par", "So", "A", "Epi", "Tres", "Anaxi", "Tha", "Theo", "Philo", "Phobo", "Ener", "Sys", "Her", "Phy", "Demo", "Pro" 
Nameart1_2: 
; anzahl  10 
Data.s "sto", "kra", "meni", "pho", "i", "ku", "megi", "man", "men", "tago" 
Nameart1_3: 
; anzahl  16 
Data.s "teles", "telos", "phane", "ket", "tes", "ton", "des", "les", "kur", "stos", "phos", "der", "les", "krit", "ras", "mes" 


Nameart2_1: 
; anzahl  9 
Data.s "M", "N", "B", "Tsch", "T", "Z", "W", "L", "D" 
Nameart2_2: 
; anzahl  20 
Data.s "ka", "ke", "ki", "ku", "ko", "ba", "bi", "bu", "he", "hu", "ho", "ze", "zu", "zi", "zo", "gu", "gi", "go", "ge" 
Nameart2_3: 
; anzahl  11 
Data.s "na", "bi", "mi", "ne", "mbu", "bo", "no", "nu", "mhe", "hu", "gho" 
Nameart2_4: 
; anzahl  11 
Data.s "nate", "mbe", "nge", "ghu", "gho", "mbo", "mbu", "ze", "zi", "zu", "zo" 



Nameart3_1: 
; anzahl  13 
Data.s "Be", "De", "Ge", "Ha", "Ja", "Je", "Ka", "Ke", "The", "Tha", "Thi", "Li", "Gre" 
Nameart3_2: 
; anzahl  23 
Data.s "en", "thi", "tha", "the", "bo", "th", "y", "gh", "que", "fe", "te", "re", "ra", "ta", "po", "pe", "pi", "ve", "va" 
Data.s "che", "cho", "chi" 
Nameart3_3: 
; anzahl  13 
Data.s "ich", "lvy", "bar", "ly", "my", "ty", "zy", "ky", "yl", "er", "te", "th", "gh" 


Nameart4_1: 
; anzahl  101 
Data.s "a", "e", "i", "o", "u", "y", "ai", "au", "ae", "ao", "ay", "ei", "eu", "eo", "ea", "ey", "ie", "iu", "io" 
Data.s "iy", "ue", "uo", "ua", "uy", "ui", "ou", "oi", "oe", "oa", "oy", "ye", "ya", "yu", "yi", "yo", "arr", "ut", "ich" 
Data.s "bar", "ly", "my", "ty", "ou", "ai", "jo", "zym", "bir", "des", "dai", "da", "los", "kyr", "io", "qu", "kat", "ark", "ana" 
Data.s "ion", "ak", "mir", "lor", "nth", "ith", "oll", "off", "ugg", "mai", "cyr", "pol", "man", "est", "ger", "the", "fis", "min", "max" 
Data.s "lo", "gh", "ron", "vor", "pre", "int", "ren", "kyll", "er", "in", "an", "on", "un", "ung", "ing", "ilit", "itr", "hit", "tra" 
Data.s "zur" 


Nameart5_1: 
; anzahl  41 
Data.s "aa", "abi", "ari", "aggri", "amaz", "anti", "asch", "ba", "bet", "ben", "bel", "da", "ef", "el", "es", "gab", "ge", "gid", "go" 
Data.s "Ha", "He", "Ho", "Jeru", "Jesa", "Jo", "Ju", "Kad", "Me", "Le", "Me", "Na", "Mor", "Ne", "Nim", "Ra", "Gil", "Sab", "She" 
Data.s "Tob" 
Nameart5_2: 
; anzahl  24 
Data.s "me", "ma", "mo", "y", "sa", "ja", "ha", "schaz", "schi", "ra", "a", "ri", "hen", "nuk", "sa", "na", "ro", "via", "tha" 
Data.s "ne", "he", "fe", "phir" 
Nameart5_3: 
; anzahl  48 
Data.s "la", "bat", "ead", "hel", "rod", "gev", "mia", "chai", "hem", "dish", "däa", "fat", "tan", "ja", "lem", "lim", "jim", "schea", "noch" 
Data.s "ka", "eon", "na", "el", "ter", "ischa", "ta", "im", "skus", "ruch", "ron", "lech", "pa", "ja", "thea", "ochia", "era", "dai", "lon" 
Data.s "min", "dach", "zar", "ia", "ias", "ra", "it", "phim" 


Nameart6_1: 
; anzahl  6 
Data.s "Al", "El", "Il", "Abu", "Abd", "Ali" 
Nameart6_2: 
; anzahl  8 
Data.s "O", "Muha", "Ach", "Abu", "Dschalla", "Sulei", "Far", "Suhra" 
Nameart6_3: 
; anzahl  13 
Data.s "mar", "stafa", "med", "tan", "lah", "seif", "yed", "shah", "ham", "sama", "laddin", "wardi", "man" 
Nameart6_4: 
; anzahl  7 
Data.s "i", "el", "il", "ibn", "ben", "al", "bin" 
Nameart6_5: 
; anzahl  23 
Data.s "Sheik", "Sharif", "Tauba", "Hadsch", "Araf", "Anam", "Nisa", "Imran", "Sadshedah", "Alak", "Abasa", "Hakkah", "Kalam", "Talak", "Duha", "Hadschr", "Dhariyat", "Schura", "Fatir" 
Data.s "Rushd", "Saadi", "Saif" 


Nameart7_1: 
; anzahl  60 
Data.s "oki", "kyo", "suzu", "fuji", "toku", "hondo", "to", "ta", "gyo", "iri", "omo", "musa", "mu", "kata", "hara", "ono", "waki", "tan", "hon" 
Data.s "shin", "san", "ni", "go", "rok", "jui", "yama", "tama", "kote", "gaeshi", "nawa", "to", "kyo", "kyu", "ki", "jama", "tama", "gama", "musu" 
Data.s "joto", "soto", "sama", "toshi", "gawa", "shi", "shu", "sho", "sha", "lan", "na", "ro", "kami", "sashi", "shin", "kuro", "kubi", "shime", "nagi" 

Nameart8_1: 
; anzahl  14 
Data.s "B", "W", "Tsch", "Ch", "L", "P", "F", "H", "Sch", "Z", "M", "D", "X", "T" 
Nameart8_2: 
; anzahl  11 
Data.s "i", "o", "u", "e", "ai", "ei", "au", "ej", "en", "an", "in" 
Nameart8_3: 
; anzahl  12 
Data.s "jang", "chu", "ing", "ong", "ang", "jong", "jing", "cho", "chu", "tsi", "tsu", "tso" 


Nameart9_1: 
; anzahl  24 
Data.s "Alpha", "Beta", "Gamma", "DElta", "Epsilon", "Zeta", "Eta", "Theta", "Jota", "Kappa", "Lambda", "My", "Ny", "Xi", "Omikron", "Pi", "Rho", "Sigma", "Tau" 
Data.s "Phi", "Chi", "Psi", "Omega" 
Nameart9_2: 
; anzahl  51 
Data.s "Prime", "Cygni", "Erina", "Carina", "Holo", "Dystera", "Tera", "Tauris", "Logon", "Nomo", "Arthos", "Laos", "Naos", "Uranos", "Stauros", "Hios", "Oinos", "Kairos", "Daimos" 
Data.s "Philos", "Plutos", "Desmios", "Polemos", "Peri", "Hodos", "Dio", "Meta", "Pros", "Kata", "Dia", "Ploion", "Tzoon", "Dendron", "Kara", "Elaion", "Xylon", "Akoe", "Thyra" 
Data.s "Telones", "Kalos", "Dikaios", "Axios", "Oro", "Limos", "Thesauros", "Kapnos", "Soteria", "Charisma", "Lailapos" 
EndDataSection 
;} 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -