; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2008&highlight=
; Author: NoOneKnows
; Date: 17. August 2003
; OS: Windows
; Demo: Yes

; Simple example for implementing OOP in PureBasic...
; Einfaches Beispiel zur Verwendung von OOP in PureBasic...

;- Einleitung:
; Einige von euch kennen sicherlich Sprachen wie C++, C#, Java und ähnliche. Sie alle haben
; etwas tolles an sich, nämlich die objektorientierte Programmierung, die es in PureBasic
; leider net gibt. Jeder der schon mal OOP programmiert hat, weiß bestimmt auch die Vorteile
; zu schätzen, nämlich vor allem Übersichtlichkeit und Wiederverwertbarkeit des Codes.
; In PureBasic und anderen Prozeduralen Programmiersprache auch passiert es dagegen bei
; größeren Projekten, das mit der Zeit der Überblick verloren geht. Der Code ist dann teilweise
; überall wiederzufinden und nicht klar genug von einander getrennt. Also hab ich mir mal
; überlegt wie OOP in PureBasic "von Hand" realisieren könnte. Was dabei rausgekommen ist
; hat an sich auch nicht viel mit OOP zu tun  Es ist alles mehr schlecht als Recht
; zusammenimprovisiert und fordert auf jeden Fall einiges an Disziplin vom Programmierer.
; Richtige objektorientierte Programmierung ist eben nur möglich, wenn der Compiler selbst
; acht gibt, ob die OOP-Standards eingehalten werden usw. 

; Also erklär ich jetzt mal was ich mir da so zusammengreimt hab. Ein Beispiel hab ich weiter
; hinten auch mit eingefügt. Also zur Theorie, wie könnte ein "Klasse" in PureBasic aufgebaut sein: 

; 1. Um die Eigenschaften einer Klasse festzulegen, empfiehlt sich eine Struktur. Dort können
;    alle Variablen quasi unter einem Dach abgelegt werden. 

; 2. Da neue Objekte bei der Deklaration zu anfang leer bzw. nicht zugewiesen sind, bietet sich
;    an, nur Pointer auf Strukturen zu verwenden und niemals den Speicherplatz für eine Klasse
;    selbst zu deklarieren. 

; 3. Um den Pointer für das Objekt zu füllen, wird, wie in OOP-Sprachen üblich, eine "New"-Prozedur
;    bzw. ein Konstruktor für die Klasse gebraucht, die einen gültigen Pointer auf das Objekt zurück gibt. 

; 4. Um eine beliebige Anzahl an Objekten für eine Klasse erstellen zu können, wäre es ganz nützlich
;    LinkedLists in dem Zusammenhang zu verwenden. Die LinkedLists würden dann die jeweiligen
;    Strukturen der Klassen beinhalten. 

; 5. Soll ein Objekt wieder gelöscht werden so muß dementsprechend das Objekt aus der LinkedList
;    entfernt und der Pointer zur Sicherheit auf 0 gesetzt werden. 

; 6. Methoden einer Klasse lassen sich nur über normale Prozeduren realisieren, die als
;    Übergabeparameter mindestens das Objekt benötigen. 

; Also bräuchte eine Klasse im Moment eine Struktur, eine LinkedList, eine New-Prozedur und eine
; Delete-Prozedur plus eventueller Methoden. 

; So, bevor man nun aber überhaupt eine Klasse erstellt, sollte es vielleicht eine Art Basis-Objekt
; geben, wie es auch in einigen OOP-Sprachen üblich ist. Aus diesem Basis-Objekt muß von der Theorie
; her jedes beliebige Objekt einer Klasse erstellt werden können. Also ist es notwendig zu wissen,
; welcher Klasse das Basis-Objekt angehört. Und um dies feststellen zu können, braucht jedes Objekt
; eine Eigenschaft, die die Klasse identifiziert. Daraus folgt nun, daß es eine Struktur "Object"
; gibt, die als einzige Eigenschaften den Klassentyp beinhaltet bzw. zusätzlichen noch ein bisschen
; Speicher für die anderen Klassen reserviert. 

; Bevor man nun anfängt Konstanten für den Klassentyp festzulegen ist es, denk ich, wesentlich
; nützlicher eine Art Klassenprozedur zu erfinden, die neben der Identifizierung einer Klasse,
; gleichzeitig zu unterschiedlichen Zwecken aufgerufen werden kann. Also würde nun im Klassentyp
; ein Pointer auf die Klassenprozedur hinterlegt werden. Über die Klassenprozedur könnte zum
; Beispiel auch der Code für die Erzeugung einer neuen Instanz bzw. dem Löschen eines Objekts
; hinterlegt werden. So verfügt also letztendlich jede Klasse als erste Variable in der Struktur
; immer den Klassentyp. Damit ist gewährleistet das der Klassentyp immer korrekt gesetzt und
; ausgelesen werden kann. 

; Eine anderes schönes Feature von OOP ist unter anderem die Vererbung von Klassen. Mit dem oben
; genannten Prinzip ist dies leicht zu verwirklichen: Damit eine vererbte Klasse voll kompatibel
; zu seiner Basis-Klasse ist müssen (!) alle Variablen der Basis-Klassen-Struktur exakt in der
; selben Reihenfolge für die Struktur der abgeleitete Klasse übernommen werden. Darüber hinaus
; können natürlich weitere Variablen hinzugefügt werden. Aber dadurch das die abgeleitet Klasse
; exakt über die selben Eigenschaften der Basis-Klasse verfügt kann jede Methode der Basis-Klasse
; auch für die abgeleitete Klasse aufgerufen werden. Dies ist in dem Moment der entscheidende
; Vorteil, es lässt sich also wirklich auf der Basis-Klasse aufbauen. 

; Allerdings ist diese Form der Vererbung etwas Fehleranfällig, zum Beispiel sobald die Eigenschaften
; der Basis-Klasse verändert werden, müsste auch die abgeleitetetn Klassen angepasst werden. Besser
; wäre es daher theoretisch einfach die Struktur der Basis-Klasse mit in die Struktur der abgeleiteten
; Klasse zu übernehmen. Jedoch würde in dem moment die Handhabung etwas schwieriger, gerade auch wenn
; mehrmals in Reihe abgeleitet wird. Dadurch entstehen Ausrücke wie
; "MeineKlasse\Klasse3\Klasse2\Klasse1\Variable = 7". Kommt aber der objektorientierung von der Logik
; her um einiges näher. 

; Soviel zur Theorie, hier folgt jetzt das Beispiel. Hab oben im wesentlich erklärt was hier in etwa
; vorgeht. Aufgeteilt ist der Code ursprünglich in 2 Dateien: 

;- Nachsatz:
; Das hier ist insgesamt auch nur ein Ansatz für OOP unter PureBasic.
; Erstens ist es nicht richtig sicher und zweitens fehlen auch noch
; viele Merkmale von OOP. Trotzdem ist es vielleicht eine interessante
; Idee, wie man damit etwas Übersichtlichkeit schaffen könnte.


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
DeleteRefObject(@*out) ;Object wieder löschen (rerferenz auf die Klasse wird entfernt, Pointer wird genullt) 
PrintN("*out nach dem Referziellen Loeschen: " + Str(*out)) 
PrintN("") 


*colorOut.ClassColorText = NewColorText("Dat hier is farbisch, und basiert auf ClassText", 11, 1) 
cClrTxtPrintN(*colorOut) 

cTxtSetText(*colorOut, "Nun nicht mehr farbig...") 
cTxtPrintN(*colorOut) 

DeleteObjectText(@*colorOut) ;kann auch über die Klassen-Delete-prozedur direkt gelöscht werden 

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
