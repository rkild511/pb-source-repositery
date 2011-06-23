; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2888&highlight=
; Author: Criss (updated for PB 4.00 by Andre)
; Date: 09. April 2005
; OS: Windows
; Demo: Yes


;- Initialize 
If InitSprite() = #False Or InitKeyboard() = #False 
  MessageRequester("Error", "Can't initialize DirectX", 0) 
EndIf 

Structure a_star 
  x.l 
  y.l 
  parentX.l 
  parentY.l 
  gCost.l 
  hCost.l 
EndStructure 

Structure way 
  px.l 
  py.l 
EndStructure 

Global enemy.POINT, target.POINT, walkto.POINT 
Global walk.way, hunt.way 
Global mapheight, mapwidth 

mapheight = 24 
mapwidth = 32 

Global Dim Map(mapheight, mapwidth) 

For i = 0 To mapheight - 1 
  For j = 0 To mapwidth - 1 
    Read Map(i, j) 
  Next 
Next 

Global NewList openPath.a_star() 
Global NewList closedPath.a_star() 

Declare placeChar(*char.POINT) 
Declare displayAll(txt$) 
Declare.l calcPath(*path.way, *stop.POINT) 
Declare.l chkNode(x, y, stopX, stopY) 
Declare fndPth_a(*strt.POINT, *stop.POINT) 

;- A* procs 
Procedure fndPth_a(*strt.POINT, *stop.POINT) 
  ClearList(openPath()) 
  ClearList(closedPath()) 
  AddElement(openPath()); Add the starting square to the open list. 
  openPath()\x = *strt\x 
  openPath()\y = *strt\y 
  openPath()\parentX = -1 
  openPath()\parentY = -1 
  openPath()\gCost = 0 
  openPath()\hCost = Abs(*strt\x - *stop\x) + Abs(*strt\y - *stop\y) 
  
  While FirstElement(openPath()) 
    cost = openPath()\gCost + openPath()\hCost:linx = 0 
    ForEach openPath(); Look for the lowest F cost square on the open list 
      fCost = openPath()\gCost + openPath()\hCost 
      If cost > fCost:cost = fCost:linx = ListIndex(openPath()):EndIf 
    Next 
    
    SelectElement(openPath(), linx); Switch it to the closed list 
    LastElement(closedPath()) 
    AddElement(closedPath()) 
    CopyMemory(@openPath(), @closedPath(), SizeOf(a_star)) 
    DeleteElement(openPath()) 
    posx = closedPath()\x 
    posy = closedPath()\y 
    If posx = *stop\x And posy = *stop\y:Break:EndIf; target found! 
    
    LastElement(openPath()) 
    For i = 1 To 4; Examine squares adjacent to the current square 
      Select i 
        Case 1:If posx > 0:chkNode(posx - 1, posy, *stop\x, *stop\y):EndIf 
        Case 2:If posx < mapheight - 1:chkNode(posx + 1, posy, *stop\x, *stop\y):EndIf 
        Case 3:If posy > 0:chkNode(posx, posy - 1, *stop\x, *stop\y):EndIf 
        Case 4:If posy < mapwidth - 1:chkNode(posx, posy + 1, *stop\x, *stop\y):EndIf 
      EndSelect 
    Next 
  Wend 
EndProcedure 

Procedure.l chkNode(x, y, stopX, stopY) 
  If Map(x, y) = 1; If it is not walkable or if it is on the closed list, ignore it 
    ForEach closedPath() 
      If closedPath()\x = x And closedPath()\y = y:ProcedureReturn 0:EndIf 
    Next 
    
    ForEach openPath(); If it is on the open list already, check to see if this path to that square is better, using G cost as the measure 
      If openPath()\x = x And openPath()\y = y 
        LastElement(closedPath()) 
        If closedPath()\gCost + 1 < openPath()\gCost 
          openPath()\gCost   = closedPath()\gCost + 1 
          openPath()\parentX = closedPath()\x 
          openPath()\parentY = closedPath()\y 
          ProcedureReturn 0 
        EndIf 
        ProcedureReturn 0 
      EndIf 
    Next 
    
    LastElement(closedPath()) 
    hCost = Abs(x - target\x) + Abs(y - target\y) 
    LastElement(openPath()) 
    AddElement(openPath()); If it isn’t on the open list, add it to the open list 
    openPath()\gCost   = closedPath()\gCost + 1 
    openPath()\hCost   = hCost 
    openPath()\parentX = closedPath()\x 
    openPath()\parentY = closedPath()\y 
    openPath()\x = x 
    openPath()\y = y 
  EndIf 
EndProcedure 

Procedure.l calcPath(*path.way, *stop.POINT) 
  If CountList(closedPath()) 
    ForEach closedPath() 
      If closedPath()\x = *stop\x And closedPath()\y = *stop\y 
        posx = *stop\x 
        posy = *stop\y 
        *path\px = 0 
        *path\py = 0 
        Break 
      EndIf 
    Next 
    For i= CountList(closedPath()) - 1 To 1 Step -1 
      SelectElement(closedPath(), i) 
      If closedPath()\x = posx And closedPath()\y = posy 
        *path\px = posx 
        *path\py = posy 
        posx = closedPath()\parentX 
        posy = closedPath()\parentY 
      EndIf 
    Next 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

;- Common procs 
Procedure displayAll(txt$) 
  ClearScreen(RGB(0, 0, 0))
  DisplaySprite(0, 0, 0) 
  StartDrawing(ScreenOutput()) 
  
  ;For i = 1 To hunt\px 
  ;  x = hunt\px 
  ;  y = hunt\py 
  ;  Box(y * 24+1, x * 24+1, 22, 22, RGB($C0,$C0,$C0)) 
  ;Next 
  DrawingMode(0) 
  Circle((enemy\y * 24) + 12, (enemy\x * 24) + 12, 10, RGB($FF,$80,$FF)) 
  Circle((target\y * 24) + 12, (target\x * 24) + 12, 10, RGB($00,$A4,$00)) 
  DrawingMode(4) 
  Circle((enemy\y * 24) + 12, (enemy\x * 24) + 12, 10, RGB($00,$00,$00)) 
  Circle((target\y * 24) + 12, (target\x * 24) + 12, 10, RGB($00,$00,$00)) 
  DrawingMode(0) 
  DrawingMode(1) 
  FrontColor(RGB($FF,$FF,$FF))
  DrawText(0, 560, txt$) 
  StopDrawing() 
  FlipBuffers() 
EndProcedure 

Procedure placeChar(*char.POINT) 
  Repeat 
    *char\x = Random(mapheight - 1) 
    *char\y = Random(mapwidth - 1) 
  Until Map(*char\x, *char\y) = 1 
EndProcedure 

;- Main 

If OpenScreen(800, 600, 16, "Pathfinding A*") 
  If CreateSprite(0, 24 * mapwidth - 1, 24 * mapheight - 1, 0):Else:End:EndIf 
  StartDrawing(SpriteOutput(0)) 
  For i = 0 To mapheight - 1 
    For j = 0 To mapwidth - 1 
      If Map(i, j) = 1 
        Box(j * 24, i * 24, 24, 24, RGB($AA,$AA,$AA)) 
      Else 
        DrawingMode(0) 
        Box(j * 24, i * 24, 24, 24, RGB($FF,$FF,$FF)) 
        DrawingMode(4) 
        ;Box(j * 24, i * 24, 24, 24, RGB($00,$00,$00)) 
        DrawingMode(0) 
      EndIf 
    Next j 
  Next i 
  StopDrawing() 
  
  Repeat 
    hunt\px = 0:walk\px = 0 
    placeChar(@enemy) 
    Repeat 
      placeChar(@target) 
    Until Abs(enemy\x - target\x) > 2 Or Abs(enemy\y - target\y) > 2 
    
    displayAll("") 
    
    Repeat 
      
      If enemy\x <> target\x Or enemy\y <> target\y 
        fndPth_a(@enemy, @target) 
        calcPath(@hunt, @target) 
        enemy\x = hunt\px 
        enemy\y = hunt\py 
        Delay(100) 
      EndIf 
      
      displayAll("ESC - Exit") 
      
      ExamineKeyboard() 
    Until KeyboardPushed(#PB_Key_Escape) Or (enemy\x = target\x And enemy\y = target\y) 
    
    hunt\px = 0 
    displayAll("ESC - Exit   F1 - Start again") 
    Repeat 
      ExamineKeyboard() 
      If KeyboardPushed(#PB_Key_Escape):Break 2:EndIf 
    Until KeyboardPushed(#PB_Key_F1) 
  ForEver 
  
Else 
  MessageRequester("Error", "Can't open 800 x 600 screen", 0) 
EndIf 

End 

DataSection 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,1,0,1,1,0,0,0,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,1,1,1,1,1,1,0,0,0,0,0 
Data.l 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,1,1,1,1,1,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,1,0,1,1,1,1,1,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,1,1,1,1,1,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -