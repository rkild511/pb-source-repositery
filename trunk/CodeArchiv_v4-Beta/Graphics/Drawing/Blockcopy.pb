; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8145&highlight=
; Author: blueznl (updated for PB4.00 by blbltheworm)
; Date: 01. November 2003
; OS: Windows
; Demo: No

; purebasic survival guide (http://www.xs4all.nl/~bluez) 
; graphics 1: bitmaps, blockcopy, winapi 
; 31.10.2003 ejn (blueznl) 
; 
; this code shows some alternatives for the build in commands of purebasic, using: 
; 
; getdc_() 
; loadimage() 
; createcompatiblebitmap_() 
; loadimage_() 
; createcompatibledc_() 
; selectobject_() 
; deletedc_() 
; releasedc_() 
; 
; plgblt_() is an api call that can transform and rotate objects (as a variation of 
; bitblt), it does not run on all variations of windows 
; 
; note: plgblt doesn't directly output on screen, unless the debugger is switched off (!) 
; however it can be used using an intermediate step 
; 
main_whnd = OpenWindow(0,200,100,660,500,"Test",#PB_Window_SystemMenu) 
main_dc = GetDC_(WindowID(0)) 
; 
; creating your own device independent bitmap 
; 
; note: creating a bitmap with the wrong number of colours (aka. not compatible / identical 
; with current screen) doesn't display it when using DrawImage() 
; 
;   bitmap_hnd.l = createbitmap_(10,10,1,32,0) 
; 
; or use a compatible bitmap 
; 
;   bitmap_hnd.l = createcompatiblebitmap_(main_hdc,10,10) 
; 
; or load a bitmap (which, funny enough, doesn't have to be compatible) appearently the 
; bitmap and / or structure generated is not identical to a createbitmap_() yet no dc 
; is given during the call, so how does windows know how to (re)format the image? i'm missing 
; something here... but it works anyway :-) 
; 
;   bitmap_hnd.l = LoadImage_(0,"..\_projects\zm24.bmp",#IMAGE_BITMAP,0,0,#LR_LOADFROMFILE|#LR_CREATEDIBSECTION) 
; 
; but let's stick to the regular purebasic loadimage command :-) 
; 
bitmap1_hnd.l = LoadImage(0,"..\gfx\pb.bmp") 
If bitmap1_hnd = 0 : MessageRequester("Error","Image couldn't be loaded") : End : EndIf
bitmap_w = ImageWidth(0) 
bitmap_h = ImageHeight(0) 
; 
bitmap2_hnd = CreateImage(1,bitmap_w,bitmap_h) 
; 
; structure needed for plgblt_() 
; 
Structure corners 
  x1.l            ; left upper corner 
  y1.l            
  x2.l            ; right upper corner 
  y2.l 
  x3.l            ; left lower corner 
  y3.l 
EndStructure 
; 
new.corners 
new\x1 = bitmap_w 
new\y1 = 0 
new\x2 = bitmap_w 
new\y2 = bitmap_h 
new\x3 = 0 
new\y3 = 0 
;  
; create device contexts (placeholders) and select images into them 
; 
source_dc = CreateCompatibleDC_(main_dc) 
SelectObject_(source_dc,bitmap1_hnd) 
dest_dc = CreateCompatibleDC_(main_dc) 
SelectObject_(dest_dc,bitmap2_hnd) 
; 
; 
; plgblt allows rotation and transformation 
; 
;   PlgBlt_(dest_dc,@new\x1,source_dc,0,0,bitmap_w,bitmap_h,0,0,0) 
; 
; bitblt is a block copy but with a parameter that affects how the copy is handled 
; 
BitBlt_(dest_dc,0,0,bitmap_w,bitmap_h,source_dc,0,0,#SRCCOPY) 
; 
; 
DeleteDC_(source_dc) 
DeleteDC_(dest_dc) 
; 
; draw the results (from bitmap 2) into the screen 
; 
;   UseWindow(0) 
;   StartDrawing(WindowOutput()) 
;   DrawImage(bitmap2_hnd,10,10) 
;   StopDrawing() 
; 
; you could do it with bitblt as well... 
; 
;   UseWindow(0) 
;   dest_dc = StartDrawing(WindowOutput()) 
;   source_dc = CreateCompatibleDC_(main_dc) 
;   SelectObject_(source_dc,bitmap2_hnd) 
;   BitBlt_(dest_dc,10,10,bitmap_w,bitmap_h,source_dc,0,0,#SRCCOPY) 
;   deletedc_(source_dc) 
;   StopDrawing() 
; 
; however, drawing directly on screen means it's not protected, and can be overwritten 
; so either copy it back using bitblt on every redraw or using a callback, or... 
; use an imagegadget 
; 
CreateGadgetList(main_whnd) 
ImageGadget(0,10,10,bitmap_w,bitmap_h,bitmap2_hnd) 
; 
Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 
; 
FreeGadget(0) 
ReleaseDC_(main_whnd,main_dc) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
