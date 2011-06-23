; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7600&highlight=
; Author: Dreglor (updated for PB4.00 by blbltheworm)
; Date: 20. September 2003
; OS: Windows
; Demo: Yes

;******************************** 
;*Name: Fire                    * 
;*By: Dreglor                   * 
;*last updated: 9-20-03 1:26pm  * 
;******************************** 

y.w=0 
x.w=0 
screen_width.w=1024 
screen_height.w=768 
Global Dim cool.w(screen_width,screen_height) 
Global Dim buf.w(screen_width,screen_height) 
yy.w=0 
xx.w=0 
For y=1 To screen_height-1 
  For x=1 To screen_width-1 
    cool(x,y)=Random(3) 
    buf(x,y)=0 
  Next x 
Next y 
InitSprite() 
OpenScreen(screen_width,screen_height,32,"FIRE!") 
InitPalette() 
CreatePalette(0) 
Global Dim color(255) 
For i=0 To 84 
color(i)=Int(255/84*i)+0<<8+0<<16 
color(i+85)=255+Int(255/84*i)<<8+0<<16 
color(i+85+85)=255+255<<8+Int(255/84*i)<<16 
Next i 
InitKeyboard() 
Repeat 
  StartDrawing(ScreenOutput()) 
  For y=1 To screen_height-1 
    For x=1 To screen_width-1 
      If buf(x,y) > 0 
        If buf(x,y) < 0 
          buf(x,y)=0 
        Else 
          buf(x,y)=((buf(x+1,y)+buf(x-1,y)+buf(x,y+1)+buf(x,y-1))/4-cool(x,y)) 
        EndIf        
        buf(x,y-1)=buf(x,y) 
        cool(x,y-1)=cool(x,y) 
        cool(x,y)=Random(3) 
        If buf(x,y) > 0 
          Plot(x,y,color(buf(x,y))) 
        EndIf 
      EndIf 
      buf(x,screen_height-2)=255 
    Next x 
  Next y 
  StopDrawing() 
  FlipBuffers() 
  ;ClearScreen(0,0,0) don't need it :o 
  ExamineKeyboard()  
Until KeyboardReleased(#PB_Key_Escape) 
CloseScreen() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
