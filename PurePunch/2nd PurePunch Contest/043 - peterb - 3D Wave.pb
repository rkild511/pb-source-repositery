;*****************************************************************************
;*
;* Name   : 3D Wave
;* Author : Petr Vavrin (peterb)
;* Date   : 14.06.09
;* Notes  :
;*
;*****************************************************************************
Macro _(u,v):If u<28:LineXY(a(c),a(c+1),a(c+v),a(c+v+1),b(c)):EndIf:EndMacro:k.f
o=500:InitSprite():OpenWindow(0,0,0,o,o,""):Dim a(5*o):Dim b(5*o):s=WindowID(0)
OpenWindowedScreen(s,0,0,o,o,1,0,0):l=99:While WindowEvent()<>16:ClearScreen(0)
StartDrawing(ScreenOutput()):If l=99:h=Random(2):i=k-Random(40):j=a.f-Random(8)
l=0:EndIf:a-j/99:k-i/99:l+1:v.f+0.01:w.f+0.003:y=-30:While y<30:x=-30:While x<30
z.f=a*Sin((k*Sqr(x*x+y*y)-p)/57):g.f=Sin(v)*y+Cos(v)*z:cw.f=Cos(w):sw.f=Sin(w)
f.f=o/(99-(cw*g-sw*x)):r=(z+a)*127/a:b(m)=r<<(8*h):a(m)=(cw*x+sw*g)*f+o/2
a(m+1)=(Cos(v)*y-Sin(v)*z)*f+o/2:m+2:x+2:Wend:y+2:Wend:p+9:m=0:For u=1 To 28
For t=1 To 28:c=(t+u*30)*2:_(t,2):_(u,60):Next:Next:StopDrawing():FlipBuffers()
Delay(20):Wend

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 11
; Folding = -
; DisableDebugger