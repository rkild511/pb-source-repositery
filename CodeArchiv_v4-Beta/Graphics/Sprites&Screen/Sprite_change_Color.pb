; German forum:
; Author: Danilo (extended + updated for PB4.00 by blbltheworm)
; Date: 28. May 2003
; OS: Windows
; Demo: Yes

; Manipulate 8-Bit (!) Sprites directly in memory
; here the color will be changed pixel by pixel

; Changes for PB4-Version (by blbltheworm):
; I put the original source by Danilo in a procedure and wrote a little example

Procedure ChangeColor(Sprite.l, oldColor.w,newColor.w)
  StartDrawing(SpriteOutput(Sprite)) 
  *MemoryAddress.BYTE = DrawingBuffer() 
  memSize.l=DrawingBufferPitch()*SpriteHeight(Sprite)-1

  For i = 0 To memSize
    If *MemoryAddress\b = oldColor
      *MemoryAddress\b = newColor
    EndIf 
    *MemoryAddress + 1 
  Next i  
  StopDrawing() 
EndProcedure

InitSprite()
InitScreen()
InitPalette()
InitKeyboard()

OpenScreen(800,600,8,"Sprite change Color")
LoadSprite(0,"..\Gfx\Game.bmp",0)    ;8-Bit!!
LoadPalette(0,"..\Gfx\Game.bmp")

DisplayPalette(0)

Repeat
  StartDrawing(ScreenOutput())
    Box(0,0,800,600,61) ;61=black
    DrawText(0,0,"Press [SPACE] to change Color")
  StopDrawing()
    
  DisplaySprite(0,(800-SpriteWidth(0))/2, (600-SpriteHeight(0))/2)  
  FlipBuffers()
  
  Delay(1)
  
  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Escape) : End : EndIf
Until KeyboardPushed(#PB_Key_Space)

ChangeColor(0,63,0)

Repeat
  StartDrawing(ScreenOutput())
    Box(0,0,800,600,61)
    DrawText(0,0,"Color changed")
  StopDrawing()
  
  DisplaySprite(0,(800-SpriteWidth(0))/2, (600-SpriteHeight(0))/2)
  FlipBuffers()
  
  Delay(1)
  
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger