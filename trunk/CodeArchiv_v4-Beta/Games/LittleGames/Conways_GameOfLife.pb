; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9081&highlight=
; Author: chris_b (updated for PB4.00 by blbltheworm)
; Date: 08. January 2004
; OS: Windows
; Demo: Yes

; Conway's Game of Life on a 256x256 grid:
; It runs pretty fast on my system, but there's plenty of scope to speed it up.
; For example the bitwise ANDs used to ensure that the world wraps around are
; not necessary - really the outside edges should be processed in seperate loops.
; But I left it like this so the code is easier to understand. 


Define.l x,y,i,col,frame,oldframe 

Global Dim LifeArray.b(1,255,255) 

InitKeyboard() 
InitSprite() 
InitSprite3D() 
OpenScreen(1024, 768, 16, "Life") 
TransparentSpriteColor(-1,RGB(255,0,255)) 
CreateSprite(0,256,256,#PB_Sprite_Texture) 
CreateSprite3D(0, 0) 
ZoomSprite3D(0, 768,768) 
Sprite3DQuality(0) 

col=RGB(240,240,255) 

frame=0 
oldframe=0 

Procedure RandomLife() 

For y=0 To 255 
  For x=0 To 255 

    LifeArray(0,x,y)=Random(1) 

  Next 
Next 

EndProcedure 

randomlife() 

Repeat 

  FlipBuffers() 

  oldframe=frame 
  frame=1-frame 

  For y=0 To 255 
    For x=0 To 255 

      i=LifeArray(oldframe,(x-1)&255,(y-1)&255) 
      i=i+LifeArray(oldframe,x,(y-1)&255) 
      i=i+LifeArray(oldframe,(x+1)&255,(y-1)&255) 
      i=i+LifeArray(oldframe,(x-1)&255,y) 
      i=i+LifeArray(oldframe,(x+1)&255,y) 
      i=i+LifeArray(oldframe,(x-1)&255,(y+1)&255) 
      i=i+LifeArray(oldframe,x,(y+1)&255) 
      i=i+LifeArray(oldframe,(x+1)&255,(y+1)&255) 

      If i=2 And LifeArray(oldframe,x,y)=1 
        LifeArray(frame,x,y)=1 
      ElseIf i=3 
        LifeArray(frame,x,y)=1 
      Else 
        LifeArray(frame,x,y)=0 
      EndIf 

    Next 
  Next 

  StartDrawing(SpriteOutput(0)) 

  Box(0, 0, 256, 256 ,0) 

  For y=0 To 255 
    For x=0 To 255 
      If LifeArray(frame,x,y) 
        Plot(x,y,col) 
      EndIf 
    Next 
  Next 

  StopDrawing() 

  ClearScreen(RGB(0,0,0)) 

  Start3D() 
  DisplaySprite3D(0,128,0,255) 
  Stop3D() 

  ExamineKeyboard() 

  If KeyboardPushed(#PB_Key_Space) 
    randomlife() 
  EndIf 

Until KeyboardPushed(#PB_Key_Escape) 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
