; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13323&highlight=
; Author: Garzul (updated for PB 4.00 by Andre)
; Date: 08. December 2004
; OS: Windows
; Demo: Yes

;/********************************************* 
;/*                \\ Effect //               *  
;/*        \\  Made in Garzul | 2004  //      *  
;/* \\JaPBe > 2.4.7.17 || Purebasic > 3.91 // *  
;/********************************************* 

;Init component 
If InitSprite() = 0 Or InitKeyboard() = 0 

  MessageRequester("Erreur", "Impossible d'initialiser directx7 ou plus", #MB_ICONERROR) 
  End 
  
EndIf 


;-Open Screen 
If OpenScreen(1024,768,32,"") = 0 

  MessageRequester("Erreur", "Impossible d'ouvrir l'écran", #MB_ICONERROR) 
  End 
  
EndIf 
;Refresh screen in 60 
SetRefreshRate(60) 



;Variable 
Angle         = 0 
AffichAngle   = 1 
Red           = Random(255) 
Green         = Random(255) 
Blue          = Random(255) 
XPosition     = 400 
YPosition     = 400 
Size          = 1 
Size          = 1 
AffichHelp    = 0 


;Delay(2000) 

;******************************* Boucle ******************************** 
Repeat 

ClearScreen(RGB(0,0,0))


;Effect particle 
If AffichAngle = 1 

   Angle + 1 

EndIf 

If Angle > 50 And AffichAngle = 1 

   AffichAngle = 0 
  
EndIf 

If AffichAngle = 0 And Angle < 1 

   AffichAngle = 1 
  
EndIf 
  
If AffichAngle = 0 

   Angle - 1 

EndIf 


;-Create particle 
For i = 0 To XPosition Step 20 
  For e = 0 To YPosition Step 20 

  StartDrawing(ScreenOutput()) 
  
    Box(300 + i + Random(Angle),150 + e + Random(angle),Size,Size,RGB(Red,Green,Blue)) 
    
  StopDrawing() 
  
  Next 
Next 


;Display text 
StartDrawing(ScreenOutput()) 

  DrawingMode(1) 
  FrontColor(RGB(0 , 200 , 0 ))
  DrawText(0, 0, "Angle = " + Str(Angle)) 
  DrawText(0, 20, "Particle color ( RGB ) = " + Str(Red) + " , " + Str(Green) + " , " + Str(Blue)) 
  DrawText(0, 40, "Size particle zone = X " + Str(XPosition) + " , Y " + Str(YPosition)) 
  DrawText(0, 60, "Particle size = " + Str(Size)) 
  DrawText(0, 80, "Help = F1") 
  
StopDrawing() 


;Set color and block color 
ExamineKeyboard() 
If KeyboardReleased(#PB_Key_R) 

     Red   + 1 
    
   ElseIf KeyboardReleased(#PB_Key_G) 
    
     Green + 1 
      
   ElseIf KeyboardReleased(#PB_Key_B) 
    
     Blue  + 1 
      
EndIf 

If Red           > 255 

     Red   = 0 
    
   ElseIf Green > 255 
    
     Green = 0 
      
   ElseIf Blue  > 255 
    
     Blue  = 0 
      
EndIf 


;Size particle zone 
If KeyboardReleased(#PB_Key_Up) 

     YPosition + 1 
    
   ElseIf KeyboardReleased(#PB_Key_Down) 
    
     YPosition - 1 
      
   ElseIf KeyboardReleased(#PB_Key_Right) 
    
     XPosition + 1 
      
   ElseIf KeyboardReleased(#PB_Key_Left) 
    
     XPosition - 1  
      
EndIf 


;Particle size and block size in after 60 and 0 
If KeyboardReleased(#PB_Key_Add) 

     Size + 1 
    
   ElseIf KeyboardReleased(#PB_Key_Subtract) 
    
     Size - 1 
      
EndIf 

If Size < 0 

     Size = 0 
    
   ElseIf Size > 60 
    
     Size = 60 
      
EndIf 


;DisplayHelp 
If KeyboardReleased(#PB_Key_F1) And AffichHelp = 0 

     AffichHelp = 1 
      
EndIf 

If AffichHelp   = 1 

StartDrawing(ScreenOutput()) 

  DrawingMode(1) 
  FrontColor(RGB(0, 200, 200))
  DrawText(200, 740, "Key function : Change color = R , G , B : Change particle zone = Moving keys : Particle size = + and -") 
  
StopDrawing() 

EndIf 


;Close Help 
If AffichHelp = 1 
  If KeyboardPushed(#PB_Key_F1) 

     AffichHelp   = 0 
    
  EndIf 
EndIf 


;Inverse to buffer :) 
FlipBuffers() 

;****************************** End ************************************ 
Until KeyboardPushed(#PB_Key_Escape) 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -