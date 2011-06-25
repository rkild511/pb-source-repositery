;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : Zoom
;* Author   : SPH
;* Date     : 07/06/2010
;* Purebasic Version : 4.5
;*
;*****************************************************************************;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitSprite() 
InitKeyboard() 
InitMouse()
UseJPEGImageDecoder()

#dw=1024
#dh=768
#dc=32

If OpenScreen(#dw,#dh,#dc,"zoom")=0
MessageRequester("Erreur", "Screen Open impossible a ouvrir", 0) : End
EndIf

CreateImage(0,#dw,#dh)
ImageID0 = ImageID(0)

i=8

Repeat
  
StartDrawing(ScreenOutput())
DrawImage(ImageID0,-i,-i,#dw+i*2,#dh+i*2)
StopDrawing()

For u=5 To 60 Step 8
LoadFont(0, "Arial", u)
StartDrawing(ScreenOutput()) 
DrawingMode(#PB_2DDrawing_Transparent)
DrawingFont(FontID(0)) 
DrawText(Random(#dw-u),Random(#dh-u),Chr(Random(222)+33), RGB(Random(255),Random(255),Random(255)),0)
StopDrawing() 
Next

StartDrawing(ScreenOutput())
GrabDrawingImage(0,0,0,#dw,#dh)
ImageID0 = ImageID(0)
StopDrawing()
FlipBuffers() 
;Delay(3)

ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)
End
; IDE Options = PureBasic 4.51 RC 1 (Windows - x86)
; CursorPosition = 12
; FirstLine = 10