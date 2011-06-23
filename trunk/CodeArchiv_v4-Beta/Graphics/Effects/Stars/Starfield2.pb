; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7349&postdays=0&postorder=asc&start=15
; Author: VIRTUALYS (updated for PB4.00 by blbltheworm)
; Date: 06. September 2003
; OS: Windows
; Demo: Yes

If InitSprite()=0 
  MessageRequester("Fatal Error!","Could not initalize directX",0) 
  End 
EndIf 
#screen_width  = 1024 
#screen_height = 768 
If OpenScreen(#screen_width,#screen_height,16,"")=0 
  MessageRequester("Fatal Error!","Could not initalize the screen",0) 
  End 
EndIf 
If InitKeyboard()=0 
  MessageRequester("Fatal Error!","Could not initalize the keyboard",0) 
  End 
EndIf 
SetFrameRate(60) ;i put this in to keep the frame rate constant 
xmax.w=10000 
ymax.w=10000 
zmax.w=2000 
sspeed.w=-10 
zmin.w=10 
num.w=5000 ;get slow around 2500-3000 and i have 2.66 cpu 
centerx.w=#screen_width/2 
centery.w=#screen_height/2 
zoom.w=60 
shade.w=0 
Global Dim sx(num) 
Global Dim sy(num) 
Global Dim sz(num) 
For i=0 To num 
    sx(i)=Random(xmax)-xmax/2 
    sy(i)=Random(ymax)-ymax/2 
    sz(i)=Random(zmax) 
Next i 
Repeat 
StartDrawing(ScreenOutput()) 
  For i=0 To num 
    sz(i)=sz(i)+sspeed 
    If sz(i)<=zmin 
      sz(i)=zmax 
      sx(i)=Random(xmax)-xmax/2 
      sy(i)=Random(ymax)-ymax/2 
    EndIf 
    screenx.w=(sx(i)*zoom)/sz(i)+centerx 
    screeny.w=(-sy(i)*zoom)/sz(i)+centery 
    shade=Int(255/zmax* -sz(i)) 
    If screenx < #screen_width 
      If screeny < #screen_height 
        If screenx > 0 
          If screeny > 0 
           Plot(screenx,screeny,RGB(shade,shade,shade)) 
          EndIf 
        EndIf 
      EndIf 
    EndIf 
  Next i 
  StopDrawing() 
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
  ExamineKeyboard() 
Until KeyboardReleased(#PB_Key_Escape) 
CloseScreen() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
