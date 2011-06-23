; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3591&highlight=
; Author: ZeHa (updated for PB 4.00 by Andre)
; Date: 07. June 2005
; OS: Windows
; Demo: Yes 

; 
;      **************************** 
;    ******************************** 
;  ***                              *** 
; ***                                *** 
; ***          MAZE MISSION          *** 
; ***                                *** 
; ***  © 2005 by Christian Gleinser  *** 
; ***                                *** 
;  ***                              *** 
;    ******************************** 
;      **************************** 



InitSprite() 
InitKeyboard() 

Global breite.b 
Global hoehe.b 
Global cnt.l 
Global rndness.b, maxrnd.b 

Global cx.b, cy.b 
Global Dim zelle(500,500,5) 
Global Dim maze.b(1001,1001) 
Global Dim bereits(4) 
Global modus.b 
Global mrichtung.b 
Global anzeigen.b 
Global deadends.l 
Global mazefertig.b 

Global PlayerX.w, PlayerY.w 
Global richtung.b, walk.b, Blickrichtung.b 
Global anicnt.l 

Global Dim GegnerX.w(500) 
Global Dim GegnerY.w(500) 
Global Dim GegnerRichtung.b(500) 
Global GegnerAnzahl.l 
Global ganicnt.l 

Global Dim MuniX.w(100) 
Global Dim MuniY.w(100) 
Global MuniAnzahl.l 
Global Munition.l 

Global ShotX.w, ShotY.w 
Global Shoot.b 
Global ShootRichtung.b 

Global mission.b 
Global Zeit.w 

Global BlueX.w 
Global BlueY.w 

Global TheButtonX.w 
Global TheButtonY.w 

Global ExitX.w 
Global ExitY.w 

Global newgame.b 

Declare removesomedeadends() 
Declare makesomerooms() 
Declare scheiss() 
Declare init() 
Declare map() 
Declare MakeSomeSprites() 
Declare game() 
Declare gameover() 
Declare explode() 
Declare Display() 
Declare DisplayMaze() 
Declare DisplayItems() 
Declare DisplayPlayer() 
Declare DisplayEnemies() 
Declare Controls() 
Declare Player() 
Declare Enemies() 
Declare Richtungswechsel(i.l) 

#links=0 
#rechts=1 
#hoch=2 
#runter=3 




Procedure umrechnenfinal() 
  For i = 2 To breite*2 Step 2 
    For j = 2 To hoehe*2 Step 2 
      If zelle(i/2,j/2,5)=1 
        maze(i-1,j-1)=1 
      EndIf 
      
      If zelle(i/2,j/2,2)=1 
        maze(i-1,j-1)=1 
        maze(i+1-1,j-1)=1 
      EndIf 
      If zelle(i/2,j/2,3)=1 
        maze(i-1,j-1)=1 
        maze(i-1,j+1-1)=1 
      EndIf 
    Next j 
  Next i 
  
  makesomerooms() 
EndProcedure 



Procedure umrechnen() 
  For i = 1 To breite 
    For j = 1 To hoehe 
      If zelle(i,j,1)=1 
        zelle(i,j-1,3)=1 
      EndIf 
      If zelle(i,j,2)=1 
        zelle(i+1,j,4)=1 
      EndIf 
      If zelle(i,j,3)=1 
        zelle(i,j+1,1)=1 
      EndIf 
      If zelle(i,j,4)=1 
        zelle(i-1,j,2)=1 
      EndIf 
    Next j 
  Next i 
EndProcedure 


Procedure calcmaze() 
  If modus=0 
    If cnt>=breite*hoehe 
      modus=1 
      umrechnen() 
      removesomedeadends() 
    EndIf 
  EndIf 
  
  
  If zelle(cx, cy, 5)=0 
    zelle(cx, cy, 5)=1 
    cnt=cnt+1 
  EndIf 
  
  
  While erfolg=0 
    rndness=rndness+1 
    If rndness=1 
      maxrnd=Int(Random(Int(breite/10)+1)+2) 
      mrichtung=Int(Random(3)+1) 
    EndIf 
    
    bereits(mrichtung)=1 
    If bereits(1) And bereits(2) And bereits(3) And bereits(4) 
      Break 
    EndIf 
    
    Select mrichtung 
      Case 1: 
        If cy>1 
          If zelle(cx,cy-1,5)=0 
            zelle(cx,cy,1)=1 
            cy=cy-1 
            erfolg=1 
          EndIf 
        EndIf 
      Case 2: 
        If cx<breite 
          If zelle(cx+1,cy,5)=0 
            zelle(cx,cy,2)=1 
            cx=cx+1 
            erfolg=1 
          EndIf 
        EndIf 
      Case 3: 
        If cy<hoehe 
          If zelle(cx,cy+1,5)=0 
            zelle(cx,cy,3)=1 
            cy=cy+1 
            erfolg=1 
          EndIf 
        EndIf 
      Case 4: 
        If cx>1 
          If zelle(cx-1,cy,5)=0 
            zelle(cx,cy,4)=1 
            cx=cx-1 
            erfolg=1 
          EndIf 
        EndIf 
    EndSelect 
  Wend 
  
  If rndness>=maxrnd 
    rndness=0 
  EndIf 
  
  
  For i = 1 To 4: bereits(i)=0: Next i 
  If erfolg=0 
    Repeat 
      cx=Int(Random(breite-1)+1) 
      cy=Int(Random(hoehe-1)+1) 
    Until zelle(cx, cy,5)=1 
    rndness=0 
    deadends=deadends+1 
  EndIf 
  
EndProcedure 



Procedure makesomeloops() 
  
  For krass = 1 To Int(breite/2) 
    ; dead ends suchen 
    Repeat 
      cx=Int(Random(breite-1)+1) 
      cy=Int(Random(hoehe-1)+1) 
      If zelle(cx,cy,1)+zelle(cx,cy,2)+zelle(cx,cy,3)+zelle(cx,cy,4)=1 
        Break 
      EndIf 
      cnt2=cnt2+1 
      If cnt2>=300 
        umrechnenfinal() 
      EndIf 
    ForEver 
    
    
    ; dead end zum loop machen 
      
      Repeat 
        i=Int(Random(3))+1 
      Until zelle(cx,cy,i)=0 
      
      zelle(cx,cy,i)=1 
      Select i 
        Case 1: cy=cy-1: zelle(cx,cy,3)=1 
        Case 2: cx=cx+1: zelle(cx,cy,4)=1 
        Case 3: cy=cy+1: zelle(cx,cy,1)=1 
        Case 4: cx=cx-1: zelle(cx,cy,2)=1 
      EndSelect 
    
  Next krass 
  umrechnenfinal() 
EndProcedure 




Procedure removesomedeadends() 
  
  For krass = 1 To Int(breite/2) 
    ; dead ends suchen 
    Repeat 
      cx=Int(Random(breite-1)+1) 
      cy=Int(Random(hoehe-1)+1) 
      If zelle(cx,cy,1)+zelle(cx,cy,2)+zelle(cx,cy,3)+zelle(cx,cy,4)=1 
        Break 
      EndIf 
    ForEver 
    
    ; dead end removen 
    Repeat 
      
      For i = 1 To 4 
        If zelle(cx,cy,i) 
          Break 
        EndIf 
      Next i 
      
      zelle(cx,cy,i)=0 
      zelle(cx,cy,5)=0 
      Select i 
        Case 1: cy=cy-1: zelle(cx,cy,3)=0 
        Case 2: cx=cx+1: zelle(cx,cy,4)=0 
        Case 3: cy=cy+1: zelle(cx,cy,1)=0 
        Case 4: cx=cx-1: zelle(cx,cy,2)=0 
      EndSelect 
      
    Until zelle(cx,cy,1)+zelle(cx,cy,2)+zelle(cx,cy,3)+zelle(cx,cy,4)>1 
  
  Next krass 
  
  makesomeloops() 
  
EndProcedure 


Procedure makesomerooms() 
  roomanzahl=Int(Random(breite*hoehe*0.08))+2 
  For i = 1 To roomanzahl 
    roomwidth=Int(Random(breite/2-4))+3 
    roomheight=Int(Random(hoehe/2-4))+3 
    roomx=Int(Random(breite*2-roomwidth-2))+1 
    roomy=Int(Random(hoehe*2-roomheight-2))+1 
    
    For j = 1 To roomwidth 
      For k = 1 To roomheight 
        maze(roomx+j,roomy+k)=1 
      Next k 
    Next j 
    
  Next i 
  
  FlipBuffers() 
  mazefertig=1 
EndProcedure 


Procedure WaitForKey() 
  Repeat 
    ExamineKeyboard() 
  Until KeyboardReleased(#PB_Any) 
EndProcedure 


Procedure ClearAll() 
  breite = 20 
  hoehe = 15 
  cx = 1 
  cy = 1 
  cnt = 0 
  mazefertig=0 
  mrichtung=0 
  deadends=0 
  modus=0 
  rndness=0 
  maxrnd=0 
  LoadFont(1,"arial",7) 
  LoadFont(2,"arial",5) 
  
  For i = 0 To 1001 
    For j = 0 To 1001 
      maze(i,j)=0 
    Next j 
  Next i 
  
  For i = 0 To 500 
    For j = 0 To 500 
      For k = 0 To 5 
        zelle(i,j,k)=0 
      Next k 
    Next j 
  Next i 
  
  For i = 0 To 4 
    bereits(i)=0 
  Next i 
  
  For i = 0 To 100 
    MuniX(i)=0 
    MuniY(i)=0 
  Next i 
  
  PlayerX=0 
  PlayerY=0 
  
  BlueX=0 
  BlueY=0 

  TheButtonX=0 
  TheButtonY=0 
  
  ShotX=0 
  ShotY=0 
  
  ExitX=0 
  ExitY=0 
  
  For i = 0 To 500 
    GegnerX(i)=0 
    GegnerY(i)=0 
  Next i 
EndProcedure 



Procedure main() 
  ClearAll() 
  
  ClearScreen(RGB(40,60,80))
  StartDrawing(ScreenOutput()) 
  FrontColor(RGB(255,255,255))
  DrawingMode(1) 
  DrawingFont(FontID(1)) 
  DrawText(113, 80, "M A Z E   M I S S I O N") 
  DrawText(100, 120, "© 2005 by Christian Gleinser") 
  DrawText(245, 225, "Press any key...") 
  StopDrawing() 
  FlipBuffers() 
  WaitForKey() 
  
  ClearScreen(RGB(40,60,80))
  StartDrawing(ScreenOutput()) 
  FrontColor(RGB(255,255,255))
  DrawingMode(1) 
  DrawingFont(FontID(1)) 
  DrawText(113, 80, "M A Z E   M I S S I O N") 
  DrawText(130, 120, "F1 - tiny maze") 
  DrawText(130, 140, "F2 - medium maze") 
  DrawText(130, 160, "F3 - giant maze") 
  StopDrawing() 
  FlipBuffers() 
  Repeat 
    ExamineKeyboard() 
    If KeyboardReleased(#PB_Key_F1) 
      breite=15 
      hoehe=15 
      Break 
    EndIf 
    If KeyboardReleased(#PB_Key_F2) 
      breite=25 
      hoehe=15 
      Break 
    EndIf 
    If KeyboardReleased(#PB_Key_F3) 
      breite=35 
      hoehe=25 
      Break 
    EndIf 
    If KeyboardReleased(#PB_Key_Escape) 
      ClearScreen(RGB(40,60,80))
      FlipBuffers() 
      Delay(500) 
      End 
    EndIf 
  ForEver 
  
  ClearScreen(RGB(40,60,80))
  StartDrawing(ScreenOutput()) 
  FrontColor(RGB(255,255,255))
  DrawingMode(1) 
  DrawingFont(FontID(1)) 
  DrawText(113, 80, "M A Z E   M I S S I O N") 
  DrawText(130, 120, "patience please...") 
  StopDrawing() 
  FlipBuffers() 
  
  MakeSomeSprites() 
  
  Repeat 
    calcmaze() 
    ExamineKeyboard() 
    If KeyboardPushed(#PB_Key_Escape) 
      End 
    EndIf 
  Until mazefertig 
  
  init() 
  game() 
  
  End 
EndProcedure 



Procedure game() 
  newgame=1 
  
  Repeat 
    Display() 
    Controls() 
    
    If mission<9 
      Player() 
      Enemies() 
    Else 
      mission=mission+1 
      If mission=100 
        gameover() 
      EndIf 
    EndIf 
    
    Delay(8) 
    
    If mission=2 
      ZeitCnt=ZeitCnt+1 
      If ZeitCnt=100 
        Zeit=Zeit-1 
        ZeitCnt=0 
      EndIf 
      If Zeit=0 
        explode() 
      EndIf 
    EndIf 
    
    If IsWindow(0) 
      WindowEvent() 
    EndIf 
    
  ForEver 
  
EndProcedure 


Procedure gameover() 
  For i = 321 To 200 Step -1 
    ClearScreen(RGB(40,60,80))
    StartDrawing(ScreenOutput()) 
    FrontColor(RGB(255,255,255))
    DrawingMode(1) 
    DrawingFont(FontID(1)) 
    DrawText(i, 200, "game over") 
    StopDrawing() 
    FlipBuffers() 
    Delay(10) 
  Next i 
  WaitForKey() 
  
  main() 
EndProcedure 


Procedure missioncomplete() 
  Delay(700) 
  
  ClearScreen(RGB(40,60,80))
  StartDrawing(ScreenOutput()) 
  FrontColor(RGB(255,255,255))
  DrawingMode(1) 
  DrawingFont(FontID(1)) 
  DrawText(95, 80, "C O N G R A T U L A T I O N S !") 
  DrawText(136, 100, "you made it!") 
  StopDrawing() 
  FlipBuffers() 
  Delay(2000) 
  ExamineKeyboard() 
  WaitForKey() 
  ClearScreen(RGB(0,0,0))
  FlipBuffers() 
  Delay(700) 
  
  main() 
EndProcedure 


Procedure explode() 
  GrabSprite(666,60,40,200,160) 
  For i = 50 To 4 Step -1 
    ClearScreen(RGB(40,60,80))
    DisplaySprite(666,60+Int(Random(i/2)),40+Int(Random(i/2))) 
    FlipBuffers() 
    Delay(16) 
    ClearScreen(RGB(40,60,80))
    DisplaySprite(666,60+Int(Random(i/2)),40+Int(Random(i/2))) 
    FlipBuffers() 
    Delay(16) 
  Next i 
  
  ExamineKeyboard() 
  
  gameover() 
EndProcedure 


Procedure Display() 
  ClearScreen(RGB(0,0,0))
  
  DisplayMaze() 
  DisplayItems() 
  DisplayPlayer() 
  DisplayEnemies() 
  
  StartDrawing(ScreenOutput()) 
  Box(0,0,320,40,RGB(40,60,80)) 
  Box(0,200,320,40,RGB(40,60,80)) 
  Box(0,0,60,240,RGB(40,60,80)) 
  Box(260,0,60,240,RGB(40,60,80)) 
  FrontColor(RGB(255,255,255))
  DrawingMode(1) 
  DrawingFont(FontID(1)) 
  DrawText(17, 17, "Bullets: "+Str(Munition)) 
  
  Select mission 
    Case 0: DrawText(190, 17, "Find the blueprints!") 
    Case 1: DrawText(190, 17, "Find self-destruction switch!") 
    Case 2: DrawText(190, 17, "Get out of here!") 
      If Zeit<11 
        FrontColor(RGB(255,0,0))
      EndIf 
      DrawText(190, 27, Str(Zeit)+" seconds left") 
  EndSelect 
  
  If mission>9 
    FrontColor(RGB(255,0,0)):DrawText(190, 17, "They got you!") 
  EndIf 
  
  If newgame 
    FrontColor(RGB(0,255,0))
    DrawText(140, 70, "get ready") 
  EndIf 
  
  StopDrawing() 
  FlipBuffers() 
  
  If newgame 
    newgame=0 
    Delay(1000) 
  EndIf 
  
EndProcedure 

Procedure DisplayMaze() 
  For x = 0 To 11 
    For y = 0 To 9 
      bx=x*20+60-PlayerX%20-10 
      by=y*20+40-PlayerY%20-10 
      
      ox=(PlayerX/20)+x-5 
      oy=(PlayerY/20)+y-4 
      If ox>=0 And oy>=0 And ox<=breite*2 And oy<=hoehe*2 
        If maze(ox,oy) 
          DisplaySprite(1,bx,by) 
        Else 
          DisplaySprite(2,bx,by) 
        EndIf 
      Else 
        DisplaySprite(2,bx,by) 
      EndIf 
    Next y 
  Next x 
EndProcedure 

Procedure DisplayItems() 
  For i = 0 To MuniAnzahl 
    ox=MuniX(i)-PlayerX-10+160 
    oy=MuniY(i)-PlayerY-10+120 
    DisplayTransparentSprite(301,ox,oy) 
  Next i 
  
  ox=BlueX-PlayerX-10+160 
  oy=BlueY-PlayerY-10+120 
  DisplayTransparentSprite(303,ox,oy) 
  
  ox=TheButtonX-PlayerX-10+160 
  oy=TheButtonY-PlayerY-10+120 
  DisplayTransparentSprite(304,ox,oy) 
  
  ox=ExitX-PlayerX-10+160 
  oy=ExitY-PlayerY-10+120 
  DisplayTransparentSprite(305,ox,oy) 
EndProcedure 

Procedure DisplayPlayer() 
  If walk=0 
    anicnt=0 
  EndIf 
  
  anicnt=anicnt+6 
  If anicnt>200 
    anicnt=0 
  EndIf 
  
  ClipSprite(100,Int(anicnt/100)*20,richtung%2*20,20,20) 
  DisplayTransparentSprite(100,150,110) 
  
  If Shoot 
    ox=ShotX-PlayerX-10+160 
    oy=ShotY-PlayerY-10+120 
    DisplayTransparentSprite(302,ox,oy) 
  EndIf 
  
EndProcedure 

Procedure DisplayEnemies() 
  ganicnt=ganicnt+6 
  If ganicnt>200 
    ganicnt=0 
  EndIf 
  
  For i = 0 To GegnerAnzahl 
    ox=GegnerX(i)-PlayerX-10+160 
    oy=GegnerY(i)-PlayerY-10+120 
    
    If GegnerRichtung(i)>=5 And GegnerRichtung(i)<40 
      GegnerRichtung(i)=GegnerRichtung(i)+1 
      DisplayTransparentSprite(201,ox,oy) 
    EndIf 
    If GegnerRichtung(i)<5 
      ClipSprite(200,Int(ganicnt/100)*20,GegnerRichtung(i)%2*20,20,20) 
      DisplayTransparentSprite(200,ox,oy) 
    EndIf 
    
  Next i 
EndProcedure 

Procedure Controls() 
  Static dauerfeuergibtshiernicht.b 
  
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) 
    End 
  EndIf 
  If KeyboardReleased(#PB_Key_F1) 
    MakeSomeSprites() 
  EndIf 
  If KeyboardReleased(#PB_Key_F2) 
    map() 
  EndIf 
  
  If KeyboardPushed(#PB_Key_Left) 
    richtung=#links 
    Blickrichtung=#links 
    walk=1 
  EndIf 
  If KeyboardPushed(#PB_Key_Right) 
    richtung=#rechts 
    Blickrichtung=#rechts 
    walk=1 
  EndIf 
  If KeyboardPushed(#PB_Key_Up) 
    richtung=#hoch 
    Blickrichtung=#hoch 
    walk=1 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) 
    richtung=#runter 
    Blickrichtung=#runter 
    walk=1 
  EndIf 
  If KeyboardPushed(#PB_Key_Space) 
    If Shoot=0 And Munition>0 And dauerfeuergibtshiernicht=0 
      Shoot=1 
      ShootRichtung=Blickrichtung 
      Munition=Munition-1 
      ShotX=PlayerX 
      ShotY=PlayerY 
      dauerfeuergibtshiernicht=1 
    EndIf 
  EndIf 
  If KeyboardReleased(#PB_Key_Space) 
    dauerfeuergibtshiernicht=0 
  EndIf 
  
  If KeyboardReleased(#PB_Any) 
    walk=0 
  EndIf 
  
EndProcedure 


Procedure Player() 
  If walk 
    nx1 = Int(PlayerX / 20) 
    nx2 = Int((PlayerX + 19) / 20) 
    ny1 = Int(PlayerY / 20) 
    ny2 = Int((PlayerY + 19) / 20) 
    
    Select richtung 
      Case #links: 
        If maze(nx2-1,ny1)<>1: hoscheisse=1: EndIf 
        If maze(nx2-1,ny2)<>1: ruscheisse=1: EndIf 
        If hoscheisse=0 And ruscheisse=1: richtung=#hoch: EndIf 
        If hoscheisse=1 And ruscheisse=0: richtung=#runter: EndIf 
        If hoscheisse=1 And ruscheisse=1: walk=0: EndIf 
      Case #rechts: 
        If maze(nx1+1,ny1)<>1: hoscheisse=1: EndIf 
        If maze(nx1+1,ny2)<>1: ruscheisse=1: EndIf 
        If hoscheisse=0 And ruscheisse=1: richtung=#hoch: EndIf 
        If hoscheisse=1 And ruscheisse=0: richtung=#runter: EndIf 
        If hoscheisse=1 And ruscheisse=1: walk=0: EndIf 
      Case #hoch: 
        If maze(nx1,ny2-1)<>1: lischeisse=1: EndIf 
        If maze(nx2,ny2-1)<>1: rescheisse=1: EndIf 
        If lischeisse=0 And rescheisse=1: richtung=#links: EndIf 
        If lischeisse=1 And rescheisse=0: richtung=#rechts: EndIf 
        If lischeisse=1 And rescheisse=1: walk=0: EndIf 
      Case #runter: 
        If maze(nx1,ny1+1)<>1: lischeisse=1: EndIf 
        If maze(nx2,ny1+1)<>1: rescheisse=1: EndIf 
        If lischeisse=0 And rescheisse=1: richtung=#links: EndIf 
        If lischeisse=1 And rescheisse=0: richtung=#rechts: EndIf 
        If lischeisse=1 And rescheisse=1: walk=0: EndIf 
    EndSelect 
  EndIf 
  
  If walk 
    Select richtung 
      Case #links: PlayerX=PlayerX-1 
      Case #rechts: PlayerX=PlayerX+1 
      Case #hoch: PlayerY=PlayerY-1 
      Case #runter: PlayerY=PlayerY+1 
    EndSelect 
  EndIf 
      
  ;einsammeln 
  For i = 0 To MuniAnzahl 
    If PlayerX>=MuniX(i)-6 And PlayerX<=MuniX(i)+6 
      If PlayerY>=MuniY(i)-6 And PlayerY<=MuniY(i)+6 
        Munition=Munition+4 
        MuniX(i)=-500 
      EndIf 
    EndIf 
  Next i 
  
  If PlayerX>=BlueX-8 And PlayerX<=BlueX+8 
    If PlayerY>=BlueY-8 And PlayerY<=BlueY+8 
      BlueX=-500 
      mission=1 
    EndIf 
  EndIf 
  
  If PlayerX>=TheButtonX-8 And PlayerX<=TheButtonX+8 
    If PlayerY>=TheButtonY-8 And PlayerY<=TheButtonY+8 
      If mission=1 
        mission=2 
        Zeit=breite*2 
        ClearScreen(RGB(255,255,255))
        FlipBuffers() 
        Delay(20) 
      EndIf 
    EndIf 
  EndIf 
      
  If PlayerX>=ExitX-8 And PlayerX<=ExitX+8 
    If PlayerY>=ExitY-8 And PlayerY<=ExitY+8 
      If mission=2 
        missioncomplete() 
      EndIf 
    EndIf 
  EndIf 
  
  
  
  ;schießen 
  If Shoot 
    ox=ShotX-PlayerX-10+160 
    oy=ShotY-PlayerY-10+120 

    Select ShootRichtung 
      Case #links: ShotX=ShotX-5 
      Case #rechts: ShotX=ShotX+5 
      Case #hoch: ShotY=ShotY-5 
      Case #runter: ShotY=ShotY+5 
    EndSelect 
    If ox<20 Or ox>300 Or oy<20 Or oy>220 
      Shoot=0 
    EndIf 
    
    For i = 0 To GegnerAnzahl 
      If GegnerRichtung(i)<5 
        If ShotX>=GegnerX(i)-10 And ShotX<=GegnerX(i)+10 
          If ShotY>=GegnerY(i)-10 And ShotY<=GegnerY(i)+10 
            GegnerRichtung(i)=5 
            Shoot=0 
          EndIf 
        EndIf 
      EndIf 
    Next i 
    
    If maze(Int(ShotX/20),Int(ShotY/20))<>1 
      If Shoot<>2 
        Shoot=Shoot+1 
      Else 
        Shoot=0 
      EndIf 
    EndIf 
    
  EndIf 
EndProcedure 


Procedure Enemies() 
  For i = 0 To GegnerAnzahl 
    nx = Int(GegnerX(i) / 20) 
    nxx = Int((GegnerX(i) + 19) / 20) 
    ny = Int(GegnerY(i) / 20) 
    nyy = Int((GegnerY(i) + 19) / 20) 
    
    Repeat 
      r=0 
      Select GegnerRichtung(i) 
        Case #links 
          If GegnerX(i)%20=0 
            If maze(nxx-1,ny)<>1 
              GegnerRichtung(i)=Int(Random(3)) 
              r=1 
            EndIf 
          EndIf 
          If r=0 
            GegnerX(i)=GegnerX(i)-1 
          EndIf 
          
        Case #rechts 
          If GegnerX(i)%20=0 
            If maze(nx+1,ny)<>1 
              GegnerRichtung(i)=Int(Random(3)) 
              r=1 
            EndIf 
          EndIf 
          If r=0 
            GegnerX(i)=GegnerX(i)+1 
          EndIf 
          
        Case #hoch 
          If GegnerY(i)%20=0 
            If maze(nx,nyy-1)<>1 
              GegnerRichtung(i)=Int(Random(3)) 
              r=1 
            EndIf 
          EndIf 
          If r=0 
            GegnerY(i)=GegnerY(i)-1 
          EndIf 
          
        Case #runter 
          If GegnerY(i)%20=0 
            If maze(nx,ny+1)<>1 
              GegnerRichtung(i)=Int(Random(3)) 
              r=1 
            EndIf 
          EndIf 
          If r=0 
            GegnerY(i)=GegnerY(i)+1 
          EndIf 
      EndSelect 
    Until r=0 
    
    If GegnerRichtung(i)<5 
      ;Kollision 
      If GegnerX(i)>=PlayerX-6 And GegnerX(i)<=PlayerX+6 
        If GegnerY(i)>=PlayerY-9 And GegnerY(i)<=PlayerY+9 
          mission=9 
        EndIf 
      EndIf 
    EndIf 
    
  Next i 
  
EndProcedure 


Procedure Richtungswechsel(i.l) 
  GegnerRichtung(i)=Int(Random(3)) 
EndProcedure 


Procedure map() 
  ClearScreen(RGB(0,0,0))
  ox=160-breite*3 
  oy=120-hoehe*3 
  
  StartDrawing(ScreenOutput()) 
  For x = 0 To breite*2 
    For y = 0 To hoehe*2 
      If maze(x,y)=0 
        Box(x*3+ox,y*3+oy,3,3,RGB(0,128,255)) 
      EndIf 
    Next y 
  Next x 
  
  For i = 0 To GegnerAnzahl 
    Plot(GegnerX(i)/20*3+1+ox,GegnerY(i)/20*3+1+oy,RGB(255,0,0)) 
  Next i 
  
  Box(PlayerX/20*3+ox,PlayerY/20*3+oy,3,3,RGB(255,255,0)) 
  StopDrawing() 
  FlipBuffers() 
  WaitForKey() 
EndProcedure 



Procedure init() 
  While maze(PlayerX,PlayerY)=0 
    PlayerX=Int(Random(breite*2)) 
    PlayerY=Int(Random(hoehe*2)) 
  Wend 
  PlayerX=PlayerX*20 
  PlayerY=PlayerY*20 
  Blickrichtung=#links 
  
  GegnerAnzahl=breite*hoehe/15 
  ;GegnerAnzahl=49 
  
  For i = 0 To GegnerAnzahl 
    While maze(GegnerX(i),GegnerY(i))=0 
      GegnerX(i)=Int(Random(breite*2)) 
      GegnerY(i)=Int(Random(hoehe*2)) 
    Wend 
    GegnerX(i)=GegnerX(i)*20 
    GegnerY(i)=GegnerY(i)*20 
    GegnerRichtung(i)=Int(Random(3)) 
    
    If GegnerX(i)>=PlayerX-50 And GegnerX(i)<=PlayerX+50 
      If GegnerY(i)>=PlayerY-50 And GegnerY(i)<=PlayerY+50 
        GegnerX(i)=0 
        GegnerY(i)=0 
        i=i-1 
      EndIf 
    EndIf 
  Next i 
  
  Munition=2 
  MuniAnzahl=breite*hoehe/100 
  
  For i = 0 To MuniAnzahl 
    While maze(MuniX(i),MuniY(i))=0 
      MuniX(i)=Int(Random(breite*2)) 
      MuniY(i)=Int(Random(hoehe*2)) 
    Wend 
    MuniX(i)=MuniX(i)*20 
    MuniY(i)=MuniY(i)*20 
  Next i 
  
  While maze(BlueX,BlueY)=0 Or BlueX=PlayerX/20 And BlueY=PlayerY/20 
    BlueX=Int(Random(breite*2)) 
    BlueY=Int(Random(hoehe*2)) 
  Wend 
  BlueX=BlueX*20 
  BlueY=BlueY*20 
  
  While maze(TheButtonX,TheButtonY)=0 Or TheButtonX=PlayerX/20 And TheButtonY=PlayerY/20 
    TheButtonX=Int(Random(breite*2)) 
    TheButtonY=Int(Random(hoehe*2)) 
  Wend 
  TheButtonX=TheButtonX*20 
  TheButtonY=TheButtonY*20 
  
  While maze(ExitX,ExitY)=0 Or ExitX=PlayerX/20 And ExitY=PlayerY/20 
    ExitX=Int(Random(breite*2)) 
    ExitY=Int(Random(hoehe*2)) 
  Wend 
  ExitX=ExitX*20 
  ExitY=ExitY*20 
  
  mission=0 
EndProcedure 


Procedure MakeSomeSprites() 
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,128,255)) 
  Line(0,0,20,0,RGB(220,230,255)) 
  Line(0,0,0,20,RGB(220,230,255)) 
  Line(1,19,20,0,RGB(0,96,192)) 
  Line(19,0,0,20,RGB(0,96,192)) 
  If Int(Random(1)) 
    Line(3,3,14,0,RGB(0,96,192)) 
    Line(3,3,0,14,RGB(0,96,192)) 
    Line(4,16,13,0,RGB(220,230,255)) 
    Line(16,3,0,14,RGB(220,230,255)) 
    If Int(Random(1)) 
      Box(4,4,12,12,RGB(100,200,255)) 
    EndIf 
    If Int(Random(1)) 
      Box(4,4,12,12,RGB(0,0,0)) 
    EndIf 
  EndIf 
  If Int(Random(1)) 
    Line(8,8,4,0,RGB(220,230,255)) 
    Line(8,8,0,5,RGB(220,230,255)) 
    Line(9,12,4,0,RGB(0,96,192)) 
    Line(12,8,0,4,RGB(0,96,192)) 
    If Int(Random(1)) 
      Box(9,9,3,3,RGB(100,200,255)) 
    EndIf 
    If Int(Random(1)) 
      Box(9,9,3,3,RGB(0,0,0)) 
    EndIf 
    If Int(Random(1)) 
      Box(9,9,3,3,RGB(0,128,255)) 
    EndIf 
  EndIf 
  StopDrawing() 
  GrabSprite(2,0,0,20,20) 
  
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,20,40)) 
  StopDrawing() 
  GrabSprite(1,0,0,20,20) 
  
  ; SPIELFIGUR 
  StartDrawing(ScreenOutput()) 
  Box(0,0,40,40,RGB(0,0,0)) 
  Circle(10,5,2,RGB(255,255,0)) 
  Line(10,7,0,4,RGB(255,255,0)) 
  Line(10,11,-1,4,RGB(255,255,0)) 
  Line(10,11,1,6,RGB(255,255,0)) 
  Line(10,7,-2,4,RGB(255,255,0)) 
  Line(10,7,2,5,RGB(255,255,0)) 
  
  Circle(20+10,5,2,RGB(255,255,0)) 
  Line(20+10,7,0,4,RGB(255,255,0)) 
  Line(20+10,11,-3,6,RGB(255,255,0)) 
  Line(20+10,11,3,4,RGB(255,255,0)) 
  Line(20+10,7,-2,5,RGB(255,255,0)) 
  Line(20+10,7,2,4,RGB(255,255,0)) 
  
  Circle(11,20+5,2,RGB(255,255,0)) 
  Line(10,20+7,0,4,RGB(255,255,0)) 
  Line(10,20+11,-1,4,RGB(255,255,0)) 
  Line(10,20+11,1,6,RGB(255,255,0)) 
  Line(10,20+7,-2,4,RGB(255,255,0)) 
  Line(10,20+7,2,5,RGB(255,255,0)) 
  
  Circle(20+11,20+5,2,RGB(255,255,0)) 
  Line(20+10,20+7,0,4,RGB(255,255,0)) 
  Line(20+10,20+11,-3,6,RGB(255,255,0)) 
  Line(20+10,20+11,3,4,RGB(255,255,0)) 
  Line(20+10,20+7,-2,5,RGB(255,255,0)) 
  Line(20+10,20+7,2,4,RGB(255,255,0)) 
  
  StopDrawing() 
  GrabSprite(100,0,0,40,40) 
  TransparentSpriteColor(-1,RGB(0,0,0))
  
  ; GEGNER 
  StartDrawing(ScreenOutput()) 
  Box(0,0,40,40,RGB(0,0,0)) 
  Circle(10,5,2,RGB(255,0,0)) 
  Line(10,7,0,4,RGB(255,0,0)) 
  Line(10,11,-1,4,RGB(255,0,0)) 
  Line(10,11,1,6,RGB(255,0,0)) 
  Line(10,7,-2,4,RGB(255,0,0)) 
  Line(10,7,2,5,RGB(255,0,0)) 
  
  Circle(20+10,5,2,RGB(255,0,0)) 
  Line(20+10,7,0,4,RGB(255,0,0)) 
  Line(20+10,11,-3,6,RGB(255,0,0)) 
  Line(20+10,11,3,4,RGB(255,0,0)) 
  Line(20+10,7,-2,5,RGB(255,0,0)) 
  Line(20+10,7,2,4,RGB(255,0,0)) 
  
  Circle(11,20+5,2,RGB(255,0,0)) 
  Line(10,20+7,0,4,RGB(255,0,0)) 
  Line(10,20+11,-1,4,RGB(255,0,0)) 
  Line(10,20+11,1,6,RGB(255,0,0)) 
  Line(10,20+7,-2,4,RGB(255,0,0)) 
  Line(10,20+7,2,5,RGB(255,0,0)) 
  
  Circle(20+11,20+5,2,RGB(255,0,0)) 
  Line(20+10,20+7,0,4,RGB(255,0,0)) 
  Line(20+10,20+11,-3,6,RGB(255,0,0)) 
  Line(20+10,20+11,3,4,RGB(255,0,0)) 
  Line(20+10,20+7,-2,5,RGB(255,0,0)) 
  Line(20+10,20+7,2,4,RGB(255,0,0)) 
  StopDrawing() 
  GrabSprite(200,0,0,40,40) 
  
  ;GEGNER TOT 
  StartDrawing(ScreenOutput()) 
  Box(0,0,40,40,RGB(0,0,0)) 
  Line(5,5,10,10,RGB(255,0,0)) 
  Line(14,5,-10,10,RGB(255,0,0)) 
  Line(5,10,10,0,RGB(255,0,0)) 
  Line(10,5,0,10,RGB(255,0,0)) 
  Circle(10,10,3,RGB(0,0,0)) 
  StopDrawing() 
  GrabSprite(201,0,0,20,20) 
  
  ; ITEMS 
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,0,0)) 
  Line(5,5,0,3,RGB(255,0,0)) 
  Line(7,5,0,3,RGB(255,0,0)) 
  Line(9,5,0,3,RGB(255,0,0)) 
  Line(11,5,0,3,RGB(255,0,0)) 
  Plot(5,8,RGB(255,255,0)) 
  Plot(7,8,RGB(255,255,0)) 
  Plot(9,8,RGB(255,255,0)) 
  Plot(11,8,RGB(255,255,0)) 
  StopDrawing() 
  GrabSprite(301,0,0,20,20) 
  
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,0,0)) 
  Circle(10,10,4,RGB(255,0,0)) 
  Circle(10,10,2,RGB(255,255,0)) 
  StopDrawing() 
  GrabSprite(302,0,0,20,20) 
  
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,0,0)) 
  Box(3,3,14,14,RGB(255,255,255)) 
  Box(4,4,12,12,RGB(0,30,170)) 
  Circle(7,7,3,RGB(255,255,255)) 
  Circle(7,7,2,RGB(0,30,170)) 
  Line(5,12,5,0,RGB(255,255,255)) 
  Line(5,14,4,0,RGB(255,255,255)) 
  Line(12,5,0,10,RGB(255,255,255)) 
  Line(12,12,3,0,RGB(255,255,255)) 
  Line(12,14,4,0,RGB(255,255,255)) 
  StopDrawing() 
  GrabSprite(303,0,0,20,20) 
  
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,0,0)) 
  Box(4,4,11,11,RGB(80,80,80)) 
  Line(4,4,11,0,RGB(120,120,120)) 
  Line(4,4,0,11,RGB(120,120,120)) 
  Line(15,4,0,11,RGB(50,50,50)) 
  Line(15,15,-11,0,RGB(50,50,50)) 
  Circle(10,10,4,RGB(0,0,0)) 
  Circle(10,10,3,RGB(255,0,0)) 
  Circle(10,10,2,RGB(200,0,0)) 
  StopDrawing() 
  GrabSprite(304,0,0,20,20) 
  
  StartDrawing(ScreenOutput()) 
  Box(0,0,20,20,RGB(0,0,0)) 
  Box(2,2,16,16,RGB(0,180,0)) 
  Box(4,4,12,12,RGB(0,50,0)) 
  DrawingFont(FontID(2)) 
  DrawingMode(1) 
  FrontColor(RGB(255,255,255))
  DrawText(2, 7, "EXIT") 
  StopDrawing() 
  GrabSprite(305,0,0,20,20) 
  
  ClearScreen(RGB(40,60,80))
EndProcedure 









Procedure StartWindowed() 
  If OpenWindow(0,0,0,640,480,"Maze Mission",#PB_Window_ScreenCentered) 
    If OpenWindowedScreen(WindowID(0),0,0,320,240,1,0,0) 
      main() 
    EndIf 
  EndIf 
EndProcedure 

Procedure StartFullscreen() 
  If OpenScreen(320,240,32,"Maze Mission") 
    main() 
  Else 
    MessageRequester("Fehler", "Fullscreen-Mode scheint nicht zu gehen. Nun muß eben der Fenstermodus genügen :)") 
    StartWindowed() 
  EndIf 
EndProcedure 



;StartFullscreen()           ;hier könnt ihr wählen, welchen Modus ihr wollt 
StartWindowed() 



; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -----
; DisableDebugger