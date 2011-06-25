;*****************************************************************************
;*
;* Name   : Dots
;* Author : Petr Vavrin (peterb)
;* Date   : 15.06.09
;* Notes  :
;*
;*****************************************************************************
Macro _(a,b):(Sin(a)+Cos(b)):EndMacro:#p=#PI/180:#n=0.001:k=99:Dim x(k):Dim y(k)
Dim v.f(k):Dim w(k):o=400:InitSprite():OpenWindow(0,0,0,o,o,"",$C80001):s.f=20
h=k:OpenWindowedScreen(WindowID(0),0,0,o,o,1,0,0):While WindowEvent()<>16
ClearScreen(0):StartDrawing(ScreenOutput()):If h=k:e=Random(k):f=Random(k)
g=Random(k):i.f=s-Random(50):h=0:EndIf:h+1:a.f+#n*e:b.f+#n*f:c.f+#n*g:s-i/k
x(0)=_(a,b)*30+o/2:y(0)=_(b,a)*30+o/2:v(0)=c:w(0)=s:l=30:While l:n=l-1:x(l)=x(n)
y(l)=y(n):v(l)=v(n):w(l)=w(n):m=0:While m<360:t.f=m*#p+v(l):u.f=#p-v
Circle(x(l)+_(t,u)*w(l),y(l)+_(u,t)*w(l),10,$ff-(l*8)):m+60:Wend:l-1:Wend
StopDrawing():FlipBuffers():Delay(20):Wend

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger