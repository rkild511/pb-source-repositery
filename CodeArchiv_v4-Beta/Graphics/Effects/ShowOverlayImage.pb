; German forum: http://www.purebasic.fr/german/viewtopic.php?t=343&highlight=
; Author: S.M. (updated for PB 4.00 by Andre)
; Date: 02. November 2004
; OS: Windows
; Demo: Yes

; Show an overlay on top of a (Direct3D) image, e.g. a game...
; Note: not every gfx card support this feature

; Über einem bestehenden (Direct3D-)Bild (z.B. einem Spiel) ein Overlay anzeigen:
; Achtung: Nicht jede Grafikkarte unterstüzt Overlays.

#DDOVER_SHOW=16384
#DDSCAPS_OVERLAY=128
#DDSCAPS_VIDEOMEMORY=16384
#DDSD_PIXELFORMAT=4096
#DDSD_CAPS=1
#DDSD_HEIGHT=2
#DDSD_WIDTH=4
#DDPF_RGB=64
#DDPF_FOURCC=4
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


Procedure CreateOverlayFromSprite(Sprite)
  *Sprite.PB_Sprite=IsSprite(Sprite)

  *SrcDDS.IDirectDrawSurface7=*Sprite\Sprite
  *SrcDDS\GetDDInterface(@*DD.IDirectDraw7)

  Width=*Sprite\RealWidth
  Height=*Sprite\RealHeight

  ddsd.DDSURFACEDESC2
  ddsd\dwSize=SizeOf(DDSURFACEDESC2)
  ddsd\ddsCaps\dwCaps=#DDSCAPS_OVERLAY|#DDSCAPS_VIDEOMEMORY
  ddsd\dwFlags=#DDSD_CAPS|#DDSD_HEIGHT|#DDSD_WIDTH|#DDSD_PIXELFORMAT
  ddsd\dwWidth=Width
  ddsd\dwHeight=Height


  ddsd\ddpfPixelFormat\dwSize=SizeOf(DDPIXELFORMAT)
  ddsd\ddpfPixelFormat\dwFlags=#DDPF_RGB
  ddsd\ddpfPixelFormat\dwRGBBitCount=16
  ddsd\ddpfPixelFormat\dwRBitMask=$F800
  ddsd\ddpfPixelFormat\dwGBitMask=$07E0
  ddsd\ddpfPixelFormat\dwBBitMask=$001F
  Result=*DD\CreateSurface(ddsd,@*DDS.IDirectDrawSurface7,0)
  Format=1

  If Result
    ddsd\ddpfPixelFormat\dwRBitMask=$7C00
    ddsd\ddpfPixelFormat\dwGBitMask=$03E0
    ddsd\ddpfPixelFormat\dwBBitMask=$001F
    Result=*DD\CreateSurface(ddsd,@*DDS.IDirectDrawSurface7,0)
    Format=1
  EndIf

  If Result
    ddsd\ddpfPixelFormat\dwRGBBitCount=0
    ddsd\ddpfPixelFormat\dwRBitMask=0
    ddsd\ddpfPixelFormat\dwGBitMask=0
    ddsd\ddpfPixelFormat\dwBBitMask=0
    ddsd\ddpfPixelFormat\dwFlags=#DDPF_FOURCC
    ddsd\ddpfPixelFormat\dwFourCC=PeekL(@"UYVY")
    Result=*DD\CreateSurface(ddsd,@*DDS.IDirectDrawSurface7,0)
    Format=2
  EndIf

  If Result
    ddsd\ddpfPixelFormat\dwFourCC=PeekL(@"YUY2")
    Result=*DD\CreateSurface(ddsd,@*DDS.IDirectDrawSurface7,0)
    Format=3
  EndIf

  If Result:MessageRequester("Error","Can't create Surface !"):End:EndIf

  SrcDC=StartDrawing(SpriteOutput(Sprite))

  If Format=1

    *DDS\GetDC(@DC)
    BitBlt_(DC,0,0,Width,Height,SrcDC,0,0,#SRCCOPY)
    *DDS\ReleaseDC(DC)

  Else
    *DDS\Lock(0,ddsd,#DDLOCK_WAIT,0)

    Addr=ddsd\lpSurface
    Pitch=ddsd\lPitch

    For y=0 To Height-1
      For x=0 To Width-1 Step 2

        C1=Point(x,y)
        C2=Point(x+1,y)

        Y0=     ( Red(C1)*29 +Green(C1)*57 +Blue(C1)*14)/100
        U0=128 +(-Red(C1)*14 -Green(C1)*29 +Blue(C1)*43)/100
        V0=128 +( Red(C1)*36 -Green(C1)*29 -Blue(C1)*07)/100

        Y1=     ( Red(C2)*29 +Green(C2)*57 +Blue(C2)*14)/100
        U1=128 +(-Red(C2)*14 -Green(C2)*29 +Blue(C2)*43)/100
        V1=128 +( Red(C2)*36 -Green(C2)*29 -Blue(C2)*07)/100

        Select Format
          Case 2
            PokeL(Addr,Y1<<24+((V0+V1)/2)<<16+Y0<<8+(U0+U1)/2):Addr+4
          Case 3
            PokeL(Addr,((V0+V1)/2)<<24+Y1<<16+((U0+U1)/2)<<8+Y0):Addr+4
        EndSelect

      Next
      Addr+(Pitch-Width*2)
    Next

    *DDS\UnLock(0)
  EndIf

  StopDrawing()

  ProcedureReturn *DDS
EndProcedure



Procedure ShowOverlay(*DDS.IDirectDrawSurface7,x,y,Width,Height)
  re1.RECT
  re1\left=x
  re1\right=x+Width
  re1\top=y
  re1\bottom=y+Height

  re2.RECT
  re2\left=0
  re2\right=Width
  re2\top=0
  re2\bottom=Height

  *DDS\GetDDInterface(@*DD.IDirectDraw7)
  *DD\GetGDISurface(@*GDI.IDirectDrawSurface7)

  *DDS\UpdateOverlay(re2,*GDI,re1,#DDOVER_SHOW,0)
EndProcedure

Procedure FreeOverlay(*DDS.IDirectDrawSurface7)
  *DDS\Release()
EndProcedure



InitSprite()
OpenWindow(1,0,0,200,100,"Overlay-Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
OpenWindowedScreen(WindowID(1),0,0,320,200,0,0,0)


CreateSprite(1,256,64);Breite muss durch 2 teilbar sein.

LoadFont(1,"Arial",32)
StartDrawing(SpriteOutput(1))
  For x=0 To 255
    For y=0 To 63
      Plot(x,y,RGB(255-x,y*4,x))
    Next
  Next
  DrawingFont(FontID(1))
  DrawingMode(1)
  FrontColor(RGB(0,0,0))
  DrawText(3,3,"Hallo Welt !!!")
  FrontColor(RGB(255,255,255))
  DrawText(0,0,"Hallo Welt !!!")
StopDrawing()
FreeFont(1)


Overlay=CreateOverlayFromSprite(1);Bei mir wird nur ein Overlay unterstützt.

ExamineDesktops()
DesktopWidth  = DesktopWidth(0)
DesktopHeight = DesktopHeight(0)

Repeat

  FlipBuffers()

  Angle.f+0.02

  x=Sin(Angle)*(DesktopWidth-256)/2+(DesktopWidth-256)/2
  y=Cos(Angle)*(DesktopHeight-64)/2+(DesktopHeight-64)/2

  ShowOverlay(Overlay,x,y,256,64)

Until WindowEvent()=#PB_Event_CloseWindow

FreeOverlay(Overlay)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -