; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1643&highlight=
; Author: wichtel (updated for PB4.00 by blbltheworm)
; Date: 08. July 2003
; OS: Windows
; Demo: No

; Umgebungsvariablen lesen und setzen 
; (gesetzte Umgebungsvariablen werden an Unterprozesse übergeben, 
;  bleiben aber nach Programmende nicht erhalten und können auch nicht 
;  von bereits laufenden Programmen gelesen werden) 

Structure envstruct 
  name.s 
  value.s 
EndStructure 

Global NewList env.envstruct() 


; gibt als Rückgabewert die Anzahl der Umgebungsvariablen zurück 
; braucht ein vorher angelegte LinkedList vom Typ envstruct 
Procedure.l myListEnv() 
  ret$="" 
  envcount.l=0 
  envblock.l=GetEnvironmentStrings_() 
  ClearList(env()) 
  Repeat 
    ret$=PeekS(envblock) 
    If ret$<>"" And Left(ret$,1)<>"=" And Left(ret$,1)<>":" 
      AddElement(env()) 
      env()\name=StringField(ret$,1,"=") 
      env()\value=StringField(ret$,2,"=") 
    EndIf 
    envblock+Len(ret$)+1 
  Until ret$="" 
  ProcedureReturn CountList(env()) 
EndProcedure 


; gibt als Rückgabewert den Wert der Umgebungsvariablen zurück 
; oder einenLeerstring wenn die Variable nicht existiert 
Procedure.s myGetEnv(name.s) 
  value.s=Space(256) 
  size.l=Len(value) 
  GetEnvironmentVariable_(@name, @value, @size) 
  ProcedureReturn(value) 
EndProcedure 

; gibt als Rückgabewert den Wert der Umgebungsvariablen zurück 
; oder einenLeerstring wenn das Setzen nicht geklappt hat 
Procedure.s mySetEnv(name.s,value.s) 
  If SetEnvironmentVariable_(@name, @value) 
    ProcedureReturn value 
  Else 
    ProcedureReturn ""  
  EndIf  
EndProcedure 



OpenConsole() 

; gezielt eine Umgebungsvariable abfragen 
PrintN("lesen...") 
PrintN("systemroot: "+myGetEnv("systemroot")) 

; eine Umgebungsvariable setzen 
PrintN("setzen...") 
PrintN("MeineVariable: "+mySetEnv("MeineVariable","MeinWert")) 



PrintN("") 
PrintN("Eingabe druecken...") 
Input() 
PrintN("") 


; alle Umgebungsvariablen in ein LinkedList und auflisten 
PrintN("Auflisten...") 
Anzahl.l=myListEnv() 
PrintN(Str(Anzahl)+" Umgebungsvariablen") 
PrintN("") 
ResetList(env()) 
While NextElement(env()) 
  PrintN(env()\name+": "+env()\value) 
  Delay(300) ; da kann man besser zuschauen 
Wend 


PrintN("") 
PrintN("Eingabe druecken...") 
Input() 

CloseConsole() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
