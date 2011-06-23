; German forum: http://www.purebasic.fr/german/viewtopic.php?t=284&highlight=
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 08. October 2004
; OS: Windows
; Demo: Yes

; Noch kurz das nichtlineare XOR mit einem Neuronalen Netzwerk. 
;/ 3-schichtiges Neuronales Netzwerk für XOR 

#LD = 15000   ;Anz. Lerndurchläufe 
#TD = 400     ;Anz. Testdurchläufe 
#LK = 1.0     ;Lernkonstante (Hier: gut wenn gross, einfach ausprobieren!) 
#n  = 2       ;anzInputs 
#v  = 30      ;Anz. verb. Neuronen 
#a  = 1       ;Anz. Outputs 

;Statistik 
Global Dim Statist.f(#LD) 

;Gewichte 
Global Dim Gewichte1.f(#n, #v)   ;Gewichte von Inputs nach verb. Schicht 
Global Dim Gewichte2.f(#v, #a)   ;Gewichte von verb. Schicht nach Outputs 
;Outputs der Neuronen 
Global Dim Inputs.f(#n)    ;Inputneuronen 
Global Dim VNeurons.f(#v)  ;Verb. Neuronen 
Global Dim VFehler.f(#v)   ;Um die Fehler zu speichern (Fehler = Abweichung vom berechneten Solloutput) 
Global Dim Outputs.f(#a)   ;Outputneuronen 
Global Dim OFehler.f(#a)   ;Um die Fehler zu speichern (Fehler = Abweichung vom Solloutput) 

Global Dim SollOutputs.f(#a)  ;SollOutput 


;- Initialisierung 
Procedure Init_Gewichte()  ;Zufällig initialisieren, von -0.3 bis +0.3 
  For z1 = 0 To #n  ;von 0, da Verschiebungsgewicht auch initialisiert werden muss 
    For z2 = 0 To #v 
      Gewichte1(z1, z2) = Random(600) / 1000.0 - 0.3 
    Next 
  Next 
  
  For z1 = 0 To #v 
    For z2 = 0 To #a 
      Gewichte2(z1, z2) = Random(600) / 1000.0 - 0.3 
    Next 
  Next 
EndProcedure 


;- Input generieren 
Procedure XOREN(V1.l, V2.l) 
  ProcedureReturn V1 ! V2  ;Versuche noch mit |, & und finde die Unterschiede im Diagramm heraus! 
EndProcedure 

Procedure Generiere_Input()  ;Inputs() und SollOutputs() füllen 
  V1.l = Random(1) 
  V2.l = Random(1) 
  Inputs(1) = V1 
  Inputs(2) = V2 
  SollOutputs(1) = XOREN(V1, V2) 
EndProcedure 


;- Berechnen/Lernen/Anpassen 
Procedure Berechne_Outputs()   ;Vorwärts 
  For z1 = 1 To #v     ;für jedes Neuron der verb. Schicht 
    VNeurons(z1) = 0   ;mit 0 initialisieren 
    For z2 = 1 To #n   ;für jedes Neuron der Inputsschicht 
      VNeurons(z1) = VNeurons(z1) + Inputs(z2) * Gewichte1(z2, z1)    ;Aktivierung aufsummieren 
    Next 
    VNeurons(z1) = VNeurons(z1) + Gewichte1(0, 0)    ;und noch das Verschiebungsgewicht 
    VNeurons(z1) = 1.0 / (1.0 + Pow(2.718, -VNeurons(z1)))  ;Aktivierungsfunktion (sigmoide Funktion) => Output 
  Next 
  
  For z1 = 1 To #a     ;für jedes Neuron der Ausgabeschicht 
    Outputs(z1) = 0    ;mit 0 initialisieren 
    For z2 = 1 To #v   ;für jedes Neuron der verb. Schicht 
      Outputs(z1) = Outputs(z1) + VNeurons(z2) * Gewichte2(z2, z1)    ;Aktivierung aufsummieren 
    Next 
    Outputs(z1) = Outputs(z1) + Gewichte2(0, 0)    ;und noch das Verschiebungsgewicht 
    Outputs(z1) = 1.0 / (1.0 + Pow(2.718, -Outputs(z1)))    ;Aktivierungsfunktion (sigmoide Funktion) => Output 
  Next 
EndProcedure 

Procedure.f Berechne_Fehler()  ;Rückwärts 1, gibt den MaximalFehler zurück 
  Protected MaxFehler.f 
  
  For z = 1 To #a   ;Fehler für 2. Gewichtsschicht 
    OFehler(z) = (SollOutputs(z) - Outputs(z)) * Outputs(z) * (1.0 - Outputs(z))    ;fülle Fehler-Array der Outputschicht 
    If MaxFehler < Abs(OFehler(z)) 
      MaxFehler = Abs(OFehler(z)) 
    EndIf 
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
    For z2 = 0 To #n    ;für jedes Neuron der Eingabeschicht 
      Gewichte1(z2, z1) = Gewichte1(z2, z1) + (#LK * VFehler(z1)) * Inputs(z2)     ;die altbekannte Delta-Regel 
    Next 
  Next 
EndProcedure 



;- LERNE 
Init_Gewichte()   ;Gewichte auf Zufallswerte (nahe beieinander (-0.3 bis +0.3)) 


For z = 1 To #LD 
  Generiere_Input()    ;Inputs()-Array füllen und Solloutput generieren 
  Berechne_Outputs()   ;die Outputs der verschiedenen Schichten (verb.- und Ausgabe-) errechnen 
  Statist(z) = Berechne_Fehler()    ;die Fehler in die Fehlerarrays füllen 
    
  Gewichte_anpassen()  ;Aus Fehlern lernen! 
Next 



For z = 1 To #TD 
  Generiere_Input() 
  Berechne_Outputs() 
  
  If Outputs(1) + 0.1 > SollOutputs(1) And Outputs(1) - 0.1 < SollOutputs(1) 
    Richtige + 1 
  EndIf 
Next 


OpenWindow(0, 100, 100, 500, 200, "XOR mit Neuronalem Netzwerk", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
schritt = #LD / 400 
Repeat 
  z = 0 
  x = 0 
  StartDrawing(WindowOutput(0)) 
    DrawingMode(1) 
    FrontColor(RGB(255,0,0))
    DrawText(10, 20, "Max. Fehler") 
    DrawText(400, 160, "Zeit") 
    FrontColor(RGB(100,100,0))
    DrawText(200, 10, "Anzahl Richtige: "+StrF(Richtige / #TD * 100.0,1)+"%") 
    
    While z <= #LD 
      Plot(x + 50, 150 - (Statist(z) * 200.0), $FF0000) 
      x + 1 
      z + schritt 
    Wend 
    LineXY(50, 150, 455, 150, $FF) 
    LineXY(50, 50, 50, 150, $FF) 
  StopDrawing() 
  
Until WaitWindowEvent() = #PB_Event_CloseWindow 
CloseWindow(0) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger