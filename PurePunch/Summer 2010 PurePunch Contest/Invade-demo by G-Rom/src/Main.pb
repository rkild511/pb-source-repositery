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
TransparentSpriteColor(basesprite,$FF00FF)
DisplayTransparentSprite(basesprite,0,0)
roadplan     = GrabSprite(#PB_Any,0,0,320,64) 
montainplanA = GrabSprite(#PB_Any,0,64,320,120) 
montainplanB = GrabSprite(#PB_Any,0,184,320,120) 
TreePlan     = GrabSprite(#PB_Any,320,0,192,240) 
Folliage     = GrabSprite(#PB_Any,0,304,320,64) 
TankSheetA   = GrabSprite(#PB_Any,0,368,128,64) 
TankSheetB   = GrabSprite(#PB_Any,128,368,128,64) 
TankSheetC   = GrabSprite(#PB_Any,256,368,128,64) 
JeepSheet    = GrabSprite(#PB_Any,320,432,64*3,64) 
SignA        = GrabSprite(#PB_Any,320,304,64,64) 
SignB        = GrabSprite(#PB_Any,384,304,128,128) 
Skull        = GrabSprite(#PB_Any,320,241,64,64,#PB_Sprite_Texture) 
Global Font  = GrabSprite(#PB_Any,0,432,320,16*3) 
TreePlan_offset= 0:general_offset=0:montainplanA_offset=0:montainplanB_offset=0
Structure clip : x1.i:y1.i : EndStructure
Global NewMap char.clip()
For i = 0 To 3:char(Str(i))\x1 = 256+(i*16) :char(Str(i))\y1 = 0:Next 
For i = 4 To 9:char(Str(i))\x1 = (i-4)*16:char(Str(i))\y1 = 16:Next 
idx=0:For i=65 To 71:char(Chr(i))\x1=208+(idx*16):char(Chr(i))\y1=16:idx+1:Next
idx=0:For i = 72 To 90:char(Chr(i))\x1=(idx*16):char(Chr(i))\y1=32:idx + 1:Next 
char(" ")\x1 = 0 : char(" ")\y1 = 0
char(".")\x1 =224: char(".")\y1 = 0
char("-")\x1 =208: char("-")\y1 = 0
char("'")\x1 =112: char("'")\y1 = 0
char(":")\x1 =6*16: char(":")\y1 = 16
Procedure text(x,y,t$)
For i = 1 To Len(t$):c$=Mid(t$,i,1):If c$=Chr(10):yy+18:xx=x-10:Else  
If y+yy>-16 And y+yy<SH:If FindMapElement(char(),c$)<>0:
ClipSprite(Font,char(c$)\x1,char(c$)\y1,16,16)
DisplayTransparentSprite(Font,x+xx,y+yy):EndIf:EndIf:xx+16:EndIf:Next 
EndProcedure
Skull3D = CreateSprite3D(#PB_Any,Skull)
Macro EOF:Chr(10):EndMacro

Global Text$ = "-DEMO POWERED BY-"+EOF:
Text$+          "    CPL.BATOR    "+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF:Text$+"PUREARMY INVASION"+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+"EN AOUT 2010"+EOF:Text$+"L'ARMEE DU"+EOF
Text$+"CAPORAL BATOR"+EOF:Text$+"ENVAHIT L'ETAT"+EOF;*
Text$+"DE L'EMPEREUR "+EOF:Text$+"KIM JONG FRED II"+EOF
Text$+EOF+EOF:Text$+"APRES DE MULTIPLES"+EOF
Text$+"AVERTISSEMENTS"+EOF:Text$+"L'EMPIRE DE FRED"+EOF
Text$+"CONTINUERAIT"+EOF:Text$+"A ENRICHIR"+EOF;*
Text$+"DU CODE PUREBASIC"+EOF:Text$+EOF+EOF
Text$+"LA SEULE SOLUTION"+EOF:Text$+"EST DONC "+EOF;*
Text$+"UNE INTERVENTION"+EOF:Text$+"MILITAIRE RAPIDE"+EOF+EOF+EOF+EOF+EOF
Text$+"LA BLITZKRIEG"+EOF:Text$+"RECOMMENCE..."+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+"IN AUGUST 2010"+EOF
Text$+"ARMY OF"+EOF
Text$+"CORPORAL BATOR"+EOF
Text$+"INVADE THE STATE"+EOF
Text$+"OF EMPEROR"+EOF
Text$+"KIM JONG FRED II"+EOF+EOF+EOF
Text$+"AFTER MULTIPLES"+EOF
Text$+"WARNINGS"+EOF
Text$+"FRED'S EMPIRE"+EOF
Text$+"WOULD CONTINUE"+EOF
Text$+"ENRICHMENT OF"+EOF
Text$+"PUREBASIC CODE"+EOF+EOF+EOF
Text$+"THE LAST SOLUTION"+EOF
Text$+"IS A FAST MILITARY"+EOF
Text$+"STRIKE"+EOF+EOF+EOF+EOF+EOF+EOF
text$+"THE BLITZKRIEG"+EOF
Text$+"BEGINS"+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF:Text$+"SUMMER 2010"+EOF
Text$+"PUREPUNCH CONTEST"+EOF:Text$+"LAUNCHED BY DJES"+EOF 
Text$+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+"CODE BY : CPL.BATOR"+EOF:Text$+".....PUREBASIC 4.50"+EOF+EOF+EOF
Text$+"GFX  BY : CPL.BATOR"+EOF:Text$+"...........THE GIMP"+EOF+EOF+EOF 
Text$+"SFX BY  : CPL.BATOR"+EOF:Text$+"...........AUDACITY"+EOF
Text$+".....FINDSOUNDS.COM"+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF+EOF
Text$+EOF+EOF+EOF:Text$+"THANKS TO :"+EOF+EOF
Text$+"-THE ASS OF MY WIFE"+EOF:Text$+"-MY BRAIN"+EOF
Text$+"-FRED.L"+EOF:Text$+"-DJES"+EOF:Text$+"-HUIBIT"+EOF
Text$+"-CANONICAL"+EOF:
Text$+"-COMMUNITY OF PB"+EOF:Text$+EOF+EOF+EOF+EOF
Text$+"ESCAPE TO QUIT"+EOF:
LoadSound(0,"Counterattack.ogg"):PlaySound(0,#PB_Sound_Loop)
FPS_LIMIT = 40:TIMETOSCROOLTEXT = ElapsedMilliseconds() + 5000
SCROOLTEXTSTOP   = (107*16)+10:TIME=ElapsedMilliseconds()+(1000*119)
While #True 
ExamineKeyboard()
If KeyboardPushed(#PB_Key_Escape) : End : EndIf 

If (ElapsedMilliseconds() > CheckTime + 1000 / FPS_LIMIT)
CheckTime = ElapsedMilliseconds()
ClearScreen(RGB(64,128,255))
If st < ElapsedMilliseconds()
TreePlan_offset+ 16:TreePlan_offset%1600
general_offset + 4:general_offset % 320
montainplanA_offset + 2 : montainplanA_offset%320
montainplanB_offset + 1 : montainplanB_offset%320
signa_offset + 4 : signa_offset%800
signb_offset + 4 : signb_offset%1600
st = ElapsedMilliseconds() + 20
EndIf 
For i = -1 To 1
DisplayTransparentSprite(montainplanB,(i*320)-montainplanB_offset,50)
Next 
For i = -1 To 1
DisplayTransparentSprite(montainplanA,(i*320)-montainplanA_offset,70)
Next 
DisplayTransparentSprite(Signa,400-signa_offset,135)
DisplayTransparentSprite(Signb,800-signb_offset,60)
For i = -1 To 1
DisplayTransparentSprite(roadplan   ,(i*320)-general_offset,240-64)
Next 
If AT<ElapsedMilliseconds()
AT = ElapsedMilliseconds() + 50
Anim+1
Anim%2
AnimJ+1
AnimJ%3
EndIf 
ClipSprite(TankSheetA,Anim*64,0,64,64)
ClipSprite(TankSheetB,Anim*64,0,64,64)
ClipSprite(TankSheetC,Anim*64,0,64,64)
ClipSprite(JeepSheet,AnimJ*64,0,64,64)
el = ElapsedMilliseconds()
For i = -1 To 1
tankdec.f + 0.1:If tankdec=>320:tankdec=0:EndIf 
DisplayTransparentSprite(TankSheetA,tankdec+(i*320),155-2*Cos(el/350))
DisplayTransparentSprite(TankSheetC,tankdec+(i*320)+74,155-2*Cos(el/350))
DisplayTransparentSprite(TankSheetB,tankdec+(i*320)+148,155-2*Cos(el/350))
DisplayTransparentSprite(JeepSheet,tankdec+(i*320)+232,140-2*Cos(el/350))
Next 
DisplayTransparentSprite(TreePlan,400-TreePlan_offset,0)
DisplayTransparentSprite(Folliage,400-TreePlan_offset-80,0)
If TIMETOSCROOLTEXT < ElapsedMilliseconds()
TextOffSet.f + 1
If TextOffSet = SCROOLTEXTSTOP
TIMETOSCROOLTEXT = ElapsedMilliseconds() + 2500
SCROOLTEXTSTOP = $FFFFFFFF
EndIf   
EndIf 
If TIME<ElapsedMilliseconds()
TIME=ElapsedMilliseconds()+(1000*119)
TIMETOSCROOLTEXT = ElapsedMilliseconds() + 5000
SCROOLTEXTSTOP   = (107*16)+10
TextOffSet       = 0
EndIf 
text(10,-TextOffSet+10,Text$)
Start3D()
ZoomSprite3D(Skull3D,64,64)
DisplaySprite3D(Skull3D,160-32,120-32-TextOffSet,240)
Stop3D()
Screen = GrabSprite(#PB_Any,0,0,320,240,#PB_Sprite_Texture)
Screen3D = CreateSprite3D(#PB_Any,Screen)
TransformSprite3D(Screen3D,0,0,SW,0,SW,SH,0,SH)
Start3D()
CompilerIf #PB_Compiler_OS = #PB_OS_Linux
If Ratio = 1.6
DisplaySprite3D(Screen3D,0,SH-(SH/4)+22)
Else 
DisplaySprite3D(Screen3D,0,SH-(SW/4)+16)
EndIf 
CompilerEndIf

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
DisplaySprite3D(Screen3D,0,0)
CompilerEndIf
Stop3D()
FreeSprite(Screen)
FreeSprite3D(Screen3D)
FlipBuffers()
Else
Delay(1)
EndIf 
Wend 