; German forum: http://www.purebasic.fr/german/viewtopic.php?t=534&postdays=0&postorder=asc&start=10
; Author: Danilo
; Date: 22. October 2004
; OS: Windows
; Demo: Yes


; Eingabe limitieren auf eine 3-stellige Zahl: 

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

PrintN(""):Print("Bitte geben sie eine 3-stellige Nummer ein: ") 

For a = 1 To 3 
  key = WaitKey2("0123456789"+Chr(13)) 
  If key=13 ; return 
    Break 
  EndIf 
  Print(Chr(key)) 
  num$+Chr(key) 
Next a 

PrintN(""):PrintN(""):PrintN("Ihre Nummer: "+num$) 
PrintN("<return>") 
WaitKey2(Chr(13)) 

Debug Val(num$)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -