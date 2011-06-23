; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7731&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 08. October 2003
; OS: Windows
; Demo: No

; My dreams come true: working GFA16 commands in PB!  
; CLS,GET,PUT,STRETCH,GRAB ;(grab is a PUT for part of image) 


;Binary raster operation - october 7 - 2003 - by Einander 
;Combines the bits from the selected pen with the bits in the destination bitmap. 
;(Bit-block transfer of color Data from source DC into a destination DC) 

; -********Choose your BitMap on line 39************* 
;With Debugger option Off, gets your BitMap; else, only part of debug window 

; 15 combination modes: 
;#BLACKNESS, #DSTINVERT, #MERGECOPY, #MERGEPAINT, #NOTSRCCOPY, #NOTSRCERASE ;#PATCOPY 
; #PATINVERT, #PATPAINT, #SRCAND, #SRCCOPY, #SRCERASE, #SRCINVERT, #SRCPAINT, #WHITENESS 

#winMain=1

Procedure Get(x,y,Wi,He)    ; Get source image - returns image handle 
   SRC=GetDC_(WindowID(#winMain)) 
   DEST = CreateCompatibleDC_(SRC) 
   SelectObject_(DEST,CreateImage(0,Wi,He))  
   BitBlt_(DEST,0,0,Wi,He,SRC,x,y,#SRCCOPY) 
   ProcedureReturn DEST 
EndProcedure 

Procedure Put(x,y,IMG,MODE) ; Draws image from IMG TO DEST (DEST = GetDC_(SrcID))  
    BitBlt_(GetDC_(WindowID(#winMain)),x,y,ImageWidth(1),ImageHeight(1),IMG,0,0,MODE) 
EndProcedure 

Procedure Stretch(x,y,Wi,He,IMG,MODE)  ; draws stretched image  
     StretchBlt_(GetDC_(WindowID(#winMain)),x,y,Wi,He,IMG,0,0,ImageWidth(1),ImageHeight(1),MODE) 
EndProcedure 

Procedure Grab(StartX,StartY,Wi,He,IMG,x,y,MODE)  ; draws part of image 
    BitBlt_(GetDC_(WindowID(#winMain)),x,y,Wi,He,IMG,StartX,StartY,MODE) 
EndProcedure 

Procedure CLS(color)   ; clear screen 
StartDrawing(WindowOutput(#winMain)) 
Box(0,0,WindowWidth(#winMain),WindowHeight(#winMain),color) 
StopDrawing() 
EndProcedure 
;__________________________ 

IMAGE$="..\gfx\PureBasic.bmp" 

LoadImage(1,IMAGE$) 
WIMG=100 : HIMG=100 
ResizeImage(1,WIMG,HIMG)  ; STARTING  WITH 100 X 100 PIXS 

id=OpenWindow(#winMain,0,0,WIMG,HIMG,"",#PB_Window_BorderLess  )    
StartDrawing(WindowOutput(#winMain)) 
DrawImage(ImageID(1),0,0) 
IMG=Get(0,0,WIMG,HIMG) 
StopDrawing() 
CloseWindow(#winMain) 

_X=GetSystemMetrics_(#SM_CXSCREEN) : _Y=GetSystemMetrics_(#SM_CYSCREEN) 
hWnd=OpenWindow(#winMain,0,0,_X,_Y,"",#WS_OVERLAPPEDWINDOW | #WS_MAXIMIZE) 
CLS(#Blue)      

;Testing some modes 

Put(220,100,IMG,#SRCCOPY) 
Put(350,100,IMG,#SRCPAINT) 

Stretch(20,200,200,200,IMG,#NOTSRCERASE) 
x=0 : y=_Y-150 

Repeat 
   Grab(0,0,50,50,IMG,20+i,y,#SRCINVERT) 
   i+50 
   Grab(50,50,50,50,IMG,20+i,y,#SRCINVERT) 
   y-50 
Until  y<50 

Repeat 
Until WaitWindowEvent()= #PB_Event_CloseWindow  

End  


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
