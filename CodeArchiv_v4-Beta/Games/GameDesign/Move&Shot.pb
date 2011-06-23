; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2820&highlight=
; Author: U.D.O (updated for PB4.00 by blbltheworm)
; Date: 21. November 2003
; OS: Windows
; Demo: Yes


; Simples Beispiel zum Bewegen und Schiessen:
; Gesteuert wird mit den Cursortasten und schießen mit der Leertaste. 

;#####Initialisierung 
InitSprite() 
InitKeyboard() 
OpenScreen(800, 600, 16, "Test") 

;#####Variablen 
Global playerX.w        
Global playerY.w        
Global schussX.w            
Global schussY.w 


playerX = 50 
playerY = 400 


;######MainLoop 
Repeat 
  FlipBuffers() 
  ExamineKeyboard() 
  ClearScreen(RGB(0,0,0))  
  
  If KeyboardPushed(#PB_Key_Up) And playerY > 0 : playerY -3 : EndIf 
  If KeyboardPushed(#PB_Key_Down) And playerY < 600 : playerY +3 : EndIf 
  If KeyboardPushed(#PB_Key_Left) And playerX > 0 : playerX -3 : EndIf 
  If KeyboardPushed(#PB_Key_Right) And playerX < 800 : playerX +3 : EndIf 
  
  If KeyboardReleased(#PB_Key_Space) 
    schussX = playerX 
    schussY = playerY 
    schuss = 1 
  EndIf 
  
  If  schuss < 600 
    schussX +6 
  Else 
    schuss = 0 
  EndIf 
  
  StartDrawing(ScreenOutput()) 
    FrontColor(RGB(50,0,150)) : Circle(playerX, playerY, 30)  
    If schuss : FrontColor(RGB(150,0,50)) : Circle(schussX, schussY, 5) : EndIf 
  StopDrawing() 
  
Until KeyboardReleased(#PB_Key_Escape) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
