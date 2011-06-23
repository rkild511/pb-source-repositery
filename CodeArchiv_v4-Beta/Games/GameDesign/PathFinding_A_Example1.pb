; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=4877&highlight=
; Author: crossroads (updated for PB 4.00 by Andre)
; Date: 22. June 2004
; OS: Windows
; Demo: No

; Hier eine einfache Umsetzung des A* - Algorithmus. 
; Der Code ist nur spärlich kommentiert (zu wenig Zeit/Lust  ) 
; Wer mehr wissen will: 
; A* Pathfinding for Beginners: http://www.policyalmanac.org/games/aStarTutorial.htm
; Oder im WWW nach "Pathfinding" suchen. 
; Zum Prog: 
; Der rote Kreis ist der "Jäger", der grüne das "Opfer". Graue Kästchen markieren den errechneten Pfad. 
; Farbige Felder sind begehbar, alles andere (schwarz) nicht. 
; Mit ESC Abbruch. 
; F1 startet neu. 
; 
; A* path finding demo by crossroads 2004 

; for more info about the A* algorithm visit: 
; http://www.policyalmanac.org/games/aStarTutorial.htm 
; or search the WWW for 'pathfinding' 

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
  px.s 
  py.s 
EndStructure 

Global enemy.POINT, target.POINT, walkto.POINT 
Global walk.way, hunt.way 

Global Dim Map(7, 7) 
For i = 0 To 7 
  Read byval.b 
  For j = 0 To 7 
    x = Int(Pow(2, 7 - j)) 
    If byval & x 
      Map(i, j) = 1 
    Else 
      Map(i, j) = 0 
    EndIf 
  Next j 
Next i 

Global NewList opPath.a_star() 
Global NewList clPath.a_star() 

Declare placeChar(*char.POINT) 
Declare displayAll(txt$) 
Declare.l calcPath(*path.way, *stop.POINT) 
Declare.l chkNode(x, y, stopX, stopY) 
Declare fndPth_a(*strt.POINT, *stop.POINT) 

;- A* procs 
Procedure fndPth_a(*strt.POINT, *stop.POINT) 
  ClearList(opPath()) 
  ClearList(clPath()) 
  AddElement(opPath()); Add the starting square to the open list. 
  opPath()\x = *strt\x 
  opPath()\y = *strt\y 
  opPath()\parentX = -1 
  opPath()\parentY = -1 
  opPath()\gCost = 0 
  opPath()\hCost = Abs(*strt\x - *stop\x) + Abs(*strt\y - *stop\y) 
  
  While FirstElement(opPath()) 
    cost = opPath()\gCost + opPath()\hCost:linx = 0 
    ForEach opPath(); Look for the lowest F cost square on the open list 
      fCost = opPath()\gCost + opPath()\hCost 
      If cost > fCost:cost = fCost:linx = ListIndex(opPath()):EndIf 
    Next 

    SelectElement(opPath(), linx); Switch it to the closed list 
    LastElement(clPath()) 
    AddElement(clPath()) 
    CopyMemory(@opPath(), @clPath(), SizeOf(a_star)) 
    DeleteElement(opPath()) 
    posx = clPath()\x:posy = clPath()\y 
    If posx = *stop\x And posy = *stop\y:Break:EndIf; target found! 
    
    LastElement(opPath()) 
    For i = 0 To 3; Examine squares adjacent to the current square 
      Select i 
        Case 0:If posx > 0:chkNode(posx - 1, posy, *stop\x, *stop\y):EndIf 
        Case 1:If posx < 7:chkNode(posx + 1, posy, *stop\x, *stop\y):EndIf 
        Case 2:If posy > 0:chkNode(posx, posy - 1, *stop\x, *stop\y):EndIf 
        Case 3:If posy < 7:chkNode(posx, posy + 1, *stop\x, *stop\y):EndIf 
      EndSelect 
    Next i 
  Wend 
EndProcedure 

Procedure.l chkNode(x, y, stopX, stopY) 
  If Map(x, y); If it is not walkable or if it is on the closed list, ignore it 
    ForEach clPath() 
      If clPath()\x = x And clPath()\y = y:ProcedureReturn 0:EndIf 
    Next 
    
    ForEach opPath(); If it is on the open list already, check to see if this path to that square is better, using G cost as the measure 
      If opPath()\x = x And opPath()\y = y 
        LastElement(clPath()) 
        If clPath()\gCost + 1 < opPath()\gCost 
          opPath()\gCost   = clPath()\gCost + 1 
          opPath()\parentX = clPath()\x 
          opPath()\parentY = clPath()\y 
          ProcedureReturn 0 
        EndIf 
        ProcedureReturn 0 
      EndIf 
    Next 
    
    LastElement(clPath()) 
    hCost = Abs(x - target\x) + Abs(y - target\y) 
    LastElement(opPath()) 
    AddElement(opPath()); If it isn’t on the open list, add it to the open list 
    opPath()\gCost   = clPath()\gCost + 1 
    opPath()\hCost   = hCost 
    opPath()\parentX = clPath()\x 
    opPath()\parentY = clPath()\y 
    opPath()\x = x 
    opPath()\y = y 
  EndIf 
EndProcedure 

Procedure.l calcPath(*path.way, *stop.POINT) 
  If CountList(clPath()) 
    ForEach clPath() 
      If clPath()\x = *stop\x And clPath()\y = *stop\y 
        posx = *stop\x:posy = *stop\y 
        *path\px = "":*path\py = "" 
        Break 
      EndIf 
    Next 
    For i= CountList(clPath()) - 1 To 1 Step -1 
      SelectElement(clPath(), i) 
      If clPath()\x = posx And clPath()\y = posy 
        *path\px + Chr(48 + posx):*path\py + Chr(48 + posy) 
        posx = clPath()\parentX:posy = clPath()\parentY 
      EndIf 
    Next 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

;- Common procs 
Procedure displayAll(txt$) 
  ClearScreen(RGB(0,0,0))
  DisplaySprite(0, 0, 0) 
  StartDrawing(ScreenOutput()) 
  For i = 1 To Len(hunt\px) 
    x = Val(Mid(hunt\px, i, 1)) 
    y = Val(Mid(hunt\py, i, 1)) 
    Box(y * 64 + 16, x * 64 + 16, 32, 32, RGB($C0,$C0,$C0)) 
  Next i 
  Circle((enemy\y * 64) + 32, (enemy\x * 64) + 32, 16, RGB($FF,$80,$FF)) 
  Circle((target\y * 64) + 32, (target\x * 64) + 32, 16, RGB($00,$A4,$00)) 
  DrawingMode(1) 
  FrontColor(RGB($FF,$FF,$FF))
  DrawText(0, 560, txt$) 
  StopDrawing() 
  FlipBuffers() 
EndProcedure 

Procedure placeChar(*char.POINT) 
  Repeat 
    *char\x = Random(7) 
    *char\y = Random(7) 
  Until Map(*char\x, *char\y) 
EndProcedure 

;- Main 

If OpenScreen(800, 600, 32, "Path finding") 
  If CreateSprite(0, 64 * 8, 64 * 8, 0):Else:End:EndIf 
  StartDrawing(SpriteOutput(0)) 
  For i = 0 To 7 
    For j = 0 To 7 
      If Map(i, j) 
        If (j % 2) ! (i % 2) 
          Box(j * 64, i * 64, 64, 64, RGB($FF,$00,$00)) 
        Else 
          Box(j * 64, i * 64, 64, 64, RGB($80,$80,$FF)) 
        EndIf 
      EndIf 
    Next j 
  Next i 
  StopDrawing() 
  
  Repeat 
    hunt\px = "":walk\px = "" 
    placeChar(@enemy) 
    Repeat 
      placeChar(@target) 
    Until Abs(enemy\x - target\x) > 2 Or Abs(enemy\y - target\y) > 2 
    
    displayAll("") 
    Delay(4000) 
  
    Repeat 
      If Len(walk\px) = 0 
        Repeat 
          placeChar(@walkto) 
        Until Abs(target\x - walkto\x) > 2 Or Abs(target\y - walkto\y) > 2 
        fndPth_a(@target, @walkto) 
        calcPath(@walk, @walkto) 
      EndIf 
      target\x = Val(Right(walk\px, 1)) 
      target\y = Val(Right(walk\py, 1)) 
      walk\px = Left(walk\px, Len(walk\px) - 1) 
      walk\py = Left(walk\py, Len(walk\py) - 1) 
      
      If enemy\x <> target\x Or enemy\y <> target\y 
        fndPth_a(@enemy, @target) 
        calcPath(@hunt, @target) 
        enemy\x = Val(Right(hunt\px, 1)) 
        enemy\y = Val(Right(hunt\py, 1)) 
      EndIf 
      
      displayAll("ESC - Exit") 
      Delay(320) 
      
      ExamineKeyboard() 
    Until KeyboardPushed(#PB_Key_Escape) Or (enemy\x = target\x And enemy\y = target\y) 
    
    hunt\px = "" 
    displayAll("ESC - Exit   F1 - Start again") 
    Repeat 
      ExamineKeyboard() 
      If KeyboardPushed(#PB_Key_Escape):Break 2:EndIf 
    Until KeyboardPushed(#PB_Key_F1) 
  ForEver 

;- Test  
  
  enemy\x = 0 
  enemy\y = 0 
  target\x = 7 
  target\y = 7 
  tt1 = GetTickCount_() 
  For tst = 1 To 1000 
    fndPth_a(@enemy, @target) 
  Next tst 
  tt2 = GetTickCount_() 
  Debug "Time (1000 loops): " + Str(tt2 - tt1) + ", Start: " + Str(tt1) + ", Stop: " + Str(tt2) 
  Debug "---------------" 
Else 
  MessageRequester("Error", "Can't open 800 x 600 screen", 0) 
EndIf 

End 

DataSection 
Data.b %11111111,%10011001,%10111101,%10111101,%11111111,%11011011,%10011001,%11111111 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -