; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3657&highlight=
; Author: Stefan (updated for PB 4.00 by Andre)
; Date: 11. June 2005
; OS: Windows
; Demo: No


; Die folgende Funktion ist bei Grafikkarten nützlich, die keine hardwarebeschleunigten
; 3D-Sprites unterstützen oder wenn man seine Software unabhängiger von der Hardware
; machen möchte.

;*********************************************
;* Render 3D-Sprites with software emulation *
;*********************************************

;The software emulation supports:
;Colorkeying with TransparentSpriteColor()
;Blending with Sprite3DBlendingMode()
;Bilinear-filtering with Sprite3DQuality()

;The software emulation doesn't support:
;Alpha blending (Transparency value of DisplaySprite3D())
;Textures with a width and height other than a power of 2.



Global OldCreateDeviceProc

Procedure GetD3DBase()
  !extrn _PB_D3DBase
  !MOV Eax,[_PB_D3DBase]
  ProcedureReturn
EndProcedure

Procedure NewCreateDevice(*D3D,*GUID,*BackDDS,*D3DDevice)
  Result=CallFunctionFast(OldCreateDeviceProc,*D3D,?IID_IDirect3DRGBDevice,*BackDDS,*D3DDevice)
  ptr=PeekL(*D3D)+OffsetOf(IDirect3D7\CreateDevice())
  WriteProcessMemory_(GetCurrentProcess_(),ptr,@OldCreateDeviceProc,4,0)
  ProcedureReturn Result
EndProcedure

Procedure Sprite3D_UseSoftwareDevice()
  ptr=PeekL(GetD3DBase())+OffsetOf(IDirect3D7\CreateDevice())
  OldCreateDeviceProc=PeekL(ptr)
  NewProc=@NewCreateDevice()
  WriteProcessMemory_(GetCurrentProcess_(),ptr,@NewProc,4,0)
EndProcedure

DataSection
  IID_IDirect3DRGBDevice:
  Data.l $A4665C60
  Data.w $2673,$11CF
  Data.b $A3,$1A,$0,$AA,$0,$B9,$33,$56
EndDataSection







;Example:

InitSprite()
InitSprite3D()
InitKeyboard()

OpenScreen(640,480,16,"Use Software to render 3D-Sprites")

Sprite3D_UseSoftwareDevice() ; swap to software-rendering (must be called before Start3D())


LoadSprite(1,"..\gfx\GeeBee2.bmp",#PB_Sprite_Texture) ; adjust path
TransparentSpriteColor(1,RGB(255,0,255))
CreateSprite3D(1,1)

FontID=LoadFont(1,"Arial",20)

Repeat
  ClearScreen(RGB(0,0,0))

  StartDrawing(ScreenOutput())
  DrawingMode(1)
  FrontColor(RGB(128,128,255))
  DrawingFont(FontID)
  DrawText(1,1, "Use Software to render 3D-Sprites !")
  StopDrawing()


  Start3D()
  Sprite3DQuality(1)

  Sprite3DBlendingMode(3,1)
  RotateSprite3D(1,1,1)
  DisplaySprite3D(1,200,200)
  Stop3D()

  FlipBuffers()
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_All)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger