;*****************************************************************************
;*
;* Name   : µRay
;* Author : Hades
;* Date   : 01-05/06/2009
;* Notes  : Change variable 's' for other resolutions.
;*
;*****************************************************************************

s=700:m=s/2:OpenWindow(0,0,0,s,s,"µRay"):Macro IS:w-4:d=Sqr(x*x+y*y+z*z):x/d:y/d
u-j:z/d:d=x*u+y*v+z*w:q=d*d-u*u-v*v-w*w+1:If q>0:e=1:p=-d-Sqr(q):EndIf:EndMacro
StartDrawing(WindowOutput(0)):t=16:Define.f:f=0.9:Macro F(v,e):For v.l=0 To e-1
EndMacro:l=0.577:j=0.2:F(sy,s):F(sx,s):r=0:g=0:b=0:F(k,t):F(i,t):c=f:u=0:v=0:e=0
x=sx+k/t-m:y=sy+i/t-m:z=s:w=0:IS:If e:o=y*p:n=x*p-j:h=z*p-4:d=n*l-o*l-h*l:If d<0
d=0:EndIf:p=2*d:x*(l-p*n)-y*(l+p*o)-z*(l+p*h):n*4:h*4:a.l=n:q=j*(1-o):o*4:n-a
a=o:o-a:a=h:h-a:n*n+o*o+h*h:a=9*n:c*(d*(1-q)+q):If a=3:x=0.8*Pow(x,9):r+x:g+x
b+x:c*j:EndIf:Else:If y>0:u=x/y:w=z/y:y=i/200-l:a=u+l:a+w:a&1:x=l+k/200:v=1
z=-l:c-0.8*a:IS:c*(1-e+e*p/t):g+c:b+c:Else:b+c:c*(1+y):c*c*c:g+c:EndIf:EndIf:r+c
Next:Next:Plot(sx,sy,RGB(r,g,b)):Next:Next:While WindowEvent()!t:Delay(50):Wend
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 8
; Folding = -
; DisableDebugger