; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=34&highlight=
; Author: NicTheQuick (changes by Andre)
; Date: 11. September 2003
; OS: Windows
; Demo: Yes

Procedure CompareWithWildcards(*String.Byte, *WC.Byte) 
  Protected *z1.Byte, *z2.Byte, *z3.Byte 
  Protected a.l, WCLength.l, StringLength.l 
  
  *z1 = *WC 
  *z2 = *String 
  Repeat 
    If *z1\b = '*' 
      *z3 = *z1 + 1 
      If *z3\b = 0                   ;Wenn der Stern am Schluss steht 
        ProcedureReturn #True 
      Else 
        If *z3\b = 0                  ;Wenn der String am Ende ist 
          ProcedureReturn #False 
        Else 
          *z3 = *z1 + 1 
          If *z3\b = *z2\b 
            *z1 + 1 
          Else 
            *z2 + 1 
          EndIf 
        EndIf 
      EndIf 
    ElseIf *z1\b = '?' 
      If *z2\b = 0 
        ProcedureReturn #False 
      Else 
        *z1 + 1 
        *z2 + 1 
      EndIf 
    Else 
      If *z1\b = *z2\b 
        *z1 + 1 
        *z2 + 1 
      Else 
        ProcedureReturn #False 
      EndIf 
    EndIf 
  Until *z1\b = 0 
  ProcedureReturn #True 
EndProcedure 

Debug CompareWithWildcards(@"NicTheQuick", @"Nic*Quick")      ;geht 
Debug CompareWithWildcards(@"NicTheQuick", @"NicThe*")        ;geht 
Debug CompareWithWildcards(@"NicTheQuick", @"?ic?he?uick")    ;geht 
Debug CompareWithWildcards(@"NicTheQuick", @"Nic*TheQuick*")  ;geht (* kann für Null Zeichen stehen) 
Debug CompareWithWildcards(@"NicTheTheQuick", @"Nic*TheQuick");geht nicht (wird noch berichtigt) 

Debug "SpeedTest (with Debugger!) started... Please wait!"
time.l = ElapsedMilliseconds() 
For a.l = 1 To 1000000 
  CompareWithWildcards(@"NicTheQuick", @"N?cT??Q*k") 
Next 
time = ElapsedMilliseconds() - time 
MessageRequester("Zeit bei 5.000.000", Str(time) + " ms", 0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
