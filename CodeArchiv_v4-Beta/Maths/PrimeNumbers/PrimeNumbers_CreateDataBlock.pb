; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=1557
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 02. October 2004
; OS: Windows
; Demo: Yes


; Create a table (data block) of prime numbers
; Erstellt eine Tabelle (Data-Block (mit Primzahlen)

; Recherche de nombres premiers 

#Max = 10000 
#Ligne = 40 

NewList Nb.l() 


For n = 3 To #Max Step 2 
  
  NbPremier = 1 
  ResetList(Nb()) 
  While NextElement(Nb()) 
    If n % Nb() = 0 
      NbPremier = 0 
      Break 
    EndIf 
  Wend 
  
  If NbPremier 
    AddElement(Nb()) 
    Nb() = n 
    Debug Str(CountList(Nb())) + " = " + Str(n) 
  EndIf 
  
Next 


If CreateFile(0, "Nb Premier [Data].pb") 
  WriteStringN(0, "#NbData_NbPremier = " + Str(CountList(Nb()))) 
  WriteStringN(0, "DataSection") 
  WriteString(0, "  NbPremier :") 
  Ligne = #Ligne 
  ResetList(Nb()) 
  While NextElement(Nb()) 
    Ligne + 1 
      
    If Ligne < #Ligne 
      WriteString(0, ", " + Str(Nb())) 
    Else 
      Ligne = 0 
      WriteStringN(0, "") 
      WriteString(0, "    Data.l " + Str(Nb())) 
    EndIf 
  Wend 
  WriteStringN(0, "") 
  WriteString(0, "EndDataSection") 
  CloseFile(0) 
EndIf 

Debug "Terminé"

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -