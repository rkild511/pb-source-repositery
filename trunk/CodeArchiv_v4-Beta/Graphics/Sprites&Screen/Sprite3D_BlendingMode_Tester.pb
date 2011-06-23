; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2308&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 20. September 2003
; OS: Windows
; Demo: Yes

Global BackR, BackG, BackB 

If InitSprite()=0 Or InitSprite3D()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant initialize DirectX !",#MB_ICONERROR):End 
EndIf 

Procedure MakeSprite() 
  If CreateSprite(0,256,256) And CreateSprite(1,256,256,#PB_Sprite_Texture) 

    For sprite = 0 To 1 
      StartDrawing(SpriteOutput(sprite)) 
        For a = 127 To 0 Step -1 
          Circle(128,128,a,RGB($FF-(a<<1),$FF-(a<<1),$FF-(a<<1))) 
        Next a 
      StopDrawing() 
    Next sprite 

    ProcedureReturn CreateSprite3D(1,1) 
  Else 
    CloseScreen() 
    MessageRequester("ERROR","Cant create Sprite !",#MB_ICONERROR):End 
  EndIf 
EndProcedure 

Procedure SetBackgroundColor(r,g,b) 
  BackR = r 
  BackG = g 
  BackB = b 
  StartDrawing(ImageOutput(1)) 
    FrontColor(RGB(r,g,b)) 
    Box(0,0,100,50) 
  StopDrawing() 
  SetGadgetState(5,ImageID(1)) 
EndProcedure 

BlendMode_1 = 3 
BlendMode_2 = 5 

OpenWindow(0,0,0,600,360,"Sprite3D BlendingMode Tester",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  SetGadgetFont(#PB_Default,LoadFont(1,"Lucida Console",13)) 
  SpinGadget(1,590, 2, 10,26,0,24): SetGadgetState(1,BlendMode_1) 
  TextGadget(0,420, 8,130,18,"BlendMode 1:") 
  TextGadget(2,550, 8, 30,18,Str(BlendMode_1),#PB_Text_Right) 
  SpinGadget(3,590,32, 10,26,0,24): SetGadgetState(3,BlendMode_2) 
  TextGadget(0,420,38,130,18,"BlendMode 2:") 
  TextGadget(4,550,38, 30,18,Str(BlendMode_2),#PB_Text_Right) 
  
  ButtonImageGadget(5,5,5,100,50,CreateImage(1,100,50)) 

  If OpenWindowedScreen(WindowID(0),0,60,600,300,0,0,0)=0 
    MessageRequester("ERROR","Cant open DirectX screen !",#MB_ICONERROR):End 
  EndIf 

  MakeSprite() 

  SetBackgroundColor($00,$00,$64) 

Repeat 
  Select WindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 
          BlendMode_1 = GetGadgetState(1) 
          SetGadgetText(2,Str(BlendMode_1)) 
        Case 3 
          BlendMode_2 = GetGadgetState(3) 
          SetGadgetText(4,Str(BlendMode_2)) 
        Case 5 
          color = ColorRequester() 
          If color <> -1 
            SetBackgroundColor(Red(color),Green(color),Blue(color)) 
          EndIf 
      EndSelect 
    Case 0 
      FlipBuffers() 
      ExamineKeyboard() 
      If KeyboardPushed(#PB_Key_Escape):End:EndIf 

      ClearScreen(RGB(BackR,BackG,BackB)) 

      DisplayTransparentSprite(0,23,23) 

      Start3D() 
        Sprite3DBlendingMode(BlendMode_1,BlendMode_2) 
        DisplaySprite3D(1,300,23,255) 
      Stop3D() 
      
      Delay(100) 
      
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
