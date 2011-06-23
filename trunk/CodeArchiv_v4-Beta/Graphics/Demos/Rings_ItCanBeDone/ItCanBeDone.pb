; German forum:
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


; 'This Can be done In PureBasic'
;
; a demo written in PureBasic
; (C) 2002 by Siegfried Rings
;
;
; Plz note,you have to check the paths from the includebinary at the end
; all Bitmaps are 24 Bit one

#width=800
#height=600
#SpriteFont=262

Global Use3D.l=1 ;Set them to NULL if your GFX-Card doesn't support 3D

Global MAX_STAR=1500, STAR_SPEED=5, star_x, star_y, start_z
Global XSCROLLER.w
Global BGPosition
Global BGCLIP
Global BGCLIP2
Global BGSinus.f
BGSinus=0.01
Global Startime
Global NowTime

Global Dim star_x.l(MAX_STAR)
Global Dim star_y.l(MAX_STAR)
Global Dim star_z.l(MAX_STAR)

;Bigscroller
Global Scrolltext.s
Scrolltext.s=UCase("       this is my first ever written intro on the pc many many thx must go to in no order  danilo paul and of course fred for his wonderfull compiler                         ")


;Ball-PositionStructure
Structure balls ; For CircleBallz and SinusBallzDemo
 x.w ; Ball x
 y.w ; Ball y 
EndStructure

Structure Tiles ;for Arkanoid Demo
 x.w ; 
 y.w ; 
 Hit.b;
EndStructure

Dim MyTiles.Tiles(15,10)
;Setting them up
For I1=1 To 15
 For I2=1 To 10
  MyTiles(I1,I2)\x=I1*32
  MyTiles(I1,I2)\y=I2*18
 Next I2
Next I1 

;This is the double BallSinusscroller PreCalculationtable
Dim SBall.balls(1024)
#SBWidth=50
#SBHeight=50
#SBALLMAX=60
Radius1 = (#width - SBWidth) / 2 - 4
Radius2 = (#height - SBHeight) / 2 - 4
For i = 0 To 1023;+SBALLMAX
    Faktor.f = 2 * #PI / 512 * i
    SBall(i)\x = (#width - #SBWidth) / 2 + Radius1 * Sin(Faktor * 2)
    If i<512
     SBall(i)\y  =(#height - #height) / 2 + Radius2 * Cos(Faktor * 3)
    Else
     SBall(i)\y  =(#height - #height) / 2 + Radius2 * Cos(Faktor * 1)
    EndIf 
Next i


; Create a list of balls
NewList ball.balls()
BallCount=60
For i = 1 To BallCount -1
 AddElement(ball()) ; This adds a ball to the list
 ball()\x = Cos(i/BallCount*#PI*2) * #width/4;i*10
 ball()\y = Sin(i/BallCount*#PI*2) * #height/4
Next


; now the normaly DX Initsequences going....
If InitMovie() = 0
   MessageRequester("Fehler","Can't open DirectX 7 InitMovieLib",0)
   End
EndIf

If InitSprite() = 0
 MessageRequester("Error", "Can't open DirectX 7 InitSprite", 0)
 End
EndIf

Result = InitSprite3D() 
If Result=0
 MessageRequester("Error", "Can't open DirectX 7 Init3dSprite", 0)
 End
EndIf
If InitKeyboard() = 0
 MessageRequester("Error","Can't open DirectX 7 InitKeyBoard",0)
 End
EndIf
If InitMouse() = 0
 MessageRequester("Error","Can't open DirectX 7 InitMouse",0)
 End
EndIf
If InitSound() = 0
   MessageRequester("Fehler","Can't open DirectX 7 InitSound",0)
   End
EndIf


Procedure SpriteCheck(x1,y1,w1,h1,x2,y2,w2,h2)
;Test SpriteCollission with Clipped Sprites(regions)
 x11=x1+w1
 y11=y1+h1
 x21=x2+w2
 y21=y2+h2
Result=0
;Which Sprite is bigger ?
;If (W1*H1)>(W2*H2)
 ;Sprite 1 is bigger, so check if Sprite 2 is in Sprite 1
 If x2>x1 And x2<x11
  If y2>y1 And y2<y11
   Result=1
;   Beep_(50,50)
  EndIf
 EndIf
;Else
 If x1>x2 And x1<x21
  If y1>y21 And y1<y21
   Result= 1
;   Beep_(500,50)
  EndIf
 EndIf
;EndIf
ProcedureReturn Result

EndProcedure

Procedure.l MTime(Time)
; Very tricky,measures the Tickcount in msec.
Shared StartTime
Shared NowTime
NowTime=GetTickCount_()
If Time=0
 ProcedureReturn NowTime
EndIf 
If Time=-1
  StartTime=NowTime;Reset the Timecounter
  ProcedureReturn StartTime
Else
  
  If NowTime>StartTime+Time ;Is time elapsed ?
   ProcedureReturn -1
  Else
   ProcedureReturn NowTime ;Now return the Ticks
  EndIf
EndIf
EndProcedure


;Following Routines are not from mine, somewhere else. did it
Procedure rnd(min.w,max.w)
 ;Simple RandomGenarator in a range
 a.w = max - Random (max-min)
 ProcedureReturn a
EndProcedure

Procedure setup_stars()
;Create the Stars-sprites on the fly
For c.w=0 To MAX_STAR
 star_x(c)= rnd(-#width/2,#width/2) << 6
 star_y(c)= rnd(-#height/2,#height/2) << 6
 star_z(c)=rnd(2,255)
Next
StartDrawing(ScreenOutput())
For i = 0 To 255
 FrontColor(RGB(i,i, i))
 Box(i*3, 0, 3, 3)
Next
StopDrawing()
For i = 0 To 255
 GrabSprite(i, i*3, 0, 3, 2)
Next
ProcedureReturn value
EndProcedure



Procedure DummyKeyboard()
ExamineKeyboard()
If KeyboardPushed(#PB_Key_Escape) 
 ;Do Nothing
EndIf
EndProcedure



Procedure UpdateStar(T2.f)
;In this Procedure  the Postion of the stars are calculated and displayed

 cos.f = Cos(T2.f) : sin.f = Sin(T2.f)
 For c = 0 To MAX_STAR
  star_z(c)=star_z(c) - STAR_SPEED
  x.l = star_x(c)
  y.l = star_y(c)
  star_y(c) = (y * cos - x * sin)
  star_x(c) = (x * cos + y * sin)
  If star_z(c)<=2
   star_z(c)=255
  EndIf
  s_x.w=(star_x(c)/star_z(c))+(#width/2)
  s_y.w=(star_y(c)/star_z(c))+(#height/2)
  col.w=255-star_z(c)
  DisplaySprite(col,s_x, s_y)
 Next
 ProcedureReturn value
EndProcedure

Procedure CalulateBigScroller()
;the BigScroller'Y-wipe
 Shared BGSinus
 BGSinus=BGSinus + 0.05
 If BGSinus>#PI
  BGSinus=- #PI
 EndIf
EndProcedure

Procedure DisplayBigScroller()
;the BigScroller and his Position
 Shared BGPosition
 Shared BGSinus
 Shared Scrolltext

 BGPosition=BGPosition-2
 If BGPosition<-Len(Scrolltext)*32
  BGPosition=0
 EndIf 


For i=1 To Len(Scrolltext)
 If BG_POSX+BGPosition<#width 
  CH=Asc(Mid(Scrolltext,i,1))
  If CH>64 And CH<91
   CX=(CH-65)*32
   If CX>=0 
    BG_POSY=300+Sin(BGSinus)*200
    ClipSprite(262, CX,0, 32, 28)
    DisplayTransparentSprite (262,BG_POSX+BGPosition,BG_POSY)
   EndIf 
  EndIf
 EndIf
 BG_POSX=BG_POSX+32
Next i 

EndProcedure


Procedure FlashText(Text.s,XPos,YPos,FontName.s,Fontsize,DelayTime)
;Simple syncronly Procedure To flash a text
 LoadFont(1,FontName,Fontsize)
  
 For i=1 To 255 Step 3 
   StartDrawing(ScreenOutput())
   DrawingMode(1) 
   DrawingFont(FontID(1)) 
   FrontColor(RGB(i,i,i) )
   DrawText(XPos,YPos,Text)
   StopDrawing() 
   FlipBuffers()
   If IsScreenActive()
     ClearScreen(0)
   EndIf
  Delay(1)
  DummyKeyboard()
 Next i
 Delay(DelayTime)
 
 LoadFont(1,FontName,Fontsize)
 For i=255 To 1 Step -6 
  StartDrawing(ScreenOutput())
   DrawingMode(1) 
   DrawingFont(FontID(1)) 
   FrontColor(RGB(i,i,i))
   DrawText(XPos,YPos,Text)
   StopDrawing() 
   FlipBuffers()
   If IsScreenActive()
     ClearScreen(0)
   EndIf

  Delay(1)
  DummyKeyboard()
 Next i
FreeFont(1)
EndProcedure


If OpenScreen( #width,#height, 32, "ItCanBeDone") ;Try to Open Screen in 32 Bit
 Goto StartIntro
Else
 If OpenScreen( #width,#height, 16, "ItCanBeDone");Try to Open in 16 Bit
  Goto StartIntro
 Else
  MessageRequester("Error", "Can't open screen !", 0);Uups Screen cannot Open,then return
  End
 EndIf
EndIf


StartIntro:

 LoadFont(2,"Arial",30)
 SetFrameRate(60)
 setup_stars()
 TransparentSpriteColor(-1,RGB(255,0,255));Pink is our all BMP-Transparent Color

 ;Very tricky, all needed gfx are taken from Memory(Resources)
 Result = CatchSprite(261, ?SpriteGuru,0)  ;For use normal 2D Logo
 Result = CatchSprite(262, ?SpriteFontABC,0) ;For use Scroller
 Result=CatchSprite(263,?SpriteGuru,#PB_Sprite_Texture);For use 3DSprites
 TransparentSpriteColor(263,RGB(255,0,255))
 Result=CatchSprite(264,?SpriteBall,0) ; the Balls
 Result=CatchSprite(265,?SpritePaddle,0) ; The Arkanoid-paddle
 Result=CatchSprite(266,?SpriteTile,0) ; The Arkanoid-Tiles(Blocks)
 Result=CatchSprite(267,?SpriteCursor,0) ; Mouse-Cursor
 Result=CatchSprite(268,?SpriteSonicRun,0);Sonic runs
 Result=CatchSprite(269,?SpriteSonicWalk,0);Sonic walks
 Result=CatchSprite(270,?SpriteSonicRings,0);Sonic Rings :)

 If Use3D
  Result = CreateSprite3D(0,263) 
  Result = CreateSprite3D(1,263) 
 EndIf

;The Sound is also grabbed from Memory
 Result=CatchSound(1,?SoundCowBell)

SetupVars:

 ;These are the Flags if one effect occurs on the screen
 Paddle=0
 guru=0;1
 Ballz=0;1
 SBALLZ=0
 REDLOGO=0
 BigScroll=0
 UseStars=0
 Sonic=0
 
 ;Some vars
 RSMin=150
 RSMax=300
 RS1=RSMin
 RS2=RSMax
 RS11=2
 RS21=-2
 RSX1=(#width-SpriteWidth(261))/2
 RSX2=RSX1
 RSMIN3=0
 RSMAX3=280;+360
 RS3=2
 RS31=-4

 BSize.f=0.5
 BSX=200
 BSXV=5
 BSY=150
 BSYV=6

 T.f=0.0005
 T2.f=0.000
 XSCROLLER=#width
 SonicRun1=-32
 SonicRun2=0
 SonicRun3=5
 SonicWalk1=#width
 SonicWalk2=0
 SonicWalk3=0
 SonicWalk4=#height
 SonicWalk5=-1
 SonicRings=0
 SonicRing2=0
 SonicRing3=2
 BoxCol1=1
 SBT2=2

 RSMIN3=0
 RSMAX3=280;+360
 
 RS3=1
 RS31=-4

 ;Okay lets begin with some soundbackground
 SoundPan(1,0) 
 SoundFrequency(1,800)
 PlaySound(1,0) 
 FlipBuffers()
 FlashText ("....Yes.....",320,270,"ARIAL",20,200)
 PlaySound(1,0) 
 FlashText ("Believe me..",320,270,"ARIAL",20,500)
 PlaySound(1,0) 
 FlashText ("It can be done in",300,270,"ARIAL",20,500)
 PlaySound(1,0) 
 SoundFrequency(1,800)
 FlashText ("PureBasic",180,200,"ARIAL",80,500)
 FlashText (";)",330,220,"CourierNew",100,200)

 ;MIDI is also grabbed from Memory, temporary saved to disk(Will removed at the end)
  If CreateFile(1, "temp.mid") ;Create File      
   L1= ?MIDIEND-?MIDI1    ;get the size of it       
   WriteData(1,?MIDI1,L1) ;write it down to the file      
   CloseFile(1); Close Filepointer
   Result=LoadMovie(0,"temp.mid")
   If Result
    PlayMovie(0,ScreenID());Play it
   Else
    Beep_(200,300);Uups what s that ?
   EndIf
  EndIf

MTime(-1);Start timer
Repeat
 DummyKeyboard()
 RS30=RS30-2
 ClearScreen(0) 
 If Use3D
  Result = Start3D() 
  If Result
   Result=ZoomSprite3D(0,RS30,RS30)
   If RS30>-270
     Result=RotateSprite3D(0,RS30,2)
   Else
     Result=RotateSprite3D(0,-270,2)
   EndIf
   Transparenty=(512+RS30)/2
   If Transparenty<0
    Transparenty=0
   EndIf 
   Result=DisplaySprite3D(0,(#width-RS30)/2,(#height-RS30)/2, Transparenty) 
   Stop3D() 
  EndIf
  EndIf
  If MTime(5500)=-1:Goto Weiter:EndIf
  If Use3D=0:Goto Weiter:EndIf
  FlipBuffers()
Until Transparenty<0 ;Transparenty<0;MTime(8500,1)=-1

Weiter:
ClearScreen(0) 
FlipBuffers()
Delay(100)

MTime(-1);Reset the timer
 
SetFrameRate(60);set it to your needs !

Repeat
ALTTAB:
 FlipBuffers()
 If IsScreenActive()=0
  Delay(1)
  Goto ALTTAB
 EndIf
 ClearScreen(0)
 
 ;Timing
 If MTime(5000)=-1 And MTime(5500)<>-1
  FlashText ("looks lame, wait 3 seconds",180,200,"ARIAL",30,100)
  Ticker=1
 EndIf
 If MTime(10000)=-1 And MTime(11000)<>-1
  FlashText ("added a rotating starfield",180,200,"ARIAL",30,100)
 EndIf
 If MTime(10000)=-1:UseStars=1:  EndIf

 If MTime(20000)=-1 And MTime(21000)<>-1
  FlashText ("a simple moving logo",180,200,"ARIAL",30,100)
 EndIf
 If MTime(20000)=-1:REDLOGO=1:  EndIf
 

 If MTime(30000)=-1 And MTime(30500)<>-1
  FlashText ("some wiping bigscroller...",180,200,"ARIAL",30,100)
 EndIf
 If MTime(30000)=-1:BigScroll=1:EndIf

 
 If MTime(40000)=-1 And MTime(40500)<>-1
  FlashText ("some sinus-ballz...",180,200,"ARIAL",30,100)
 EndIf
 If MTime(40000)=-1:SBALLZ=1:EndIf


 If MTime(50000)=-1 And MTime(50500)<>-1
  FlashText ("and 3D-Guru's...",180,200,"ARIAL",30,100)
 EndIf
 If MTime(50000)=-1:guru=1:REDLOGO=0:EndIf


 If MTime(60000)=-1 And MTime(60500)<>-1
  FlashText ("some other ballz...",180,200,"ARIAL",30,100)
 EndIf
 If MTime(60000)=-1:Ballz=1:SBALLZ=0:EndIf

 If MTime(70000)=-1 And MTime(70500)<>-1
  FlashText ("remember Arkanoid ?",180,200,"ARIAL",30,100)
 EndIf
 If MTime(70000)=-1:Paddle=1:Ballz=0:guru=0:EndIf

 If MTime(80000)=-1 And MTime(80500)<>-1
  FlashText ("remember Sonic ?",180,200,"ARIAL",30,100)
 EndIf
 If MTime(80000)=-1:Sonic=1:Ballz=0:guru=0:EndIf

 If MTime(90000)=-1 And MTime(90500)<>-1
  FlashText ("Now all together",180,200,"ARIAL",30,100)
 EndIf
 If MTime(90500)=-1:Paddle=1:Ballz=1:guru=1:SBALLZ=1:REDLOGO=1:EndIf
 
 T2=T2+T
 If T2>0.05 Or T2<-0.05
  T=T*-1
 EndIf
 
 ;set the Mouse-Sprite with the easy way
 ExamineMouse()
 MX=MouseX()
 MY=MouseY()
 DisplayTransparentSprite(267,MX,MY)
; If SpriteCheck(100,30,300,16,MX,MY,17,30)
;   Beep_(50,100)
; EndIf
 
 If UseStars=1
  UpdateStar(T2)
 EndIf
 If Sonic=1
  SonicRun1+4
  If SonicRun1>#width
   SonicRun1=-32
  EndIf
  SonicRun2+1
  If SonicRun2=5
   SonicRun3+1
   If SonicRun3>3
    SonicRun3=0
   EndIf 
   SonicRun2=0
  EndIf 
  ClipSprite(268, SonicRun3*32,0, 32, 36)
  DisplayTransparentSprite (268,SonicRun1,1)

  SonicWalk1+1
  If SonicWalk1>#width
   SonicWalk1=-40
  EndIf
  SonicWalk2+1
  If SonicWalk2=5
   SonicWalk3+1
   SonicRings+1
   SonicRing2=SonicRing2+SonicRing3
   If SonicRing2>10:SonicRing3=-SonicRing3:EndIf
   If SonicRing2<0:SonicRing3=-SonicRing3:EndIf
   If SonicWalk3>7:SonicWalk3=0:EndIf 
   SonicWalk2=0
  EndIf 
  SonicWalk4=SonicWalk4+SonicWalk5
  If SonicWalk4<(4*#height/6)
   SonicWalk5=-SonicWalk5
  EndIf
  If SonicWalk4>#height
   SonicWalk5=-SonicWalk5
  EndIf

  ClipSprite(269, SonicWalk3*40+320,0, 32, 36)
  DisplayTransparentSprite (269,#width-SonicWalk1,SonicWalk4-36)

 
  If SonicRings>3
   SonicRings=0
  EndIf
  ClipSprite(270, SonicRings*16,0, 16, 16)
  DisplayTransparentSprite (270,#width-SonicWalk1-30,SonicWalk4-30+SonicRing2)
EndIf

 
 If XSCROLLER<-100 ;the easy scroller at the top
   XSCROLLER=#width
 EndIf
 XSCROLLER=XSCROLLER-1
 StartDrawing(ScreenOutput())
 DrawingMode(1) 
  
 BoxCol=BoxCol+BoxCol1
 If BoxCol>50:  BoxCol1=-BoxCol1: EndIf
 If BoxCol<1:  BoxCol1=-BoxCol1: EndIf
 FrontColor(RGB(BoxCol*2,0,0))
 Box(1, 34, #width, 1) 
 FrontColor(RGB(BoxCol*5,0,0))
 Box(1, 35, #width, 1) 
 FrontColor(RGB(BoxCol*2,0,0)) 
 Box(1, 36, #width, 1) 
 FrontColor(RGB(240-(BoxCol*4),240-(BoxCol*4),240-(BoxCol*4)))
 Box(1, SonicWalk4-2, #width, 1) 
 FrontColor(RGB(120-(BoxCol*2),120-(BoxCol*2),120-(BoxCol*2)))
 Box(1, SonicWalk4-1, #width, 1) 
 DrawingMode(1) 
 FrontColor(RGB(100,100,0))
 DrawText(XSCROLLER+1,26+1,"-CodeGuru- strikes back.......") ;#height/5=26
 FrontColor(RGB(250,250,0))
 DrawText(XSCROLLER,26,"-CodeGuru- strikes back.......")


 DrawingFont(FontID(2)) 
 DrawText(#width-XSCROLLER,SonicWalk4+2,"-PureBasic- ..Powerfull Basic Language..")

 If Ticker=1
  ML.f= MovieStatus(0)/MovieLength(0)*100  
  FrontColor(RGB(40,40,150))
  DrawText(2,2,"INTRO-Finished (%) : "+StrF(ML,1))
  FrontColor(RGB(80,80,250))
  DrawText(1,1,"INTRO-Finished (%) : "+StrF(ML,1))
 EndIf
 StopDrawing() 
 

 y1=y1+1
 If y1>300:y1=0:EndIf

 RS1=RS1+RS11
 If RS1>RSMax: RS11=-RS11:EndIf
 If RS1<RSMin: RS11=-RS11:EndIf

 RS2=RS2+RS21
 If RS2>RSMax: RS21=-RS21:EndIf
 If RS2<RSMin: RS21=-RS21:EndIf


 If REDLOGO>0
  If RS11<0
   ClipSprite(261, 0,0, SpriteWidth(263), SpriteHeight(263)/2)
   DisplayTransparentSprite (261,RSX1,RS1)
   ClipSprite(261, 0,SpriteHeight(263)/2, SpriteWidth(263), SpriteHeight(263)/2)
   DisplayTransparentSprite (261,RSX2,RS2)
  Else
   ClipSprite(261, 0,SpriteHeight(263)/2, SpriteWidth(263), SpriteHeight(263)/2)
   DisplayTransparentSprite (261,RSX2,RS2)
   ClipSprite(261, 0,0, SpriteWidth(263), SpriteHeight(263)/2)
   DisplayTransparentSprite (261,RSX1,RS1)
  EndIf
 EndIf
 ;DisplayTransparentSprite (263,10,10)
 RS3=RS3+RS31
 If RS3>RSMAX3: RS31=-RS31:EndIf
 If RS3<RSMIN3: RS31=-RS31:EndIf

If SBALLZ=1
    SBT +1
    If SBT > (1024-#SBALLMAX) 
     SBT=0
     SBT2 +1
     If SBT2=4
      SBT2=0
     EndIf 
    EndIf 
    For Pos1 = 0 To #SBALLMAX Step 2 ;511
        XP = SBall(Pos1 + SBT)\x 
        YP = SBall(Pos1 + SBT)\y + #height/2
        ClipSprite(264, SBT2*50,0, 50, 50)
        DisplayTransparentSprite(264, XP,YP) 
    Next Pos1    
EndIf

If Ballz=1
 ClipSprite(264, 0,0, 50, 50)
 BSize.f=BSize.f + 0.05
 If BSize.f>2 :BSize.f=-2:EndIf
 FirstElement(ball()) ; Move the struct list to the first item
 i=0
 While NextElement(ball()) 
  DisplayTransparentSprite(264, ball()\x+#width/2, ball()\y+#height/2) ; Display the sprite with masking
  i=i+1
  ball()\x = Cos(i/BallCount*#PI*2) * #width/4 * BSize ;i*10
  ball()\y = Sin(i/BallCount*#PI*2) * #height/4 * BSize 
  If ball()\y >#height:ball()\y =0: EndIf 
 Wend
EndIf

If Use3D

 Result = Start3D()

 If Result
  If guru=1
   Result=ZoomSprite3D(0,RS3,RS3)
   Result=RotateSprite3D(0,RS3,1)
   Result=DisplaySprite3D(0,(#width-RS3)/2,(#height-RS3)/2, 255) 
  EndIf

 If Paddle
  Result=ZoomSprite3D(1,80,80)
  RS4=RS4+1
  If RS4=360 :RS4=0: EndIf 
  Result=RotateSprite3D(1,RS4,1)
  BSX=BSX+BSXV
  BSY=BSY+BSYV
  If BSX>=#width-80 
   BSXV=-BSXV
   PlaySound(1,0) 
   SoundPan(1,100) 
   SoundFrequency(1,4000)
  EndIf 
  If BSX<=0 
   BSXV=-BSXV
   PlaySound(1,0) 
   SoundPan(1,-100) 
   SoundFrequency(1,4000)
  EndIf 
  If BSY>=#height-80 
   BSYV=-BSYV
   PlaySound(1,0) 
   SoundPan(1,0) 
   SoundFrequency(1,14000)
  EndIf 
  If BSY<=0 
   BSYV=-BSYV
   PlaySound(1,0) 
   SoundPan(1,0) 
   SoundFrequency(1,8000)
  EndIf 
  DisplayTransparentSprite(265, BSX, #height-20) ; Display paddle
  For I1=1 To 15
   For I2=1 To 10
    If MyTiles(I1,I2)\Hit=0
     ClipSprite(266, 32*I2,0, 30, 16)
     DisplayTransparentSprite(266,100+MyTiles(I1,I2)\x,30+MyTiles(I1,I2)\y);Tiles
     If SpriteCheck(BSX,BSY,80,80,MyTiles(I1,I2)\x,MyTiles(I1,I2)\y,30,16)
      MyTiles(I1,I2)\Hit=1
      PlaySound(1,0) 
      SoundPan(1,0) 
      SoundFrequency(1,10000)
      BSYV=-BSYV
      BSXV=-BSXV
     EndIf
    EndIf
   Next I2
  Next I1 
  Result=DisplaySprite3D(1,BSX,BSY, 255) 
 EndIf  
 Stop3D() 
EndIf
EndIf

If BigScroll=1
  If MTime(0)>Oldtime+5
   Oldtime=MTime(0)
   CalulateBigScroller()
  EndIf 
   DisplayBigScroller()
EndIf

If MovieStatus(0) =0 
 Goto ThisIsTheEnd
EndIf

ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape) ; If ESCAPE is pressed: END


ThisIsTheEnd:
If FileSize("temp.mid")>0
 DeleteFile("temp.mid")
EndIf
FlashText ("The END",340,270,"ARIAL",20,100)
FlashText ("(c)2002 -CodeGuru-",280,270,"ARIAL",20,100)
End


;DataSection
SpriteFontABC:
IncludeBinary"FontABC.bmp"
SpriteGuru:
IncludeBinary"Codeguru.bmp"
SpriteBall:
IncludeBinary"ball.bmp"
SpritePaddle:
IncludeBinary"Paddle.bmp"
SpriteTile:
IncludeBinary"Tiles.bmp"
SpriteCursor:
IncludeBinary"Cursor.bmp"
SpriteSonicRun:
IncludeBinary"sonicrun.bmp"
SpriteSonicWalk:
IncludeBinary"sonWalk.bmp"
SpriteSonicRings:
IncludeBinary"rings.bmp"

SoundCowBell:
IncludeBinary"CowBell.wav"

MIDI1:
IncludeBinary"DG.mid";
MIDIEND: 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableAsm
; UseIcon = C:\Programme\Microsoft Visual Studio\Common\Graphics\Icons\Elements\FIRE.ICO
; Executable = D:\Source\Purebasic\RedSector\Out\itcanbe.exe