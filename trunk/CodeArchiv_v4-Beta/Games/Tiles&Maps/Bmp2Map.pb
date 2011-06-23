; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2131&highlight=
; Author: Kaeru Gaman (improved + updated for PB 4.00 by Andre)
; Date: 19. February 2005
; OS: Windows
; Demo: Yes


; Bmp2Map : a small replacement for a map editor
; Bmp2Map : ein ersatz für einen Mapeditor

InitSprite()
InitKeyboard()

BMPName.s = OpenFileRequester("Bitmap zum einlesen auswählen","c:\","Bitmap|*.bmp|Alle|*.*",0)

If Not BMPName
  End
EndIf

OpenScreen(1024,768,32,"BMP2MAP")

Dim Colors(27)
Dim Tiles(27)
Restore Table

For n=0 To 27
  Read Red.w
  Read Grn.w
  Read Blu.w
  Read Tile.w
  Colors(n) = RGB(Red,Grn,Blu)
  Tiles(n) = Tile
Next

LoadSprite(1,BMPName,0)

MapWidth = SpriteWidth(1)

MapHeight = SpriteHeight(1)

If MapWidth>1024 Or MapHeight>768
  MessageRequester("Fehler !","Die maximale Größe beträgt 1024x768 Pixel!",#MB_ICONERROR)
  End
EndIf

Dim Map.l(MapWidth-1,MapHeight-1)

DisplaySprite(1,0,0)    ; anzeigen der Grafik, die geladen wurde
FlipBuffers()

; Map Grabben
;
DisplaySprite(1,0,0)
StartDrawing(ScreenOutput())
For t=0 To MapHeight-1
  For n=0 To MapWidth-1
    For i=0 To 27
      If Point(n,t) = Colors(i)
        Map(n,t) = Tiles(i)
      EndIf
    Next
  Next
Next
StopDrawing()

CloseScreen()
Delay(100)

MapName.s = SaveFileRequester("Name und Pfad der zu speichernden Map wählen","c:\","Maps|*.map|Alle|*.*",0)

If MapName
  If GetExtensionPart(MapName) = ""
    MapName = MapName + ".map"
  EndIf
  If CreateFile(1,Mapname)
    WriteLong(1, MapWidth)
    WriteLong(1, MapHeight)
    For t=0 To MapHeight-1
      For n=0 To MapWidth-1
        WriteLong(1, Map(n,t))
      Next
    Next
    CloseFile(1)
  EndIf
Else
  Debug "Speichern abgebrochen!"
EndIf

End

DataSection
  Table:
  Data.w    0,   0,   0,   0      ; Schwarz
  Data.w  128, 128, 128,   1      ; Dunkelgrau
  Data.w  128,   0,   0,   2      ; Dunkelrot
  Data.w  128, 128,   0,   3      ; Dunkelgelb
  Data.w    0, 128,   0,   4      ; Dunkelgrün
  Data.w    0, 128, 128,   5      ; Dunkeltürkis
  Data.w    0,   0, 128,   6      ; Dunkelblau
  Data.w  128,   0, 128,   7      ; Dunkellila
  Data.w  128, 128,  64,  16      ; Graugelb
  Data.w    0,  64,  64,  17      ; Graugrün
  Data.w    0, 128, 255,  18      ; Blassblau
  Data.w    0,  64, 128,  19      ; Graublau
  Data.w   64,   0, 255,  20      ; Seeblau
  Data.w  128,  64,   0,  21      ; Braun

  Data.w  255, 255, 255,  15      ; Weiss
  Data.w  192, 192, 192,   8      ; Hellgrau
  Data.w  255,   0,   0,   9      ; Rot
  Data.w  255, 255,   0,  10      ; Gelb
  Data.w    0, 255,   0,  11      ; Grün
  Data.w    0, 255, 255,  12      ; Türkis
  Data.w    0,   0, 255,  13      ; Blau
  Data.w  255,   0, 255,  14      ; Lila
  Data.w  255, 255, 128,  22      ; Blassgelb
  Data.w    0, 255, 128,  23      ; Blassgrün
  Data.w  128, 255, 255,  24      ; Blasstürkis
  Data.w  128, 128, 255,  25      ; Lilablau
  Data.w  255,   0, 128,  26      ; Pink
  Data.w  255, 128,  64,  27      ; Ocker

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -