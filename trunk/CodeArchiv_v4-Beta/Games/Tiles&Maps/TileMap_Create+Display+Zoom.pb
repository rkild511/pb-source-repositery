; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10196&postdays=0&postorder=asc&start=40
; Author: PMV
; Date: 19. January 2007
; OS: Windows
; Demo: Yes


; Some comments by PMV & Andre:
; This is a short & "dirty" example about loading tiles and creating a map.
; Especially the zoom function (press left mouse button and move the mouse 
; cursor around) is still buggy.


; © 2007 by PMV 
EnableExplicit 

; Anzahl der Tiles
#TilesZeilen = 3
#TilesProZeile = 10
#AlleTiles = #TilesZeilen * #TilesProZeile

;Startkoordinaten der Map 
#StartX = 000 
#StartY = 000 

;Angabe des Pfades zu den Sprites 
;[iii] ist Platzhalter für die Grafiken bei 001 - 400 (mit führenden Nullen) 
;[i] ist Platzhalter für die Grafiken bei 1 - 400 (ohne führende Nullen) 
#Path = "..\..\Graphics\Gfx\TileSet\[iii].bmp" 

;Quialität der Sprite3D (AA) ein oder aus 
#Sprite3DQuality = 0 ;eingeschalet 

;größe der genutzten Tiles 
;da Sprite3D genutzt wird, sollte Breite und Höhe gleich sein und ein Wert aus 2^X. 
#Sprite3DWidth = 64 ;2048 
#Sprite3DHeight = 64 ;2048 

;extreme der Zoom-Möglichkeiten 
#MaxZoom = 500 ;1276 
#MinZoom = 5 

;Auflösung 
#ScreenWidth = 1024 
#ScreenHeight = 768 

;Tilegröße der Originiale 
#OTileWidth = 64
#OTileHeight = 64

Global Dim Tile.l(19, 19) 
Global Dim MapSprite.l(1,1) 
Global Dim MapSprite3D.l(1,1) 



Structure TileNumber 
  Width.l 
  Height.l 
EndStructure 
Global TileNumber.TileNumber 

Global PosX.f, PosY.f 
Global TileWidth.l, TileHeight.l ;aktuelle größe der Tiles in Pixel 
Global Zoom.l  ;aktuelle Zoomfaktor in Prozent 

Global MapX.l, MapY.l ;Koordinaten der Map 
; ------------------------------------ 

;Map darf nicht überdrehten werden 
Macro CheckMapCoordinates() 
  If TileWidth * TileNumber\Width - MapX * 100 / Zoom < #ScreenWidth 
    MapX = (TileWidth * TileNumber\Width - #ScreenWidth) * Zoom / 100 / 2 
  EndIf 
  If TileHeight * TileNumber\Height - MapY * 100 / Zoom < #ScreenHeight 
    MapY = TileNumber\Height * TileHeight * Zoom / 100 - #ScreenHeight * Zoom / 100 
  EndIf 
  If MapX < 0 
    If TileWidth * TileNumber\Width < #ScreenWidth 
      MapX = (TileWidth * TileNumber\Width - #ScreenWidth) * Zoom / 100 / 2 
    Else 
      MapX = 0 
    EndIf 
  EndIf 
  If MapY < 0 : MapY = 0 : EndIf 
EndMacro 
; ------------------------------------- 

;zeichnet die 3 Ladebalken und den aktuellen Status 
Procedure DisplayState(load.l, create.l, free.l, Text$) 
    Protected y.l 
    StartDrawing(ScreenOutput()) 
      DrawingMode(#PB_2DDrawing_Default) 
      Box(#ScreenWidth/2 - 103, #ScreenHeight/2 - 36, 206, 22, RGB(113, 2, 0)) 
      Box(#ScreenWidth/2 - 100, #ScreenHeight/2 - 32, 200 * load / #AlleTiles, 14, RGB(162, 3, 0)) 

      Box(#ScreenWidth/2 - 103, #ScreenHeight/2 - 11, 206, 22, RGB(54, 115, 61)) 
      If create
        Box(#ScreenWidth/2 - 100, #ScreenHeight/2 - 7, 200 * create / (TileNumber\Width * TileNumber\Height), 14, RGB(80, 169, 90)) 
      EndIf

      Box(#ScreenWidth/2 - 103, #ScreenHeight/2 + 14, 206, 22, RGB(130, 130, 0)) 
      If free
        Box(#ScreenWidth/2 - 100, #ScreenHeight/2 + 18, 200 * free / #AlleTiles, 14, RGB(186, 186, 0)) 
      EndIf

      DrawingMode(#PB_2DDrawing_Transparent | #PB_2DDrawing_XOr) 
      If free < #AlleTiles : y = 25 : EndIf 
      If create < #AlleTiles : y = 0 : EndIf 
      If load < #AlleTiles : y = - 25 : EndIf 
      DrawText(#ScreenWidth/2 - TextWidth(Text$)/2, #ScreenHeight/2 - TextHeight(Text$)/2 + y, Text$, $f0f0f0f0) 
    StopDrawing() 
    FlipBuffers(0) 
EndProcedure 
; -------------------------------------- 

;zeichnet die angegebene Szene ausgehend von den Originaltiles auf den aktuellen Buffer 
Procedure DisplayTileScene(X, Y, Width, Height) 
  Protected TileX.l, TileY.l, DisplayX.l, DisplayY.l 
  x = -x 
  y = -y 
  
  TileX = Abs(Int(X / #OTileWidth)) 
  TileY = Abs(Int(Y / #OTileHeight)) 
  For DisplayX = X % #OTileWidth To Width-1 Step #OTileWidth 
    For DisplayY = Y % #OTileHeight To Height-1 Step #OTileHeight 
      If TileX >= 0 And TileX < #TilesProZeile And TileY >= 0 And TileY < #TilesZeilen 
        DisplaySprite(Tile(TileX, TileY), DisplayX, DisplayY) 
      Else 
        Break 
      EndIf 
      TileY + 1 
    Next 
    TileY = Abs(Int(Y / #OTileHeight)) 
    TileX + 1 
  Next 
EndProcedure 
; --------------------------- 

;lädt die Grafiken aus den Bilddateien 
Procedure InitMap() 
  Protected x.l, y.l, i.l, Path$

  ClearScreen(0) 
  FlipBuffers() 
  ClearScreen(0) 
  For i = 0 To #AlleTiles - 1
    ExamineKeyboard() 
    If KeyboardPushed(#PB_Key_All) <> #False : End : EndIf 
    If FindString(#Path, "[iii]", 1) 
      Path$ = ReplaceString(#Path, "[iii]", RSet(Str(i+1), 3, "0")) 
    Else 
      Path$ = ReplaceString(#Path, "[i]", Str(i)) 
    EndIf 
    Tile(x, y) = LoadSprite(#PB_Any, Path$ , #PB_Sprite_Memory) 
    If Not Tile(x, y) 
      CloseScreen() 
      MessageRequester("Error", "Can't load sprite " + Path$ + "!") 
      End 
    EndIf 
    x + 1 
    If x >= #TilesProZeile : y + 1 : x = 0 : EndIf 
    
    
    DisplayState(i+1, 0, 0, "load original tiles ... " + StrF((i+1) / 4, 0) + "%") 
  Next 
  
  TileNumber\Width = Round(#OTileWidth * #TilesProZeile / #Sprite3DWidth, 1) 
  TileNumber\Height = Round(#OTileHeight * #TilesProZeile / #Sprite3DHeight, 1) 
  Dim MapSprite(TileNumber\Width, TileNumber\Height) 
  Dim MapSprite3D(TileNumber\Width, TileNumber\Height) 
  TileWidth = #Sprite3DWidth 
  TileHeight = #Sprite3DHeight 
  Zoom = 100 
EndProcedure 

;erstellt die neuen Tiles mit den gewünschten Größen 
Procedure CreateMap() 
  Protected x.l, y.l, i.l, Text$, PixX.l, PixY.l, State.f 
    
  ClearScreen(0) 
  FlipBuffers() 
  ClearScreen(0) 
  For x = 0 To TileNumber\Width - 1 
    For y = 0 To TileNumber\Height - 1 
    ExamineKeyboard() 
    If KeyboardPushed(#PB_Key_All) <> #False : End : EndIf 
    
    MapSprite(x, y) = CreateSprite(#PB_Any, #Sprite3DWidth, #Sprite3DHeight, #PB_Sprite_Texture) 
    If Not MapSprite(X, Y) 
      CloseScreen() 
      MessageRequester("Error", "Can't create sprite number" + Str(i+1) + "!") 
      End 
    EndIf 
    TransparentSpriteColor(MapSprite(x, y), RGB(255,0,255)) 
    UseBuffer(MapSprite(x, y)) 
    DisplayTileScene(x * #Sprite3DWidth, Y * #Sprite3DHeight, #Sprite3DWidth, #Sprite3DHeight) 
    MapSprite3D(x, y) = CreateSprite3D(#PB_Any, MapSprite(x, y)) 
    If Not IsSprite3D(MapSprite3D(x, y)) 
      CloseScreen() 
      MessageRequester("Error", "Can't create sprite3d number " + Str(i+1) + "!") 
      End 
    EndIf      
    
    State = x*TileNumber\Height+y+1
    DisplayState(#AlleTiles, State, 0, "create new tiles ... " + StrF(100 * State / (TileNumber\Width * TileNumber\Height), 0) + "%") 
    Next 
  Next 

EndProcedure 

; gibt die am anfang geladenen Tiles wieder frei 
Procedure FreeTempData() 
  Protected X.l, Y.l, i.l, Text$ 

  For i = 0 To #AlleTiles - 1
    FreeSprite(Tile(x, y)) 
    x + 1 
    If x >= #TilesProZeile : y + 1 : x = 0 : EndIf 
    DisplayState(#AlleTiles, #AlleTiles, i+1, "free old tiles ... " + StrF(100 * (i+1) / #AlleTiles, 0) + "%") 
  Next 
EndProcedure 
; ------------------------------------------ 

;zeichnet die angegebene Szene auf den aktuellen Buffer 
Procedure DisplayMap(X, Y, Width, Height) 
  Protected TileX.l, TileY.l, DisplayX.l, DisplayY.l 
  Protected MoveX.l 
  If X < -#ScreenWidth 
    ;MoveX = Int((-X) / #ScreenWidth) * #ScreenWidth * 100 / Zoom 
  EndIf 
  
    
  X * 100 / Zoom 
  Y * 100 / Zoom 
  
  TileX = Abs(Int(X / TileWidth)) 
  TileY = Abs(Int(Y / TileHeight)) 
  Start3D() 
  
  DisplayX = -X % TileWidth 
  Repeat ;For DisplayX = X % #TileWidth To Width-1 Step #TileWidth 

    DisplayY = -Y % TileHeight 
    Repeat ;For DisplayY = Y % #TileHeight To Height-1 Step #TileHeight 
      If TileX < TileNumber\Width And TileY < TileNumber\Height 
        DisplaySprite3D(MapSprite3D(TileX, TileY), MoveX + DisplayX, DisplayY) 
      EndIf 
      TileY + 1 
      
      DisplayY + TileHeight 
    Until DisplayY >= Height - 1 
    TileY = Abs(Int(Y / TileHeight)) 
    TileX + 1 
    
    DisplayX + TileWidth 
  Until DisplayX >= Width-1 
  Stop3D() 
EndProcedure 
; --------------------------- 


Procedure ZoomMap(Zoom.l) 
  Protected x.l, y.l, Width.l, Height.l 
  If Zoom <= 0 Or Zoom > #MaxZoom 
    ProcedureReturn #False 
  EndIf 

  TileWidth = 100 * #Sprite3DWidth / Zoom 
  TileHeight = 100 * #Sprite3DHeight / Zoom 
  For x = 0 To TileNumber\Width - 1 
    For y = 0 To TileNumber\Height - 1 
      ZoomSprite3D(MapSprite3D(X, Y), TileWidth, TileHeight) 
    Next 
  Next 
  ProcedureReturn #True 
EndProcedure 


Procedure Init() 
  InitSprite() 
  InitSprite3D() 
  Sprite3DQuality(#Sprite3DQuality) 
  InitKeyboard() 
  InitMouse() 
  UsePNGImageDecoder() 
  If Not OpenScreen(#ScreenWidth, #ScreenHeight, 32, "") 
    MessageRequester("Error", "Can't open screen! (" + Str(#ScreenWidth) + " X " + Str(#ScreenHeight)) 
    End 
  EndIf 
  InitMap() 
  CreateMap() 
  FreeTempData() 
  Zoom = 100
  ZoomMap(Zoom) 

  MapX = #StartX 
  MapY = #StartY 
  CheckMapCoordinates() 
EndProcedure 

;-Programmstart 
Define RelativZoom.l 

Define ButtonStateLeft.l, tempZoom.l, ZoomStart.l, X.l, Y.l 
Define ButtonStateRight.l 

Define.l MouseX, MouseY, OldMouseX, OldMouseY, tempMapX, tempMapY, tempX, tempY 

Define FPS.l, FPSCounter.l, FPSTimer.l, LoopTime.l, Timer.l 
Init() 
Repeat 
  If Not ExamineMouse() 
    ;bei hoher PC-Auslastung (geringer FPS) funktioniert ExamineMouse() nicht richtig 
    Beep_(1000, 100) 
  EndIf 
  
 ;Zoom per gedrückter linker Maustaste 
 If MouseButton(#PB_MouseButton_Left) 
    If ButtonStateLeft 
      Zoom = tempZoom + (MouseY() - ZoomStart) * 2 
      MapX = tempX + (tempZoom - Zoom) * #ScreenWidth/200 
      MapY = tempY + (tempZoom - Zoom) * #ScreenHeight/200 

      If Zoom < #MinZoom : Zoom = #MinZoom : EndIf 
      If Zoom > #MaxZoom : Zoom = #MaxZoom : EndIf 

      CheckMapCoordinates() 
      
      ZoomMap(Zoom) 
      ClearScreen(0) 
    Else 
      tempZoom = Zoom 
      tempX = MapX 
      tempY = MapY 
      ZoomStart = MouseY() 
      ButtonStateLeft = 1 
    EndIf 
  ElseIf ButtonStateLeft 
    ButtonStateLeft = 0 
    TempZoom = 0 
    tempX = 0 
    tempY = 0 
    ZoomStart = 0 
  EndIf 
  ; --------------------------- 

  If MouseButton(#PB_MouseButton_Right) 
    If ButtonStateRight = 0 
      MouseX = MouseX() 
      MouseY = MouseY() 
      ButtonStateRight = 1 
      tempMapX = MapX 
      tempMapY = MapY 
    EndIf 
    If OldMouseX <> MouseX() Or OldMouseY <> MouseY() 
      MapX = tempMapX - (MouseX() - MouseX) * Zoom / 100 
      MapY = tempMapY - (MouseY() - MouseY) * Zoom / 100 
    EndIf 
    OldMouseX = MouseX() 
    OldMouseY = MouseY() 
    
    CheckMapCoordinates() 
  ElseIf ButtonStateRight 
    ButtonStateRight = 0 
  EndIf 

  If TileWidth * TileNumber\Width - MapX * 100 / Zoom  < #ScreenWidth 
    ClearScreen(0) 
  EndIf 

  ;Karte anzeigen 
  DisplayMap(MapX, MapY, #ScreenWidth, #ScreenHeight);, #ScreenWidth * Zoom, #ScreenHeight * Zoom) 
  
  FPSCounter + 1 
  If ElapsedMilliseconds() >= FPSTimer + 1000 : FPS = FPSCounter : FPSCounter = 0 : FPSTimer = ElapsedMilliseconds() : EndIf 

  ;GUI 
  StartDrawing(ScreenOutput()) 
    DrawingMode(0) 
    DrawText(5, 5, "FPS: " + Str(FPS), $ffffff, 0) 
    DrawText(75, 5, "Zoom: " + Str(Zoom) + " %", $ffffff, 0) 
    DrawText(190, 5, "Sprites: " + Str(TileNumber\Width) + " x " + Str(TileNumber\Height), $ffffff, 0) 
    DrawText(300, 5, "MapX/MapY: " + Str(MapX) + " / " + Str(MapY), $ffffff, 0) 
    DrawText(600, 5, "MouseRight: " + Str(ButtonStateRight), $ffffff, 0) 
    
    Circle(MouseX(), MouseY(), 2, $FFFFFF) 
  StopDrawing() 
  FlipBuffers() 
  
  ;Zeitberechnung 
  LoopTime = ElapsedMilliseconds() - Timer 
  Timer = ElapsedMilliseconds() 
  
  ;Tastatur, per Any-Key aus dem ganzen raus gehen 
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_All) <> #False 
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger