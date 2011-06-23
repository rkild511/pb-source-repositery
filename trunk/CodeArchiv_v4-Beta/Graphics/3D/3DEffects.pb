; www.menzer-software.de
; Author: Rayman1970 (updated to PB4 by ste123)
; Date: 17. July 2003
; OS: Windows
; Demo: Yes

InitSprite() : InitSprite3D() : InitKeyboard()
OpenScreen(640,400,16,"3D DEMO")
 
Sprite3DQuality(1)

GrabSprite(2,0,0,64,64,#PB_Sprite_Texture)

a.f=0.3 : i.f=16

Repeat
  rot+1 : If rot>360 : rot=0 : EndIf

  ClearScreen( RGB(f,155,155) )
  CreateSprite3D(1, 2)

  Start3D()
    ZoomSprite3D(1,63, 63)
    RotateSprite3D(1,rot,1) 
    For x=0 To 640 Step 64 : For y=0 To 400 Step 64
      DisplaySprite3D(1,0+x,0+y,255)
    Next y : Next x


    ZoomSprite3D(1,300, 300)
    RotateSprite3D(1,360-rot,1) 
    DisplaySprite3D(1,160,50,200)

    FreeSprite3D(1) 
  Stop3D()

  i+a : If i>50 Or i<2 : a=-a : EndIf
  f+1 : If f>255 : f=0 : EndIf

  StartDrawing(ScreenOutput())
    Plot(32,i,RGB(Random(255),Random(255),Random(255)))
  StopDrawing()

  GrabSprite(2,0,0,64,64,#PB_Sprite_Texture)

  FlipBuffers()
  ExamineKeyboard()  
Until KeyboardPushed(#PB_Key_Escape)

CloseScreen()
MessageRequester("3D Grafik Demo für PureBasic" ,"(c) 2003 www.Menzer-Software.de", 0)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger