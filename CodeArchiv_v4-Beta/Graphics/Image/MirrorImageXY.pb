; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1516&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 26. June 2003
; OS: Windows
; Demo: No


; Mirroring of an image - four examples
; Spiegeln eines Bildes - vier Beispiele

; 
; by Danilo, 26.06.2003 - german forum 
; 
; Credits: Idea by benny, german forum -> thanks benny! 
; 
Procedure MirrorImageX(Image) 
  ; Mirrors an image around the X-axis 
  Width  = ImageWidth(Image) 
  Height = ImageHeight(Image) 
  hDC = StartDrawing(ImageOutput(Image)) 
    StretchBlt_(hDC,0,Height,Width,-Height,hDC,0,0,Width,Height, #SRCCOPY) ; 
  StopDrawing() 
EndProcedure 

Procedure MirrorImageY(Image) 
  ; Mirrors an image around the Y-axis 
  Width  = ImageWidth(Image) 
  Height = ImageHeight(Image) 
  hDC = StartDrawing(ImageOutput(Image)) 
    StretchBlt_(hDC,Width,0,-Width,Height,hDC,0,0,Width,Height, #SRCCOPY) ; 
  StopDrawing() 
EndProcedure 


; Make Image 
#ImageX = 100 
#ImageY = 100 
CreateImage(1,#ImageX,#ImageY) 
  StartDrawing(ImageOutput(1)) 
    FrontColor(RGB($FF,$FF,$FF)) 
    Line(0,0,#ImageX,#ImageY) 
    DrawingMode(1) 
    FrontColor(RGB($FF,$FF,$00)) 
    DrawText(0,0,"Hello World!!") 
  StopDrawing() 

CopyImage(1,2) 
CopyImage(1,3) 
CopyImage(1,4) 

; Display it mirrored 
OpenWindow(1,200,200,#ImageX*2+15,#ImageY*2+15,"",#PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(1)) 

   ImageGadget(1,5         ,5         ,#ImageX,#ImageY,ImageID(1)) 

   MirrorImageX(2) 
   ImageGadget(2,#ImageX+10,5         ,#ImageX,#ImageY,ImageID(2)) 

   MirrorImageY(3) 
   ImageGadget(3,5         ,#ImageY+10,#ImageX,#ImageY,ImageID(3)) 

   MirrorImageX(4):MirrorImageY(4) 
   ImageGadget(4,#ImageX+10,#ImageY+10,#ImageX,#ImageY,ImageID(4)) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
