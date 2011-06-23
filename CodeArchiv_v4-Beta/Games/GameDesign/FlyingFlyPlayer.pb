; English PB Chat
; Author: oly (updated for PB 4.00 by Andre)
; Date: 31. October 2004
; OS: Windows
; Demo: Yes

; Flying fly with physics
; Just a simple player that can be moved around with cursor keys.
; Has some physics that effects the player like friction and gravity.

#PLAYERS = 4
#TAIL_LENGTH = 7

Structure XY
  x.f
  y.f
EndStructure

Structure item
  location.XY
  weight.f
  maxvelocity.f
  velocity.XY
EndStructure

Structure insect
  xjoy.b : yjoy.b : bjoy1.b : bjoy2.b
  pos.item

  tail.l
  tailsize.b
  x.l[10]
  y.l[10]
  col.l[10]

  sex.b
  follow.b

  name.s
  score.w
  cntrl.w
  r.b : g.b : b.b

  status.b
EndStructure

Structure world
  width.w
  height.w
  depth.b

  friction.f
  gravity.f
  wind.f

  xsize.l
  ysize.l

EndStructure
;IncludeFile "types.pbi"
;IncludeFile "physics.pbi"

Global Dim fly.insect(#PLAYERS+1)
Global wld.world
Global ply.b
Global x.f,y.f
ply=0

;img=LoadImage(1,"landscape2s2.bmp")

wld\width = 600
wld\height = 600
wld\depth = 16
wld\gravity = 0.05
wld\friction = 0.95 ;0.95
wld\xsize = 600
wld\ysize = 600

Procedure initfly()
  fly(ply)\status=0
  fly(ply)\x[0]=100
  fly(ply)\y[0]=100
  fly(ply)\pos\location\x=100
  fly(ply)\pos\location\y=100
  fly(ply)\pos\weight=0.20
  fly(ply)\pos\maxvelocity=0.5
  fly(ply)\follow=0
  fly(ply)\tail=-100
  fly(ply)\cntrl=5
  fly(ply)\col = RGB(255,128,128)
  For i=1 To #TAIL_LENGTH
    fly(ply)\x[i] = fly(ply)\x[i-1]
    fly(ply)\y[i] = fly(ply)\y[i-1]
  Next
EndProcedure

InitKeyboard()
InitSprite()
hwnd= OpenWindow(0,0,100,600,600, "FireFlies", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
OpenWindowedScreen(hwnd,1,1,600,600,0,0,0)

Procedure ReadKeys1()
  ExamineKeyboard()
  fly(ply)\xjoy = 0 : fly(ply)\yjoy = 0
  If KeyboardPushed(#PB_Key_Up) : fly(ply)\yjoy=-1 : EndIf
  If KeyboardPushed(#PB_Key_Down) :fly(ply)\yjoy=1 : EndIf
  If KeyboardPushed(#PB_Key_Left) : fly(ply)\xjoy=-1 : EndIf
  If KeyboardPushed(#PB_Key_Right) : fly(ply)\xjoy=1 : EndIf
EndProcedure

Procedure physics(*pos.item,addx.b,addy.b)
  *pos\velocity\x = *pos\velocity\x * wld\friction  ;slow down because of friction
  *pos\velocity\y = *pos\velocity\y * wld\friction

  *pos\velocity\x = *pos\velocity\x + (addx * *pos\maxvelocity) ;speed up traveling in direction
  *pos\velocity\y = *pos\velocity\y + (addy * *pos\maxvelocity)

  *pos\velocity\y = *pos\velocity\y + (*pos\weight + wld\gravity) ;Add gravity to object
EndProcedure

Procedure movefly()
  physics(@fly(ply)\pos,fly(ply)\xjoy,fly(ply)\yjoy)

  fly(ply)\pos\location\x = fly(ply)\pos\location\x + fly(ply)\pos\velocity\x
  fly(ply)\pos\location\y = fly(ply)\pos\location\y + fly(ply)\pos\velocity\y

  If fly(ply)\tail < ElapsedMilliseconds() + 80
    fly(ply)\tail = ElapsedMilliseconds()
    For i=#TAIL_LENGTH+2 To 1 Step -1
      fly(ply)\x[i] = fly(ply)\x[i-1]
      fly(ply)\y[i] = fly(ply)\y[i-1]
    Next
  EndIf

  fly(ply)\x[0] = fly(ply)\pos\location\x
  fly(ply)\y[0] = fly(ply)\pos\location\y

  StartDrawing(WindowOutput(0))
  For i=0 To #TAIL_LENGTH
    LineXY(fly(ply)\x[i],fly(ply)\y[i],fly(ply)\x[i+1],fly(ply)\y[i+1] ,fly(ply)\col)

    LineXY(fly(ply)\x[i]+1,fly(ply)\y[i],fly(ply)\x[i+1]+1,fly(ply)\y[i+1] ,fly(ply)\col)
    LineXY(fly(ply)\x[i]-1,fly(ply)\y[i],fly(ply)\x[i+1]-1,fly(ply)\y[i+1] ,fly(ply)\col)

    LineXY(fly(ply)\x[i],fly(ply)\y[i]+1,fly(ply)\x[i+1],fly(ply)\y[i+1]+1 ,fly(ply)\col)
    LineXY(fly(ply)\x[i],fly(ply)\y[i]-1,fly(ply)\x[i+1],fly(ply)\y[i+1]-1 ,fly(ply)\col)
  Next
  StopDrawing()
EndProcedure

Procedure DrawScene()
  StartDrawing(WindowOutput(0))
  ;DrawImage(UseImage(1), 1, 1)
  Box(0,0,800,600,0)
  StopDrawing()
  movefly()

EndProcedure

initfly()
While done=0
  Event=WindowEvent()
  If Event=#PB_Event_CloseWindow
    done=1
  EndIf
  ReadKeys1()
  DrawScene()
  Delay(40)
Wend

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -