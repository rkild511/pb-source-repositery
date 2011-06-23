; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 05. September 2002
; OS: Windows
; Demo: Yes

ScreenWidth = 640 ;Higher resolution = smoother dots.
ScreenHeight = 480 ;Setting this higher doesn't affect performance much - because we only draw one sprite on the screen.
ScreenDepth = 32 ;[16 or 32] When color depth is set to 16 everything goes green on my monitor! why?
Squirm=16 ;[1 to 255]  lower value = more squirm!
Density=512 ;Number of new dots per frame.


InitSprite()
InitKeyboard()
InitSprite3D()


OpenScreen(ScreenWidth, ScreenHeight, ScreenDepth, "SquirmDots")


CreateSprite(0,3,3,#PB_Sprite_Memory)
CreateSprite(1,256,256,#PB_Sprite_Texture) ;This really only needs to be 256*192 but it's square for compatibility. 
TransparentSpriteColor(0,RGB(255,0,255)) 
TransparentSpriteColor(1,RGB(255,0,255))
UseBuffer(0)
DisplayRGBFilter(1, 1, 1, 1, 255, 255, 255) 
CreateSprite3D(0, 1)
Sprite3DQuality(1)
ZoomSprite3D(0, ScreenWidth,ScreenWidth) ;Yes, ScreenWidth twice - to maintain correct aspect of our square sprite.


Repeat
   FlipBuffers()
   UseBuffer(1)
      For x=0 To Density
         DisplaySprite(0,Random(253), Random(189))
      Next
   UseBuffer(-1)
   Start3D()
      DisplaySprite3D(0,0,0,Squirm) 
   Stop3D()
   ExamineKeyboard()
Until KeyboardPushed(#PB_Key_All)


End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -