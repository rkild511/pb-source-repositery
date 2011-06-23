; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2756&highlight=
; Author: Stefan Moebius
; Date: 06. November 2003
; OS: Windows
; Demo: No

;Direct3D 8.0 Beispiel 

;Alle Farbwerte müssen im BGR Farbformat angegeben werden. 
Declare BGR(b,G,R) 
Declare D3D_SetPixel(x,y,color) 
Declare D3D_DrawLine(x1,y1,x2,y2,color) 
Declare D3D_OpenScreen(Width,Height,BPP,Title$) 
Declare D3D_Cls(color) 
Declare D3D_Box(x1,y1,x2,y2,color) 
Declare D3D_Flip() 
Declare D3D_End() 

Structure D3D_TLVERTEX8 
  x.f 
  y.f 
  z.f 
  rhw.f;res.l 
  color.l 
EndStructure 

Structure D3DPresent_Parameters 
  BackBufferWidth.l 
  BackBufferHeight.l 
  BackBufferFormat.l 
  BackBufferCount.l 
  MultiSampleType.l 
  SwapEffect.l 
  hDeviceWindow.l 
  Windowed.l 
  EnableAutoDepthStencil.l 
  AutoDepthStencilFormat.l 
  flags.l 
  FullScreen_RefreshRateInHz.l 
  FullScreen_PresentationInterval.l 
EndStructure 


#D3DFVF_XYZRHW=4 
#D3DFVF_DIFFUSE=64 

#D3DSWAPEFFECT_FLIP=2 
#D3DSWAPEFFECT_COPY=3 

#D3DCLEAR_TARGET=1 

#D3DADAPTER_DEFAULT=0 
#D3DDEVTYPE_HAL=1 
#D3DDEVTYPE_REF=2 
#D3DDEVTYPE_SW=3 

#D3DCREATE_SOFTWARE_VERTEXPROCESSING=32 
#D3DCREATE_HARDWARE_VERTEXPROCESSING=64 
#D3DCREATE_MIXED_VERTEXPROCESSING=128 

#D3DPT_POINTLIST=1 
#D3DPT_LINELIST=2 
#D3DPT_LINESTRIP=3 
#D3DPT_TRIANGLELIST=4 
#D3DPT_TRIANGLESTRIP=5 

#D3D_SDK_VERSION=220 

#D3DFMT_R5G6B5=23     ;16 Bit 
#D3DFMT_R8G8B8=20     ;24 Bit 
#D3DFMT_X8R8G8B8=22   ;32 Bit 

Procedure BGR(b,G,R) 
  ProcedureReturn RGB(b,G,R) 
EndProcedure 

Procedure D3D_OpenScreen(Width,Height,BPP,Title$) 
  Global D3DWnd.D3DPresent_Parameters 
  Global D3D.IDirect3D8 
  Global D3DDevice.IDirect3DDevice8 
  Global Dim Points.D3D_TLVERTEX8(10);$FFFF 
  
  Select BPP 
    Case 16 
      PixelFormat=#D3DFMT_R5G6B5 
    Case 24 
      PixelFormat=#D3DFMT_R8G8B8 
    Case 32 
      PixelFormat=#D3DFMT_X8R8G8B8 
  EndSelect 
  
  OpenWindow(1,0,0,Width,Height,Title$,#WS_POPUP) 
  Inst=OpenLibrary(1,"D3D8.dll") 
  If Inst 
    D3D.IDirect3D8=CallFunction(1,"Direct3DCreate8",#D3D_SDK_VERSION) 
    
    D3DWnd\SwapEffect=#D3DSWAPEFFECT_FLIP 
    D3DWnd\BackBufferWidth=Width 
    D3DWnd\BackBufferHeight=Height 
    D3DWnd\BackBufferCount=1 
    D3DWnd\BackBufferFormat=PixelFormat 
    D3DWnd\hDeviceWindow=WindowID(1) 
    Result=0 
    If D3D\CreateDevice(0,1,WindowID(1),#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice)=0 
      D3DDevice\SetVertexShader(#D3DFVF_XYZRHW|#D3DFVF_DIFFUSE) 
      Result=1 
      ShowCursor_(0) 
    Else 
      If D3D\CreateDevice(0,1,WindowID(1),#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice)=0 
        D3DDevice\SetVertexShader(#D3DFVF_XYZRHW|#D3DFVF_DIFFUSE) 
        Result=1 
        ShowCursor_(0) 
      Else 
        MessageRequester("","Fehler") 
        End 
      EndIf 
    EndIf 
  EndIf 

  ;ProcedureReturn Result      ;PB Bug ??????? 
EndProcedure 


Procedure D3D_End() 
  ShowCursor_(-1) 
  CloseLibrary(1) 
EndProcedure 

Procedure D3D_Cls(color) 
  D3DDevice\Clear(0,0,#D3DCLEAR_TARGET,color,0.0,0) 
EndProcedure 

Procedure D3D_Box(x1,y1,x2,y2,color) 
  Re.RECT 
  Re\Left=x1:Re\Right=x2:Re\Top=y1:Re\Bottom=y2 
  D3DDevice\Clear(1,@Re,#D3DCLEAR_TARGET,color,0.0,0) 
EndProcedure 

Procedure D3D_Flip() 
  D3DDevice\Present(0,0,0,0) 
EndProcedure 

Procedure D3D_SetPixel(x,y,color) 
  Points(0)\x=x 
  Points(0)\y=y 
  Points(0)\color=color 
  D3DDevice\BeginScene() 
  D3DDevice\DrawPrimitiveUP(#D3DPT_POINTLIST,1,@Points(0),20) 
  D3DDevice\EndScene() 
EndProcedure 

Procedure D3D_DrawLine(x1,y1,x2,y2,color) 
  Points(0)\x=x1 
  Points(0)\y=y1 
  Points(0)\color=color 
  Points(1)\x=x2 
  Points(1)\y=y2 
  Points(1)\color=color 
  D3DDevice\BeginScene() 
  D3DDevice\DrawPrimitiveUP(#D3DPT_LINELIST,1,@Points(0),20) 
  D3DDevice\EndScene() 
EndProcedure 

Procedure D3D_Draw2ColorLine(x1,y1,x2,y2,Color1,Color2) 
  Points(0)\x=x1 
  Points(0)\y=y1 
  Points(0)\color=Color1 
  Points(0)\rhw=1 
  Points(1)\x=x2 
  Points(1)\y=y2 
  Points(1)\color=Color2 
  Points(1)\rhw=1 
  D3DDevice\BeginScene() 
  D3DDevice\DrawPrimitiveUP(#D3DPT_LINELIST,1,@Points(0),20) 
  D3DDevice\EndScene() 
EndProcedure 

Procedure D3D_DrawTriangle(x1,y1,x2,y2,x3,y3,Color1,Color2,Color3) 
  Points(0)\x=x1 
  Points(0)\y=y1 
  Points(0)\color=Color1 
  Points(0)\rhw=1 
  Points(1)\x=x2 
  Points(1)\y=y2 
  Points(1)\color=Color2 
  Points(1)\rhw=1 
  Points(2)\x=x3 
  Points(2)\y=y3 
  Points(2)\color=Color3 
  Points(2)\rhw=1 
  D3DDevice\BeginScene() 
  D3DDevice\DrawPrimitiveUP(#D3DPT_TRIANGLESTRIP,1,@Points(0),20) 
  D3DDevice\EndScene() 
EndProcedure 













;-Beispiel: 
D3D_OpenScreen(800,600,32,"Direct3D 8.0 Test") 




Start=GetTickCount_() 
Repeat 
  RandomSeed(80) 
  D3D_Cls(BGR(255,0,0));blau 
  For M=0 To 1000 
    x=Random(800) 
    y=Random(600) 
    D3D_Box(x,y,x+Random(100),y+Random(100),Random($FFFFFF)) 
  Next 
  ;Maus 
  GetCursorPos_(pt.POINT) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+20,pt\y+20,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x,pt\y+10,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+10,pt\y,0,$FFFFFF) 
  D3D_Flip() 
  WaitWindowEvent() 
Until GetTickCount_()-Start>5000 



Start=GetTickCount_() 
Repeat 
  RandomSeed(80) 
  D3D_Cls(0);schwarz 
  For M=0 To 1000 
    D3D_DrawLine(Random(800),Random(600),Random(800),Random(600),Random($FFFFFF)) 
  Next 
  ;Maus 
  GetCursorPos_(pt.POINT) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+20,pt\y+20,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x,pt\y+10,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+10,pt\y,0,$FFFFFF) 
  D3D_Flip() 
  WaitWindowEvent() 
Until GetTickCount_()-Start>5000 



Start=GetTickCount_() 
Repeat 
  RandomSeed(80) 
  D3D_Cls($FFFFFF);weiß 
  For M=0 To 10000 
    D3D_SetPixel(Random(800),Random(600),Random($FFFFFF)) 
  Next 
  ;Maus 
  GetCursorPos_(pt.POINT) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+20,pt\y+20,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x,pt\y+10,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+10,pt\y,0,$FFFFFF) 
  D3D_Flip() 
  WaitWindowEvent() 
Until GetTickCount_()-Start>5000 



Start=GetTickCount_() 
Repeat 
  RandomSeed(80) 
  D3D_Cls(BGR(128,0,0)) 
  D3D_DrawTriangle(400,0,800,600,0,600,$FFFFFF,0,BGR(0,255,255)) 
  ;Maus 
  GetCursorPos_(pt.POINT) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+20,pt\y+20,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x,pt\y+10,0,$FFFFFF) 
  D3D_Draw2ColorLine(pt\x,pt\y,pt\x+10,pt\y,0,$FFFFFF)  
  D3D_Flip() 
  WaitWindowEvent() 
Until GetTickCount_()-Start>5000 



D3D_End() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
