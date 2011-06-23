; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3248&highlight=
; Author: Christian (updated for PB3.93 by ts-soft + Andre, updated for PB4.00 by Andre)
; Date: 27. December 2003
; OS: Windows
; Demo: Yes

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  *************************************************************************** ~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
;   Polygon2D Drawing Prozeduren (ver. 1.00)
;        2003 by Christian Stolze
;
;        With this procedures you can fast & easily draw polygons with unlimited
;        corner-points. But its only possible for 2D drawing operations.
;
;        Mit diesen Prozeduren können relativ schnell und einfach Polygone mit
;        bliebig vielen Eckpunkten gezeichnet werden. Dies ist jedoch nur für
;        2D Zeichenoperationen möglich.
;
;        Erstellt am 27.12.2003
;
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  *************************************************************************** ~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Procedure InitPolygonDrawing()     ; Initialisierung für die Polygonlibrary
  Structure Vertex                 ; Struktur für die LinkedLists in denen VertexDaten gespeichert werden
    PID.l
    ID.l
    x.l
    y.l
  EndStructure
  
  Global NewList PolygonPoints.Vertex()     ; LinkedList zum Speichern der Vertex-Kooardinaten der Polygon-Eckpunkte
  Global NewList PolygonDrawBuffer.Vertex() ; Zwischenspeicher für spätere Zeichenarbeiten
  
;  If PolygonPoints()
;    If PolygonDrawBuffer()
;      result.l = PolygonPoints() + PolygonDrawBuffer()
;    Else
;      result.l = -1
;    EndIf
;  Else
    result.l = -1
;  EndIf
  ProcedureReturn result.l
EndProcedure

Procedure.l SetPolygonPoint(PolygonID.l, ID.l, x.l, y.l) ; Setzen eines Eckpunktes
  ResetList(PolygonPoints())
  While NextElement(PolygonPoints())
    If PolygonPoints()\ID = ID.l And PolygonPoints()\PID = PolygonID.l
      result.l = -1
    Else
      result.l = 0
    EndIf
  Wend
  
  If result <> -1                                         ; Speichert die Eckpunktdaten in die LinkedList
    AddElement(PolygonPoints())
    PolygonPoints()\PID = PolygonID.l
    PolygonPoints()\ID = ID.l
    PolygonPoints()\x = x.l
    PolygonPoints()\y = y.l
  EndIf
  
  ProcedureReturn result.l
EndProcedure

Procedure.l DeletePolygonPoint(PolygonID.l, ID.l)        ; Löscht einen Eckpunkt mit der ID.l aus dem angegebenem Polygon
  ResetList(PolygonPoints())
  While NextElement(PolygonPoints())                     ; durchsucht die LinkedList nach dem angegeben Punkt
    If PolygonPoints()\ID = ID.l And PolygonPoints()\PID = PolygonID.l
      DeleteElement(PolygonPoints())
      result.l = 0
    Else
      result.l = -1
    EndIf
  Wend
  
  ProcedureReturn result.l                              ; gibt -1 zurück, wenn der Eckpunkt nicht gelöscht werden konnte.(ansonsten 0)
EndProcedure

Procedure.l MovePolygonPoint(PolygonID.l, ID.l, NewID.l, NewX.l, NewY.l) ; ändert die Daten eines Eckpunktes (ID.l) innerhalb des Polygons (PolygonID.l)
  ResetList(PolygonPoints())
  While NextElement(PolygonPoints())                                     ; LinkedList wird nach dem Eckpunkt durchsucht
    If PolygonPoints()\ID = ID.l And PolygonPoints()\PID = PolygonID.l
      result.l = 0
      DeleteElement(PolygonPoints())                                      ; wurde er gefunden, wird er gelöscht ...
      Break
    Else
      result.l = -1
    EndIf
  Wend
  If result.l <> -1
    SelectElement(PolygonPoints(), ID.l-1)
    AddElement(PolygonPoints())                                            ; ... und nun wieder mit neuen Daten hinzugefügt
    PolygonPoints()\ID = NewID.l
    PolygonPoints()\x = NewX.l
    PolygonPoints()\y = NewY.l
  EndIf
  ProcedureReturn result.l
EndProcedure

Procedure CreatePolygon(PolygonID.l, Width.l, Height.l, BorderColor.l)    ; Zeichnen eines Polygons
  Protected last.l
  Protected VertexX.l, VertexY.l, VertexX1.l, VertexY1.l, VertexX2.l, VertexY2.l
  
  CreateSprite(PolygonID.l, Width.l, Height.l)                             ; Sprite auf dem das Polygon gezeichnet wird, wird erstellt
  
  ClearList(PolygonDrawBuffer())                                           ; Zwischenspeicher wird gelöscht
  ResetList(PolygonPoints())                                               ; Alle Eckpunkte des angegeben Polygons (PolygonID.l) werden gesucht ...
  While NextElement(PolygonPoints())
    If PolygonPoints()\PID = PolygonID.l
      AddElement(PolygonDrawBuffer())                                      ; ... und in den Zwischenspeicher eingefügt
      PolygonDrawBuffer()\PID = PolygonPoints()\PID
      PolygonDrawBuffer()\ID = PolygonPoints()\ID
      PolygonDrawBuffer()\x = PolygonPoints()\x
      PolygonDrawBuffer()\y = PolygonPoints()\y
    EndIf
  Wend
  
  ;  ResetList(PolygonDrawBuffer())                                        ; kann einkommentiert werden, um die Eckpunkte
  ;  While NextElement(PolygonDrawBuffer())                                ; des Polygons mit Kreisen zu markieren
  ;    VertexX.l = PolygonDrawBuffer()\x
  ;    VertexY.l = PolygonDrawBuffer()\y
  ;    If StartDrawing(SpriteOutput(PolygonID.l))
  ;        Circle(VertexX.l, VertexY.l, 5, BorderColor.l)
  ;       StopDrawing()
  ;    EndIf
  ;   Wend
  
  ResetList(PolygonDrawBuffer())                                           ; erster und damit letzten Eckpunkt wird ausgelesen und die Koordinaten gespeichert
  NextElement(PolygonDrawBuffer())                                         ; (wird zum Schluß noch gebraucht)
  VertexX.l = PolygonDrawBuffer()\x
  VertexY.l = PolygonDrawBuffer()\y
  
  ResetList(PolygonDrawBuffer())                                           ; nun werden nacheinander die Koordinaten der Punkte ausgelesen
  While NextElement(PolygonDrawBuffer())
    VertexX1.l = PolygonDrawBuffer()\x
    VertexY1.l = PolygonDrawBuffer()\y
    If NextElement(PolygonDrawBuffer())
      VertexX2.l = PolygonDrawBuffer()\x
      VertexY2.l = PolygonDrawBuffer()\y
      PreviousElement(PolygonDrawBuffer())
    ElseIf last.l = 0                                                    ; hier werden die Koordinaten der ersten und letzten Elementes wieder in einer weitere
      VertexX1.l = VertexX2.l                                             ; Variable gespeichert um das Polygon abzuschließen
      VertexY1.l = VertexY2.l                                             ; und somit den (vor)letzten Eckpunkt wieder mit dem ersten(/letzten)
      VertexX2.l = VertexX.l                                              ; verbinden zu können
      VertexY2.l = VertexY.l
      last.l = 1
    EndIf
    If StartDrawing(SpriteOutput(PolygonID.l))                            ; hier werden jeweils 2 Eckpunkte mit einer Linie verbunden
      LineXY(VertexX1.l, VertexY1.l, VertexX2.l, VertexY2.l, BorderColor.l)
      StopDrawing()
    EndIf
  Wend
EndProcedure

Procedure DeletePolygon(PolygonID.l)                                     ; Löscht alle Eckpunkte des angegebenen Polygons aus der LinkedList
  ResetList(PolygonPoints())
  While NextElement(PolygonPoints())
    If PolygonPoints()\PID = PolygonID.l
      DeleteElement(PolygonPoints())
    EndIf
  Wend
EndProcedure

Procedure SetPolygonColor(PolygonID.l, x.l, y.l, OutlinColor.l, Color.l) ; Füllt das angegebene Polygon vom Punkt x,y aus mit der Farbe Color.l bis die
  If StartDrawing(SpriteOutput(PolygonID.l))                              ; bis die Randfarbe (OutlinColor.l) auftritt
    FillArea(x.l, y.l, OutlinColor.l, Color.l)
    StopDrawing()
  EndIf
EndProcedure

Procedure DisplayPolygon(PolygonID.l, x.l, y.l)                          ; Zeigt das angegebene Polygon(/Sprite) auf dem Bildschirm an
  DisplaySprite(PolygonID.l, x.l, y.l)
EndProcedure

Procedure DisplayTransparentPolygon(PolygonID.l, x.l, y.l, Red.l, Green.l, Blue.l) ; Zeigt das angegebene Polygon(/Sprite) auf dem Bildschirm an
  TransparentSpriteColor(PolygonID.l, RGB(Red.l, Green.l, Blue.l))           ; wobei die angegebene Farbe Transparent dargestellt wird
  DisplayTransparentSprite(PolygonID.l, x.l, y.l)
EndProcedure

Procedure.l GetPolygonPointX(PolygonID.l, ID.l)                         ; Ausgabe der X-Koordinate eines Eckpunktes
  ResetList(PolygonPoints())
  While NextElement(PolygonPoints())                                      ; LinkedList wird nach dem Eckpunkt durchsucht
    If PolygonPoints()\ID = ID.l And PolygonPoints()\PID = PolygonID.l
      result.l = PolygonPoints()\x
      Break
    Else
      result.l = -1
    EndIf
  Wend
  ProcedureReturn result.l
EndProcedure

Procedure.l GetPolygonPointY(PolygonID.l, ID.l)                         ; Ausgabe der Y-Koordinate eines Eckpunktes
  ResetList(PolygonPoints())
  While NextElement(PolygonPoints())                                      ; LinkedList wird nach dem Eckpunkt durchsucht
    If PolygonPoints()\ID = ID.l And PolygonPoints()\PID = PolygonID.l
      result.l = PolygonPoints()\y
      Break
    Else
      result.l = -1
    EndIf
  Wend
  ProcedureReturn result.l
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
