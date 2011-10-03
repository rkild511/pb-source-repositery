; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Nom du projet : Levenshtein distance
; Réference : ; http://en.wikipedia.org/wiki/Levenshtein_distance
; Nom du Fichier : Levenshtein Distance.pbi
; Version du fichier : 1.0.0
; Programmation : OK
; Programmé par : Guillaume
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 01-03-2009
; Mise à jour : 01-03-2009
; Codé avec PureBasic V4.50
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure.l LevenshteinDistance(P_String01.s, P_String02.s, P_CaseSensitive.b = #False)
  
  If P_CaseSensitive = #False
    P_String01 = LCase(P_String01)
    P_String02 = LCase(P_String02)
  EndIf
  
  m.l = Len(P_String01)
  n.l = Len(P_String02)
  
  Dim Distance.l(m, n)
  
  For Index = 0 To m
    Distance(Index, 0) = Index
  Next
  
  For Index = 0 To n
    Distance(0, Index) = Index
  Next
  
  For IndexA = 1 To m
    For IndexB = 1 To n
      
      If Mid(P_String01, IndexA - 1, 1) = Mid(P_String02, IndexB - 1, 1)
        cost = 0
      Else
        cost = 1
      EndIf   
      
      Smallest_Long.l = Distance(IndexA - 1, IndexB) + 1
      Min02.l = Distance(IndexA, IndexB - 1) + 1
      Min03.l = Distance(IndexA - 1, IndexB - 1) + cost

      If Min02 < Smallest_Long
        Smallest_Long = Min02
      EndIf
      
      If Min03 < Smallest_Long
        Smallest_Long = Min03
      EndIf

      Distance(IndexA, IndexB) = Smallest_Long
      
    Next
  Next  
  
  ProcedureReturn Distance(m, n)
EndProcedure

Procedure.d LevenshteinCorrelation(P_String01.s, P_String02.s, P_CaseSensitive.b = #False)
  
  Biggest_Long.l = Len(P_String01)
  P_Number02.l = Len(P_String02)
 
  If P_Number02 > Biggest_Long
    Biggest_Long = P_Number02
  EndIf
 
  ProcedureReturn  1.0 - LevenshteinDistance(P_String01, P_String02, P_CaseSensitive) / Biggest_Long
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 3
; Folding = -
; EnableXP