; http://www.purebasic-lounge.de
; Author: Hroudtwolf
; Date: 22. May 2006
; OS: Windows, Linux
; Demo: Yes

#PHP_ENT_QUOTES   =0 ; handles both quotes: " and '   /  behandelt beide Quotes: " und '
#PHP_ENT_NOQUOTES =1 ; don't handle quotes            /  behandelt keine Quotes.
#PHP_ENT_COMPAT   =2 ; handles only double quotes: "  /  behandelt nur doppelte Quotes: "

Procedure.s HTMLSpecialChars (String.s,QuoteMode.l)
   Protected Dim CharAssocBuffer.s(5,2)
   Protected StartAssoc.l,StrPart.l,Char.s,NewStr.s,AssocFound.l
   Select QuoteMode.l
     Case #PHP_ENT_NOQUOTES
     StartAssoc.l=2
     Case #PHP_ENT_QUOTES
     StartAssoc.l=0
     Default
     StartAssoc.l=1
   EndSelect
   CharAssocBuffer.s(0,0)="'"        :CharAssocBuffer.s(0,1)="'"
   CharAssocBuffer.s(1,0)=Chr(34)    :CharAssocBuffer.s(1,1)="&quot;"
   CharAssocBuffer.s(2,0)="&"        :CharAssocBuffer.s(2,1)="&amp;"
   CharAssocBuffer.s(3,0)="<"        :CharAssocBuffer.s(3,1)="&lt;"
   CharAssocBuffer.s(4,0)=">"        :CharAssocBuffer.s(4,1)="&gt;;"
   For StrPart.l=0 To Len (String.s)-1
      Char.s=PeekS(@String+StrPart.l,1)
      AssocFound.l=#False
      For AssocNo.l=StartAssoc.l To 4
        If Char.s=CharAssocBuffer.s(AssocNo.l,0)
           NewStr.s+CharAssocBuffer.s(AssocNo.l,1)
           AssocFound.l=#True
           Break
        EndIf         
      Next AssocNo.l
      If AssocFound.l=#False
         NewStr.s+Char.s
      EndIf
   Next StrPart.l
   ProcedureReturn NewStr.s
EndProcedure

Debug HTMLSpecialChars (Chr(34)+"Hallo ich bin 'Frosch' & 'Prinz' zugleich."+Chr(34)+" sagte es.",#PHP_ENT_QUOTES)
Debug HTMLSpecialChars (Chr(34)+"Hallo ich bin 'Frosch' & 'Prinz' zugleich."+Chr(34)+" sagte es.",#PHP_ENT_NOQUOTES)
Debug HTMLSpecialChars (Chr(34)+"Hallo ich bin 'Frosch' & 'Prinz' zugleich."+Chr(34)+" sagte es.",#PHP_ENT_COMPAT)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -