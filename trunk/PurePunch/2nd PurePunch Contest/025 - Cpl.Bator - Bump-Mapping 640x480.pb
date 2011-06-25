;*****************************************************************************
;*
;* Name   : Bump-Mapping 640x480
;* Author : Cpl.Bator
;* Date   : 2/06/2009
;* Notes  : Tested on linux , program quit automatically
;*
;*****************************************************************************
Macro R:For:EndMacro:Macro T:Next:EndMacro:S=512:W=640:H=480:W2=320:H2=240
Macro N:EndIf:EndMacro:InitSprite():OpenScreen(W,H,32,""):Dim L(S,S):g=64
R y=0 To S:R x=0 To S:Nxl.f=(x-(S/2))/(S/4):Nyl.f=(y-(S/2))/(S/4):Nzl.f:v.f
Nzl=1-Sqr((Nxl*Nxl)+(Nyl*Nyl)):If Nzl<=0:Nzl=0:N:L(x,y)=(200 * NZl):T x:T y
Dim B(1000,1000):R i = 0 To 79:R y= 0 To 63:R x= 0 To 63:C=(x*256/g)!(y*256/g)
B(x+dx,y+dy)=RGB(C,C,C):T:T:dx+g:If dx=W:dx=0:dy+g:N:T:Repeat:ClearScreen(0)
v+0.1:LX.f=W2+160*Cos(v):LY.f=H2+120*Sin(v/2):StartDrawing(ScreenOutput())
R y=1 To 479:R x=1 To 639:NX=(B(x+1,y)-B(x-1,y)):NY=(B(x,y+1)-B(x,y-1))
NLX.f=X-LX:NLY.f=Y-LY:NX=(NX+NLX)+(S/2):NY=(NY+NLY)+(S/2):NX%512:NY%512
C=L(NX,NY)<<8:Plot(x,y,C):T x:T y:StopDrawing():FlipBuffers():Until v>50
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 17
; Folding = -
; DisableDebugger