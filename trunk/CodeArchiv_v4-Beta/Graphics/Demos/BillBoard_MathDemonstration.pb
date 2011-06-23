; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9122&postdays=0&postorder=asc&start=0
; Author: Hades
; Date: 07. July 2006
; OS: Windows
; Demo: Yes

; Small billboard demonstration in 2D

If InitSprite() = 0 
  MessageRequester("Error", "Can't open DirectX 7 or later", 0) 
  End 
EndIf 

Procedure TurnBB(BBX.f, BBZ.f, BBSize.f, AugeX.f, AugeZ.f) 
  Protected LookX.f, LookZ.f, VLength.f, RightX.f, RightZ.f 
  Protected X1.f, Y1.f, Z1.f, X2.f, Y2.f, Z2.f 
  LookX = AugeX - BBX 
  LookZ = AugeZ - BBZ 
  
  VLength = Sqr(LookX * LookX + LookZ * LookZ) 
  LookX = LookX / VLength 
  LookZ = LookZ / VLength 
  
  RightX = LookZ 
  RightZ = -LookX 
  
  X1 = BBX + -BBSize * RightX 
  Z1 = BBZ + -BBSize * RightZ 
  
  X2 = BBX + BBSize * RightX 
  Z2 = BBZ + BBSize * RightZ 
  
  LineXY(X1, Z1, X2, Z2, RGB(255,255,255)) 
EndProcedure 

If OpenWindow(0,0,0,400,400,"Billboard math in 2D", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_ScreenCentered) 
  If OpenWindowedScreen(WindowID(0),0,0,400,400,0,0,0) 
    Repeat 
      ClearScreen(RGB(0,0,0)) 
      StartDrawing(ScreenOutput()) 
      
      TurnBB(200.0, 200.0, 40.0, WindowMouseX(0), WindowMouseY(0)) 
      TurnBB(100.0, 300.0, 20.0, WindowMouseX(0), WindowMouseY(0)) 
      
      StopDrawing() 
      FlipBuffers() 
      Delay(1) 
      Event.l = WindowEvent() 
    Until Event = #PB_Event_CloseWindow 
  EndIf 
EndIf  
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP