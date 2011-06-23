; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2285&highlight=
; Author: benny (original by remi_meier, updated for PB 4.00 by Andre)
; Date: 03. March 2005
; OS: Windows, Linux
; Demo: Yes


; Binary Sierpinski triangle, colored & mirrored
; Binäres Sierpinskidreieck, farbig & gespiegelt

OpenWindow(0, 200,200, 300,300, "", #PB_Window_SystemMenu) 

Img = CreateImage(#PB_Any, 300, 300) 

x=16 
y = 16 
n=255 

StartDrawing(ImageOutput(Img)) 
For r=0 To n 
  For s=0 To n-r 
    If (r & s) 
      FrontColor(RGB(64+r/4,s/4,s/2+64))
      Plot(x+r+5,y+s+5) 
      FrontColor(RGB(s/4,64+r/4,s/2+64))
      Plot(x+6+n-r,y+6+n-s) 
    Else 
      FrontColor(RGB(128+r/4,s/2,s/2+128))
      Plot(x+r+5,y+s+5) 
      FrontColor(RGB(s/2,128+r/4,s/2+128))
      Plot(x+6+n-r,y+6+n-s)      
    EndIf 
  Next s 
Next r 
StopDrawing() 

Repeat 

  StartDrawing(WindowOutput(0)) 
    DrawImage(ImageID(Img), 0,0) 
  StopDrawing() 

  Event = WaitWindowEvent() 
  If Event = 0 
    Delay(1) 
  EndIf 
Until Event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -