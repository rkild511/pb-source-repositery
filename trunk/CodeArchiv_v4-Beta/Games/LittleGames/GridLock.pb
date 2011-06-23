; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3591&start=10
; Author: FGK (updated for PB 4.00 by Andre)
; Date: 07. June 2005
; OS: Windows, Linux
; Demo: Yes

; GridLock Clone V0.8 
; Use the mouse (press and hold the left mouse button) to move the stones.

; Hier mein bescheidener Beitrag zum MiniGameContest:
; Ziel von "Gridlock" ist es den Masterstein aus dem Durchbruch 
; in der Mauer zu schieben. Horizontale Steine können nur quer 
; bewegt werden. Vertikale nur in der Senkrechten. Inspiriert hat 
; mich dieses Spiel auf meinem SE P900. Die Punktebewertung 
; habe ich Zug- und Levelabhänig gestaltet - das mißfiel mir beim 
; "Orginal". Mangels der Contest-Einschränkungen gibts keine 
; speicherbare Hiscoreliste oder Weiterspielen am aktuellen Level. 
; 
; Gesteuert wird mit der Maus. 
; 
; 
; ------------------------------------------------------------ 
; GridLock Clone V0.8 
; PB Version von F. Kastl für MiniGameContest '05 
; Credits an Riku Salkia dem Autor der P900 Version 
;  
; ------------------------------------------------------------ 
; 
#BlockSize=24 
#BlockHalf = #BlockSize/2 
#StatusX = 220 
#StatusY = 10 
#Master = 0 
#Horizontal = 1 
#Vertikal= 2 
#Width=320 
#Height=200 
#MoveCost = 2 
#BlockBonus = 10 
#LevelValue= 5 
#MaxLevel = 40 

Structure Block 
  Typ.b 
  Size.b 
  XPos.l 
  YPos.l 
  dx.l 
  dy.l 
  XLen.l 
  YLen.l 
  XMap.b 
  YMap.b 
  MovePlus.b 
  MoveMinus.b 
  Col.l 
  SpriteID.l 
EndStructure  


Global HSprite1,HSprite2 
Global VSprite1,VSprite2 
Global MSprite,MapSprite 
Global x,y,oldX,oldY 
Global I,btn 
Global Bonus.l,Score.l 
Global Level.l,Moves.l 
Global Done,Quit 

Global Dim Map.b(7,7) 
Global NewList Blocks.Block() 

Procedure DrawShadowText(px.l,py.l,Text$,FrontCol.l,ShadowCol.l) 
  FrontColor(FrontCol)
  DrawingMode(1) 
  DrawText(px,py,Text$) 
  FrontColor(ShadowCol)
  DrawText(px+1,py-1,Text$) 
EndProcedure  

Procedure DrawBox(px,py,w,h,Text$) 
  StartDrawing(ScreenOutput()) 
    DrawingMode(0) 
    Box(px,py,w,h,RGB($C0,$3F,$66)) 
    Line(px,py,w,0,RGB($EA,$A8,$B9)) 
    Line(px+w,py,0,h,RGB($EA,$A8,$B9)) 
    DrawShadowText(w-TextWidth(Text$)-15,h/2+10,Text$,RGB(0,0,0),RGB($EA,$A8,$B9)) 
  StopDrawing() 
EndProcedure 
  
Procedure DrawLevel() 
  DisplaySprite(MapSprite,0,0) 
  ForEach Blocks() 
    DisplayTransparentSprite(Blocks()\SpriteID,#BlockSize+Blocks()\XPos,#BlockSize+Blocks()\YPos) 
  Next  
EndProcedure 

Procedure DrawStatus() 
  If Moves*#MoveCost<Bonus 
    t$="Bonus: " +RSet(Str(Bonus-Moves*#MoveCost),4,"0") 
  Else  
    t$="Bonus: " +RSet("",4,"0") 
  EndIf  
  StartDrawing(ScreenOutput()) 
    DrawShadowText(#StatusX,#StatusY,"Level: " + RSet(Str(Level),2,"0"),RGB(255,255,255),RGB(0,0,0)) 
    DrawShadowText(#StatusX,#StatusY+20,"Score: " + RSet(Str(Score),5,"0"),RGB(255,255,255),RGB(0,0,0)) 
    DrawShadowText(#StatusX,#StatusY+40,"Moves: " +RSet(Str(Moves),4,"0"),RGB(255,255,255),RGB(0,0,0)) 
    DrawShadowText(#StatusX,#StatusY+60,t$,RGB(255,255,255),RGB(0,0,0)) 
  StopDrawing() 
EndProcedure 

Procedure.l GetBlock() 
  R=-1 
  ForEach Blocks() 
    If x>Blocks()\XPos+#BlockSize And x<(Blocks()\XPos+Blocks()\XLen+#BlockSize) 
      If y>Blocks()\YPos+#BlockSize And y<(Blocks()\YPos+Blocks()\YLen+#BlockSize) 
        R =ListIndex(Blocks()) 
        Break 
      EndIf  
    EndIf  
  Next  
  ProcedureReturn R 
EndProcedure 

Procedure CheckMove() 
  Blocks()\MoveMinus=0 
  Blocks()\MovePlus=0 
  Select Blocks()\Typ 
    Case #Vertikal 
      If Map(Blocks()\XMap+1,Blocks()\YMap)=1 
        Blocks()\MoveMinus=1 
      EndIf  
      If Map(Blocks()\XMap+1,Blocks()\YMap+Blocks()\Size+1)=1 
        Blocks()\MovePlus=1 
      EndIf  
    Case #Horizontal 
      If Map(Blocks()\XMap,Blocks()\YMap+1)=1 
        Blocks()\MoveMinus=1 
      EndIf  
      If Map(Blocks()\XMap+Blocks()\Size+1,Blocks()\YMap+1)=1 
        Blocks()\MovePlus=1 
      EndIf  
    Case #Master 
      If Map(Blocks()\XMap,Blocks()\YMap+1)=1 
        Blocks()\MoveMinus=1 
      EndIf  
      If Map(Blocks()\XMap+Blocks()\Size+1,Blocks()\YMap+1)=1 
        Blocks()\MovePlus=1 
      EndIf  
  EndSelect 
EndProcedure 

Procedure SetBlocksToMap(Mode.b) 
  Select Blocks()\Typ 
    Case #Horizontal 
      For l=1 To Blocks()\Size 
        Map(Blocks()\XMap+l,Blocks()\YMap+1)=Mode 
      Next l 
    Case #Vertikal 
      For l=1 To Blocks()\Size 
        Map(Blocks()\XMap+1,Blocks()\YMap+l)=Mode 
      Next l 
    Case #Master 
      For l=1 To Blocks()\Size 
        Map(Blocks()\XMap+l,Blocks()\YMap+1)=Mode 
      Next l 
  EndSelect 
EndProcedure  
  
Procedure AlignBlocks() 
  If I>-1 
    SelectElement(Blocks(),I) 
    If Abs(Blocks()\dy) < #BlockSize/4 
      Blocks()\dy=0 
    EndIf 
    If Abs(Blocks()\dx) < #BlockSize/4 
      Blocks()\dx=0 
    EndIf 
    Blocks()\YPos =Blocks()\YMap * #BlockSize 
    Blocks()\XPos =Blocks()\XMap * #BlockSize 
  EndIf 
EndProcedure  

Procedure MoveBlocks() 
  I= GetBlock() 
  If I>-1 
    SelectElement(Blocks(),I) 
    CheckMove() 
    DeltaX = oldX-x 
    DeltaY = oldY-y 
    dy=0:dx=0 
      Select Blocks()\Typ 
        Case #Vertikal 
          If DeltaY>0             ;Minus Richtung 
            If Blocks()\MoveMinus=1 
              ProcedureReturn 
            EndIf  
          Else                    ;Plus Richtung 
            If Blocks()\MovePlus=1 
              ProcedureReturn 
            EndIf  
          EndIf  
          DeltaX=0 
        Case #Horizontal 
          If DeltaX>0             ;Minus Richtung 
            If Blocks()\MoveMinus=1 
              ProcedureReturn 
            EndIf  
          Else                    ;Plus Richtung 
            If Blocks()\MovePlus=1 
              ProcedureReturn 
            EndIf  
          EndIf  
          DeltaY=0 
        Case #Master 
          If DeltaX>0             ;Minus Richtung 
            If Blocks()\MoveMinus=1 
              ProcedureReturn 
            EndIf  
          Else                    ;Plus Richtung 
            If Blocks()\MovePlus=1 
              ProcedureReturn 
            EndIf  
          EndIf  
          DeltaY=0 
      EndSelect  
      Blocks()\YPos-DeltaY 
      Blocks()\XPos-DeltaX 
      Blocks()\dx - DeltaX 
      Blocks()\dy - DeltaY 
      SetBlocksToMap(0) 
      If Blocks()\dy > #BlockSize/4 
        Blocks()\YMap+1 
        Blocks()\dy=0 
        Blocks()\YPos =Blocks()\YMap * #BlockSize 
        Moves+1 
      EndIf 
      If Blocks()\dy < -#BlockSize/4 
        Blocks()\YMap-1 
        Blocks()\dy=0 
        Blocks()\YPos =Blocks()\YMap * #BlockSize 
        Moves+1 
      EndIf 
      If Blocks()\dx > #BlockSize/4 
        Blocks()\XMap+1 
        Blocks()\dx=0 
        Blocks()\XPos =Blocks()\XMap * #BlockSize 
        Moves+1 
      EndIf 
      If Blocks()\dx < -#BlockSize/4 
        Blocks()\XMap-1 
        Blocks()\dx=0 
        Blocks()\XPos =Blocks()\XMap * #BlockSize 
        Moves+1 
      EndIf 
      SetBlocksToMap(1) 
      If Blocks()\Typ=#Master And Blocks()\XMap=5 
        Done=1 
      EndIf 
      If GetBlock()=-1 
        btn=0 
      EndIf  
    EndIf 
EndProcedure  

Procedure GetLevel(LVL) 
  If LVL<=#MaxLevel 
    ClearList(Blocks()) 
    Restore Map 
    For ty= 0 To 7 
      For tx= 0 To 7 
        Read Map.b(tx,ty)  
      Next tx 
    Next ty 
    
    Restore BlockCount 
      For l=1 To Level-1 
        Read o.b 
        Offset.l+(o*4)      ;Bytelänge berechnen 
      Next l 
      Read Count.b          ;Blockanzahl einlesen 
      
      Bonus.l=Count*#BlockBonus ;Bonus von Blockanzahl abhängig berechnen 
      
    Restore LevelTab 
      For l= 1 To Offset  
        Read o.b            ;Skip LevelBytes 
      Next l 
  
    For l=1 To Count 
      AddElement(Blocks()) 
      Read Blocks()\Typ 
      Read Blocks()\XMap 
      Read Blocks()\YMap 
      Read Blocks()\Size 
      Select Blocks()\Typ 
        Case #Horizontal 
          Blocks()\XLen=#BlockSize*Blocks()\Size 
          Blocks()\YLen=#BlockSize 
          If Blocks()\Size=3 
            Blocks()\SpriteID = HSprite1 
          Else 
            Blocks()\SpriteID = HSprite2 
          EndIf  
        Case #Vertikal 
          Blocks()\XLen=#BlockSize 
          Blocks()\YLen=#BlockSize*Blocks()\Size 
          If Blocks()\Size=3 
            Blocks()\SpriteID = VSprite1 
          Else 
            Blocks()\SpriteID = VSprite2 
          EndIf  
        Case #Master 
          Blocks()\XLen=#BlockSize*Blocks()\Size 
          Blocks()\YLen=#BlockSize 
          Blocks()\SpriteID = MSprite 
      EndSelect 
      SetBlocksToMap(1) 
      Blocks()\XPos=Blocks()\XMap*#BlockSize;+#BlockSize 
      Blocks()\YPos=Blocks()\YMap*#BlockSize;+#BlockSize 
    Next l 
  Else 
    LVL=#MaxLevel 
    Quit=1 
  EndIf 
  Moves=0 
  Done=0 
EndProcedure 

Procedure NextLevel(Text$) 
  DrawBox(#BlockSize,#BlockSize,6*#BlockSize,6*#BlockSize,Text$) 
  FlipBuffers() 
  Delay(2000) 
  If Moves*#MoveCost<Bonus 
    Score=Score+(Bonus-Moves*#MoveCost) 
  EndIf  
  Score = Score + (Level*#LevelValue) 
  Level+1 
  GetLevel(Level) 
EndProcedure  

Procedure.l CreateBlockSprite() 
  Read Typ.b 
  Read Size.l 
  Read R.w 
  Read G.w 
  Read b.w 
  
  Select Typ 
    Case #Horizontal 
      x=Size*#BlockSize 
      y=#BlockSize 
      t$="" 
    Case #Vertikal 
      x=#BlockSize 
      y=Size*#BlockSize 
    Case #Master 
      x=Size*#BlockSize 
      y=#BlockSize 
      t$="M" 
    EndSelect 
  c=RGB(R,G,b) 
  SpriteID=CreateSprite(#PB_Any,x,y,0) 
  StartDrawing(SpriteOutput(SpriteID)) 
  DrawingMode(0) 
  ;Box(0,0,SpriteWidth(SpriteID),SpriteHeight(SpriteID),c) 
  If Typ=#Horizontal Or Typ=#Master 
   Circle(#BlockHalf,#BlockHalf,#BlockHalf,c) 
   Circle(x-#BlockHalf,#BlockHalf,#BlockHalf,c) 
   Box(#BlockHalf,0,x-#BlockSize,#BlockSize,c) 
   DrawingMode(4) 
   DrawText((x-TextWidth(t$))/2,4, t$) 
  Else 
   Circle(#BlockHalf,#BlockHalf,#BlockHalf,c) 
   Circle(#BlockHalf,y-#BlockHalf,#BlockHalf,c) 
   Box(0,#BlockHalf,#BlockSize,y-#BlockSize,c) 
  EndIf  
  StopDrawing() 
  ProcedureReturn SpriteID 
EndProcedure 

Procedure.l CreateMapSprite(Size.l) 
  back = RGB(0,255,255) 
  dark = RGB($6B,$91,$94) 
  light = RGB(220,255,255) 
  
  Restore Map 
  For y= 0 To 7 
    For x= 0 To 7 
      Read Map.b(x,y)  
    Next x 
  Next y 
  
  x=#Width 
  y=#Height 
  SpriteID=CreateSprite(#PB_Any,x,y,0) 
  StartDrawing(SpriteOutput(SpriteID)) 
  DrawingMode(0) 
  Box(0,0,SpriteWidth(SpriteID),SpriteHeight(SpriteID),RGB(192,192,192)) 
    x=Size*#BlockSize 
    y=Size*#BlockSize 
    Box(0,0,x,y,back) 
    For y=0 To 7 
      For x = 0 To 7 
        If Map(x,y)=1 
          DrawingMode(0) 
          Box(x*#BlockSize,y*#BlockSize,#BlockSize,#BlockSize,RGB(220,255,255)) 
          DrawingMode(4) 
          Box(x*#BlockSize,y*#BlockSize,#BlockSize,#BlockSize,RGB(180,180,255)) 
        EndIf 
      Next x 
    Next y  
    Restore LineTab 
    x=0:y=0 
    For l= 1 To 12 
      Read x2 
      Read y2 
      LineXY(x*#BlockSize,y*#BlockSize,x2*#BlockSize,y2*#BlockSize,dark) 
      x=x2:y=y2 
    Next l 
  StopDrawing() 
  ProcedureReturn SpriteID 
EndProcedure  

Procedure CreateGameGfx() 
  MapSprite=CreateMapSprite(8) 
  Restore Blk_Master 
  MSprite=CreateBlockSprite() 
  Restore Blk_Hor1 
  HSprite1=CreateBlockSprite() 
  Restore Blk_Ver1 
  VSprite1=CreateBlockSprite() 
  Restore Blk_Hor2 
  HSprite2=CreateBlockSprite() 
  Restore Blk_Ver2 
  VSprite2=CreateBlockSprite() 
EndProcedure 
  
If OpenWindow(0, 100, 200, 640,400, "PB Gridlock V0.8", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_WindowCentered) 
  InitSprite() 
  If CreateMenu(0, WindowID(0)) 
    MenuTitle("Game") 
    MenuItem( 1, "&Restart") 
    MenuItem( 2, "&Skip Level") 
    MenuItem( 3, "&Exit") 
    MenuTitle("?") 
    MenuItem(4, "About") 
  EndIf 
  
  If OpenWindowedScreen(WindowID(0),0,0,#Width,#Height,1,0,0) 
    CreateGameGfx() 
    Level=1 
    GetLevel(Level) 
    Repeat 
      DrawLevel()  
      oldX=x:oldY=y 
      x=WindowMouseX(0)/2 
      y=WindowMouseY(0)/2 
      EventID.l = WindowEvent() 
      Select EventID 
        Case #PB_Event_Menu 
          Select EventMenu() 
            Case 1 ; Restart Level 
              DrawBox(#BlockSize,#BlockSize,6*#BlockSize,6*#BlockSize,"Restart Level") 
              FlipBuffers() 
              Delay(1000) 
              GetLevel(Level) 
            Case 2 
              NextLevel("Skip Level!") 
              Bonus=0 
            Case 3 ; Exit 
              Quit=1 
            Case 4 ; About 
              MessageRequester("PB-GridLock", "PB-Version von GridLock" + Chr(10) + "geschrieben für den " + Chr(10) + "www.pure-board.de" + Chr(10) + "Mini-GameContest '05" + Chr(10) + "" + Chr(10) + "Autor:   F.G.K " + Chr(10) + "" + Chr(10) + "Credits an Riku Salkia dem Autor der Symbian Phone Version", #MB_OK|#MB_ICONINFORMATION)            
          EndSelect 
        Case #WM_LBUTTONDOWN      
          btn=1 
        Case #WM_LBUTTONUP      
          btn=0 
        Case #PB_Event_CloseWindow 
          Quit = 1 
      EndSelect 
      If btn 
        MoveBlocks() 
      Else 
        AlignBlocks() 
      EndIf 
      DrawStatus() 
      If Done=1 
        NextLevel("Well Done!") 
      EndIf 
      FlipBuffers() 
      Delay(10)    
    Until Quit = 1 
  EndIf  
  
EndIf 
End 

;{ DatasSection 
DataSection 
Blk_Master: 
Data.b #Master 
Data.l 2 
Data.w 192 
Data.w 192 
Data.w 192 
Blk_Hor1: 
Data.b #Horizontal 
Data.l 3 
Data.w 0 
Data.w 0 
Data.w 255 
Blk_Hor2: 
Data.b #Horizontal 
Data.l 2 
Data.w 255 
Data.w 255 
Data.w 0 
Blk_Ver1: 
Data.b #Vertikal 
Data.l 3 
Data.w 255 
Data.w 0 
Data.w 0 
Blk_Ver2: 
Data.b #Vertikal 
Data.l 2 
Data.w 0 
Data.w 255 
Data.w 0 

LineTab: 
Data.l 8,0,8,3,7,3 
Data.l 7,1,1,1,1,7 
Data.l 7,7,7,4,8,4 
Data.l 8,8,0,8,0,0 


Map: 
Data.b 1,1,1,1,1,1,1,1 
Data.b 1,0,0,0,0,0,0,1 
Data.b 1,0,0,0,0,0,0,1 
Data.b 1,0,0,0,0,0,0,0 
Data.b 1,0,0,0,0,0,0,1 
Data.b 1,0,0,0,0,0,0,1 
Data.b 1,0,0,0,0,0,0,1 
Data.b 1,1,1,1,1,1,1,1 

BlockCount: 
Data.b  8,11, 6, 7,11,11, 9,14,12,12 
Data.b  8, 8,13,12,14,11,12, 9, 8,10 
Data.b  7,12,10,10,13,12,10,12,12,10 
Data.b 11,11,12,12,11,12,13,11,12,13 

LevelTab: 
;- Level1: 
Data.b #Horizontal,0,0,2 
Data.b #Vertikal,0,1,3 
Data.b #Vertikal,0,4,2 
Data.b #Horizontal,2,5,3 
Data.b #Horizontal,4,4,2 
Data.b #Master,1,2,2 
Data.b #Vertikal,3,1,3 
Data.b #Vertikal,5,0,3 
;-Level2: 
Data.b #Vertikal,0,0,2 
Data.b #Master,0,2,2 
Data.b #Horizontal,0,3,3 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,3,5,2 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,4,2,2 
Data.b #Vertikal,5,1,3 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,3,1,2 
;-Level3: 
Data.b #Vertikal,1,4,2 
Data.b #Horizontal,1,3,2 
Data.b #Horizontal,2,5,2 
Data.b #Vertikal,3,2,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,5,3,3 
;-Level4: 
Data.b #Vertikal,0,0,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,2,3,2 
Data.b #Horizontal,2,5,3 
Data.b #Vertikal,5,4,2 
Data.b #Horizontal,3,3,3 
Data.b #Vertikal,3,0,3 
;-Level5: 
Data.b #Vertikal,0,4,2 
Data.b #Horizontal,4,4,2 
Data.b #Horizontal,4,5,2 
Data.b #Vertikal,5,2,2 
Data.b #Vertikal,5,0,2 
Data.b #Vertikal,4,1,3 
Data.b #Vertikal,3,0,3 
Data.b #Horizontal,1,3,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,1,3 
Data.b #Horizontal,0,0,2 
;-Level6: 
Data.b #Horizontal,3,5,3 
Data.b #Vertikal,3,2,3 
Data.b #Vertikal,4,1,3 
Data.b #Vertikal,5,1,3 
Data.b #Vertikal,3,0,2 
Data.b #Master,1,2,2 
Data.b #Horizontal,0,1,2 
Data.b #Horizontal,0,0,2 
Data.b #Horizontal,0,3,2 
Data.b #Vertikal,2,3,2 
Data.b #Vertikal,0,4,2 
;-Level7: 
Data.b #Vertikal,5,0,2 
Data.b #Vertikal,4,0,2 
Data.b #Vertikal,5,2,2 
Data.b #Vertikal,3,1,2 
Data.b #Master,1,2,2 
Data.b #Vertikal,1,0,2 
Data.b #Horizontal,2,0,2 
Data.b #Horizontal,2,3,2 
Data.b #Vertikal,3,4,2 
;-Level8: 
Data.b #Vertikal,5,0,3 
Data.b #Horizontal,4,3,2 
Data.b #Horizontal,3,4,3 
Data.b #Horizontal,3,5,3 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,0,4,2 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,0,3,2 
Data.b #Master,0,2,2 
Data.b #Vertikal,2,2,2 
Data.b #Vertikal,3,2,2 
Data.b #Horizontal,2,1,2 
Data.b #Horizontal,3,0,2 
Data.b #Vertikal,4,1,2 
;-Level9: 
Data.b #Vertikal,1,0,2 
Data.b #Master,0,2,2 
Data.b #Vertikal,0,3,3 
Data.b #Horizontal,1,3,3 
Data.b #Vertikal,2,4,2 
Data.b #Vertikal,5,4,2 
Data.b #Vertikal,5,2,2 
Data.b #Horizontal,4,1,2 
Data.b #Horizontal,4,0,2 
Data.b #Horizontal,2,0,2 
Data.b #Vertikal,3,1,2 
Data.b #Vertikal,4,2,3 
;-Level10: 
Data.b #Horizontal,4,0,2 
Data.b #Horizontal,4,1,2 
Data.b #Vertikal,5,2,3 
Data.b #Horizontal,4,5,2 
Data.b #Vertikal,3,4,2 
Data.b #Horizontal,1,3,3 
Data.b #Vertikal,0,2,3 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,0,1,2 
Data.b #Horizontal,0,0,2 
Data.b #Vertikal,2,0,2 
Data.b #Master,1,2,2 
;-Level11: 
Data.b #Vertikal,5,4,2 
Data.b #Horizontal,3,3,3 
Data.b #Horizontal,2,5,3 
Data.b #Vertikal,2,3,2 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,0,3 
Data.b #Horizontal,1,0,2 
Data.b #Vertikal,3,0,3 
;-Levell12: 
Data.b #Vertikal,5,0,3 
Data.b #Horizontal,3,3,3 
Data.b #Vertikal,4,4,2 
Data.b #Vertikal,2,1,3 
Data.b #Master,0,2,2 
Data.b #Vertikal,0,0,2 
Data.b #Horizontal,1,0,2 
Data.b #Horizontal,0,5,3 
;-Level13: 
Data.b #Horizontal,4,4,2 
Data.b #Horizontal,4,5,2 
Data.b #Vertikal,3,4,2 
Data.b #Vertikal,0,3,3 
Data.b #Horizontal,1,5,2 
Data.b #Vertikal,1,2,2 
Data.b #Vertikal,2,1,2 
Data.b #Master,3,2,2 
Data.b #Horizontal,0,0,2 
Data.b #Horizontal,2,0,2 
Data.b #Vertikal,4,0,2 
Data.b #Vertikal,5,1,3 
Data.b #Horizontal,3,3,2 
;-Level14 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,4,2,2 
Data.b #Vertikal,5,2,2 
Data.b #Horizontal,4,1,2 
Data.b #Master,2,2,2 
Data.b #Horizontal,2,3,2 
Data.b #Vertikal,2,4,2 
Data.b #Vertikal,2,0,2 
Data.b #Horizontal,0,0,2 
Data.b #Vertikal,0,2,2 
Data.b #Vertikal,1,2,2 
Data.b #Horizontal,0,5,2 
;-Level15: 
Data.b #Horizontal,1,5,2 
Data.b #Horizontal,3,5,2 
Data.b #Vertikal,3,3,2 
Data.b #Vertikal,2,3,2 
Data.b #Master,2,2,2 
Data.b #Horizontal,2,1,2 
Data.b #Horizontal,3,0,2 
Data.b #Horizontal,1,0,2 
Data.b #Vertikal,5,1,3 
Data.b #Vertikal,4,1,3 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,1,2,3 
Data.b #Vertikal,0,2,3 
Data.b #Horizontal,0,1,2 
;-Level16: 
Data.b #Vertikal,5,0,3 
Data.b #Horizontal,3,3,3 
Data.b #Master,3,2,2 
Data.b #Vertikal,4,0,2 
Data.b #Horizontal,2,0,2 
Data.b #Horizontal,2,1,2 
Data.b #Vertikal,2,2,3 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,0,0,2 
Data.b #Vertikal,0,1,2 
Data.b #Vertikal,1,2,2 
;-Level17: 
Data.b #Horizontal,0,5,3 
Data.b #Horizontal,0,4,3 
Data.b #Vertikal,3,3,3 
Data.b #Vertikal,4,4,2 
Data.b #Vertikal,5,4,2 
Data.b #Vertikal,2,2,2 
Data.b #Master,0,2,2 
Data.b #Horizontal,0,3,2 
Data.b #Vertikal,0,0,2 
Data.b #Horizontal,1,0,3 
Data.b #Horizontal,4,1,2 
Data.b #Horizontal,2,1,2 
;-Level18: 
Data.b #Horizontal,0,5,3 
Data.b #Horizontal,1,4,2 
Data.b #Vertikal,0,2,3 
Data.b #Horizontal,1,3,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,3,0,3 
Data.b #Vertikal,2,0,2 
Data.b #Horizontal,0,1,2 
Data.b #Horizontal,0,0,2 
;-Level19: 
Data.b #Horizontal,3,0,2 
Data.b #Vertikal,2,0,2 
Data.b #Master,2,2,2 
Data.b #Vertikal,4,1,2 
Data.b #Vertikal,4,3,2 
Data.b #Horizontal,2,3,2 
Data.b #Horizontal,1,4,3 
Data.b #Vertikal,1,2,2 
;-Level20: 
Data.b #Vertikal,5,2,3 
Data.b #Horizontal,3,5,3 
Data.b #Horizontal,3,4,2 
Data.b #Vertikal,2,4,2 
Data.b #Vertikal,2,2,2 
Data.b #Vertikal,3,1,2 
Data.b #Horizontal,1,1,2 
Data.b #Vertikal,0,0,2 
Data.b #Master,0,2,2 
Data.b #Horizontal,3,0,3 
;-Level21: 
Data.b #Horizontal,3,5,3 
Data.b #Horizontal,0,0,2 
Data.b #Vertikal,2,0,2 
Data.b #Vertikal,3,0,3 
Data.b #Horizontal,1,3,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,1,3 
;-Level22: 
Data.b #Vertikal,5,4,2 
Data.b #Horizontal,4,3,2 
Data.b #Horizontal,4,1,2 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,3,1,3 
Data.b #Vertikal,2,0,2 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,1,2 
Data.b #Vertikal,1,3,2 
Data.b #Vertikal,0,4,2 
Data.b #Horizontal,1,5,3 
Data.b #Horizontal,2,4,2 
;-Level23: 
Data.b #Horizontal,2,5,3 
Data.b #Horizontal,4,4,2 
Data.b #Horizontal,4,3,2 
Data.b #Vertikal,3,3,2 
Data.b #Vertikal,2,3,2 
Data.b #Vertikal,2,1,2 
Data.b #Master,3,2,2 
Data.b #Horizontal,3,1,2 
Data.b #Horizontal,2,0,3 
Data.b #Vertikal,5,0,3 
;-Level24: 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,0,4,3 
Data.b #Horizontal,1,3,2 
Data.b #Vertikal,0,2,2 
Data.b #Vertikal,1,1,2 
Data.b #Master,2,2,2 
Data.b #Vertikal,2,0,2 
Data.b #Horizontal,3,0,2 
Data.b #Vertikal,4,4,2 
Data.b #Vertikal,4,2,2 
;-Level25: 
Data.b #Horizontal,4,5,2 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,5,1,3 
Data.b #Vertikal,4,2,2 
Data.b #Horizontal,4,0,2 
Data.b #Horizontal,0,0,2 
Data.b #Horizontal,0,1,2 
Data.b #Vertikal,2,0,2 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,2,3 
Data.b #Vertikal,1,4,2 
Data.b #Horizontal,1,3,3 
Data.b #Vertikal,3,4,2 
;-Level26: 
Data.b #Vertikal,5,4,2 
Data.b #Vertikal,5,2,2 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,4,1,3 
Data.b #Vertikal,3,1,2 
Data.b #Horizontal,1,3,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,1,0,2 
Data.b #Vertikal,0,1,2 
Data.b #Vertikal,0,3,2 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,3,5,2 
;-Level27: 
Data.b #Horizontal,3,5,3 
Data.b #Vertikal,5,2,3 
Data.b #Horizontal,3,3,2 
Data.b #Vertikal,2,4,2 
Data.b #Vertikal,2,2,2 
Data.b #Master,0,2,2 
Data.b #Vertikal,0,0,2 
Data.b #Horizontal,1,0,2 
Data.b #Horizontal,1,1,2 
Data.b #Vertikal,3,0,3 
;-Level28: 
Data.b #Vertikal,5,3,3 
Data.b #Horizontal,4,1,2 
Data.b #Vertikal,3,0,2 
Data.b #Horizontal,0,0,3 
Data.b #Vertikal,2,1,3 
Data.b #Master,0,2,2 
Data.b #Vertikal,0,3,2 
Data.b #Vertikal,1,3,2 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,2,5,2 
Data.b #Horizontal,2,4,3 
Data.b #Horizontal,3,3,2 
;-Level29: 
Data.b #Vertikal,5,4,2 
Data.b #Vertikal,5,2,2 
Data.b #Vertikal,4,0,3 
Data.b #Horizontal,3,3,2 
Data.b #Vertikal,3,4,2 
Data.b #Horizontal,0,5,3 
Data.b #Vertikal,0,3,2 
Data.b #Horizontal,1,4,2 
Data.b #Horizontal,1,3,2 
Data.b #Master,0,2,2 
Data.b #Vertikal,2,1,2 
Data.b #Horizontal,0,0,3 
;-Level30: 
Data.b #Vertikal,5,3,3 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,3,1,2 
Data.b #Vertikal,2,0,2 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,0,3 
Data.b #Horizontal,0,3,2 
Data.b #Horizontal,2,3,2 
Data.b #Horizontal,2,5,2 
Data.b #Horizontal,0,5,2 
;-Level31: 
Data.b #Horizontal,3,5,3 
Data.b #Vertikal,5,2,3 
Data.b #Horizontal,4,1,2 
Data.b #Horizontal,3,0,3 
Data.b #Horizontal,0,0,2 
Data.b #Vertikal,3,1,2 
Data.b #Horizontal,3,3,2 
Data.b #Vertikal,2,3,3 
Data.b #Master,1,2,2 
Data.b #Vertikal,0,2,2 
Data.b #Horizontal,0,4,2 
;-Level32: 
Data.b #Vertikal,5,3,3 
Data.b #Horizontal,4,0,2 
Data.b #Vertikal,3,0,2 
Data.b #Vertikal,2,0,3 
Data.b #Horizontal,0,0,2 
Data.b #Master,0,2,2 
Data.b #Vertikal,0,3,2 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,1,3,2 
Data.b #Vertikal,3,4,2 
Data.b #Horizontal,3,3,2      
;-Level33: 
Data.b #Vertikal,5,3,3 
Data.b #Horizontal,3,3,2 
Data.b #Vertikal,4,4,2 
Data.b #Vertikal,3,4,2 
Data.b #Horizontal,0,5,3 
Data.b #Horizontal,1,4,2 
Data.b #Horizontal,1,3,2 
Data.b #Vertikal,0,3,2 
Data.b #Master,0,2,2 
Data.b #Vertikal,1,0,2 
Data.b #Vertikal,2,0,3 
Data.b #Horizontal,4,0,2 
;-Level34: 
Data.b #Vertikal,0,0,2 
Data.b #Master,0,2,2 
Data.b #Horizontal,0,3,3 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,3,5,2 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,3,3,2 
Data.b #Vertikal,4,2,2 
Data.b #Vertikal,3,1,2 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,5,1,3 
;-Level35: 
Data.b #Vertikal,5,0,3 
Data.b #Horizontal,3,0,2 
Data.b #Vertikal,3,1,2 
Data.b #Vertikal,2,0,3 
Data.b #Master,0,2,2 
Data.b #Vertikal,0,3,2 
Data.b #Horizontal,0,5,2 
Data.b #Horizontal,1,4,2 
Data.b #Vertikal,3,4,2 
Data.b #Vertikal,4,4,2 
Data.b #Horizontal,1,3,3 
;-Level36: 
Data.b #Horizontal,4,0,2 
Data.b #Vertikal,5,1,3 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,3,3,2 
Data.b #Horizontal,0,5,2 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,0,3,3 
Data.b #Vertikal,0,0,3 
Data.b #Horizontal,1,0,3 
Data.b #Vertikal,1,1,2 
Data.b #Horizontal,2,1,2 
Data.b #Master,2,2,2 
;-Level37: 
Data.b #Horizontal,4,5,2 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,5,1,3 
Data.b #Vertikal,4,1,3 
Data.b #Horizontal,4,0,2 
Data.b #Vertikal,3,4,2 
Data.b #Horizontal,0,5,2 
Data.b #Vertikal,0,2,3 
Data.b #Horizontal,0,0,2 
Data.b #Horizontal,0,1,2 
Data.b #Vertikal,2,0,2 
Data.b #Master,1,2,2 
Data.b #Horizontal,1,3,3 
;-Level38: 
Data.b #Horizontal,3,5,3 
Data.b #Vertikal,5,2,3 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,3,1,2 
Data.b #Vertikal,0,0,2 
Data.b #Master,0,2,2 
Data.b #Horizontal,1,1,2 
Data.b #Vertikal,2,2,2 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,3,3,2 
Data.b #Horizontal,3,4,2 
;-Level39: 
Data.b #Vertikal,5,2,3 
Data.b #Horizontal,3,0,3 
Data.b #Vertikal,2,0,2 
Data.b #Vertikal,2,2,2 
Data.b #Vertikal,3,1,2 
Data.b #Horizontal,3,3,2 
Data.b #Vertikal,0,4,2 
Data.b #Vertikal,1,4,2 
Data.b #Horizontal,2,5,2 
Data.b #Horizontal,2,4,2 
Data.b #Horizontal,0,3,2 
Data.b #Master,0,2,2 
;-Level40: 
Data.b #Horizontal,0,5,2 
Data.b #Vertikal,2,4,2 
Data.b #Horizontal,3,5,2 
Data.b #Vertikal,3,3,2 
Data.b #Horizontal,4,4,2 
Data.b #Vertikal,5,1,3 
Data.b #Vertikal,4,0,2 
Data.b #Master,3,2,2 
Data.b #Vertikal,2,1,2 
Data.b #Vertikal,1,1,2 
Data.b #Horizontal,1,0,2 
Data.b #Vertikal,0,0,3 
Data.b #Horizontal,0,3,3 
EndDataSection 
;} 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --8