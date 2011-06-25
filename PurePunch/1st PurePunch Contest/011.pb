;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : djes
;* Date : Tue Dec 02, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=269241#269241
;*
;* Note : DirectX9
;*
;*****************************************************************************

SetPriorityClass_(  GetCurrentProcess_(), #HIGH_PRIORITY_CLASS)

If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error", "Sprite system can't be initialized", 0)
  End
EndIf

If InitSprite3D() = 0
  MessageRequester("Error", "Sprite3D system can't be initialized correctly", 0)
  End
EndIf

If OpenScreen(640, 480, 32, "Sprite")

  CreateSprite(0, 128, 128, #PB_Sprite_Texture)
  StartDrawing(SpriteOutput(0))
  a.f = 0
  For y = 0 To 127
    For x = 0 To 127
      vx.f = x - 64
      vy.f = y - 64
      dist.f = Sqr(vx * vx + vy * vy)
      If dist = 0 : dist = 0.0001 : EndIf
      If dist < 64
        vx   = vx / dist
        vy   = vy / dist
        c = 128 + 128 * ACos(vx * vy)
        Plot(x, y, RGB(c, $55, c/2))
      EndIf
    Next x
  Next y
  StopDrawing()
  CopySprite(0, 1)

  CreateSprite3D(0, 0)

  SetFrameRate(60)
  SetRefreshRate(60)

  frame_counter = 0

  Repeat
     
    ClearScreen(RGB($55, 0, $55))
   
    If Start3D()

      RotateSprite3D(0, frame_counter * 5, 0)

      For u=0 To 255 Step 1
        x = 150 * Sin((frame_counter * 2 + u) / 50)
        DisplaySprite3D(0, 256 + x, u, 255 * Sin(u * #PI / 256))
        ZoomSprite3D(0, 64, 32 + u/2)
        RotateSprite3D(0, 5, 1)
      Next u

      Stop3D()

    EndIf
   
;    Delay(15)
    FlipBuffers(1)
    frame_counter + 1
   
    ExamineKeyboard()

  Until KeyboardPushed(#PB_Key_Escape)
 
Else
  MessageRequester("Error", "Can't open a 640*480 - 32 bit screen !", 0)
EndIf

CompilerIf Subsystem("DirectX9")=0
  MessageRequester("Test" , "Now try with DirectX9 Subsystem" , 0)
CompilerEndIf 

End
