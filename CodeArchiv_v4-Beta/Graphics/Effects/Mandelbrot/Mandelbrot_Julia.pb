; English forum: 
; Author: Froggerprogger (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


;coded by Froggerprogger 
;depending on codes from WolfgangS and Danilo 
; 
;It shows the julia set with a mouse-varied constant. 
;So just move the mouse carefully And pray for a faster CPU... 
; 
;turn the Debugger off! 

Declare drawfractal(cx.f, cy.f) 
#xmax=1024 
#ymax=768 

#maxcolor=32 

#leftside   =-2 
#top        =1.5 
xside.f     =4 
yside.f     =-3 
xscale.f    =xside/#xmax          
yscale.f    =yside/#ymax 
cx.f = -0.033 : cy.f = 0.696 
;or try cx.f = -0.773 :   cy.f = -0.109 

; Structure LONG     ; in PB3.70+ already declared
;   l.l 
; EndStructure 

If InitSprite()=0 Or InitKeyboard()=0 Or InitMouse()=0 
  Beep_(300,300):End:EndIf 

MessageRequester("","Move the mouse !"+Chr(13)+Chr(10)+"ESC = Exit",0) 

OpenScreen(#xmax,#ymax,32,"") 


Procedure drawfractal(cx.f,cy.f) 
  Shared xscale, yscale 

  StartDrawing(ScreenOutput()) 
    Buffer = DrawingBuffer() 
    Pitch  = DrawingBufferPitch() 
  For y= 0 To #ymax-1 
    *Line.LONG = Buffer+y*Pitch 
    For x= 0 To #xmax-1 
      zx.f= x*xscale+#leftside 
      zy.f= y*yscale+#top 
        
      colorcounter=0 
      
      PowZX.f = 0 
      PowZY.f = 0 
  
      Repeat 
  
        PowZX = zx*zx 
        PowZY = zy*zy 
        tempx.f = PowZX-PowZY+cx 
        zy      = 2 * zx * zy + cy 
        zx      = tempx 
        colorcounter+1 
          
      Until PowZX+PowZY>4 Or colorcounter>=#maxcolor 
      
      floatvalue.f = colorcounter / #maxcolor * $B0 * 3 
      *Line\l = RGB(floatvalue, floatvalue / 2, floatvalue / 3) 
      ;*Line\l = colorcounter * $111111 
      *Line+4 
    Next 
  Next 
  FrontColor(RGB(255,255,255)) 
  DrawingMode(1) 
  DrawText(0,0,"x: "+StrF(cx,4) + "    y: "+StrF(cy,4)+"          ") 
  StopDrawing() 
  FlipBuffers() 
EndProcedure 


Repeat 
   ExamineMouse() 

   cx + MouseDeltaX()*0.005 
   cy - MouseDeltaY()*0.005    
    
   drawfractal(cx,cy) 

   ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_Escape) 
CloseScreen()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger