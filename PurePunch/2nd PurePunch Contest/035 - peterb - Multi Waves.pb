;*****************************************************************************
;*
;* Name   : Multi Waves
;* Author : Petr Vavrin (peterb)
;* Date   : 18.06.09
;* Notes  :
;*
;*****************************************************************************
Macro q:Random(96)-48:EndMacro:Macro r:Random(10)+1:EndMacro:Dim u(9999):o=400
Macro _(a):LineXY(u(e),u(e+1),u(e+a),u(e+a+1),v(e)<<16):EndMacro:InitSprite()
n=60:OpenWindow(0,0,0,o,o,""):OpenWindowedScreen(WindowID(0),0,0,o,o,1,0,0)
Dim v(9999):While WindowEvent()<>16:If l=0:h=q:oy=q:j=q:ny=q:c=r:a=r:d=r:b=r:p=0
l=300:EndIf:l-1:ClearScreen(0):StartDrawing(ScreenOutput()):m=0:y=-n:While y<n
x=-n:i=y-oy:i*i:k=y-ny:k*k:While x<n:s=x-h:z.f=a*Sin((c*Sqr(s*s+i)-p)/57):s=x-j
f.f=d*Sqr(s*s+k)-p:z+b*Sin(f/57):v(m)=(z+a+b)*127/(a+b):z*0.7:yy.f=0.7*y
f=o/(90-(yy+z)):u(m)=x*f+200:u(m+1)=(yy-z)*f+130:m+2:x+2:Wend:y+2:Wend:p+9:s=1
While s<59:t=1:While t<59:e=(t+s*n)*2:If t<58:_(2):EndIf:If s<58:_(120):EndIf
t+2:Wend:s+2:Wend:StopDrawing():FlipBuffers():Delay(20):Wend

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger