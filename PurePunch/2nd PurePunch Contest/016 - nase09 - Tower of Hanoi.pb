;*****************************************************************************
;*
;* Name   : Tower of Hanoi
;* Author : nase09
;* Date   : 23 June 2009
;* Notes  : s=Number of Stones (up to 60 recommended, solves only <64!) 
;*          p=moving speed (e.g. set to 600 for slow,150 For fast,0 for fun)
;*
;*****************************************************************************
s=12 :p=300 :InitSprite():OpenWindow(0,0,0,800,680,""):Dim t(2):Dim h(2):h(0)=s
OpenWindowedScreen(WindowID(0),0,0,800,680,0,0,0):Dim b(s):Dim p(s):Dim i(2,s-1)
Dim y(s):For d=0 To s-1:i(0,d)=d+1:b(d+1)=d*(124/s):y(d+1)=d:k=30:Next:If s%2=0
t(1)=2:t(2)=1:Else:t(1)=1:t(2)=2:EndIf:f=$4646:x.q=1:If s>20:k=640/s:EndIf
Repeat:q=t((x&(x-1))%3):z=t((x|(x-1)+1)%3):d=h(z):i(z,d)=i(q,h(q)-1):p(i(z,d))=z
y(i(z,d))=d:h(q)-1:h(z)+1:r=260:ClearScreen(0):StartDrawing(ScreenOutput())
For d=0 To 2:Box(6+d*r,672,257,4,f):Box(134+d*r,672,2,-k*s-4,f+23)
Next:For d=1 To s:u=b(d):Box(10+p(d)*r+u,671-y(d)*k,250-u-u,-k+1,182)
Box(12+p(d)*r+u,669-y(d)*k,246-u-u,-k+5,234):Next:StopDrawing():FlipBuffers()
Delay(p):x+1:Until WindowEvent()=16 Or x>1<<s-1
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; DisableDebugger