;******************************************************************************
;*
;* Name   : MiniSnake
;* Author : pcfreak
;* Date   : 2009-06-21
;* Notes  : Up:    5
;*          Down:  2
;*          Left:  1
;*          Right: 3
;*          Quit:  0
;*
;******************************************************************************
w=64:h=48:r=10:NewList s.POINT():Macro r(l):Random(l-3)+1:EndMacro:InitSprite()
Macro z:s():EndMacro:Macro e(v):v#element(z):EndMacro:x=r(w):InitKeyboard()
OpenWindowedScreen(OpenWindow(0,0,0,w*r,h*r,"mSnake"),0,0,w*r,h*r,0,0,0):y=r(h)
e(add):z\x=w/2:z\y=h/2:Repeat:ExamineKeyboard():k.s=KeyboardInkey():e(first)
If k="1":d=3:EndIf:If k="5" Or k="2":d=Val(k):EndIf:If k="3":d=0:EndIf:n=z\x
m=z\y:While e(Next):Swap z\x,n:Swap z\y,m:Wend:e(first):z\x+Cos(d):z\y+Sin(d)
StartDrawing(ScreenOutput()):n=z\x:m=z\y:While e(Next):If z\x=n And z\y=m:End
EndIf:Wend:If n=x And m=y:e(add):z\x=n:x=r(w):y=r(h):z\y=m:EndIf
Box(0,0,w*r,h*r,$C000):ForEach z:Circle(z\x*r,z\y*r,r/2+1,$2D72D2):Next
Circle(x*r,y*r,r/2+1,$FFFFFF):StopDrawing():FlipBuffers():Delay(50):Until k="0"
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 17
; Folding = -
; DisableDebugger