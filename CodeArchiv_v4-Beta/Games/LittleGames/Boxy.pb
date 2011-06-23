; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3591&start=0
; Author: Epyx (updated for PB 4.00 by Andre)
; Date: 07. June 2005
; OS: Windows
; Demo: Yes


;***************************************************************************** 
;** ** 
;** Boxy a Sokoban Clone written by Epyx 06/2005 ** 
;** No Ressources are included, all grafix and Sounds are runtime generated ** 
;** ** 
;** epyx@FlashArts.de Http://www.FlashArts.de ** 
;** No idea who have written the Procedure to create Sounds at runtime ** 
;** but i found it here ... ** 
;** http://www.purebasic-lounge.de/viewtopic.php?t=647&highlight=sounds ** 
;** ** 
;***************************************************************************** 

Declare Create_Sprites() 
Declare Draw_Map(Mode.l) 
Declare Init() 
Declare GenSFX(nr,Frequency, Duration,Mode) 
Declare CloseSFX(nr) 

If InitSprite()=0 : MessageRequester("Boxy - DirectX Error","You need at least DirectX 7 to run this game",#MB_ICONERROR) : End : EndIf 
If InitSprite3D()=0 : MessageRequester("Boxy - 3D Error","You need at least a Direct3D Card to run this game",#MB_ICONERROR) : End : EndIf 
If InitSound()=0 : MessageRequester("Boxy - Sound Error","Cant activating your SoundCard",#MB_ICONERROR) : End : EndIf 


X= InitKeyboard() 

Title_Window$ = "Boxy"
Fullscreen=1 : Screen_X=640 : Screen_Y=480 
Global Dim Map.l(20,14) : Global Dim SMap(20,14) 

Global FigurX,FigurY,Finish_Points,PoCol,Crate_on_finish 


Init() : GenSFX(1,22610,50,0) : GenSFX(2,44610,100,1) : GenSFX(3,810,300,2) : GenSFX(4,810,300,2) 

SoundVolume(1, 30) : SoundVolume(2, 100) 


If Fullscreen=0 
hWnd=OpenWindow(0,0,0,Screen_X,Screen_Y,Title_Window$,#PB_Window_ScreenCentered) 
X=OpenWindowedScreen(hWnd,0,0,Screen_X,Screen_Y,0,0,0) 
Else 
X= OpenScreen(Screen_X, Screen_Y, 32, Title_Window$) 
EndIf 


Create_Sprites() 

Structure Info_ST 
  image.l 
  x.l 
  y.l 
  SinX.f 
  SinY.f 
  SinXS.l 
  SinYS.l 
  SinXA.f 
  SinYA.f 
  SinSA.f 
  Size.l 
  SizeS.f 
  Rot.f 
EndStructure 
NewList Partikel.Info_ST() 



Menu: 
ClearList(Partikel()) 
For t = 0 To 19 
  AddElement(Partikel()) 
  Partikel()\image = 50 + Random(2) 
  Partikel()\x = 0 : Partikel()\y = 0 
  Partikel()\SinX = 0 + (t*2) 
  Partikel()\SinY = 0 + (t*2) 
  Partikel()\SizeS= Random(360) 
  Partikel()\SinXA= Random(1000000) / 1000000.0 
  Partikel()\SinYA= Random(1000000) / 1000000.0 
  Partikel()\SinSA= Random(1000000) / 1000000.0 
  Partikel()\SinXS = 320 : Partikel()\SinYS = 240 
Next t 

Restore Intro 
For Y = 1 To 14 : For X = 1 To 20 
ShAd=0 : Read ima : If ima=2 : Finish_Points+1 : EndIf 
Map(X,Y) = ima : SM=ima : If ima>2 : SM=1 : EndIf 
SMap(X,Y) = SM : Next X : Next Y 
FigurX=-200 : FigurY=-200 : Taste=0 



; ######################################### 
; ### Menu Loop ### 
; ######################################### 
Repeat 
  
  ClearScreen(RGB(0,0,0))
  
  If Fullscreen=0 
  Event = WindowEvent() 
  Select Event 
  Case #PB_Event_CloseWindow 
  End 
  EndSelect 
  Delay(10) 
  EndIf 
  
  Draw_Map(0) 
  
  StartDrawing(ScreenOutput()) 
  DrawingMode(1) : FrontColor(RGB(255, 200, 200))
  DrawText(230, 310, "a Game written by Epyx 2005") 
  DrawText(440, 377, "Press Enter to Start the Game") 
  DrawText(440, 409, "Escape to exit this Game") 
  FrontColor(RGB(255, 0, 0))
  DrawText(0, 377, "Cursor keys to move the cone head") 
  DrawText(0, 393, "Cursor keys and space to push the crates") 
  DrawText(0, 409, "F1 to reset the scene and try again") 
  DrawText(0, 425, "Escape jumps to the menu") 
  StopDrawing() 
  
  ExamineKeyboard() 
  If KeyboardReleased(#PB_Key_Escape) 
  CloseSFX(1) : CloseSFX(2) : End 
  EndIf 
  
  Taste= KeyboardPushed(#PB_Key_Return) 
  FlipBuffers() 
Until (Taste<>0) 



Map_number=0 : Taste=0 
Start: 
Seconds_to_Run=125 : Turns_needed=0 

Reset: 
Finish_Points=0 


If Map_number=0 : Restore Level0 : EndIf 
If Map_number=1 : Restore Level1 : EndIf 
If Map_number=2 : Restore Level2 : EndIf 
If Map_number=3 : Restore Level3 : EndIf 
If Map_number=4 : Restore Level4 : EndIf 
If Map_number=5 : Restore Level5 : EndIf 
If Map_number=6 : Restore Level6 : EndIf 
If Map_number=7 : Restore Level7 : EndIf 
If Map_number=8 : Restore Level8 : EndIf 
If Map_number=9 : Goto Menu : EndIf 

For Y = 1 To 14 
  For X = 1 To 20 
    ShAd=0 
    Read ima 
    If ima=2 Or ima=5 : Finish_Points+1 : EndIf 
    Map(X,Y) = ima : SM=ima 
    If ima>2 : SM=1 : EndIf 
    SMap(X,Y) = SM 
    If ima=5 : Map(X,Y) =4 : SMap(X,Y) =2 : EndIf 
  Next X 
Next Y 
Read FigurX : Read FigurY : Read Epyx 



; ######################################### 
; ### Main Loop ### 
; ######################################### 
Repeat 
  
  ClearScreen(RGB(0,0,0))
  
  JTime = timeGetTime_() 
  If (JTime-LTime) > 999 
  LTime = timeGetTime_() 
  If Seconds_to_Run<11 : SoundFrequency(3, 30000) : PlaySound(3,0) : SoundFrequency(4, 15000): PlaySound(4,0): EndIf 
  Seconds_to_Run -1 
  Else 
  SFPS + 1 
  EndIf 
  
  
  If Fullscreen=0 
  Event = WindowEvent() 
  Select Event 
  Case #PB_Event_CloseWindow 
  End 
  EndSelect 
  Delay(10) 
  EndIf 
  
  ExamineKeyboard() : Taste = KeyboardReleased(#PB_Key_Escape) 
  
  If RCol=0 : PoCol +2 : If PoCol> 100 : RCol=1 : EndIf : EndIf 
  If RCol=1 : PoCol -2 : If PoCol< 10 : RCol=0 : EndIf : EndIf 
  Crate_on_finish=0 
  
  Start3D() 
  Sprite3DBlendingMode(5,7) 
  ResetList(Partikel()) 
  While NextElement(Partikel()) 
  
    Sprite3DQuality(1) 
    Partikel()\x = ((Screen_X/2)-16)+(Sin(Partikel()\SinX * #PI/180) * Partikel()\SinXS) 
    Partikel()\y = ((Screen_Y/2)-16)+(Sin(Partikel()\SinY * #PI/180) * Partikel()\SinYS) 
    
    Partikel()\Size = (Sin(Partikel()\SizeS * #PI/180) * 255) 
    ZoomSprite3D(Partikel()\image, Partikel()\Size, Partikel()\Size) 
    RotateSprite3D(Partikel()\image, Partikel()\Rot, 0) 
    DisplaySprite3D(Partikel()\image, Partikel()\x, Partikel()\y, 155) 
    
    Partikel()\SinX+Partikel()\SinXA : Partikel()\SinY+Partikel()\SinYA : Partikel()\SizeS+Partikel()\SinSA : Partikel()\Rot+ 0.5 
  Wend 
  Stop3D() 
  
  Draw_Map(1) 
  
  
  If KeyboardPushed(#PB_Key_F1) : Goto Reset : EndIf 
  If KeyboardPushed(#PB_Key_Space) : Space_me=1 : Else : Space_me=0 : EndIf 
  
  If KeyboardPushed(#PB_Key_Left) And Taschte=0 : FigurX-1 : Taschte=1 : Turns_needed+1 : PlaySound(1,0) 
  If (Map(FigurX,FigurY)=4) And (Map(FigurX-1,FigurY)<3) And (Space_me=1) 
  Map(FigurX-1,FigurY)=4 : Map(FigurX,FigurY)=SMap(FigurX,FigurY): PlaySound(2,0) : EndIf 
  If Map(FigurX,FigurY)>2 : FigurX+1 : Turns_needed-1 : EndIf : EndIf 
  
  If KeyboardPushed(#PB_Key_Right) And Taschte=0 : FigurX+1 : Taschte=1 : Turns_needed+1 : PlaySound(1,0) 
  If (Map(FigurX,FigurY)=4) And (Map(FigurX+1,FigurY)<3) And (Space_me=1) 
  Map(FigurX+1,FigurY)=4 : Map(FigurX,FigurY)=SMap(FigurX,FigurY): PlaySound(2,0) : EndIf 
  If Map(FigurX,FigurY)>2 : FigurX-1 : Turns_needed-1 : EndIf : EndIf 
  
  If KeyboardPushed(#PB_Key_Up) And Taschte=0 : FigurY-1 : Taschte=1 : Turns_needed+1 : PlaySound(1,0) 
  If (Map(FigurX,FigurY)=4) And (Map(FigurX,FigurY-1)<3) And (Space_me=1) 
  Map(FigurX,FigurY-1)=4 : Map(FigurX,FigurY)=SMap(FigurX,FigurY) : PlaySound(2,0) : EndIf 
  If Map(FigurX,FigurY)>2 : FigurY+1 : Turns_needed-1 : EndIf : EndIf 
  
  If KeyboardPushed(#PB_Key_Down) And Taschte=0 : FigurY+1 : Taschte=1 : Turns_needed+1 : PlaySound(1,0) 
  If (Map(FigurX,FigurY)=4) And (Map(FigurX,FigurY+1)<3) And (Space_me=1) 
  Map(FigurX,FigurY+1)=4 : Map(FigurX,FigurY)=SMap(FigurX,FigurY): PlaySound(2,0) : EndIf 
  If Map(FigurX,FigurY)>2 : FigurY-1 : Turns_needed-1 : EndIf : EndIf 
  
  
  If KeyboardPushed(#PB_Key_Down)=0 And KeyboardPushed(#PB_Key_Up)=0 And KeyboardPushed(#PB_Key_Right)=0 And KeyboardPushed(#PB_Key_Left)=0 : Taschte=0 : EndIf 
  
  StartDrawing(ScreenOutput()) 
  DrawingMode(1) : FrontColor(RGB(255, 255, 255))
  DrawText(90, 0, "Time: "+Str(Seconds_to_Run)) 
  DrawText(178, 0, "Level: "+Str(Map_number+1)) 
  DrawText(260, 0, "Turns: "+Str(Turns_needed)) 
  DrawText(520, 0, "Epyx Turns: "+Str(Epyx)) 
  StopDrawing() 
  
  FlipBuffers() 
  
  If Crate_on_finish=Finish_Points 
  SoundFrequency(3, 22000) : PlaySound(3,0) : Delay(100) 
  SoundFrequency(4, 16000) : PlaySound(4,0) : Delay(100) 
  SoundFrequency(3, 11000) : PlaySound(3,0) : Delay(100) 
  SoundFrequency(4, 20000) : PlaySound(4,0) : Delay(300) 
  SoundFrequency(3, 15000) : PlaySound(3,0) : Delay(100) 
  SoundFrequency(4, 15000) : PlaySound(4,0) : Delay(200) 
  Delay(2000) : Map_number+1 : Goto Start : EndIf 
  If Seconds_to_Run<0 : Taste=1 : EndIf 
  
Until (Taste<>0) 

Goto Menu 


DataSection 

Intro: 

Data.l 3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 3,1,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 3,1,3,3,1,1,1,3,3,1,1,3,1,3,3,1,3,1,1,3 
Data.l 3,1,1,3,3,1,3,1,3,3,1,3,1,3,3,1,3,1,1,3 
Data.l 3,1,1,3,3,1,3,1,3,3,1,1,3,3,1,1,3,3,3,3 
Data.l 3,1,1,3,3,1,3,1,3,3,1,3,1,3,3,1,1,3,3,1 
Data.l 3,3,3,3,1,1,1,3,3,1,1,3,1,3,3,1,1,3,3,1 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 


Level0: 
Data.l 0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0 
Data.l 0,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,0,0 
Data.l 0,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,0,0 
Data.l 0,3,1,1,3,3,3,3,1,2,1,3,3,3,3,1,1,3,0,0 
Data.l 0,3,1,1,3,1,1,1,1,1,1,1,1,1,3,1,1,3,0,0 
Data.l 0,3,1,1,3,1,1,1,1,1,1,1,1,1,3,1,1,3,0,0 
Data.l 0,3,1,1,1,1,1,1,4,1,1,1,1,1,1,1,1,3,0,0 
Data.l 0,3,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,3,0,0 
Data.l 0,3,1,1,3,1,1,1,1,1,1,1,1,1,3,1,1,3,0,0 
Data.l 0,3,1,1,3,1,1,1,1,1,1,1,1,1,3,1,1,3,0,0 
Data.l 0,3,1,1,3,3,3,3,1,2,1,3,3,3,3,1,1,3,0,0 
Data.l 0,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,0,0 
Data.l 0,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,0,0 
Data.l 0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0 
Data.l 10,7,20 

Level1: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,2,1,4,1,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,4,1,4,1,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,2,1,4,1,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 10,7,18 

Level2: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,4,2,1,4,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,2,4,1,4,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,4,2,1,4,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,2,4,1,4,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 7,8,45 

Level3: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,4,2,2,1,1,3,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,2,2,3,1,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,3,3,4,4,4,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,3,1,1,1,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 7,6,91 

Level4: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,3,1,1,1,3,3,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,1,1,3,1,1,1,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,1,3,1,1,3,1,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,1,4,1,4,3,1,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,2,3,1,1,1,1,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,2,1,1,3,3,3,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 7,6,74 

Level5: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,1,1,3,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,3,3,3,1,1,3,3,3,3,3,0,3,3,3,3,0,0 
Data.l 0,0,0,3,1,1,2,2,4,1,1,1,3,0,3,1,1,3,0,0 
Data.l 0,0,0,3,1,4,2,2,1,4,1,1,3,0,3,1,1,3,0,0 
Data.l 0,0,0,3,3,3,1,4,3,3,3,3,3,0,3,3,3,3,0,0 
Data.l 0,0,0,0,0,3,1,1,3,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 7,6,52 

Level6: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,3,2,1,2,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,3,2,1,4,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,3,1,4,3,3,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,4,1,1,4,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,3,4,3,3,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,3,3,3,3,3,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 11,10,61 

Level7: 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,3,1,1,1,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,3,4,4,4,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,1,4,2,2,1,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,4,2,2,2,3,3,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,3,3,1,1,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 8,7,40 

Level8: 

Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,1,2,1,1,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,4,1,4,1,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,2,1,5,1,2,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,1,4,1,4,1,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,3,3,1,2,1,3,3,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,3,3,3,3,3,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 
Data.l 12,7,200 
EndDataSection 


EndDataSection 

Procedure Create_Sprites() 
  
  ; ######################################### 
  ; ### Create all needed Grafix ### 
  ; ######################################### 
  ;###### Bodenplatten 
  CreateSprite(1,32, 32,0) 
  StartDrawing(SpriteOutput(1)): Box(0, 0, 32, 32 , RGB(70,0,0)) 
  For t=0 To 20 : Y1= Random(31) : Y2= Random(6)+1 : C1= Random(40) 
  Box(0, Y1, 32, Y2 , RGB(50+C1,0,0)) : Next t : Base=0 
  For i=0 To 1 
  For t=0 To 2 
  iX=(t*16) : lX=(i*16) 
  LineXY(Base+0+iX, 0+lX, Base+13+iX, 0+lX , RGB(150,60,60)) : LineXY(Base+0+iX, 0+lX, Base+0+iX, 13+LX , RGB(150,60,60)) 
  LineXY(Base+0+iX, 13+lX, Base+13+iX, 13+lX , RGB(8,0,0)) : LineXY(Base+13+iX, 13+lX, Base+13+iX, 0+lX , RGB(8,0,0)) 
  Next t : Base-6 : Next i : StopDrawing() 
  
  
  ;###### Wände 
  CreateSprite(3,32, 64,0) 
  StartDrawing(SpriteOutput(3)): Box(0, 32, 32, 40 , RGB(70,70,70)) : Box(0, 16, 32, 16 , RGB(170,170,170)) 
  For t=0 To 20 : Y1= 32+ Random(31) : Y2= Random(6)+1 : C1= Random(40) 
  Box(0, Y1, 32, Y2 , RGB(50+C1,50+C1,50+C1)) : Next t : Base=0 
  For i=0 To 4 : For t=0 To 3 
  iX=(t*16) : lX=(i*7) 
  LineXY(Base+0+iX, 32+lX, Base+13+iX, 32+lX , RGB(130,130,130)) : LineXY(Base+0+iX, 32+lX, Base+0+iX, 37+LX , RGB(130,130,130)) 
  LineXY(Base+0+iX, 37+lX, Base+13+iX, 37+lX , RGB(8,0,0)) : LineXY(Base+13+iX, 37+lX, Base+13+iX, 32+lX , RGB(8,8,8)) 
  Next t : Base-6 : Next i 
  FrontColor(RGB(200, 200, 200)) : LineXY(0, 16, 16, 22) : LineXY(16, 22, 32, 16) : LineXY(0, 16, 32, 16) :FillArea(16, 17,RGB(200, 200, 200)) 
  FrontColor(RGB(140, 140, 140)) : LineXY(0, 32, 16, 23) : LineXY(16, 23, 32, 32) : LineXY(0, 32, 32, 32) :FillArea(16, 25,RGB(140, 140, 140)) 
  FrontColor(RGB(120, 120, 120)) : LineXY(17,22, 32, 16) : LineXY(17, 23, 32, 32) : LineXY(32, 16, 32, 32):FillArea(25, 22,RGB(120, 120, 120)) 
  StopDrawing() 
  
  CreateSprite(2,64,64,#PB_Sprite_Texture) : StartDrawing(SpriteOutput(2)): Circle(16, 16, 16 , RGB(255,255,255)) : StopDrawing() 
  
  CreateSprite(4,32, 64,0) : StartDrawing(SpriteOutput(4)) : Box(0, 32, 32, 40 , RGB(170,140,0)) : Box(0, 14, 32, 18 , RGB(200,170,0)) 
  LineXY(0, 32, 32, 32,RGB(250, 200, 0)) : LineXY(0, 63, 16, 63,RGB(100, 50, 0)) : LineXY(32, 32, 32,64,RGB(100, 50, 0)) 
  For t= 0 To 4 : iX=(t*8) : LineXY(0+iX, 32, 0+iX, 64,RGB(250, 200, 0)) : LineXY((-1)+iX, 32, (-1)+iX, 64,RGB(100, 50, 0)) : Next t 
  For t= 0 To 8 : LineXY(0+t, 57, 23+t, 38,RGB(170,140,0)) : Next t : LineXY(0, 57, 23, 38,RGB(250, 200, 0)) : LineXY(8, 57, 32, 38,RGB(100, 50, 0)) : LineXY(8, 58, 32, 39,RGB(100, 50, 0) ) 
  Base=0 : For o = 0 To 1 : For t= 0 To 5 : LineXY(1, 36+t+Base, 31, 36+t+Base,RGB(170,140,0)) : Next t 
  LineXY(1, 36+Base, 31, 36+Base,RGB(250,200,0)) : LineXY(1, 41+Base, 31, 41+Base,RGB(100,50,0)) : LineXY(1, 42+Base, 31, 42+Base,RGB(120,70,0)) 
  Base+19 : Next o 
  ito=2 : For t= 0 To 3 
  iX=(t*ito) : LineXY(1, 16+iX, 31, 16+iX,RGB(150, 100, 0)) : LineXY (1,16+iX+1, 31, 16+iX+1 ,RGB(255, 225,100)) : ito+1 :Next t 
  LineXY(0, 14, 0, 32,RGB(255, 225,100)) : LineXY(31, 14, 31, 32,RGB(150, 100, 0)) 
  Base=0 : For o=0 To 10 : For t = 0 To 6 : LineXY(4+t+Base, 15, 4+t+Base, 31,RGB(200,170,0)) : Next t 
  LineXY(4+Base , 14, 4+Base, 31,RGB(255, 225,100)) : LineXY(9+Base, 14, 9+Base, 31,RGB(150, 100, 0)) : LineXY(10+Base, 14, 10+Base, 31,RGB(150, 100, 0)) 
  Base+18 : Next o : StopDrawing() 
  
  CreateSprite(10,64,64,#PB_Sprite_Texture) : UseBuffer(10) : ClearScreen(RGB(8,8,8)) : UseBuffer(-1) 
  CreateSprite3D(10, 10) : CreateSprite3D(2, 2) 
  
  ;###### Spielfigur 
  CreateSprite(8,32, 64,0) 
  StartDrawing(SpriteOutput(8)): FrontColor(RGB(0, 0, 255))
  Ellipse(16, 52, 16,9) : LineXY(16, 0, 0, 50) : LineXY(17, 0, 32, 50) : FillArea(16, 5,RGB(0, 0, 255)) 
  For t= 0 To 14 : tr=t*7 
  LineXY(16, 1, 16-t,58-(t*0.3) , RGB(100-tr,100-tr,255)) : LineXY(16, 1, 16+t,58-(t*0.3) , RGB(100-tr,100-tr,255)) 
  Next t 
  StopDrawing() 
  
  CreateSprite(50,256, 256,#PB_Sprite_Texture) : StartDrawing(SpriteOutput(50)) : For t = 0 To 128 : Circle(128, 128, 128-t, RGB(0,0,(t))) : Next t 
  StopDrawing() : CreateSprite3D(50,50) 
  CreateSprite(51,256, 256,#PB_Sprite_Texture) : StartDrawing(SpriteOutput(51)) : For t = 0 To 128 : Circle(128, 128, 128-t, RGB(t,0,0)) : Next t 
  StopDrawing() : CreateSprite3D(51,51) 
  CreateSprite(52,256, 256,#PB_Sprite_Texture) : StartDrawing(SpriteOutput(52)) : For t = 0 To 128 : Circle(128, 128, 128-t, RGB(0,(t),0)) : Next t 
  StopDrawing() : CreateSprite3D(52,52) 
  
EndProcedure 

Procedure Draw_Map(Mode.l) 
  For Y = 1 To 14 
    For X = 1 To 20 
      SPR = Map(X,Y) 
      
      If SPR=3 : siz=4 : Kolo.l = RGB(200,200,200) 
      ElseIf SPR=1 : siz=4 : Kolo.l = RGB(60,0,0) 
      ElseIf SPR=4 : siz=4 : Kolo.l = RGB(250,250,0) 
      ElseIf SPR=0 : siz=2 : Kolo.l = RGB(0,0,0) 
      ElseIf SPR=2 : siz=4 : Kolo.l = RGB(PoCol,PoCol,PoCol) : EndIf 
      If (X=FigurX) And (Y=FigurY) : siz=4 : Kolo.l = RGB(0,0,250) : EndIf 
      
      If SPR=4 And SMap(X,Y)=2 : Crate_on_finish+1 : EndIf 
      
      
      If Mode=1 
      StartDrawing(ScreenOutput()) 
      Box((X*4), (Y*4), siz, siz, Kolo.l) 
      StopDrawing() 
      EndIf 
      
      ShD=0 : If SPR=1 Or SPR=2 
      SH_Y = Y-1 : If SH_Y>0 : If Map(X,SH_Y)>2 : ShD=1 : EndIf 
      EndIf : EndIf 
      
      
      If SPR>2 : Panning=32 : Else : Panning=0 : EndIf 
      If SPR=1 Or SPR>2: DisplayTransparentSprite(SPR ,(X-1)*32,(Y*32)-Panning) : EndIf 
      If SPR = 2 : DisplayTransparentSprite(1,(X-1)*32,(Y*32)) : EndIf 
      
      If ShD= 1 
      Start3D() 
      DisplaySprite3D(10, (X-1)*32,(Y*32), 100) 
      Stop3D() 
      EndIf 
      
      If SPR = 2 
      Start3D() 
      DisplaySprite3D(2, (X-1)*32,(Y*32), PoCol) 
      Stop3D() 
      EndIf 
      
      If (X=FigurX) And (Y=FigurY) 
      DisplayTransparentSprite(8,(FigurX-1)*32,(FigurY*32)-32) 
      EndIf 
      
    Next X 
  Next Y 
EndProcedure 

Procedure Init() 
  Structure WAVE 
    wFormatTag.w 
    nChannels.w 
    nSamplesPerSec.l 
    nAvgBytesPerSec.l 
    nBlockAlign.w 
    wBitsPerSample.w 
    cbSize.w 
  EndStructure 
EndProcedure 

Procedure GenSFX(nr,Frequency, Duration,Mode) 
  SoundValue.b 
  w.f 
  
  #Mono = $0001 
  #SampleRate = 11025 
  #RiffId$ = "RIFF" 
  #WaveId$ = "WAVE" 
  #FmtId$ = "fmt " 
  #DataId$ = "data" 
  
  
  WaveFormatEx.WAVE 
  WaveFormatEx\wFormatTag = #WAVE_FORMAT_PCM 
  WaveFormatEx\nChannels = #Mono 
  WaveFormatEx\nSamplesPerSec = #SampleRate 
  WaveFormatEx\wBitsPerSample = $0008 
  WaveFormatEx\nBlockAlign = (WaveFormatEx\nChannels * WaveFormatEx\wBitsPerSample) / 8 
  WaveFormatEx\nAvgBytesPerSec = WaveFormatEx\nSamplesPerSec * WaveFormatEx\nBlockAlign 
  WaveFormatEx\cbSize = 0 
  
  DataCount = (Duration * #SampleRate)/1000 
  RiffCount = 4 + 4 + 4 + SizeOf(WAVE) + 4 + 4 + DataCount 
  
  start=AllocateMemory(RiffCount+100) 
  MS=start 
  
  PokeS(MS,#RiffId$):MS+4 
  PokeL(MS,RiffCount):MS+4 
  PokeS(MS,#WaveId$):MS+4 
  PokeS(MS,#FmtId$):MS+4 
  TempInt = SizeOf(WAVE) 
  PokeL(MS,TempInt):MS+4 
  
  PokeW(MS,WaveFormatEx\wFormatTag):MS+2 
  PokeW(MS,WaveFormatEx\nChannels):MS+2 
  PokeL(MS,WaveFormatEx\nSamplesPerSec):MS+4 
  PokeL(MS,WaveFormatEx\nAvgBytesPerSec):MS+4 
  PokeW(MS,WaveFormatEx\nBlockAlign):MS+2 
  PokeW(MS,WaveFormatEx\wBitsPerSample):MS+2 
  PokeW(MS,WaveFormatEx\cbSize):MS+2 
  
  PokeS(MS,#DataId$):MS+4 
  PokeL(MS,DataCount):MS+4 
  
  w = 2 * #PI * Frequency 
  For i = 0 To DataCount - 1 
    Select Mode 
      Case 0 
        SoundValue = 127 + 32 * Sin(i * w / #SampleRate)*1.55*35 
      Case 1 
        SoundValue = #SampleRate+Random(100) 
      Case 2 
        SoundValue = 127 + 127 * Sin(i * w / #SampleRate) 
    EndSelect 
    
    PokeB(MS,SoundValue):MS+1; 
  Next 
  
  CatchSound(nr,start) 
EndProcedure 

Procedure CloseSFX(nr) 
  StopSound(nr) 
  FreeSound(nr) 
  ;FreeMemory(nr)   ; disabled by Andre because the 'nr' parameter isn't a valid memory pointer.... PB will free memory automatically...
EndProcedure 




; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -