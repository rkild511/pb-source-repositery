; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1269&highlight=
; Author: RobinK (updated for PB4.00 by blbltheworm)
; Date: 18. June 2003
; OS: Windows
; Demo: Yes


; Converted from:  http://freespace.virgin.net/hugo.elias/graphics/x_water.htm

If InitSprite() = 0 Or OpenScreen(320,240,32,"Wasser") = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  End 
EndIf 

Global Dim Buffer(2,319,239) 
Repeat      
  Buffer(0,Random(317)+1,Random(237)+1) = Random(128) 
  ExamineMouse()    
  If MouseButton(1) <> 0 
    Buffer(0,MouseX(),MouseY()) = 128 
  EndIf 
  out = ScreenOutput() 
  If out    
  If StartDrawing(out) 
  For x = 1 To 318 
    For y = 1 To 238 
      Buffer(1,x,y) = ((Buffer(0,x-1,y)+Buffer(0,x+1,y)+Buffer(0,x,y-1)+Buffer(0,x,y+1))>>1) - Buffer(1,x,y) 
      Buffer(1,x,y) = Buffer(1,x,y)-Buffer(1,x,y)/128 
      Plot(x,y,RGB(0,Buffer(1,x,y)+128,255))  
    Next 
  Next    
  For x = 0 To 319 
    For y = 0 To 239 
      Buffer(2,x,y) = Buffer(1,x,y) 
    Next 
  Next 
  For x = 0 To 319 
    For y = 0 To 239 
      Buffer(1,x,y) = Buffer(0,x,y) 
    Next 
  Next    
  For x = 0 To 319 
    For y = 0 To 239 
      Buffer(0,x,y) = Buffer(2,x,y) 
    Next 
  Next    
  Plot(MouseX(),MouseY(),RGB(255,0,0)) 
  StopDrawing() 
  EndIf 
  EndIf 
  FlipBuffers() 
  ClearScreen(RGB(0,0,128))  
  ExamineKeyboard()  
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
