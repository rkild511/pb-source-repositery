; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2420&highlight=
; Author: Dennis (updated for PB4.00 by blbltheworm)
; Date: 29. September 2003
; OS: Windows
; Demo: Yes


;/DX_GraphicsTest width 256-Colormode 
;/A Boss Plasma by Dennis Briese (M) 

Declare Error(Message.s) 
Declare PutPixel(x,y,col,buffer.l) 
Declare ViewBuffer(buffer.l) 
Declare PreSin() 
Declare PrePal() 
Declare SetUpImageText()        

Global *GraphicsBuffer 
Global Dim SinPre(1800) 

#BILDX=800 
#BILDY=600 
#PLASWIDTHX=320 
#PLASWIDTHY=200 
CenterX=#BILDX/2 
CenterY=#BILDY/2 
FENSTERPOSX=CenterX-#PLASWIDTHX/2 
FENSTERPOSY=CenterY-#PLASWIDTHY/2 

*GraphicsBuffer = AllocateMemory(#BILDX*#BILDY) 
If *GraphicsBuffer
  
  For n=0 To #BILDX*#BILDY-1 
    PokeB(*GraphicsBuffer+n,0) 
  Next 
  
  If InitSprite()=#False:Error("DirectX erforderlich"):EndIf 
  If InitKeyboard()=#False:Error("Kein Keyboard"):EndIf 
  If InitMouse()=#False:Error("Keine Mouse"):EndIf 
  
  If OpenScreen(#BILDX,#BILDY,8,"") 
    
    ;SetUpImageText();Wer hier etwas ändern möchte entferne das Semikolon vorn 
    PreSin() 
    PrePal() 
    
    Repeat 
      Count+1 
      
      If Count>720 :Count=0:EndIf 
        
      For C=0 To #PLASWIDTHX 
        E=SinPre((C << 1)+(Count>>1)) 
        E=E+SinPre(C+(Count << 1)) 
        E=E+(SinPre((C >> 1)+Count)<<1) 
        E=75+(E>>6) 
    
        For D=0 To #PLASWIDTHY 
          f=(SinPre(d +(Count << 1))<<1)  
          f=f+SinPre((d << 1)+(Count >> 1)) 
          f=f+(SinPre(d+Count)<<1) 
          f=75+(f>>5) 
          
          PutPixel(FENSTERPOSX+c,FENSTERPOSY+d,(e*f)>>5,*GraphicsBuffer) 
          
        Next 
      Next 
  
      
    
      StartDrawing(ScreenOutput()) 
       ViewBuffer(*GraphicsBuffer) 
      StopDrawing() 
      
      ;DisplayTransparentSprite(0,FENSTERPOSX,FENSTERPOSY);Und dies auch!! 
      
      FlipBuffers() 
      ExamineKeyboard() 
    Until KeyboardPushed(#PB_Key_All) 
  
  EndIf 
Else 
  Error("NO Memory !!") 

EndIf 
Procedure Error(Message.s) 
  MessageRequester("Error",Message,#PB_MessageRequester_Ok) 
  End 

EndProcedure 
Procedure PutPixel(x,y,col,buffer.l) 
  PokeB(buffer.l+#BILDX*y+x,col) 
EndProcedure 
Procedure ViewBuffer(buffer.l) 
  For y=0 To #BILDY-1 
    dbuffer=DrawingBuffer() 
    pitch=DrawingBufferPitch() 
    CopyMemory(buffer+#BILDX*y,dbuffer+y*pitch,#BILDX) 
  Next 
EndProcedure 
Procedure PreSin() 
  For  a=0 To 1799 
    SinPre(a)=(Sin((#PI*a)/180)*1024) 
    SinPre(a)=Pow(SinPre(a),2)/1000 
    
  Next 
EndProcedure 
Procedure PrePal() 
    InitPalette() 
    CreatePalette(0) 
    For n=0 To 255 
      SetPaletteColor(0,n,RGB(0,0,0)) 
    Next 
    For n=0 To 41 
      SetPaletteColor(0,n,RGB(r,g,b)) 
      r=r+2 
    Next      
    For n=42 To 83 
      SetPaletteColor(0,n,RGB(r,g,b)) 
      g=g+2:b+2 
    Next 
    For n=84 To 125 
      SetPaletteColor(0,n,RGB(r,g,b)) 
      b=b+2 
    Next 
    For n=126 To 167 
      SetPaletteColor(0,n,RGB(r,g,b)) 
      r=r-2 
    Next 
    For n=168 To 209 
      SetPaletteColor(0,n,RGB(r,g,b)) 
      g=g-2 
    Next 
    For n=210 To 252 
      SetPaletteColor(0,n,RGB(r,g,b)) 
      b=b-2 
    Next 
    
    DisplayPalette(0) 
  EndProcedure    
Procedure SetUpImageText() 
  LoadFont(0,"NewTimesRoman",4) 
  
  
  CreateSprite(0,#PLASWIDTHX+1,#PLASWIDTHY+1) 
  
  StartDrawing(SpriteOutput(0)) 
  Box(0,0,#PLASWIDTHX+1,#PLASWIDTHY+1,RGB(200,200,200)) 
  DrawingFont(FontID(0)) 
   BackColor(RGB(200,200,200)) 
   FrontColor(RGB(1,1,1)) 
   DrawingMode(0) 
    
  For y=0 To 200 Step 6 
    For x=0 To 320 Step 4 
      DrawText(x,y,Chr(Random(5)+65)) 
    Next 
  Next 
  
  StopDrawing() 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger
