; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10866&highlight=
; Author: Kekskiller
; Date: 22. November 2006
; OS: Windows
; Demo: Yes

;{-iso3d
Structure gVector
  X.f
  Y.f
  Z.f
  xPlot.l;letztes x auf screen
  yPlot.l;letztes y auf screen
EndStructure

Structure gPolygon
  Alpha.l;pointer zu vektoren, die die polygon-basis bilden
  Betha.l;
  Gamma.l;
EndStructure

Structure gQuad
  Alpha.l;pointer zu vektoren, die die quad-basis bilden
  Betha.l;
  Gamma.l;
  Delta.l;
EndStructure

Structure gCam
  X.f ;x-verschiebung des mittelpunktes
  Y.f ;y-verschiebung des mittelpunktes
  Rotation.l ;die rotation der kamera um den mittelpunkt.
EndStructure

Structure gScreen
  aspectX.f;aspekt von briete und höhe (kleinste seite = 1.0
  aspectY.f;
  sizeX.l;größte des bildschirms
  sizeY.l;
  UVsizeX.f;vorberechnete UnitVectorGrößen fürs Rendern
  UVsizeY.f;
  uvs_on_screenX.f
  uvs_on_screenY.f
EndStructure

Structure gScene
  gMaxUnitSize.l ;größte größe eines vektorgebildes
  p_gSceneVectors.l ;zeiger auf szenen-speicher (wird nur bei alloziieren verändert, enthält die vektordaten)
  p_gLastChangedVector.l ;pointer auf letzten veränderten vektor (schneller beim speichern)
  gSceneSize.l ;größe des Szenenspeichers
  gVectorsInScene.l ;anzahl vektoren im Szenenspeicher
  gMaxPossibleVectors.l ;maximale anzahl von vektoren, die in eine szene passen
  p_gSceneShapes.l;pointer auf formenspeicher (enthält "visuelles" wie polygone, quads, sprites, etc...)
EndStructure

;{-konstanten
#gPoke_X = 0
#gPoke_Y = #gPoke_X + SizeOf(Float)
#gPoke_Z = #gPoke_Y + SizeOf(Float)

#gFlags_Non = 0
#gFlags_DrawAxis = 1
#gFlags_SetUpScreen_GetUVfromXUV = 2
#gFlags_SetUpScreen_GetUVfromYUV = 2

#gDegree_45 = 0.785398
#gDegree_90 = 1.570796
#gDegree_180 = 3.141593
#gDegree_270 = 4.712389

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


Global globFirstRot.b


Procedure.f AngleToSin(angle.w)
  s.f = (#PI / 180) * angle
  ProcedureReturn s
EndProcedure

Procedure gSetUpScreen(*screen.gScreen, sizeX.l,sizeY.l, uvs_on_screenX.f, uvs_on_screenY.f)
  *screen\sizeX = sizeX
  *screen\sizeY = sizeY

  If *screen\sizeX > *screen\sizeY
    *screen\aspectX = *screen\sizeX / *screen\sizeY
    *screen\aspectY = 1.0
  ElseIf *screen\sizeY > *screen\sizeX
    *screen\aspectX = 1.0
    *screen\aspectY = *screen\sizeY / *screen\sizeX
  EndIf

  *screen\uvs_on_screenX = uvs_on_screenX
  *screen\uvs_on_screenY = uvs_on_screenY

  *screen\UVsizeX = *screen\sizeX / *screen\uvs_on_screenX
  *screen\UVsizeY = *screen\sizeY / *screen\uvs_on_screenY
EndProcedure

Procedure gNewScene(*scene.gScene, vectors.l)
  If *scene

    *scene\gMaxUnitSize = SizeOf(gVector)
    *scene\p_gSceneVectors = AllocateMemory(vectors * *scene\gMaxUnitSize)
    *scene\p_gLastChangedVector = *scene\p_gSceneVectors
    *scene\gMaxPossibleVectors = vectors
    *scene\gVectorsInScene = 0
    *scene\gSceneSize = vectors * *scene\gMaxUnitSize

  EndIf
EndProcedure

Procedure gAddVectorDirect(*scene.gScene, X.f, Y.f, Z.f)
  If *scene

    ;pointer auf letzten vektor um eine unitgröße erhöhen (wenn überhaupt gesetzt)
    If *scene\gVectorsInScene > 0
      *scene\p_gLastChangedVector + *scene\gMaxUnitSize
    EndIf
    ;daten sichern
    PokeF(*scene\p_gLastChangedVector + #gPoke_X, X)
    PokeF(*scene\p_gLastChangedVector + #gPoke_Y, Y)
    PokeF(*scene\p_gLastChangedVector + #gPoke_Z, Z)
    *scene\gVectorsInScene + 1

  EndIf
EndProcedure

Procedure.s gGetSceneContentAsString(*scene.gScene)
  Protected back.s, *p
  If *scene

    *p = *scene\p_gSceneVectors
    back.s + "*gSceneVector: " + Str(*p) + Chr(10) + Chr(13)
    back.s + "*gLastChangedVector: " + Str(*scene\p_gLastChangedVector) + Chr(10) + Chr(13)
    back.s + "vectors in scene: " + Str(*scene\gVectorsInScene) + " from max. " + Str(*scene\gMaxPossibleVectors) + Chr(10) + Chr(13)
    back.s + Chr(10) + Chr(13)
    For Z = 0 To *scene\gVectorsInScene-1
      back.s + "#" + Str(Z+1) + Chr(10) + Chr(13)
      back.s + "x: " + Str(PeekF(*p+#gPoke_X)) + Chr(10) + Chr(13)
      back.s + "y: " + Str(PeekF(*p+#gPoke_Y)) + Chr(10) + Chr(13)
      back.s + "z: " + Str(PeekF(*p+#gPoke_Z)) + Chr(10) + Chr(13)
      back.s + Chr(10) + Chr(13)
      *p + *scene\gMaxUnitSize
    Next
    ProcedureReturn back

  Else
    ProcedureReturn ""
  EndIf
EndProcedure

Procedure.l gAbsLong(var.l)
  ProcedureReturn 2147483648 - var & 2147483647
EndProcedure

Procedure.b gAbsByte(var.b)
  ProcedureReturn 256 - var & 255
EndProcedure

Procedure gRenderSzene(*scene.gScene, *screen.gScreen, xRender.l,yRender.l, yRot.f, xRot.f, zRot.f, flags.b=#gFlags_Non)
  Protected *p
  Protected *gPoly.gPolygon, *gQuad.gQuad, *gVec.gVector
  Protected gA.l, gB.l, gC.l, gCos.f, gSin.f
  If *scene

    ;arbeitspointer zuweisen
    *p = *scene\p_gSceneVectors

    If flags & #gFlags_DrawAxis

      ;x-achse
      uvXx = xRender + Cos(yRot) * *screen\UVsizeX
      uvXy = yRender + Sin(yRot) * *screen\UVsizeY * Sin(xRot)

      ;y-achse
      uvYx = xRender
      uvYy = yRender + *screen\UVsizeY * Sin(xRot + #gDegree_270)

      ;z-achse
      uvZx = xRender + Cos(yRot + #gDegree_90) * *screen\UVsizeX
      uvZy = yRender + Sin(yRot + #gDegree_90) * *screen\UVsizeY * Sin(xRot)

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
        ;Edit: Erweiterung auf X-Rotation erfolgt durch Sinus-Multiplikation bei My mit der X-Rotation.
        ;
        ;  Mx + cos Y-Rotation * X-Koordinate * Pixellänge eines Einheitsvektors
        ;  My + sin Y-Rotation * X-Koordinate * Pixellänge eines Einheitsvektors * sin X-Rotation
        ;
        ;Es ist wichtig, nur die X-Koordinaten im ersten Schritt zu nehmen, da die Kreisgröße sich
        ;in dieser orthogonalen Berechnung auf einen statischen Radius beschränkt, d.h. der Radius
        ;ist auf dem Bildschirm IMMER gleich.
        ;
        ;Danach folgt die Zurechnung der Y-Koordinaten! Da bei dieser einfachen Darstellung auf eine
        ;Z/X-Rotation verzichtet wird, kann ruhig nur die Y-Position des Vektors verändert (die auf
        ;dem Bildschirm!). Dabei müssen wir ganz einfach die Y-Koordinate im Raum von Y abziehen
        ;
        ;Edit: Hierbei auch mit X-Rotation erweitern, allerdings mit X-Rotation + 270° (da sich Y um 270°
        ;von den anderen Achsen unterscheidet! Vom Umsetzen also sehr angenehm...
        ;
        ;  My - Y-Koordinate * Pixellänge eines Einheitsvektors * sin (X-Rotation + 270°)
        ;
        ;Letzten Endes wird von dem nun besthenden Punkt (der im Moment nur eine 2dimensionale
        ;auf einer X/Y-Achse im Raum ist) eine Schlenker um 90 in Richtung der Innen-Raumes machen.
        ;Klingt seltsam, ist aber einfach. Da wir uns schon auf dem Kreis der X-Koordinate befinden,
        ;müssen wir vom Kreispunkt 270° abzweigen (da Z senkrecht zu X steht). Noch die X-Berechnung
        ;in Erinnerung? Ist ähnlich, da wir ja sozusagen einen zweiten Kreis erstellen müssen (dessen
        ;Punkt - wie schonmal zwei mal erwähnt - um 270 Grad versetzt ist als der Original-Punkt).
        ;
        ; Edit: Erweiterung auf X-Rotation wie bei X-Koordinaten-Einbindung
        ;
        ;  Mx + cos (Y-Rotation + 90°) * Z-Koordinate * Pixellänge eines Einheitsvektors
        ;  My + sin (Y-Rotation + 90°) * Z-Koordinate * Pixellänge eines Einheitsvektors * sin X-Rotation
        ;
        ;Anmerkung: Da wo ich überall 270° schrieb, kann man auch theoretisch auch 90° einsetzen,
        ;dann würde sich aber auch das Verhalten von Winkel zu Darstellung ändern! Ich muss zugeben,
        ;dass ich das bei einigen Rechnungen getan habe und sie nicht ganz mit den Beispielen übereinstimmen...
        ;}

        ;typ ziehen und arbeitsvektor setzen (*gVec)
        *gVec = *p

        ;x-koordinaten einberechnen (+ y/x-rotation)
        *gVec\xPlot = xRender + Cos(yRot) * *gVec\X * *screen\UVsizeX
        *gVec\yPlot = yRender + Sin(yRot) * *gVec\X * *screen\UVsizeY * Sin(xRot)

        ;y-koordinaten einberechnen (+ x-rotation, y wird nicht benötigt, "da es y selbst ist")
        *gVec\yPlot + *screen\UVsizeY * *gVec\Y * Sin(xRot + #gDegree_270)

        ;z-koordinaten einberechnen (+ y/x-rotation)
        *gVec\xPlot + Cos(yRot + #gDegree_90) * *gVec\Z * *screen\UVsizeX
        *gVec\yPlot + Sin(yRot + #gDegree_90) * *gVec\Z * *screen\UVsizeY * Sin(xRot)

        ;{comment
        ;Z-Rotation-Therorie
        ;~~~~~~~~~~~~~~~~~~~
        ;Die Z-Rotation beim Rendern hat nicht mehr viel mit der eigentlichen Z-Achse zu tun. Es ist
        ;eher eine Drehung des Bildschirms anhand der sichtbaren Punkten. Da die Polygone erst nach
        ;dieser Berechnung gerendert werden, kann man immer noch prima weiterrendern.
        ;
        ;Die Berechnung der Z-Rotation erfolgt über den Satz des Pytagoras, als Drehpunkt gilt die
        ;Bildschirmmitte.
        ;
        ; gA = Seite a
        ; gB = Seite b
        ; gC = Seite c (unsere entfernung)
        ; gCos = Cosinus des bereits vorhandenen Winkels zum Mittelpunkt
        ; gSin = Sinus des bereits vorhandenen Winkels zum Mittelpunkt
        ;
        ;}

        ;z-Rotation mit einbeziehen

        DisableDebugger

        If globFirstRot = 0

          Debug "yRender: " + Str(yRender)
          Debug "yRender: " + Str(yRender)
          Debug ""
          Debug "*gVec\xPlot: " + Str(*gVec\xPlot)
          Debug "*gVec\yPlot: " + Str(*gVec\yPlot)
          Debug ""

          gA = yRender - *gVec\yPlot
          gB = xRender - *gVec\xPlot
          ; If gA < 0: gA * -1: EndIf
          ; If gB < 0: gB * -1: EndIf
          Debug "gA: " + Str(gA)
          Debug "gB: " + Str(gB)
          Debug ""

          gC = Sqr(gA * gA + gB * gB)
          Debug "gC: " + Str(gC)
          Debug ""

          gCos = gB / gC
          gSin = gA / gC
          Debug "gCos: " + StrF(gCos)
          Debug "gSin: " + StrF(gSin)
          Debug ""

          *gVec\xPlot = xRender - gCos * gC
          *gVec\yPlot = yRender - gSin * gC
          Debug "*gVec\xPlot: " + Str(*gVec\xPlot)
          Debug "*gVec\yPlot: " + Str(*gVec\yPlot)
          Debug ""

          globFirstRot = 0

        EndIf

        EnableDebugger

        ;einzeichnen
        If *gVec\xPlot > 0 And *gVec\xPlot < *screen\sizeX
          If *gVec\yPlot > 0 And *gVec\yPlot < *screen\sizeY
            Circle(*gVec\xPlot, *gVec\yPlot, 1, #gCOLOR_AXIS_TEXT)
          EndIf
        EndIf

        ;pointer auf nächsten vektor erhöhen
        *p + *scene\gMaxUnitSize

      Next
    EndIf

  EndIf
EndProcedure

Procedure.l gGetVector(*scene.gScene, vektorindex.l)
  If *scene
    ProcedureReturn *scene\p_gSceneVectors + vektorindex * *scene\gMaxUnitSize
  Else
    ProcedureReturn 0
  EndIf
EndProcedure
;}-

;-deklarieren
Declare CreateScene()

;-initialisieren
InitSprite()
InitKeyboard()
InitMouse()
Global myScreen.gScreen
Global myScene.gScene
Global myYRotation.l
Global myXRotation.l
Global myZRotation.l
Global polycount.l, polycol.l

;-fenster + szene erstellen
CreateScene()

MessageRequester("iso3d", gGetSceneContentAsString(@myScene))

;-hauptschleife
Repeat
  ;event-handling
  event = WindowEvent()

  ;maus
  ExamineMouse()
  ExamineKeyboard()

  ;drehung durch maus updaten
  myYRotation - MouseDeltaX()
  myXRotation + MouseDeltaY()
  myZRotation + MouseWheel()

  ;rendern
  ClearScreen(0)
  StartDrawing(ScreenOutput())
  gRenderSzene(@myScene, @myScreen, myScreen\sizeX/2,myScreen\sizeY/2, AngleToSin(myYRotation),AngleToSin(myXRotation),AngleToSin(myZRotation), #gFlags_DrawAxis)
  StopDrawing()
  FlipBuffers()

  ;delay
  Delay(1)
Until KeyboardPushed(#PB_Key_Escape) Or event = #PB_Event_CloseWindow



;-prozeduren
Procedure CreateScene()
  gSetUpScreen(@myScreen, 640,480, 20*(640/380),20)

  gNewScene(@myScene, 15)
  For polycount = 0 To 6
    gAddVectorDirect(@myScene, Random(10),Random(10),Random(10))
    gAddVectorDirect(@myScene, Random(10),Random(10),Random(10))
    gAddVectorDirect(@myScene, Random(10),Random(10),Random(10))
  Next
  gAddVectorDirect(@myScene, 0,0,0)
  gAddVectorDirect(@myScene, 2,0,0)
  gAddVectorDirect(@myScene, 0,2,0)
  gAddVectorDirect(@myScene, 0,0,2)

  OpenWindow(0, 0,0, myScreen\sizeX,myScreen\sizeY, "iso3d", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_TitleBar)
  OpenWindowedScreen(WindowID(0), 0,0, myScreen\sizeX,myScreen\sizeY, 0,0,0)
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; EnableXP