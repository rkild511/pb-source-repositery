;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : Gaga Punch
;* Author   : Cool Dji
;* Date     : Summer 2010
;* Purebasic Version : 4.50 32bit Windows
;* Notes    : Gaga Punch Create,Write and Delete 40 textures.bmp on your disk
;*
;*****************************************************************************
InitSprite() : InitKeyboard() : InitSprite3D() : InitSound() :InitEngine3D()
Global ing.f,ing2.f,ing3.f=0.1,ing4,ing5.f,k,sl5,w1,ing6,ing7,ing8=255,ing9
Global Posmouse,nuag,dnuag=1,scenario,activeboule,bx,by,alpha1,ang.f,zs.f
Global Rlfa.d,RlfaX.d,RlfaY.d,RlfaZ.d,n1,dn1,Smtb,Smt,dl,ing8a=-1
Global Dim Rxa.d(100),Dim Rya.d(100),Dim Rza.d(100),dang.f,pla.f,sm
Global Dim Bougix.i(36*5):Global Dim Bougiy.i(36*5):Global Dim Bougiz.i(36*5)
Global Dim coux.f(99),Dim couy.f(99),Dim cx.f(10000),Dim cy.f(10000)
Global Strig$ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789",Dim cz.f(10000)
Declare AffT(TextMenu01$,y.i,sz.i,sprite.i,rnd.i)
Global nbTLK=9:Global Dim TLK$(nbTLK), Dim TLKsc.i(nbtlk)
For j=1 To nbTLK:TLKsc(j)=600+100*j:Next:TLK$(1)="HELLO HELLO"
TLK$(2)="HERE IS THE":TLK$(3)="GAGA PUNCH DEMO":TLK$(4)="-------"
TLK$(5)="LOVE TO":TLK$(6)="ALL PUREBASIC":TLK$(7)="USERS"
TLK$(8)="ALL OVER":TLK$(9)="THE WORLD"
TLK1$="GAGA PUNCH BY COOL DJI FOR THE SUMMER 2010 PUREPUNCH DEMO CONTEST  "
Global Dim TK$(37):TK$(0)="HELLO TO":TK$(1)="AR S":TK$(2)="BEAUREGARD"
TK$(3)="CASE":TK$(4)="CEDERAVIC":TK$(5)="CHAOS":TK$(6)="CLS":TK$(7)="COMTOIS"
TK$(8)="DJES":TK$(9)="DOBRO":TK$(10)="ERIX14":TK$(11)="FLAITH":TK$(12)="FRED"
TK$(13)="FRENCHY PILOU":TK$(14)="G ROM":TK$(15)="GEBONET":TK$(16)="GILDEV"
TK$(17)="HUITBIT":TK$(18)="JACOBUS":TK$(19)="KCC":TK$(20)="KELEBRINDAE"
TK$(21)="KERNADEC":TK$(22)="L SOLDAT I":TK$(23)="LEPIAF31":TK$(24)="METALOS"
TK$(25)="MLD":TK$(26)="OCTAVIUS":TK$(27)="OLLIVIER":TK$(28)="POLUX"
TK$(29)="PROGI1984":TK$(30)="PSYCHOPATHE":TK$(31)="SPH":TK$(32)="TAZNORMAND"
TK$(33)="THYPHOON":TK$(34)="TMYKE":TK$(35)="VENOM":TK$(36)="WARKERING"
TK$(37)="AND MORE"
Procedure AffT(Text$,y.i,sz.i,sp.i,rnd.i)
sx=0:For i=1 To Len(Text$):For j=1 To Len(Strig$)
If Mid(Text$,i,1)=Mid(Strig$,j,1):a=sz+2
DisplaySprite3D(sp+j-1,sx+Random(rnd)+400-(Len(Text$)*a)/2,y+Random(rnd),200)
sx=sx+sz+2:j=Len(Strig$):EndIf :Next:Next
EndProcedure
OpenScreen(800, 600, 32, "Gaga Punch")
UseOGGSoundDecoder():LoadSound(0,"Gaga Punch.ogg")
LoadImage(0, "Gaga Punch.bmp"):AntialiasingMode(#PB_AntialiasingMode_x6)
For j=0 To 5:GrabImage(0,1,j*32,432,32,32)
CreateSprite(j,32,32,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j):Next
k=6:For i=0 To 3:For j=0 To 7:GrabImage(0,1,j*64,i*64,64,64)
CreateSprite(k,64,64,#PB_Sprite_Texture):TransparentSpriteColor(k, 0)
StartDrawing(SpriteOutput(k)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(k, k):k+1:Next:Next
j=38:GrabImage(0,1,0,272,400,85):CreateSprite(j,400,128,#PB_Sprite_Texture)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j)
j=39:GrabImage(0,1,0,272,255,155)
CreateSprite(j,255,155,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j)
For j =0+40 To 31+40:GrabImage(0,1,(j-40)*16,256,16,16)
CreateSprite(j,16,16,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j):Next
For j=100 To 101:GrabImage(0,1,0+(j-100)*256,272,256,160)
CreateSprite(j,256,160,#PB_Sprite_Texture):StartDrawing(SpriteOutput(j))
DrawImage(ImageID(1),0,0): StopDrawing():CreateSprite3D(j, j)
ZoomSprite3D(j,800,600):Next
For j=0 To 2
GrabImage(0,1,32+j*16,432,16,16):CreateSprite(110+j,16,16,#PB_Sprite_Texture)
StartDrawing(SpriteOutput(110+j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(110+j,110+j):Next
j=150:GrabImage(0,1,112,400,144,112)
CreateSprite(j,144,112,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j)
j=160:GrabImage(0,1,0,400,112,112)
CreateSprite(j,112,112,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j)
j=170:GrabImage(0,1,256,439,112,34)
CreateSprite(j,176,34,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),64,0): StopDrawing()
CreateSprite3D(j, j)
j=180:GrabImage(0,1,368,440,144,73)
CreateSprite(j,144,73,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j)
j=190:GrabImage(0,1,256,473,112,39)
CreateSprite(j,112,39,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j)):DrawImage(ImageID(1),0,0): StopDrawing()
CreateSprite3D(j, j)
For j =0 To 46:GrabImage(0,10+j,256+(j)*6,432,6,7)
CreateSprite(200+j,6,7,#PB_Sprite_Texture):TransparentSpriteColor(j, 0)
StartDrawing(SpriteOutput(j+200)):DrawImage(ImageID(10+j),0,0): StopDrawing()
CreateSprite3D(j+200, j+200):Next
Sprite3DQuality(1):k=1:curt=1:Restore Formes:Repeat:Read.i Bougix(curt)
Read.i Bougiy(curt):Bougiz(curt)=0:curt+1:Until curt > 36*3
For j= 1 To 36:Rxa(j)=Bougix(j)*3:Rya(j)=Bougiy(j)*3:Rza(j)= Bougiz(j)*3:Next
GrabImage(0,1,0,272,128,128):SaveImage(1,"toto.bmp")
GrabImage(0,1,128,272,128,128)
SaveImage(1,"toto1.bmp"):Add3DArchive("\", #PB_3DArchive_FileSystem)
CreateMaterial(1, LoadTexture(0,"toto.bmp")):DisableMaterialLighting(1, 1)
MaterialBlendingMode(1,#PB_Material_Add)
For j = 1 To 36:CreateParticleEmitter(j,50,50,50,0)
ParticleMaterial(j,MaterialID(1)):ParticleTimeToLive  (j, 1,1)
ParticleEmissionRate(j,20):ParticleSize(j, 200, 200)
ParticleColorRange(j, RGB(255,0,255),RGB(255,255,0))
ParticleEmitterLocate(j,Bougix(j)*15, 0, Bougiy(j)*15):
HideParticleEmitter(j,0):Next
CreateMaterial(2, LoadTexture(1,"toto1.bmp"))
MaterialBlendingMode(2,#PB_Material_Add):DisableMaterialLighting(2, 1)
DeleteFile("toto.bmp") :DeleteFile("toto1.bmp")      
For j=0 To 99:a.f=a.f+3.6:If a=360:a=0:EndIf
coux(j)=Sin(Radian(a.f)):couy(j)=Cos(Radian(a.f)):Next
CreateBillboardGroup(0,MaterialID(2),50,50):For i=0 To 10:For j=0 To 99
AddBillboard(j,0,coux(j)*(3000+i*10),coux(j)*(3000+i*10),couy(j)*(3000+i*10))
Next:Next:CreateBillboardGroup(2, MaterialID(1), 1000, 1000):For j=0 To 1
AddBillboard(j, 2,   coux(0)*3050,coux(0)*3050,couy(0)*3050):Next
CreateBillboardGroup(1, MaterialID(1), 30, 30):For j=0 To 5000
AddBillboard(j, 1,Random(10000)-5000,Random(10000)-5000,Random(10000)-5000)
Next:CreateCamera(0, 0, 0, 100, 100):ing5=0.01
CreateBillboardGroup(10,MaterialID(2),10,10):For j=0 To 10000:ang+0.01
If ang=360:ang=0:EndIf:cx(j)=j*2:cy(j)=Sin(ang)*500:cz(j)=j:Next
For j=0 To 1000:AddBillboard(j,10,cx(j*10),cy(j*10),cz(j*10)):Next
HideBillboardGroup(10, 1):For j=0 To 37:CreateImage(2,Len(TK$(j))*40,16)
StartDrawing(ImageOutput(2)):sx=0:For i=1 To Len(TK$(j)):For k=1 To Len(Strig$)
If Mid(TK$(j),i,1)=Mid(Strig$,k,1):DrawImage(ImageID(10+k-1),(i-1)*40,0,30,16)
k=Len(Strig$):EndIf :Next:Next:StopDrawing():SaveImage(2,"name"+Str(j)+".bmp")
CreateMaterial(j+10, LoadTexture(j+10,"name"+Str(j)+".bmp"))
MaterialBlendingMode(j+10,#PB_Material_Add):a=TextureWidth(j+10)/4
CreateBillboardGroup(j+11,MaterialID(j+10),a,TextureHeight(j+10)/4)
AddBillboard(j, j+11,cx(9500-(j*240)),cy(9500-(j*240)),cz(9500-(j*240)))
HideBillboardGroup(j+11, 1):DeleteFile("name"+Str(j)+".bmp"):Next:dl=10000
;-- BIG LOOP
Repeat: scenario+1: FlipBuffers()
ing2=ing2+ing3:If ing2>50:ing3=-0.3:EndIf:If ing2<0:ing4=ing4+1:ing3=0.3
If ing4=3:ing4=0:EndIf:EndIf
ing6+1:If ing6=1:ing7=ing7+1:If ing7=100:ing7=0:EndIf:ing6=0:ing=ing+ing5
If ing>98 : ing=0 : EndIf :EndIf:For j=0 To 1
BillboardLocate(j, 2, coux(ing7)*3050,coux(ing7)*3050,couy(ing7)*3050):Next
Select smtb : Case 0 To 58000,195000 To 270000
a=25+(1+Sin(ing/2))*7500*Sin(ing*0.4):b=4000+4000* Sin(ing)
c=5000+(1+Sin(ing/2))*1000*Cos(ing*0.4): d=0:e=0:f=0
For j=0 To 38:HideBillboardGroup(j+10,1):Next:  Case 58000 To 113000
a=25+(1+Sin(ing/2))*7500*Sin(ing*0.4):b=4000+4000* Sin(ing)
c=5000+(1+Sin(ing/2))*1000*Cos(ing*0.4):d=coux(ing7)*3050:e=coux(ing7)*3050
f=couy(ing7)*3050:Case 113000 To 195000:For j=0 To 38
HideBillboardGroup(j+10,0):Next:dl=dl-2:If dl<10:dl=10:EndIf
a=cx(dl):b=cy(dl)+20:c=cz(dl):d=cx(dl-5):e=cy(dl-5)+20:f=cz(dl-5)
EndSelect
Select smtb: Case 1 To 252000 ;Case 16500 To 253380
CameraLocate(0,a,b,c):CameraLookAt(0,d,e,f):RenderWorld():EndSelect
If Start3D():w1+1:If w1>2:w1=0:sl5+1:If sl5=32:sl5=0:EndIf:EndIf
ing9=ing9+1:If ing9=15:ing9=0:ing8=ing8+ing8a:If ing8<30:ing8=30:EndIf:EndIf
If (smtb<113000) Or (smtb>252000)
For i=0 To 10:For j=0 To 12:DisplaySprite3D(6+sl5,j*64,i*64,ing8):Next:Next
EndIf:If smtb>31000:For j = 1 To 36
ParticleEmitterLocate(j,Bougix(j+ing4*36)*ing2, 0, Bougiy(j+ing4*36)*ing2):Next
EndIf:Select smtb
  Case 1 To 1000,58000 To 59000,65000 To 66000,72000 To 73000,79000 To 80000
    For j=0 To 31:ZoomSprite3D(40+j,90,90):Next:AffT("GAGA PUNCH",250,75,40,2) 
  Case  85500 To 86500, 92500 To 93500, 99000 To 100000, 106000 To 107000
For j=0 To 31:ZoomSprite3D(40+j,90,90):Next:AffT("GAGA PUNCH",250,75,40,2) 
EndSelect
If (smtb>2500) And (smtb<16000):For j=0 To 31:ZoomSprite3D(40+j,44,44):Next
For j=1 To nbtlk:TLKsc(j)-2:If TLKsc(j)<-20:TLKsc(j)=600+100*nbTLK:EndIf
AffT(TLK$(j),TLKsc(j),44,40,2):Next:EndIf  
If (smtb>31000) And (smtb<113000):n1+dn1:If n1<50:dn1=5:EndIf:If n1>100:dn1=-5
EndIf:DisplaySprite3D(101,0,0,n1):EndIf:If (smtb>58000) And (smtb<113000)
ZoomSprite3D(150,432,336):DisplaySprite3D(150,184,264,Random(150)):EndIf
If scenario>1205:scenario=0:EndIf:If Sm=0:dang=dang+0.01:If dang>4:dang=4:
pla+0.1:If pla>6:Sm=1:PlaySound(0):Smt=ElapsedMilliseconds():EndIf:EndIf
RotateSprite3D(170,90+pla,0):
ang+dang:If ang=360:ang=0:EndIf:RotateSprite3D(160, ang, 0):Else  
Smtb=ElapsedMilliseconds()-Smt:If Smtb<252000:pla=((130-96)/253380)*Smtb
RotateSprite3D(170,96+pla,0):ang+4:If ang=360:ang=0:EndIf
RotateSprite3D(160,ang,0):EndIf:If Smtb>252000:pla-0.5:If pla<-10:pla=-10:EndIf
RotateSprite3D(170,96+pla,0):dang=dang-0.01:If dang<0:dang=0:EndIf:ang+dang
If ang=360:ang=0:EndIf:RotateSprite3D(160, ang, 0):EndIf:EndIf
DisplaySprite3D(160,10,488,200):DisplaySprite3D(170,40,410,200)
If smtb<2:DisplaySprite3D(180,654,525,200):DisplaySprite3D(190,344,530,200)
EndIf:AffT(Tlk1$,580,6,200,0):AffT("ESC TO QUIT",590,6,200,0)
Stop3D():EndIf:ExamineKeyboard():Until KeyboardPushed(#PB_Key_Escape):
End   
DataSection: Formes : Data.i -1,-57,-5,-66,-17,-77,-30,-80,-43,-82,-61,-81,-71
Data.i -73,-80,-60,-80,-43,-75,-27,-70,-14,-63,1,-50,15,-42,27,-32,38,-24,46
Data.i -15,56,-8,64,1,72,10,63,21,52,32,42,40,34,47,24,53,14,60,6,68,-6,75,-20
Data.i 81,-35,82,-52,77,-70,64,-80,47,-83,31,-81,17,-75,8,-67,1,-71,5,-60,12
Data.i -45,19,-31,32,-33,49,-34,64,-34,54,-24,45,-12,38,1,45,10,53,22,63,36,48
Data.i 34,33,33,18,31,14,43,6,57,1,72,-5,58,-11,42,-16,31,-33,33,-50,34,-61,34
Data.i -51,22,-41,10,-35,1,-42,-12,-53,-23,-60,-36,-43,-33,-28,-32,-17,-30,-12
Data.i -41,-5,-56,-6,-96,-12,-80,-32,-66,-58,66,-62,-47,-86,-50,-104,-44,-100
Data.i -30,-77,-25,-69,-7,-59,7,-56,26,-59,50,-66,72,-48,80,-25,84,6,93,13,76
Data.i 29,72,56,78,75,68,70,50,79,30,68,15,53,10,63,-6,74,-19,85,-51,61,-56,42
Data.i -62,21,-79,94,92,95,111,92,125,86,118,86,103 :EndDataSection
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 169
; FirstLine = 145
; Folding = -
; EnableXP
; Executable = Gaga Punch.exe