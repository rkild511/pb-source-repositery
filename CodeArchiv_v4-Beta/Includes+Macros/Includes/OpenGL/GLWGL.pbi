; English forum: http://www.purebasic.fr/english/viewtopic.php?t=42461#42461
; Author: Num3
; Date: 21. December 2003
; OS: Windows
; Demo: Yes

;/ ------------------------------------------------------------------------- 
; GLWGL.INC -- Part of the OpenGL32 API Includes For PureBasic 
;  Portions copyright Microsoft (And Silicon Graphics?). 
;/ ------------------------------------------------------------------------- 

#GLWGL_INC                 = 1 

#PFD_TYPE_RGBA             = 0 
#PFD_TYPE_COLORINDEX       = 1 

#PFD_MAIN_PLANE            = 0 
#PFD_OVERLAY_PLANE         = 1 
#PFD_UNDERLAY_PLANE        = -1 

#PFD_DOUBLEBUFFER          = $00000001 
#PFD_STEREO                = $00000002 
#PFD_DRAW_TO_WINDOW        = $00000004 
#PFD_DRAW_TO_BITMAP        = $00000008 
#PFD_SUPPORT_GDI           = $00000010 
#PFD_SUPPORT_OPENGL        = $00000020 
#PFD_GENERIC_FORMAT        = $00000040 
#PFD_NEED_PALETTE          = $00000080 
#PFD_NEED_SYSTEM_PALETTE   = $00000100 
#PFD_SWAP_EXCHANGE         = $00000200 
#PFD_SWAP_COPY             = $00000400 
#PFD_SWAP_LAYER_BUFFERS    = $00000800 
#PFD_GENERIC_ACCELERATED   = $00001000 
#PFD_SUPPORT_DIRECTDRAW    = $00002000 

#PFD_DEPTH_DONTCARE        = $20000000 
#PFD_DOUBLEBUFFER_DONTCARE = $40000000 
#PFD_STEREO_DONTCARE       = $80000000 

#WGL_FONT_LINES            = 0 
#WGL_FONT_POLYGONS         = 1 

#LPD_DOUBLEBUFFER          = $00000001 
#LPD_STEREO                = $00000002 
#LPD_SUPPORT_GDI           = $00000010 
#LPD_SUPPORT_OPENGL        = $00000020 
#LPD_SHARE_DEPTH           = $00000040 
#LPD_SHARE_STENCIL         = $00000080 
#LPD_SHARE_ACCUM           = $00000100 
#LPD_SWAP_EXCHANGE         = $00000200 
#LPD_SWAP_COPY             = $00000400 
#LPD_TRANSPARENT           = $00001000 

#LPD_TYPE_RGBA             = 0 
#LPD_TYPE_COLORINDEX       = 1 

#WGL_SWAP_MAIN_PLANE       = $00000001 
#WGL_SWAP_OVERLAY1         = $00000002 
#WGL_SWAP_OVERLAY2         = $00000004 
#WGL_SWAP_OVERLAY3         = $00000008 
#WGL_SWAP_OVERLAY4         = $00000010 
#WGL_SWAP_OVERLAY5         = $00000020 
#WGL_SWAP_OVERLAY6         = $00000040 
#WGL_SWAP_OVERLAY7         = $00000080 
#WGL_SWAP_OVERLAY8         = $00000100 
#WGL_SWAP_OVERLAY9         = $00000200 
#WGL_SWAP_OVERLAY10        = $00000400 
#WGL_SWAP_OVERLAY11        = $00000800 
#WGL_SWAP_OVERLAY12        = $00001000 
#WGL_SWAP_OVERLAY13        = $00002000 
#WGL_SWAP_OVERLAY14        = $00004000 
#WGL_SWAP_OVERLAY15        = $00008000 
#WGL_SWAP_UNDERLAY1        = $00010000 
#WGL_SWAP_UNDERLAY2        = $00020000 
#WGL_SWAP_UNDERLAY3        = $00040000 
#WGL_SWAP_UNDERLAY4        = $00080000 
#WGL_SWAP_UNDERLAY5        = $00100000 
#WGL_SWAP_UNDERLAY6        = $00200000 
#WGL_SWAP_UNDERLAY7        = $00400000 
#WGL_SWAP_UNDERLAY8        = $00800000 
#WGL_SWAP_UNDERLAY9        = $01000000 
#WGL_SWAP_UNDERLAY10       = $02000000 
#WGL_SWAP_UNDERLAY11       = $04000000 
#WGL_SWAP_UNDERLAY12       = $08000000 
#WGL_SWAP_UNDERLAY13       = $10000000 
#WGL_SWAP_UNDERLAY14       = $20000000 
#WGL_SWAP_UNDERLAY15       = $40000000 

#WGL_SWAPMULTIPLE_MAX      = 16 

;/ NOT YET CONVERTED ... 

; TYPE POINTFLOAT 
; x AS SINGLE 
; y AS SINGLE 
; End TYPE 
; 
; TYPE GLYPHMETRICSFLOAT 
; gmfBlackBoxX AS SINGLE 
; gmfBlackBoxY AS SINGLE 
; gmfptGlyphOrigin AS POINTFLOAT 
; gmfCellIncX AS SINGLE 
; gmfCellIncY AS SINGLE 
; End TYPE 
; 
; TYPE tagLAYERPLANEDESCRIPTOR 
; nSize AS WORD 
; nVersion AS WORD 
; dwFlags AS DWORD 
; iPixelType AS BYTE 
; cColorBits AS BYTE 
; cRedBits AS BYTE 
; cRedShift AS BYTE 
; cGreenBits AS BYTE 
; cGreenShift AS BYTE 
; cBlueBits AS BYTE 
; cBlueShift AS BYTE 
; cAlphaBits AS BYTE 
; cAlphaShift AS BYTE 
; cAccumBits AS BYTE 
; cAccumRedBits AS BYTE 
; cAccumGreenBits AS BYTE 
; cAccumBlueBits AS BYTE 
; cAccumAlphaBits AS BYTE 
; cDepthBits AS BYTE 
; cStencilBits AS BYTE 
; cAuxBuffers AS BYTE 
; iLayerPlane AS BYTE 
; bReserved AS BYTE 
; crTransparent AS LONG 
; End TYPE 
; 
; TYPE WGLSWAP 
; hdc AS LONG 
; uiFlags AS DWORD 
; End TYPE 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
