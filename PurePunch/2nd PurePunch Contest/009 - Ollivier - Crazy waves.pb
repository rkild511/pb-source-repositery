;*****************************************************************************
;*
;* Name   : Crazy waves
;* Author : Ollivier
;* Date   : 02/06/09
;* Notes  : Cf http://www.purebasic.fr/french/viewtopic.php?t=9437
;*
;*****************************************************************************
Q=600:Dim SX.F(Q):Dim SY.F(Q):Dim SA.F(Q):Dim SR.F(Q):#Z=4:Dim SV.F(Q)
InitSprite():#N=3:InitMouse():#B=2:ExamineDesktops():DW=DesktopWidth(0)
DH=DesktopHeight(0):OpenScreen(DW,DH,DesktopDepth(0),""):CreateSprite(0,DW,DH)
CreateSprite(1,#Z,#Z):StartDrawing(SpriteOutput(1)):Box(0, 0, #Z, #Z,#White)
StopDrawing():X.F=SX(0):Y.F=SY(0):For CA=0 To Q:SX(CA)=DW/2:SY(CA)=DH/2
SA(CA)=Random(628)/100:SV(CA)=Random(800)/100:Next CA:Repeat:Delay(1)
ExamineMouse():FlipBuffers():DisplaySprite(0,0,0):For I=0 To Q:X=SX(I):Y=SY(I)
DisplaySprite(1,X,Y):DX.F=(4999*X+DW/2)/5000:DY.F=(4999*Y+DH/2)/5000
V.F=Sqr(DX*DX+DY*DY):VS.F=SV(I)*(100/V):SX(I)=DX+(Cos(SA(I))*VS):SR(I)+0.0001
SY(I)=DY-(Sin(SA(I))*VS):SA(I)+Sin(SR(I))*(10/V):Next:Until MouseButton(2)
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 17
; DisableDebugger