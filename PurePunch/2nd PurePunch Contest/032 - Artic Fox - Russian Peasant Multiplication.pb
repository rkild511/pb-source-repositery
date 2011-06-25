;*****************************************************************************
;*
;* Name   : Russian Peasant Multiplication
;* Author : Arctic Fox
;* Date   : 20/06/2009
;* Notes  : Read about the algorithm here: http://mathforum.org/dr.math/faq/faq.peasant.html
;*          Should run on all platforms, but only tested on Windows
;*
;*****************************************************************************
OpenWindow(0,0,0,300,300,"Russian Peasant Multiplication",$C80001):n=15:Dim n(n)
Dim s(n):n(0)=Random(999):s(0)=Random(999):StartDrawing(WindowOutput(0)):Macro Z
Str:EndMacro:DrawingMode(1):c=#White:FillArea(0,0,-1,c):a$=Z(n(0))+" × "+Z(s(0))
a$+"  = "+Z(n(0)*s(0)):DrawText(5,5,a$):Line(5,25,290,0):While s(a)>0:n$=Z(n(a))
s$=Z(s(a)):n(a+1)=n(a)*2:DrawText(5,a*20+30,n$):DrawText(105,a*20+30,s$)
s(a+1)=Int(s(a)/2):a+1:Delay(250):Wend:n=a:Delay(1000):For x=0 To n
If Right(Bin(s(x)),1)="0":Delay(400):Box(5,x*20+30,300,20,c):EndIf:Next
a$="= " + Z(n(0)*s(0)):DrawText(5,n*20+40,a$):Line(5,n*20+35,290,0)
a=TextWidth(a$):Line(5,n*20+60,a,0):Line(5,n*20+62,a,0):StopDrawing():Repeat
Until WaitWindowEvent()=16:End
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; Folding = -
; DisableDebugger