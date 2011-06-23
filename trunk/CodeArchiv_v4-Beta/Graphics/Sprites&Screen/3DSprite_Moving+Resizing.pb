; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1623&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 06. July 2003
; OS: Windows
; Demo: Yes

; 
; by Danilo, 06.07.2003 - german forum 
; 
If InitSprite() And InitSprite3D() And InitKeyboard() 
  If OpenWindow(0,200,200,640,480,"Game",#PB_Window_SystemMenu) 
    If OpenWindowedScreen(WindowID(0), 0, 0, 640, 480, 0, 0, 0) 

      If CreateSprite(1, 64, 64, #PB_Sprite_Texture) 
        If StartDrawing(SpriteOutput(1)) 
          Box(00,00,64,64,$FF0000) 
          Box(32,00,32,32,$00FFFF) 
          Box(00,32,32,32,$00FFFF) 
          Box(32,32,32,32,$FF0000) 
          StopDrawing() 
        EndIf 

        If CreateSprite3D(0, 1) 

          Repeat 
            Repeat 
              Event = WindowEvent() 
              If Event=#PB_Event_CloseWindow:Quit = 1:EndIf 
            Until Event=0 
            FlipBuffers() 
            ExamineKeyboard() 
            If KeyboardPushed(#PB_Key_Escape) 
              Quit = 1 
            EndIf 
            ClearScreen(RGB($00,$00,$00)) 
            Start3D() 
              ZoomSprite3D(0,x,x) 
              RotateSprite3D(0,angle.f,1) 
              DisplaySprite3D(0,320-x/2,240-x/2,x) 
            Stop3D() 

            angle+1.0 
            If angle > 360:angle-360:EndIf 

            If flag=0 
              x+2 
              If x => 250:flag=1:EndIf 
            Else 
              x-4 
              If x <= 20 :flag=0:EndIf 
            EndIf 
            Delay(1) 
          Until Quit 
        EndIf 
      EndIf 
    EndIf 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
