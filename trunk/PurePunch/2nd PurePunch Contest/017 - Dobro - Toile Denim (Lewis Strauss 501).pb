;*****************************************************************************
;*
;* Name   : Toile Denim (Lewis Strauss 501)
;* Author : Dobro
;* Date   : 24/Juin/2009
;* Notes  : -exit white mouse right button
;*
;*****************************************************************************
t$="-1,-1,0,-1,+1,-1,-1,0,+1,0,-1,+1,0,+1,+1,+1,0,0,0,0"
xp=2:yp=2:EX=640:Ey=480:InitSprite():InitMouse():OpenScreen(EX,Ey,32,"")
CreateImage(1,EX,Ey,32):StartDrawing(ImageOutput(1)):For t= 1 To 4096
Circle(Random(EX-1),Random(Ey-1),5,Random (255)):Next:StopDrawing():Repeat
 If oo=0:For xp =2 To EX-2:StartDrawing(ImageOutput(1)):For yp=2 To Ey-2
 For x=1 To 4 Step 2:a1=Val(StringField(t$,x,",")):
a2=Val(StringField(t$,x+1,",")):p=p+(Point(xp+a1,yp+a2)):Next:p=p/2:
Circle(xp,yp,2,p):Next:StopDrawing():StartDrawing(ScreenOutput()):
DrawImage(ImageID(1),0,0):StopDrawing():FlipBuffers():Next:oo=1:EndIf
ExamineMouse():If MouseButton(2):End:EndIf:ForEver

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; DisableDebugger