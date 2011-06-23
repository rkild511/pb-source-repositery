; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2483&highlight=
; Author: helpy
; Date: 09. October 2003
; OS: Windows
; Demo: Yes

; Useful to short long path/filenames....   need PB 3.80+ !!!
Procedure.s ShortenString(aString.s) 
  Protected sLen.l, pos1.l, pos2.l 
  sLen = Len(aString) 
  pos1 = FindString(aString,"\",1) 
  If pos1 > 0 
    pos2 = FindString(aString,"\",pos1+1) 
    While pos2 > 0 
      If pos2 > 0 
        If pos2 - pos1 > 6 
          aString = Left(aString,pos1+3) + ".." + Right(aString,sLen-pos2+1) 
          Break 
        Else 
          pos1 = pos2 
          pos2 = FindString(aString,"\",pos1+1) 
        EndIf 
      EndIf 
    Wend 
  EndIf 
  If Len(aString) = sLen 
    pos1 = FindString(aString,"\",1) 
    If pos1 > 0 
      pos2 = FindString(aString,"\",pos1+1) 
      While pos2 > 0 
        If pos2 > 0 
          If pos2 - pos1 > 3 
            aString = Left(aString,pos1) + ".." + Right(aString,sLen-pos2+1) 
            Break 
          Else 
            pos1 = pos2 
            pos2 = FindString(aString,"\",pos1+1) 
          EndIf 
        EndIf 
      Wend 
    EndIf 
  EndIf 
  ProcedureReturn aString 
EndProcedure 

teste.s = "C:\Programme\Programmierung\Purebasic\Programm.exe" 

Debug teste

teste = ShortenString(teste) 
Debug teste 
teste = ShortenString(teste) 
Debug teste 
teste = ShortenString(teste) 
Debug teste 
teste = ShortenString(teste) 
Debug teste 
teste = ShortenString(teste) 
Debug teste 
teste = ShortenString(teste) 
Debug teste
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
