;*****************************************************************************
;*
;* Name   :Julia Set windowed - windows only
;* Author :Idle
;* Date   :16/06/2009
;* Notes  :Windows Only
;*         ***** > Disable debugger < ***** 
;*        :A / Z = zoom :
;*        :S / X = change Real
;*        :D / C = change Imaginary
;*        :UP / DOWN / LEFT / RIGHT = Move
;*        :Esc = quit   
;*****************************************************************************

Macro _(k):GetAsyncKeyState_(k)&1:EndMacro:Macro e:ElseIf:EndMacro:InitSprite()
Macro ca(a,b):(a-w/2)/(0.5*z*w)+(1/w*(b-(w/2))):EndMacro:Global w=512,z.f=1.0 
Macro F(a,b):For a=0 To b-1:EndMacro:Global cI.f=0.26015,cR.f=-0.72,nR.d,nI.d
Global aR.d,aI.d,px.f=w/2,py.f=px:OpenWindow(0,0,0,w,w,"julia set"):Repeat
StartDrawing(WindowOutput(0)):f(x,w):f(y,w):nR=ca(x,px):nI=ca(y,py):f(i,128)
aR=nR:aI=nI:nR=aR*aR-aI*aI+cR:nI=2*aR*aI+cI:If((nR*nR+nI*nI)>4):Break:EndIf
Next:c=Pow(i,4):Plot(x,y,c):Next:Next:StopDrawing():Delay(20):If _(65):z*2
e _(90):z/2:e _(83):cI+0.001:e _(88):cI-0.001:e _(68):cR+0.001:e _(67)
cR-0.001:e _(39):px+(4/z):e _(37):px-(4/z):e _(38):py-(4/z):e _(40):py+(4/z)
e _(#VK_ESCAPE):q=1:EndIf:Until q=1 Or WindowEvent()=16

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger