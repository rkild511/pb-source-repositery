;*****************************************************************************
;*
;* Name   :  Agitated Desktop
;* Author : TazNormand
;* Date   : 05 June 2009
;* Notes  : Appel d'API, ne devrait pas marcher sur Mac/linux/Amiga et Version Démo
;*
;*****************************************************************************

ExamineDesktops():w=DesktopWidth(0):h=DesktopHeight(0):InitSprite()
InitSprite3D():InitKeyboard():i=CreateImage(0,w,h):sy=4:x=0:y=0:sx=8
hdc=StartDrawing(ImageOutput(0)):Ddc=GetDC_(GetDesktopWindow_())
BitBlt_(hdc,0,0,w,h,Ddc,0,0,#SRCCOPY):StopDrawing()
ReleaseDC_(GetDesktopWindow_(),Ddc):OpenScreen(w,h,32,""):CreateSprite(0,w,h,4)
StartDrawing(SpriteOutput(0)):DrawImage(i,0,0,w,h):StopDrawing()
CreateSprite3D(0,0):ZoomSprite3D(0,w/1.2,h/1.2):Repeat:ExamineKeyboard()
If x<0 Or x>w-(w/1.2):sx*-1:EndIf:If y<0 Or y>h-(h/1.2):sy*-1:EndIf:x+sx:y+sy
Start3D():DisplaySprite3D(0,x,y):Stop3D():FlipBuffers():ClearScreen(0)
Until KeyboardPushed(#PB_Key_Escape):End

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 5
; DisableDebugger