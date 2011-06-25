;*****************************************************************************
;*
;* Name   : 3DCube
;* Author : Petr Vavrin (peterb)
;* Date   : 12.06.09
;* Notes  :
;*
;*****************************************************************************
InitSprite():o=400:OpenWindow(0,0,0,o,o,"3D cube",$C80001):Dim p(o):Dim a.f(o)
Dim l(o):OpenWindowedScreen(WindowID(0),0,0,o,o,1,0,0):Restore t:For c=0 To 5
Read.b d:Read.w e:For m=0 To 3:i=c*4+m:p(i)=(d>>(m*2)&3-1.5)*5:l(i)=e>>(m*4)&15
Next:Next:DataSection:t:Data.l $0c3221ff,$65f31443,$5887cf76,$30625100,$8473
EndDataSection:While WindowEvent()<>16:ClearScreen(0):sc=ScreenOutput():s+255
StartDrawing(sc):v.f+0.05:w.f+0.01:For c=0 To 7:m=c*3:x=p(m):y=p(m+1):z=p(m+2)
g.f=Sin(v)*y+Cos(v)*z:f.f=o/(40-(Cos(w)*g-Sin(w)*x)):a(m)=(Cos(w)*x+Sin(w)*g)
a(m)*f+o/2:a(m+1)=(Cos(v)*y-Sin(v)*z)*f+o/2:Next:For c=0 To 11:m=c*2:i=l(m)*3-3
j=l(m+1)*3-3:For k=1 To 3:LineXY(a(i)+k,a(i+1),a(j)+k,a(j+1),s-k):Next:Next
DrawText(9,9,"Enjoy this 3DCube",s,0):StopDrawing():FlipBuffers():Delay(15):Wend

; IDE Options = PureBasic 4.31 (Windows - x86)
; DisableDebugger