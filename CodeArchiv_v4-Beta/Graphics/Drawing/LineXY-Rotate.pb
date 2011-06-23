; German forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 06. September 2002
; OS: Windows
; Demo: Yes


InitSprite() 
InitKeyboard() 

#ScreenWidth  = 800 
#ScreenHeight = 600 
#ScreenBits   = 32 
#MiddleX      = #ScreenWidth  / 2 
#MiddleY      = #ScreenHeight / 2 
#Radius       = 100 

Procedure.f GSin(winkel.f) 
   ; Eingabe: Winkel ( 0 - 360 ) 
   ; Ausgabe: Sinus vom Winkel 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ; Eingabe: Winkel ( 0 - 360 ) 
   ; Ausgabe: Cosinus vom Winkel 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

If OpenScreen(800,600,32,"Line-Test") 

   Repeat 
      FlipBuffers() 
      ClearScreen(RGB(0,0,0)) 

      StartDrawing(ScreenOutput()) 
         LineXY(#MiddleX,#MiddleY,#MiddleX+GSin(grad)*#Radius,#MiddleY+GCos(grad)*#Radius, $FFFFFF) 
      StopDrawing() 
      grad - 1 
      If grad = -1 : grad = 359 : EndIf 

      ExamineKeyboard() 
   Until KeyboardPushed(#PB_Key_Escape) 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger