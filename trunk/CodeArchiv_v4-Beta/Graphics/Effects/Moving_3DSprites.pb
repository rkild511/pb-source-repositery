; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1849
; Author: kutta (updated to PB4 by ste123)
; Date: 28. July 2003
; OS: Windows
; Demo: Yes

Declare punkteberechnen()
Declare sortieren()
Declare linien ()
Declare texture ()

Global anzahl.l,spr.l,spr3d.l
anzahl=20

InitSprite()
InitSprite3D()
InitKeyboard()
OpenScreen(1024,768,32,"flat")
LoadFont(0,"comic sans ms",5)

;würfel objekt erschaffen
Structure wuerfel
  xpos.f[8]
  ypos.f[8]
  zpos.f[8]
  temxpos.f[8]
  temypos.f[8]
  temzpos.f[8]
  x2d.f[8]
  y2d.f[8]
  verx.f
  very.f
  verz.f
  con1.w[7]
  con2.w[7]
  con3.w[7]
  con4.w[7]
  breite.f
  laenge.f
  hoehe.f
  startposx.f
  startposy.f
  winkelx.f
  winkely.f
  winkelz.f
  zeigerx.f
  zeigery.f
  zeigerz.f
  speedx.f
  speedy.f
  speedz.f
  index.f
EndStructure

;wuerfel eckpunkte in die structure legen
Global Dim typ.wuerfel(anzahl)
For t=1 To anzahl
  typ(t)\index=t
  typ(t)\breite=80
  typ(t)\hoehe=80
  typ(t)\laenge=80
  typ(t)\xpos[0]=0
  typ(t)\ypos[0]=0
  typ(t)\zpos[0]=0
  typ(t)\xpos[1]=typ(t)\breite
  typ(t)\ypos[1]=0
  typ(t)\zpos[1]=0
  typ(t)\xpos[2]=typ(t)\breite
  typ(t)\ypos[2]=typ(t)\hoehe
  typ(t)\zpos[2]=0
  typ(t)\xpos[3]=0
  typ(t)\ypos[3]=typ(t)\hoehe
  typ(t)\zpos[3]=0
  typ(t)\xpos[4]=0
  typ(t)\ypos[4]=0
  typ(t)\zpos[4]=typ(t)\laenge
  typ(t)\xpos[5]=typ(t)\breite
  typ(t)\ypos[5]=0
  typ(t)\zpos[5]=typ(t)\laenge
  typ(t)\xpos[6]=typ(t)\breite
  typ(t)\ypos[6]=typ(t)\hoehe
  typ(t)\zpos[6]=typ(t)\laenge
  typ(t)\xpos[7]=0
  typ(t)\ypos[7]=typ(t)\hoehe
  typ(t)\zpos[7]=typ(t)\laenge
  typ(t)\startposx=Random(800)+100
  typ(t)\startposy=Random(600)+100
  typ(t)\speedx=Random((5)+1)/10
  typ(t)\speedy=Random((5)+1)/10
  typ(t)\speedz=Random((5)+1)/10
  typ(t)\zeigerx=Random(2)+1
  If typ(t)\zeigerx=0:typ(t)\zeigerx=2:EndIf
  typ(t)\zeigery=Random(2)+1
  If typ(t)\zeigery=0:typ(t)\zeigery=-2:EndIf
  typ(t)\zeigerz=Random((5)+1)/10
  If typ(t)\zeigerz=0:typ(t)\zeigerz=-0.2:EndIf
  typ(t)\verz=Random(100)-Random(4000)
Next

;3d sprite als lichtextur
spr.l = CreateSprite(#PB_Any,8,8,#PB_Sprite_Texture)
StartDrawing(SpriteOutput(spr))
FrontColor( RGB(200,100,100) )
Box(0, 0, 8, 8)
StopDrawing()
CopySprite(spr,99,#PB_Sprite_Texture)
spr3d.l = CreateSprite3D(#PB_Any,99)

;3d sprites als seitenflächen
For n=1 To 6;seiten
  StartDrawing(SpriteOutput(spr))
  FrontColor( RGB(0,0,55) )
  Box(0, 0, 8, 8)
  DrawingFont(FontID(0))
  DrawingMode(3)
  FrontColor( RGB(229,100,0) )
  ;DrawText(1,-1,Str(n))
  StopDrawing()
  CopySprite(spr,n,#PB_Sprite_Texture)
  CreateSprite3D(n,n)
Next

;quaderecken einlesen
For t=1 To anzahl
  Restore seiten:
  For n=1 To 6;seiten
    Read typ(t)\con1[n]
    Read typ(t)\con2[n]
    Read typ(t)\con3[n]
    Read typ(t)\con4[n]
  Next
  DataSection
  seiten:
  Data.w 0,1,2,3,  4,5,1,0,  5,4,7,6,  4,0,3,7, 1,5,6,2, 3,2,6,7
  EndDataSection
Next

;************************************************************************************************************************
;Haupschleife
Repeat
  ClearScreen( RGB(0,0,0) )
  ExamineKeyboard()
  punkteberechnen ()
  sortieren()
  linien()
  texture()
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
;*************************************************************************************************************************

Procedure punkteberechnen ()
  For t=1 To anzahl
    
    For v=0 To 7 ;eckpunkte transformieren
      ;nächster winkelwert
      typ(t)\winkelx=typ(t)\winkelx+typ(t)\speedx
      If typ(t)\winkelx+typ(t)\speedx =>360.00 :typ(t)\winkelx=typ(t)\winkelx-360:EndIf
      typ(t)\winkely=typ(t)\winkely+typ(t)\speedy
      If typ(t)\winkely+typ(t)\speedy =>360.00 :typ(t)\winkely=typ(t)\winkely-360:EndIf
      typ(t)\winkelz=typ(t)\winkelz+typ(t)\speedz
      If typ(t)\winkelz+typ(t)\speedz =>360.00 :typ(t)\winkelz=typ(t)\winkelz-360:EndIf
      ;rotation
      typ(t)\temypos[v]= (((typ(t)\ypos[v]-typ(t)\hoehe/2) * Cos(typ(t)\winkelx*(2*3.14159265/360))) - ((typ(t)\zpos[v]-typ(t)\laenge/2) * Sin(typ(t)\winkelx*(2*3.14159265/360))))
      typ(t)\temzpos[v]= (((typ(t)\ypos[v]-typ(t)\hoehe/2) * Sin(typ(t)\winkelx*(2*3.14159265/360))) + ((typ(t)\zpos[v]-typ(t)\laenge/2) * Cos(typ(t)\winkelx*(2*3.14159265/360))))
      typ(t)\temxpos[v]= (((typ(t)\xpos[v]-typ(t)\breite/2) * Cos(typ(t)\winkely*(2*3.14159265/360))) - (typ(t)\temzpos[v] * Sin(typ(t)\winkely*(2*3.14159265/360))))
      typ(t)\temzpos[v] =(((typ(t)\xpos[v]-typ(t)\breite/2) * Sin(typ(t)\winkely*(2*3.14159265/360))) + (typ(t)\temzpos[v] * Cos(typ(t)\winkely*(2*3.14159265/360))))
      x=typ(t)\temxpos[v]
      typ(t)\temxpos[v]= ((typ(t)\temxpos[v] * Cos(typ(t)\winkelz*(2*3.14159265/360))) - (typ(t)\temypos[v] * Sin(typ(t)\winkelz*(2*3.14159265/360))))
      typ(t)\temypos[v]= ((x * Sin(typ(t)\winkelz*(2*3.14159265/360))) + (typ(t)\temypos[v] * Cos(typ(t)\winkelz*(2*3.14159265/360))))
      ;verschiebung z-achse
      If typ(t)\verz>220 Or typ(t)\verz<-4000:typ(t)\zeigerz=typ(t)\zeigerz*-1:EndIf
      typ(t)\verz=typ(t)\verz+typ(t)\zeigerz
      typ(t)\temzpos[v]=typ(t)\temzpos[v]+typ(t)\verz
      ;2d umsetzung
      typ(t)\x2d[v]= 500 * typ(t)\temxpos[v] / (400 - (typ(t)\temzpos[v]))
      typ(t)\y2d[v]= 500 * typ(t)\temypos[v] / (400 - (typ(t)\temzpos[v]))
    Next
    
    ;2d bewegung
    typ(t)\startposx=typ(t)\startposx+typ(t)\zeigerx
    typ(t)\startposy=typ(t)\startposy+typ(t)\zeigery
    If typ(t)\startposx>900 Or typ(t)\startposx<100:typ(t)\zeigerx=typ(t)\zeigerx*-1:EndIf
    If typ(t)\startposy>700 Or typ(t)\startposy<100:typ(t)\zeigery=typ(t)\zeigery*-1:EndIf
    ;z mittelwert sammeln
    typ(t)\index=(Round(typ(t)\temzpos[0],1)+Round(typ(t)\temzpos[6],1)+Round(typ(t)\temzpos[4],1)+Round(typ(t)\temzpos[2],1))/4
  Next
EndProcedure

Procedure sortieren();der würfel in z reinfolge ft.bubblesort(thx wichtel !)
  a.l
  b.l
  c.wuerfel
  For b=1 To anzahl-1
    For a=b To anzahl-1
      If  typ(b)\index>typ(a+1)\index
        CopyMemory(@typ(b),@c,SizeOf(wuerfel))
        CopyMemory(@typ(a+1),@typ(b),SizeOf(wuerfel))
        CopyMemory(@c,@typ(a+1),SizeOf(wuerfel))
      EndIf
    Next a
  Next b
EndProcedure

Procedure linien() ;drahtgitter
  StartDrawing(ScreenOutput())
  DrawingMode(1)
  For t=1 To anzahl
    
    For n=1 To 6
      con1=typ(t)\con1[n]
      con2=typ(t)\con2[n]
      con3=typ(t)\con3[n]
      con4=typ(t)\con4[n]
      FrontColor( RGB(0,0,155) )
      LineXY(typ(t)\x2d[con1]+typ(t)\startposx,typ(t)\y2d[con1]+typ(t)\startposy,typ(t)\x2d[con2]+typ(t)\startposx,typ(t)\y2d[con2]+typ(t)\startposy) ;eins
      LineXY(typ(t)\x2d[con2]+typ(t)\startposx,typ(t)\y2d[con2]+typ(t)\startposy,typ(t)\x2d[con3]+typ(t)\startposx,typ(t)\y2d[con3]+typ(t)\startposy) ;zwei
      LineXY(typ(t)\x2d[con3]+typ(t)\startposx,typ(t)\y2d[con3]+typ(t)\startposy,typ(t)\x2d[con4]+typ(t)\startposx,typ(t)\y2d[con4]+typ(t)\startposy) ;drei
      LineXY(typ(t)\x2d[con4]+typ(t)\startposx,typ(t)\y2d[con4]+typ(t)\startposy,typ(t)\x2d[con1]+typ(t)\startposx,typ(t)\y2d[con1]+typ(t)\startposy) ;vier
    Next
    
  Next
  StopDrawing()
EndProcedure

Procedure texture();3d sprites rauftransformen
  Start3D()
  ;Sprite3DBlendingMode(15,9)
  For t=1 To anzahl
    
    For n=1 To 6 ;seiten
      con1=typ(t)\con1[n]
      con2=typ(t)\con2[n]
      con3=typ(t)\con3[n]
      con4=typ(t)\con4[n]
      If typ(t)\x2d[con1]>typ(index)\x2d[con2]
        TransformSprite3D(n, typ(t)\x2d[con2], typ(t)\y2d[con2], typ(t)\x2d[con1], typ(t)\y2d[con1], typ(t)\x2d[con4], typ(t)\y2d[con4], typ(t)\x2d[con3], typ(t)\y2d[con3])
        TransformSprite3D(spr3d, typ(t)\x2d[con2], typ(t)\y2d[con2], typ(t)\x2d[con1], typ(t)\y2d[con1], typ(t)\x2d[con4], typ(t)\y2d[con4], typ(t)\x2d[con3], typ(t)\y2d[con3])
      EndIf
      If typ(t)\y2d[con4]<typ(t)\y2d[con2]
        TransformSprite3D(n, typ(t)\x2d[con1], typ(t)\y2d[con1], typ(t)\x2d[con4], typ(t)\y2d[con4], typ(t)\x2d[con3], typ(t)\y2d[con3], typ(t)\x2d[con2], typ(t)\y2d[con2])
        TransformSprite3D(spr3d, typ(t)\x2d[con1], typ(t)\y2d[con1], typ(t)\x2d[con4], typ(t)\y2d[con4], typ(t)\x2d[con3], typ(t)\y2d[con3], typ(t)\x2d[con2], typ(t)\y2d[con2])
      EndIf
      If typ(t)\y2d[con4]>typ(t)\y2d[con2]
        TransformSprite3D(n, typ(t)\x2d[con3], typ(t)\y2d[con3], typ(t)\x2d[con2], typ(t)\y2d[con2], typ(t)\x2d[con1], typ(t)\y2d[con1], typ(t)\x2d[con4], typ(t)\y2d[con4])
        TransformSprite3D(spr3d, typ(t)\x2d[con3], typ(t)\y2d[con3], typ(t)\x2d[con2], typ(t)\y2d[con2], typ(t)\x2d[con1], typ(t)\y2d[con1], typ(t)\x2d[con4], typ(t)\y2d[con4])
      EndIf
      mittelwert=(Round(typ(t)\x2d[con1],1)+Round(typ(t)\x2d[con2],1)+Round(typ(t)\x2d[con3],1)+Round(typ(t)\x2d[con4],1))/4
      DisplaySprite3D(n,typ(t)\startposx,typ(t)\startposy,255)
      DisplaySprite3D(spr3d,typ(t)\startposx,typ(t)\startposy,100+mittelwert*3/4);lichttextur
    Next
    
  Next
  Stop3D()
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
