; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9452&highlight=
; Author: LarsG
; Date: 09. February 2004
; OS: Windows
; Demo: Yes


; Problem: I've got a sprite loaded. Basically, it's a tileset which i need to clip from
;          to display a specific tile. My problem is that I need to put that clipped part
;          of the sprite tileset into an image (i'm working on a map editor and i can't
;          display sprites in my listicon gadget). 
; Solution: Just load your tile image into a sprite, set drawing to another 
;           image or sprite, and use this procedure to display the different tiles.. 

Procedure DrawClippedSprite(image, x, y, sizex, sizey, frame) 
    Protected initwidth.l, initheight.l, yc.l 
    initwidth = SpriteWidth(image) 
    initheight = SpriteHeight(image) 
    yc = Int(Round((frame * sizex) / initwidth,0)) 
    frame = frame - (yc * Int((initwidth / sizex))) 
    yc = (yc * sizey) 
    ; get the right part of the image 
    ClipSprite(image,sizex * frame, yc, sizex, sizey) 
    DisplayTransparentSprite(image,x,y) 
    ; reset the clipsprite back to the initial values (size) 
    ClipSprite(image,0,0,initwidth,initheight) 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -