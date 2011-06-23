; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6809&highlight=
; Author: Lance Jepsen (updated for PB4.00 by blbltheworm)
; Date: 05. July 2003
; OS: Windows
; Demo: Yes

; Analog Timer 
; Modified Danilo code by Lance Jepsen 

InitSprite() 
InitKeyboard() 

#ScreenWidth  = 800 
#ScreenHeight = 600 
#ScreenBits   = 32 
#MiddleX      = #ScreenWidth  / 2 
#MiddleY      = #ScreenHeight / 2 
#Radius       = 100 

Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

If OpenScreen(800,600,32,"") 

   Repeat 
      FlipBuffers() 
      ClearScreen(RGB(0,0,0)) 

      StartDrawing(ScreenOutput()) 
      Circle(#MiddleX, #MiddleY, 100, RGB(255,0,0)) 
      LineXY(#MiddleX,#MiddleY,#MiddleX+GSin(grad)*#Radius,#MiddleY+GCos(grad)*#Radius, RGB(0,255,0)) 
      StopDrawing() 
      Delay(1000) 
      grad = grad - 6 
      If grad = -6 : grad = 359 : EndIf 

      ExamineKeyboard() 
   Until KeyboardPushed(#PB_Key_Escape) 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
