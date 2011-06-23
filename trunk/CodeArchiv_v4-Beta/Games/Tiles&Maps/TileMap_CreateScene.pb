; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10196&postdays=0&postorder=asc&start=20
; Author: PMV (code updated with a working example by Andre)
; Date: 07. October 2006
; OS: Windows
; Demo: Yes


; Little procedure, which loads a set of map tiles and create a
; sprite with the scene of it.

; Hier hab ich ne kleine Prozedur erstellt, die ein Sprite mit der 
; entsprechenden Szene zurück gibt. Damit sind Diashows mit größeren 
; Schnick-Schnack kein problem. (Stichwort "Überblenden" als Beispiel) 
; Zur Veranschaulichung hab ich zusätzlich noch ein kleines Programm 
; geschrieben, das diese Prozedur nutzt, um eine Diashow in der 
; einfachsten Form zu zeigen. Die Größe des Fensters kann beliebig 
; verändert werden. 

;die Größe des Fensters kann nach belieben verändert werden  (darf nicht größer als die Map sein!)
#WindowWidth = 100 ;-PB-Bug unter ca. 120 gibts einen Rand im Screen o_O 
#WindowHeight = 100 

; ---------------------------------------------------------------------- 
; ---------------------------------------------------------------------- 
;ab hier beginnt das Programm selber, Änderungen auf eigene Gefahr *lol* 
#MapWidth = 10 
#MapHeight = 3 
#AlleTiles = #MapWidth * #MapHeight
#TileWidth = 64
#TileHeight = 64 
Global Dim Map(#MapWidth - 1, #MapHeight - 1) 


;Gibt ein Sprite mit der übergebenen Szene zurück 
Procedure CreateScene(X, Y, Width, Height, Mode=0) 
  Protected TileX.l, TileY.l, DisplayX.l, DisplayY.l 
  If X > 0 : X * -1 : EndIf 
  If Y > 0 : Y * -1 : EndIf 
  If -X > #TileWidth * #MapWidth - #WindowWidth 
    ProcedureReturn #False 
  ElseIf -Y > #TileHeight * #MapHeight - #WindowHeight 
    ProcedureReturn #False 
  EndIf 
  Sprite = CreateSprite(#PB_Any, Width, Height, Mode) 
  If Not Sprite : ProcedureReturn #False : EndIf 
  UseBuffer(Sprite) 
  
  TileX = Abs(Int(X / #TileWidth)) 
  TileY = Abs(Int(Y / #TileHeight)) 

  ;-PB-Bug
  ;bei Konstanten können keine negativen reste raus kommen
  ;oder ist es ein Bug, das es mit geht? *lol*
  Protected TileWidth.l = #TileWidth
  Protected TileHeight.l = #TileHeight
  For DisplayX = X % TileWidth To Width-1 Step #TileWidth 
    For DisplayY = Y % TileHeight To Height-1 Step #TileHeight 
      DisplaySprite(Map(TileX, TileY), DisplayX, DisplayY) 
      TileY + 1 
    Next 
    TileY = Abs(Int(Y / #TileHeight)) 
    TileX + 1 
  Next 
  UseBuffer(-1) 
  ProcedureReturn Sprite 
EndProcedure 
; ------------------------------------------------------------- 

InitSprite() 
;UsePNGImageDecoder() 

MainWindow = OpenWindow(#PB_Any, 0, 0, #WindowWidth, #WindowHeight, "LovePix - Diashow", #PB_Window_Invisible | #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
OpenWindowedScreen(WindowID(MainWindow), 0, 0, #WindowWidth, #WindowHeight, 0, 0, 0) 

ProgressWindow = OpenWindow(#PB_Any, 0, 0, 310, 30, "Loading...", #PB_Window_BorderLess |#PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(ProgressWindow)) 
ContainerGadget(#PB_Any, -1, -1, 310, 30, #PB_Container_Raised) 
Progress = ProgressBarGadget(#PB_Any, 3, 3, 300, 20, 0, #AlleTiles) 

;laden der Grafiken 
x = 0 
y = 0 
For i = 0 To #AlleTiles-1
  While WindowEvent() : Wend 
  Map(x, y) = LoadSprite(#PB_Any, "..\..\Graphics\Gfx\TileSet\" + RSet(Str(i+1), 3, "0") + ".bmp") 
  If Not Map(X, Y) 
    MessageRequester("Error", "Can't load sprite " + RSet(Str(i+1), 3, "0") + "!") 
    End 
  EndIf 
  x + 1 
  If x >= #MapWidth : y + 1 : x = 0 : EndIf 
  SetGadgetState(Progress, i + 1) 
Next 
CloseWindow(ProgressWindow) 
HideWindow(MainWindow, #False) 

;Hauptschleife 
Time = Random(3000) + 1000 ;zufällige Anzeigedauer pro Bild 
Timer = ElapsedMilliseconds() - Time 
Repeat 
  If Timer + Time <= ElapsedMilliseconds() 
    Timer = ElapsedMilliseconds() 
    Time = Random(3000) + 1000 ;zufällige Anzeigedauer pro Bild 

    If Szene : FreeSprite(Szene) : EndIf 
    PosX = Random(#TileWidth * #MapWidth - #WindowWidth) 
    PosY = Random(#TileHeight * #MapHeight - #WindowHeight) 
    Szene = CreateScene(PosX, PosY, #WindowWidth, #WindowHeight) 

    DisplaySprite(Szene, 0, 0)
    FlipBuffers() 
  EndIf 
Until WaitWindowEvent(100) = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP