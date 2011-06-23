; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8245&highlight=
; Author: DriakTravo (edited by LarsG)
; Date: 08. November 2003
; OS: Windows
; Demo: No

InitSprite() 
OpenScreen(800,600,32,"test") 

CreateSprite(1,100,100) 
If StartDrawing(SpriteOutput(1)) 
  Box(0,0,100,100,$ffff) 
  StopDrawing() 
Else 
  MessageRequester("Damn it","No draw!",0) 
EndIf 

time = GetTickCount_() 

For X = 0 To 400 
  ClearScreen(RGB(0,0,0))
  StartDrawing(ScreenOutput()) 
    Box(0,0,100,100,$ffffff) 
  StopDrawing() 
  FlipBuffers() 
Next X 

box = GetTickCount_() - time 

time = GetTickCount_() 

For X = 0 To 400 
  ClearScreen(RGB(0,0,0))
  DisplaySprite(1,0,0) 
  FlipBuffers() 
Next X 

sprite = GetTickCount_() - time 

CloseScreen() 

s1.s = "Box    : " + Str(box) 
s2.s = "Sprite : " + Str(sprite) 
OpenConsole() 
  PrintN("Results:") 
  PrintN(s1) 
  PrintN(s2) 
  Print("Press <enter> to quit") 
  Input() 
CloseConsole() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
