;*****************************************************************************
;*
;* Name   : Humping workbench
;* Author : Psychophanta
;* Date   : 13 June 2009
;* Notes  : Calls Win API, wouldn't work on Mac/linux/Amiga + PB Demo Version
;*
;*****************************************************************************
Macro _:50*Cos(c.f):EndMacro:Macro q:50*Sin(c):EndMacro:ExamineDesktops()
W=DesktopWidth(0):H=DesktopHeight(0):InitSprite():InitSprite3D():InitKeyboard()
CreateImage(0,W,H):i=StartDrawing(ImageOutput(0))
BitBlt_(i,0,0,W,H,GetDC_(GetDesktopWindow_()),0,0,#SRCCOPY):StopDrawing()
DeleteDC_(i):OpenScreen(W,H,32,"F"):CreateSprite(0,W,H,4)
StartDrawing(SpriteOutput(0)):DrawImage(ImageID(0),0,0):StopDrawing()
CreateSprite3D(0,0):Repeat:ExamineKeyboard():ClearScreen(0):Start3D()
TransformSprite3D(0,_,_*Cos(c),W+_,_*Cos(c),W+q,H+q*Cos(c),q,H+q*Cos(c))
DisplaySprite3D(0,0,0,$FF):Stop3D():c+8E-2:If c>2*#PI:c=0:EndIf
FlipBuffers():Delay(16):Until KeyboardPushed(1)

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; Folding = -
; DisableDebugger