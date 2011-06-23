; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 17. February 2003
; OS: Windows
; Demo: Yes

;- Pack
; Dateien ausw�hlen, Namen geben und Packen: 
Global NewList DateienPacken.s() ;Damit man unbegrenzt viele Dateien packen kann, wird eine dynamisch verkn�pfte Liste erstellt. 
Pfad$ = "C:\" 

;Das Auswahlfenster f�r die zu packenden Dateien wird erstellt. #PB_Requester_MultiSelection = Auswahl mehrere Dateien m�glich.  
Datei$ = OpenFileRequester("Dateien zum Packen ausw�hlen", Pfad$, "Programme (*.exe)|*.exe", 0, #PB_Requester_MultiSelection) 

If Datei$ + Datei$                         ;Wenn eine Datei ausgew�hlt wurde... 
  AddElement(DateienPacken())              ;wird die Liste um ein Element erweitert... 
  DateienPacken() = Datei$                 ;und der Name der Datei in die Liste geschrieben 
  Repeat 
    WeitereDatei$ = NextSelectedFileName() ;Weitere Dateien k�nnen ausgew�hlt werden. 
    If WeitereDatei$ 
      AddElement(DateienPacken()) 
      DateienPacken() = WeitereDatei$ 
    EndIf 
  Until WeitereDatei$ = "" 
  ;Hier kann man den Namen der fertig gepackten Datei angeben 
  NamePackDat$ = InputRequester("Dateien Packen", "Wie lautet der Name der Pack-Datei?", "Datei.pac") 
Else  ;wurde keine Datei zum Packen ausgew�hlt, wird... 
  End ;das Programm beendet. 
EndIf 


ResetList(DateienPacken())                 ;Die Liste wird zur�ck gesetzt, damit man sie neu auslesen kann. 
If CreateFile(0, Pfad$ + "Liste.tmp")      ;Hier wird eine tempor�re Datei erstell, in der die Dateinamen gespeichert werden. 
  While NextElement(DateienPacken()) 
    Dateiname$ = GetFilePart(DateienPacken()) 
    WriteStringN(0,Dateiname$) 
  Wend 
EndIf 
CloseFile(0) 
    
If CreatePack(Pfad$ + NamePackDat$)        ;Die Pack-Datei wird erstellt. 
  AddPackFile(Pfad$ + "Liste.tmp")         ;Die tempor�re Datei zuerst reingeschrieben. 
  ResetList(DateienPacken())                
  While NextElement(DateienPacken())       ;Und jetzt alle Dateien, die in der Liste stehn. 
    If AddPackFile(DateienPacken(), 0): EndIf 
  Wend 
EndIf  
ClosePack() 

DeleteFile(Pfad$ + "Liste.tmp")            ;Nun kann die tempor�re Datei wieder gel�scht werden. 





;-Unpack
;Gepackte Datei aussuchen und wieder entpacken: 
Global NewList DateienEntpacken.s() ;Liste zum Entpacken erstellen 
Pfad$ = "C:\" 

;Auswahlfenster f�r die gepackte Datei 
PackDatei$ = OpenFileRequester("Dateien ausw�hlen", Pfad$, "Gepackte Dateien (*.pac)|*.pac", 0) 
If OpenPack(PackDatei$)                                 ;Gepackte Datei �ffnen. 
  *SpeicherAdresse = NextPackFile()                     ;Die erste Datei in eine Speicheadresse schreiben. 
  Groesse = PackFileSize()                              ;Die Groesse der Datei feststellen. 
  ;Die Datei auslesen lassen, damit man die Namen der gepackten Dateien erh�lt und in die Liste schreiben. 
  For Schleife = 1 To Groesse                            
    String$ = PeekS(*SpeicherAdresse, Groesse) 
    Position = FindString(String$, Chr(13), Schleife) 
    AddElement(DateienEntpacken()) 
    Laenge = Position - Schleife 
    DateienEntpacken() = Mid(String$, Schleife, Laenge) 
    Schleife = Schleife + Laenge + 1 
  Next Schleife    
Else 
  End 
EndIf 


If CreateDirectory("C:\Entpackt") :EndIf ;Ein Verzeichnis wird erstellt, in welches die Dateien entpackt werden sollen. 

ResetList(DateienEntpacken()) 
While NextElement(DateienEntpacken()) 
  *GepackteDatei = NextPackFile() 
  Groesse = PackFileSize() 
  If CreateFile(0, "C:\Entpackt\"+DateienEntpacken()) ;Eine Datei mit einem Namen aus der Liste wird erstellt. 
    WriteData(0,*GepackteDatei, Groesse)                ;Die Datein werden in die Datei geschrieben. 
  EndIf 
  CloseFile(0)                                        ;Datei schlie�en, damit eine neue erstellt werden kann. 
Wend 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -