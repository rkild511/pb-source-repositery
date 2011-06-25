;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : INVASION
;* Author   : CPL.BATOR
;* Date     : 15 JULY 2010
;* Purebasic Version : 4.50
;* Notes    : RUN ON LINUX UBUNTU 10.04 AND WINDOWS XP SP3 ( MAYBE OTHER 
;* WINDOWS ) ESCAPE TO QUIT
;*****************************************************************************
CompilerIf #PB_Compiler_OS = #PB_OS_Linux:CompilerIf Subsystem("opengl")
CompilerElse:CompilerError "NEED SUBSYSTEM : opengl"
CompilerEndIf:CompilerEndIf
CompilerIf #PB_Compiler_OS = #PB_OS_Windows:CompilerIf Subsystem("OpenGL")
CompilerError "DOES NOT WORK WITH OPENGL !":CompilerEndIf:CompilerEndIf
InitSprite() : InitKeyboard() : ExamineDesktops() : InitSprite3D() :InitSound()
Global SW = DesktopWidth(0):Global SH = DesktopHeight(0):Ratio.f = SW/SH
UseOGGSoundDecoder():OpenScreen(SW,SH,DesktopDepth(0),""):UsePNGImageDecoder()
basesprite = LoadSprite(#PB_Any,"clipme.png")
Macro gb:GrabSprite:EndMacro  
TransparentSpriteColor(basesprite,$FF00FF)
DisplayTransparentSprite(basesprite,0,0)
roadplan= gb(#PB_Any,0,0,320,64):montainplanA = gb(#PB_Any,0,64,320,120) 
montainplanB=gb(#PB_Any,0,184,320,120):TreePlan=gb(#PB_Any,320,0,192,240) 
Folliage=gb(#PB_Any,0,304,320,64):TankSheetA=gb(#PB_Any,0,368,128,64) 
TankSheetB=gb(#PB_Any,128,368,128,64):TankSheetC=gb(#PB_Any,256,368,128,64) 
JeepWrecked=gb(#PB_Any,320,448,64,64):TankWreckedA=gb(#PB_Any,384,448,64,64) 
TankWreckedB = gb(#PB_Any,448,512-64,64,64) 
BurnSheet    = gb(#PB_Any,0,512-32,128,32) 
smoke        = gb(#PB_Any,128,512-32,32,32,#PB_Sprite_Texture)
smoke3d      = CreateSprite3D(#PB_Any,smoke)
SignA        = gb(#PB_Any,320,304,64,64) 
SignB        = gb(#PB_Any,384,304,128,128) 
Skull        = gb(#PB_Any,320,241,64,64,#PB_Sprite_Texture)
Choper       = gb(#PB_Any,160,432,159,80)
Pale         = gb(#PB_Any,388,241,79,8,#PB_Sprite_Texture)
Pale3D       = CreateSprite3D(#PB_Any,Pale)
PlaneSpr     = gb(#PB_Any,400,257,65,27)
Global Font  = gb(#PB_Any,0,432,320,16*3) 
TreePlan_offset= 0:general_offset=0:montainplanA_offset=0:montainplanB_offset=0
Structure clip : x1.i:y1.i : EndStructure
Structure pos : x1.f:y1.f : EndStructure:Global NewList plane.pos()
timetoplane = ElapsedMilliseconds() + Random(1500)
Structure debris:position.pos:spriteid.i:isburn.a:EndStructure
Structure burn:position.pos:timetosmoke.i:EndStructure
Structure smoke:position.pos:alpha.f:angle.i:EndStructure
NewList smoke.smoke():NewList burn.burn():Dim ldebris.debris(10):For i= 0 To 10
ldebris(i)\position\x1 = -Random(1280)+Random(640)
ldebris(i)\position\y1 = 160 + Random(10)
ldebris(i)\isburn      = Random(1):If ldebris(i)\isburn
AddElement(burn()):burn()\position\x1 = ldebris(i)\position\x1 + 16
burn()\position\y1 = ldebris(i)\position\y1 + 32:EndIf:Select Random(2)
Case 0: ldebris(i)\spriteid = TankWreckedA
Case 1: ldebris(i)\spriteid = TankWreckedB
Case 2: ldebris(i)\spriteid = JeepWrecked
EndSelect: Next : Global NewMap char.clip()
For i = 0 To 3:char(Str(i))\x1 = 128+(i*8) :char(Str(i))\y1 = 0:Next 
For i = 4 To 9:char(Str(i))\x1 = (i-4)*8:char(Str(i))\y1 = 8:Next 
idx=0:For i=65 To 71:char(Chr(i))\x1=104+(idx*8):char(Chr(i))\y1=8:idx+1:Next
idx=0:For i = 72 To 90:char(Chr(i))\x1=(idx*8):char(Chr(i))\y1=16:idx + 1:Next 
char(" ")\x1 = 0 : char(" ")\y1=0:
char(".")\x1 =224/2: char(".")\y1= 0:char("-")\x1 =208/2: char("-")\y1= 0
char("'")\x1 =112/2: char("'")\y1=0:char(":")\x1 =(6*16)/2: char(":")\y1=8
char(",")\x1 =128-16:char(",")\y1=0:char(")")\x1 =10*8:char(")")\y1=8
Procedure text(x.i,y.i,t$):For i = 1 To Len(t$):
c$=Mid(t$,i,1):If c$=Chr(10):yy+9:xx=x-5:Else:If y+yy>-8 And y+yy<SH:
If FindMapElement(char(),c$)<>0:ClipSprite(Font,char(c$)\x1,char(c$)\y1,8,8)
DisplayTransparentSprite(Font,x+xx,y+yy):EndIf:EndIf:xx+8:EndIf:Next 
EndProcedure:Skull3D = CreateSprite3D(#PB_Any,Skull):Macro EOF:Chr(10):EndMacro
Global Text$ 
Global Text$
Text$+ "-    DEMO POWERED BY    -"+EOF:
Text$+ "       CPL.BATOR    "+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+"  PUREARMY INVASION II"+EOF
Text$+"    -COUNTER STRIKE-"
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+"EN AOUT 2010,L'ARMEE DU CAPORAL BATOR"+EOF
Text$+"A TENTE D'ENVAHIR LE PAYS DE "+EOF;*
Text$+"L'EMPEREUR KIM JONG FRED II"+EOF
Text$+"AFIN QU'IL STOPPE SON ENRICHISSEMENT"+EOF;*
Text$+"DE CODE PUREBASIC."+EOF+EOF+EOF;*
Text$+"CE FUT UN ECHEC TOTAL..."+EOF
Text$+"L'ARMEE DU DICTATEUR PROCEDE DONC"+EOF
Text$+"A UNE CONTRE-ATTAQUE..."+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+"IN AUGUST 2010,CORPORAL BATOR'S ARMY"+EOF
Text$+"TRY TO INVADE THE COUNTRY OF THE"+EOF
Text$+"EMPEROR KIM JONG FRED II"+EOF
Text$+"IN ORDER TO STOP IT'S ENRICHMENT"+EOF
Text$+"OF PUREBASIC CODE."+EOF+EOF+EOF
Text$+"IT WAS A TOTAL FAILURE ..."+EOF
Text$+"DICTATOR'S ARMY WAS RESPOND BY"+EOF
Text$+"AN COUNTER STRIKE..."+EOF
Text$+EOF+EOF+EOF+EOF:Text$+"SUMMER 2010"+EOF
Text$+"PUREPUNCH CONTEST"+EOF:Text$+"LAUNCHED BY DJES"+EOF 
Text$+EOF+EOF+EOF+EOF
Text$+"CODE BY : CPL.BATOR"+EOF:Text$+".....PUREBASIC 4.50"+EOF+EOF+EOF
Text$+"GFX  BY : CPL.BATOR"+EOF:Text$+"...........THE GIMP"+EOF+EOF+EOF 
Text$+"SFX BY  : CPL.BATOR"+EOF:Text$+"...........AUDACITY"+EOF
Text$+".....FINDSOUNDS.COM"+EOF+EOF+EOF+EOF+EOF
Text$+EOF+EOF+EOF:Text$+"THANKS TO :"+EOF+EOF
Text$+"-MY DISHWASHER"+EOF:Text$+"-MEKKISOFT,FOR WONDERFULL SOFTWARE :)"+EOF
Text$+"-FRED.L"+EOF:Text$+"-DJES"+EOF
Text$+"-CANONICAL"+EOF:
Text$+"-COMMUNITY OF PB"+EOF
Text$+"-HUITBIT OF FRENCH FORUM"+EOF:Text$+EOF+EOF
Text$+"PRESS ESCAPE TO QUIT,OR DEMO WILL LOOP."+EOF:
Macro dtsp:DisplayTransparentSprite:EndMacro
LoadSound(0,"Counterattack.ogg"):PlaySound(0,#PB_Sound_Loop)
FPS_LIMIT = 40:TIMETOSCROOLTEXT = ElapsedMilliseconds() + 5000
TIME=ElapsedMilliseconds()+(1000*119)
While #True 
ExamineKeyboard()
If KeyboardPushed(#PB_Key_Escape) : End : EndIf 
If (ElapsedMilliseconds() > CheckTime + 1000 / FPS_LIMIT)
CheckTime = ElapsedMilliseconds()
ClearScreen(RGB(255/2, 128/2, 64/2))
If st < ElapsedMilliseconds()
TreePlan_offset+ 16:TreePlan_offset%1600
general_offset + 4:general_offset % 320
For i = 0 To 10:ldebris(i)\position\x1+4
If ldebris(i)\position\x1>320:ldebris(i)\position\x1 = -Random(1280)-64
If ldebris(i)\isburn:AddElement(burn())
burn()\position\x1 = ldebris(i)\position\x1+16 
burn()\position\y1 = ldebris(i)\position\y1+32 
EndIf 
EndIf 
Next:ForEach burn():burn()\position\x1+4
If burn()\position\x1>320:DeleteElement(burn(),1):EndIf:Next 
ForEach smoke()
Smoke()\position\x1 + 1 * Cos(smoke()\angle*#PI/180) 
Smoke()\position\y1 + 1 * Sin(smoke()\angle*#PI/180)
Smoke()\position\x1 + 4
If Smoke()\position\x1 > 320:DeleteElement(smoke(),1):EndIf:Next 
montainplanA_offset + 2 : montainplanA_offset%320
montainplanB_offset + 1 : montainplanB_offset%320
signa_offset + 4 : signa_offset%800:signb_offset + 4 : signb_offset%1600
st = ElapsedMilliseconds() + 25:EndIf:For i = -1 To 1
DisplayTransparentSprite(montainplanB,(i*320)+montainplanB_offset,50)
Next:If timetoplane<ElapsedMilliseconds():
timetoplane=ElapsedMilliseconds() + Random(4500):AddElement(Plane())
Plane()\x1 = 350:plane()\y1 = Random(50):EndIf 
ForEach plane():  DisplayTransparentSprite(PlaneSpr,Plane()\x1,Plane()\y1)
Plane()\x1 - 8:If Plane()\x1 < - 320:DeleteElement(plane()):EndIf:Next 
For i = -1 To 1
DisplayTransparentSprite(montainplanA,(i*320)+montainplanA_offset,70):Next 
DisplayTransparentSprite(Signa,-400+signa_offset,135)
DisplayTransparentSprite(Signb,-800+signb_offset,60)
For i = -1 To 1
DisplayTransparentSprite(roadplan   ,(i*320)+general_offset,240-64)
Next:If AT<ElapsedMilliseconds():AT = ElapsedMilliseconds() + 50:Anim+1:Anim%2
BurnAnim+1:BurnAnim%4:EndIf:ClipSprite(TankSheetA,Anim*64,0,64,64)
ClipSprite(TankSheetB,Anim*64,0,64,64):ClipSprite(TankSheetC,Anim*64,0,64,64)
ClipSprite(BurnSheet  ,BurnAnim*32,0,32,32):el = ElapsedMilliseconds()
For i = -1 To 1:tankdec.f - 0.5:If Int(tankdec)<=-450:tankdec=0:EndIf
DisplayTransparentSprite(TankSheetA,tankdec+(i*450),150-2*Cos(el/350))
DisplayTransparentSprite(TankSheetC,tankdec+(i*450)+150,150-2*Cos(el/350))
DisplayTransparentSprite(TankSheetB,tankdec+(i*450)+300,150-2*Cos(el/350))
DisplayTransparentSprite(Choper,tankdec+(i*450)+300,30-4*Cos(el/150))
Start3D()
If Anim = 1  
DisplaySprite3D(Pale3D,(tankdec+(i*450)+300)+68     ,(30-4*Cos(el/150)+5))
Else 
  DisplaySprite3D(Pale3D,(tankdec+(i*450)+300)+72-79     ,(30-4*Cos(el/150)+5))
EndIf
Stop3D()
Next:For i = 0 To 10:
dtsp(ldebris(i)\spriteid,ldebris(i)\position\x1,ldebris(i)\position\y1)
Next:Start3D():ForEach smoke():smoke()\alpha-2:
If smoke()\alpha<0:smoke()\alpha=0:EndIf
DisplaySprite3D(Smoke3D,Smoke()\position\x1,Smoke()\position\y1,smoke()\alpha)
Next:Stop3D():ForEach burn()
DisplayTransparentSprite(BurnSheet,burn()\position\x1,burn()\position\y1)
el=ElapsedMilliseconds():If burn()\timetosmoke < el
burn()\timetosmoke=el+100:AddElement(smoke()):smoke()\alpha=255
smoke()\position\x1 = burn()\position\x1
smoke()\position\y1 = burn()\position\y1
smoke()\angle = -90 - Random(20)+Random(20)
EndIf:Next:DisplayTransparentSprite(TreePlan,-400+TreePlan_offset,0)
DisplayTransparentSprite(Folliage,-400+TreePlan_offset-80,0)
If TIMETOSCROOLTEXT < ElapsedMilliseconds():If tsp<ElapsedMilliseconds()
tsp=ElapsedMilliseconds()+75:TextOffSet.f + 1:EndIf:EndIf 
If TIME<ElapsedMilliseconds():TIME=ElapsedMilliseconds()+(1000*119)
TIMETOSCROOLTEXT = ElapsedMilliseconds() + 5000
SCROOLTEXTSTOP   = (107*16)+10:TextOffSet       = 0:EndIf 
text(5,-TextOffSet+5,Text$):Start3D():ZoomSprite3D(Skull3D,64,64)
DisplaySprite3D(Skull3D,105-32,120-82-TextOffSet,240)
Stop3D()
Screen = GrabSprite(#PB_Any,0,0,320,240,#PB_Sprite_Texture)
Screen3D = CreateSprite3D(#PB_Any,Screen):
TransformSprite3D(Screen3D,0,0,SW,0,SW,SH,0,SH):
Start3D():CompilerIf #PB_Compiler_OS = #PB_OS_Linux:
If Ratio = 1.6:DisplaySprite3D(Screen3D,0,SH-(SH/4)+22):
Else:DisplaySprite3D(Screen3D,0,SH-(SW/4)+16)
EndIf:CompilerEndIf:CompilerIf #PB_Compiler_OS = #PB_OS_Windows
DisplaySprite3D(Screen3D,0,0):CompilerEndIf:Stop3D():FreeSprite(Screen)
FreeSprite3D(Screen3D):FlipBuffers():Else:Delay(1):EndIf:Wend