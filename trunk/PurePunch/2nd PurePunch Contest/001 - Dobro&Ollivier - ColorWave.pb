;*****************************************************************************
;*
;* Name   : ColorWave
;* Author : Dobro
;* Date   : 06/17/2009
;* Notes  : Right mouse button to quit ! optimisé par Olivier
;*
;*****************************************************************************
Macro S(X,Y):E#X=GetSystemMetrics_(Y):EndMacro:InitSprite():InitMouse():S(X,0)
Macro c:EndIf:EndMacro:S(Y,1):w=OpenWindow(0,0,0,EX,EY,"",$80C80001):CX=(EX)/2
OpenWindowedScreen(w,0,0,EX,EY,1,0,0):V.f=8.2:a.f=0:G.f=$78:p.f=0.3:V.f=2:a.F
L=500:Dim T.l(L):Macro Q(X):Abs(Cos(a+(X))*255):EndMacro:For i=0 To L:D=100
a+(2*#PI/L):T(i)=RGB(Q(4*#PI/6),Q(#PI/3),Q(0)):Next:Repeat:U+Cos(3.6):b+Sin(36)
StartDrawing(ScreenOutput()):a=Sin((x+U)/(L+Sin(x/D)*D))*75+75:For Y=1 To EY-1
U=Cos((Y+b)/(300+Cos(Y/D)*D))*150:E=a+U:E=Abs(E):E%500:E=T(E):i=Y:G+V:If G>120
V=-V:c:If G<-120:V=-0.001:V=-V:c:Macro h(X):Sin((a+i*p*X)*0.0174533)*G
EndMacro:x=CX-300+H(10):Line(x+H(3),Y,L,0,E):Next:ExamineMouse():StopDrawing()
a+V:WindowEvent():FlipBuffers():ClearScreen(0):Until MouseButton(2)

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 5
; Folding = -
; DisableDebugger