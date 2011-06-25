;*****************************************************************************
;*
;* Name   : Star field
;* Author : Dobro (il reste plus grand chose de mon code LOL)
;* Date   : 20/Juin/2009
;* Notes  : optimisé par Tonton
;*
;*****************************************************************************

k=255:x=k*4:InitSprite():D=OpenWindow(1,0,0,x,x,"",$80C80001):n=5*x:Dim f(n)
Dim g(n):u=10*x:k=u/2:w=2*x:l=10:p=-l:g=x/2:OpenWindowedScreen(D,0,0,x,x,1,1,1)
Dim h(n):Macro z:f(i)=Random(u)-k:g(i)=Random(u)-k:EndMacro:For i=0 To n:M=60
  h(i)=Random(w):z:Next:Repeat:StartDrawing(ScreenOutput()):Box(0,0,x,x)
    For i=0 To n:h(i)+p:If h(i)<l:h(i)=w:EndIf:c=(f(i)*M)/h(i)+g:D=(-g(i)*M)/h(i)+g
Circle(c,D,1,Random(1<<24)):Next:StopDrawing():FlipBuffers():Until WindowEvent()=16 
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 6
; Folding = -
; DisableDebugger