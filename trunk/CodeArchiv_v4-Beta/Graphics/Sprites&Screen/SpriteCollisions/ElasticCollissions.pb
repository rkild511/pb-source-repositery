; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8594
; Author: Psychophanta
; Date: 12. August 2006
; OS: Windows
; Demo: Yes


; This is a rigorous mechanics collision simulation. 
; No rub, no gravity and totally elastic collisions. 

Define.d 
Procedure.d WrapAngle(angle.d); <- wraps a value into [-Pi,Pi] fringe 
  !fldpi 
  !fadd st0,st0; <- now i have 2*pi into st0 
  !fld qword[p.v_angle] 
  !fprem1 
  !fstp st1 
  ProcedureReturn 
EndProcedure 

Procedure.d ATan2(y.d,x.d) 
  !fld qword[p.v_y] 
  !fld qword[p.v_x] 
  !fpatan 
  ProcedureReturn 
EndProcedure 

Procedure CreateBallSprite(c.l,size.l,color.l) 
  CreateSprite(c,size,size) 
  StartDrawing(SpriteOutput(c)) 
  BackColor(0):R.w=color&$FF:G.w=color>>8&$FF:B.w=color>>16&$FF 
  For t.l=size/2 To 1 Step -1 
    R+160/size:G+160/size:B+160/size:If R>255:R=255:EndIf:If G>255:G=255:EndIf:If B>255:B=255:EndIf 
    Circle(size/2,size/2,t,RGB(R,G,B)) 
  Next 
  StopDrawing() 
EndProcedure 

Procedure ParticleAndBarbellShock(*results.double,l=0.1,R=0.65,W=0.91,m1=0.3411,m2=0.1411,V1=0.0,V2=0.0,K=1.0/3.0,e=1.0) 
  ;l es la distancia a la que colisionan particula y barra, a medir desde el centro de esta. 
  ;R es el radio de la barra (o disco, o esfera...). 
  ;m1 es la masa de la particula. 
  ;m2 es la masa de la barra. 
  ;(V1x,V1y) es el vector velocidad de la particula antes del choque. 
  ;(V2x,V2y) es el vector velocidad del centro de masas de la barra antes del choque. 
  ;(V1xp,V1yp) es el vector velocidad de la partícula tras el choque. 
  ;(V2xp,V2yp) es el vector velocidad del centro de masas de la barra tras el choque. 
  ;W es la velocidad angular inicial de la barra 
  ;Wp es la velocidad angular final de la barra 
  ;e es un valor llamado "coeficiente de restitución" y es: e = -(V1p-(V2p+Wp*l))/(V1-(V2+W*l)) 
  ;K es un valor especifico de la geometría de la masa rotante (1/2 si es un disco rotando alrededor de su eje central y transversal; 1/3 si es una barra; etc). 
  I=m2*K*R*R; <- momento de inercia 
  ;Ecuaciones: 
  ;m1·V1+m2·V2=m1·V1'+m2·V2'  ; <- conservación del momento lineal del sistema 
  ;m1·V1·l+I·W=m1·V1'·l+I·W'  ; <- conservación del momento angular del sistema 
  ;m1·V1^2+m2·V2^2+I·W^2+Q=m1·V1'^2+m2·V2'^2+I·W'^2  ; <- conservación de la energía del sistema. Q=0 para un choque completamente elástico 
  ;V1'=V2'+W'·l-e·(V1-V2-W·l) 
  CRV=e*(V1-V2-W*l) 
  ;Incógnitas despejadas: 
  Wp=(I*W*(m1+m2)+m1*m2*l*(V1-V2+CRV))/(I*(m1+m2)+m1*m2*l*l) 
  V2p=(m1*V1+m2*V2-m1*Wp*l+m1*CRV)/(m1+m2) 
  V1p=V2p+Wp*l-CRV 
  ; 
  *results\d=Wp:*results+SizeOf(double) 
  *results\d=V2p:*results+SizeOf(double) 
  *results\d=V1p 
EndProcedure 

Structure values 
  omega.d 
  VelocidadEfectiva0.d 
  StructureUnion 
    VelocidadEfectiva1.d 
    VelocidadEfectiva2.d 
  EndStructureUnion 
EndStructure 
gotvalues.values 

Macro Collide(MassID) 
  ;Unclip 
  mass=M(0)\mass/(M(0)\mass+M(MassID#)\mass) 
  Ball#MassID#x+Unclip#MassID#x.d*mass:Ball#MassID#y+Unclip#MassID#y.d*mass 
  M(MassID#)\x+Unclip#MassID#x.d*mass:M(MassID#)\y+Unclip#MassID#y.d*mass 
  mass=1-mass 
  M(0)\x-Unclip#MassID#x.d*mass:M(0)\y-Unclip#MassID#y.d*mass 
  ; 
  Point#MassID#x.d=Ball#MassID#x.d+M(MassID#)\radius*DiffuX.d:Point#MassID#y.d=Ball#MassID#y.d+M(MassID#)\radius*DiffuY.d; <- vector (Eje de giro->punto de colisión) 
  l=Abs(Point#MassID#x.d*-DiffuY.d+Point#MassID#y.d*DiffuX.d):l*l/(la+l) 
  ; 
  \VelocidadEfectiva0=(M(0)\mx*Rightvx.d+M(0)\my*Rightvy.d):\VelocidadEfectiva0=(M(0)\mx*Rightvx.d+M(0)\my*Rightvy.d); <- módulo de la componente en línea de choque de la velocidad lineal de la barra. 
  \VelocidadEfectiva#MassID#=(M(MassID#)\mx*Rightvx.d+M(MassID#)\my*Rightvy.d):\VelocidadEfectiva#MassID#=(M(MassID#)\mx*Rightvx.d+M(MassID#)\my*Rightvy.d); <- componente en linea de choque de la velocidad lineal de la particula. 
  M(0)\mx-\VelocidadEfectiva0*Rightvx.d:M(0)\my-\VelocidadEfectiva0*Rightvy.d; <- se deja a la barra solo con la componente de la velocidad normal a la linea de choque. 
  M(MassID#)\mx-\VelocidadEfectiva#MassID#*Rightvx.d:M(MassID#)\my-\VelocidadEfectiva#MassID#*Rightvy.d; <- se deja a la partícula solo con la componente de la velocidad normal a la linea de choque. 
  ; 
  ;The calculation function: 
  ParticleAndBarbellShock(@gotvalues.values,l,M(0)\HalfWidth,omega,M(MassID#)\mass,M(0)\mass,\VelocidadEfectiva#MassID#,\VelocidadEfectiva0) 
  ; 
  omega=\omega 
  M(0)\mx+\VelocidadEfectiva0*Rightvx.d:M(0)\my+\VelocidadEfectiva0*Rightvy.d; <- se suma la velocidad en la linea de choque obtenida. 
  M(MassID#)\mx+\VelocidadEfectiva#MassID#*Rightvx.d:M(MassID#)\my+\VelocidadEfectiva#MassID#*Rightvy.d; <- se suma la velocidad en la linea de choque obtenida. 
EndMacro 

Macro CollideR(MassID) 
  la=M(0)\HalfWidth 
  Collide(MassID#) 
EndMacro 

Macro CollideL(MassID) 
  la=M(0)\HalfWidth 
  Collide(MassID#) 
EndMacro 

Macro CollideU(MassID) 
  la=M(0)\HalfHeight 
  Collide(MassID#) 
EndMacro 

Macro CollideD(MassID) 
  la=M(0)\HalfHeight 
  Collide(MassID#) 
EndMacro 

Macro BallInner(MassID) 
  Ball#MassID#x.d=M(MassID#)\x-M(0)\x:Ball#MassID#y.d=M(MassID#)\y-M(0)\y; <- vector centro de cápsula->bola 
  Capsule#MassID#x.d=Cos(angle):Capsule#MassID#y.d=Sin(angle); <- vector Derecha de la cápsula 
  Ball#MassID#rdist.d=(Ball#MassID#x*Capsule#MassID#x+Ball#MassID#y*Capsule#MassID#y); <- Proyección del vector bola sobre el vector Derecha de la cápsula 
  Ball#MassID#udist.d=(Ball#MassID#x*Capsule#MassID#y+Ball#MassID#y*-Capsule#MassID#x); <- Proyección del vector bola sobre el vector Arriba de la cápsula 
  If Ball#MassID#rdist>0; <- Si la bola#MassID# está a la derecha: 
    If Ball#MassID#udist>0; <- Si la bola#MassID# está a la derecha y arriba: 
      rdifmr=Ball#MassID#rdist-M(0)\HalfWidth+M(MassID#)\radius 
      udifmr=Ball#MassID#udist-M(0)\HalfHeight+M(MassID#)\radius 
      If udifmr>0; <- Si hay colisión contra la arista de arriba: 
        Rightvx.d=-Capsule#MassID#y:Rightvy.d=Capsule#MassID#x; <- este vector señala siempre el sentido de giro positivo (agujas del reloj) 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#y:DiffuY.d=-Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-udifmr*DiffuX.d:Unclip#MassID#y.d=-udifmr*DiffuY.d 
        CollideU(MassID#) 
      EndIf 
      If rdifmr>0; <- Si hay colisión contra la arista derecha: 
        Rightvx.d=Capsule#MassID#x:Rightvy.d=Capsule#MassID#y 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#x:DiffuY.d=Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-rdifmr*DiffuX.d:Unclip#MassID#y.d=-rdifmr*DiffuY.d 
        CollideR(MassID#) 
      EndIf 
    Else; <- Si la bola#MassID# está a la derecha y abajo: 
      rdifmr=Ball#MassID#rdist-M(0)\HalfWidth+M(MassID#)\radius 
      udifmr=-Ball#MassID#udist-M(0)\HalfHeight+M(MassID#)\radius 
      If udifmr>0; <- Si hay colisión contra la arista de abajo: 
        Rightvx.d=-Capsule#MassID#y:Rightvy.d=Capsule#MassID#x 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#y:DiffuY.d=Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-udifmr*DiffuX.d:Unclip#MassID#y.d=-udifmr*DiffuY.d 
        CollideD(MassID#) 
      EndIf 
      If rdifmr>0; <- Si hay colisión contra la arista derecha: 
        Rightvx.d=-Capsule#MassID#x:Rightvy.d=-Capsule#MassID#y 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#x:DiffuY.d=Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-rdifmr*DiffuX.d:Unclip#MassID#y.d=-rdifmr*DiffuY.d 
        CollideR(MassID#) 
      EndIf 
    EndIf 
  Else; <- Si la bola está a la izquierda: 
    If Ball#MassID#udist>0; <- Si la bola está a la izquierda y arriba: 
      rdifmr=-Ball#MassID#rdist-M(0)\HalfWidth+M(MassID#)\radius 
      udifmr=Ball#MassID#udist-M(0)\HalfHeight+M(MassID#)\radius 
      If udifmr>0; <- Si hay colisión contra la arista de arriba: 
        Rightvx.d=Capsule#MassID#y:Rightvy.d=-Capsule#MassID#x 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#y:DiffuY.d=-Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-udifmr*DiffuX.d:Unclip#MassID#y.d=-udifmr*DiffuY.d 
        CollideU(MassID#) 
      EndIf 
      If rdifmr>0; <- Si hay colisión contra la arista izquierda: 
        Rightvx.d=Capsule#MassID#x:Rightvy.d=Capsule#MassID#y 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#x:DiffuY.d=-Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-rdifmr*DiffuX.d:Unclip#MassID#y.d=-rdifmr*DiffuY.d 
        CollideL(MassID#) 
      EndIf 
    Else; <- Si la bola está a la izquierda y abajo: 
      rdifmr=-Ball#MassID#rdist-M(0)\HalfWidth+M(MassID#)\radius 
      udifmr=-Ball#MassID#udist-M(0)\HalfHeight+M(MassID#)\radius 
      If udifmr>0; <- Si hay colisión contra la arista de abajo: 
        Rightvx.d=Capsule#MassID#y:Rightvy.d=-Capsule#MassID#x 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#y:DiffuY.d=Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-udifmr*DiffuX.d:Unclip#MassID#y.d=-udifmr*DiffuY.d 
        CollideD(MassID#) 
      EndIf 
      If rdifmr>0; <- Si hay colisión contra la arista izquierda: 
        Rightvx.d=-Capsule#MassID#x:Rightvy.d=-Capsule#MassID#y 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#x:DiffuY.d=-Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=-rdifmr*DiffuX.d:Unclip#MassID#y.d=-rdifmr*DiffuY.d 
        CollideL(MassID#) 
      EndIf 
    EndIf 
  EndIf 
EndMacro 

Macro BallOuter(MassID) 
  Ball#MassID#x.d=M(MassID#)\x-M(0)\x:Ball#MassID#y.d=M(MassID#)\y-M(0)\y; <- vector centro de cápsula->bola 
  Capsule#MassID#x.d=Cos(angle):Capsule#MassID#y.d=Sin(angle); <- vector-unidad Derecha de la cápsula 
  Ball#MassID#rdist.d=(Ball#MassID#x*Capsule#MassID#x+Ball#MassID#y*Capsule#MassID#y); <- Proyección del vector bola sobre el vector Derecha de la cápsula 
  Ball#MassID#udist.d=(Ball#MassID#x*Capsule#MassID#y+Ball#MassID#y*-Capsule#MassID#x); <- Proyección del vector bola sobre el vector Arriba de la cápsula 
  ; 
  If Ball#MassID#rdist>=0; <- Si la bola#MassID# está a la derecha: 
    If Ball#MassID#udist>=0; <- Si la bola#MassID# está a la derecha y arriba: 
      rdif=Ball#MassID#rdist-M(0)\HalfWidth:rdifmr=rdif-M(MassID#)\radius 
      udif=Ball#MassID#udist-M(0)\HalfHeight:udifmr=udif-M(MassID#)\radius 
      If udifmr<=0 And rdif<=0; <- Si hay colisión contra alguna arista o esquina superior derecha: 
        Rightvx.d=-Capsule#MassID#y:Rightvy.d=Capsule#MassID#x 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#y:DiffuY.d=Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=udifmr*DiffuX.d:Unclip#MassID#y.d=udifmr*DiffuY.d 
        CollideU(MassID#) 
      ElseIf rdifmr<=0 And udif<=0; <- Si hay colisión contra la arista derecha: 
        Rightvx.d=Capsule#MassID#x:Rightvy.d=Capsule#MassID#y 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#x:DiffuY.d=-Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=rdifmr*DiffuX.d:Unclip#MassID#y.d=rdifmr*DiffuY.d 
        CollideR(MassID#) 
      Else:ddif=Sqr(rdif*rdif+udif*udif)-M(MassID#)\radius 
        If ddif<0 
          incl=ATan2(-udif,-rdif) 
          DiffuX.d=Cos(incl):DiffuY.d=Sin(incl); <- Vector unidad del sentido del choque. 
          Unclip#MassID#x.d=ddif*DiffuX.d:Unclip#MassID#y.d=ddif*DiffuY.d 
          Rightvx.d=Capsule#MassID#x:Rightvy.d=Capsule#MassID#y 
          CollideR(MassID#) 
          Rightvx.d=-Capsule#MassID#y:Rightvy.d=Capsule#MassID#x 
          CollideU(MassID#) 
        EndIf 
      EndIf 
    Else; <- Si la bola#MassID# está a la derecha y abajo: 
      rdif=Ball#MassID#rdist-M(0)\HalfWidth:rdifmr=rdif-M(MassID#)\radius 
      udif=-Ball#MassID#udist-M(0)\HalfHeight:udifmr=udif-M(MassID#)\radius 
      If udifmr<=0 And rdif<=0; <- Si hay colisión contra la arista de abajo: 
        Rightvx.d=-Capsule#MassID#y:Rightvy.d=Capsule#MassID#x 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#y:DiffuY.d=-Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=udifmr*DiffuX.d:Unclip#MassID#y.d=udifmr*DiffuY.d 
        CollideD(MassID#) 
      ElseIf rdifmr<=0 And udif<=0; <- Si hay colisión contra la arista derecha: 
        Rightvx.d=-Capsule#MassID#x:Rightvy.d=-Capsule#MassID#y 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#x:DiffuY.d=-Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=rdifmr*DiffuX.d:Unclip#MassID#y.d=rdifmr*DiffuY.d 
        CollideR(MassID#) 
      Else:ddif=Sqr(rdif*rdif+udif*udif)-M(MassID#)\radius 
        If ddif<0 
          incl=ATan2(udif,-rdif) 
          DiffuX.d=Cos(incl):DiffuY.d=Sin(incl); <- Vector unidad del sentido del choque. 
          Unclip#MassID#x.d=ddif*DiffuX.d:Unclip#MassID#y.d=ddif*DiffuY.d 
          Rightvx.d=-Capsule#MassID#x:Rightvy.d=-Capsule#MassID#y 
          CollideR(MassID#) 
          Rightvx.d=-Capsule#MassID#y:Rightvy.d=Capsule#MassID#x 
          CollideD(MassID#) 
        EndIf 
      EndIf 
    EndIf 
  Else; <- Si la bola está a la izquierda: 
    If Ball#MassID#udist>=0; <- Si la bola está a la izquierda y arriba: 
      rdif=-Ball#MassID#rdist-M(0)\HalfWidth:rdifmr=rdif-M(MassID#)\radius 
      udif=Ball#MassID#udist-M(0)\HalfHeight:udifmr=udif-M(MassID#)\radius 
      If udifmr<=0 And rdif<=0; <- Si hay colisión contra la arista de arriba: 
        Rightvx.d=Capsule#MassID#y:Rightvy.d=-Capsule#MassID#x 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=-Capsule#MassID#y:DiffuY.d=Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=udifmr*DiffuX.d:Unclip#MassID#y.d=udifmr*DiffuY.d 
        CollideU(MassID#) 
      ElseIf rdifmr<=0 And udif<=0; <- Si hay colisión contra la arista izquierda: 
        Rightvx.d=Capsule#MassID#x:Rightvy.d=Capsule#MassID#y 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#x:DiffuY.d=Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=rdifmr*DiffuX.d:Unclip#MassID#y.d=rdifmr*DiffuY.d 
        CollideL(MassID#) 
      Else:ddif=Sqr(rdif*rdif+udif*udif)-M(MassID#)\radius 
        If ddif<0 
          incl=ATan2(-udif,rdif) 
          DiffuX.d=Cos(incl):DiffuY.d=Sin(incl); <- Vector unidad del sentido del choque. 
          Unclip#MassID#x.d=ddif*DiffuX.d:Unclip#MassID#y.d=ddif*DiffuY.d 
          Rightvx.d=Capsule#MassID#x:Rightvy.d=Capsule#MassID#y 
          CollideL(MassID#) 
          Rightvx.d=Capsule#MassID#y:Rightvy.d=-Capsule#MassID#x 
          CollideU(MassID#) 
        EndIf 
      EndIf 
    Else; <- Si la bola está a la izquierda y abajo: 
      rdif=-Ball#MassID#rdist-M(0)\HalfWidth:rdifmr=rdif-M(MassID#)\radius 
      udif=-Ball#MassID#udist-M(0)\HalfHeight:udifmr=udif-M(MassID#)\radius 
      If udifmr<=0 And rdif<=0; <- Si hay colisión contra la arista de abajo: 
        Rightvx.d=Capsule#MassID#y:Rightvy.d=-Capsule#MassID#x 
        angle+Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#y:DiffuY.d=-Capsule#MassID#x; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=udifmr*DiffuX.d:Unclip#MassID#y.d=udifmr*DiffuY.d 
        CollideD(MassID#) 
      ElseIf rdifmr<=0 And udif<=0; <- Si hay colisión contra la arista izquierda: 
        Rightvx.d=-Capsule#MassID#x:Rightvy.d=-Capsule#MassID#y 
        angle-Abs(omega); <- to unclip 
        DiffuX.d=Capsule#MassID#x:DiffuY.d=Capsule#MassID#y; <- Vector unidad del sentido del choque. 
        Unclip#MassID#x.d=rdifmr*DiffuX.d:Unclip#MassID#y.d=rdifmr*DiffuY.d 
        CollideL(MassID#) 
      Else:ddif=Sqr(rdif*rdif+udif*udif)-M(MassID#)\radius 
        If ddif<0 
          incl=ATan2(udif,rdif) 
          DiffuX.d=Cos(incl):DiffuY.d=Sin(incl); <- Vector unidad del sentido del choque. 
          Unclip#MassID#x.d=ddif*DiffuX.d:Unclip#MassID#y.d=ddif*DiffuY.d 
          Rightvx.d=-Capsule#MassID#x:Rightvy.d=-Capsule#MassID#y 
          CollideL(MassID#) 
          Rightvx.d=Capsule#MassID#y:Rightvy.d=-Capsule#MassID#x 
          CollideD(MassID#) 
        EndIf 
      EndIf 
    EndIf 
  EndIf 
EndMacro 

;-INITS: 
#DEGTORAD=#PI/180.0:#RADTODEG=180.0/#PI 
bitplanes.b=32 
SCREENWIDTH.l=GetSystemMetrics_(#SM_CXSCREEN):SCREENHEIGHT.l=GetSystemMetrics_(#SM_CYSCREEN) 
If InitMouse()=0 Or InitSprite()=0 Or InitSprite3D()=0 Or InitKeyboard()=0 
  MessageRequester("Error","Can't access DirectX",0):End 
EndIf 

While OpenScreen(SCREENWIDTH,SCREENHEIGHT,bitplanes.b,"")=0 
  If bitplanes.b>16:bitplanes.b-8 
  ElseIf SCREENHEIGHT>600:SCREENWIDTH=800:SCREENHEIGHT=600 
  ElseIf SCREENHEIGHT>480:SCREENWIDTH=640:SCREENHEIGHT=480 
  ElseIf SCREENHEIGHT>400:SCREENWIDTH=640:SCREENHEIGHT=400 
  ElseIf SCREENHEIGHT>240:SCREENWIDTH=320:SCREENHEIGHT=240 
  ElseIf SCREENHEIGHT>200:SCREENWIDTH=320:SCREENHEIGHT=200 
  Else:MessageRequester("Listen:","Can't open Screen!",0):End 
  EndIf 
Wend 

Structure Masa 
  mass.d 
  x.d:y.d 
  mx.d:my.d 
  radius.d 
  HalfWidth.d 
  HalfHeight.d 
EndStructure 
#nummasses=3 
Global Dim M.Masa(#nummasses-1) 
M(0)\radius=256 
M(0)\HalfWidth=M(0)\radius:M(0)\HalfHeight=M(0)\HalfWidth/3 
M(1)\radius=M(0)\radius/16 
M(2)\radius=M(0)\radius/8 
#BallmovRadiusprop=0.9 
CreateSprite(0,M(0)\radius*2,M(0)\radius*2,#PB_Sprite_Texture); <- Disco cápsula frontal 
StartDrawing(SpriteOutput(0)) 
BackColor(0) 
Box(0,M(0)\radius-M(0)\HalfHeight,M(0)\HalfWidth*2,M(0)\HalfHeight*2,$aaEE77) 
For t.l=1 To M(0)\HalfHeight 
  Box(t,M(0)\radius-M(0)\HalfHeight+t,M(0)\HalfWidth*2-2*t,M(0)\HalfHeight*2-2*t,$6699DD-t) 
Next 
StopDrawing() 
CreateSprite3D(0,0):ZoomSprite3D(0,M(0)\radius*2,M(0)\radius*2) 
CreateBallSprite(1,M(1)\radius*2,$BBAA44); <- particula 1 
CreateBallSprite(2,M(2)\radius*2,$AA8833); <- particula 2 
; 
angle.d=0:angledeg.d=angle.d*#RADTODEG; <- Initial inclination 
angularforce.d=0.01333; <- Initial Force Momentum 
omega.d=0.0;01; <- Initial Angular speed 
alpha.d=0; <- Initial Angular acceleration 
; 
M(0)\x=SCREENWIDTH/2:M(0)\y=SCREENHEIGHT/2;<-Posición inicial de la cápsula 
M(1)\x=SCREENWIDTH/2:M(1)\y=SCREENHEIGHT/2; <- Posición inicial de la masa intracápsula1 (Ball1) 
M(2)\x=SCREENWIDTH/2:M(2)\y=SCREENHEIGHT*8/9; <- Posición inicial de la masa intracápsula2 (Ball2) 
M(0)\mass=40; <- Masa de la cápsula 
M(1)\mass=40; <- Masa de la Ball1 
M(2)\mass=40; <- Masa de la Ball2 
;-MAIN: 
Repeat 
  ExamineKeyboard():ExamineMouse():ClearScreen($250938) 
  Start3D() 
  RotateSprite3D(0,angledeg.d,0);<- cápsula 
  DisplaySprite3D(0,M(0)\x-M(0)\radius,M(0)\y-M(0)\radius,200); <- cápsula 
  Stop3D() 
  DisplayTransparentSprite(1,M(1)\x-M(1)\radius,M(1)\y-M(1)\radius); <- disco contra 
  DisplayTransparentSprite(2,M(2)\x-M(2)\radius,M(2)\y-M(2)\radius); <- Ball intracápsula frontal 
  ; 
;   Gosub DisplayAndKeys 
  ;;;;;;;;;;;;;;;;;;;;;;;Mouse buttons. If no mousebuttons are pressed, means that it leaves at dead-point 
  If MouseButton(1); <- Acceleration happens to all: 
    angularforce.d-1 
    alpha.d=angularforce.d/(M(1)\mass*M(0)\radius*M(0)\radius+M(2)\mass*M(0)\radius*M(0)\radius) 
    omega.d+alpha.d 
  ElseIf MouseButton(2); <- Acceleration happens to all: 
    angularforce.d+1 
    alpha.d=angularforce.d/(M(1)\mass*M(0)\radius*M(0)\radius+M(2)\mass*M(0)\radius*M(0)\radius) 
    omega.d+alpha.d 
  EndIf 
  ;Mouse move: 
  mousedeltax.l=MouseDeltaX():mousedeltay.l=MouseDeltaY() 
  M(2)\mx+mousedeltax.l/40:M(2)\my+mousedeltay.l/40 
  ;;;;;;;;;;;;;;;;;;;;;;;Update angles: 
  angle.d=WrapAngle(angle.d+omega.d):angledeg.d=angle.d*#RADTODEG 
  With gotvalues 
  BallOuter(2); <- particula externa 
  BallInner(1); <- particula interna 
  EndWith 
  ;;;;;;;;;;;;;;;;;;;;;;;Actualización de las posiciones: 
  M(0)\x+M(0)\mx 
  M(0)\y+M(0)\my 
  M(1)\x+M(1)\mx 
  M(1)\y+M(1)\my 
  M(2)\x+M(2)\mx 
  M(2)\y+M(2)\my 
  ;Screen limits: 
  For t.l=0 To #nummasses-1 Step 2 
    If M(t)\x<0:M(t)\mx=Abs(M(t)\mx):ElseIf M(t)\x>SCREENWIDTH:M(t)\mx=-Abs(M(t)\mx):EndIf 
    If M(t)\y<0:M(t)\my=Abs(M(t)\my):ElseIf M(t)\y>SCREENHEIGHT:M(t)\my=-Abs(M(t)\my):EndIf 
  Next 
  ; 
  If KeyboardReleased(#PB_Key_Space):While KeyboardReleased(#PB_Key_Space)=0:Delay(20):ExamineKeyboard():Wend:EndIf 
  FlipBuffers():Delay(16) 
Until KeyboardPushed(#PB_Key_Escape) 

CloseScreen() 
End 


DisplayAndKeys: 
  StartDrawing(ScreenOutput()) 
  If pos.l=0:BackColor($11cc11):FrontColor(0):Else:BackColor(0):FrontColor($11cc11):EndIf 
  DrawText(0,0,"Capsule: "+Str(M(0)\mass)) 
  If pos.l=1:BackColor($eeddaa):FrontColor(0):Else:BackColor(0):FrontColor($eeddaa):EndIf 
  DrawText(0,20,"Particle1: "+Str(M(1)\mass)) 
  If pos.l=2:BackColor($ddcc88):FrontColor(0):Else:BackColor(0):FrontColor($ddcc88):EndIf 
  DrawText(0,40,"Particle2: "+Str(M(2)\mass)) 
  StopDrawing() 
  ;Keys: 
  If KeyboardReleased(#PB_Key_Up):pos.l-1:If pos.l<0:pos.l=0:EndIf 
  ElseIf KeyboardReleased(#PB_Key_Down):pos.l+1:If pos.l>2:pos.l=2:EndIf 
  ElseIf KeyboardPushed(#PB_Key_Right):M(pos.l)\mass+1 
  ElseIf KeyboardPushed(#PB_Key_Left):M(pos.l)\mass-1:If M(pos.l)\mass<1:M(pos.l)\mass=1:EndIf 
  EndIf 
Return

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP