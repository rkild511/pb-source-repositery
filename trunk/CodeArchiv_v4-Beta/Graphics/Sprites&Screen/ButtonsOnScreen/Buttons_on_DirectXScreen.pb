; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: Yes


InitSprite() 
InitKeyboard() 
InitMouse() 

OpenScreen(800,600,32,"Test") 
   CreateGadgetList(ScreenID()) 
   ButtonGadget(1,10,10,100,20,"Button 1",#PB_Button_Toggle) 
   ButtonGadget(2,10,30,100,20,"Button 1",#PB_Button_Toggle) 
   SetGadgetState(1,1) 
   FlipBuffers() 
   GrabSprite(1,10,10,100,20) 
   GrabSprite(2,10,30,100,20) 
   FreeGadget(1):FreeGadget(2) 

   CreateSprite(3,16,16) 
     StartDrawing(SpriteOutput(3)): Line(0,0,16,16,$FFFF): StopDrawing() 

Repeat 
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
  ExamineMouse() 
  MouseX = MouseX() 
  MouseY = MouseY() 
  If MouseButton(1) And MouseX > 50 And MouseX < 150 And MouseY > 50 And MouseY < 70 
     mousesprite = 1 
  Else 
     mousesprite = 2 
  EndIf 
  DisplaySprite(mousesprite,50,50) 
  DisplayTransparentSprite(3,MouseX(),MouseY()) 
  ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) 
     End 
  EndIf 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -