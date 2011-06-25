;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : Military marshes
;* Author   : Cpl.Bator
;* Date     : 18/07/2010
;* Purebasic Version : 4.50
;* Notes    : Run on Linux ubuntu 10.04 and windows XP ( maybe other windows)
;*
;*****************************************************************************
CompilerIf #PB_Compiler_OS = #PB_OS_Linux:CompilerIf Subsystem("opengl")
CompilerElse:CompilerError "NEED SUBSYSTEM : opengl"
CompilerEndIf:CompilerEndIf
InitSprite() : InitKeyboard() : InitSprite3D():InitSound():ExamineDesktops()
Macro Dts:DisplayTransparentSprite:EndMacro
Global DW=DesktopWidth(0):Global DH=DesktopHeight(0):Global DD=DesktopDepth(0)
OpenScreen(DW,DH,DD,"",#PB_Screen_SmartSynchronization):UsePNGImageDecoder()
UseOGGSoundDecoder():Music = LoadSound(#PB_Any,"./Medias/music.ogg")
SpriteBase = LoadSprite(#PB_Any,"./Medias/clipme.png"):
TransparentSpriteColor(SpriteBase,$FF00FF)
DisplayTransparentSprite(SpriteBase,0,0) 
Plan_City     = GrabSprite(#PB_Any,0,344,320,166)
Road_City     = GrabSprite(#PB_Any,320,128,192,384)
Soldier_Sheet = GrabSprite(#PB_Any,0,0,320,352)
Global Font   = GrabSprite(#PB_Any,320,20,192,64) 
Dim cotillion_spr(8):Dim cotillion_spr3D(8):For i = 0 To 8
cotillion_spr(i)=GrabSprite(#PB_Any,320+(i*20),0,20,20,#PB_Sprite_Texture)
cotillion_spr3D(i)  = CreateSprite3D(#PB_Any,cotillion_spr(i)):Next 
Structure cotillion:id.i:angle.f:x.f:y.f:EndStructure
Global NewList cotillion.cotillion():For i = 0 To 500:AddElement(cotillion())
cotillion()\id    = cotillion_spr3D(Random(8)):cotillion()\angle = Random(360)
cotillion()\x     = Random(640*2):cotillion()\y     = Random(480):Next 
Global Virtual_Screen_X = 640:Global Virtual_Screen_Y = 480
FPS_LIMIT = 30:PlaySound(Music,#PB_Sound_Loop)
Structure clip : x1.i:y1.i : EndStructure:Global NewMap char.clip()
For i = 0 To 9:char(Str(i))\x1 = 32+(i*16) :char(Str(i))\y1 = 32:Next 
idx=0:For i=65 To 76:char(Chr(i))\x1=idx*16:char(Chr(i))\y1=0:idx+1:Next
idx=0:For i = 77 To 88:char(Chr(i))\x1=(idx*16):char(Chr(i))\y1=16:idx + 1:Next
idx=0:For i = 89 To 90:char(Chr(i))\x1=(idx*16):char(Chr(i))\y1=32:idx + 1:Next
char(" ")\x1 =64+16 : char(" ")\y1=48:char(".")\x1 =48: char(".")\y1= 48:
char("%")\x1 =0: char("%")\y1= 48:char("$")\x1 =16: char("$")\y1= 48:
char("*")\x1 =32: char("*")\y1= 48:char(":")\x1 =64: char(":")\y1= 48:
Procedure text(x.i,y.i,t$):For i = 1 To Len(t$):c$=Mid(t$,i,1)
If y+yy>-16 And y+yy<DH:If FindMapElement(char(),c$)<>0
ClipSprite(Font,char(c$)\x1,char(c$)\y1,16,16):
DisplayTransparentSprite(Font,x+xx,y+yy):EndIf:EndIf:xx+16:Next:EndProcedure
Text$ = "PUREBASIC 4.50 PUREPUNCH * CONTEST SUMMER 2010 LAUNCHED BY DJES $ "
Text$ + "THIS DEMO WAS CODED BY CPL.BATOR   " 
Text$ + "ANIMATION WAS DRAWED BY CPL.BATOR  "
Text$ + "THANKS FOR ALL USERS OF %PUREBASIC%  "
Text$ + "PERSONAL MESSAGE FOR KWAI CHANG KAINE : REVIENS. ON A LES MEMES A LA MAISON %$"
While #True:ExamineKeyboard():If KeyboardPushed(#PB_Key_Escape) : Break : EndIf 
If (ElapsedMilliseconds() > CheckTime + 1000 / FPS_LIMIT):
CheckTime = ElapsedMilliseconds():ClearScreen(RGB(192,192,255)):
If TimeToScroll < ElapsedMilliseconds():TimeToScroll=ElapsedMilliseconds() + 2
Plan_City_OffSet.f + 0.25:If Plan_City_OffSet=>320:Plan_City_OffSet=0:EndIf
Road_City_Offset.f + 2:If Road_City_Offset=>192 : Road_City_Offset = 0 : EndIf 
ForEach cotillion():cotillion()\x - 2:Next:EndIf:For i = -2 To 2
DisplayTransparentSprite(Plan_City,(i*320)-Plan_City_OffSet,-60):
Next:For i=-4 To 4
DisplayTransparentSprite(Road_City,(i*192)-Road_City_Offset,480-384)
Next :If AnimTimer < ElapsedMilliseconds():AnimTimer = ElapsedMilliseconds()+75
AnimX+1:If AnimX>3:AnimX=0:AnimY+1:EndIf:If AnimY>1:AnimX=0:AnimY=0:EndIf:EndIf
ClipSprite(Soldier_Sheet,80*AnimX,176*AnimY,80,176):dec+1:dec%450:
For dd=-1 To 1:For j = 0 To 3:For i = 0 To 3:
  Dts(Soldier_Sheet,(10+((90*i)+(j*-15))+(dd*450) )+dec,220+(j*30)):Next:Next
Next:Start3D():ForEach cotillion():
RotateSprite3D(cotillion()\id,cotillion()\angle,0):
DisplaySprite3D(cotillion()\id,cotillion()\x,cotillion()\y)
cotillion()\y + 1:cotillion()\angle + 10:If cotillion()\y > 480
cotillion()\x = Random(640+640):cotillion()\y = -20 :EndIf 
Next:Stop3D():tt+6:text(10-tt,10,Text$):If tt>((Len(Text$)*16)):tt=-640:EndIf
ScreenGrab = GrabSprite(#PB_Any,0,0,640,480,#PB_Sprite_Texture)
ScreenGrab3D = CreateSprite3D(#PB_Any,ScreenGrab)
Start3D():ZoomSprite3D(ScreenGrab3D,DW,DH):DisplaySprite3D(ScreenGrab3D,0,0)
Stop3D():FreeSprite(ScreenGrab):FreeSprite3D(ScreenGrab3D):Else:Delay(1):EndIf 

If KeyboardPushed(#PB_Key_F1)
  s = GrabSprite(#PB_Any,0,0,640,480)
  SaveSprite(s,"Screenshoot.png",#PB_ImagePlugin_PNG)
  End 
EndIf 

FlipBuffers()


:Wend:CloseScreen():End 




