; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10866&highlight=
; Author: Kekskiller
; Date: 20. November 2006
; OS: Windows
; Demo: Yes

;{-iso3d
Structure gVector
  X.f
  Y.f
  Z.f
  color.l
  xPlot.l;letztes x auf screen
  yPlot.l;letztes y auf screen
EndStructure

Structure gPolygon
  Alpha.gVector
  Betha.gVector
  Gamma.gVector
EndStructure

Structure gQuad
  Alpha.gVector
  Betha.gVector
  Gamma.gVector
  Delta.gVector
EndStructure

Structure gCam
  X.f ;x-verschiebung des mittelpunktes
  Y.f ;y-verschiebung des mittelpunktes
  Rotation.l ;die rotation der kamera um den mittelpunkt.
EndStructure

Structure gScreen
  aspectX.f;aspekt von briete und höhe (kleinste seite = 1.0
  aspectY.f;
  UnitVectorSize.f;größe eines einheitsvektor auf dem bildschirm (abhängig von der bildschirmgröße)
  sizeX.l;größte des bildschirms
  sizeY.l;
  UVsizeX.f;vorberechnete UnitVectorGrößen fürs Rendern
  UVsizeY.f;
EndStructure

Structure gScene
  gMaxUnitSize.l ;größte größe eines vektorgebildes
  p_gSceneVectors.l ;zeiger auf szenen-speicher (wird nur bei alloziieren verändert)
  p_gLastChangedVector.l ;pointer auf letzten veränderten vektor (schneller beim speichern)
  gSceneSize.l ;größe des Szenenspeichers
  gVectorsInScene.l ;anzahl vektoren im Szenenspeicher
  gMaxPossibleVectors.l ;maximale anzahl von vektoren, die in eine szene passen
EndStructure

;{-konstanten
#gType_Vec = 0
#gType_Poly = 1
#gType_PolyEnd = 2
#gType_Quad = 3

#gType_Line_Part = 3 ;teil oder anfang einer linie
#gType_Line_End = 4 ;endstück einer linie (MUSS immer letztes element sein

#gPoke_X = 1
#gPoke_Y = #gPoke_X + SizeOf(Float)
#gPoke_Z = #gPoke_Y + SizeOf(Float)
#gPoke_Col = #gPoke_Z + SizeOf(Float)

#gFlags_Non = 0
#gFlags_DrawAxis = 1
#gFlags_SetUpScreen_StretchUV = 2

#gDegree_45 = 0.785398
#gDegree_90 = 1.570796

#gCOLOR_AXIS_TEXT = $FFFFFF
#gCOLOR_X_AXIS = $FF0000
#gCOLOR_Y_AXIS = $0000FF
#gCOLOR_Z_AXIS = $00FF00

#gAXIS_X_VECTOR_X = 1
#gAXIS_X_VECTOR_Y = 0
#gAXIS_X_VECTOR_Z = 0

#gAXIS_Y_VECTOR_X = 0
#gAXIS_Y_VECTOR_Y = 1
#gAXIS_Y_VECTOR_Z = 0

#gAXIS_Z_VECTOR_X = 0
#gAXIS_Z_VECTOR_Y = 0
#gAXIS_Z_VECTOR_Z = 1
;}-
Procedure.f AngleToSin(angle.w)
  s.f = (#PI / 180) * angle
  ProcedureReturn s
EndProcedure

Procedure gSetUpScreen(*screen.gScreen, sizeX.l,sizeY.l, uvs.f, flags)
  *screen\sizeX = sizeX
  *screen\sizeY = sizeY

  If *screen\sizeX > *screen\sizeY
    *screen\aspectX = *screen\sizeX / *screen\sizeY
    *screen\aspectY = 1.0
  ElseIf *screen\sizeY > *screen\sizeX
    *screen\aspectX = 1.0
    *screen\aspectY = *screen\sizeY / *screen\sizeX
  EndIf

  *screen\UnitVectorSize = uvs

  If flags & #gFlags_SetUpScreen_StretchUV
    ;vorberechnete UV-Größen (Einheitsvektorgröße auf dem Bildschirm)
    *screen\UVsizeX = *screen\UnitVectorSize * *screen\aspectX
    *screen\UVsizeY = *screen\UnitVectorSize * *screen\aspectY
  Else
    *screen\UVsizeX = *screen\UnitVectorSize
    *screen\UVsizeY = *screen\UnitVectorSize
  EndIf
EndProcedure

Procedure gNewScene(*scene.gScene, vectors.l, gMaxUnitSize=1+SizeOf(gQuad))
  *scene\gMaxUnitSize = gMaxUnitSize
  *scene\p_gSceneVectors = AllocateMemory(vectors * gMaxUnitSize)
  *scene\p_gLastChangedVector = *scene\p_gSceneVectors
  *scene\gMaxPossibleVectors = vectors
  *scene\gVectorsInScene = 0
  *scene\gSceneSize = vectors * *scene\gMaxUnitSize
EndProcedure

Procedure gAddVectorDirect(*scene.gScene, vectortype.b, X.f, Y.f, Z.f, c.l)
  ;pointer auf letzten vektor um eine unitgröße erhöhen (wenn überhaupt gesetzt)
  If *scene\gVectorsInScene > 0
    *scene\p_gLastChangedVector + *scene\gMaxUnitSize
  EndIf
  ;type poken
  PokeB(*scene\p_gLastChangedVector, vectortype)
  ;daten sichern
  PokeF(*scene\p_gLastChangedVector + #gPoke_X, X)
  PokeF(*scene\p_gLastChangedVector + #gPoke_Y, Y)
  PokeF(*scene\p_gLastChangedVector + #gPoke_Z, Z)
  PokeL(*scene\p_gLastChangedVector + #gPoke_Col, c)
  *scene\gVectorsInScene + 1
EndProcedure

Procedure.s gGetTypeString(vectortype.b)
  Select vectortype
    Case #gType_Poly: ProcedureReturn "Poly"
    Case #gType_Quad: ProcedureReturn "Quad"
    Case #gType_Vec: ProcedureReturn "Vec"
  EndSelect
EndProcedure

Procedure.s gGetSceneContentAsString(*scene.gScene)
  Protected back.s, *p
  *p = *scene\p_gSceneVectors
  back.s + "*gSceneVector: " + Str(*p) + Chr(10) + Chr(13)
  back.s + "*gLastChangedVector: " + Str(*scene\p_gLastChangedVector) + Chr(10) + Chr(13)
  back.s + "vectors in scene: " + Str(*scene\gVectorsInScene) + " from max. " + Str(*scene\gMaxPossibleVectors) + Chr(10) + Chr(13)
  back.s + Chr(10) + Chr(13)
  For Z = 0 To *scene\gVectorsInScene-1
    back.s + "#" + Str(Z+1) + Chr(10) + Chr(13)
    back.s + "type: " + gGetTypeString(PeekB(*p)) + Chr(10) + Chr(13)
    back.s + "x: " + Str(PeekF(*p+#gPoke_X)) + Chr(10) + Chr(13)
    back.s + "y: " + Str(PeekF(*p+#gPoke_Y)) + Chr(10) + Chr(13)
    back.s + "z: " + Str(PeekF(*p+#gPoke_Z)) + Chr(10) + Chr(13)
    back.s + Chr(10) + Chr(13)
    *p + *scene\gMaxUnitSize
  Next
  ProcedureReturn back
EndProcedure

Procedure gRenderSzene(*scene.gScene, *screen.gScreen, xRender.l,yRender.l, yRot.f, xRot.f, zRot.f, flags.b=#gFlags_Non)
  Protected *p
  Protected *gPoly.gPolygon, *gQuad.gQuad, *gVec.gVector, *gLastVec.gVector, *gLastVec2.gVector, *gLastVec3.gVector
  Protected type.l, lasttype.l, lasttype2.l, lasttype3.l

  ;x und y sind der mittelpunkt auf dem bildschirm...
  ;resolution ist die auflösung der szene, d.h. wie viele einheitsvektoren auf einem bild platz finden...

  ;arbeitspointer zuweisen
  *p = *scene\p_gSceneVectors

  If flags & #gFlags_DrawAxis

    ;x-achse
    uvXx = xRender + Cos(yRot) * *screen\UVsizeX
    uvXy = yRender + Sin(yRot) * *screen\UVsizeY

    ;y-achse
    uvYx = xRender
    uvYy = yRender - *screen\UnitVectorSize

    ;z-achse
    uvZx = xRender + Cos(yRot + #gDegree_90) * *screen\UVsizeX
    uvZy = yRender + Sin(yRot + #gDegree_90) * *screen\UVsizeY

    ;Von 0-Punkt aus Rendern
    ;~~~~~~~~~~~~~~~~~~~~~~~
    LineXY(xRender,yRender, uvXx,uvXy, #gCOLOR_X_AXIS);(blau)
    LineXY(xRender,yRender, uvYx,uvYy, #gCOLOR_Y_AXIS);(rot)
    LineXY(xRender,yRender, uvZx,uvZy, #gCOLOR_Z_AXIS);(grün)

    DrawText(uvXx,uvXy, "X", #gCOLOR_AXIS_TEXT, #gCOLOR_X_AXIS)
    DrawText(uvYx,uvYy, "Y", #gCOLOR_AXIS_TEXT, #gCOLOR_Y_AXIS)
    DrawText(uvZx,uvZy, "Z", #gCOLOR_AXIS_TEXT, #gCOLOR_Z_AXIS)

  EndIf

  ;wenn vektoren vorhanden, alle durchgehen und rendern
  If *scene\gVectorsInScene > 0
    For Z=0 To *scene\gVectorsInScene-1

      ;{comment
      ;Render-Theorie:
      ;~~~~~~~~~~~~~~~~~~~~~~~~~~~
      ;Zuallererst berechnen wir die X-Position. X ist im Prinzip auch nur ein Punkt, der sich
      ;auf einem Kreis bewegt -> die Größe des Kreises ist dabei abhängig von der X-Koordinate
      ;des Vektors. Somit benutzen wir ganz normale Kreis-Punkt-Positionen. Die Rotation bezieht
      ;sich dabei auf die Rotation des Y-Achse (da diese die Position auf dem Kreis MITBESTIMMT!)
      ;
      ;  M = Mittelpunkt
      ;
      ;  Mx + cos Y-Rotation * X-Koordinate * Pixellänge eines Einheitsvektors
      ;  My + sin Y-Rotation * X-Koordinate * Pixellänge eines Einheitsvektors
      ;
      ;Es ist wichtig, nur die X-Koordinaten im ersten Schritt zu nehmen, da die Kreisgröße sich
      ;in dieser orthogonalen Berechnung auf einen statischen Radius beschränkt, d.h. der Radius
      ;ist auf dem Bildschirm IMMER gleich.
      ;
      ;Danach folgt die Zurechnung der Y-Koordinaten! Da bei dieser einfachen Darstellung auf eine
      ;Z/X-Rotation verzichtet wird, kann ruhig nur die Y-Position des Vektors verändert (die auf
      ;dem Bildschirm!). Dabei müssen wir ganz einfach die Y-Koordinate im Raum von Y abziehen
      ;
      ;  My - Y-Koordinate * Pixellänge eines Einheitsvektors
      ;
      ;Letzten Endes wird von dem nun besthenden Punkt (der im Moment nur eine 2dimensionale
      ;auf einer X/Y-Achse im Raum ist) eine Schlenker um 90 in Richtung der Innen-Raumes machen.
      ;Klingt seltsam, ist aber einfach. Da wir uns schon auf dem Kreis der X-Koordinate befinden,
      ;müssen wir vom Kreispunkt 90° abzweigen (da Z senkrecht zu X steht). Noch die X-Berechnung
      ;in Erinnerung? Ist ähnlich, da wir ja sozusagen einen zweiten Kreis erstellen müssen (dessen
      ;Punkt - wie schonmal zwei mal erwähnt - um 90 Grad versetzt ist als der Original-Punkt).
      ;
      ;  Mx + cos (Y-Rotation + 90) * Z-Koordinate * Pixellänge eines Einheitsvektors
      ;  My + sin (Y-Rotation + 90) * Z-Koordinate * Pixellänge eines Einheitsvektors
      ;
      ;}

      ;typ ziehen und arbeitsvektor setzen (*gVec)
      type = PeekB(*p)
      *gVec = *p + 1

      ;position auf x-achse setzen
      *gVec\xPlot = xRender + Cos(yRot) * *gVec\X * *screen\UVsizeX
      *gVec\yPlot = yRender + Sin(yRot) * *gVec\X * *screen\UVsizeY

      ;position auf y-achse erweitern
      *gVec\yPlot - *gVec\Y * *screen\UnitVectorSize

      ;position auf z-achse erweitern
      *gVec\xPlot + Cos(yRot + #gDegree_90) * *gVec\Z * *screen\UVsizeX
      *gVec\yPlot + Sin(yRot + #gDegree_90) * *gVec\Z * *screen\UVsizeY

      ;einzeichnen (+ flächen rechnen)
      Select type
        Case #gType_Vec
          Circle(*gVec\xPlot, *gVec\yPlot, 4, *gVec\color)

        Case #gType_Poly
          ;wenn letzter vector auch vom polygon, dann
          If lasttype = #gType_Poly
            LineXY(*gLastVec\xPlot, *gLastVec\yPlot, *gVec\xPlot,*gVec\yPlot, *gLastVec\color) ;vom jetzigen zum letzten nachziehen
          EndIf
          ;diesen vektor für den nächsten vektor speichern
          *gLastVec3 = *gLastVec2
          *gLastVec2 = *gLastVec
          *gLastVec = *gVec

        Case #gType_PolyEnd
          ;wenn letzter überhaupt ein polygon
          If lasttype = #gType_Poly
            LineXY(*gLastVec\xPlot, *gLastVec\yPlot, *gVec\xPlot,*gVec\yPlot, *gLastVec\color);vom jetzigen zum letzten nachziehen
            LineXY(*gLastVec2\xPlot, *gLastVec2\yPlot, *gVec\xPlot,*gVec\yPlot, *gVec\color);vom jetzigen zum ersten
          EndIf
          ;diesen vektor für den nächsten vektor speichern
          *gLastVec3 = *gLastVec2
          *gLastVec2 = *gLastVec
          *gLastVec = *gVec

      EndSelect

      ;pointer auf nächsten vektor erhöhen
      *p + *scene\gMaxUnitSize
      ;letze typen speichern (wir benötigen insgesamt 4 variablen wegen poly(3vec) und quad(4vec)
      lasttype3 = lasttype2
      lasttype2 = lasttype
      lasttype = type

    Next
  EndIf

EndProcedure

Procedure.l GetVector(*scene.gScene, vektorindex.l)
  ProcedureReturn *scene\p_gSceneVectors + vektorindex * *scene\gMaxUnitSize
EndProcedure
;}-

;-deklarieren
Declare CreateScene()

;-initialisieren
InitSprite()
InitKeyboard()
Global myScreen.gScreen
Global myScene.gScene
Global mySceneRotation.l

;-fenster + szene erstellen
CreateScene()
mySceneRotation = 45

;-hauptschleife
Repeat
  ;event-handling
  Select WindowEvent()
    Case #PB_Event_CloseWindow: End
  EndSelect

  ;rendern
  ClearScreen(0)
  StartDrawing(ScreenOutput())
    gRenderSzene(@myScene, @myScreen, myScreen\sizeX/2,myScreen\sizeY/1.3, AngleToSin(mySceneRotation),AngleToSin(0),AngleToSin(0), #gFlags_DrawAxis)
  StopDrawing()
  FlipBuffers()

  ;delay
  Delay(1)
  mySceneRotation + 1
  If mySceneRotation >= 359
    mySceneRotation = 0
  EndIf
ForEver

; Procedure MoveThem()
;

;-prozeduren
Procedure CreateScene()
  gSetUpScreen(@myScreen, 640,480, 40, #gFlags_Non)

  ;RGB(255,255,255)

  gNewScene(@myScene, 3)
  For Z = 0 To 6
    gAddVectorDirect(@myScene, #gType_Poly,    Random(4),Random(4),Random(3), RGB(255,255,255))
    gAddVectorDirect(@myScene, #gType_Poly,    Random(4),Random(4),Random(3), RGB(255,255,255))
    gAddVectorDirect(@myScene, #gType_PolyEnd, Random(4),Random(4),Random(3), RGB(255,255,255))
  Next

  OpenWindow(0, 0,0, myScreen\sizeX,myScreen\sizeY, "iso3d", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_TitleBar)
  OpenWindowedScreen(WindowID(0), 0,0, myScreen\sizeX,myScreen\sizeY, 0,0,0)
EndProcedure
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP