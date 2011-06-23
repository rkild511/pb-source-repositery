; German forum: http://www.purebasic.fr/german/viewtopic.php?t=534&postdays=0&postorder=asc&start=10
; Author: Danilo
; Date: 22. October 2004
; OS: Windows
; Demo: Yes


; Hier noch ein kleines Beispiel für die Eingabe einer maximal 
; 6-stelligen Zahl, wobei korrigieren per Backspace erlaubt ist: 
 
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

OpenConsole():ClearConsole() 

For a = 1 To 6: Line$+Chr(196): Next a 
PrintN(Space(44)+Chr(218)+Line$+Chr(191)) 
PrintN("Bitte geben sie eine 6-stellige Nummer ein: "+Chr(179)+"      "+Chr(179)) 
PrintN(Space(44)+Chr(192)+Line$+Chr(217)) 
ConsoleLocate(50,1) 

Repeat 
  key = WaitKey2("0123456789"+Chr(13)+Chr(8)) 
  If key=13 ; return 
    Break 
  ElseIf key=8 ; backspace 
    num$=Left(num$,Len(num$)-1) 
  Else 
    num$+Chr(key) 
  EndIf 
  ConsoleLocate(45,1) 
  Print(RSet(num$,6," ")) 
  ConsoleLocate(50,1) 
Until Len(num$)=6 

PrintN(""):PrintN(""):PrintN("<return>") 
WaitKey2(Chr(13)) 

Debug Val(num$)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -