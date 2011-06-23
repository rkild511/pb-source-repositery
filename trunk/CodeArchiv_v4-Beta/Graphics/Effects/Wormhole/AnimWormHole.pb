; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2421&highlight=
; Author: Dennis (updated for PB4.00 by Deeem2031)
; Date: 29. September 2003
; OS: Windows
; Demo: Yes


; Note: you must run the CreateWormHole.pb code first to create the needed data file!
; Hinweis: Sie müssen erst den CreateWormHole.pb Code starten, um die benötigte Datendatei zu erstellen!

;/ Diese Datei liest WormHole.Dat 
;/ und animiert den Wurm 
Declare LoadPic() 
Declare PutPixel(x,y,col,buffer.l) 
Declare ViewBuffer(buffer.l) 
Declare GetPicture() 
Declare ShiftUp() 
Declare ShiftDown() 
Declare ShiftLeft() 
Declare ShiftRight() 


#PI=3.1415926535897931

#ScreenMem=0 


Global *ScreenBuffer,Temp.l,Color.l,BufferSize,pitch,V 

BufferSize = 640 << 8 + 640 << 7 + 640 << 6 +640 << 5 


If InitMouse()=#False:End:EndIf 
If InitKeyboard()=#False:End:EndIf 
If InitSprite()=#False:End:EndIf 


*ScreenBuffer = AllocateMemory(BufferSize) 
If *ScreenBuffer
  For N=0 To BufferSize 
    PokeB(*ScreenBuffer+N,0) 
  Next  
  OpenScreen(640,480,8,"") 
  
  SetRefreshRate(75) 
  GetPicture() 
  
  LoadPic() 
  StartDrawing(ScreenOutput()) 
  ;***************************** 
  ViewBuffer(*ScreenBuffer); * 
  ;***************************** 
  StopDrawing() 
  FlipBuffers() 
  StartDrawing(ScreenOutput()) 
  ;***************************** 
  ViewBuffer(*ScreenBuffer); * 
  ;***************************** 
  StopDrawing() 
  FlipBuffers() 
  
  Repeat 
    
    ShiftRight() 
    ShiftDown() 
    FlipBuffers() 
    
    ExamineKeyboard() 
  Until KeyboardPushed(#PB_Key_All) 
  
  Else 
  End 
EndIf  
Procedure PutPixel(x,y,col,buffer.l) 
  PokeB(buffer.l+640*y+x,col) 
EndProcedure 
Procedure ViewBuffer(buffer.l) 
  dbuffer=DrawingBuffer() 
  For y=0 To 479 Step 1 
    CopyMemory(buffer+(y <<9 + y << 7) ,dbuffer+y * DrawingBufferPitch(),640) 
  Next 
EndProcedure 
Procedure GetPicture() 
  InitPalette() 
  CreatePalette(0) 
  
  For N=0 To 255 
    SetPaletteColor(0,N,RGB(0,0,0)) 
  Next 
  For N=0 To 224 
    RE=PeekW(?Red+N*2) 
    GR=PeekW(?Green+N*2) 
    BL=PeekW(?Blue+N*2) 
    SetPaletteColor(0,N+1,RGB(RE,GR,BL)) 
    SetPaletteColor(0,N+1,RE+GR<<8+BL<<16) 
  Next 
  
  DisplayPalette(0) 
  
EndProcedure 
Procedure ShiftRight() 
  For M=0 To 15 
    V=M<<4-M 
    Temp=GetPaletteColor(0,15+V) 
    SetPaletteColor(0,15+V,GetPaletteColor(0,14+V)) 
    SetPaletteColor(0,14+V,GetPaletteColor(0,13+V)) 
    SetPaletteColor(0,13+V,GetPaletteColor(0,12+V)) 
    SetPaletteColor(0,12+V,GetPaletteColor(0,11+V)) 
    SetPaletteColor(0,11+V,GetPaletteColor(0,10+V)) 
    SetPaletteColor(0,10+V,GetPaletteColor(0, 9+V)) 
    SetPaletteColor(0, 9+V,GetPaletteColor(0, 8+V)) 
    SetPaletteColor(0, 8+V,GetPaletteColor(0, 7+V)) 
    SetPaletteColor(0, 7+V,GetPaletteColor(0, 6+V)) 
    SetPaletteColor(0, 6+V,GetPaletteColor(0, 5+V)) 
    SetPaletteColor(0, 5+V,GetPaletteColor(0, 4+V)) 
    SetPaletteColor(0, 4+V,GetPaletteColor(0, 3+V)) 
    SetPaletteColor(0, 3+V,GetPaletteColor(0, 2+V)) 
    SetPaletteColor(0, 2+V,GetPaletteColor(0, 1+V)) 
    SetPaletteColor(0, 1+V,Temp) 
   Next 
EndProcedure    
Procedure ShiftDown() 
  For M=1 To 15 
    Temp=GetPaletteColor(0,M+210) 
    SetPaletteColor(0,M+210,GetPaletteColor(0,M+195)) 
    SetPaletteColor(0,M+195,GetPaletteColor(0,M+180)) 
    SetPaletteColor(0,M+180,GetPaletteColor(0,M+165)) 
    SetPaletteColor(0,M+165,GetPaletteColor(0,M+150)) 
    SetPaletteColor(0,M+150,GetPaletteColor(0,M+135)) 
    SetPaletteColor(0,M+135,GetPaletteColor(0,M+120)) 
    SetPaletteColor(0,M+120,GetPaletteColor(0,M+105)) 
    SetPaletteColor(0,M+105,GetPaletteColor(0,M+ 90)) 
    SetPaletteColor(0,M+ 90,GetPaletteColor(0,M+ 75)) 
    SetPaletteColor(0,M+ 75,GetPaletteColor(0,M+ 60)) 
    SetPaletteColor(0,M+ 60,GetPaletteColor(0,M+ 45)) 
    SetPaletteColor(0,M+ 45,GetPaletteColor(0,M+ 30)) 
    SetPaletteColor(0,M+ 30,GetPaletteColor(0,M+ 15)) 
    SetPaletteColor(0,M+ 15,GetPaletteColor(0,M)) 
    
    SetPaletteColor(0,M,Temp) 
    Next 
EndProcedure 
  

Procedure LoadPic() 
  If OpenFile(0,"WormHole.Dat")<>0 
    For N=0 To BufferSize 
      PokeB(*ScreenBuffer+N,ReadByte(0)) 
    Next  
    CloseFile(0)
  Else 
    End 
  EndIf 
  
EndProcedure 
  
  DataSection 
  Red: 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  Data.w 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255 
  
  Green: 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,200,200,200,  0,  0,  0,200,200,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,200,  0,200,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,255,200,255,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,255,255,255,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,200,255,200,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,200,200,200,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,200,  0,200,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,200,  0,200,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,255,255,200,  0,200,255,255,200,  0,  0,  0 
  Data.w   0,  0,  0,200,200,200,200,  0,200,200,200,200,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  
  
  Blue: 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,  0,  0,  0,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,255,  0,255,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,255,255,255,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,  0,255,  0,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,  0,  0,  0,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,  0,  0,  0,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,  0,  0,  0,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,255,255,  0,  0,  0,255,255,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  Data.w   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 
  
  
  EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger
