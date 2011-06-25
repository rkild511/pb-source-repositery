;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : 
;* Author : Cpl.Bator
;* Date   : Dim 24/Aoû/2008
;* Link   : http://www.purebasic.fr/french/viewtopic.php?p=86731#86731
;*
;*****************************************************************************
InitSprite() : InitKeyboard() : OpenScreen(1024,768,32,"PurePunch")
CreateSprite(0,32,32) : TransparentSpriteColor(0,0) : StartDrawing(SpriteOutput(0)) : For i = 0 To 16 : DrawingMode(#PB_2DDrawing_Outlined ) :    Circle(16,16,16-i,255-(14*i)) : Next i :StopDrawing()
Repeat : ClearScreen(0) : ExamineKeyboard()
      Z.f = (16+16*Cos(ElapsedMilliseconds()/1000))+16
      Restore P: For y = 0 To 4 : For x = 0 To 3 : Read A:  If A = 1 : DisplayTransparentSprite(0,x*Z,y*Z): EndIf  : Next x  : Next y
      Restore u: For y = 0 To 4 : For x = 0 To 3 : Read A:  If A = 1 : DisplayTransparentSprite(0,16+(Z*4)+x*Z,y*Z): EndIf  : Next x  : Next y
      Restore R: For y = 0 To 4 : For x = 0 To 3 : Read A:  If A = 1 : DisplayTransparentSprite(0,32+(Z*8)+x*Z,y*Z): EndIf  : Next x  : Next y
      Restore E: For y = 0 To 4 : For x = 0 To 3 : Read A:  If A = 1 : DisplayTransparentSprite(0,64+(Z*12)+x*Z,y*Z): EndIf  : Next x  : Next y
FlipBuffers() : Until KeyboardPushed(#PB_Key_Escape):End
DataSection
      P:Data.l 1,1,1,0 : Data.l 1,0,0,1: Data.l 1,1,1,0:Data.l 1,0,0,0 : Data.l 1,0,0,0
      u:Data.l 1,0,0,1 : Data.l 1,0,0,1 : Data.l 1,0,0,1 : Data.l 1,0,0,1:Data.l 0,1,1,0
      R:Data.l 1,1,1,0 : Data.l 1,0,0,1 : Data.l 1,1,1,0 : Data.l 1,1,0,0 : Data.l 1,0,0,1
      E: Data.l 1,1,1,1 : Data.l 1,0,0,0 :  Data.l 1,1,0,0 :  Data.l 1,0,0,0: Data.l 1,1,1,1
EndDataSection

