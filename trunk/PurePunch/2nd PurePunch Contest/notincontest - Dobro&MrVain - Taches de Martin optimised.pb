
; Original version by dobro
; Optimized version by 'thorsten will' aka 'mr.vain of secretly!'
;
InitSprite():w=640:Dim D(w,480):OpenScreen(w,480,32,""):Repeat:d=ScreenOutput()
StartDrawing(d):h=480:If i=0:For i=1 To w<<4:a=Random(w-1):b=Random(h-1)
Circle(a,b,5,Random(4096)):Next:For x=0 To w-1:For y=0 To h-1:d(x,y)=Point(x,y)
Next:Next:EndIf:For x=1 To w-2:For y=1 To h-2:t=D(x-1,y-1)+D(x+1,y+1)+D(x,y-1)
t+D(x,y+1)+D(x+1,y)+D(x-1,y)+D(x-1,y+1)+D(x+1,y-1):t/8:Plot(x,y,t):D(x,y)=t:Next
Next:StopDrawing():FlipBuffers():Until GetAsyncKeyState_(27)

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 10