;*****************************************************************************
;*
;* Name   :  Screen Wave
;* Author : TazNormand
;* Date   : 05 June 2009
;* Notes  :
;*
;*****************************************************************************

ExamineDesktops():w=DesktopWidth(0):h=DesktopHeight(0):InitSprite():y=-256
InitKeyboard():i=CreateImage(0,w,h) :hDC=StartDrawing(ImageOutput(0))
Ddc=GetDC_(GetDesktopWindow_()):BitBlt_(hDC,0,0,w,h,DDC,0,0,#SRCCOPY)
StopDrawing() :ReleaseDC_(GetDesktopWindow_(),DDC):OpenScreen(w,h,32,"")
CreateSprite(0,w,h):StartDrawing(SpriteOutput(0)):DrawImage(i,0,0,w,h)
StopDrawing():Repeat:ExamineKeyboard():x=(Sin((y)/w*#PI*4)*128)+10
ClipSprite(0,0,y,w,256):DisplaySprite(0,x,y):FlipBuffers():ClearScreen(0):y=y+4
If y=h+32:y=-256:EndIf:Until KeyboardPushed(#PB_Key_Escape):End

; IDE Options = PureBasic 4.31 (Windows - x86)
; DisableDebugger