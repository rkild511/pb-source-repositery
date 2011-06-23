; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14297&highlight=
; Author: fmcpma (updated by GedB, updated for PB 4.00 by Andre)
; Date: 08. March 2005
; OS: Windows
; Demo: Yes


; *********** 
; SPRITE TEST 
; *********** 

Gosub set_up 
Gosub man_loop; MAIN LOOP 
End 

; *********** 
; SUBROUTINES 
; *********** 

; 1 SET UP 

set_up: 
   Gosub set_data; Actual constant declarations must be above actual use, so these too. 
   Gosub set_hardware 
   Gosub set_sprites 
Return 

; 1.1 Data 

set_data: 
   Gosub set_constants 
   Gosub set_variables 
   Gosub set_lists 
   Declare spr_speed() 
Return 

; 1.1.1 CONSTANTS 

set_constants: 
   #scr_width     =1024 
   #scr_height    = 768 
   #scr_depth     =  32 
   #scr_freq      =  60 
   #scr_hor_centre=#scr_width /2; SCREEN HORIZONTAL CENTRE 
   #scr_ver_centre=#scr_height/2 
    red           =RGB(255,  0,  0) 
    green         =RGB(  0,255,  0) 
    blue          =RGB(  0,  0,255) 
    white         =RGB(255,255,255) 
    purple        =RGB(255,  0,255) 
   #ball          =   1 
   #square        =   2 
   #triangle      =   3 
   #max_sprites   =1000 
   #spd_spawn     = 500; SPEED SPAWN 
   #spr_size      =  32; SPRITE SIZE 
   #second        =1000 
Return 

; 1.1.2 VARIABLES 

set_variables: 
   ths_image  .l; THIS IMAGE 
   num_sprites.l 
   lst_spawn  .l; LAST SPAWN 
   num_frames .l 
   lst_second .l 
   fps        .l 
Return 

; 1.1.3 LISTS and ARRAYS 

set_lists: 
   Structure spr_info; SPRITE INFO 
      id          .l 
      hor_position.l 
      ver_position.l 
      hor_speed   .l 
      ver_speed   .l 
   EndStructure 
   NewList spr.spr_info(); SPRITE 
   Dim image.l(3) 
Return 

; 1.2 HARDWARE 

set_hardware: 
   fontID = LoadFont(#PB_Any,"fixedsys",16)
   InitSprite() 
   InitKeyboard() 
   SetRefreshRate(#scr_freq) 
   OpenScreen(#scr_width,#scr_height,#scr_depth,"Sprite test") 
Return 

; 1.3 IMAGES 

set_sprites: 
   For ths_image=#ball To #triangle 
      image(ths_image)=CreateSprite(#PB_Any,32,32) 
      StartDrawing(SpriteOutput(image(ths_image))) 
      Select ths_image 
         Case #ball 
            Circle(15,15,15,red) 
         Case #square 
            Box(0,0,32,32,green) 
         Case #triangle 
            LineXY(15, 0, 0,31,purple) 
            LineXY( 0,31,31,31,purple) 
            LineXY(31,31,15, 0,purple) 
            FillArea(15,2,purple,purple) 
      EndSelect 
      StopDrawing() 
   Next ths_image 
Return 

; 2 MAIN LOOP 

man_loop: 
   lst_second=ElapsedMilliseconds() 
   Repeat 
      ClearScreen(RGB(0,0,0))
      Gosub spn_sprites; SPAWN SPRITES 
      Gosub drw_sprites; DRAW SPRITES 
      Gosub clc_fps    ; CALCULATE FPS 
      Gosub prt_panel  ; PRINT PANEL 
      FlipBuffers(0) 
      ExamineKeyboard() 
   Until KeyboardPushed(#PB_Key_Escape) 
Return 

; 2.1 SPAWN SPRITES 

spn_sprites: 
   If num_sprites<#max_sprites 
      If ElapsedMilliseconds()-lst_spawn>=#spd_spawn 
         lst_spawn=ElapsedMilliseconds() 
         num_sprites+1 
         LastElement(spr()) 
         AddElement(spr()) 
         spr()\id=CopySprite(image(Random(2)+1),#PB_Any) 
         spr()\hor_position=#scr_hor_centre 
         spr()\ver_position=#scr_ver_centre 
         spr()\hor_speed=spr_speed() 
         spr()\ver_speed=spr_speed() 
      EndIf 
   EndIf 
Return 

; 2.2 DRAW SPRITES 

drw_sprites: 
   ForEach spr() 
      spr()\hor_position+spr()\hor_speed 
      spr()\ver_position+spr()\ver_speed 
      DisplayTransparentSprite(spr()\id,spr()\hor_position,spr()\ver_position) 
      If spr()\hor_position<0 Or spr()\hor_position> #scr_width-#spr_size 
         spr()\hor_speed=-spr()\hor_speed 
      EndIf 
      If spr()\ver_position<0 Or spr()\ver_position>#scr_height-#spr_size 
         spr()\ver_speed=-spr()\ver_speed 
      EndIf 
   Next 
Return 

; 2.3 CALCULATE FPS 

clc_fps: 
   num_frames+1 
   If ElapsedMilliseconds()-lst_second>=#second 
      fps=num_frames 
      num_frames=0 
      lst_second+#second 
   EndIf 
Return 

; 2.4 PRINT PANEL 

prt_panel: 
   StartDrawing(ScreenOutput()) 
   DrawingMode(1) 
   DrawingFont(FontID(fontID)) 
   FrontColor(RGB(255,255,255))
   DrawText(0, 0, "SCREEN WIDTH :"+RSet(Str( #scr_width),5)) 
   DrawText(0, 12, "SCREEN HEIGHT:"+RSet(Str(#scr_height),5)) 
   DrawText(0, 24, "SCREEN DEPTH :"+RSet(Str( #scr_depth),5)) 
   DrawText(0, 36, "N. OF SPRITES:"+RSet(Str(num_sprites),5)) 
   DrawText(0, 48, "PROGRAM FPS  :"+RSet(Str(        fps),5)) 
   StopDrawing() 
Return 

; ********* 
; FUNCTIONS 
; ********* 

Procedure.l spr_speed() 
   result.l 
   result=Random(5)+1 
   If Random(1) 
      result=-result 
   EndIf 
   ProcedureReturn result 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -