; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3439&start=20
; Author: Unknown (posted by Bourbon, updated for PB4.00 by blbltheworm)
; Date: 17. January 2004
; OS: Windows
; Demo: Yes

ScreenWidth = 640 
ScreenHeight = 480 
ScreenDepth = 16 

InitSprite() 
InitKeyboard() 
InitSprite3D() 
OpenScreen(ScreenWidth, ScreenHeight, ScreenDepth, "") 

CreateSprite(0,32,32,#PB_Sprite_Texture) 
StartDrawing(SpriteOutput(0)) 
For x=0 To 15 
  Box(x,x,32-(x <<1),32-(x <<1),RGB(x*16,x*16,x*16)) 
Next 
StopDrawing() 

CreateSprite3D(0,0) 
ZoomSprite3D(0, 32, 16) 

Repeat 
  
  FlipBuffers() 
  
  ClearScreen(RGB(0,0,0)) 
  StartDrawing(ScreenOutput()) 
  
  For x=0 To 63 
    Box(x*10, 0, 5, 480, RGB(0,0,192)) 
  Next 
  
  DrawingMode(1) 
  FrontColor(RGB(255,255,255)) 
  For x=0 To 11 
    For y=0 To 11 
      DrawText((x*52),(y*40)+16,Str(x) + "," + Str(y)) 
    Next 
  Next 
  
  StopDrawing() 
  
  Start3D() 
  For x=0 To 11 
    For y=0 To 11 
      Sprite3DBlendingMode(x,y) 
      DisplaySprite3D(0,x*52,y*40,255) 
    Next 
  Next 
  Stop3D() 
  
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Space) 
    GrabSprite(1, 0, 0, 640, 480 ,#PB_Sprite_Memory) 
    SaveSprite(1, "BlendModes.bmp") 
  EndIf 
  
Until KeyboardPushed(#PB_Key_Escape) Or EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
