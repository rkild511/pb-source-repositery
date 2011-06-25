
;*****************************************************************************
;*
;* Name   : DemoManiac - small multipart intro (Windows only!)
;* Author : Thorsten Will - aka 'Mr.Vain of Secretly!'
;* Date   : 23.06.2009
;* Notes  : Entry for the PurePunch Contest #2
;*          The rule is to code something in max 10 lines of 80 characters!
;*          I tried to code a small multipart intro with timing and music! ^^
;*          Win32 API has been used for timing, because smaller as pb commands.
;*
;*          This intro features:
;*              - blue background noise
;*              - colorful XOr pattern
;*              - fractal (flipping and zooming while transforming)
;*              - abstract moving lines (changing color)
;*              - background music (timing with fx isnt nice nor easy this way)
;*              - flashing text
;*              - auto exit
;*
;*          P L E A S E   D I S A B L E   T H E   D E B U G G E R  !!!
;*
;*****************************************************************************
s=timeGetTime_():InitMovie():LoadMovie(0,"c:\windows\media\onestop.mid"):b=255
InitSprite():OpenScreen(640,480,32,""):PlayMovie(0,0):Repeat:r=ScreenOutput()
StartDrawing(r):e=(timeGetTime_()-s)/100:t.f+0.05:For m=0 To 639:For n=0 To 479
g=64:Plot(m,n,(g+Random(g))<<16):d=826:w=Sin(t)*b:If e>=0 And e<152:h=Cos(t)*b
ElseIf e>152 And e<393:h=w:EndIf:q.f=(n-b)/h:p.f=(m-b)/w:x.f=0:y.f=t/21:z=100
For i=1 To 24:u.f=x*x-y*y+p:v.f=2*x*y+q:If u*u+v*v>4:Goto E:EndIf:x=u:y=v:Next
Plot(m,n,RGB(m!n,96,m*n/740)):E:o=$FF:Next:Next:If e>393 And e<665:For i=0 To b
x=Cos(l.f):y=Sin(l):m=z*-Sin(i+(x*z))+c:g=c*Sin(i+(x*c))+b+c:n=z*-Cos(i+(y*z))+c
h=c*Cos(i+(y*c))+b:c=150:LineXY(m,n,g,h,o*t*4):Next:l=t/b:ElseIf e>665 And e<d
DrawingMode(1):DrawText(b,b,"END",w):EndIf:StopDrawing():FlipBuffers():Until e>d 

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 33
; DisableDebugger