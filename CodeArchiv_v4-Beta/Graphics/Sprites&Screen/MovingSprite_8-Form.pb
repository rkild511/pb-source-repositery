; German forum: http://www.purebasic.fr/german/viewtopic.php?t=125&highlight=
; Author: Bernd (updated for PB 4.00 by Andre)
; Date: 14. September 2004
; OS: Windows
; Demo: Yes


; Als Bahngleichung benutze ich eine Lemniskate, wird u.a. im 
; Strassen- und Schienenbau angewandt. Diese Kurve beschreibt in den 
; Grenzen 0 bis 2 PI exakt eine liegende 8 (Zeichen für Unendlichkeit). 
; 
; Als Grundlage habe ich das Sprite-Beispiel aus Pure Basic genommen. 

; ------------------------------------------------------------ 
; 
;   Lemniskate 
; 
;    
; ------------------------------------------------------------ 
; 

If InitSprite() = 0 Or InitKeyboard() = 0 
  MessageRequester("Error", "Can't open DirectX 7 or later", 0) 
  End 
EndIf 
  
 intervall.f= 3.14/50 ;pi verteilt 
 t.f=0 
; 
; 

If OpenScreen(640, 480, 16, "Sprite") 

  
  ; 
  LoadSprite(0, "..\Gfx\PureBasic.bmp", 0) 
  CopySprite(0,1,0) 
  
  
  Repeat 
    
    
    
    FlipBuffers() 
    
     ClearScreen(RGB(0,0,0))
    
    
      
    t.f = t.f + intervall.f 
    
    y.f = 300 * Sin(t) * Cos(t) / (1 + Pow (Sin(t),2))+200 ; Lemniskate in Kartesischen Koordinaten 
    x.f = 300 * Cos(t) / (1 + Pow (Sin(t),2))+300            
    
    DisplaySprite(0, x, y) ; koordinatenursprung in Bildmitte 
    
    If t > 6.28             ;Richtungswechsel 
      
      t=0 
      
     EndIf 
          
     If t < 0 
      intervall = 3.14/50 
    EndIf 
        
    ExamineKeyboard() 
  Until KeyboardPushed(#PB_Key_Escape) 
  
Else 
  MessageRequester("Error", "Can't open a 640*480 - 16 bit screen !", 0) 
EndIf 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -