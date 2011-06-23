; German forum: http://www.purebasic.fr/german/viewtopic.php?t=4512&highlight=
; Author: PureLust (updated for PB 4.00 by Andre)
; Date: 03. October 2005
; OS: Windows
; Demo: Yes

Define.w OrigBreite,OrigHoehe,OrigXDrehpunkt,OrigYDrehpunkt,ZielBreite,ZielHoehe,Rand

; Standardvariablen definieren
#GFX_Mittelwertfilter = 1
OrigBreite=200
OrigHoehe=200
OrigXDrehpunkt=45
OrigYDrehpunkt=45
ZielBreite=OrigBreite
ZielHoehe=OrigHoehe
Rand=20
Filterung.b=#GFX_Mittelwertfilter
Filterung.b=0
Dim OrigPoint(OrigBreite+1,OrigHoehe+1)

If OpenWindow(0,10,10,OrigBreite*2+Rand*3,OrigHoehe+Rand*2," 2D Image-Rotation  <ESC>-Ende   <Space>-Pause   <F>-Filter",0)
  If CreateImage(1,OrigBreite,OrigHoehe)
    ; original Ausgangsbild erzeugen
    If StartDrawing(ImageOutput(1))
      Box(1,1,OrigBreite-2,OrigHoehe-2,RGB(255,255,255))
      Box(20,30,OrigBreite-40,30,RGB(20,200,200))
      ;Circle(OrigXDrehpunkt,OrigYDrehpunkt,4,RGB(0,0,255))
      ;Circle(OrigXDrehpunkt,OrigYDrehpunkt,2,RGB(255,255,255))
      Circle(40,OrigHoehe-41,30,RGB(200,33,33))
      ; Daten des Originalbildes in einem Array zwischenspeichern
      For x.w = 1 To OrigBreite
        For y.w = 1 To OrigHoehe
          OrigPoint(x,y)=Point(x-1,y-1)
        Next y
      Next x
      StopDrawing()
    EndIf
    If StartDrawing(WindowOutput(0))
      Hintergrundfarbe = Point(1,1)
      ; Im Bildpuffer einen Rahmen in Hintergrundfarbe um das Bild legen (für Filter)
      For x=0 To OrigBreite : OrigPoint(x,0)=Hintergrundfarbe : OrigPoint(x,OrigHoehe+1)=Hintergrundfarbe  : Next x
      For Y=0 To OrigHoehe  : OrigPoint(0,y)=Hintergrundfarbe : OrigPoint(OrigBreite+1,y)=Hintergrundfarbe : Next y
      ; Originalbild auf Fenster ausgeben
      OrigImageID=ImageID(1)
      DrawImage(OrigImageID,Rand,Rand)
      StopDrawing()
    EndIf
    If CreateImage(2,ZielBreite,ZielHoehe)
      Repeat
        For w = 0 To 359
          Winkel.f = 3.141/180*w
          ; mehrfach benutzte Berechnungen puffern
          SinWinkel.f = Sin(Winkel)
          CosWinkel.f = Cos(Winkel)
          ZielImageID=ImageID(2)
          If StartDrawing(ImageOutput(2))
            ; Zielimage löschen
            Box(0,0,ZielBreite,ZielHoehe,Hintergrundfarbe)
            StartTimer = ElapsedMilliseconds()
            For x.w = 1 To OrigBreite
              ; mehrfach benutzte Berechnungen puffern
              xSinWinkel.f = (x-OrigXDrehpunkt)*SinWinkel
              xCosWinkel.f = (x-OrigXDrehpunkt)*CosWinkel
              For y.w = 1 To OrigHoehe
                zx.f=(xCosWinkel-(y-OrigYDrehpunkt)*SinWinkel)+OrigXDrehpunkt
                zy.f=(xSinWinkel+(y-OrigYDrehpunkt)*CosWinkel)+OrigYDrehpunkt
                Select Filterung
                  Case #GFX_Mittelwertfilter
                    ; Berechnung mit Filter
                    zxi = Int(zx+0.5)
                    zyi = Int(zy+0.5)
                    If zx>0 And zx<ZielBreite+1 And zy>0 And zy<ZielHoehe+1
                      PixelFarbe1 = OrigPoint(zxi,zyi)
                      If zx<zxi
                        PixelFarbe2 = OrigPoint(zxi-1,zyi)
                      Else
                        PixelFarbe2 = OrigPoint(zxi+1,zyi)
                      EndIf
                      Gewichtung2.f=Abs(zx-zxi)
                      If zy>zyi
                        PixelFarbe3 = OrigPoint(zxi,zyi+1)
                      Else
                        PixelFarbe3 = OrigPoint(zxi,zyi-1)
                      EndIf
                      Gewichtung3.f=Abs(zy-zyi)
                      Gewichtung1.f=1-Gewichtung2-Gewichtung3
                      ; Pixelgewichtung berechnen
                      PixelRed=Red(PixelFarbe1)*Gewichtung1+Red(PixelFarbe2)*Gewichtung2+Red(PixelFarbe3)*Gewichtung3
                      PixelGreen=Green(PixelFarbe1)*Gewichtung1+Green(PixelFarbe2)*Gewichtung2+Green(PixelFarbe3)*Gewichtung3
                      PixelBlue=Blue(PixelFarbe1)*Gewichtung1+Blue(PixelFarbe2)*Gewichtung2+Blue(PixelFarbe3)*Gewichtung3
                      Plot(x-1,y-1,RGB(PixelRed,PixelGreen,PixelBlue))
                    EndIf
                  Default
                    ; Berechnung ohne Filter
                    If zx>=1 And zx<ZielBreite+1 And zy>=1 And zy<ZielHoehe+1
                      Plot(x-1,y-1,OrigPoint(Int(zx),Int(zy)))
                    EndIf
                EndSelect
              Next y
            Next x
            StopDrawing()
            SetWindowTitle(0," 2D Image-Rotation  <ESC>-Ende   <Space>-Pause   <F>-Filter     FPS: "+Str(1000/(ElapsedMilliseconds()-StartTimer+1)))
          EndIf
          If StartDrawing(WindowOutput(0))
            ; gedrehtes Image auf Fenster ausgeben
            DrawImage(ZielImageID,rand*2+OrigBreite,Rand)
            StopDrawing()
          EndIf
          Event=WindowEvent()
          If Event = #WM_KEYDOWN
            If EventwParam() = #VK_SPACE
              Repeat
                Event=WaitWindowEvent()
              Until Event = #WM_KEYDOWN
            ElseIf EventwParam() = #VK_F
              Filterung = #GFX_Mittelwertfilter-Filterung
            ElseIf EventwParam() = #VK_ESCAPE
              Break 2
            EndIf
          EndIf
        Next w
      ForEver
    EndIf
  EndIf
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger