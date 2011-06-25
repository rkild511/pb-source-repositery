;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : Psychophanta
;* Date : Mon Dec 01, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=269074#269074
;*
;*****************************************************************************
InitSprite()
InitKeyboard()

If OpenScreen(800,600,32,"Plasma")=0
  Debug "Can't create screen"
  End
EndIf

StartDrawing(ScreenOutput())
If DrawingBufferPixelFormat()&(#PB_PixelFormat_32Bits_RGB|#PB_PixelFormat_32Bits_RGB)=0
  Debug "No 32 bits screen mode available"
  End
EndIf
StopDrawing()

Dim CosTable.l(1599)
Dim ColorTable.l(255)

For i.w=0 To 1599
  CosTable(i)=Sin(9/8*i*#PI/180.)*32+32
Next

If DrawingBufferPixelFormat()=#PB_PixelFormat_32Bits_RGB
  For i=0 To 255
    ColorTable(i)=i
  Next
Else
  For i=0 To 255
    ColorTable(i)=i<<16
  Next
EndIf

Repeat

  ExamineKeyboard()

  StartDrawing(ScreenOutput())
 
  *Buffer=DrawingBuffer()
  Pitch=DrawingBufferPitch()

  For y.l=0 To 599
    pos1.l=CosTable(y+wave)
    *Line.long=*Buffer
    For x.l=0 To 799
      *Line\l=ColorTable(CosTable(x+Wave)+CosTable(x+y)+pos1)
      *Line+4
    Next
    *Buffer+Pitch
  Next

  Wave+6
  If Wave>320
    Wave=0
  EndIf

  StopDrawing()

  FlipBuffers(1)

Until KeyboardPushed(#PB_Key_Escape)

End

