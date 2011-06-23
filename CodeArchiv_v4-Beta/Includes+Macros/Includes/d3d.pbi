;***************************************************************************
;*
;*  File:	       d3d.h / DX7 SDK
;*  Content:	 Direct3D include file
;*                 for PureBasic
;*
;*  Conversion by: traumatic!, April 2003 <traumatic@connection-refused.org>
;*
;*  Status:        COMPLETE
;*                                                                                
;***************************************************************************


;*
;* Interface IID's
;*

; +++ NOTE:
; +++ unused should be remarked - this doesn't really belong in here
; +++ better place them in the actual program
;
DataSection
  IID_IDirect3D:
    Data.l $3BBA0080
    Data.w $2421, $11CF
    Data.b $a3, $1a, $00, $aa, $00, $b9, $33, $56

  IID_IDirect3D2:
    Data.l $6aae1ec1
    Data.w $662a, $11d0
    Data.b $88, $9d, $00, $aa, $00, $bb, $b7, $6a

  IID_IDirect3D3:
    Data.l $bb223240
    Data.w $e72b, $11d0
    Data.b $a4, $a9, $b4, $aa, $00, $c0, $99, $3e

  IID_IDirect3D7:
    Data.l $f5049e77
    Data.w $4861, $11d2
    Data.b $a4, $07, $00, $a0, $c9, $06, $29, $a8

  IID_IDirect3DRampDevice:
    Data.l $F2086B20
    Data.w $259F, $11CF
    Data.b $a3, $1a, $00, $aa, $00, $b9, $33, $56

  IID_IDirect3DRGBDevice:
    Data.l $A4665C60
    Data.w $2673, $11CF
    Data.b $a3, $1a, $00, $aa, $00, $b9, $33, $56

  IID_IDirect3DHALDevice:
    Data.l $84E63dE0
    Data.w $46AA, $11CF
    Data.b $81, $6f, $00, $00, $c0, $20, $15, $6e

  IID_IDirect3DMMXDevice:
    Data.l $881949a1
    Data.w $d6f3, $11d0
    Data.b $89, $ab, $00, $a0, $c9, $05, $41, $29


  IID_IDirect3DRefDevice:
    Data.l $50936643
    Data.w $13e9, $11d1
    Data.b $89, $aa, $00, $a0, $c9, $05, $41, $29

  IID_IDirect3DNullDevice:
    Data.l $8767df22
    Data.w $bacc, $11d1
    Data.b $89, $69, $00, $a0, $c9, $06, $29, $a8

  IID_IDirect3DTnLHalDevice:
    Data.l $f5049e78
    Data.w $4861, $11d2
    Data.b $a4, $07, $00, $a0, $c9, $06, $29, $a8



; *
; * Internal Guid to distinguish requested MMX from MMX being used as an RGB rasterizer
; *

  IID_IDirect3DDevice:
    Data.l $64108800
    Data.w $957d, $11d0
    Data.b $89, $ab, $00, $a0, $c9, $05, $41, $29

  IID_IDirect3DDevice2:
    Data.l $93281501
    Data.w $8cf8, $11d0
    Data.b $89, $ab, $00, $a0, $c9, $05, $41, $29
   
  IID_IDirect3DDevice3:
    Data.l $b0ab3b60
    Data.w $33d7, $11d1
    Data.b $a9, $81, $00, $c0, $4f, $f7, $b1, $74
    
  IID_IDirect3DDevice7:
    Data.l $5049e79
    Data.w $4861, $11d2
    Data.b $a4, $07, $00, $a0, $c9, $06, $29, $a8

  IID_IDirect3DTexture:
    Data.l $2CDCD9E0
    Data.w $25A0, $11CF
    Data.b $a3, $1a, $00, $aa, $00, $b9, $33, $56

  IID_IDirect3DTexture2:
    Data.l $93281502
    Data.w $8cf8, $11d0
    Data.b $89, $ab, $00, $a0, $c9, $05, $41, $29

  IID_IDirect3DLight:
    Data.l $4417C142
    Data.w $33AD, $11CF
    Data.b $81, $6f, $00, $00, $c0, $20, $15, $6e

  IID_IDirect3DMaterial:
    Data.l $4417C144
    Data.w $33AD, $11CF
    Data.b $81, $6f, $00, $00, $c0, $20, $15, $6e

  IID_IDirect3DMaterial2:
    Data.l $93281503
    Data.w $8cf8, $11d0
    Data.b $89, $ab, $00, $a0, $c9, $05, $41, $29
    
  IID_IDirect3DMaterial3:
    Data.l $ca9c46f4
    Data.w $d3c5, $11d1
    Data.b $b7, $5a, $00, $60, $08, $52, $b3, $12

  IID_IDirect3DExecuteBuffer:
    Data.l $4417C145
    Data.w $33AD, $11CF
    Data.b $81, $6f, $00, $00, $c0, $20, $15, $6e

  IID_IDirect3DViewport:
    Data.l $4417C146
    Data.w $33AD, $11CF
    Data.b $81, $6f, $00, $00, $c0, $20, $15, $6e

  IID_IDirect3DViewport2:
    Data.l $93281500
    Data.w $8cf8, $11d0
    Data.b $89, $ab, $00, $a0, $c9, $05, $41, $29
    
  IID_IDirect3DViewport3:
    Data.l $b0ab3b61
    Data.w $33d7, $11d1
    Data.b $a9, $81, $00, $c0, $4f, $d7, $b1, $74

  IID_IDirect3DVertexBuffer:
    Data.l $7a503555
    Data.w $4a83, $11d1
    Data.b $a5, $db, $00, $a0, $c9, $03, $67, $f8
  
  IID_IDirect3DVertexBuffer7:
    Data.l $f5049e7d
    Data.w $4861, $11d2
    Data.b $a4, $07, $00, $a0, $c9, $06, $29, $a8  
EndDataSection 


; *
; * Direct3D interfaces
; *
#IDirect3D_QueryInterface                       =   0
#IDirect3D_AddRef                               =   4
#IDirect3D_Release                              =   8
#IDirect3D_Initialize                           =  12
#IDirect3D_EnumDevices                          =  16
#IDirect3D_CreateLight                          =  20
#IDirect3D_CreateMaterial                       =  24
#IDirect3D_CreateViewport                       =  28
#IDirect3D_FindDevice                           =  32

; *** IDirect3D2 methods ***
#IDirect3D2_QueryInterface                      =   0
#IDirect3D2_AddRef                              =   4
#IDirect3D2_Release                             =   8
#IDirect3D2_EnumDevices                         =  12
#IDirect3D2_CreateLight                         =  16
#IDirect3D2_CreateMaterial                      =  20
#IDirect3D2_CreateViewport                      =  24
#IDirect3D2_FindDevice                          =  28
#IDirect3D2_CreateDevice                        =  32

; *** IDirect3D3 methods ***
#IDirect3D3_QueryInterface                      =   0
#IDirect3D3_AddRef                              =   4
#IDirect3D3_Release                             =   8
#IDirect3D3_EnumDevices                         =  12
#IDirect3D3_CreateLight                         =  16
#IDirect3D3_CreateMaterial                      =  20
#IDirect3D3_CreateViewport                      =  24
#IDirect3D3_FindDevice                          =  28
#IDirect3D3_CreateDevice                        =  32
#IDirect3D3_CreateVertexBuffer                  =  36
#IDirect3D3_EnumZBufferFormats                  =  40
#IDirect3D3_EvictManagedTextures                =  44

; *** IDirect3D7 methods ***
#IDirect3D7_QueryInterface                      =   0
#IDirect3D7_AddRef                              =   4
#IDirect3D7_Release                             =   8
#IDirect3D7_EnumDevices                         =  12
#IDirect3D7_CreateDevice                        =  16
#IDirect3D7_CreateVertexBuffer                  =  20
#IDirect3D7_EnumZBufferFormats                  =  24
#IDirect3D7_EvictManagedTextures                =  28

; *
; * Direct3D Device interfaces
; *
#IDirect3DDevice_QueryInterface                 =   0
#IDirect3DDevice_AddRef                         =   4
#IDirect3DDevice_Release                        =   8
#IDirect3DDevice_Initialize                     =  12
#IDirect3DDevice_GetCaps                        =  16
#IDirect3DDevice_SwapTextureHandles             =  20
#IDirect3DDevice_CreateExecuteBuffer            =  24
#IDirect3DDevice_GetStats                       =  28
#IDirect3DDevice_Execute                        =  32
#IDirect3DDevice_AddViewport                    =  36
#IDirect3DDevice_DeleteViewport                 =  40
#IDirect3DDevice_NextViewport                   =  44
#IDirect3DDevice_Pick                           =  48
#IDirect3DDevice_GetPickRecords                =  52
#IDirect3DDevice_EnumTextureFormats             =  56
#IDirect3DDevice_CreateMatrix                   =  60
#IDirect3DDevice_SetMatrix                      =  64
#IDirect3DDevice_GetMatrix                      =  68
#IDirect3DDevice_DeleteMatrix                   =  72
#IDirect3DDevice_BeginScene                     =  76
#IDirect3DDevice_EndScene                       =  80
#IDirect3DDevice_GetDirect3D                    =  84

; *** IDirect3DDevice2 methods ***
#IDirect3DDevice2_QueryInterface                =   0
#IDirect3DDevice2_AddRef                        =   4
#IDirect3DDevice2_Release                       =   8
#IDirect3DDevice2_GetCaps                       =  12
#IDirect3DDevice2_SwapTextureHandles            =  16
#IDirect3DDevice2_GetStats                      =  20
#IDirect3DDevice2_AddViewport                   =  24
#IDirect3DDevice2_DeleteViewport                =  28
#IDirect3DDevice2_NextViewport                  =  32
#IDirect3DDevice2_EnumTextureFormats            =  36
#IDirect3DDevice2_BeginScene                    =  40
#IDirect3DDevice2_EndScene                      =  44
#IDirect3DDevice2_GetDirect3D                   =  48
#IDirect3DDevice2_SetCurrentViewport            =  52
#IDirect3DDevice2_GetCurrentViewport            =  56
#IDirect3DDevice2_SetRenderTarget               =  60
#IDirect3DDevice2_GetRenderTarget               =  64
#IDirect3DDevice2_Begin                         =  68
#IDirect3DDevice2_BeginIndexed                  =  72
#IDirect3DDevice2_Vertex                        =  76
#IDirect3DDevice2_Index                         =  80
#IDirect3DDevice2_End                           =  84
#IDirect3DDevice2_GetRenderState                =  88
#IDirect3DDevice2_SetRenderState                =  92
#IDirect3DDevice2_GetLightState                 =  96
#IDirect3DDevice2_SetLightState                 = 100
#IDirect3DDevice2_SetTransform                  = 104
#IDirect3DDevice2_GetTransform                  = 108
#IDirect3DDevice2_MultiplyTransform             = 112
#IDirect3DDevice2_DrawPrimitive                 = 116
#IDirect3DDevice2_DrawIndexedPrimitive          = 120
#IDirect3DDevice2_SetClipStatus                 = 124
#IDirect3DDevice2_GetClipStatus                 = 128

; *** IDirect3DDevice2 methods ***
#IDirect3DDevice3_QueryInterface                =   0
#IDirect3DDevice3_AddRef                        =   4
#IDirect3DDevice3_Release                       =   8
#IDirect3DDevice3_GetCaps                       =  12
#IDirect3DDevice3_GetStats                      =  16
#IDirect3DDevice3_AddViewport                   =  20
#IDirect3DDevice3_DeleteViewport                =  24
#IDirect3DDevice3_NextViewport                  =  28
#IDirect3DDevice3_EnumTextureFormats            =  32
#IDirect3DDevice3_BeginScene                    =  36
#IDirect3DDevice3_EndScene                      =  40
#IDirect3DDevice3_GetDirect3D                   =  44
#IDirect3DDevice3_SetCurrentViewport            =  48
#IDirect3DDevice3_GetCurrentViewport            =  52
#IDirect3DDevice3_SetRenderTarget               =  56
#IDirect3DDevice3_GetRenderTarget               =  60
#IDirect3DDevice3_Begin                         =  64
#IDirect3DDevice3_BeginIndexed                  =  68
#IDirect3DDevice3_Vertex                        =  72
#IDirect3DDevice3_Index                         =  76
#IDirect3DDevice3_End                           =  80
#IDirect3DDevice3_GetRenderState                =  84
#IDirect3DDevice3_SetRenderState                =  88
#IDirect3DDevice3_GetLightState                 =  92
#IDirect3DDevice3_SetLightState                 =  96
#IDirect3DDevice3_SetTransform                  = 100
#IDirect3DDevice3_GetTransform                  = 104
#IDirect3DDevice3_MultiplyTransform             = 108
#IDirect3DDevice3_DrawPrimitive                 = 112
#IDirect3DDevice3_DrawIndexedPrimitive          = 116
#IDirect3DDevice3_SetClipStatus                 = 120
#IDirect3DDevice3_GetClipStatus                 = 124
#IDirect3DDevice3_DrawPrimitiveStrided          = 128
#IDirect3DDevice3_DrawIndexedPrimitiveStrided   = 132
#IDirect3DDevice3_DrawPrimitiveVB               = 136
#IDirect3DDevice3_DrawIndexedPrimitiveVB        = 140
#IDirect3DDevice3_ComputeSphereVisibility       = 144
#IDirect3DDevice3_GetTexture                    = 148
#IDirect3DDevice3_SetTexture                    = 152
#IDirect3DDevice3_GetTextureStageState          = 156
#IDirect3DDevice3_SetTextureStageState          = 160
#IDirect3DDevice3_ValidateDevice                = 164

; *** IDirect3DDevice7 methods ***
#IDirect3DDevice7_QueryInterface                =   0
#IDirect3DDevice7_AddRef                        =   4
#IDirect3DDevice7_Release                       =   8
#IDirect3DDevice7_GetCaps                       =  12
#IDirect3DDevice7_EnumTextureFormats            =  16
#IDirect3DDevice7_BeginScene                    =  20
#IDirect3DDevice7_EndScene                      =  24
#IDirect3DDevice7_GetDirect3D                   =  28
#IDirect3DDevice7_SetRenderTarget               =  32
#IDirect3DDevice7_GetRenderTarget               =  36
#IDirect3DDevice7_Clear                         =  40
#IDirect3DDevice7_SetTransform                  =  44
#IDirect3DDevice7_GetTransform                  =  48
#IDirect3DDevice7_SetViewport                   =  52
#IDirect3DDevice7_MultiplyTransform             =  56
#IDirect3DDevice7_GetViewport                   =  60
#IDirect3DDevice7_SetMaterial                   =  64
#IDirect3DDevice7_GetMaterial                   =  68
#IDirect3DDevice7_SetLight                      =  72
#IDirect3DDevice7_GetLight                      =  76
#IDirect3DDevice7_SetRenderstate                =  80
#IDirect3DDevice7_GetRenderstate                =  84
#IDirect3DDevice7_BeginStateBlock               =  88
#IDirect3DDevice7_EndStateBlock                 =  92
#IDirect3DDevice7_PerLoad                       =  96
#IDirect3DDevice7_DrawPrimitive                 = 100
#IDirect3DDevice7_DrawIndexedPrimitive          = 104
#IDirect3DDevice7_SetClipStatus                 = 108
#IDirect3DDevice7_GetClipStatus                 = 112
#IDirect3DDevice7_DrawPrimitveStrided           = 116
#IDirect3DDevice7_DrawIndexedPrimitiveStrided   = 120
#IDirect3DDevice7_DrawPrimitiveVB               = 124
#IDirect3DDevice7_DrawIndexedPrimitveVB         = 128
#IDirect3DDevice7_ComputeSphereVisibility       = 132
#IDirect3DDevice7_GetTexture                    = 136
#IDirect3DDevice7_SetTexture                    = 140
#IDirect3DDevice7_GetTextureStageObject         = 144
#IDirect3DDevice7_SetTextureStageObject         = 148
#IDirect3DDevice7_ValidateDevice                = 152
#IDirect3DDevice7_ApllyStateBlock               = 156
#IDirect3DDevice7_CaptureStateBlock             = 160
#IDirect3DDevice7_DeleteStateBlock              = 164
#IDirect3DDevice7_CreateStateBlock              = 168
#IDirect3DDevice7_Load                          = 172
#IDirect3DDevice7_LightEnable                   = 176
#IDirect3DDevice7_GetLightEnable                = 180
#IDirect3DDevice7_SetClipPlane                  = 184
#IDirect3DDevice7_GetClipPlane                  = 188
#IDirect3DDevice7_GetInfo                       = 192


;*
;* Execute Buffer interface
;*
#IDirect3DExecuteBuffer_QueryInterface          =   0
#IDirect3DExecuteBuffer_AddRef                  =   4
#IDirect3DExecuteBuffer_Release                 =   8
#IDirect3DExecuteBuffer_Initialize              =  12
#IDirect3DExecuteBuffer_Lock                    =  16
#IDirect3DExecuteBuffer_Unlock                  =  20
#IDirect3DExecuteBuffer_SetExecuteData          =  24
#IDirect3DExecuteBuffer_GetExecuteData          =  28
#IDirect3DExecuteBuffer_Validate                =  32
#IDirect3DExecuteBuffer_Optimize                =  36


; *
; * Light interfaces
; *
#IDirect3DLight_QueryInterface                  =   0
#IDirect3DLight_AddRef                          =   4
#IDirect3DLight_Release                         =   8
#IDirect3DLight_Initialize                      =  12
#IDirect3DLight_SetLight                        =  16
#IDirect3DLight_GetLight                        =  20

; *
; * Material interfaces
; *
#IDirect3DMaterial_QueryInterface               =   0
#IDirect3DMaterial_AddRef                       =   4
#IDirect3DMaterial_Release                      =   8
#IDirect3DMaterial_Initialize                   =  12
#IDirect3DMaterial_SetMaterial                  =  16
#IDirect3DMaterial_GetMaterial                  =  20
#IDirect3DMaterial_GetHandle                    =  24
#IDirect3DMaterial_Reserve                      =  28
#IDirect3DMaterial_Unreserve                    =  32

#IDirect3DMaterial2_QueryInterface              =   0
#IDirect3DMaterial2_AddRef                      =   4
#IDirect3DMaterial2_Release                     =   8
#IDirect3DMaterial2_SetMaterial                 =  12
#IDirect3DMaterial2_GetMaterial                 =  16
#IDirect3DMaterial2_GetHandle                   =  20

#IDirect3DMaterial3_QueryInterface              =   0
#IDirect3DMaterial3_AddRef                      =   4
#IDirect3DMaterial3_Release                     =   8
#IDirect3DMaterial3_SetMaterial                 =  12
#IDirect3DMaterial3_GetMaterial                 =  16
#IDirect3DMaterial3_GetHandle                   =  20

; *
; * Texture interfaces
; *
#IDirect3DTexture_QueryInterface                =   0
#IDirect3DTexture_AddRef                        =   4
#IDirect3DTexture_Release                       =   8
#IDirect3DTexture_Initialize                    =  12
#IDirect3DTexture_GetHandle                     =  16
#IDirect3DTexture_PaletteChanged                =  20
#IDirect3DTexture_Load                          =  24
#IDirect3DTexture_Unload                        =  28

#IDirect3DTexture2_QueryInterface               =   0
#IDirect3DTexture2_AddRef                       =   4
#IDirect3DTexture2_Release                      =   8
#IDirect3DTexture2_GetHandle                    =  12
#IDirect3DTexture2_PaletteChanged               =  16
#IDirect3DTexture2_Load                         =  20

; *
; * Viewport interfaces
; *
#IDirect3DViewport_QueryInterface               =   0
#IDirect3DViewport_AddRef                       =   4
#IDirect3DViewport_Release                      =   8
#IDirect3DViewport_Initialize                   =  12
#IDirect3DViewport_GetViewport                  =  16
#IDirect3DViewport_SetViewport                  =  20
#IDirect3DViewport_TransformVertices            =  24
#IDirect3DViewport_LightElements                =  28
#IDirect3DViewport_SetBackground                =  32
#IDirect3DViewport_GetBackground                =  36
#IDirect3DViewport_SetBackgroundDepth           =  40
#IDirect3DViewport_GetBackgroundDepth           =  44
#IDirect3DViewport_Clear                        =  48
#IDirect3DViewport_AddLight                     =  52
#IDirect3DViewport_DeleteLight                  =  56
#IDirect3DViewport_NextLight                    =  60

#IDirect3DViewport2_QueryInterface              =   0
#IDirect3DViewport2_AddRef                      =   4
#IDirect3DViewport2_Release                     =   8
#IDirect3DViewport2_Initialize                  =  12
#IDirect3DViewport2_GetViewport                 =  16
#IDirect3DViewport2_SetViewport                 =  20
#IDirect3DViewport2_TransformVertices           =  24
#IDirect3DViewport2_LightElements               =  28
#IDirect3DViewport2_SetBackground               =  32
#IDirect3DViewport2_GetBackground               =  36
#IDirect3DViewport2_SetBackgroundDepth          =  40
#IDirect3DViewport2_GetBackgroundDepth          =  44
#IDirect3DViewport2_Clear                       =  48
#IDirect3DViewport2_AddLight                    =  52
#IDirect3DViewport2_DeleteLight                 =  56
#IDirect3DViewport2_NextLight                   =  60
#IDirect3DViewport2_GetViewport2                =  64
#IDirect3DViewport2_SetViewport2                =  68

#IDirect3DViewport3_QueryInterface              =   0
#IDirect3DViewport3_AddRef                      =   4
#IDirect3DViewport3_Release                     =   8
#IDirect3DViewport3_Initialize                  =  12
#IDirect3DViewport3_GetViewport                 =  16
#IDirect3DViewport3_SetViewport                 =  20
#IDirect3DViewport3_TransformVertices           =  24
#IDirect3DViewport3_LightElements               =  28
#IDirect3DViewport3_SetBackground               =  32
#IDirect3DViewport3_GetBackground               =  36
#IDirect3DViewport3_SetBackgroundDepth          =  40
#IDirect3DViewport3_GetBackgroundDepth          =  44
#IDirect3DViewport3_Clear                       =  48
#IDirect3DViewport3_AddLight                    =  52
#IDirect3DViewport3_DeleteLight                 =  56
#IDirect3DViewport3_NextLight                   =  60
#IDirect3DViewport3_GetViewport2                =  64
#IDirect3DViewport3_SetViewport2                =  68
;#IDirect3DViewport3_SetBackgroundDepth          =  72
;#IDirect3DViewport3_GetBackgroundDepth          =  76
#IDirect3DViewport3_Clear2                      =  80

;*** IDirect3DVertexBuffer methods ***
#IDirect3DVertexBuffer_QueryInterface           =   0
#IDirect3DVertexBuffer_AddRef                   =   4
#IDirect3DVertexBuffer_Release                  =   8
#IDirect3DVertexBuffer_Lock                     =  12
#IDirect3DVertexBuffer_Unlock                   =  16
#IDirect3DVertexBuffer_ProcessVertices          =  20
#IDirect3DVertexBuffer_GetVertexBufferDesc      =  24
#IDirect3DVertexBuffer_Optimize                 =  28

#IDirect3DVertexBuffer7_QueryInterface          =   0
#IDirect3DVertexBuffer7_AddRef                  =   4
#IDirect3DVertexBuffer7_Release                 =   8
#IDirect3DVertexBuffer7_Lock                    =  12
#IDirect3DVertexBuffer7_Unlock                  =  16
#IDirect3DVertexBuffer7_ProcessVertices         =  20
#IDirect3DVertexBuffer7_GetVertexBufferDesc     =  24
#IDirect3DVertexBuffer7_Optimize                =  28
#IDirect3DVertexBuffer7_ProcessVerticesStrided  =  32



;****************************************************************************
;*
;* Flags for IDirect3DDevice::NextViewport
;*
;****************************************************************************
;
;*
;* Return the next viewport
;*
#D3DNEXT_NEXT             = $00000001
;
;*
;* Return the first viewport
;*
#D3DNEXT_HEAD             = $00000002
;
;*
;* Return the last viewport
;*
#D3DNEXT_TAIL             = $00000004
;
;
;****************************************************************************
;*
;* Flags for DrawPrimitive/DrawIndexedPrimitive
;*   Also valid for Begin/BeginIndexed
;*   Also valid for VertexBuffer::CreateVertexBuffer
;****************************************************************************
;
;*
;* Wait until the device is ready to draw the primitive
;* This will cause DP to not return DDERR_WASSTILLDRAWING
;*
#D3DDP_WAIT               = $00000001

;
;*
;* Hint that the primitives have been clipped by the application.
;*
#D3DDP_DONOTCLIP          = $00000004
;
;*
;* Hint that the extents need not be updated.
;*
#D3DDP_DONOTUPDATEEXTENTS = $00000008

; *
; * Hint that the lighting should not be applied on vertices.
; *

#D3DDP_DONOTLIGHT         = $00000010



;*
;* Direct3D Errors
;* DirectDraw error codes are used when errors not specified here.
;*
#DD_OK                            = 0
#D3D_OK                           = #DD_OK

#D3DERR_BADMAJORVERSION           = $887602bc             ; +++ NOTE: #define _FACDD 0x876
#D3DERR_BADMINORVERSION           = $887602bd             ; +++ #define MAKE_DDHRESULT( code )
                                                          ; +++ MAKE_HRESULT( 1, _FACDD, code )

;*
;* An invalid device was requested by the application.
;*
#D3DERR_INVALID_DEVICE            = $887602c1
#D3DERR_INITFAILED                = $887602c2

;*
;* SetRenderTarget attempted on a device that was
;* QI'd off the render target.
;*
#D3DERR_DEVICEAGGREGATED          = $887602c3


#D3DERR_EXECUTE_CREATE_FAILED     = $887602c6
#D3DERR_EXECUTE_DESTROY_FAILED    = $887602c7
#D3DERR_EXECUTE_LOCK_FAILED       = $887602c8
#D3DERR_EXECUTE_UNLOCK_FAILED     = $887602c9
#D3DERR_EXECUTE_LOCKED            = $887602ca
#D3DERR_EXECUTE_NOT_LOCKED        = $887602cb

#D3DERR_EXECUTE_FAILED            = $887602cc
#D3DERR_EXECUTE_CLIPPED_FAILED    = $887602cd

#D3DERR_TEXTURE_NO_SUPPORT        = $887602d0
#D3DERR_TEXTURE_CREATE_FAILED     = $887602d1
#D3DERR_TEXTURE_DESTROY_FAILED    = $887602d2
#D3DERR_TEXTURE_LOCK_FAILED       = $887602d3
#D3DERR_TEXTURE_UNLOCK_FAILED     = $887602d4
#D3DERR_TEXTURE_LOAD_FAILED       = $887602d5
#D3DERR_TEXTURE_SWAP_FAILED       = $887602d6
#D3DERR_TEXTURE_LOCKED            = $887602d7
#D3DERR_TEXTURE_NOT_LOCKED        = $887602d8
#D3DERR_TEXTURE_GETSURF_FAILED    = $887602d9

#D3DERR_MATRIX_CREATE_FAILED      = $887602da
#D3DERR_MATRIX_DESTROY_FAILED     = $887602db
#D3DERR_MATRIX_SETDATA_FAILED     = $887602dc
#D3DERR_MATRIX_GETDATA_FAILED     = $887602dd
#D3DERR_SETVIEWPORTDATA_FAILED    = $887602de

#D3DERR_INVALIDCURRENTVIEWPORT    = $887602df
#D3DERR_INVALIDPRIMITIVETYPE      = $887602e0
#D3DERR_INVALIDVERTEXTYPE         = $887602e1
#D3DERR_TEXTURE_BADSIZE           = $887602e2
#D3DERR_INVALIDRAMPTEXTURE        = $887602e3

#D3DERR_MATERIAL_CREATE_FAILED    = $887602e4
#D3DERR_MATERIAL_DESTROY_FAILED   = $887602e5
#D3DERR_MATERIAL_SETDATA_FAILED   = $887602e6
#D3DERR_MATERIAL_GETDATA_FAILED   = $887602e7
#D3DERR_INVALIDPALETTE            = $887602e8

#D3DERR_ZBUFF_NEEDS_SYSTEMMEMORY  = $887602e9
#D3DERR_ZBUFF_NEEDS_VIDEOMEMORY   = $887602ea
#D3DERR_SURFACENOTINVIDMEM        = $887602eb

#D3DERR_LIGHT_SET_FAILED          = $887602ee
#D3DERR_LIGHTHASVIEWPORT          = $887602ef
#D3DERR_LIGHTNOTINTHISVIEWPORT    = $887602f0

#D3DERR_SCENE_IN_SCENE            = $887602f8
#D3DERR_SCENE_NOT_IN_SCENE        = $887602f9
#D3DERR_SCENE_BEGIN_FAILED        = $887602fa
#D3DERR_SCENE_END_FAILED          = $887602fb

#D3DERR_INBEGIN                   = $88760302
#D3DERR_NOTINBEGIN                = $88760303
#D3DERR_NOVIEWPORTS               = $88760304
#D3DERR_VIEWPORTDATANOTSET        = $88760305
#D3DERR_VIEWPORTHASNODEVICE       = $88760306
#D3DERR_NOCURRENTVIEWPORT         = $88760307


#D3DERR_INVALIDVERTEXFORMAT       = $88760800                                    

; *
; * Attempted To CreateTexture on a surface that had a color key
; *
#D3DERR_COLORKEYATTACHED          = $88760802
                                    
#D3DERR_VERTEXBUFFEROPTIMIZED     = $8876080c
#D3DERR_VBUF_CREATE_FAILED        = $8876080d
#D3DERR_VERTEXBUFFERLOCKED        = $8876080e
#D3DERR_VERTEXBUFFERUNLOCKFAILED  = $8876080f

#D3DERR_ZBUFFER_NOTPRESENT        = $88760816
#D3DERR_STENCILBUFFER_NOTPRESENT  = $88760817

#D3DERR_WRONGTEXTUREFORMAT        = $88760818
#D3DERR_UNSUPPORTEDCOLOROPERATION = $88760819
#D3DERR_UNSUPPORTEDCOLORARG       = $8876081a        
#D3DERR_UNSUPPORTEDALPHAOPERATION = $8876081b
#D3DERR_UNSUPPORTEDALPHAARG       = $8876081c
#D3DERR_TOOMANYOPERATIONS         = $8876081d
#D3DERR_CONFLICTINGTEXTUREFILTER  = $8876081e
#D3DERR_UNSUPPORTEDFACTORVALUE    = $8876081f
#D3DERR_CONFLICTINGRENDERSTATE    = $88760821
#D3DERR_UNSUPPORTEDTEXTUREFILTER  = $88760822
#D3DERR_TOOMANYPRIMITIVES         = $88760823
#D3DERR_INVALIDMATRIX             = $88760824
#D3DERR_TOOMANYVERTICES           = $88760825
#D3DERR_CONFLICTINGTEXTUREPALETTE = $88760826

#D3DERR_INVALIDSTATEBLOCK         = $88760834
#D3DERR_INBEGINSTATEBLOCK         = $88760835
#D3DERR_NOTINBEGINSTATEBLOCK      = $88760836

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -