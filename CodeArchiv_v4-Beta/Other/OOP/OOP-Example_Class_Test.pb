; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2008&highlight=
; Author: NoOneKnows
; Date: 17. August 2003
; OS: Windows
; Demo: Yes

; Simple example for implementing OOP in PureBasic...
; Einfaches Beispiel zur Verwendung von OOP in PureBasic...

;- Einleitung:
; Einige von euch kennen sicherlich Sprachen wie C++, C#, Java und �hnliche. Sie alle haben
; etwas tolles an sich, n�mlich die objektorientierte Programmierung, die es in PureBasic
; leider net gibt. Jeder der schon mal OOP programmiert hat, wei� bestimmt auch die Vorteile
; zu sch�tzen, n�mlich vor allem �bersichtlichkeit und Wiederverwertbarkeit des Codes.
; In PureBasic und anderen Prozeduralen Programmiersprache auch passiert es dagegen bei
; gr��eren Projekten, das mit der Zeit der �berblick verloren geht. Der Code ist dann teilweise
; �berall wiederzufinden und nicht klar genug von einander getrennt. Also hab ich mir mal
; �berlegt wie OOP in PureBasic "von Hand" realisieren k�nnte. Was dabei rausgekommen ist
; hat an sich auch nicht viel mit OOP zu tun  Es ist alles mehr schlecht als Recht
; zusammenimprovisiert und fordert auf jeden Fall einiges an Disziplin vom Programmierer.
; Richtige objektorientierte Programmierung ist eben nur m�glich, wenn der Compiler selbst
; acht gibt, ob die OOP-Standards eingehalten werden usw. 

; Also erkl�r ich jetzt mal was ich mir da so zusammengreimt hab. Ein Beispiel hab ich weiter
; hinten auch mit eingef�gt. Also zur Theorie, wie k�nnte ein "Klasse" in PureBasic aufgebaut sein: 

; 1. Um die Eigenschaften einer Klasse festzulegen, empfiehlt sich eine Struktur. Dort k�nnen
;    alle Variablen quasi unter einem Dach abgelegt werden. 

; 2. Da neue Objekte bei der Deklaration zu anfang leer bzw. nicht zugewiesen sind, bietet sich
;    an, nur Pointer auf Strukturen zu verwenden und niemals den Speicherplatz f�r eine Klasse
;    selbst zu deklarieren. 

; 3. Um den Pointer f�r das Objekt zu f�llen, wird, wie in OOP-Sprachen �blich, eine "New"-Prozedur
;    bzw. ein Konstruktor f�r die Klasse gebraucht, die einen g�ltigen Pointer auf das Objekt zur�ck gibt. 

; 4. Um eine beliebige Anzahl an Objekten f�r eine Klasse erstellen zu k�nnen, w�re es ganz n�tzlich
;    LinkedLists in dem Zusammenhang zu verwenden. Die LinkedLists w�rden dann die jeweiligen
;    Strukturen der Klassen beinhalten. 

; 5. Soll ein Objekt wieder gel�scht werden so mu� dementsprechend das Objekt aus der LinkedList
;    entfernt und der Pointer zur Sicherheit auf 0 gesetzt werden. 

; 6. Methoden einer Klasse lassen sich nur �ber normale Prozeduren realisieren, die als
;    �bergabeparameter mindestens das Objekt ben�tigen. 

; Also br�uchte eine Klasse im Moment eine Struktur, eine LinkedList, eine New-Prozedur und eine
; Delete-Prozedur plus eventueller Methoden. 

; So, bevor man nun aber �berhaupt eine Klasse erstellt, sollte es vielleicht eine Art Basis-Objekt
; geben, wie es auch in einigen OOP-Sprachen �blich ist. Aus diesem Basis-Objekt mu� von der Theorie
; her jedes beliebige Objekt einer Klasse erstellt werden k�nnen. Also ist es notwendig zu wissen,
; welcher Klasse das Basis-Objekt angeh�rt. Und um dies feststellen zu k�nnen, braucht jedes Objekt
; eine Eigenschaft, die die Klasse identifiziert. Daraus folgt nun, da� es eine Struktur "Object"
; gibt, die als einzige Eigenschaften den Klassentyp beinhaltet bzw. zus�tzlichen noch ein bisschen
; Speicher f�r die anderen Klassen reserviert. 

; Bevor man nun anf�ngt Konstanten f�r den Klassentyp festzulegen ist es, denk ich, wesentlich
; n�tzlicher eine Art Klassenprozedur zu erfinden, die neben der Identifizierung einer Klasse,
; gleichzeitig zu unterschiedlichen Zwecken aufgerufen werden kann. Also w�rde nun im Klassentyp
; ein Pointer auf die Klassenprozedur hinterlegt werden. �ber die Klassenprozedur k�nnte zum
; Beispiel auch der Code f�r die Erzeugung einer neuen Instanz bzw. dem L�schen eines Objekts
; hinterlegt werden. So verf�gt also letztendlich jede Klasse als erste Variable in der Struktur
; immer den Klassentyp. Damit ist gew�hrleistet das der Klassentyp immer korrekt gesetzt und
; ausgelesen werden kann. 

; Eine anderes sch�nes Feature von OOP ist unter anderem die Vererbung von Klassen. Mit dem oben
; genannten Prinzip ist dies leicht zu verwirklichen: Damit eine vererbte Klasse voll kompatibel
; zu seiner Basis-Klasse ist m�ssen (!) alle Variablen der Basis-Klassen-Struktur exakt in der
; selben Reihenfolge f�r die Struktur der abgeleitete Klasse �bernommen werden. Dar�ber hinaus
; k�nnen nat�rlich weitere Variablen hinzugef�gt werden. Aber dadurch das die abgeleitet Klasse
; exakt �ber die selben Eigenschaften der Basis-Klasse verf�gt kann jede Methode der Basis-Klasse
; auch f�r die abgeleitete Klasse aufgerufen werden. Dies ist in dem Moment der entscheidende
; Vorteil, es l�sst sich also wirklich auf der Basis-Klasse aufbauen. 

; Allerdings ist diese Form der Vererbung etwas Fehleranf�llig, zum Beispiel sobald die Eigenschaften
; der Basis-Klasse ver�ndert werden, m�sste auch die abgeleitetetn Klassen angepasst werden. Besser
; w�re es daher theoretisch einfach die Struktur der Basis-Klasse mit in die Struktur der abgeleiteten
; Klasse zu �bernehmen. Jedoch w�rde in dem moment die Handhabung etwas schwieriger, gerade auch wenn
; mehrmals in Reihe abgeleitet wird. Dadurch entstehen Ausr�cke wie
; "MeineKlasse\Klasse3\Klasse2\Klasse1\Variable = 7". Kommt aber der objektorientierung von der Logik
; her um einiges n�her. 

; Soviel zur Theorie, hier folgt jetzt das Beispiel. Hab oben im wesentlich erkl�rt was hier in etwa
; vorgeht. Aufgeteilt ist der Code urspr�nglich in 2 Dateien: 

;- Nachsatz:
; Das hier ist insgesamt auch nur ein Ansatz f�r OOP unter PureBasic.
; Erstens ist es nicht richtig sicher und zweitens fehlen auch noch
; viele Merkmale von OOP. Trotzdem ist es vielleicht eine interessante
; Idee, wie man damit etwas �bersichtlichkeit schaffen k�nnte.


;- Beispiel:
IncludeFile "OOP-Example_Class_Template.pb" 

OpenConsole() 

*out.ClassText = NewText("Dies ist ein Testtext") 
cTxtPrintN(*out) 

*out\text$ = "Nu is der Text anders, aber veraendert gegen das Prinzip von OOP" 
cTxtPrintN(*out) 

cTxtSetText(*out, "So ists eigentlich richtig!") 
cTxtPrintN(*out) 

PrintN("") 
PrintN("*out vor  dem Referziellen Loeschen: " + Str(*out)) 
DeleteRefObject(@*out) ;Object wieder l�schen (rerferenz auf die Klasse wird entfernt, Pointer wird genullt) 
PrintN("*out nach dem Referziellen Loeschen: " + Str(*out)) 
PrintN("") 


*colorOut.ClassColorText = NewColorText("Dat hier is farbisch, und basiert auf ClassText", 11, 1) 
cClrTxtPrintN(*colorOut) 

cTxtSetText(*colorOut, "Nun nicht mehr farbig...") 
cTxtPrintN(*colorOut) 

DeleteObjectText(@*colorOut) ;kann auch �ber die Klassen-Delete-prozedur direkt gel�scht werden 

PrintN("") 

*objOut.Object = NewObject(@Object()) ;Achtung dieses Objekt ist dannach keiner Klasse zugeordnet 
cTxtSetText(*objOut, "Dieser Text kommt aus einem reinen 'Object'") 
cTxtPrintN(*objOut) 
DeleteRefObject(@*objOut) 

*objOut = NewObject(@ClassText()) ;dieses Objekt wird der Klasse Text zugewiesen 
cTxtSetText(*objOut, "Dieser Text kommt aus einem 'Object' das der 'ClassText' zugewiesen wurde") 
cTxtPrintN(*objOut) 
If *objOut\class = @ClassText() 
    PrintN("Dieses Objekt wurde wirklich aus der Klasse Text instanziert") 
EndIf 

;DeleteRefObject(@*objOut) 

PrintN("") 

*altOut.ClassAlternativeColorText = NewAlternativeColorText("Alternative ColorText-Klasse, kommt dem OOP von der Logik her naeher", 11, 1) 
cAltClrTxtPrintN(*altOut) 
cTxtPrintN(*altOut\ClassText) 
;DeleteRefObject(@*altOut) 

PrintN("") 
PrintTextN(*objOut) 
PrintTextN(*altOut) 

DeleteRefObject(@*objOut) 
DeleteRefObject(@*altOut) 

Input() 
CloseConsole() 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
