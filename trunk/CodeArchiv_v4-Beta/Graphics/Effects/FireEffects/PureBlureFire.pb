; German forum:
; Author: GPI (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 22. September 2003
; OS: Windows
; Demo: Yes


; **Boolean Operatoren 
  #True=1 
  #False=0 

Global *Firebuffer  


Declare ViewBuffers() 
Declare.w RecalculateByte(Byte.b) 
Declare Error(Error.s) 
Declare TestSprite() 
Declare TestKeyboard() 
Declare PutPixel(x,y,col) 
Declare.b GetPixel(x,y) 

TestSprite() 
TestKeyboard() 

If OpenScreen(640,480,8,"PureFire") = #False 
  Error("Bildauflösung..") 
  End 
EndIf 

If InitMouse()=#False 
  Error("Keine Mause") 
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
;CreateFile(0,"BlurErgs.txt") 

*Firebuffer = AllocateMemory(640*480)  
If *Firebuffer = #False
  Error("Konnte Speicher nicht allokieren!!") 
  End 
EndIf 


For n=1 To 640*480 
  PokeB(*Firebuffer+n,0) 
Next 

MouseLocate(320,200) 

Repeat 

  
  ;For NY=0 To 256 
  ;For NX=0 To 256 
  ;putpixel(NX,NY,NX) 
  ;Next 
  ;Next 
  ;-----------MouseBranding------------ 
  PutPixel(MouseX(),MouseY(),200) 
  PutPixel(MouseX()-1,MouseY(),200) 
  PutPixel(MouseX()+1,MouseY(),200) 
  PutPixel(MouseX(),MouseY()-1,200) 
  PutPixel(MouseX(),MouseY()+1,200) 
  PutPixel(MouseX()-1,MouseY()-1,200) 
  PutPixel(MouseX()+1,MouseY()-1,200) 
  PutPixel(MouseX()-1,MouseY()+1,200) 
  PutPixel(MouseX()+1,MouseY()+1,200) 
  
  
  
  
  ;-----------Setup Random-Pixels------------- 
  For Pix=0 To 639 
    R.b=Random(255) 
    PutPixel(Pix,479,R) 
    PutPixel(Pix,478,R) 
    PutPixel(Pix,477,R) 
    PutPixel(Pix,476,R) 
    PutPixel(Pix,475,R) 
  Next 
  ;------------Blur the thing---------------- 
  For NY=100 To 479 
    For NX=150  To 470 
      a.w=RecalculateByte(GetPixel(NX+1,NY)) 
      b.w=RecalculateByte(GetPixel(NX-1,NY)) 
      c.w=RecalculateByte(GetPixel(NX,NY+1)) 
      D.w=RecalculateByte(GetPixel(NX,NY-1)) 
      E.b=(a+b+c+D)>>2 
      f.w=RecalculateByte(E.b) 
      If f>0 
        f=f-1 
      EndIf 
      E.b=f 
      ;WriteStringN("Blurr:="+Str(RecalculateByte(E.b))) 
      PutPixel(NX,NY-1,E.b) 
      
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
;CloseFile(0) 
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
  PokeB(*Firebuffer+(y<<9)+(y<<7)+x,col) 
EndProcedure 
;----------------------------------- 
Procedure.b GetPixel(x,y) 
  ProcedureReturn PeekB(*Firebuffer+(y<<9)+(y<<7)+x) 
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

  For y=0 To 474 
    buffer=DrawingBuffer() 
    pitch=DrawingBufferPitch() 
    CopyMemory(*Firebuffer+(y<<9)+(y<<7),buffer+y*pitch,640) 
  
  Next 

EndProcedure 
;-------------------------------------- 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; Executable = C:\Programming\PureBlureFire.exe
; DisableDebugger