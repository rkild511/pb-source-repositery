; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 02. March 2003
; OS: Windows
; Demo: Yes

InitMovie()
InitSprite()
InitKeyboard()

LoadMovie(0, "test.mp3")

OpenScreen(640, 480, 32, "Test")

PlayMovie(0, ScreenID())

Repeat
  FlipBuffers()
  ClearScreen(RGB(0,0,0))
  If MovieStatus(0) = 0
    PlayMovie(0, ScreenID())
  EndIf
  StartDrawing(ScreenOutput())
  count.s = Str(MovieStatus(0))
  DrawText(10,10,count)
  Delay(20)
  StopDrawing()
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -