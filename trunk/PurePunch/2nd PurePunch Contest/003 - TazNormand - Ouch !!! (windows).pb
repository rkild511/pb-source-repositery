;*****************************************************************************
;*
;* Name   :  Ouch !!!
;* Author : TazNormand
;* Date   : 07 June 2009
;* Notes  : Calls Win API, wouldn't work on Mac/linux/Amiga + PB Demo Version
;*
;*****************************************************************************

ExamineDesktops():w=DesktopWidth(0):h=DesktopHeight(0):InitSprite():sx=0:p=8
InitSprite3D():InitKeyboard():i=CreateImage(0,w,h):sy=0:r=32:x=(w-(w/r))/2
hc=StartDrawing(ImageOutput(0)):d=GetDC_(GetDesktopWindow_()):y=(h-(h/r))/2
BitBlt_(hc,0,0,w,h,d,0,0,#SRCCOPY):StopDrawing():
ReleaseDC_(GetDesktopWindow_(),d):OpenScreen(w,h,32,""):CreateSprite(0,w,h,4)
StartDrawing(SpriteOutput(0)):DrawImage(i,0,0,w,h):StopDrawing()
CreateSprite3D(0,0):ZoomSprite3D(0,w/r,h/r):Repeat:ExamineKeyboard():Start3D()
DisplaySprite3D(0,x,y):Stop3D():r-1:If r>1:x=(w-(w/r))/2:y=(h-(h/r))/2
ZoomSprite3D(0,w/r,h/r):sy=y:sx=x:EndIf:If r<1:y=sy:sy+4:x=sx+p:p*-1:EndIf
FlipBuffers():ClearScreen(0):Until KeyboardPushed(#PB_Key_Escape) Or sy>w:End
; IDE Options = PureBasic 4.31 (Windows - x86)
; DisableDebugger