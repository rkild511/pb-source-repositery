; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1212&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 02. June 2003
; OS: Windows
; Demo: No


; Example, how the background of a player will be moved, and the player still hold its position
; in the middle of the screen

#SPRITE_W = 50 
#SPRITE_H = 50 

#SCREEN_W = 800 
#SCREEN_H = 600 

If InitSprite() = 0 Or InitKeyboard() = 0 
   MessageRequester("ERROR","Cant init DirectX",0):End 
EndIf 

If OpenScreen(#SCREEN_W,#SCREEN_H,32,"TEST") = 0    ; test 32bit 
If OpenScreen(#SCREEN_W,#SCREEN_H,24,"TEST") = 0   ; if 32bit failed, test 24bit 
  If OpenScreen(#SCREEN_W,#SCREEN_H,16,"TEST") = 0  ; if 32/24 failed, try 16bit screen 
     MessageRequester("ERROR","Cant open 16/24/32bit Screen",0):End 
  EndIf 
EndIf 
EndIf 

   ; limit Speed 
   SetFrameRate(50) 

   CreateSprite(1,#SPRITE_W,#SPRITE_H) 
   StartDrawing(SpriteOutput(1)) 
     Box(0,0,#SPRITE_W,#SPRITE_H,RGB($00,$00,$FF)) 
   StopDrawing() 

   CreateSprite(2,#SPRITE_W,#SPRITE_H) 
   StartDrawing(SpriteOutput(2)) 
     Box(0,0,#SPRITE_W,#SPRITE_H,RGB($FF,$FF,$FF)) 
   StopDrawing() 

   CreateSprite(3,50,50) 
   StartDrawing(SpriteOutput(3)) 
     DrawingMode(1) 
     FrontColor(RGB($10,$10,$10)) 
     DrawText(0,18,"Player1") 
   StopDrawing() 

Repeat 
    FlipBuffers() 
    ExamineKeyboard() 
    If IsScreenActive() 
       ;ClearScreen($66,$66,$66) 

       ; KEYBOARD CHECK 
       ; 
       If KeyboardPushed(#PB_Key_Up) 
         backY + 2 
       EndIf 
       If KeyboardPushed(#PB_Key_Down) 
         backY - 2 
       EndIf 

       If KeyboardPushed(#PB_Key_Right) 
         backX - 2 
       EndIf 

       If KeyboardPushed(#PB_Key_Left) 
         backX + 2 
       EndIf 
      

       If backY <= ((-(#SPRITE_H*2))-1) : backY + #SPRITE_H*2: EndIf 
       If backY => 1   : backY - (#SPRITE_H*2) : EndIf 
        
       If backX <= ((-(#SPRITE_W*2))-1) : backX + #SPRITE_W*2 : EndIf 
       If backX => 1   : backX - (#SPRITE_W*2) : EndIf 

       For a = 0 To (#SCREEN_W/#SPRITE_W)/2 
         For b = 0 To (#SCREEN_H/#SPRITE_H)/2 
           DisplaySprite(1,          backX+a*#SPRITE_W*2,backY+b*#SPRITE_H*2) 
           DisplaySprite(2,#SPRITE_W+backX+a*#SPRITE_W*2,backY+b*#SPRITE_H*2) 
           DisplaySprite(2,          backX+a*#SPRITE_W*2,#SPRITE_H+backY+b*#SPRITE_H*2) 
           DisplaySprite(1,#SPRITE_W+backX+a*#SPRITE_W*2,#SPRITE_H+backY+b*#SPRITE_H*2) 
         Next b 
       Next a 
       ; Player 
       DisplayTransparentSprite(3,#SCREEN_W/2-25,#SCREEN_H/2-25) 
       Sleep_(1) 
    Else 
       Sleep_(200) 
    EndIf 
Until KeyboardPushed(#PB_Key_Escape) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
