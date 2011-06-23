; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9574&highlight=
; Author: Criss
; Date: 25. August 2006
; OS: Windows
; Demo: Yes

; With this include you can easily program a Jump & Run game!
; The example shows how you can do this!

; Mit dieser Include ist es möglich schnell und einfach ein Jump & Run -Spiel 
; zu programmieren! Das Beispiel zeigt wie das ganze funktioniert! 


Global Dim game_map.l(2, 15, 15) ; 3 Layer / 16 Tiles hoch / 16 Tiles breit 
Global mapoffsetx.l, mapoffsety.l 


; Karte in die mitte des Bildschirms setzen 
mapoffsetx = 144 
mapoffsety = 44 


; Jump&Run - Engine initialisieren 
XIncludeFile "JumpnRun_Routines.pbi" 
If jnr_init(15, 15, 32, 32, 32, 32, 2, 4, mapoffsetx, mapoffsety) = #False 
  MessageRequester("Fähler!", "D'Jump & Run - Engine cha nid initialisiert wärde!", #MB_ICONERROR) 
  End 
EndIf 


; Spielerposition setzen 
jnr\x = mapoffsetx + 64 
jnr\y = mapoffsety + 64 


LoadFont(0, "Terminal", 8, #PB_Font_Bold) 


Procedure readmap() 
  Restore game_data 
  For z1 = 0 To 2 
    For z2 = 0 To 15 
      For z3 = 0 To 15 
        Read game_map(z1, z2, z3) 
      Next z3 
    Next z2 
  Next z1 
EndProcedure 


Procedure drawmap() 

  ; Long splitten ?!? ... (Sprites) ... 
  
  For z1 = 0 To 2 
    For z2 = 0 To 15 
      For z3 = 0 To 15 
        If game_map(z1, z2, z3) > 0 
          DisplayTransparentSprite((z1 * 100) + game_map(z1, z2, z3), mapoffsetx + (z3 * 32), mapoffsety + (z2 * 32)) 
        EndIf 
      Next z3 
    Next z2 
  Next z1 
EndProcedure 


Procedure detectkeys() 
  key = #False 
  ExamineKeyboard() 
  
  ; Spiel beenden 
  If KeyboardPushed(#PB_Key_Escape) 
    End 
  EndIf 
  
  ; Springen  
  If KeyboardPushed(#PB_Key_Space) 
    key = jnr_jumping(22, 300) 
  EndIf 
  
  ; Nach Rechts laufen 
  If KeyboardPushed(#PB_Key_Right) 
    key = jnr_right() 
  EndIf 

  ; Nach Links laufen 
  If KeyboardPushed(#PB_Key_Left) 
    key = jnr_left() 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Down) 
    key = jnr_down() 
  EndIf 
  
EndProcedure 


Procedure getfps() 
  Static GetFPS_Count.l, GetFPS_FPS.l, GetFPS_Start.l 
  GetFPS_Count + 1 
  If GetFPS_Start = 0 
    GetFPS_Start = ElapsedMilliseconds() 
  EndIf 
  If ElapsedMilliseconds() - GetFPS_Start >= 1000 
    GetFPS_FPS   = GetFPS_Count 
    GetFPS_Count = 0 
    GetFPS_Start + 1000 
  EndIf 
  ProcedureReturn GetFPS_FPS 
EndProcedure 


Procedure infos() 
  StartDrawing(ScreenOutput()) 
    DrawingFont(FontID(0)) 
    DrawingMode(#PB_2DDrawing_Transparent) 
    fps.s = Str(getfps()) + " FPS" 
    DrawText(4, 2, fps, RGB(120, 120, 120)) 
    Select jnr_gettile(jnr\x, jnr\y) 
      Case 0 
        typ.s = "..." 
      Case 1 
        typ.s = "..." 
      Case 2 
        typ.s = "WOLKE" 
    EndSelect 
    DrawText(4, 14, "TILETYP " + Str(jnr_gettile(jnr\x, jnr\y)) + " (" + typ + ")", RGB(120, 120, 120)) 
    DrawText(4, GetSystemMetrics_(#SM_CYSCREEN) - TextHeight(jnr\engine) - 2, jnr\engine, RGB(120, 120, 255)) 
    DrawText(GetSystemMetrics_(#SM_CXSCREEN) - TextWidth(jnr\copyright) - 4, GetSystemMetrics_(#SM_CYSCREEN) - TextHeight(jnr\copyright) - 2, jnr\copyright, RGB(80, 80, 80)) 
  StopDrawing() 
EndProcedure 


Procedure checkobjects() 
  Select game_map(2, ((jnr\y - mapoffsety) + jnr\pheight / 2) / jnr\theight, ((jnr\x - mapoffsetx) + jnr\pwidth / 2) / jnr\twidth) 
    Case 1 ; Münze 
      game_map(2, ((jnr\y - mapoffsety) + jnr\pheight / 2) / jnr\theight, ((jnr\x - mapoffsetx) + jnr\pwidth / 2) / jnr\twidth) = 0 
  
  EndSelect 
EndProcedure 


; DirectX - Initialisieren 
If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMovie() = 0 Or InitSound() = 0 
  MessageRequester("Fähler!", "Du hesch en alti Version oder keis Diräktix!", #MB_ICONERROR) 
  End 
EndIf 


; Screen öffnen 
If OpenScreen(800, 600, 32, jnr\engine) 


  ; Framerate hier anpassen, damit das ganze nicht zu schnell/langsam läuft! 
  SetFrameRate(100) 

  
  ; Tiles erstellen 
  TransparentSpriteColor(#PB_Default, RGB(0, 0, 0)) 
  
  
  ; Spieler 
  CreateSprite(1000, 32, 32) 
  StartDrawing(SpriteOutput(1000)) 
    DrawingMode(#PB_2DDrawing_Default) 
    Box(0, 0, 32, 32, RGB(0, 80, 0)) 
    DrawingMode(#PB_2DDrawing_Outlined) 
    Box(0, 0, 32, 32, RGB(0, 120, 0)) 
  StopDrawing() 
  
  
  ; Boden / Wand / Mauer 
  CreateSprite(101, 32, 32) 
  StartDrawing(SpriteOutput(101)) 
    DrawingMode(#PB_2DDrawing_Default) 
    Box(0, 0, 32, 32, RGB(80, 80, 80)) 
    DrawingMode(#PB_2DDrawing_Outlined) 
    Box(0, 0, 32, 32, RGB(120, 120, 120)) 
  StopDrawing() 

  ; Kiste (Wolkentyp) 
  CreateSprite(102, 32, 32) 
  StartDrawing(SpriteOutput(102)) 
    DrawingMode(#PB_2DDrawing_Default) 
    Box(0, 0, 32, 32, RGB(160, 104, 0)) 
    DrawingMode(#PB_2DDrawing_Outlined) 
    Box(0, 0, 32, 32, RGB(200, 144, 40)) 
    LineXY(0, 0, 32, 32, RGB(180, 124, 20)) 
    LineXY(32, 0, 0, 32, RGB(180, 124, 20)) 
  StopDrawing() 


  ; Gegenstand zum aufnehmen 
  CreateSprite(201, 32, 32) 
  StartDrawing(SpriteOutput(201)) 
    DrawingMode(#PB_2DDrawing_Default) 
    Circle(16, 16, 16, RGB(80, 80, 0)) 
    DrawingMode(#PB_2DDrawing_Outlined) 
    Circle(16, 16, 16, RGB(120, 120, 0)) 
    Circle(16, 16, 13, RGB(120, 120, 0)) 
  StopDrawing() 
  
  
  ; Karte laden 
  readmap() 
  
  
  ; Main-Loop 
  Repeat 
    ; eventid.l = WindowEvent() 
    ClearScreen(RGB(16, 16, 16)) 
    detectkeys() 
    jnr_loop() 
    drawmap() 
    DisplayTransparentSprite(1000, jnr\x, jnr\y) 
    checkobjects() 
    infos() 
    FlipBuffers(0) 
  ForEver 
EndIf 
End 


; Map-Daten 
DataSection 

jnr_data: 
; Info-Daten für die Jump&Run - Engine 
;   Begehbar  | Typ 
; 0 (#False)  = - 
; 1 (#True)   = - 
; 2 (#True)   = Wolke (Cloud) 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,0,1,1,1,1,1,1,1,1,2,1,1,0 
Data.l 0,1,1,1,1,1,0,1,1,1,1,2,2,2,1,0 
Data.l 0,1,1,1,1,1,1,1,1,1,2,2,2,2,2,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 


; Eigentliche Spiele-Map-Daten 
game_data: 

; Layer 0 (Hinten) 
; ---------------- 
; 0 = Leer -> Kein Tile 
; 1 = Boden / Wand / Mauer 
; 2 = Kiste (Wolkentyp) 
; ... 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 

; Layer 1 (Mitte) 
; --------------- 
; 0 = Leer / Kein Tile 
; 1 = Münze 
; ... 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
Data.l 1,0,0,1,0,0,0,0,0,0,0,0,2,0,0,1 
Data.l 1,0,0,0,0,0,1,0,0,0,0,2,2,2,0,1 
Data.l 1,0,0,0,0,0,0,0,0,0,2,2,2,2,2,1 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 

; Layer 2 (Vorne) 
; --------------- 
; 0 = Leer / Kein Tile 
; ... 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 

EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP