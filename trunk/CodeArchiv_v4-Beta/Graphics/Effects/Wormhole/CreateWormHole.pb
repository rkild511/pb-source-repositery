; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2421&highlight=
; Author: Dennis (updated for PB4.00 by Deeem2031)
; Date: 29. September 2003
; OS: Windows
; Demo: Yes


;/ Dieses Programm Erstellt das Bild des Wurms 
;/ und speichert dieses als WormHole.Dat 
;/ AUTHOR: Dennis Briese(M) 
Declare DrawWormHole() 
Declare PutPixel(x,y,col,buffer.l) 
Declare AbsLNG(a.l) 
Declare Mod(a, b) 


#ScreenMem=0 
#PI=3.1415926535897931

Global *ScreenBuffer 
BufferSize = 640 << 8 + 640 << 7 + 640 << 6 + 640 << 5 
  


*ScreenBuffer = AllocateMemory(BufferSize)
If *ScreenBuffer
  
  For N=0 To BufferSize 
    PokeB(*ScreenBuffer+N,0) 
  Next  
  DrawWormHole() 
  CreateFile(0,"WormHole.Dat") 
  For N=0 To BufferSize 
    WriteByte(0,PeekB(*ScreenBuffer+N)) 
  Next 
  
  CloseFile(0) 
EndIf 

Procedure DrawWormHole() 
  #SPOKES=9600 
  #DIVS=2400 
  #STRETCH=50 
  #XCENTER=320 
  #YCENTER=240 
  Define.f xf,yf,zf 
  Define.w i1,j1,Color1 
  For j1=1 To #DIVS 
    For i1=0 To #SPOKES-1 
      zf=-1.0+(Log(2.0*j1/#DIVS)) 
      xf=(640.0*j1/#DIVS*Cos(2*#PI*i1/#SPOKES)) 
      yf=(480.0*j1/#DIVS*Sin(2*#PI*i1/#SPOKES)) 
      yf=yf-#STRETCH*zf 
      xf+#XCENTER 
      yf+#YCENTER 
      Color1=Mod(i1/16,15)+15*Mod(j1/8,15)+1 
      If xf>=0 And xf<=640 And yf>=0 And yf<=480 
        PutPixel(xf,yf,Color1,*ScreenBuffer) 
                
        
      EndIf 
    Next 
  Next 
  
EndProcedure 
Procedure PutPixel(x,y,col,buffer.l) 
  PokeB(buffer.l+640*y+x,col) 
EndProcedure 
Procedure AbsLNG(a.l) 
  If a >> 31 
    a * -1 
  EndIf 
  ProcedureReturn a 
EndProcedure 

Procedure Mod(a, b) 
  Erg.l = a - a / b * b 
  If a >> 31 : Erg + AbsLNG(b) : EndIf 
  ProcedureReturn Erg 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
