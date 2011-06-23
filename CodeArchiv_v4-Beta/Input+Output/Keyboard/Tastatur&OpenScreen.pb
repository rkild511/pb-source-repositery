; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2067&highlight=
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 18. February 2003
; OS: Windows
; Demo: Yes

InitSprite() 
InitKeyboard() 
OpenScreen(800,600,16,"Eingabe") 
Repeat 
  ExamineKeyboard() 
  ClearScreen(RGB(0,0,0)) 
      If KeyboardReleased(#PB_Key_A) <> 0 
        Eingabe$ = Eingabe$ + "a" 
      EndIf    
      If KeyboardReleased(#PB_Key_B) <> 0 
        Eingabe$ = Eingabe$ + "b" 
      EndIf 
      If KeyboardReleased(#PB_Key_C) <> 0 
        Eingabe$ = Eingabe$ + "c" 
      EndIf  
      If KeyboardReleased(#PB_Key_D) <> 0 
        Eingabe$ = Eingabe$ + "d" 
      EndIf  
      If KeyboardReleased(#PB_Key_E) <> 0 
        Eingabe$ = Eingabe$ + "e" 
      EndIf  
      If KeyboardReleased(#PB_Key_F) <> 0 
        Eingabe$ = Eingabe$ + "f" 
      EndIf  
      If KeyboardReleased(#PB_Key_G) <> 0 
        Eingabe$ = Eingabe$ + "g" 
      EndIf  
      If KeyboardReleased(#PB_Key_H) <> 0 
        Eingabe$ = Eingabe$ + "h" 
      EndIf  
      If KeyboardReleased(#PB_Key_I) <> 0 
        Eingabe$ = Eingabe$ + "i" 
      EndIf  
      If KeyboardReleased(#PB_Key_J) <> 0 
        Eingabe$ = Eingabe$ + "j" 
      EndIf  
      If KeyboardReleased(#PB_Key_K) <> 0 
        Eingabe$ = Eingabe$ + "k" 
      EndIf  
      If KeyboardReleased(#PB_Key_L) <> 0 
        Eingabe$ = Eingabe$ + "l" 
      EndIf  
      If KeyboardReleased(#PB_Key_M) <> 0 
        Eingabe$ = Eingabe$ + "m" 
      EndIf 
      If KeyboardReleased(#PB_Key_N) <> 0 
        Eingabe$ = Eingabe$ + "n" 
      EndIf    
      If KeyboardReleased(#PB_Key_O) <> 0 
        Eingabe$ = Eingabe$ + "o" 
      EndIf    
      If KeyboardReleased(#PB_Key_P) <> 0 
        Eingabe$ = Eingabe$ + "p" 
      EndIf    
      If KeyboardReleased(#PB_Key_Q) <> 0 
        Eingabe$ = Eingabe$ + "q" 
      EndIf    
      If KeyboardReleased(#PB_Key_R) <> 0 
        Eingabe$ = Eingabe$ + "r" 
      EndIf    
      If KeyboardReleased(#PB_Key_S) <> 0 
        Eingabe$ = Eingabe$ + "s" 
      EndIf    
      If KeyboardReleased(#PB_Key_T) <> 0 
        Eingabe$ = Eingabe$ + "t" 
      EndIf    
      If KeyboardReleased(#PB_Key_U) <> 0 
        Eingabe$ = Eingabe$ + "u" 
      EndIf    
      If KeyboardReleased(#PB_Key_V) <> 0 
        Eingabe$ = Eingabe$ + "v" 
      EndIf    
      If KeyboardReleased(#PB_Key_W) <> 0 
        Eingabe$ = Eingabe$ + "w" 
      EndIf    
      If KeyboardReleased(#PB_Key_X) <> 0 
        Eingabe$ = Eingabe$ + "x" 
      EndIf    
      If KeyboardReleased(#PB_Key_Y) <> 0 
        Eingabe$ = Eingabe$ + "y" 
      EndIf    
      If KeyboardReleased(#PB_Key_Z) <> 0 
        Eingabe$ = Eingabe$ + "z" 
      EndIf  
      If KeyboardReleased(#PB_Key_Space) <> 0 
        Eingabe$ = Eingabe$ + " " 
      EndIf 
      If KeyboardReleased(#PB_Key_Back) <> 0 
        Eingabe$ = Mid(Eingabe$, 0, Len(Eingabe$)-1) 
      EndIf    
    StartDrawing(ScreenOutput()) 
    DrawingMode(1) 
    FrontColor(RGB(100,255,0)) 
    DrawText(0,100,Eingabe$) 
    StopDrawing() 
    FlipBuffers() 
Until KeyboardPushed(1) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
