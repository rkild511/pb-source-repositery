; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2304&highlight=
; Author: Stefan (updated for PB 4.00 by Andre)
; Date: 04. March 2005
; OS: Windows
; Demo: Yes


; Collision detection with 3D-Sprites
; Kollisionserkennung mit 3D-Sprites

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

#DDSD_WIDTH=4
#DDSD_HEIGHT=2
#DDSD_CAPS=1
#DDSCAPS_3DDEVICE=8192
#DDSCAPS_OFFSCREENPLAIN=64

Global *D3DDevice.IDirect3DDevice7
Global *BackBuffer.IDirectDrawSurface7

Procedure CreateRenderSprite(Sprite,Width,Height)
  Result=CreateSprite(Sprite,Width,Height)
  If Result=0:ProcedureReturn 0:EndIf
  *PBSprite.PB_Sprite=IsSprite(Sprite)
  *DDS.IDirectDrawSurface7=*PBSprite\Sprite
  *DDS\GetDDInterface(@*DD.IDirectDraw7)
  *DDS\Release()
  DDSD.DDSURFACEDESC2
  DDSD\dwSize=SizeOf(DDSURFACEDESC2)
  DDSD\dwFlags=#DDSD_WIDTH|#DDSD_HEIGHT|#DDSD_CAPS
  DDSD\dwWidth=Width
  DDSD\dwHeight=Height
  DDSD\ddsCaps\dwCaps=#DDSCAPS_3DDEVICE|#DDSCAPS_OFFSCREENPLAIN
  Result=*DD\CreateSurface(DDSD,*PBSprite,0)
  If Result:ProcedureReturn 0:EndIf
  ProcedureReturn *PBSprite\Sprite
EndProcedure

Procedure SelectRenderSprite(Sprite)
  !extrn _PB_Direct3D_Device
  !MOV Eax,[_PB_Direct3D_Device]
  !MOV [p_D3DDevice],Eax
  !extrn _PB_DirectX_BackBuffer
  !MOV Eax,[_PB_DirectX_BackBuffer]
  !MOV [p_BackBuffer],Eax
  *D3DDevice\EndScene()
  Select Sprite
    Case -1
      *D3DDevice\SetRenderTarget(*BackBuffer,2)
    Default
      *D3DDevice\SetRenderTarget(PeekL(IsSprite(Sprite)),2)
  EndSelect
  *D3DDevice\BeginScene()
EndProcedure






;Example:

InitSprite()
InitSprite3D()


InitKeyboard()
InitMouse()

ExamineDesktops()
Screenwidth  = DesktopWidth(0)
Screenheight = DesktopHeight(0)

OpenScreen(Screenwidth,Screenheight,16,"Collision detection with 3D-Sprites")

CreateRenderSprite(0,181,181)
CreateRenderSprite(1,181,181)

TransparentSpriteColor(0,RGB(255,0,255))
TransparentSpriteColor(1,RGB(255,0,255))

LoadSprite(5,"..\..\gfx\GeeBee2.bmp",#PB_Sprite_Texture) ;Pfad anpassen !
CreateSprite3D(5,5)


Repeat
  ExamineKeyboard()
  ExamineMouse()

  ClearScreen(RGB(0,0,0))

  UseBuffer(0)
  ClearScreen(RGB(255,0,255));Clear Sprite 0
  UseBuffer(1)
  ClearScreen(RGB(255,0,255));Clear Sprite 1
  UseBuffer(-1)


  Start3D()

  SelectRenderSprite(0);Draw the 3D-Sprite on Sprite 0
  Angle1+2
  RotateSprite3D(5,Angle1,0)
  DisplaySprite3D(5,27,27)


  SelectRenderSprite(1);Draw the 3D-Sprite on Sprite 1
  Angle2-2
  RotateSprite3D(5,Angle2,0)
  DisplaySprite3D(5,27,27)

  SelectRenderSprite(-1);Draw on Backbuffer
  Stop3D()


  DisplayTransparentSprite(0,MouseX(),MouseY())
  DisplayTransparentSprite(1,300,250)

  If SpritePixelCollision(0,MouseX(),MouseY(),1,300,250)
    StartDrawing(ScreenOutput())
    FrontColor(RGB(255,255,0))
    DrawingMode(1)
    ;DrawingFont(GetStockObject_(#ANSI_FIXED_FONT))
    DrawText(1, 1, "Collision !")
    StopDrawing()
  EndIf

  FlipBuffers()

Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger