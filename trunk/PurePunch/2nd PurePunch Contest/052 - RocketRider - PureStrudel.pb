;*****************************************************************************
;*
;* Name   : PureStrudel
;* Author : RocketRider
;* Date   : 04.06.09
;* Notes  : Disable debugger, use DirectX 9 Subsystem
;*
;*****************************************************************************
InitSprite():OpenWindow(0,0,0,600,600,"",13107201)
OpenWindowedScreen(WindowID(0),0,0,600,600,0,0,0)
Repeat:x=300:y=300:a+1:StartDrawing(ScreenOutput())
For i=1 To 90000 Step 2
x+Sin(i+5.8)*i/100:y+Cos(i)*i/100:x2=x+Sin(i)*1000:y2=y+Cos(i)*1000:i2=Sqr(i)+a
i3.f=Sin((i+a)/100)*1.5
LineXY(x,y,x2,y2,RGB(128+Sin(i2)*10*i3,128+Sin(i2)*10*i3,128+Sin(i2)*10*i3))
Next:StopDrawing():FlipBuffers(0):Until WindowEvent() = 16
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 15
; SubSystem = DirectX9
; DisableDebugger