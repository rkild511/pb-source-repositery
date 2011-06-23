; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7820&highlight=
; Author: pythagoras_156 (updated for PB4.00 by blbltheworm)
; Date: 08. October 2003
; OS: Windows
; Demo: Yes


; Here is a procedure i wrote to create an outline for a sprite.
; It can be useful for example if you want to highlight a selected
; sprite object. The idea is to scan the sprite in four directions
; (left to right, right to left, top to bottom, bottom to top) and
; to write a specified outline color at the sprite boundaries.
; By excluding the transparent color it allows for a near-perfect
; outline. I say near-perfect because due to the scan loop breaking
; each time a boundary is met, a few boundaries pixels are not taken
; in account. 
; Although, it is already quite fast, i wonder if it can be accelerated
; even more or if anyone has a better idea to get a perfect outline. 



#GFX_OUTLINE = 1 

Procedure DisplaySpriteOutline(sprite_id.l,x.l,y.l,transparent_color.l,outline_color.l) 
  
  CopySprite(sprite_id,#GFX_OUTLINE) 

  ; From left to right - top to bottom 
  StartDrawing(SpriteOutput(#GFX_OUTLINE)) 
    adr=DrawingBuffer() 
    add=DrawingBufferPitch() 
  StopDrawing() 
  For j=0 To SpriteHeight(#GFX_OUTLINE)-1 
    *adr2 =adr 
    For i=0 To SpriteWidth(#GFX_OUTLINE)-1 
      color.l = PeekL(*adr2) 
      If color <> transparent_color : PokeL(*adr2,outline_color) : Break : EndIf 
      *adr2+4 
    Next 
    adr+add 
  Next 
  
  ; From right to left - top to bottom 
  StartDrawing(SpriteOutput(#GFX_OUTLINE)) 
    adr=DrawingBuffer() 
    add=DrawingBufferPitch() 
  StopDrawing() 
  For j=0 To SpriteHeight(#GFX_OUTLINE)-1 
    *adr2 =adr + (4*(SpriteWidth(#GFX_OUTLINE)-1)) 
    For i=0 To SpriteWidth(#GFX_OUTLINE)-1 
      color.l = PeekL(*adr2) 
      If color <> transparent_color : PokeL(*adr2,outline_color) : Break : EndIf 
      *adr2-4 
    Next 
    adr+add 
  Next 
  
  ; From top to bottom - left to Right 
  StartDrawing(SpriteOutput(#GFX_OUTLINE)) 
    adr=DrawingBuffer() 
    add=DrawingBufferPitch() 
  StopDrawing() 
  For i=0 To SpriteWidth(#GFX_OUTLINE)-1 
    *adr2 = adr 
    For j=0 To SpriteHeight(#GFX_OUTLINE)-1 
      color.l = PeekL(*adr2) 
      If color <> transparent_color : PokeL(*adr2,outline_color) : Break : EndIf 
      *adr2+add 
    Next 
    adr+4 
  Next 
  
  ; From bottom to top - left to Right 
  StartDrawing(SpriteOutput(#GFX_OUTLINE)) 
    adr=DrawingBuffer() 
    add=DrawingBufferPitch() 
  StopDrawing() 
  For i=0 To SpriteWidth(#GFX_OUTLINE)-1 
    *adr2 = adr +(add*(SpriteHeight(#GFX_OUTLINE)-1)) 
    For j=0 To SpriteHeight(#GFX_OUTLINE)-1 
      color.l = PeekL(*adr2) 
      If color <> transparent_color : PokeL(*adr2,outline_color) : Break : EndIf 
      *adr2-add 
    Next 
    adr+4 
  Next 
    
  TransparentSpriteColor(#GFX_OUTLINE,RGB(Red(transparent_color),Green(transparent_color),Blue(transparent_color))) 
  DisplayTransparentSprite(#GFX_OUTLINE,x,y) 
  FreeSprite(#GFX_OUTLINE) 
EndProcedure 

; TEST PROGRAM 
InitSprite() 
OpenWindow(1,100,100,128,128,"Outline",#PB_Window_SystemMenu) 
OpenWindowedScreen(WindowID(1),0,0,128,128,0,0,0) 
; Load the sprite you want to test the procedure with and set the correct transparent color. 
LoadSprite(2,"..\Gfx\Geebee2.bmp") : TransparentSpriteColor(2,RGB(255,0,255)) 

Repeat 
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
  DisplayTransparentSprite(2,0,0) 
  DisplaySpriteOutline(2,0,0,RGB(255,0,255),$FF0000) 
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
