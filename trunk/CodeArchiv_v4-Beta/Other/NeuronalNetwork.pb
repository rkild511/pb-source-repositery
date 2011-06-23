; German forum: http://www.purebasic.fr/german/viewtopic.php?t=284&highlight=
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 08. October 2004
; OS: Windows
; Demo: Yes

; Vorwort:
; Nach einiger Zeit habe ich mich nun wieder an die guten alten Neuronalen
; Netzwerke gemacht.
; Hab nun endlich ein 3-schichtiges Netzwerk hinbekommen (hoffe das alles stimmt)!
; Um es auf 4 Schichten zu erweitern wäre nun auch nur noch ein Kinderspiel.
; Konnte noch nicht viel damit rumspielen und hab deshalb nur mal wieder das
; alte, einfache Problem des Ellipsen- und Boxenunterscheidens geproggt. Das
; 2-schichtige Netz konnte das zwar auch und musste auch nicht so viel lernen,
; aber es soll ja nur ein Anfangsbeispiel sein (3-schichtige N. können nun auch
; nichtlineare Probleme lösen)!
; Vorsicht! Braucht ziemlich lange zum berechnen, deshalb vielleicht die
; #LD-Konstante runter setzen!

;/ 3-schichtiges Neuronales Netzwerk
; Eingabeschicht - Verborgene Schicht - Ausgabeschicht
; - Jedes Neuron der Eingabeschicht ist mit jedem Neuron der verborgenen Schicht verbunden
; - Jedes Neuron der verborgenen Schicht ist mit jedem Neuron der Ausgabeschicht verbunden
; - Jedes Neuron der verb.- und der Ausgabeschicht hat ein Verschiebungsgewicht (Gewicht wo immer Input = 1)
; - Weniger fehleranfällig, für nichtlineare Probleme der Form: y = f(x), braucht mehr Training


; als Aktivierungsfunktion habe ich diesmal die nichtlineare sigmoide Funktion gewählt:
; 1 / (1 + e^(-Aktivierung))
; sie bleibt zwischen 0 und 1, wird aber 0 und 1 nie erreichen!

; Zu #LD: für einen Fehler von 10% müsste die Anzahl Lerndurchläufe 10 mal
; grösser sein, als die Anzahl an Gewichten!!!  (Anz.Gewichte = #v * (#n * #n + #a)


; #Toleranz = 0.01   ;Zum herausfinden, wann genug gelernt wurde (habs auskommentiert)

#LD = 1000
; #LD = 77100 ;Anz. Lerndurchläufe
#TD = 400   ;Anz. Testdurchläufe
#LK = 0.1   ;Lernkonstante
#n  = 16    ;Wurzelvon(Anz. Inputs), Seitenlänge des Bildes
#v  = 300   ;Anz. verb. Neuronen
#a  = 1     ;Anz. Outputs, Achtung, wenn verändert, dann muss auch Generiere_Input() angepasst werden

;Gewichte
Global Dim Gewichte1.f(#n * #n, #v)   ;Gewichte von Inputs nach verb. Schicht
Global Dim Gewichte2.f(#v, #a)   ;Gewichte von verb. Schicht nach Outputs
;Outputs der Neuronen
Global Dim Inputs.f(#n * #n)    ;Inputneuronen
Global Dim VNeurons.f(#v)  ;Verb. Neuronen
Global Dim VFehler.f(#v)   ;Um die Fehler zu speichern (Fehler = Abweichung vom berechneten Solloutput)
Global Dim Outputs.f(#a)   ;Outputneuronen
Global Dim OFehler.f(#a)   ;Um die Fehler zu speichern (Fehler = Abweichung vom Solloutput)

Global Dim SollOutputs.f(#a)  ;Array mit den Bildern (1011110000011101)


;- Initialisierung
Procedure Init_Gewichte()  ;Zufällig initialisieren, von -0.3 bis +0.3
  For z1 = 0 To #n * #n  ;von 0, da Verschiebungsgewicht auch initialisiert werden muss
    For z2 = 0 To #v
      Gewichte1(z1, z2) = Random(600) / 1000.0 - 0.3
    Next
  Next

  For z1 = 0 To #v
    For z2 = 0 To #a
      Gewichte2(z1, z2) = Random(600) / 1000.0 - 0.3
    Next
  Next

  VNeurons(0) = 1
  Inputs(0)  = 1
EndProcedure


;- Input generieren
Global Image.l
Image = CreateImage(#PB_Any, #n, #n)

Procedure Generiere_Input(Image)
  StartDrawing(ImageOutput(Image))
    DrawingMode(0)
    Box(0, 0, #n, #n, 0)  ;Image löschen
    DrawingMode(4)
    zufall = Random(1)
    If zufall = 0         ;Ellipse
      Ellipse(Random(4) + 6, Random(4) + 6, Random(4) + 3, Random(4) + 3, $FFFFFF)
      SollOutputs(1) = 1.0    ;Outputneuron = 1
    ElseIf zufall = 1     ;Box
      Box(Random(6), Random(6), Random(5) + 5, Random(5) + 5, $FFFFFF)
      SollOutputs(1) = 0.0    ;Outputneuron = 0
    EndIf
  
    For z = 1 To #n * #n  ;Inputs()-Array füllen
      x = (z % #n) + 1
      y = z / #n
      farbe = Point(x, y)
      If farbe > 0
        Inputs(z) = 1.0
      Else
        Inputs(z) = 0.0
      EndIf
    Next
  StopDrawing()
EndProcedure


;- Berechnen/Lernen/Anpassen
Procedure Berechne_Outputs()   ;Vorwärts
  For z1 = 1 To #v     ;für jedes Neuron der verb. Schicht
    VNeurons(z1) = 0     ;mit 0 initialisieren
    For z2 = 1 To #n * #n   ;für jedes Neuron der Inputsschicht
      VNeurons(z1) = VNeurons(z1) + Inputs(z2) * Gewichte1(z2, z1)    ;Aktivierung aufsummieren
    Next
    For z3 = 1 To #v    ;und noch die Verschiebungsgewichte
      VNeurons(z1) = VNeurons(z1) + Gewichte1(0, z3)
    Next
    VNeurons(z1) = 1.0 / (1.0 + Pow(2.718, -VNeurons(z1)))  ;Aktivierungsfunktion (sigmoide Funktion) => Output
  Next

  For z1 = 1 To #a     ;für jedes Neuron der Ausgabeschicht
    Outputs(z1) = 0    ;mit 0 initialisieren
    For z2 = 1 To #v     ;für jedes Neuron der verb. Schicht
      Outputs(z1) = Outputs(z1) + VNeurons(z2) * Gewichte2(z2, z1)    ;Aktivierung aufsummieren
    Next
    For z3 = 1 To #a    ;und noch die Verschiebungsgewichte
      Outputs(z1) = Outputs(z1) + Gewichte2(0, z3)
    Next
    Outputs(z1) = 1.0 / (1.0 + Pow(2.718, -Outputs(z1)))    ;Aktivierungsfunktion (sigmoide Funktion) => Output
  Next
EndProcedure

Procedure.f Berechne_Fehler()  ;Rückwärts 1, gibt den MaximalFehler zurück
  Protected MaxFehler.f    ;um zu erkennen, wann der maximale Fehler innerhalb der Toleranz #Toleranz liegt

  For z = 1 To #a   ;Fehler für 2. Gewichtsschicht
    OFehler(z) = (SollOutputs(z) - Outputs(z)) * Outputs(z) * (1.0 - Outputs(z))    ;fülle Fehler-Array der Outputschicht

    ; If Abs(OFehler(z)) > Abs(MaxFehler)   ;Maximaler Fehler herausfinden
    ; MaxFehler = OFehler(z)
    ; EndIf
  Next

  For z1 = 1 To #v    ;für jedes Neuron der verb. Schicht
    Fehler1.f = 0     ;mit 0 initialisieren
    For z2 = 1 To #a  ;Fehler 1 berechnen
      Fehler1 = Fehler1 + OFehler(z2) * Gewichte2(z1, z2)  ;Fehler aufsummieren
    Next
    VFehler(z1) = VNeurons(z1) * (1.0 - VNeurons(z1)) * Fehler1    ;fülle Fehlerarray der verb. Schicht
  Next

  ProcedureReturn MaxFehler
EndProcedure

Procedure Gewichte_anpassen()  ;Rückwärts 2
  ;2. Gewichteschicht anpassen
  For z1 = 0 To #a    ;für jedes Neuron der Ausgabeschicht
    For z2 = 0 To #v    ;für jedes Neuron der verb. Schicht
      Gewichte2(z2, z1) = Gewichte2(z2,z1) + (#LK * OFehler(z1)) * VNeurons(z2)    ;die altbekannte Delta-Regel
    Next
  Next

  ;1. Gewichteschicht anpassen
  For z1 = 0 To #v    ;für jedes Neuron der verb. Schicht
    For z2 = 0 To #n * #n    ;für jedes Neuron der Eingabeschicht
      Gewichte1(z2, z1) = Gewichte1(z2, z1) + (#LK * VFehler(z1)) * Inputs(z2)     ;die altbekannte Delta-Regel
    Next
  Next
EndProcedure


;- LERNE
Init_Gewichte()   ;Gewichte auf Zufallswerte (nahe beieinander (-0.3 bis +0.3))
; anzInToleranz = 0

For z = 1 To #LD
  Generiere_Input(Image)    ;Inputs()-Array füllen und Solloutput generieren
  Berechne_Outputs()   ;die Outputs der verschiedenen Schichten (verb.- und Ausgabe-) errechnen
  Berechne_Fehler()    ;die Fehler in die Fehlerarrays füllen

  ; bereich.f = Berechne_Fehler()
  ; If Abs(bereich) <= #Toleranz
  ; anzInToleranz + 1
  ; EndIf
  ; If anzInToleranz >= 300
  ; Break
  ; EndIf

  Gewichte_anpassen()  ;Aus Fehlern lernen!
Next

OpenConsole()
PrintN("Training beendet!")
PrintN("")

;- TESTE
richtige = 0
OpenWindow(0,200,200,200,200,"",#PB_Window_SystemMenu)
For z = 1 To #TD
  Generiere_Input(Image)

  StartDrawing(WindowOutput(0))
    DrawImage(ImageID(Image),0,0,32,32)
  StopDrawing()

  Berechne_Outputs()
  If (SollOutputs(1) > 0.8 And Outputs(1) > 0.8) Or (SollOutputs(1) < 0.2 And Outputs(1) < 0.2)  ;hat ers auf 0.2 genau herausgefunden?
    richtige + 1
  EndIf

  Delay(20)

Next

StartDrawing(WindowOutput(0))
  DrawText(5, 40, "Close Window!")
StopDrawing()

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
CloseWindow(0)

PrintN("Test:")
PrintN("Richtige von " + Str(#TD) + ": " + Str(richtige))
PrintN("In Prozent: " + StrF(richtige / #TD * 100.0))


PrintN("")
PrintN("Taste drücken...")

Input()


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger