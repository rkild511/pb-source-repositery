; German forum: 
; Author: Unknown (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm + Andre)
; Date: 18. October 2003
; OS: Windows
; Demo: Yes


; **Boolean Operatoren 
  #True=1 
  #False=0 

Global *Firebuffer  

Declare DrawLine(x1,y1,x2,y2,col) 
Declare ViewBuffers() 
Declare.w RecalculateByte(Byte.b) 
Declare Error(Error.s) 
Declare TestSprite() 
Declare TestKeyboard() 
Declare PutPixel(x,y,col) 
Declare.b GetPixel(x,y) 

TestSprite() 
TestKeyboard() 

If OpenScreen(320,200,8,"PureFire") = #False 
  Error("Bildauflösung..") 
  End 
EndIf 

If InitMouse()=#False 
  Error("Keine Mouse") 
  End 
EndIf 
If InitPalette()=#False 
  Error("Kann Palettemodus nicht intitialisieren") 
  End 
EndIf 

CreatePalette(0) 

For Index=0 To 63 
  ;Color=Rot+Grün<<8+Blau<<16 
  Color=Index*4+0<<8+0<<16 
  SetPaletteColor(0,Index,Color)  
Next 
For Index=0 To 63 
  Color=252+((Index*4)/2)<<8+0<<16 
  SetPaletteColor(0,Index+64,Color) 
Next 
For Index=0 To 63 
  Color=255+((Index*4)/2+125)<<8+(Index*4)<<16 
  SetPaletteColor(0,Index+128,Color) 
Next 
For Index=0 To 63 
  Color=255-(Index*4)+255-(Index*4)<<8+255<<16 
  SetPaletteColor(0,Index+192,Color) 
Next 

DisplayPalette(0) 
*Firebuffer = AllocateMemory(320*200)
If *Firebuffer = #False 
  Error("Konnte Speicher nicht allokieren!!") 
  End 
EndIf 


For n=1 To 320*200 
  PokeB(*Firebuffer+n,0) 
Next 

MouseLocate(160,100) 

Repeat 
  
  
  ;For NY=0 To 256 
  ;For NX=0 To 256 
  ;putpixel(NX,NY,NX) 
  ;Next 
  ;Next 
  ;-----------MouseBranding------------ 
  If MouseX()>0 And MouseY()>0 
    If MouseX()<320 And MouseY()<200 
      PutPixel(MouseX(),MouseY(),200) 
      PutPixel(MouseX()-1,MouseY(),200) 
      PutPixel(MouseX()+1,MouseY(),200) 
      PutPixel(MouseX(),MouseY()-1,200) 
      PutPixel(MouseX(),MouseY()+1,200) 
      PutPixel(MouseX()-1,MouseY()-1,200) 
      PutPixel(MouseX()+1,MouseY()-1,200) 
      PutPixel(MouseX()-1,MouseY()+1,200) 
      PutPixel(MouseX()+1,MouseY()+1,200) 
    EndIf 
  EndIf 
  
  
  
  ;-----------Setup Lines------------- 
  
  x=x+d1:x2=x2+d3 
  y=y+d2: y2=y2+d4 
  If x>310 : d1=-Random(10)+1:EndIf 
  If x<10 : d1=Random(10)+1:EndIf 
  If y>190 : d2=-Random(10)+1:EndIf 
  If y<16  : d2= Random(10)+1:EndIf 
  If x2>310 : d3=-Random(10)+1:EndIf 
  If x2<10 : d3=Random(10)+1:EndIf 
  If y2>190 : d4=-Random(10)+1:EndIf 
  If y2<16  : d4= Random(10)+1:EndIf 
  
  
  DrawLine(x,y,x2,y2,255) 
  
  
  ;------------Blur the thing---------------- 
  For NY=1 To 200 
    For NX=1  To 320 
      A.w=RecalculateByte(GetPixel(NX+1,NY)) 
      b.w=RecalculateByte(GetPixel(NX-1,NY)) 
      C.w=RecalculateByte(GetPixel(NX,NY+1)) 
      D.w=RecalculateByte(GetPixel(NX,NY-1)) 
      
      
      E.b=(A+b+C+D)>>2 
      f.w=RecalculateByte(E.b) 
      If f>0 
      f=f-1 
      EndIf 
      E.b=f 
      PutPixel(NX,NY,E) 
      
    Next 
  Next 
  
  ;-----------------The Only Thing to Draw------------- 
  StartDrawing(ScreenOutput()) 
  ;************* 
  ViewBuffers() 
  ;************* 
  StopDrawing() 
  
  ExamineKeyboard() 
  ExamineMouse() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_All) 
FreeMemory(*Firebuffer) 
;--->End of Programm 
End 





;P R O C E D U R E S 
;---------------------------------- 
Procedure Error(Error.s) 
  MessageRequester("FehlerTeufel", Error.s,#PB_MessageRequester_Ok) 
  End 
EndProcedure 
;---------------------------------- 

Procedure TestSprite() 
  If InitSprite() = #False 
    Error("Kann DirectX7 oder höher nicht finden!") 
  EndIf 
EndProcedure 
;----------------------------------- 

Procedure TestKeyboard() 
  If InitKeyboard() = #False 
    Error("Kein Keyboard..") 
  EndIf 
EndProcedure 
;----------------------------------- 
Procedure PutPixel(x,y,col) 
  PokeB(*Firebuffer+(y<<8)+(y<<6)+x,col) 
EndProcedure 
;----------------------------------- 
Procedure.b GetPixel(x,y) 
  ProcedureReturn PeekB(*Firebuffer+(y<<8)+(y<<6)+x) 
EndProcedure 
;----------------------------------- 
Procedure.w RecalculateByte(Byte.b) 

  If Byte < 0 
    recalc.w=Byte+256 
  Else  
    recalc.w=Byte 
  EndIf 
  ProcedureReturn recalc 
EndProcedure 
;------------------------------------- 
Procedure ViewBuffers() 
  
  For y=0 To 194 
    buffer=DrawingBuffer() 
    pitch=DrawingBufferPitch() 
    CopyMemory(*Firebuffer+(y<<8)+(y<<6),buffer+y*pitch,320) 
  
  Next 

EndProcedure 
;-------------------------------------- 

Procedure DrawLine(x1,y1,x2,y2,col) 
  
  x=x1:y=y1:D=0 
  hx=x2-x1 
  hy=y2-y1 
  xinc=1:yinc=1 
  
  If hx<0 
    xinc=-1:hx=-hx 
  EndIf 
  
  If hy<0 
    yinc=-1:hy=-hy 
  EndIf 
  
  If hy<=hx 
    c=2*hx:m=2*hy 
    L1: 
    PutPixel(x,y,col) 
    If x=x2:Goto BR1:EndIf 
    x=x+xinc 
    d=d+m 
    If d>hx : y=y+yinc : d=d-c : EndIf 
    Goto L1 
    BR1: 
  Else 
    
    c=2*hy:m=2*hx 
    
    L2: 
    PutPixel(x,y,col) 
    
    If y=y2 : Goto BR2 : EndIf 
    
    y=y+yinc 
    d=d+m 
    
    If d>hy : x=x+xinc : d=d-c : EndIf 
    Goto L2 
    BR2: 
  EndIf 
  
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger