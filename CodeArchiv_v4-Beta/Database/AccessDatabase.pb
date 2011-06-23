; German forum: 
; Author: Logan5 (updated for PB 4.00 by Andre)
; Date: 30. November 2002
; OS: Windows, Linux
; Demo: Yes

;Autor logan5, 30. Nov 2002

If InitDatabase() 

  result = OpenDatabase(0,"Kasam Datenbank","maier","bravo") 



;-------------------------------------------------------------------------------------- 
; Was InitDatabase() bedeutet am besten in der hilfe nachschauen 
; result wird nur abgefragt um festzustellen ob die Datenbank ge�ffnet werden kann 
; 
; OpenDatabase(#Database, ODBCDatabaseName$, User$, Password$) 
; 
; #Database ist einfach eine nummer die man festlegt 
; ODBCDatabaseName$ jetzt wird's schwieriger, hier nicht die datenbank datei eintragen 
; sondern, den namen den ihr im odbc treiber f�r die datenbank vergeben habt 
; zu finden in einstellungen systemsteuerung odbc datenquelle system dsn 
; User$ und Password$ falls die access datei mit einem username und password 
; gesichert ist hier angeben, falls nicht ist v�llig egal was hier steht 
;-------------------------------------------------------------------------------------- 

  If result > 0 
    MessageRequester("Kasam Datenbank", "Kasam Datenbank ist offen",#PB_MessageRequester_Ok ) 
  EndIf 

;-------------------------------------------------------------------------------------- 
; Hier wird nur noch einmal ausgegeben, das die datenbank offen ist 
;-------------------------------------------------------------------------------------- 


  Abfrage$="Select * from stratab" 

;-------------------------------------------------------------------------------------- 
; Hier wird die abfrage f�r die datenbank formuliert diese braucht man sp�ter 
; f�r DatabaseQuery(Abfrage$) 
; wenn ich den befehl richtig verstanden hab bedeutet er w�hle (select) alles (*) 
; aus (from) der Tabelle stratab aus 
; stratab ist eine Tabelle aus der Access datei die ich abfragen will 
;-------------------------------------------------------------------------------------- 



  OpenConsole() 

;-------------------------------------------------------------------------------------- 
; in meinem beispiel m�chte ich den dateninhalt einfach nur ausgeben, also 
; �ffne ich hier eine console. genauso gut k�nnte man sie an ein array �bergeben oder 
; nach bestimmten s�tzen suchen 
;-------------------------------------------------------------------------------------- 


  If DatabaseQuery(0, Abfrage$) 

;-------------------------------------------------------------------------------------- 
; die erkl�rung f�r DatabaseQuery am besten in der hilfe nachschlagen 
;-------------------------------------------------------------------------------------- 



    While NextDatabaseRow(0) 

;-------------------------------------------------------------------------------------- 
; hier beginnt die abfrage meiner tabelle stratab (ist �brigens die abk�rzung f�r 
; strassennamen tabelle) 
; die tabelle beeinhaltet nur zwei spalten eine mit der strassen id und eine mit dem 
; strassennamen 
; ich muss die feldbezeichnung innerhalb der access datei gar nicht kennen, denn ich 
; rufe die erste spalte mit GetDatabaseString(0), die zweite mit GetDatabaseString(1) 
; usw. auf und speichere sie in freigew�hlten variablennamen unter purebasic mit einer 
; while wend schleife durchlaufe ich die ganze datei 
;-------------------------------------------------------------------------------------- 

      ID = GetDatabaseLong(0, 0) 
      Bezeichnung.s=RTrim(GetDatabaseString(0, 1)) 
;-------------------------------------------------------------------------------------- 
; in meinen beispiel gebe ich die daten nur auf dem bildschirm aus, der rest d�rfte 
; klar sein 
;-------------------------------------------------------------------------------------- 


      Print (Str(ID)) 
      Print(" ") 
      PrintN (Bezeichnung.s) 

    Wend 


  Else 
    MessageRequester("Fehler","ODCB Umgebung nicht vorhanden",#MB_ICONERROR) 
    End 
  EndIf 

CloseDatabase(0) 

CloseConsole()

EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger