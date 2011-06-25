;*****************************************************************************
;*
;* Name   : Pixels Emboss
;* Author : eddy r.
;* Date   : 05.06.09
;* Notes  : r=radius w=screenwidth - atan2 short version
;*
;*****************************************************************************
r.f=200:w.f=600:Procedure.f atan2(y.f,x.f):a.f=2*ATan(y/(Sqr(x*x+y*y)+x))
ProcedureReturn a:EndProcedure:InitSprite():OpenWindow(0,0,0,w,w,"",$C80001)
ww=(w-1):OpenWindowedScreen(WindowID(0),0,0,w,w,0,0,0):Repeat:ClearScreen(0)
StartDrawing(ScreenOutput()):x=WindowMouseX(0):y=WindowMouseY(0):For j=0 To 60
For i=0 To 60:u.f=i*10:v.f=j*10:m.f=(u-x):n.f=(v-y):d.f=Sqr(m*m+n*n)
If d<r:d=0.5*r*Sin(0.5*#PI*(1+d/r)):a.f=ATan2(n,m):du=Cos(a)*d
dv=Sin(a)*d:u+du:v+dv:EndIf:If u>0 And u<ww And v>0 And v<ww:Plot(u,v,$FF)
EndIf:Next:Next:StopDrawing():FlipBuffers(0):Until WindowEvent()=16
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 2
; Folding = -
; DisableDebugger