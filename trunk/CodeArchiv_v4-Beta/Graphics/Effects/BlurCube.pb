; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1566&highlight=
; Author: Dennis (updated for PB4.00 by blbltheworm + Andre)
; Date: 01. July 2003
; OS: Windows
; Demo: Yes


; **Boolean Operatoren 
  #True=1 
  #False=0 

Structure Point2d 
x.w 
y.w 
EndStructure 

Structure Point3d 
x.f 
y.f 
z.f 
EndStructure  


Global Dim CubeList.Point3d(8) 
Global Dim ScreenList.Point2d(100) 
;Dim World.Point3d(100) 



;--------------GLOBALS-------------------------------------- 
Global *Firebuffer,objD.f,objsize.f 
Global v11.f,v12.f,v13.f,v21.f,v22.f,v23.f,v32.f,v33.f,v43.f 

;------------Declares-------------------------------------- 
Declare DrawCube() 
Declare DrawLine(x1,y1,x2,y2,col) 
Declare ViewBuffers() 
Declare.w RecalculateByte(Byte.b) 
Declare Error(Error.s) 
Declare TestSprite() 
Declare TestKeyboard() 
Declare PutPixel(x,y,col) 
Declare.b GetPixel(x,y) 
Declare InitObj() 
Declare EyeScreen() 
Declare Perspect(theta.f,phi.f,rho.f) 
Declare Bind(vertex1,vertex2) 
Declare rotateZ(alpha.f) 
Declare rotateX(alpha.f) 
Declare Clear() 


TestSprite() 
TestKeyboard() 
CreateFile(0,"Cube.dat") 


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
If  *Firebuffer = #False 
  Error("Konnte Speicher nicht allokieren!!") 
  End 
EndIf 


For n=1 To 320*200 
  PokeB(*Firebuffer+n,0) 
Next 

MouseLocate(160,100) 


maxX=319 
maxY=199 

InitObj() 
Perspect(0.3,1.3,5*objsize) 

Repeat 
  EyeScreen() 
  rotateZ(0.09) 
  rotateX(0.09) 
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
  
  
  
  ;---------Draw a funny cube--------- 
  DrawCube() 
  
  ;------------Blur the thing---------------- 
  For NY=1 To 200 
    For NX=1  To 320 
      A.w=RecalculateByte(GetPixel(NX+1,NY)) 
      b.w=RecalculateByte(GetPixel(NX-1,NY)) 
      C.w=RecalculateByte(GetPixel(NX,NY+1)) 
      D.w=RecalculateByte(GetPixel(NX,NY-1)) 
      
      
      E.b=(A+b+C+D)>>2 
      f.w=RecalculateByte(E.b) 
      If f>1 
      f=f-2 
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
  ;Clear() 
Until KeyboardPushed(#PB_Key_All) 
CloseFile(0) 

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
  x=x1 : y=y1 : D=0 
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
      c=hx>>1:m=hy>>1 
    L1: 
      PutPixel(x,y,col) 
      If x=x2:Goto BR1:EndIf 
        x=x+xinc 
        d=d+m 
      If d>hx : y=y+yinc : d=d-c : EndIf 
      Goto L1 
    BR1: 
      Else 
      c=hy>>1:m=hx>>1 
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
;---------------------------------------- 
Procedure DrawCube() 
  Bind(0,1):Bind(0,4) 
  Bind(1,2):Bind(1,5) 
  Bind(2,3):Bind(2,6) 
  Bind(3,0):Bind(3,7) 
  Bind(4,5) 
  Bind(5,6) 
  Bind(6,7) 
  Bind(7,4) 

EndProcedure 
;------------------------------------- 
Procedure InitObj() 
  
  DataSection 
    CubeData: 
    Data.f -1,-1,-1,-1,1,-1,1,1,-1,1,-1,-1 
    Data.f -1,-1, 1,-1,1, 1,1,1, 1,1,-1, 1 
  EndDataSection 
  Restore CubeData 
  For n=0 To 7 
    Read xx.f 
    Read yy.f 
    Read zz.f 
    
    
    CubeList(n)\x=xx 
    CubeList(n)\y=yy 
    CubeList(n)\z=zz 
  Next 
  
  objsize=Sqr(12) 
EndProcedure 
;--------------------------------------- 
Procedure Perspect(theta.f,phi.f,rho.f) 
  
  
  objD=rho*100/objsize 
  
  
  costh.f=Cos(theta) 
  sinth.f=Sin(theta) 
  cosph.f=Cos(phi) 
  sinph.f=Sin(phi) 
  v11=-sinth 
  v12=-cosph*costh 
  v13=sinph*costh 
  v21=costh 
  v22=-cosph*sinth 
  v23=sinph*sinth 
  v32=sinph 
  v33=cosph 
  v43=-rho 
  

EndProcedure 


Procedure EyeScreen() 
  
  For n=0 To 7 
    px.f=CubeList(n)\x 
    py.f=CubeList(n)\y 
    pz.f=CubeList(n)\z 
  
    x.f=v11*px+v21*py 
    y.f=v12*px+v22*py+v32*pz 
    z.f=v13*px+v23*py+v33*pz+v43 
  
    ScreenList(n)\x=-objD*x/z 
    ScreenList(n)\y=-objD*y/z 
    
  
  Next 
  
EndProcedure 
;------------------------------------------- 
Procedure Bind(vertex1,vertex2) 
  x1=ScreenList(vertex1)\x 
  y1=ScreenList(vertex1)\y 
  x2=ScreenList(vertex2)\x 
  y2=ScreenList(vertex2)\y 
  DrawLine(160-x1,100-y1,160-x2,100-y2,255) 
EndProcedure 
;--------------------------------- 
Procedure rotateZ(alpha.f) 
  cosalpha.f=Cos(alpha) 
  sinalpha.f=Sin(alpha) 
  For n=0 To 7 
    px.f=CubeList(n)\x 
    py.f=CubeList(n)\y 
    rx.f=px*cosalpha-py*sinalpha 
    ry.f=px*sinalpha+py*cosalpha 
    CubeList(n)\x=rx 
    CubeList(n)\y=ry 
  Next 
EndProcedure 
;-------------------------------- 
Procedure rotateX(alpha.f) 
  cosalpha.f=Cos(alpha) 
  sinalpha.f=Sin(alpha) 
  For n=0 To 7 
    py.f=CubeList(n)\y 
    pz.f=CubeList(n)\z 
    ry.f=py*cosalpha-pz*sinalpha 
    rz.f=py*sinalpha+pz*cosalpha 
    CubeList(n)\y=ry 
    CubeList(n)\z=rz 
  Next 
EndProcedure 


Procedure Clear() 
  For n=1 To 320*200 
    PokeB(*Firebuffer+n,0) 
  Next 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; DisableDebugger