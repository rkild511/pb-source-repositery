; German forum: http://www.purebasic.fr/german/viewtopic.php?t=534&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 22. October 2004
; OS: Windows
; Demo: Yes


; Simple Yes/No request:
; Einfache Ja/Nein-Abfrage (j/n): 

Procedure.l WaitKey2(string$) 
  ; waits until the users presses a key 
  ; specified in string$ 
  Repeat 
    asc = Asc(Inkey()) 
    If asc > 0 And asc < 127 
      If FindString(string$,Chr(asc),1) 
        key = asc 
      EndIf 
    EndIf 
    Delay(10) 
  Until key 
  ProcedureReturn key 
EndProcedure 

OpenConsole() 

PrintN(""):Print("Partition 'c:\' wirklich formatieren ? (j/n) ") 

key = WaitKey2("jJnN") : PrintN(""):PrintN("") 

If key='j' Or key='J' 
  Print("Formatierung.") 
  For a = 1 To 10 
    Print("."):Delay(500) 
  Next a 
  PrintN(" erfolgreich.") 
Else 
  PrintN("Formatierung wird nicht durchgeführt.") 
EndIf 

PrintN("<return>") 
WaitKey2(Chr(13))
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -