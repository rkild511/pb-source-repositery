;*****************************************************************************
;*
;* Name   :Julia Set Full Screen cross platform
;* Author :Idle & PeterB
;* Date   :16/06/2009
;* Notes  :Not Windows Only
;*         ***** > Disable debugger < ***** 
;*        :A / Z = zoom :
;*        :S / X = change Real
;*        :D / C = change Imaginary
;*        :UP / DOWN / LEFT / RIGHT = Move
;*        :Esc = quit   
;*****************************************************************************

Macro _(k):ElseIf KeyboardPushed(k):ch=1:EndMacro:Macro F(a,b):For a=0 To b-1
EndMacro:InitSprite():InitKeyboard():cI.f=0.26015:cR.f=-0.72:a.f=0.001:h=600
w=800:h2=h/2:w2=w/2:s.f=w2:t.f=h/2:z.f=1:OpenScreen(w,h,32,""):ch=1:Repeat
ExamineKeyboard():If ch:StartDrawing(ScreenOutput()):v1.f=z*w2:v2.f=z*h2
u1.f=1/w*(s-w2):u2.f=1/h*(t-h2):f(x,w):f(y,h):R.f=(x-w2)/v1+u1:I.f=(y-h2)/v2+u2
f(j,128):aR.f=R:aI.f=I:R=aR*aR-aI*aI+cR:I=2*aR*aI+cI:If R*R+I*I>4:Break:EndIf
Next:Plot(x,y,Pow(j,4)):Next:Next:StopDrawing():FlipBuffers():ClearScreen(0)
ch=0:EndIf:Delay(5):If 1=2:_(30):z*2:_(44):z/2:_(31):cI+a:_(45):cI-a:_(32):cR+a
_(46):cR-a:_(205):s+(4/z):_(203):s-(4/z):_(200):t-(4/z):_(208):t+(4/z):_(1):q=1
EndIf:Until q=1

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger