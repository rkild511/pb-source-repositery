; German forum: http://www.purebasic.fr/german/viewtopic.php?t=605&highlight=
; Author: S.M. (updated for PB 4.00 by Andre)
; Date: 02. November 2004
; OS: Windows
; Demo: No

; Sprite resizing via DirectDraw
; Sprites vergrößern oder verkleinern via DirectDraw

#DDBLT_WAIT=16777216 

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


Procedure ResizeSprite(Sprite,Width,Height);Gibt bei Fehlern 0 zurück. 
  If Width<=0 Or Height<=0:ProcedureReturn 0:EndIf 
  
  *Sprite.PB_Sprite=IsSprite(Sprite) 
  If *Sprite=0:ProcedureReturn 0:EndIf 
  
  *DDS.IDirectDrawSurface7=*Sprite\Sprite 
  If *DDS=0:ProcedureReturn 0:EndIf 
  
  *DDS\GetDDInterface(@*DD.IDirectDraw7) 
  If *DD=0:ProcedureReturn 0:EndIf 
  
  DDSD=AllocateMemory(124) 
  If DDSD=0:ProcedureReturn 0:EndIf 
  
  PokeL(DDSD,124) 
  If *DDS\GetSurfaceDesc(DDSD):FreeMemory(DDSD):ProcedureReturn 0:EndIf 
  PokeL(DDSD+8,Height) 
  PokeL(DDSD+12,Width) 
  
  If *DD\CreateSurface(DDSD,@*DDS2.IDirectDrawSurface7,0):FreeMemory(DDSD):ProcedureReturn 0:EndIf 
  
  rect.RECT 
  rect\left=0 
  rect\right=Width 
  rect\top=0 
  rect\bottom=Height 
  If *DDS2\Blt(rect,*DDS,0,#DDBLT_WAIT,0):FreeMemory(DDSD):*DDS\Release():ProcedureReturn 0:EndIf 
  
  FreeMemory(DDSD) 
  *DDS\Release() 
  *Sprite\Sprite=*DDS2 
  *Sprite\Width=Width 
  *Sprite\Height=Height 
  *Sprite\RealWidth=Width 
  *Sprite\RealHeight=Height 
  *Sprite\ClipX=0 
  *Sprite\ClipY=0 
  ProcedureReturn *DDS2 
EndProcedure 


;Test: 
InitSprite() 
InitKeyboard() 

OpenScreen(800,600,16,"ResizeSprite()") 

CreateSprite(1,128,128) 
StartDrawing(SpriteOutput(1)) 
For M=0 To 500 
  Circle(Random(128),Random(128),10,Random($FFFFFF)) 
Next 
BackColor(RGB(0,0,0))
FrontColor(RGB(255,255,0)) 
DrawingFont(GetStockObject_(#ANSI_VAR_FONT)) 
DrawText(1, 1, "Press enter to quit.") 
StopDrawing() 


DisplaySprite(1,0,0) 

ResizeSprite(1,256,128) 
DisplaySprite(1,128,0) 

ResizeSprite(1,256,256) 
DisplaySprite(1,384,0) 

ResizeSprite(1,100,100) 
DisplaySprite(1,640,0) 

FlipBuffers() 

Repeat 
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_Return) 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -