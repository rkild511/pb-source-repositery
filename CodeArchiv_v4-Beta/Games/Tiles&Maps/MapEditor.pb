; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2054&postdays=0&postorder=asc&start=10
; Author: glubschi90 (updated for PB 4.00 by Andre)
; Date: 17. February 2005
; OS: Windows
; Demo: Yes


; Map Editor

; Das Programm braucht keine Ressourcen (auﬂer deine Tiles).
; Den Pfad zu den Tiles musst du angeben (ist im Code mit #### markiert).
; Das aktuelle Tile kannst du mit dem Mausrad oder den Pfeilbuttons wechseln.


LoadFont(0,"Arial",10)

If InitSprite()=0:End:EndIf
If InitMouse()=0:End:EndIf
If InitKeyboard()=0:End:EndIf

id=OpenScreen(800,600,32,"Map-Editor")

Global MouseTimeOut, Info.s
Global Dim Map(39,29)
gitter=1
IPBoxTXT.s
Info="Willkommen!"

;##############################################################
#SavePath="" ; <- Muss ggf angepasst werden!
#TilesPath="..\..\Graphics\Gfx\TileSet\" ; <- Muss auch angepasst werden!
#NumOfTiles=30 ; <- Anzahl der Bitmapdateien
;##############################################################

;{Maptiles laden
For i=1 To #NumOfTiles
  If LoadSprite(i-1,#TilesPath+RSet(Str(i), 3, "0") +".bmp") = 0
    CloseScreen()
    MessageRequester("Fehler","Konnte Datei: "+Str(i)+".bmp nicht laden",#MB_ICONERROR)
    End
  EndIf
Next
;}

Enumeration #NumOfTiles+1
  #Mouse
  #Arrow_L
  #Arrow_R
EndEnumeration

;{-Sprites erstellen
CreateSprite(#Arrow_L,30,30)
StartDrawing(SpriteOutput(#Arrow_L));{
FrontColor(RGB(0,255,200))
LineXY(0,15,10,0)
LineXY(0,15,10,30)
Line(10,0,0,30)
FillArea(5,15,RGB(0,255,200))
Box(10,10,20,10)
StopDrawing();}

CreateSprite(#Arrow_R,30,30)
StartDrawing(SpriteOutput(#Arrow_R));{
FrontColor(RGB(0,255,200))
LineXY(30,15,20,0)
LineXY(30,15,20,30)
Line(20,0,0,30)
FillArea(25,15,RGB(0,255,200))
Box(0,10,20,10)
StopDrawing();}

CreateSprite(#Mouse,30,30)
TransparentSpriteColor(#Mouse,RGB(0,255,0))
StartDrawing(SpriteOutput(#Mouse));{
Box(0,0,30,30,RGB(0,255,0))
FrontColor(RGB(0,0,0))
Line(0,0,0,30)
Line(0,0,30,0)
LineXY(0,30,30,0)
FillArea(10,10,0,$FFFFFF)
StopDrawing();}
;}



Procedure MouseKlick()
  ret=0
  If MouseTimeOut=0 And MouseButton(1)
    MouseTimeOut=1
    ret=1
  EndIf
  ProcedureReturn ret
EndProcedure

Procedure RectPointOverlap(x,y,w,h,px,py)
  ret=0
  If px>=x And px<=x+w And py>=y And py<=y+h
    ret=1
  EndIf
  ProcedureReturn ret
EndProcedure

Procedure Timer()
  Repeat
    Delay(60000) ; = 60sek
    If CreateFile(0,#SavePath+"AutoSave")
      For x=0 To 39
        For y=0 To 29
          WriteByte(0, Map(x,y))
        Next
      Next
      CloseFile(0)
      Info="-Automatisches Speichern-"
    Else
      Info="-Konnte nicht automatisch speichern!-"
    EndIf
  ForEver
EndProcedure


SetFrameRate(60)

CreateThread(@Timer(),0)

Repeat

  ExamineMouse():ExamineKeyboard()
  mx=MouseX():my=MouseY()


  ;-Sprites

  ;Map

  For x=0 To 39
    For y=0 To 29
      DisplaySprite(Map(x,y),x*16,y*16)
    Next
  Next

  ;Men¸

  DisplayTransparentSprite(#Arrow_L,10,530)
  DisplayTransparentSprite(#Arrow_R,100,530)
  DisplaySprite(CurrentSprite,60,535)

  ;-Drawing

  StartDrawing(ScreenOutput())
  DrawingFont(FontID(0))

  DrawingMode(1)

  If gitter

    FrontColor(RGB(255,0,0))
    For x=1 To 40
      Line(x*16,0,0,480)
    Next
    For y=1 To 30
      Line(0,y*16,640,0)
    Next
  EndIf


  FrontColor(RGB(255,255,255))
  DrawText(55, 510, "Tile")

  If gitter=1
    DrawText(660, 20, "Gitternetz: an")
  Else
    DrawText(660, 20, "Gitternetz aus")
  EndIf

  DrawText(660, 40, "-Leertaste zum ƒndern-")

  DrawText(220, 535, "Dateiname:")
  Box(300,530,300,20)


  FrontColor(RGB(0,255,200))

  Box(300,560,145,20)
  Box(455,560,145,20)

  Box(620,530,170,20,13107400)


  FrontColor(RGB(0,0,0))

  DrawText(305, 532, IPBoxTXT)

  DrawText(305, 562, "Speichern")
  DrawText(460, 562, "Laden")

  DrawText(622, 532, Info)

  DrawText(622, 562, "Map-Editor by glubschi90")

  If IPBox=1
    Box(307+TextWidth(IPBoxTXT),532,4,16)
  EndIf



  DrawingMode(4)
  Box(mx+15,my+15,19,19,16711680)
  Box(mx+16,my+16,17,17,16711680)
  StopDrawing()


  ;-Abfragen
  If KeyboardReleased(#PB_Key_Escape)
    quit=1
  EndIf

  If KeyboardReleased(#PB_Key_Space)
    If gitter=1
      gitter=0
    Else
      gitter=1
    EndIf
  EndIf

  ;Maus abfragen

  MKlick=MouseKlick()

  If mx<640 And my<480
    If MouseButton(1)
      Map(mx/16,my/16)=CurrentSprite
    EndIf
  EndIf

  If MouseWheel()>0 And CurrentSprite>0
    CurrentSprite-1
  EndIf
  If MouseWheel()<0 And CurrentSprite<#NumOfTiles-1
    CurrentSprite+1
  EndIf


  If RectPointOverlap(300,530,300,20,mx,my)
    If MKlick
      IPBox=1
    EndIf
  Else
    If MKlick
      IPBox=0
    EndIf
  EndIf

  If RectPointOverlap(300,560,145,20,mx,my) And MKlick ;-Speichern
    If IPBoxTXT<>""
      If CreateFile(0,#SavePath+IPBoxTXT)
        For x=0 To 39
          For y=0 To 29
            WriteByte(0, Map(x,y))
          Next
        Next
        CloseFile(0)
        Info="Datei gespeichert!"
      Else
        Info="Konnte Datei nicht speichern!"
      EndIf
    Else
      Info="Bitte Dateinamen angeben."
    EndIf
  EndIf


  If RectPointOverlap(460,560,145,20,mx,my) And MKlick ;-Laden
    If IPBoxTXT<>""
      If ReadFile(0,#SavePath+IPBoxTXT)
        For x=0 To 39
          For y=0 To 29
            Map(x,y)=ReadByte(0)
          Next
        Next
        CloseFile(0)
        Info="Datei geladen!"
      Else
        Info="Konnte Datei nicht laden!"
      EndIf
    Else
      Info="Bitte Dateinamen angeben."
    EndIf
  EndIf


  If RectPointOverlap(10,530,30,30,mx,my) And MKlick=1 And CurrentSprite>0
    CurrentSprite-1
  EndIf
  If RectPointOverlap(100,530,30,30,mx,my) And MKlick=1 And CurrentSprite<#NumOfTiles-1
    CurrentSprite+1
  EndIf


  ;InputBoxen
  If IPBox=1
    IPBoxTXT+KeyboardInkey()
    If KeyboardReleased(#PB_Key_Back)
      IPBoxTXT=Left(IPBoxTXT,Len(IPBoxTXT)-1)
    EndIf
  EndIf

  ;Mausoptionen
  If MouseTimeOut>0
    If MouseTimeOut=10
      MouseTimeOut=0
    EndIf
    MouseTimeOut+1
    If MouseButton(1)=0
      MouseTimeOut=0
    EndIf
  EndIf

  ;Maus
  DisplaySprite(CurrentSprite,mx+16,my+16)
  DisplayTransparentSprite(#Mouse,mx,my)
  FlipBuffers()
  ClearScreen(RGB(0,100,100))

Until quit=1

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger