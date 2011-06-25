;*****************************************************************************
;*
;* Name   : text effect
;* Author : Dobro
;* Date   : 20/Juin/2009
;* Notes  : -
;*
;*****************************************************************************
LoadFont(1,"arial",50,512):InitSprite():AM=2:Ts.s="Pure Basic":
WD=OpenWindow(1,50,50,640,200,"",13238272)
OpenWindowedScreen(WD,0,0,640,200,1,0,0):CreateImage(100,640,100)
StartDrawing( ImageOutput(100)):FrontColor($FFFF00):BackColor(0)
DrawingFont(FontID(1)):DrawingMode(1):DrawText(0,0,Ts.s):StopDrawing()
For t=0 To 100:GrabImage(100,t,0,t,640,1):Next:Repeat
StartDrawing(ScreenOutput()):DrawingMode(1):For Y= 0 To 100
DrawingFont(FontID(1)):FrontColor($BA2595):DrawText(40,0,Ts.s):a+1:If a=360*10
a=0 :EndIf:x+(Sin(a*2*3.1415926/50)*AM):DrawImage(ImageID(Y),x+Y,Y+50,640,1)
Next:StopDrawing():FlipBuffers():EV=WindowEvent():Until EV=16
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 11
; DisableDebugger