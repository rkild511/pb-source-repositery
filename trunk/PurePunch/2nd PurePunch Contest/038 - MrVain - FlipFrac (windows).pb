;*****************************************************************************
;*
;* Name   : FlipFrac - flipping flat fractal with faked lightsourcing effect                               
;* Author : Thorsten Will - aka 'Mr.Vain of Secretly!'
;* Date   : 16.06.2009                                   
;* Notes  : Entry for the PurePunch Contest #2
;*          The rule is to code something in max 10 lines of 80 characters!
;*          I did a small graphic effect in just only 5 lines of code! ;-)
;*          Win32 API has been used to check if user pressed the ESCAPE key
;*
;*          P L E A S E   D I S A B L E   T H E   D E B U G G E R  !!!
;*
;***************************************************************************** 
InitSprite():OpenScreen(640,480,32,""):b=255:Repeat:StartDrawing(ScreenOutput())
For m=0 To 639:For n=0 To 479:c=(64+Random(128))<<16:p.f=(m-320)/(Sin(t.f)*200)
q.f=(n-240)/(Cos(t)*200):x.f=0:y.f=0:For i=0 To 31:u.d=x*x-y*y+p:v.d=2*x*y+q
If(u*u+v*v)>4:Goto E:EndIf:x=u:y=v:Next:c=Cos(t)*200:c=RGB(c,c,b):E:Plot(m,n,c)
Next:Next:StopDrawing():t+0.05:FlipBuffers():Until GetAsyncKeyState_(27):End


; IDE Options = PureBasic 4.31 (Windows - x86)
; DisableDebugger