; www.PureArea.net
; Author: Andre Beer (updated for PB4.00 by blbltheworm)
; Date: 26. April 2003
; OS: Windows
; Demo: Yes


; *** Balken - und Liniendiagramm ***
; 26. April 2003 by Andre Beer / PureBasic-Team (www.purebasic.com/german)
; Danke und Greetings an Thorsten für Deinen Original-Code  :-)

;-Init
ImW.w = 800        ; Breite des Diagramms in Pixel  \ gilt hier aus als
ImH.w = 300        ; Hoehe des Diagramms in Pixel   / Fenstergroesse
MaxValue.w = 100   ; Maximaler Einzelwert in den Diagrammwerten
Graphs.w = 20      ; Anzahl der Balken/Linien im Diagramm
Color.l = -1       ; Farbe der Balken/Linien:
                   ; -1 für Zufallswerte  oder
                   ; RGB-Farbwert, wenn eine feste Farbe gewuenscht wird
                   ; Beispiel: Color.l = RGB(Rot,Gruen,Blau)  - Rot, Gruen, Blau mit Werten zwischen 0 und 255 ersetzen
;Color.l = RGB(250,200,0)                        


;-Strukturen
Structure DIAGRAMM 
  Farbe.l 
  Wert.l 
EndStructure 

; Array anlegen, xx Zahlen + 1 Bezugsgroesse 
Global Dim DiagrammData.DIAGRAMM(Graphs+1) 


;-Proceduren 
Procedure Balken(ID.l, Count.l, x.l, y.l, Breite.l, Hoehe.l, Titel.s) 
  ; ID     = Output-ID fuer Zeichenoperationen  (z.B. WindowOutput, ImageOutput, etc.)
  ; Count  = Werte-/Balkenanzahl
  ; x, y   = linke obere Ecke des Diagramms in Pixel
  ; Breite = Diagrammbreite in Pixel
  ; Hoehe  = Diagrammhoehe in Pixel, inkl. Titelzeile und Anzeige der Werte
  ; Titel  = String, der als Titelzeile oberhalb des Diagramms ausgegeben werden soll  
  
  FontID.l = LoadFont(1, "ARIAL", 10, #PB_Font_Bold | #PB_Font_HighQuality)
  FontID2.l = LoadFont(1, "ARIAL", 8, #PB_Font_Bold | #PB_Font_HighQuality)
  
  StartDrawing(ID) 

  ; Titelzeile ausgeben
  FrontColor(RGB(0,0,200))
  DrawingFont(FontID)
  DrawText((Breite-TextWidth(Titel))/2, y,Titel)
  y + 18
  DrawingFont(FontID2)

  FaktorHoehe.f = (Hoehe-2) / DiagrammData(0)\Wert
  Breite = Breite / Count
  x - Breite

  For Werte.l = 1 To Count 
    LeftX = x + (Werte * Breite)
    
    DrawingMode(4) 
    Box(LeftX + 1, y, Breite - 2, Hoehe, RGB(0,0,0)) 
    
    DrawingMode(0) 
    Box(LeftX + 2, Hoehe - (DiagrammData(Werte)\Wert * FaktorHoehe) - 1 + y, Breite - 4, DiagrammData(Werte)\Wert * FaktorHoehe, DiagrammData(Werte)\Farbe) 
    
    FrontColor(RGB(0,0,0))
    DrawText(LeftX + (Breite - TextWidth(Str(DiagrammData(Werte)\Wert)))/2, y + Hoehe,Str(DiagrammData(Werte)\Wert))
  Next Werte 
  
  StopDrawing() 
EndProcedure 


Procedure Linien(ID.l, Count.l, x.l, y.l, Breite.l, Hoehe.l, Titel.s) 
  ; ID     = Output-ID fuer Zeichenoperationen  (z.B. WindowOutput, ImageOutput, etc.)
  ; Count  = Werte-/Balkenanzahl
  ; x, y   = linke obere Ecke des Diagramms in Pixel
  ; Breite = Diagrammbreite in Pixel
  ; Hoehe  = Diagrammhoehe in Pixel, inkl. Titelzeile und Anzeige der Werte
  ; Titel  = String, der als Titelzeile oberhalb des Diagramms ausgegeben werden soll  
  
  Bezug.l = DiagrammData(0)\Wert * Hoehe / 100
  Space.f = (Breite - 2) / Count 

  Temp1.l = 0 
  Temp2.l = 0 
  Temp3.l = 0 
  
  FontID.l = LoadFont(1, "ARIAL", 10, #PB_Font_Bold | #PB_Font_HighQuality)
  FontID2.l = LoadFont(1, "ARIAL", 8, #PB_Font_Bold | #PB_Font_HighQuality)
  
  StartDrawing(ID) 

  ; Titelzeile ausgeben
  FrontColor(RGB(0,0,200))
  DrawingFont(FontID)
  DrawText((Breite-TextWidth(Titel))/2, y,Titel)
  y + 18
  DrawingFont(FontID2)
  
  DrawingMode(4) 
  Box(x, y, Breite, Bezug, RGB(0,0,0))  
  DrawingMode(0) 
  
  For Werte.l = 1 To Count 
    Temp1 = Bezug - (DiagrammData(Werte)\Wert * Hoehe / 100) + y 
    Temp2 = Bezug - (DiagrammData(Werte + 1)\Wert * Hoehe / 100) + y 
    Temp3 = x + 1 + ((Werte - 1) * Space) 
    
    If Werte = 1 
      LineXY(x + 1, Temp1, x + 1 + (Werte * Space), Temp2, DiagrammData(Werte)\Farbe) 
    Else 
      LineXY(Temp3, Temp1, x + 1 + (Werte * Space), Temp2, DiagrammData(Werte)\Farbe) 
    EndIf    
    
    FrontColor(RGB(0,0,0))
    DrawText(Temp3 - TextWidth(Str(DiagrammData(Werte)\Wert))/2, y + Hoehe,Str(DiagrammData(Werte)\Wert))
  Next Werte 
  
  StopDrawing() 
  
EndProcedure 


;- Diagrammdaten

; Bezugsgroesse festlegen 
DiagrammData(0)\Wert = MaxValue  ; Wert entspricht 100% Diagrammhoehe, muss mindestens dem groessten Einzelwert entsprechen!!!

; Daten-Array fuellen
For a=1 To Graphs
  Wert  = Random(MaxValue)
  Rot   = Random(255)
  Gruen = Random(255)
  Blau  = Random(255)
  DiagrammData(a)\Wert = Wert
  If Color = -1
    DiagrammData(a)\Farbe = RGB(Rot,Gruen,Blau)
  Else
    DiagrammData(a)\Farbe = Color
  EndIf
Next a


;-Main Programm 
OpenWindow(0,100,200,ImW,ImH,"Diagramme... ;-)",#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget) 

;-Image erstellen
If CreateImage(0,ImW,ImH)
  StartDrawing(ImageOutput(0))
  Box(0,0,ImW,ImH,$FFFFFF)
  StopDrawing()
Else
  Debug "Fehler beim Image erstellen..."
  End
EndIf


;-Diagramme aufrufen
Balken(ImageOutput(0), Graphs, 10, 5, ImW-30, ImH/2-45, "Balken-Diagramm")         ; Parameter: OutputID, Elemente, x, y, Breite, Hoehe
Linien(ImageOutput(0), Graphs, 10, Imh/2+5, ImW-30, ImH/2-45, "Linien-Diagramm")   ; Parameter: OutputID, Elemente, x, y, Breite, Hoehe


WinID.l = WindowID(0)
If CreateGadgetList(WinID)
  ImageGadget(0,2,2,300,220,ImageID(0))
EndIf


;- Hauptschleife
Repeat 

   Event = WaitWindowEvent() 

   Select Event 

      Case #PB_Event_CloseWindow 
         Quit = #True 

   EndSelect 

Until Quit 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -