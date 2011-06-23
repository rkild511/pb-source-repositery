; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8578&highlight=
; Author: blue
; Date: 07. December 2003
; OS: Windows
; Demo: Yes

Procedure.l x_matchpattern(string.s,pattern.s,ulcase.l) 
  Protected s_l, s_p, m_l, m_p, nomatch.l, match.l, ff.l, m.s 
  ; 
  ; *** check if string matches pattern 
  ; 
  ; in:     string.s   - string to check 
  ;         pattern.s  - pattern including wildcards * and ? and multiple patterns seperated by | 
  ;         ulcase.l   - 0 check case 1 don't care about case 
  ; retval: 0          - no match 
  ;         1          - match 
  ; 
  If ulcase.l = 1 
    string.s = LCase(string.s) 
    pattern.s = LCase(pattern.s) 
  EndIf 
  ; 
  s_l = Len(string) 
  s_p = 1 
  m_l = Len(pattern) 
  m_p = 0 
  ; 
  nomatch.l = #False 
  match.l = #False 
  ff.l = #False 
  While m_p < m_l And match = #False 
    m_p = m_p+1 
    m.s = Mid(pattern,m_p,1) 
    If m = "*" 
      If m_p = m_l 
        match = #True 
      Else 
        ff= #True 
      EndIf 
    EndIf 
    If m = "|" 
      If s_p = s_l+1 
        match = #True 
      EndIf 
    ElseIf m = "?" 
      If s_p <= s_l 
        s_p = s_p+1 
      Else 
        nomatch = #True 
      EndIf 
    ElseIf m <> "*" 
      If ff = #True 
        ff = #False 
        Repeat 
          s_p = s_p+1 
        Until s_p > s_l Or m=Mid(string,s_p,1) 
        If m = Mid(string,s_p,1) 
          s_p = s_p+1 
        Else 
          nomatch = #True 
        EndIf 
      Else 
        If m = Mid(string,s_p,1) 
          s_p = s_p+1 
        Else 
          nomatch = #True 
        EndIf 
      EndIf 
    EndIf 
    If nomatch = #False And s_p = s_l+1 And m_p = m_l 
      match = #True 
    EndIf 
    If nomatch = #True 
      m_p = FindString(pattern,"|",m_p+1) 
      If m_p = 0 
        m_p = m_l 
      Else 
        nomatch = #False 
        ff = #False 
        s_p = 1 
      EndIf 
    EndIf 
  Wend 
  ; 
  ProcedureReturn match 
EndProcedure 

Debug x_matchpattern("StringToSearch","*To*",0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
