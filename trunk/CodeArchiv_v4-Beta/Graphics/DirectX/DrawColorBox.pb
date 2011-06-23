; German forum: http://www.purebasic.fr/german/viewtopic.php?p=30868#30868 
; Author: Stefan (updated for PB 4.00 by edel)
; Date: 07. April 2005 
; OS: Windows 
; Demo: No 


; Speed-improved colorbox drawing via DirectX, also usable for a partwise ClearScreen 
; Geschwindigkeitsoptimierte Variante für das Zeichnen einer Farbbox 

Structure DDBLTFX 
  dwSize.l 
  dwDDFX.l 
  dwROP.l 
  dwDDROP.l 
  dwRotationAngle.l 
  dwZBufferOpCode.l 
  dwZBufferLow.l 
  dwZBufferHigh.l 
  dwZBufferBaseDest.l 
  dwZDestConstBitDepth.l 
  dwZDestConst.l 
  dwZSrcConstBitDepth.l 
  dwZSrcConst.l 
  dwAlphaEdgeBlendBitDepth.l 
  dwAlphaEdgeBlend.l 
  dwReserved.l 
  dwAlphaDestConstBitDepth.l 
  dwAlphaDestConst.l 
  dwAlphaSrcConstBitDepth.l 
  dwAlphaSrcConst.l 
  dwFillColor.l 
  dwColorSpaceLowValue.l 
  dwColorSpaceHighValue.l 
  dwColorSpaceLowValue2.l 
  dwColorSpaceHighValue2.l 
EndStructure 
#DDBLT_COLORFILL=1024 
#DDBLT_WAIT=16777216 

Procedure _GetScreenWidth() 
  !extrn _PB_Screen_Width  
  !MOV Eax,[_PB_Screen_Width ] 
  ProcedureReturn 
EndProcedure 
Procedure _GetScreenHeight() 
  !extrn _PB_Screen_Height 
  !MOV Eax,[_PB_Screen_Height] 
  ProcedureReturn 
EndProcedure 
Procedure _GetPixelFormat() 
  !extrn _PB_DirectX_PixelFormat 
  !MOV Eax,[_PB_DirectX_PixelFormat] 
  ProcedureReturn 
EndProcedure 
Procedure _GetBackBufferSurface() 
  !extrn _PB_Sprite_CurrentBitmap 
  !MOV Eax,[_PB_Sprite_CurrentBitmap] 
  ProcedureReturn 
EndProcedure 
Procedure _RGBColor(R,G,B) 
  Select _GetPixelFormat() 
    Case #PB_PixelFormat_15Bits 
      ProcedureReturn B>>3+(G>>3)<<5+(R>>3)<<10 
    Case #PB_PixelFormat_16Bits    
      ProcedureReturn B>>3+(G>>2)<<5+(R>>3)<<11    
    Case #PB_PixelFormat_24Bits_RGB 
      ProcedureReturn R+G<<8+B<<16 
    Case #PB_PixelFormat_24Bits_BGR    
      ProcedureReturn b+G<<8+R<<16 
    Case #PB_PixelFormat_32Bits_RGB    
      ProcedureReturn R+G<<8+B<<16 
    Case #PB_PixelFormat_32Bits_BGR 
      ProcedureReturn B+G<<8+R<<16    
  EndSelect 
EndProcedure 


Procedure DrawColorBox(x,y,width,height,RGB) 
  *Back.IDirectDrawSurface7=_GetBackBufferSurface() 
  
  a.rect\left=x 
  a\right=x+width 
  a\top=y 
  a\bottom=y+height 
  
  b.rect\left=0 
  b\right=_GetScreenWidth() 
  b\top=0 
  b\bottom=_GetScreenHeight() 
  
  If IntersectRect_(dest.rect,a.rect,b.rect)=0:ProcedureReturn 0:EndIf 
  
  BltInfo.DDBLTFX\dwSize=SizeOf(DDBLTFX) 
  BltInfo\dwFillColor=_RGBColor(Red(RGB),Green(RGB),Blue(RGB)) 
  
  ProcedureReturn *Back\Blt(dest,0,0,#DDBLT_COLORFILL|#DDBLT_WAIT,BltInfo) 
EndProcedure 


InitSprite() 
InitKeyboard() 
OpenScreen(800,600,16,"Fast colorboxes") 

Repeat 
  ClearScreen(0) 
  
  For c=0 To 300 
    DrawColorBox(100,100,50,50,#Red) 
  Next 
  
  
  Count+1 
  If ElapsedMilliseconds()-Start=>1000:Start=ElapsedMilliseconds():FPS=Count:Count=0:EndIf 
  
  StartDrawing(ScreenOutput()) 
  DrawText(0,0,Str(FPS)) 
  StopDrawing() 
  
  FlipBuffers(0) 
  
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_All) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger