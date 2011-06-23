; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5352&highlight=
; Author: Froggerprogger
; Date: 12. August 2004
; OS: Windows
; Demo:


; LCS - Längste Gemeinsame Teilfolge eines (Byte-)Strings

; LCS_Get: 
; Berechnet den längsten gemeinsamen Substring (Longest Common Subsequence) in *p_x und *p_y 
; Arbeitet mit jedem Bytestring, nicht nur mit Strings ! 
; Man kann diese Funktion daher durchaus z.B. mit binären Dateien füttern ! 
; 
; Liefert einen Pointer zum Ergebnis (+terminierender 0, also WENN Du mit strings 
; arbeitest, kannst Du direkt PeekS(LCS_Get(...)) aufrufen) 
; Die Länge wird in der referenzierten *p_resLen gespeichert, Du kannst den Parameter 
; aber auch auf Null lassen, wenn Du die Länge nicht brauchst. 
; 
; Zu den Anwendungen: 
; Die Länge der Lcs läßt sich als Maß für die 'Ähnlichkeit' zweier Strings nutzen. 
; Auch sollte man damit die Unterschiede zweier Dateien ausmachen können (mit einigen 
; Zusatzangaben bzgl. der Orte der zusammenhängenden Bereiche), bis dahin, daraus 
; annähernd minimal aufwändige Patches zweier Dateiversionen zu entwerfen, z.B. für 
; Updates.

; by Froggerprogger 12.08.04 

ProcedureDLL.l LCS_Get(*p_x.l, p_xLen.l, *p_y.l, p_yLen.l, *p_resLen.l) 
  ; LCS = Longest Common Subsequence 
  ; basiert auf Pseudocode von Cormen's 'Introduction to Algorithms SE' p.353f 
  ; (Kombination aus LCS_LENGTH und (iterativem) PRINT_LCS) 
  ; by Froggerprogger 12.08.04 
  
  Protected i.l, j.l 
  Protected *mem.l 
  Protected resLen.l 
  Protected actPos.l 
  
  ; define the arrays used for calculation (I wish we had local ones...) 
  Dim LCS_c.l(p_xLen, p_yLen) 
  Dim LCS_d.b(p_xLen, p_yLen) ; 1=upleft, 2=up, 3=left 
  
  ; compute the main algorithm 
  For i=1 To p_xLen 
    For j = 1 To p_yLen 
      If PeekB(*p_x + (i-1)) = PeekB(*p_y + (j-1)) 
        LCS_c(i, j) = LCS_c(i-1, j-1) + 1 
        LCS_d(i, j) = 1 ; upleft 
      Else 
        If LCS_c(i-1, j) >= LCS_c(i, j-1) 
          LCS_c(i,j) = LCS_c(i-1, j) 
          LCS_d(i,j) = 2 ; up 
        Else 
          LCS_c(i,j) = LCS_c(i, j-1) 
          LCS_d(i,j) = 3 ; left 
        EndIf 
      EndIf 
    Next j 
  Next i 
  
  ; the length is stored in bottom right field 
  resLen = LCS_c(p_xLen, p_yLen) 

  ; now we might free LCS_c 
  Dim LCS_c.l(0,0) 

  ; allocate memory for our result (plus a terminating zero for comfortable use with PeekS) 
  *mem = AllocateMemory(resLen + 1) 
  If *mem = 0 
    ProcedureReturn -1 
  EndIf 
  
  i = p_xLen 
  j = p_yLen 
  actPos = resLen -1 
  
  ; write out our lcs 
  While i > 0 And j > 0 
    If LCS_d(i,j) = 1 
      PokeB(*mem + actPos, PeekB(*p_x + (i-1))) 
      actPos - 1 
      i-1 
      j-1 
    ElseIf LCS_d(i,j) = 2 
      i-1 
    Else ; LCS_d(i,j) = 3 
      j-1 
    EndIf 
  Wend 
  
  ; free LCS_d 
  Dim LCS_d.b(0,0) 
  
  ; write the length of lcs at position *p_resLen 
  If *p_resLen 
    PokeL(*p_resLen, resLen) 
  EndIf 

  ; return pointer to result 
  ProcedureReturn *mem 
EndProcedure 

a.s = "Dies ist ein bekloppter String, dem ich hiermit ausgerechnet diese menschliche Eigenschaft zuschreibe !" 
b.s = "Dies ein weiterer, der im übrigen weder den Sinn des Lebens, noch dessen Unsinn darstellt." 
len.l 

Debug ".............................." 
Debug "Längste gemeinsame Teilfolge der folgenden beiden Strings:" 
Debug ".............................." 
Debug a 
Debug b 
Debug ".............................." 
Debug PeekS(LCS_Get(@a, Len(a), @b, Len(b), @len)) 
Debug ".............................." 
Debug "length: "  + Str(len)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -