; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7925&highlight=
; Author: vanleth (updated for PB4.00 by blbltheworm)
; Date: 16. October 2003
; OS: Windows
; Demo: No


; Normaly intended only for a speedtest of using a Bitmap font compared to PB's DrawText
; but also useful as an example how to include (e.g. colored) bitmap fonts in a game...  André ;)

InitSprite() : InitKeyboard()

OpenScreen(800,600,16,"Bitmap Font")
; font sprite letters is 6 in width and 10 in height
LoadSprite(0, "debugfont.bmp" , 0 )

Procedure bitmap_text(x.l, y.l, string_buffer.s)
  a=0
  Repeat
    buff.b = PeekB(@string_buffer+a)
    ClipSprite(0,(buff-32)*6, 0, 6, 10)
    DisplaySprite(0, x+(a*6), y)
    a+1
  Until buff = 0
EndProcedure

Repeat
  FlipBuffers() : ClearScreen(RGB(0,0,0))
  
  old_time = timeGetTime_()
  For a = 0 To 2000
    bitmap_text(100,100,"Bitmap Font")
  Next
  bitmapfont_time = timeGetTime_() - old_time
  
  old_time = timeGetTime_()
  StartDrawing(ScreenOutput())
  DrawingMode(1) : FrontColor(RGB(200,200,200))
  For a = 0 To 2000
    DrawText(100, 112,"Fred's Font")
  Next
  pbfont_time = timeGetTime_() - old_time
  
  ; show results
  DrawText(0,0,"Bitmap "+Str(bitmapfont_time))
  DrawText(0,12,"PureBasic "+Str(pbfont_time))
  StopDrawing()
  
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
