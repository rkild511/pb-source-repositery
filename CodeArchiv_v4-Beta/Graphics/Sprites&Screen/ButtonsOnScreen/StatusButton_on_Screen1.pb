; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1898&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 04. August 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 04.08.2003 - german forum 
; 
If InitSprite()=0 Or InitMouse()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init DirectX !",#MB_ICONERROR):End 
EndIf 

If OpenScreen(1024,768,16,"Vollbild")=0 
  MessageRequester("ERROR","Cant open screen !",#MB_ICONERROR):End 
EndIf 

If CreateSprite(0,100,100)=0 Or CreateSprite(1,100,100)=0 Or CreateSprite(2,16,16)=0 
  CloseScreen() 
  MessageRequester("ERROR","Cant create sprites !",#MB_ICONERROR):End 
EndIf 

hFnt = LoadFont(1,"Arial",72) 

For a = 0 To 1 
  StartDrawing(SpriteOutput(a)) 
    Box(0,0,100,100,RGB(a*255,a*255,(a!1)*255)) 
    FrontColor(RGB((a!1)*255,(a!1)*255,a*255)) 
    DrawingFont(hFnt):DrawingMode(1) 
    DrawText(50-TextWidth(Str(a))/2,0,Str(a)) 
  StopDrawing() 
Next a 

StartDrawing(SpriteOutput(2)) 
  Circle(8,8,7,RGB($00,$FF,$FF)) 
StopDrawing() 

;Sprite = 0 
MouseLocate(243,243) 

Repeat 
  FlipBuffers() 
  ExamineKeyboard() 
  ExamineMouse() 
  ClearScreen(RGB(0,0,0)) 


  ;- Mausabfrage 
  ;  hier sollte die mausabfage stehen - also if mausklick, 
  ;  zeig bild, warte auf mausklick... 
  MouseX       = MouseX() 
  MouseY       = MouseY() 

  If MouseButton(1) And MouseState=0 
    If MouseX>=200 And MouseX<=300 And MouseY>=200 And MouseY<=300 
      Box        ! 1 
      MouseState ! 1 
      MouseTime  = timeGetTime_() 
    EndIf 
  EndIf 

  If MouseState ; If Mouse was pressed, check time 
    If timeGetTime_() => MouseTime + 400 
      MouseState ! 1 
    EndIf 
  EndIf 


  ;- Sprites anzeigen 
  DisplaySprite(Box,200,200) 
  DisplayTransparentSprite(2,MouseX,MouseY) 

Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
