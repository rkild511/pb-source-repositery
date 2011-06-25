;*****************************************************************************
;*
;* Name   : Taches de Martin
;* Author : Dobro
;* Date   : 23/Juin/2009
;* Notes  : -exit white mouse right button
;*          change screen resolution if the program crashes
;*
;*****************************************************************************
xp=2:yp=2:EX=320:Ey=200:InitSprite():InitMouse():OpenScreen(320,200,32,"")
CreateImage(1,320,200,32):StartDrawing(ImageOutput(1)):For t= 1 To 5000
Circle(Random(EX-1),Random(Ey-1),5,Random (1<<12)):Next:StopDrawing():Repeat
 StartDrawing(ImageOutput(1)):For xp=2 To EX-1:For yp=2 To Ey-1:cs1=Point(xp-1,yp-1)
 cs2=Point(xp+1,yp+1):cs3=Point(xp,yp-1):cs4=Point(xp,yp+1):cs5=Point(xp+1,yp):
 cs6=Point(xp-1,yp):cs7=Point(xp-1,yp+1):cs8=Point(xp+1,yp-1)
 Circle(xp,yp,1,(cs1+cs2+cs3+cs4+cs5+cs6+cs7+cs8)/8):ExamineMouse():
If MouseButton(2):End:EndIf:Next:Next:StopDrawing():
StartDrawing(ScreenOutput()):DrawImage(ImageID(1),0,0):StopDrawing()
FlipBuffers():ForEver


; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 9
; DisableDebugger