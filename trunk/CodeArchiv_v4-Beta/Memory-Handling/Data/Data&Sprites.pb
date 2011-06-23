; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=9075#9075
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 12. June 2003
; OS: Windows
; Demo: Yes


; 
; by Danilo, 12.06.2003 - german forum 
; 
#SPRITE_W    = 50 
#SPRITE_H    = 50 
#SPRITECOUNT = 5 

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

   BigFont = LoadFont(1,"Arial",36,#PB_Font_Bold) 

   ; Sprites erstellen, 
   ; Label SpriteFarben zum lesen mit 'Read' verwenden 
   Restore SpriteFarben 

   For a = 1 To #SPRITECOUNT 
     CreateSprite(a,#SPRITE_W,#SPRITE_H) 
     StartDrawing(SpriteOutput(a)) 
       Read color 
       Box(0,0,#SPRITE_W,#SPRITE_H,color) 
       DrawingMode(1) 
       DrawingFont(BigFont) 
       FrontColor(RGB(0,0,0)) 
       DrawText(0,0,Str(a)) 
     StopDrawing() 
   Next a 


Repeat 
    FlipBuffers() 
    ExamineKeyboard() 
    If IsScreenActive() 
       ClearScreen(RGB($00,$00,$00)) 

       ; Label Bildschirm benutzen.. 
       Restore Bildschirm 

       For y = 0 To #SCREEN_H-#SPRITE_H Step #SPRITE_H 
         For x = 0 To #SCREEN_W-#SPRITE_W Step #SPRITE_W 
           Read Sprite 
           If Sprite 
             DisplaySprite(Sprite,x,y) 
           EndIf 
         Next x 
       Next y 
        
       ; Label Strings benutzen.. 
       Restore Strings 

       If StartDrawing(ScreenOutput())        
         DrawingMode(1) 
         DrawingFont(BigFont) 
         FrontColor(RGB($FF,$FF,z)) 
          z+1: If z=256:z=0:EndIf 
         For a = 1 To 4 
           Read A$ 
           DrawText(a*30,20+a*48,A$) 
         Next a 
         StopDrawing() 
       EndIf 

    Else 
       Delay(200) 
    EndIf 
Until KeyboardPushed(#PB_Key_Escape) 
End 

DataSection 
  SpriteFarben: 
    Data.l $0000FF, $00FF00, $FF0000, $00FFFF, $FF00FF 
  Bildschirm: 
    Data.l 1,2,3,4,5,0,0,0,0,0,0,5,4,3,2,1 
    Data.l 2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,2 
    Data.l 3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,3 
    Data.l 4,0,0,4,0,0,0,0,0,0,0,0,0,0,0,4 
    Data.l 5,0,0,0,5,0,0,1,2,3,4,5,0,0,0,5 
    Data.l 0,0,0,0,5,0,0,3,2,0,0,5,0,0,0,0 
    Data.l 0,0,0,0,5,0,0,2,3,0,0,5,0,0,0,0 
    Data.l 5,0,0,0,5,4,3,2,1,0,0,5,0,0,0,5 
    Data.l 4,0,0,0,0,0,0,0,0,0,0,0,4,0,0,4 
    Data.l 3,0,0,0,0,0,0,0,0,0,0,0,0,3,0,3 
    Data.l 2,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2 
    Data.l 1,2,3,4,5,0,0,0,0,0,0,5,4,3,2,1 
  Strings: 
    Data.s "Ich" 
    Data.s "bin" 
    Data.s "ein" 
    Data.s "String" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
