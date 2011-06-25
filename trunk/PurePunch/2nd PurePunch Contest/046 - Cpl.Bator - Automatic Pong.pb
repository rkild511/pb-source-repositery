;*****************************************************************************
;*
;* Name   : Automatic Pong
;* Author : Cpl.Bator
;* Date   : 1/06/2009
;* Notes  : Press any key to quit ( not tested on windows but linux )
;*
;*****************************************************************************
InitSprite():InitKeyboard():OpenScreen(640,480,32,""):Bx.d=320:By.d=240:Bd.b=4
Macro M:Macro:EndMacro:M I:If:EndMacro:M EI:EndIf:EndMacro:M A:And:EndMacro:
M clsw:W=255:EndMacro:M C:Case:EndMacro:H=$FFFFFF:Dy=240:Gy=240:Repeat:Gy=By
ExamineKeyboard():W-1:I W<0:W=0:EI:Select Bd:C 1:Bx+0.5:By+0.5:C 2:Bx-0.5:
By+0.5:C 3:Bx-0.5:By-0.5:C 4:Bx+0.5:By-0.5:EndSelect:I By>476 A Bd=1:Bd=4:
clsw:EI:I By<4 A Bd=4:Bd=1:clsw:EI:I By>476 A Bd=2:Bd=3:clsw:EI:I By<4 A Bd=3:
Bd=2:clsw:EI:I Bx<20 A Bd=2:Bd=1:clsw:EI:I Bx<20 A Bd=3:Bd=4:clsw:EI:Dy=By
I Bx>610 A Bd=1:Bd=2:clsw:EI:I Bx>610 A Bd=4:Bd=3:clsw:EI:O=ScreenOutput()
StartDrawing(O):Circle(Bx,By,4,H):Box(10,Gy-32,10,64,H):Box(610,Dy-32,10,64,H)
StopDrawing():FlipBuffers(2):ClearScreen(RGB(W,W,W)):Until KeyboardInkey()
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 17
; Folding = -
; DisableDebugger