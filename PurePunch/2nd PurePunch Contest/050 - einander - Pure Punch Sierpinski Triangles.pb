;*****************************************************************************
;*
;* Name : Pure Punch Sierpinski Triangles
;* Author : einander
;* Date : 05.06.09
;* Notes : resizeable window
;*
;*****************************************************************************
OpenWindow(0,0,0,800,600,"Pure Punch Sierpinski Triangles",$CC0001)
StartDrawing(WindowOutput(0)):Repeat:W=WindowWidth(0):H=WindowHeight(0)
A=Random(255):b=Random(255):c=Random(255):d=Random(#White):For X=0 To W-1
If WaitWindowEvent(0)=16:End:EndIf:LineXY(X,0,X,H,d):For Y=0 To H-1:R=X&Y:If A<b
If R=X:Plot(X,Y,RGB(A,b,c)):EndIf:EndIf:If b<c:If R=Y:Plot(W-X,Y,RGB(b,c,A))
EndIf:EndIf:If c<d:For i=0 To c:If A&1:If R =i:Plot(X-i,H-Y,d):EndIf:Else:If R=i
Plot(X-i,Y,d):EndIf:EndIf:Next:EndIf:For i=c/3 To 255:If b&1:If R=i
Plot(W-X,Y,RGB(i,A,b)):EndIf:Else:If R=i:Plot(X,H-Y,RGB(b,i,A)):EndIf:EndIf:Next
Next:Next:ForEver
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 8
; DisableDebugger