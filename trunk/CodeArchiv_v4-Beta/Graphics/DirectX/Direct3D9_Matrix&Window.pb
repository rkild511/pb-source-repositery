; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3665
; Author: Stefan Moebius (updated for PB 4.00 by Andre)
; Date: 09. February 2004
; OS: Windows
; Demo: No

; Kleines Beispiel für die Benutzung von Direct3D 9 in PureBASIC.
; Das Beispiel zeigt vor allem die Benutzung von Matrizen und das Rendern von Fenstern.

#D3D_SDK_VERSION=31 

#D3D_OK=0 

#D3DFVF_XYZ=2 
#D3DFVF_XYZRHW=4 
#D3DFVF_DIFFUSE=64 

#D3DSWAPEFFECT_DISCARD=1 
#D3DSWAPEFFECT_FLIP=2 
#D3DSWAPEFFECT_COPY=3 
#D3DSWAPEFFECT_COPY_VSYNC=4 

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

#D3DFMT_X1R5G5B5=24 
#D3DFMT_A1R5G5B5=25 
#D3DFMT_R5G6B5=23 
#D3DFMT_X8R8G8B8=22 
#D3DFMT_A8R8G8B8=21 
#D3DFMT_R8G8B8=20 


#D3DTS_PROJECTION=3 
#D3DTS_WORLD=256 

#D3DPRESENTFLAG_LOCKABLE_BACKBUFFER=1 

#D3DRS_LIGHTING=137 
#D3DRS_ALPHABLENDENABLE=27 
#D3DRS_FILLMODE=8 
#D3DRS_CULLMODE=22 
#D3DRS_SRCBLEND=19 
#D3DRS_DESTBLEND=20 
#D3DRS_FOGENABLE=28 
#D3DRS_FOGCOLOR=34 

Structure My_Vertex 
  x.f 
  y.f 
  z.f 
  col.l 
EndStructure 

Structure D3DXMATRIX 
  _11.f 
  _12.f 
  _13.f 
  _14.f 
  _21.f 
  _22.f 
  _23.f 
  _24.f 
  _31.f 
  _32.f 
  _33.f 
  _34.f 
  _41.f 
  _42.f 
  _43.f 
  _44.f 
EndStructure 

Structure D3DDISPLAYMODE 
  Width.l 
  Height.l 
  RefreshRate.l 
  Format.l 
EndStructure 

Structure D3DADAPTER_IDENTIFIER9 
  Driver.b[512] 
  Description.b[512] 
  DeviceName.b[32] 
  DriverVersion.Large_Integer 
  DriverVersionLowPart.l 
  DriverVersionHighPart.l 
  VendorId.l 
  DeviceId.l 
  SubSysId.l 
  Revision.l 
  DeviceIdentifier.GUID 
  WHQLLevel.l 
EndStructure 


Structure D3DPresent_Parameters 
  BackBufferWidth.l 
  BackBufferHeight.l 
  BackBufferFormat.l 
  BackBufferCount.l 
  MultiSampleType.l 
  MultiSampleQuality.l 
  SwapEffect.l 
  hDeviceWindow.l 
  Windowed.l 
  EnableAutoDepthStencil.l 
  AutoDepthStencilFormat.l 
  Flags.l 
  FullScreen_RefreshRateInHz.l 
  FullScreen_PresentationInterval.l 
EndStructure 


Procedure MoveMatrix(*Matrix.D3DXMATRIX,X.f,Y.f,Z.f) 
  *Matrix\_41=X 
  *Matrix\_42=Y 
  *Matrix\_43=Z 
EndProcedure 

Procedure RotateMatrixX(*Matrix.D3DXMATRIX,Grad.f) 
  *Matrix\_11=1.0 
  *Matrix\_44=1.0 
  *Matrix\_12=0.0 
  *Matrix\_13=0.0 
  *Matrix\_14=0.0 
  *Matrix\_41=0.0 
  *Matrix\_21=0.0 
  *Matrix\_24=0.0 
  *Matrix\_42=0.0 
  *Matrix\_31=0.0 
  *Matrix\_34=0.0 
  *Matrix\_43=0.0 
  Rad.f=Grad/#PI*2 
  *Matrix\_22= Cos(Rad) 
  *Matrix\_23= Sin(Rad) 
  *Matrix\_32=-Sin(Rad) 
  *Matrix\_33= Cos(Rad) 
EndProcedure 

Procedure RotateMatrixY(*Matrix.D3DXMATRIX,Grad.f) 
  *Matrix\_22=1.0 
  *Matrix\_44=1.0 
  *Matrix\_12=0.0 
  *Matrix\_14=0.0 
  *Matrix\_41=0.0 
  *Matrix\_21=0.0 
  *Matrix\_23=0.0 
  *Matrix\_24=0.0 
  *Matrix\_42=0.0 
  *Matrix\_32=0.0 
  *Matrix\_34=0.0 
  *Matrix\_43=0.0 
  Rad.f=Grad/#PI*2 
  *Matrix\_11= Cos(Rad) 
  *Matrix\_13=-Sin(Rad) 
  *Matrix\_31= Sin(Rad) 
  *Matrix\_33= Cos(Rad) 
EndProcedure 

Procedure RotateMatrixZ(*Matrix.D3DXMATRIX,Grad.f) 
  *Matrix\_33=1.0 
  *Matrix\_44=1.0 
  *Matrix\_13=0.0 
  *Matrix\_14=0.0 
  *Matrix\_41=0.0 
  *Matrix\_23=0.0 
  *Matrix\_24=0.0 
  *Matrix\_42=0.0 
  *Matrix\_31=0.0 
  *Matrix\_32=0.0 
  *Matrix\_34=0.0 
  *Matrix\_43=0.0 
  Rad.f=Grad/#PI*2 
  *Matrix\_11= Cos(Rad) 
  *Matrix\_12= Sin(Rad) 
  *Matrix\_21=-Sin(Rad) 
  *Matrix\_22= Cos(Rad) 
EndProcedure 




Procedure D3D_Init() 
  Global D3DInst 
  Global D3D.IDirect3D9 
  Global D3DWnd.D3DPresent_Parameters 
  Global D3DDevice.IDirect3DDevice9 
  Global D3DInst 
  D3DInst=LoadLibrary_("D3D9.dll") 
  If D3DInst 
    D3D=CallFunctionFast(GetProcAddress_(D3DInst,"Direct3DCreate9"),#D3D_SDK_VERSION) 
  EndIf 
  ProcedureReturn D3D 
EndProcedure 

Procedure D3D_OpenScreen(WindowID,Width,Height,PixelFormat,SwapEffect,Lockable) 
  If D3D 
    D3DWnd\SwapEffect=SwapEffect 
    D3DWnd\BackBufferWidth=Width 
    D3DWnd\BackBufferHeight=Height 
    D3DWnd\BackBufferCount=1 
    D3DWnd\BackBufferFormat=PixelFormat 
    D3DWnd\hDeviceWindow=WindowID 
    D3DWnd\Flags=#D3DPRESENTFLAG_LOCKABLE_BACKBUFFER 
    If Lockable=0:D3DWnd\Flags=0:EndIf 
    Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_HAL,WindowID,#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_HAL,WindowID,#D3DCREATE_MIXED_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_HAL,WindowID,#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_REF,WindowID,#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_REF,WindowID,#D3DCREATE_MIXED_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_REF,WindowID,#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_SW,WindowID,#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_SW,WindowID,#D3DCREATE_MIXED_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_SW,WindowID,#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
  EndIf 
  ProcedureReturn D3DDevice 
EndProcedure 

Procedure D3D_OpenWindowedScreen(WindowID,Lockable) 
  If D3D 
    ScrInfo.D3DDISPLAYMODE 
    D3D\GetAdapterDisplayMode(#D3DADAPTER_DEFAULT,ScrInfo) 
    D3DWnd\SwapEffect=#D3DSWAPEFFECT_DISCARD 
    D3DWnd\BackBufferFormat=ScrInfo\Format 
    D3DWnd\Windowed=-1 
    D3DWnd\hDeviceWindow=WindowID 
    D3DWnd\Flags=#D3DPRESENTFLAG_LOCKABLE_BACKBUFFER 
    If Lockable=0:D3DWnd\Flags=0:EndIf 
    Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_HAL,WindowID,#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_HAL,WindowID,#D3DCREATE_MIXED_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_HAL,WindowID,#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_REF,WindowID,#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_REF,WindowID,#D3DCREATE_MIXED_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_REF,WindowID,#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_SW,WindowID,#D3DCREATE_HARDWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_SW,WindowID,#D3DCREATE_MIXED_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
    If Result 
      Result=D3D\CreateDevice(#D3DADAPTER_DEFAULT,#D3DDEVTYPE_SW,WindowID,#D3DCREATE_SOFTWARE_VERTEXPROCESSING,D3DWnd,@D3DDevice) 
    EndIf 
  EndIf 
  ProcedureReturn D3DDevice 
EndProcedure 

Procedure D3D_Release() 
  If D3DDevice:D3DDevice\Release():EndIf 
  If D3D:D3D\Release():EndIf 
  If D3DInst:FreeLibrary_(D3DInst):EndIf 
EndProcedure 











Global FPS,Count,Start 
Global BackBuffer.IDirect3DSurface9,AdapterInfo.D3DADAPTER_IDENTIFIER9,ScrInfo.D3DDISPLAYMODE 


Global VertexNr 
Global Dim Vertex.My_Vertex(1000) 

Procedure SetVertexColor(RGB) 
  Vertex(VertexNr)\col=RGB(Blue(RGB),Green(RGB),Red(RGB)) 
EndProcedure 

Procedure SetVertex(x.f,y.f,z.f) 
  Vertex(VertexNr)\x=x 
  Vertex(VertexNr)\y=y 
  Vertex(VertexNr)\z=z 
  VertexNr+1 
EndProcedure 

Procedure RenderScene() 
  D3DDevice\Clear(0,0,#D3DCLEAR_TARGET,$FF,0.0,0) 
  
  DC.l 
  BackBuffer\GetDC(@DC) 
  SetBkMode_(DC,1) 
  SetTextColor_(DC,#White) 
  SelectObject_(DC,GetStockObject_(#ANSI_VAR_FONT)) 
  Text$="FPS: "+Str(FPS) 
  TextOut_(DC,350,0,@Text$,Len(Text$)) 
  Text$=Str(ScrInfo\Width)+"x"+Str(ScrInfo\Height)+"@"+Str(ScrInfo\RefreshRate)+" Hz" 
  TextOut_(DC,350,20,@Text$,Len(Text$)) 
  Text$=PeekS(@AdapterInfo\Description)+"("+PeekS(@AdapterInfo\Driver)+")" 
  TextOut_(DC,350,40,@Text$,Len(Text$)) 
  BackBuffer\ReleaseDC(DC) 
  
  D3DDevice\BeginScene() 
  D3DDevice\DrawPrimitiveUP(#D3DPT_TRIANGLELIST,VertexNr/3,@Vertex(0),16) 
  D3DDevice\EndScene() 
  
  D3DDevice\Present(0,0,0,0) 
EndProcedure 

If D3D_Init()=0 
  MessageRequester("","Direct3D konnte nicht gestartet werden.") 
  D3D_Release() 
  End 
EndIf 



Flags=#PB_Window_ScreenCentered|#PB_Window_SizeGadget|#PB_Window_MaximizeGadget 
  
OpenWindow(1,0,0,640,480,"Direct3D 9 Test",Flags) 

OpenWindow(2,0,0,100,100,"D3D9 Test",#PB_Window_SystemMenu,WindowID(1)) 


SetWindowPos_(WindowID(1),#HWND_TOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE) 
SetWindowPos_(WindowID(2),#HWND_TOPMOST,0,0,0,0,#SWP_NOSIZE|#SWP_NOMOVE) 

CreateGadgetList(WindowID(2)) 
OptionGadget(1,0, 0,100,25,"1.)") 
OptionGadget(2,0,25,100,25,"2.)") 
OptionGadget(3,0,50,100,25,"3.)") 
OptionGadget(4,0,75,100,25,"4.)") 
SetGadgetState(1,1) 

Result=D3D_OpenScreen(WindowID(1),640,480,#D3DFMT_X8R8G8B8,#D3DSWAPEFFECT_DISCARD,#True) 
If Result=0 
  Result=D3D_OpenScreen(WindowID(1),640,480,#D3DFMT_R5G6B5,#D3DSWAPEFFECT_DISCARD,#True) 
EndIf 
If Result=0 
  Result=D3D_OpenScreen(WindowID(1),640,480,#D3DFMT_X1R5G5B5,#D3DSWAPEFFECT_DISCARD,#True) 
EndIf 
If Result=0 
  Result=D3D_OpenWindowedScreen(WindowID(1),#True) 
EndIf 

If Result=0 
  MessageRequester("","Direct3D konnte nicht gestartet werden.") 
  D3D_Release() 
  End 
EndIf 

ProjMatrix.D3DXMATRIX 

ProjMatrix\_11=Cos((#PI/4)/2)/Sin((#PI/4)/2) 
ProjMatrix\_22=Cos((#PI/4)/2)/Sin((#PI/4)/2) 
ProjMatrix\_33=1/(1-0.001) 
ProjMatrix\_34=1 
ProjMatrix\_43=-(1/(1-0.001)) 

D3DDevice\SetTransform(#D3DTS_PROJECTION,@ProjMatrix) 

RGB1=RGB(192,192,0) 
RGB2=RGB(64,128,0) 
RGB3=RGB(128,64,0) 

SetVertexColor(RGB1) 
SetVertex(0.0,0.25,0.0) 
SetVertexColor(RGB2) 
SetVertex(-0.5,-0.5,0.5) 
SetVertexColor(RGB3) 
SetVertex(0.5,-0.5,0.5) 
SetVertexColor(RGB1) 
SetVertex(0.0,0.25,0.0) 
SetVertexColor(RGB3) 
SetVertex(0.5,-0.5,0.5) 
SetVertexColor(RGB2) 
SetVertex(0.5,-0.5,-0.5) 
SetVertexColor(RGB1) 
SetVertex(0.0,0.25,0.0) 
SetVertexColor(RGB2) 
SetVertex(0.5,-0.5,-0.5) 
SetVertexColor(RGB3) 
SetVertex(-0.5,-0.5,-0.5) 
SetVertexColor(RGB1) 
SetVertex(0.0,0.25,0.0) 
SetVertexColor(RGB3) 
SetVertex(-0.5,-0.5,-0.5) 
SetVertexColor(RGB2) 
SetVertex(-0.5,-0.5,0.5) 

D3DDevice\SetFVF(#D3DFVF_XYZ|#D3DFVF_DIFFUSE) 
D3DDevice\SetRenderState(#D3DRS_LIGHTING,0) 

D3DDevice\GetBackBuffer(0,0,0,@BackBuffer) 

D3D\GetAdapterIdentifier(0,0,AdapterInfo) 
D3D\GetAdapterDisplayMode(#D3DADAPTER_DEFAULT,ScrInfo) 

Z.f=5 
X.f=0 
Y.f=0 
RotY.f 

D3DDevice\SetDialogBoxMode(-1) 

Repeat 
  
  Count+1:If timeGetTime_()-Start>1000:FPS=Count:Count=0:Start=timeGetTime_():EndIf 
    
  If GetGadgetState(1) 
    D3DDevice\SetRenderState(#D3DRS_FOGENABLE,0) 
    D3DDevice\SetRenderState(#D3DRS_ALPHABLENDENABLE,0) 
    D3DDevice\SetRenderState(#D3DRS_FILLMODE,3) 
    D3DDevice\SetRenderState(#D3DRS_CULLMODE,3) 
  EndIf 
  
  If GetGadgetState(2) 
    D3DDevice\SetRenderState(#D3DRS_FOGENABLE,0) 
    D3DDevice\SetRenderState(#D3DRS_ALPHABLENDENABLE,0) 
    D3DDevice\SetRenderState(#D3DRS_FILLMODE,2) 
    D3DDevice\SetRenderState(#D3DRS_CULLMODE,0) 
  EndIf 
  
  If GetGadgetState(3) 
    D3DDevice\SetRenderState(#D3DRS_FOGENABLE,0) 
    D3DDevice\SetRenderState(#D3DRS_FILLMODE,3) 
    D3DDevice\SetRenderState(#D3DRS_CULLMODE,3) 
    D3DDevice\SetRenderState(#D3DRS_ALPHABLENDENABLE,-1) 
    D3DDevice\SetRenderState(#D3DRS_SRCBLEND,2) 
    D3DDevice\SetRenderState(#D3DRS_DESTBLEND,2) 
  EndIf 
  
  If GetGadgetState(4) 
    D3DDevice\SetRenderState(#D3DRS_ALPHABLENDENABLE,0) 
    D3DDevice\SetRenderState(#D3DRS_FILLMODE,3) 
    D3DDevice\SetRenderState(#D3DRS_CULLMODE,3) 
    D3DDevice\SetRenderState(#D3DRS_FOGENABLE,-1) 
    D3DDevice\SetRenderState(#D3DRS_FOGCOLOR,RGB(96,96,96)) 
  EndIf 
  
  RenderScene() 
  
  If GetAsyncKeyState_(#VK_UP)=-32767   :z-0.15:EndIf 
  If GetAsyncKeyState_(#VK_DOWN)=-32767 :z+0.15:EndIf 
  
  If GetAsyncKeyState_(#VK_LEFT)=-32767 :x+0.15:EndIf 
  If GetAsyncKeyState_(#VK_RIGHT)=-32767:x-0.15:EndIf 
  
  WorldMatrix.D3DXMATRIX 
  
  RotY+0.1 
  
  RotateMatrixY(@WorldMatrix,RotY) 
  MoveMatrix(@WorldMatrix,x,y,z) 
  
  D3DDevice\SetTransform(#D3DTS_WORLD,@WorldMatrix) 
  
  
  Event=WindowEvent() 
  
  If Event=#PB_Event_CloseWindow And EventWindow()=2 
    D3DDevice\SetDialogBoxMode(0) 
    CloseWindow(2) 
  EndIf 
  
Until GetAsyncKeyState_(#VK_ESCAPE)=-32767 


D3DDevice\SetDialogBoxMode(0) 

D3D_Release() 
End 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger