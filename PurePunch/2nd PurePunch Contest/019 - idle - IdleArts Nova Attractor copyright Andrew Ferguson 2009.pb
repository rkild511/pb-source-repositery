;*****************************************************************************
;*
;* Name   :IdleArts Nova Attractor copyright Andrew Ferguson 2009
;* Author :andrew ferguson
;* Date   :01/06/2009
;* Notes  :Disable debugger - windows only change value line 16 "1.2" more faster
;*        :and lt=dt+6000 
;*****************************************************************************

Global Dim sr.f(3,2<<14):Macro r(v):Random(v)+1:EndMacro:InitSprite():w=800
l=600:OpenWindow(0,0,0,w,l,""):OpenWindowedScreen(WindowID(0),0,0,w,l,0,0,0)
*px.long:While WindowEvent()!16:StartDrawing(ScreenOutput()):h=DrawingBuffer()
P=DrawingBufferPitch():dt=GetTickCount_():If dt>lt:b=1:ef=R(100):lt=dt+6000
EndIf:For a=1 To 2<<14:If b:ix=R(w):sr(0,a)=ix:iy=R(w):sr(1,a)=iy
sr(2,a)=1/Sqr(ix*ix+iy*iy):EndIf:x.f=sr(0,a):y.f=sr(1,a):z.f=Sqr(x*x+y*y)
m.f=sr(2,a)*z* 1.2 :px=(400+(Sin(x)+Cos(y))*m):py=(300+(Cos(x)-Sin(y))*m)
sr(0,a)+(px/ef):sr(1,a)+(py/ef):sr(2,a)+1/z:If px>1 And py>1:If px<w And py<l
c=m:of=(px*4+(py*p)):*px=h+of:*px\l+RGB(c,c*0.4,c*0.2):rt=0:EndIf:EndIf
Next:b=0:StopDrawing():FlipBuffers():ClearScreen(RGB(0,0,0)):Delay(20):Wend 
; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger