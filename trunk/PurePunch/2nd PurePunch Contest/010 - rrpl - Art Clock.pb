;*****************************************************************************
;*
;* Name   : Art Clock
;* Author : rrpl
;* Date   : 30 June 09
;* Notes  : Well yes it a clock - 'art' is timed to the seconds count
;*
;*****************************************************************************
l=200:m=100:W=OpenWindow(0,200,200,l,m,"Art Clock",$CC0001):InitSprite()
OpenWindowedScreen(W, 0,0, l, m, 1, 0, 0):SetTimer_(W,1,1000,0):Procedure z(v)
v=Random(v):ProcedureReturn v:EndProcedure:Procedure a():g=z(24):h=z(18)
x=z(200-g):y=z(170-h):b=z(255):g=z(255):r=z(255):Ellipse(g,h,x,y,RGB(r,g,b))
EndProcedure:Procedure u(f):For k=0 To f:a():Next:EndProcedure
ClearScreen($bbbbbb):Repeat:n=Date():e=WaitWindowEvent():If e= 16:End
ElseIf e=#WM_TIMER:If EventwParam()=1:d.s=FormatDate("%dd/%mm/%yyyy",n)
t.s=FormatDate("%hh:%ii:%ss",n):StartDrawing(ScreenOutput()):u(1)
Box(40,30, 120, 37 ,$FFFFFF):DrawText(40,30," Date: "+d):
DrawText(40,50," Time: "+t+" "):StopDrawing():EndIf:EndIf:FlipBuffers():ForEver

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger