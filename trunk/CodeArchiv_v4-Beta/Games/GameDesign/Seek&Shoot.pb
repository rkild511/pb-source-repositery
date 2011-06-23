; English forum: http://www.purebasic.fr/english/viewtopic.php?t=17322
; Author: Psychophanta (updated for PB 4.00 by Andre)
; Date: 23. October 2005
; OS: Windows
; Demo: No

; I am making a program to calculate speed and direction of an object in 3D space to 
; reach an astro orbit. 
; I've made lots of things related to this. 
; You can try this elliptical particle movement and push LMB to reach it in 2 seconds 
; (or the time you choose). The calculations are done in 3D, but it is displayed in 2D. 

;****************************************************** 
;Seek & Shoot to elliptic way moving object (in 3D space): 
;****************************************************** 
#DEGTORAD=0.01745329:#RADTODEG=57.2957795 
#objradius=2:#refresh=60:#dly=16 
#cursorradius=8:#Explosionsize=21 
DefType .f 
projspeed.f=5;<-rectilineus and constant speed for projectiles 
MainAxisx.f=341:MainAxisy.f=0:MainAxisz.f=0 
SecAxisx.f=0:SecAxisy.f=123:SecAxisz.f=0 
phi.f=0; <- circular rotation angle 
omega.f=0.0581333 ; <- circular rotation speed (angular speed) 
time.f=2*#refresh 
; 
Procedure.b Collision(p1x.f,p1y.f,p1z.f,m1x.f,m1y.f,m1z.f,p2x.f,p2y.f,p2z.f,m2x.f,m2y.f,m2z.f) 
  w.f=#objradius 
  p1xp.f=p1x+w:p1xm.f=p1x-w:p1yp.f=p1y+w:p1ym.f=p1y-w:p2xp.f=p2x+w:p2xm.f=p2x-w:p2yp.f=p2y+w:p2ym.f=p2y-w 
  p1zp.f=p1z+w:p1zm.f=p1z-w:p2zp.f=p2z+w:p2zm.f=p2z-w 
  If ((p1zm<=p2zp And p1zp>=p2zm+m2z) Or (p1zp>=p2zm And p1zm<=p2zp+m2z)) Or ((p2zm<=p1zp And p2zp>=p1zm+m1z) Or (p2zp>=p1zm And p2zm<=p1zp+m1z)) 
    If ((p1xm<=p2xp And p1xp>=p2xm+m2x) Or (p1xp>=p2xm And p1xm<=p2xp+m2x)) And ((p1ym<=p2yp And p1yp>=p2ym+m2y) Or (p1yp>=p2ym And p1ym<=p2yp+m2y)) 
      ProcedureReturn 1 
    EndIf 
    If ((p2xm<=p1xp And p2xp>=p1xm+m1x) Or (p2xp>=p1xm And p2xm<=p1xp+m1x)) And ((p2ym<=p1yp And p2yp>=p1ym+m1y) Or (p2yp>=p1ym And p2ym<=p1yp+m1y)) 
      ProcedureReturn 1 
    EndIf 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

;-INITS: 
bitplanes.b=32 
SCREENWIDTH.l=GetSystemMetrics_(#SM_CXSCREEN):SCREENHEIGHT.l=GetSystemMetrics_(#SM_CYSCREEN) 
If InitMouse()=0 Or InitSprite()=0 Or InitKeyboard()=0 
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
; 
CreateSprite(0,16,16);<-The mouse cursor 
StartDrawing(SpriteOutput(0)):BackColor(RGB(0,0,0)) 
Line(0,0,15,10,$CABE2A) 
Line(0,0,5,15,$CABE2A) 
LineXY(5,15,15,10,$CABE2A) 
FillArea(2,2,$CABE2A,$C0C1D0) 
StopDrawing() 
CreateSprite(1,#objradius*2,#objradius*2);<-the object 
StartDrawing(SpriteOutput(1)):BackColor(RGB(0,0,0))
Circle(#objradius,#objradius,#objradius,$50F0CA) 
StopDrawing() 
; 
ox.f=SCREENWIDTH.l/2:oy.f=SCREENHEIGHT.l/2:oz.f=0; <- geometrical center of ellipse 
MainAxisMod.f=Sqr(MainAxisx.f*MainAxisx.f+MainAxisy.f*MainAxisy.f+MainAxisz.f*MainAxisz.f); <- radius 0 (a.k.a. semiaxis) and its length (modulo) 
SecAxisMod.f=Sqr(SecAxisx.f*SecAxisx.f+SecAxisy.f*SecAxisy.f+SecAxisz.f*SecAxisz.f); <- radius 1 (a.k.a. semiaxis) and its length (modulo) 
;Positionate both Focuses of the ellipse: 
If SecAxisMod.f>MainAxisMod.f; <- it this is true, it means MAIN AXIS (where the Focuses are posistionated) SECONDARY AXIS must be swapped 
  xch.f=SecAxisMod.f:SecAxisMod.f=MainAxisMod.f:MainAxisMod.f=xch.f; <- Swap it 
  xch.f=SecAxisx.f:SecAxisx.f=MainAxisx.f:MainAxisx.f=xch.f; <- Swap it 
  xch.f=SecAxisy.f:SecAxisy.f=MainAxisy.f:MainAxisy.f=xch.f; <- Swap it 
  xch.f=SecAxisz.f:SecAxisz.f=MainAxisz.f:MainAxisz.f=xch.f; <- Swap it 
EndIf 
; 
MouseLocate(ox.f,oy.f); <- lets locate mouse cursor just in the geometrical center of the ellipse 
;-MAIN: 
Repeat 
  ExamineKeyboard():ExamineMouse() 
  x.f=MouseX():y.f=MouseY():z.f=0 
  targetoldx.f=targetx.f:targetoldy.f=targety.f:targetoldz.f=targetz.f 
  vx.f=MainAxisx.f*Cos(phi)+SecAxisx.f*Sin(phi):vy.f=MainAxisy.f*Cos(phi)+SecAxisy.f*Sin(phi):vz.f=0 
  targetx.f=ox.f+vx.f:targety.f=oy.f+vy.f:targetz.f=oz.f-vz.f 
  targetmx.f=targetx.f-targetoldx.f:targetmy.f=targety.f-targetoldy.f:targetmz.f=targetz.f-targetoldz.f 
  ClearScreen(RGB(0,0,0))
  If MouseButton(1) And shot.b=0 
    shot.b=1 
    shotx.f=x.f:shoty.f=y.f:shotz.f=z.f 
    wx.f=MouseDeltaX():wy.f=MouseDeltaY():wz.f=0; <- speed vector of the base before launch projectile 
    Gosub shot;<-shot to it 
  EndIf 
  ; 
  If shot.b:Gosub moveshot:EndIf 
  If collide.b:Gosub boom:EndIf 
  ; 
  DisplayTransparentSprite(1,targetx.f-#objradius,targety.f-#objradius) 
  DisplayTransparentSprite(0,x.f,y.f);draw mouse pointer sprite 
  phi.f+omega.f:If phi>=#PI:phi-2*#PI:EndIf 
  FlipBuffers():Delay(#dly);<--swap buffers 
Until KeyboardPushed(#PB_Key_Escape) 
ReleaseMouse(1):CloseScreen():End 
;-Subroutines: 
shot:; FIXED TIME ALGORITHM: 
  dx.f=ox-x:dy.f=oy-y:dz.f=oz-z 
  shotmx.f=(dx+MainAxisx.f*Cos(omega.f*time+phi)+SecAxisx.f*Sin(omega.f*time+phi))/time 
  shotmy.f=(dy+MainAxisy.f*Cos(omega.f*time+phi)+SecAxisy.f*Sin(omega.f*time+phi))/time 
  shotmz.f=(dz+MainAxisz.f*Cos(omega.f*time+phi)+SecAxisz.f*Sin(omega.f*time+phi))/time 
  initcount.l=ElapsedMilliseconds() 
Return 
moveshot: 
  If shotx.f>SCREENWIDTH.l Or shotx.f<0 Or shoty.f>SCREENHEIGHT.l Or shoty.f<0:shot.b=0:Return:EndIf 
  DisplayTransparentSprite(1,shotx.f-#objradius,shoty.f-#objradius);draw our projectile sprite 
  timecount.f=(ElapsedMilliseconds()-initcount.l)/1000 
  If Collision(targetx.f,targety.f,targetz.f,targetmx.f,targetmy.f,targetmz.f,shotx.f,shoty.f,shotz.f,shotmx.f,shotmy.f,shotmz.f) 
    shot.b=0:shotmx.f=0:shotmy.f=0:shotmz.f=0 
    collide.b=#objradius 
    collx.f=targetx.f:colly.f=targety.f:collmx.f=targetmx.f/3:collmy.f=targetmy.f/3 
  Else 
    shotx.f+shotmx.f 
    shoty.f+shotmy.f 
    shotz.f+shotmz.f 
  EndIf 
Return 
boom: 
  If collide.b<=#Explosionsize 
    StartDrawing(ScreenOutput()) 
    Circle(collx.f,colly.f,collide.b,$FFFFFF) 
    StopDrawing() 
    collx.f+collmx.f:colly.f+collmy.f 
    collide.b+1 
  Else 
    StartDrawing(ScreenOutput()) 
    Circle(collx.f,colly.f,#Explosionsize*2-collide.b,$0F0FFF) 
    StopDrawing() 
    collx.f+collmx.f/2:colly.f+collmy.f/2 
    collide.b+1:If collide.b>=#Explosionsize*2:collide.b=0:EndIf 
  EndIf 
Return 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP