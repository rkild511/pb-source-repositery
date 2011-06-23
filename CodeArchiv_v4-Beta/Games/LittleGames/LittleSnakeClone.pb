; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3791&highlight=
; Author: benpicco (updated for PB 4.00 by Andre)
; Date: 25. June 2005
; OS: Windows
; Demo: Yes

InitSprite():InitKeyboard()
#screenX=640
#screenY=480
Dim raster.f(#screenX,#screenY)
Global futterX.w
Global futterY.w
Global score.w
Global speed.b
Global laenge.f
Procedure drawing(text$,X,Y,color)
  StartDrawing(ScreenOutput())
  DrawingMode(1)
  FrontColor(color)
  DrawText(x,y,text$)
  StopDrawing()
EndProcedure
laenge=3
speed=10
futterX=((Random(((#screenX-20)/speed)))*speed)+10
futterY=((Random(((#screenY-20)/speed)))*speed)+10
For x=0 To laenge*10 Step 10
  raster(10+x,10)=x/10
Next
headX=10+x
headY=10
speedX=speed
speedY=0

OpenWindow(0, 0, 0, #ScreenX,#ScreenY, "Snake", #PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(0),0,0,#screenX,#screenY,1,0,0)
SetFrameRate(20)

Repeat
  ClearScreen(RGB(10,10,10))
  WindowEvent()
  StartDrawing(ScreenOutput())
  Box(futterX,futterY,10,10,RGB(255,0,0))
  For y=1 To #screenY
    For x=1 To #screenX
      If raster(x,y)>0
        Box(x,y,10,10,RGB(255*(raster(x,y)/laenge),255*(raster(x,y)/laenge),255*(raster(x,y)/laenge)))
        If raster(x,y)=laenge
          Box(x,y,10,10,RGB(0,0,255))
        EndIf
        raster(x,y)-1
      EndIf
    Next
  Next
  headX+speedX
  headY+speedY
  If headX>#screenX-10
    headX=10
  EndIf
  If headX<10
    headX=#screenX-10
  EndIf
  If headY>#screenY-10
    headY=10
  EndIf
  If headY<10
    headY=#screenY-10
  EndIf
  If raster(headX,headY)<>0
    Goto die
  EndIf
  raster(headX,headY)=laenge
  StopDrawing()
  drawing(Str(score),1,1,RGB(255,255,255))
  FlipBuffers()
  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Up) And speedY<>speed
    speedY=-speed
    speedX=0
  ElseIf KeyboardPushed(#PB_Key_Down) And speedY<>-speed
    speedY=speed
    speedX=0
  ElseIf KeyboardPushed(#PB_Key_Left) And speedX<>speed
    speedY=0
    speedX=-speed
  ElseIf KeyboardPushed(#PB_Key_Right) And speedX<>-speed
    speedY=0
    speedX=speed
  EndIf
  If headX=futterX And headY=futterY
    score+1
    laenge+1
    futterX=((Random(((#screenX-20)/speed)))*speed)+10
    futterY=((Random(((#screenY-20)/speed)))*speed)+10
  EndIf
Until KeyboardPushed(#PB_Key_Escape)
End

die:
StopDrawing()
drawing("GameOver!",100,100,RGB(100,100,100))
OpenFile(1,"highscore.dat")
highscore.w=ReadWord(1)
CloseFile(1)
drawing("Highscore:"+Str(highscore),50,150,RGB(255,255,0))
FlipBuffers()
Delay(1000)
If score>highscore
  drawing("New Highscore!",200,200,RGB(0,255,0))
  OpenFile(1,"highscore.dat")
  WriteWord(1,score)
  CloseFile(1)
  FlipBuffers()
  Delay(1000)
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -