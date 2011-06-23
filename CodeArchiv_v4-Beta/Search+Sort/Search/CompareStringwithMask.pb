; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7819
; Author: einander (changes + updated for PB4.00 by blbltheworm)
; Date: 08. October 2003
; OS: Windows
; Demo: Yes


;Compare string with mask - Recursive search 
;by Einander - Registered PB user 
;October 8 - 2003 - PB 3.80 
; 
Procedure.s FindMask(Orig$,Msk$) 
    Shared Compare$ 
    in=FindString(Msk$,"*",1) 
    If in 
        LMask$=Left(Msk$,in-1) 
        RMask$= Mid(Msk$,in+1,Len(Msk$)) 
        in=FindString(Orig$,LMask$,1) 
        If in 
            Compare$=Compare$+"*"+LMask$ 
            FindMask(Mid(Orig$,in+2,Len(Orig$)),RMask$) 
        EndIf 
    Else 
       Compare$=Compare$+"*"+Msk$ 
    EndIf 
    If Left(Compare$,1)="*" : Compare$=Mid(Compare$,2,Len(Compare$)):EndIf ;<-Added by blbltheworm
   ProcedureReturn Compare$ 
EndProcedure 
;_____________________________________________________________ 
; 
; Use * on mask to replace any text 
Original$="This is the original text with included mask fragments" 
Mask$="**is*nal*ext wit***uded*ment" 

While Left(Mask$,1)="*":Mask$=Mid(Mask$,2,Len(Mask$)):Wend ; cleans mask 
While Right(Mask$,1)="*":Mask$=Left(Mask$,Len(Mask$)-1):Wend 
While FindString(Mask$,"**",1) : Mask$=ReplaceString(Mask$,"**","*") : Wend ;<-Added by blbltheworm

If Mask$=Original$ 
    Debug "1 Mask equals Original" 
ElseIf Len(Mask$)>Len(Original$) 
    Debug "0 Mask too long" 
Else 
  Found$=FindMask(Original$,Mask$)
  If Found$=Mask$ 
      Debug "1 Found : "+Found$ 
  Else 
      Debug "0 Not found!" 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
