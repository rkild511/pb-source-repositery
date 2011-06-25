;*****************************************************************************
;*
;* Name   : PSphere
;* Author : djes
;* Date   : 06/17/2009
;* Notes  : -
;*
;*****************************************************************************
InitSprite():Macro g(t,d):Macro t:d:endmacr:EndMacro:g(d,drawing)o:g(n,Next)o
g(so,ScreenOutput)o:Structure v:x.f:y.f:z.f:c.i:EndStructure:w=511:r=255:k=127
g(q,s())o:g(C(m,l,p),Cos(0.03)*q\m l Sin(0.03)*q\p)o:g(e,EndIf)o:t$="PUREBASIC"
OpenWindow(0,0,0,w,w,""):OpenWindowedScreen(WindowID(0),0,0,w,w,0,0,0)
NewList s.v():LoadFont(1,"Arial",16):Start#D(so()):DrawingFont(FontID(1))
DrawText(10,0,t$,r,0):For y=-r To r:For x=-r To r:z=Sqr($FE01-(x*x)-(y*y))
If z>0:If Point(x&k,y&63)<>0:AddElement(q):If x&1=0:z*-1:e:q\x=x:q\y=y:q\z=z
q\c=-1:e:e:n x:n y:Stop#D():Repeat:FlipBuffer#q:ClearScreen(0):Start#D(so())
ForEach(q):Plot(r+q\x,r+q\y,w):b.f=C(x,-,z):q\z=C(z,+,x):q\x=b:b.f=C(x,-,y)
q\y=C(y,+,x):q\x=b:Plot(r+q\x,r+q\y,q\z):n:Stop#D():Until WindowEvent()=16
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 14
; Folding = -
; DisableDebugger