; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1151&start=10 
; Author: S.M. (updated for PB 4.00 by Andre + edel) 
; Date: 11. December 2004 
; OS: Windows 
; Demo: Yes 


#DDLOCK_WAIT=1 
#DDCKEY_SRCBLT=8 
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

Procedure GetCurrentBuffer() ;gibt die DDrawSurface des Rendering-Buffers zurück. 
  !extrn _PB_Sprite_CurrentBitmap 
  !MOV Eax,[_PB_Sprite_CurrentBitmap] 
  ProcedureReturn 
EndProcedure 

Procedure GetPixelFormat() ;gibt das PixelFormat des Rendering-Buffers zurück 
  !extrn _PB_DirectX_PixelFormat 
  !MOV Eax,[_PB_DirectX_PixelFormat] 
  ProcedureReturn 
EndProcedure 

Procedure _ScreenWidth() ;gibt die Breite des Rendering-Buffers zurück 
  !extrn _PB_Screen_Width 
  !MOV Eax,[_PB_Screen_Width] 
  ProcedureReturn 
EndProcedure 

Procedure _ScreenHeight() ;gibt die Höhe des Rendering-Buffers zurück 
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
  
  *SpriteDDS\Lock(0,SpriteDDSD2,#DDLOCK_WAIT,0);schließt den Sprite- 
  *DestDDS\Lock(0,DestDDSD2,#DDLOCK_WAIT,0);und Rendering-Buffer, damit man direkt auf den Speicher zugreifen kann. 
  
  
  SrcPitch=SpriteDDSD2\lPitch 
  DestPitch=DestDDSD2\lPitch 
  
  SrcAddr=SpriteDDSD2\lpSurface 
  DestAddr=DestDDSD2\lpSurface 
  
  PixelFormat=GetPixelFormat() 
  
  x=Sqr(Pow((*Sprite\Width+1)/2,2)+Pow((*Sprite\Height+1)/2,2)) 
  
  If XPos-x>=0 And YPos-x>=0 And XPos+x<=ScreenWidth And YPos+x<=ScreenHeight ;Kann das Bild komplett dargestellt werden ? 
    
    ;======================================================================  
    If PixelFormat=#PB_PixelFormat_8Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX        
          Color=*SrcPtr\l&$FF 
          PokeW(DestAddr+((((x-SpriteWidth2)*Sin)>>11+Yv2))*DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1),Color+Color<<8) ;Zeichnet den Pixel 
          *SrcPtr+1 
        Next 
      Next    
      
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_15Bits Or PixelFormat=#PB_PixelFormat_16Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*2 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l&$FFFF 
          PokeL(DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2)*DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1)*2,Color+Color<<16) ;Zeichnet den Pixel 
          *SrcPtr+2 
        Next 
      Next    
    EndIf 
    
    
    If PixelFormat=#PB_PixelFormat_24Bits_RGB Or PixelFormat=#PB_PixelFormat_24Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*3 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l 
          Addr=DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2) *DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1)*3 ;Zeichnet den Pixel 
          PokeW(Addr,Color) 
          PokeL(Addr+2,Color>>16|Color<<8) 
          
          *SrcPtr+3 
        Next 
      Next    
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_32Bits_RGB Or PixelFormat=#PB_PixelFormat_32Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*4 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l 
          Addr=DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2) *DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1)*4 ;Zeichnet den Pixel 
          PokeL(Addr,Color) 
          PokeL(Addr+4,Color) 
          
          *SrcPtr+4 
        Next 
      Next    
      
    EndIf 
    ;====================================================================== 
    
    
  Else 
    
    
    ;======================================================================    
    If PixelFormat=#PB_PixelFormat_8Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l&$FF 
            PokeW(DestAddr+Yp*DestPitch+Xp,Color+Color<<8) ;Zeichnet den Pixel 
          EndIf 
          *SrcPtr+1 
        Next 
      Next    
      
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_15Bits Or PixelFormat=#PB_PixelFormat_16Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*2 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l&$FFFF 
            PokeL(DestAddr+Yp*DestPitch+Xp*2,Color+Color<<16) ;Zeichnet den Pixel 
          EndIf 
          *SrcPtr+2 
        Next 
      Next    
    EndIf 
    
    
    If PixelFormat=#PB_PixelFormat_24Bits_RGB Or PixelFormat=#PB_PixelFormat_24Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*3 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l 
            Addr=DestAddr+Yp*DestPitch+Xp*3 ;Zeichnet den Pixel 
            PokeW(Addr,Color) 
            PokeL(Addr+2,Color>>16|Color<<8) 
            
          EndIf 
          *SrcPtr+3 
        Next 
      Next    
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_32Bits_RGB Or PixelFormat=#PB_PixelFormat_32Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*4 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l 
            Addr=DestAddr+Yp*DestPitch+Xp*4 ;Zeichnet den Pixel 
            PokeL(Addr,Color) 
            PokeL(Addr+4,Color) 
            
          EndIf 
          *SrcPtr+4 
        Next 
      Next        
    EndIf 
    ;======================================================================    
    
  EndIf 
  
  *SpriteDDS\UnLock(0) ;Öffnet den Sprite-Buffer und den Rendering-Buffer wieder. 
  *DestDDS\UnLock(0) 
  ProcedureReturn -1 
EndProcedure 




Procedure PutRotatedTransSprite(Sprite,XPos,YPos,Angle.f) 
  
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
  
  *SpriteDDS\GetColorKey(#DDCKEY_SRCBLT,ColorKey.DDCOLORKEY);Gibt die transparente Farbe (im passendem PixelFormat) des Sprites zurück 
  TransColor=ColorKey\dwColorSpaceLowValue 
  
  
  SpriteDDSD2.DDSURFACEDESC2 
  DestDDSD2.DDSURFACEDESC2 
  
  SpriteDDSD2\dwSize=SizeOf(DDSURFACEDESC2) 
  DestDDSD2\dwSize=SizeOf(DDSURFACEDESC2) 
  
  *SpriteDDS\Lock(0,SpriteDDSD2,#DDLOCK_WAIT,0);schließt den Sprite- 
  *DestDDS\Lock(0,DestDDSD2,#DDLOCK_WAIT,0);und Rendering-Buffer, damit man direkt auf den Speicher zugreifen kann. 
  
  
  SrcPitch=SpriteDDSD2\lPitch 
  DestPitch=DestDDSD2\lPitch 
  
  SrcAddr=SpriteDDSD2\lpSurface 
  DestAddr=DestDDSD2\lpSurface 
  
  PixelFormat=GetPixelFormat() 
  
  
  x=Sqr(Pow((*Sprite\Width+1)/2,2)+Pow((*Sprite\Height+1)/2,2)) 
  
  If XPos-x>=0 And YPos-x>=0 And XPos+x<=ScreenWidth And YPos+x<=ScreenHeight ;Kann das Bild komplett dargestellt werden ? 
    
    ;======================================================================    
    
    If PixelFormat=#PB_PixelFormat_8Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l&$FF 
          If Color<>TransColor 
            PokeW(DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2)*DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1),Color+Color<<8) ;Zeichnet den Pixel 
          EndIf 
          
          *SrcPtr+1 
        Next 
      Next    
      
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_15Bits Or PixelFormat=#PB_PixelFormat_16Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*2 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l&$FFFF 
          If Color<>TransColor 
            PokeL(DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2)*DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1)*2,Color+Color<<16) ;Zeichnet den Pixel 
          EndIf 
          
          *SrcPtr+2 
        Next 
      Next    
    EndIf 
    
    
    If PixelFormat=#PB_PixelFormat_24Bits_RGB Or PixelFormat=#PB_PixelFormat_24Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*3 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l&$FFFFFF 
          
          If Color<>TransColor 
            Addr=DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2) *DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1)*3 ;Zeichnet den Pixel 
            PokeW(Addr,Color) 
            PokeL(Addr+2,Color>>16|Color<<8) 
          EndIf 
          
          *SrcPtr+3 
        Next 
      Next    
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_32Bits_RGB Or PixelFormat=#PB_PixelFormat_32Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*4 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Color=*SrcPtr\l&$FFFFFF 
          If Color<>TransColor 
            Addr=DestAddr+(((x-SpriteWidth2)*Sin)>>11+Yv2)*DestPitch+(((x-SpriteWidth2)*Cos)>>11+Yv1)*4 ;Zeichnet den Pixel 
            PokeL(Addr,Color) 
            PokeL(Addr+4,Color) 
          EndIf 
          
          *SrcPtr+4 
        Next 
      Next    
      
    EndIf 
    ;======================================================================    
    
    
    
  Else 
    
    ;======================================================================    
    
    If PixelFormat=#PB_PixelFormat_8Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l&$FF 
            If Color<>TransColor 
              PokeW(DestAddr+Yp*DestPitch+Xp,Color+Color<<8) ;Zeichnet den Pixel 
            EndIf 
            
          EndIf 
          *SrcPtr+1 
        Next 
      Next    
      
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_15Bits Or PixelFormat=#PB_PixelFormat_16Bits 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*2 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l&$FFFF 
            If Color<>TransColor 
              PokeL(DestAddr+Yp*DestPitch+Xp*2,Color+Color<<16) ;Zeichnet den Pixel 
            EndIf 
            
          EndIf 
          *SrcPtr+2 
        Next 
      Next    
    EndIf 
    
    
    If PixelFormat=#PB_PixelFormat_24Bits_RGB Or PixelFormat=#PB_PixelFormat_24Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*3 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l&$FFFFFF 
            
            If Color<>TransColor 
              Addr=DestAddr+Yp*DestPitch+Xp*3 ;Zeichnet den Pixel 
              PokeW(Addr,Color) 
              PokeL(Addr+2,Color>>16|Color<<8) 
            EndIf 
            
          EndIf 
          *SrcPtr+3 
        Next 
      Next    
    EndIf 
    
    If PixelFormat=#PB_PixelFormat_32Bits_RGB Or PixelFormat=#PB_PixelFormat_32Bits_BGR 
      
      For y=StartY To EndY 
        *SrcPtr.Long=SrcAddr+y*SrcPitch+StartX*4 ;Berechnet die Startadresse 
        
        Yv1=((y-SpriteHeight2)*NSin)>>11+XPos 
        Yv2=((y-SpriteHeight2)*Cos)>>11+YPos 
        For x=StartX To EndX  
          
          Xp=((x-SpriteWidth2)*Cos)>>11+Yv1 ;Berechnet die Position des Pixels 
          Yp=((x-SpriteWidth2)*Sin)>>11+Yv2 
          
          If Xp>=0 And Xp<ScreenWidth And Yp>=0 And Yp<=ScreenHeight 
            
            Color=*SrcPtr\l&$FFFFFF 
            If Color<>TransColor 
              Addr=DestAddr+Yp*DestPitch+Xp*4 ;Zeichnet den Pixel 
              PokeL(Addr,Color) 
              PokeL(Addr+4,Color) 
            EndIf 
            
          EndIf 
          *SrcPtr+4 
        Next 
      Next    
      
    EndIf 
    ;======================================================================      
    
    
  EndIf 
  
  *SpriteDDS\UnLock(0) ;Öffnet den Sprite-Buffer und den Rendering-Buffer wieder. 
  *DestDDS\UnLock(0) 
  ProcedureReturn -1 
EndProcedure 




;Beispiel: 
InitSprite() 
InitKeyboard() 
InitMouse() 

OpenScreen(800,600,16,"PutRotatedSprite()/PutRotatedTransSprite()") 


;Achtung: 
;Das Sprite sollte im Hauptspeicher erstellt werden, da dort der direkte Speicherzugriff schneller ist. 
;LoadSprite(1,"D:\Purebasic\examples\sources\data\Geebee2.bmp",#PB_Sprite_Memory);Pfad anpassen ! 
LoadSprite(1,"..\Gfx\Geebee2.bmp",#PB_Sprite_Memory);Pfad anpassen ! 


;ClipSprite(1,20,20,100,100) 
TransparentSpriteColor(1,RGB(255,0,255)) 

MouseLocate(400,300) 

Repeat 
  ExamineKeyboard() 
  Angle+1 
  
  ClearScreen(RGB(128,128,128)) 
  
  ExamineMouse() 
  
  PutRotatedTransSprite(1,MouseX(),MouseY(),Angle) 
  
  FlipBuffers() 
  
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --