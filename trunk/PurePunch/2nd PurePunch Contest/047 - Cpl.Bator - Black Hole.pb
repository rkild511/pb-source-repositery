;*****************************************************************************
;*
;* Name   : Black Hole
;* Author : Cpl.Bator
;* Date   : 1/06/2009
;* Notes  : Press any key to quit , tested on Linux
;*
;*****************************************************************************
InitSprite():InitKeyboard():OpenScreen(1024,768,32,"")
Repeat:ExamineKeyboard():StartDrawing(ScreenOutput())
TM = ElapsedMilliseconds():L.d=1024+512*Cos(TM/500):For S = 1 To 20
T.d=(1024+L)/S : C = (S*255)/20: X.d=(S*2)*Cos(TM/1250): Y.d=(S*4)*Sin(TM/550)
Circle((512+X),(384+Y),T,RGB(0,0,255-C)):Next :StopDrawing():FlipBuffers(2)
Until KeyboardInkey()
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 9
; DisableDebugger