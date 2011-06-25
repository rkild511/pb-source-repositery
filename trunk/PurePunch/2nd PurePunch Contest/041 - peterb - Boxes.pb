;*****************************************************************************
;*
;* Name   : Boxes
;* Author : Petr Vavrin (peterb)
;* Date   : 15.06.09
;* Notes  :
;*
;*****************************************************************************
o=400:q=20:InitSprite():OpenWindow(0,0,0,o,o,"",$C80001):i=WindowID(0)
OpenWindowedScreen(i,0,0,o,o,1,0,0):While WindowEvent()<>16:ClearScreen(0)
StartDrawing(ScreenOutput()):x=q:While x<o:y=q:While y<o:u.f=Sqr(x*x+y*y)
w=q*Sin((2*u-p)/57):Box(x-w/2,y-w/2,w,w,255):y+q:Wend:x+q:Wend:p+4:StopDrawing()
FlipBuffers():Delay(q):Wend

; IDE Options = PureBasic 4.31 (Windows - x86)
; DisableDebugger