; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3284&highlight=
; Author. Deeem2031
; Date: 30. December 2003
; OS: Windows
; Demo: Yes

; Support all variants of +,-,*,/ with and without brackets...

#Max_Kl = 19 ;Die maximale Anzahl von Klammern (+1 ,wegen der 0) 

Procedure.f Eval(Input.s) 
  Dim Priority.s(20) 
  Result.f 
  P2_Result.f 
  k = 0 
  *pInput.BYTE = @Input 
  Repeat 
    If *pInput\b = '(' 
      
      k+1 
        
    ElseIf *pInput\b = ')' 
      
      *r.BYTE = @Priority(k) 
      last_op = 0 
      number.s = "" 
      lastchrnum = 1 
      P2_Start_Op = -1 
      Repeat 
        If *r\b >= $30 And *r\b <= $39 
          number + Chr(*r\b) 
          lastchrnum = 1 
          
        ElseIf *r\b = '.' 
          
          number + "." 
          lastchrnum = 1 
          
        Else ;*r\b ist keine ASCII-Ziffer 
          
          
          last_op2 = last_op 
          If lastchrnum 
            If *r\b = '+' 
              If last_op > 2 
                If last_op = 3 
                  P2_Result * ValF(number) 
                ElseIf last_op = 4 
                  P2_Result / ValF(number) 
                EndIf 
                If P2_Start_Op = 0 
                  Result = P2_Result 
                ElseIf P2_Start_Op = 1 
                  Result + P2_Result 
                ElseIf P2_Start_Op = 2 
                  Result - P2_Result 
                EndIf 
                P2_Start_Op = -1 
              EndIf 
              
              last_op = 1 
            ElseIf *r\b = '-' 
              If last_op > 2 
                If last_op = 3 
                  P2_Result * ValF(number) 
                ElseIf last_op = 4 
                  P2_Result / ValF(number) 
                EndIf 
                If P2_Start_Op = 0 
                  Result = P2_Result 
                ElseIf P2_Start_Op = 1 
                  Result + P2_Result 
                ElseIf P2_Start_Op = 2 
                  Result - P2_Result 
                EndIf 
                P2_Start_Op = -1 
              EndIf 
              
              last_op = 2 
            ElseIf *r\b = '*' 
              If last_op < 3 
                P2_Start_Op = last_op 
                P2_Result = ValF(number) 
              EndIf 
              last_op = 3 
            ElseIf *r\b = '/' 
              If last_op < 3 
                P2_Start_Op = last_op 
                P2_Result = ValF(number) 
              EndIf 
              last_op = 4 
            EndIf 
            
            If last_op2 = 0 And last_op < 3 
              Result = ValF(number) 
            ElseIf last_op2 = 1 And last_op < 3 
              Result + ValF(number) 
            ElseIf last_op2 = 2 And last_op < 3 
              Result - ValF(number) 
            ElseIf last_op2 = 3 
              P2_Result * ValF(number) 
            ElseIf last_op2 = 4 
              P2_Result / ValF(number) 
            EndIf 
            
            number = "" 
          ElseIf *r\b = '-' 
            If number = "" 
              number = "-" 
            Else 
              number = "" 
            EndIf 
          EndIf 
          
          
          
          lastchrnum = 0 
          
        EndIf 
        
        
        *r+1 
      Until *r\b = 0 
      If last_op = 0 
        Result = ValF(number) 
      ElseIf last_op = 1 
        Result + ValF(number) 
      ElseIf last_op = 2 
        Result - ValF(number) 
      ElseIf last_op = 3 
        P2_Result * ValF(number) 
      ElseIf last_op = 4 
        P2_Result / ValF(number) 
      EndIf 
      
      If P2_Start_Op = 0 
        Result = P2_Result 
      ElseIf P2_Start_Op = 1 
        Result + P2_Result 
      ElseIf P2_Start_Op = 2 
        Result - P2_Result 
      EndIf 
      k-1 
      If k < 0 
        ProcedureReturn 0 
      EndIf 
      Priority(k)+Str(Result) 
      
    ElseIf *pInput\b = 0 ; ---ENDE vom String--- 

      
      *r.BYTE = @Priority(k) 
      last_op = 0 
      number = "" 
      lastchrnum = 1 
      P2_Start_Op = -1 
      Repeat 
        If *r\b >= $30 And *r\b <= $39 
          number + Chr(*r\b) 
          lastchrnum = 1 
          
        ElseIf *r\b = '.' 
          
          number + "." 
          lastchrnum = 1 
          
        Else ;*r\b ist keine ASCII-Ziffer 
          
          
          last_op2 = last_op 
          If lastchrnum 
            If *r\b = '+' 
              If last_op > 2 
                If last_op = 3 
                  P2_Result * ValF(number) 
                ElseIf last_op = 4 
                  P2_Result / ValF(number) 
                EndIf 
                If P2_Start_Op = 0 
                  Result = P2_Result 
                ElseIf P2_Start_Op = 1 
                  Result + P2_Result 
                ElseIf P2_Start_Op = 2 
                  Result - P2_Result 
                EndIf 
                P2_Start_Op = -1 
              EndIf 
              
              last_op = 1 
            ElseIf *r\b = '-' 
              If last_op > 2 
                If last_op = 3 
                  P2_Result * ValF(number) 
                ElseIf last_op = 4 
                  P2_Result / ValF(number) 
                EndIf 
                If P2_Start_Op = 0 
                  Result = P2_Result 
                ElseIf P2_Start_Op = 1 
                  Result + P2_Result 
                ElseIf P2_Start_Op = 2 
                  Result - P2_Result 
                EndIf 
                P2_Start_Op = -1 
              EndIf 
              
              last_op = 2 
            ElseIf *r\b = '*' 
              If last_op < 3 
                P2_Start_Op = last_op 
                P2_Result = ValF(number) 
              EndIf 
              last_op = 3 
            ElseIf *r\b = '/' 
              If last_op < 3 
                P2_Start_Op = last_op 
                P2_Result = ValF(number) 
              EndIf 
              last_op = 4 
            EndIf 
            
            If last_op2 = 0 And last_op < 3 
              Result = ValF(number) 
            ElseIf last_op2 = 1 And last_op < 3 
              Result + ValF(number) 
            ElseIf last_op2 = 2 And last_op < 3 
              Result - ValF(number) 
            ElseIf last_op2 = 3 
              P2_Result * ValF(number) 
            ElseIf last_op2 = 4 
              P2_Result / ValF(number) 
            EndIf 
            
            number = "" 
          ElseIf *r\b = '-' 
            If number = "" 
              number = "-" 
            Else 
              number = "" 
            EndIf 
          EndIf 
          
          
          
          lastchrnum = 0 
          
        EndIf 
        
        
        *r+1 
      Until *r\b = 0 
      If last_op = 0 
        Result = ValF(number) 
      ElseIf last_op = 1 
        Result + ValF(number) 
      ElseIf last_op = 2 
        Result - ValF(number) 
      ElseIf last_op = 3 
        P2_Result * ValF(number) 
      ElseIf last_op = 4 
        P2_Result / ValF(number) 
      EndIf 
      
      If P2_Start_Op = 0 
        Result = P2_Result 
      ElseIf P2_Start_Op = 1 
        Result + P2_Result 
      ElseIf P2_Start_Op = 2 
        Result - P2_Result 
      EndIf 
      
      ProcedureReturn Result 
      
    Else 
      Priority(k) + Chr(*pInput\b) 
    EndIf 
    *pInput+1 
  ForEver 
EndProcedure 


Debug Eval("-234+5-(3-4*2)") 
Debug -234+5-(3-4*2) 
Debug "---" 
Debug Eval("2+-3") 
Debug 2+-3 
Debug "---" 
Debug Eval("-234*4234-(234287*342/23123+(74*2+(425/6)))") 
Debug -234*4234-(234287*342/23123+(74*2+(425/6))) 
Debug "---" 
Debug Eval("2---3") 
Debug 2---3 
Debug "---" 
Debug Eval("2/3") 
Debug 2/3 
Debug "---" 
Debug Eval("2+3/4*5-6") 
Debug 2+3/4*5-6 
Debug "---" 
Debug Eval("2+3*4") 
Debug 2+3*4 
Debug "---" 
Debug Eval("3*4+2") 
Debug 3*4+2 
Debug "---" 
Debug Eval("3*4") 
Debug 3*4 
Debug "---" 
Debug Eval("3.234*4.321") 
Debug 3.234*4.321 


;StartTime = gettickcount_() 
;For i = 0 To 100000 
;  Eval("-234+5-(3-2)") 
;Next 
; 
;MessageRequester("",Str(gettickcount_()-StartTime)) ; ca. 1550 ms @Deeem2031-Computer (ohne Debugger)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
