; www.PureArea.net
; Author: Andre Beer + Thorsten Sommer (updated for PB4.00 by blbltheworm)
; Date: 08. April 2003
; OS: Windows
; Demo: Yes


; *** Balken - und Liniendiagramm ***
; Original-Code:  06. April 2003 by Thorsten
; Verbesserungen: 07. April 2003 by Andre
; Bugfix: 08. April 2003 by Andre


;-Diagrammgroesse (in Pixel) einstellen, gilt hier auch als Fenstergroesse
ImW.w=400     ; Breite
ImH.w=300     ; Hoehe


;-Definitionen 
Structure DIAGRAMM 
  Farbe.l 
  Wert.l 
EndStructure 

;Array anlegen, 9 Zahlen + 1 Bezugsgrösse 
Global Dim DiagrammData.DIAGRAMM(10) 


;-Proceduren 
Procedure Balken(ID.l, Count.l, x.l, y.l, Breite.l, Hoehe.l) 
  ; ID     = Output-ID für Zeichenoperationen  (z.B. WindowOutput, ImageOutput, etc.)
  ; Count  = Werte-/Balkenanzahl
  ; x, y   = linke obere Ecke des Diagramms in Pixel
  ; Breite = Diagrammbreite in Pixel
  ; Hoehe  = Diagrammhöhe in Pixel
  
  Bezug.l = DiagrammData(0)\Wert * Hoehe / 100

  Breite = Breite / Count
  x - Breite

  StartDrawing(ID) 

  For Werte.l = 1 To Count 
    DrawingMode(4) 
    Box(x + (Werte * Breite) + 1, y, Breite - 2, Bezug, RGB(0,0,0)) 
    
    DrawingMode(0) 
    Box(x + (Werte * Breite) + 1, Bezug - (DiagrammData(Werte)\Wert * Hoehe / 100) + y + 1, Breite - 2, (DiagrammData(Werte)\Wert * Hoehe / 100) - 2, DiagrammData(Werte)\Farbe) 
  Next Werte 
  
  StopDrawing() 
  
EndProcedure 

Procedure Linien(ID.l, Count.l, x.l, y.l, Breite.l, Hoehe.l) 
  ; ID     = Output-ID für Zeichenoperationen  (z.B. WindowOutput, ImageOutput, etc.)
  ; Count  = Werte-/Balkenanzahl
  ; x, y   = linke obere Ecke des Diagramms in Pixel
  ; Breite = Diagrammbreite in Pixel
  ; Hoehe  = Diagrammhöhe in Pixel
  
  Bezug.l = DiagrammData(0)\Wert * Hoehe / 100
  Space.f = (Breite - 2) / Count 

  Temp1.l = 0 
  Temp2.l = 0 
  Temp3.l = 0 
  
  StartDrawing(ID) 
  
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
    
  Next Werte 
  
  StopDrawing() 
  
EndProcedure 


;- Diagrammdaten

;Die Bezugsgrösse festlegen 
DiagrammData(0)\Wert = 100 

;Die Daten eingeben 
DiagrammData(1)\Wert = 10 
DiagrammData(1)\Farbe = RGB(0,0,0) 

DiagrammData(2)\Wert = 100 
DiagrammData(2)\Farbe = RGB(0,66,66) 

DiagrammData(3)\Wert = 33 
DiagrammData(3)\Farbe = RGB(255,0,66) 

DiagrammData(4)\Wert = 55 
DiagrammData(4)\Farbe = RGB(255,0,0) 

DiagrammData(5)\Wert = 11 
DiagrammData(5)\Farbe = RGB(0,120,20) 

DiagrammData(6)\Wert = 1 
DiagrammData(6)\Farbe = RGB(30,10,66) 

DiagrammData(7)\Wert = 6 
DiagrammData(7)\Farbe = RGB(0,0,150) 

DiagrammData(8)\Wert = 89 
DiagrammData(8)\Farbe = RGB(0,0,12) 

DiagrammData(9)\Wert = 17 
DiagrammData(9)\Farbe = RGB(0,0,255) 


;-Main Programm 
OpenWindow(0,100,200,ImW,ImH,"Window#0",#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget) 

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
Balken(ImageOutput(0), 9, 10, 10, ImW-30, ImH/2-20)         ; Parameter: OutputID, Elemente, x, y, Breite, Höhe
Linien(ImageOutput(0), 9, 10, Imh/2+10, ImW-30, ImH/2-20)   ; Parameter: OutputID, Elemente, x, y, Breite, Höhe


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