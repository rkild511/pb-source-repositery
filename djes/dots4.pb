;Effectue un morph entre les points d'un objet, avec deux textures différentes, et rotation 3d
;ts les points sont dans un tableau auquel on accède linéairement afin d'éviter des "caches hits"
;algo optimisé, mais pas le code

#MELANGE=#FALSE

#SCREEN_WIDTH=800
#SCREEN_HEIGHT=600

#MIDX=#SCREEN_WIDTH/2
#MIDY=#SCREEN_HEIGHT/2

Structure dot
 x.f
 y.f
 z.f
 color.l
EndStructure

IncludeFile "matrix.pb"

InitSprite()
InitKeyboard()
InitMouse()
InitSprite3D()

Dim dots.dot(500000)

;OpenWindow(0, 0, 0, #SCREEN_WIDTH, #SCREEN_HEIGHT, 0, "Purebr3aker")
;OpenWindowedScreen(WindowID(0), 0, 0, #SCREEN_WIDTH, #SCREEN_HEIGHT, 0, 0, 0)
OpenScreen(#SCREEN_WIDTH, #SCREEN_HEIGHT, 16, "Purebr3aker")

SetFrameRate(75)
RandomSeed(1)

;******************************************
;positions et couleurs des points d'origine
LoadImage(0,"gfx\bgames.bmp")
UseImage(0)
StartDrawing(ImageOutput()) 
i.l=0
For yi=-200 To 200-1
 For xi=-300 To 300-1
  dots(i)\x=xi
  dots(i)\y=yi
  dots(i)\z=20*Sin((xi*3.1416*4)/600)*Sin((yi*3.1416*4)/400)
  dots(i)\color=Point(xi+300,yi+200)
  i+2
 Next xi
Next yi
StopDrawing()
FreeImage(0)

;**************************
;couleurs de la seconde img
LoadImage(0,"gfx\isproudtopresent.bmp")
UseImage(0)
StartDrawing(ImageOutput())
i.l=1
For yi=-200 To 200-1
 For xi=-300 To 300-1
  dots(i)\x=xi
  dots(i)\y=yi
  dots(i)\z=20*Sin((xi*3.1416*4)/600)*Sin((yi*3.1416*4)/400)
  dots(i)\color=Point(xi+300,yi+200)
  i+2
 Next xi
Next yi
StopDrawing()
FreeImage(0)

;**************************
;entrelace les points de morph afin de créer un tableau des points sous la forme suivante (chiffres: num point; lettre:couleur) 
;à partir de 0a 0b 1c 1d 2e 2f 3g 3h
;on obtient  0a 1d 1c 2f 2e 3h ...
;->gain de calculs dans la bcl principale
xo.f=dots(1)\x
yo.f=dots(1)\y
zo.f=dots(1)\z
co.l=dots(1)\color
For i=0 To 479998-2 Step 2
 dots(i+1)\x=dots(i+3)\x
 dots(i+1)\y=dots(i+3)\y
 dots(i+1)\z=dots(i+3)\z
 dots(i+1)\color=dots(i+3)\color
Next i
i+2
dots(i+1)\x=xo
dots(i+1)\y=yo
dots(i+1)\z=zo
dots(i+1)\color=co

If #MELANGE=#TRUE
 ;**************************
 ;ensuite mélange les points
 For i=0 To 479998-2 Step 2

  Repeat
   ;normlt la valeur de ce random devrait être tout le tableau; 
   ;en fait, en le limitant, on swappe avec les n 1ers éléments, 
   ;ce qui a pour effet de limiter la distance des points transformés 
   ;(ça morphe avec les n élts précédents)
   p.l=Random(1000) 
   p+p
  Until p<>i

  xo1.f=dots(i+1)\x
  yo1.f=dots(i+1)\y
  zo1.f=dots(i+1)\z
  co1.l=dots(i+1)\color
  xo2.f=dots(i+2)\x
  yo2.f=dots(i+2)\y
  zo2.f=dots(i+2)\z
  co2.l=dots(i+2)\color

  dots(i+1)\x=dots(p+1)\x
  dots(i+1)\y=dots(p+1)\y
  dots(i+1)\z=dots(p+1)\z
  dots(i+1)\color=dots(p+1)\color
  dots(i+2)\x=dots(p+2)\x
  dots(i+2)\y=dots(p+2)\y
  dots(i+2)\z=dots(p+2)\z
  dots(i+2)\color=dots(p+2)\color

  dots(p+1)\x=xo1
  dots(p+1)\y=yo1
  dots(p+1)\z=zo1
  dots(p+1)\color=co1
  dots(p+2)\x=xo2
  dots(p+2)\y=yo2
  dots(p+2)\z=zo2
  dots(p+2)\color=co2

 Next i
EndIf

;************************************
;crée un sprite en mémoire sur lequel va s'effectuer le tracé
CreateSprite(0,800,600,#PB_Sprite_Memory)

DefType.matrix obj_rotation_matrix_org, obj_rotation_matrix, zoom
DefType.f x, y, z

matrix_identity(@obj_rotation_matrix_org)
matrix_identity(@obj_rotation_matrix)
matrix_identity(@zoom)

rot_speed.f=radians(1)
tangage.f=0 : cap.f=0 : roulis.f=0
zoomf.f=1

morph.f=0

Repeat
 ExamineKeyboard()
  
 cap=0 : roulis=0 : tangage=0 : redraw=0

 If KeyboardPushed(#PB_Key_PageUp)
  roulis=-rot_speed
 EndIf 
 If KeyboardPushed(#PB_Key_PageDown)
  roulis=rot_speed
 EndIf 

 If KeyboardPushed(#PB_Key_Up) 
  tangage=rot_speed
 EndIf 
 If KeyboardPushed(#PB_Key_Down) 
  tangage=-rot_speed
 EndIf 

 If KeyboardPushed(#PB_Key_Left) 
  cap=rot_speed    
 EndIf 
 If KeyboardPushed(#PB_Key_Right) 
  cap=-rot_speed
 EndIf   

 If KeyboardPushed(#PB_Key_F1) 
   matrix_identity(@obj_rotation_matrix_org)
   redraw=1  
 EndIf 

 ExamineMouse()
 If MouseButton(1)
  zoomf+0.01
 EndIf
 If MouseButton(2)
  zoomf-0.01
 EndIf

 y=MouseDeltaY()

 If cap>#PI 
  cap-2*#PI
 Else
  If cap<-#PI 
   cap+2*#PI
  EndIf
 EndIf
 If tangage>#PI 
  tangage-2*#PI
 Else
  If tangage<-#PI 
   tangage+2*#PI
  EndIf
 EndIf
 If roulis>#PI 
  roulis-2*#PI
 Else
  If roulis<-#PI 
   roulis+2*#PI
  EndIf
 EndIf

 ;ClearScreen(0,0,0)
 
 ;rotation et zoom de l'objet
 matrix_rotate_around_object_axis(@obj_rotation_matrix_org, tangage.f, cap.f, roulis.f)
 matrix_copy(@obj_rotation_matrix,@obj_rotation_matrix_org)
 zoom\mat[0]=zoomf
 zoom\mat[4]=zoomf
 zoom\mat[8]=zoomf
 matrix_by_matrix_multiply(@obj_rotation_matrix, @zoom)

 m0.f=obj_rotation_matrix\mat[0]
 m1.f=obj_rotation_matrix\mat[1]   
 m2.f=obj_rotation_matrix\mat[2]
 m3.f=obj_rotation_matrix\mat[3]
 m4.f=obj_rotation_matrix\mat[4]
 m5.f=obj_rotation_matrix\mat[5]
 
 ;****************************
 StartDrawing(SpriteOutput(0))
 Box(0,0,800,600,RGB(0,0,0))

 ;premier point
 x.f=dots(0)\x
 y.f=dots(0)\y
 z.f=dots(0)\z
 x1.f = m0 * x + m1 * y + m2 * z;
 y1.f = m3 * x + m4 * y + m5 * z;
 
 For i=0 To 480000-2 Step 2

  ;couleur du point originel
  c1=dots(i)\color

  ;pos et couleur du point de destination
  x.f=dots(i+1)\x
  y.f=dots(i+1)\y
  z.f=dots(i+1)\z
  x2.f = m0 * x + m1 * y + m2 * z;
  y2.f = m3 * x + m4 * y + m5 * z;
  c2=dots(i+1)\color

  x=x1+morph*(x2-x1)
  y=y1+morph*(y2-y1)
  r=Red(c1)+morph*(Red(c2)-Red(c1))
  g=Green(c1)+morph*(Green(c2)-Green(c1))
  b=Blue(c1)+morph*(Blue(c2)-Blue(c1))
  
  ;position du nouveau point originel=position du point de destination (mais couleur originel), afin d'éviter un nouveau calcul de cette pos
  x1=x2
  y1=y2

  If x<=399 And x>=-399 And y>=-299 And y<=299
;    DisplaySprite(1,300+dots2(i)\x,200+dots2(i)\y)
    Plot(400+x,300+y,RGB(r,g,b))
   EndIf
 Next i

 StopDrawing()

 DisplaySprite(0,0,0)   
 FlipBuffers(1)

 morph+MouseWheel()/100
 If morph<0
  morph=0
 EndIf

 If morph>1
  morph=1
 EndIf



Until KeyboardPushed(#PB_Key_Escape)
 
End 
   

; ExecutableFormat=Windows
; CPU=1
; DisableDebugger
; EOF