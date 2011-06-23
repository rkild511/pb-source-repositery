; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1151&start=10 
; Author: S.M. (updated for PB 4.00 by Andre + edel) 
; Date: 10. December 2004 
; OS: Windows 
; Demo: 


; Der Code unterstützt jetzt sogar Clipping und benötigt keine externe Libraries mehr. 
; Anstelle von UseBuffer(Sprite) musst du StartDrawing(SpriteOutput(Sprite)) benutzen. 

#DDLOCK_WAIT=1 

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

Structure PB_Sprite 
  Sprite.l 
  Width.w 
  Height.w 
  Depth.w 
  Mode.w 
  FileName.l 
  RealWidth.w 
  RealHeight.w 
  ClipX.w 
  ClipY.w 
EndStructure 

Procedure GetCurrentBuffer() 
  !extrn _PB_Sprite_CurrentBitmap 
  !MOV Eax,[_PB_Sprite_CurrentBitmap] 
  ProcedureReturn 
EndProcedure 

Procedure GetPixelFormat() 
  !extrn _PB_DirectX_PixelFormat 
  !MOV Eax,[_PB_DirectX_PixelFormat] 
  ProcedureReturn 
EndProcedure 

Procedure _ScreenWidth() 
  !extrn _PB_Screen_Width 
  !MOV Eax,[_PB_Screen_Width] 
  ProcedureReturn 
EndProcedure 

Procedure _ScreenHeight() 
  !extrn _PB_Screen_Height 
  !MOV Eax,[_PB_Screen_Height] 
  ProcedureReturn 
EndProcedure 







Procedure PutRotatedSprite(Sprite,XPos,YPos,Angle.f) 
  
  *Sprite.PB_Sprite=IsSprite(Sprite) 
  
  If *Sprite=0:ProcedureReturn 0:EndIf 
  
  Angle.f=Angle*0.017453; *(ACos(-1)*2)/360 
  
  Cos=Cos(Angle.f)*2048 
  Sin=Sin(Angle.f)*2048 
  NSin=-Sin 
  
  SpriteWidth=*Sprite\Width-1 
  SpriteHeight=*Sprite\Height-1 
  
  StartX=*Sprite\ClipX 
  StartY=*Sprite\ClipY 
  EndX=SpriteWidth+StartX 
  EndY=SpriteHeight+StartY 
  
  SpriteWidth2=(SpriteWidth)/2+StartX 
  SpriteHeight2=(SpriteHeight)/2+StartY 
  
  ScreenWidth=_ScreenWidth()-1 
  ScreenHeight=_ScreenHeight()-1 
  
  *SpriteDDS.IDirectDrawSurface7=*Sprite\Sprite 
  *DestDDS.IDirectDrawSurface7=GetCurrentBuffer() 
  
  SpriteDDSD2.DDSURFACEDESC2 
  DestDDSD2.DDSURFACEDESC2 
  
  SpriteDDSD2\dwSize=SizeOf(DDSURFACEDESC2) 
  DestDDSD2\dwSize=SizeOf(DDSURFACEDESC2) 
  
  *SpriteDDS\Lock(0,SpriteDDSD2,#DDLOCK_WAIT,0) 
  *DestDDS\Lock(0,DestDDSD2,#DDLOCK_WAIT,0) 
  
  SrcPitch=SpriteDDSD2\lPitch 
  DestPitch=DestDDSD2\lPitch 
  
  SrcAddr=SpriteDDSD2\lpSurface 
  DestAddr=DestDDSD2\lpSurface 
  
  PixelFormat=GetPixelFormat() 
  
  If PixelFormat=#PB_PixelFormat_8Bits 
    
    For y=StartY To EndY 
      *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX 
      
      Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
      Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
      For x=StartX To EndX  
        
        Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 
        Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
        
        If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
          
          PokeW(DestAddr+Yp*DestPitch+Xp,*SrcPtr\l) 
        EndIf 
        *SrcPtr+1 
      Next 
    Next    
    
  EndIf 
  
  If PixelFormat=#PB_PixelFormat_15Bits Or PixelFormat=#PB_PixelFormat_16Bits 
    
    For y=StartY To EndY 
      *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*2 
      
      Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
      Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
      For x=StartX To EndX  
        
        Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 
        Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
        
        If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
          
          PokeL(DestAddr+Yp*DestPitch+Xp*2,*SrcPtr\l) 
        EndIf 
        *SrcPtr+2 
      Next 
    Next    
  EndIf 
  
  
  If PixelFormat=#PB_PixelFormat_24Bits_RGB Or PixelFormat=#PB_PixelFormat_24Bits_BGR 
    
    For y=StartY To EndY 
      *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*3 
      
      Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
      Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
      For x=StartX To EndX  
        
        Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 
        Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
        
        If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
          
          Color=*SrcPtr\l 
          Addr=DestAddr+Yp*DestPitch+Xp*3 
          PokeW(Addr,Color) 
          PokeL(Addr+2,Color>>16|Color<<8) 
          
        EndIf 
        *SrcPtr+3 
      Next 
    Next    
  EndIf 
  
  If PixelFormat=#PB_PixelFormat_32Bits_RGB Or PixelFormat=#PB_PixelFormat_32Bits_BGR 
    
    For y=StartY To EndY 
      *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*4 
      
      Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
      Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
      For x=StartX To EndX  
        
        Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 
        Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
        
        If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
          
          Color=*SrcPtr\l 
          Addr=DestAddr+Yp*DestPitch+Xp*4 
          PokeL(Addr,Color) 
          PokeL(Addr+4,Color) 
          
        EndIf 
        *SrcPtr+4 
      Next 
    Next    
    
  EndIf 
  
  *SpriteDDS\UnLock(0) 
  *DestDDS\UnLock(0) 
  ProcedureReturn -1 
EndProcedure 


InitSprite() 
InitKeyboard() 

ExamineDesktops() 

OpenScreen(DesktopWidth(0),DesktopHeight(0),16,"PutRotatedSprite()") 

LoadSprite(1,"..\Gfx\Geebee2.bmp",#PB_Sprite_Memory);Pfad anpassen 

ClipSprite(1,10,10,50,50) 

Repeat 
  ExamineKeyboard() 
  Angle+1 
  
  ClearScreen(RGB(0,0,0)) 
  
  PutRotatedSprite(1,300,300,Angle) 
  
  FlipBuffers() 
  
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -