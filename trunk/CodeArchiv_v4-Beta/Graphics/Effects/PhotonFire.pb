; http://www.purebasic-lounge.de/viewtopic.php?t=3738&postdays=0&postorder=asc&start=30
; Author: remi_meier
; Date: 30. December 2006
; OS: Windows, Linux
; Demo: Yes


; Photon Fire
; Photonenbeschuss
;
; Man überlege sich folgende Optimierungsaufgabe:
; Es existiert eine Kugel mit dem Radius R im Ursprung des Koordinaten-
; systems. Nun werden per Zufall Kugeln (auch Radius R) aus allen Richtungen
; auf die Kugel geschossen, d. h. die Kugeln fliegen alle auf den Ursprung des
; Koordinatensystems zu. Kaum berührt eine fliegende Kugel eine schon
; existierende, bleibt sie stehen (man wirft also immer eine Kugel auf einmal).
; Dies mache für 20'000 Kugeln und betrachte das entstandene Bild!

EnableExplicit

; Sinus & Cosinus Tabelle
#SINCOS = 1 << 12
Dim tSin.f(#SINCOS)
Dim tCos.f(#SINCOS)
Define.l z
For z = 0 To #SINCOS
  tSin(z) = Sin(z * 2 * #PI / #SINCOS)
  tCos(z) = Cos(z * 2 * #PI / #SINCOS)
Next


Structure KUGEL
  phi.l     ; Winkel Phi (polar) 0 - #SINCOS
  r.f       ; Radius (polar)
EndStructure

#R = 2.0            ; Radius der Kugeln
#N = 5000          ; Anz. zu schiessende Kugeln
Global cN.l = 1     ; Akt. Anz. Kugeln
Global Dim Kugel.KUGEL(#N)   ; Gesetzte Kugeln

; Startkugel setzen
Kugel(0)\r   = 0
Kugel(0)\phi = 0



;- Calculations
Define.l z1, z2, time
Define.l gPhi       ; Geradenwinkel durch Ursprung
Define.l tdPhi, tAlpha, sortMin, sortMax
Define.f maxR, tR, t
Define.f t1, t2


Delay(500)
time = ElapsedMilliseconds()
For cN = 1 To #N
  ; cN aktuell zu setzende Kugel
  gPhi = Random(#SINCOS)

  ; Kollisionsschleife
  maxR = 0
  sortMin = 0
  sortMax = #SINCOS
  For z2 = 0 To cN - 1
    If Kugel(z2)\phi < sortMin ;- Or Kugel(z2)\r < maxR - 2 * #R  ; slows down? (FPU)
      Continue
    ElseIf Kugel(z2)\phi > sortMax
      Break
    EndIf

    tdPhi = Kugel(z2)\phi - gPhi
    t2    = Kugel(z2)\r
    ; zwei mal den Code kopieren mit Vorzeichenbeachtung
    If tdPhi < 0
      Macro Collide(sgn=)
        t1 = sgn#tSin(sgn#tdPhi)
        t  = (4 * #R * #R) - t1 * t1 * t2 * t2
        If t > 0
          ; Strahl kollidiert mit Kugel
          tR   = t2 * tCos(sgn#tdPhi) + Sqr(t)

          If tR > maxR
            maxR = tR

            ; Winkelbereich
            tAlpha  = ATan((2 * #R) / maxR) * (#SINCOS / 2 / #PI)

            sortMax = gPhi + tAlpha
            sortMin = gPhi - tAlpha
            ; Gerade um gPhi ~ 0°/360° -> Überprüfung nicht so simpel -> ausschalten
            If sortMax > #SINCOS
              sortMin = 0
            ElseIf sortMin < 0
              sortMax = #SINCOS
            EndIf
          EndIf
        EndIf
      EndMacro
      Collide(-)
    Else
      Collide()
    EndIf

  Next

  ;- To Optimize:
  ; Sortiert einsetzen
  Repeat
    For z1 = 1 To cN - 1
      If Kugel(z1)\phi > gPhi
        ; Memory nach hinten schieben
        MoveMemory(@Kugel(z1), @Kugel(z1+1), (cN - z1) * SizeOf(KUGEL))
        Kugel(z1)\r   = maxR
        Kugel(z1)\phi = gPhi

        Break 2
      EndIf
    Next
    Kugel(cN)\r   = maxR
    Kugel(cN)\phi = gPhi
  Until #True

Next
time = ElapsedMilliseconds() - time




;- Display
MessageRequester("Finished Calc", "Berechnung für " + Str(#N) + " Kugeln dauerte " + Str(time) + " ms.")
CreateImage(0, 500, 500)
StartDrawing(ImageOutput(0))
For z1 = 0 To #N
  Circle(250 + Kugel(z1)\r * tCos(Kugel(z1)\phi), 250 - Kugel(z1)\r * tSin(Kugel(z1)\phi), #R, $FF)
Next
StopDrawing()

OpenWindow(0, 200, 200, 500, 500, "Kugeln")
CreateGadgetList(WindowID(0))
ImageGadget(0, 0, 0, 500, 500, ImageID(0))

Repeat
Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP