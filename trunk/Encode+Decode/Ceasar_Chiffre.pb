; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=993&highlight=
; Author: NicTheQuick
; Date: 13. May 2003

Procedure.s CaesarChiffre(Eing.s,k,Modus.b) 
  ;k: ist der Schluessel und liegt zwischen 1 und 255 
  
  ;Modus: 
  ; - 0 : Chiffrierung 
  ; - 1 : DeChiffrierung 
  Ausg.s = "" 
  Select Modus 
    Case 0 
      For Position.l=1 To Len(Eing) 
        z$=Mid(Eing,Position,1) 
        var1=Asc(z$)+k 
        If var1>255 
          var1-256 
        EndIf 
        Ausg + Chr(var1) 
      Next 
    Case 1 
      For Position.l=1 To Len(Eing) 
        z$=Mid(Eing,Position,1) 
        var1=Asc(z$)+256-k 
        If var1>255 
          var1-256 
        EndIf 
        Ausg+Chr(var1) 
      Next 
  EndSelect 
  ProcedureReturn Ausg 
EndProcedure 

Text$="Ave Caesar" 
c$=CaesarChiffre(Text$,100,0) 
m$=CaesarChiffre(c$,100,1) 

MessageRequester("Chiffrierung","Original: "+Text$+Chr(13)+"Chiffriert: "+c$+Chr(13)+"DeChiffriert: "+m$,0)
; ExecutableFormat=Windows
; CursorPosition=3
; FirstLine=1
; EOF