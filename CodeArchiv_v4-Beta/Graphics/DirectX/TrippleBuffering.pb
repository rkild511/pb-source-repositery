; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3346&highlight= 
; Author: Stefan (updated for PB 4.00 by edel)
; Date: 14. May 2005 
; OS: Windows 
; Demo: No 


;######################################## 
;# Use Triple Buffering in PureBasic    # 
;######################################## 

Structure DDPIXELFORMAT 
  dwSize.l 
  dwFlags.l 
  dwFourCC.l 
  dwRGBBitCount.l 
  dwRBitMask.l 
  dwGBitMask.l 
  dwBBitMask.l 
  dwRGBAlphaBitMask.l 
EndStructure 

Structure DDCOLORKEY 
  dwColorSpaceLowValue.l 
  dwColorSpaceHighValue.l 
EndStructure 

Structure DDSCAPS2 
  dwCaps.l 
  dwCaps2.l 
  dwCaps3.l 
  dwCaps4.l 
EndStructure 

Structure DDSURFACEDESC2 
  dwSize.l 
  dwFlags.l 
  dwHeight.l 
  dwWidth.l 
  lPitch.l 
  dwBackBufferCount.l 
  dwRefreshRate.l 
  dwAlphaBitDepth.l 
  dwReserved.l 
  lpSurface.l 
  ddckCKDestOverlay.DDCOLORKEY 
  ddckCKDestBlt.DDCOLORKEY 
  ddckCKSrcOverlay.DDCOLORKEY 
  ddckCKSrcBlt.DDCOLORKEY 
  ddpfPixelFormat.DDPIXELFORMAT 
  ddsCaps.DDSCAPS2 
  dwTextureStage.l 
EndStructure 

#DDSD_CAPS=1 
#DDSD_BACKBUFFERCOUNT=32 
#DDSCAPS_BACKBUFFER=4 
#DDSCAPS_3DDEVICE=8192 
#DDSCAPS_PRIMARYSURFACE=512 
#DDSCAPS_FLIP=16 
#DDSCAPS_COMPLEX=8 



Procedure OpenScreenEx(Width,Height,bpp,NbOfBuffers,Title$) ;doesn't work with the OGRE-Engine. 
  !extrn _PB_Engine3D_Initialized 
  !extrn _PB_DirectX_PrimaryBuffer 
  !extrn _PB_DirectX_BackBuffer 
  !extrn _PB_DDrawBase 
  
  If NbOfBuffers<2:ProcedureReturn 0:EndIf ; We need at least double buffering. 
  
  OGREUsed.l 
  *FrontDDS.IDirectDrawSurface7 
  *BackDDS.IDirectDrawSurface7 
  *DD.IDirectDraw7 
  
  !MOV Eax,[_PB_Engine3D_Initialized] 
  !MOV [p.v_OGREUsed],Eax 
  
  If OGREUsed:ProcedureReturn 0:EndIf     ;We can't change the number of Buffers if we use the OGRE-Engine. 
  OpenScreenResult=OpenScreen(Width,Height,bpp,Title$) 
  If OpenScreenResult=0:ProcedureReturn 0:EndIf 
  
  !MOV Eax,[_PB_DirectX_PrimaryBuffer] 
  !MOV [p.p_FrontDDS],Eax 
  !MOV Eax,[_PB_DirectX_BackBuffer] 
  !MOV [p.p_BackDDS],Eax 
  !MOV Eax,[_PB_DDrawBase] 
  !MOV [p.p_DD],Eax 
  
  If NbOfBuffers>2 ; change the number of Buffers. 
    
    DDSDESC.DDSURFACEDESC2 
    DDSDESC\dwSize=SizeOf(DDSURFACEDESC2) 
    
    
    If *FrontDDS\GetSurfaceDesc(DDSDESC) 
      CloseScreen():ProcedureReturn 0 
    EndIf 
    
    DEVICE3D=DDSDESC\ddsCaps\dwCaps&#DDSCAPS_3DDEVICE 
    
    RtlZeroMemory_(DDSDESC,SizeOf(DDSURFACEDESC2)) 
    
    DDSDESC\dwSize=SizeOf(DDSURFACEDESC2) 
    DDSDESC\dwFlags=#DDSD_CAPS|#DDSD_BACKBUFFERCOUNT 
    DDSDESC\ddsCaps\dwCaps=#DDSCAPS_PRIMARYSURFACE|#DDSCAPS_FLIP|#DDSCAPS_COMPLEX|DEVICE3D 
    DDSDESC\dwBackBufferCount=NbOfBuffers-1 
    
    ;*BackDDS\Release() is automatically released 
    *FrontDDS\Release() 
    
    *BackDDS=0 
    *FrontDDS=0 
    
    !MOV dword[_PB_DirectX_PrimaryBuffer],0 
    !MOV dword[_PB_DirectX_BackBuffer],0 
    
    Result=*DD\CreateSurface(DDSDESC,@*FrontDDS,0) 
    If Result:ProcedureReturn 0:EndIf 
    
    ddsCaps.DDSCAPS2 
    ddsCaps\dwCaps=#DDSCAPS_BACKBUFFER    
    Result=*FrontDDS\GetAttachedSurface(ddsCaps,@*BackDDS) 
    If Result:*FrontDDS\Release():ProcedureReturn 0:EndIf 
    
    !MOV Eax,[p.p_FrontDDS] 
    !MOV dword[_PB_DirectX_PrimaryBuffer],Eax 
    !MOV Eax,[p.p_BackDDS] 
    !MOV dword[_PB_DirectX_BackBuffer],Eax 
  EndIf 
  
  ProcedureReturn OpenScreenResult 
EndProcedure 






;Example: 


InitSprite() 
InitSprite3D() 
InitKeyboard() 
Result=OpenScreenEx(800,600,16,3,"Triple Buffering Test") 

If Result=0 
  MessageRequester("ERROR","Can't open screen !") 
  End 
EndIf 


CreateSprite(1,64,64,#PB_Sprite_Texture) 
font = LoadFont(1,"Arial Black",10) 

StartDrawing(SpriteOutput(1)) 
Box(0,0,64,64,#Yellow) 
DrawingFont(font) 
DrawingMode(1) 
FrontColor(RGB(0,0,128)) 
DrawText(0, 0, "Enjoy") 
DrawText(0, 18, "Triple-") 
DrawText(0, 36, "buffering") 
StopDrawing() 
CreateSprite3D(1,1) 


RandomSeed(3) 


For count=0 To 2   ; fill all 3 buffers 
  ClearScreen(RGB(0,0,0)) 
  Start3D() 
  Sprite3DQuality(1) 
  ZoomSprite3D(1,256,256) 
  RotateSprite3D(1,30,0) 
  DisplaySprite3D(1,Random(800-256),Random(600-256)) 
  Stop3D() 
  FlipBuffers() 
  Delay(500) 
Next 

Repeat 
  FlipBuffers() 
  Delay(500) 
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
