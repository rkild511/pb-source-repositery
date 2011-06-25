;*****************************************************************************
;*
;* Name   : Estelar fireworking
;* Author : Psychophanta
;* Date   : 21 June 2009
;* Notes  : Should work on Windows
;*
;*****************************************************************************
InitSprite():InitKeyboard():OpenScreen(1024,768,32,""):Structure j:a.f:x.l:y.l
i.l:e.l:n.l:d.l:f.f:c.l:u.f:v.f:w.f:g.f:EndStructure:Dim m.j(22):With m(z)
Macro r(r):Random(r):EndMacro:Macro L(_,g=\)
LineXY(g#x+g#i*Cos(_),g#y+g#i*Sin(_),g#x+g#e*Cos(g#w),g#y+g#e*Sin(g#w),g#c)
EndMacro:For z=0 To 22:\i=r(400):Next:Repeat:ClearScreen(0):ExamineKeyboard()
StartDrawing(ScreenOutput()):For z=0 To 22:If \i>r(500)+50:\x=r(1023):\y=r(767)
\i=r(10):\e=r(30):\d=(r(1E3)-5E2)/10:\c=r($EEEEEE)+$111111:\n=r(26)+4
\g=(r(1E3)-5E2)/1E4:EndIf:\a=2*#PI/\n:For t=1 To \n:\u=(t-1)*\a+\f:\v=t*\a+\f
\w=(t+\d/20-0.5)*\a+\f:L(\u):L(\v):Next:\i+2:\e-\i/6:\f+\g:Next:StopDrawing()
FlipBuffers():Delay(16):Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; Folding = -
; DisableDebugger