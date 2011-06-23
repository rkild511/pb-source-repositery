; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8603&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 07. December 2003
; OS: Windows
; Demo: No


; Paint to a DC mixing API and PB commands, allowing some interesting modes
; (as #NOTSRCCOPY, #PATPAINT, etc.) with ImageGadget(). 

#IMG0=0 
#IMG1=1 

hWnd=OpenWindow(0, x,y,600,400, "NotSrcCopy", #WS_OVERLAPPEDWINDOW | #PB_Window_WindowCentered) 
hDC = GetDC_(hWnd) 
hIMG0 = LoadImage(#IMG0, "..\Gfx\PureBasic.bmp" )  ; "********your SMALL BMP here*********") 
WI = ImageWidth(#IMG0) : HE = ImageHeight(#IMG0) 
hIMG1 = CreateImage(#IMG1, WI, HE)   ; For BITBLT 

    Src_DC = CreateCompatibleDC_(hDC) 
    SelectObject_(Src_DC, hIMG0) 
    Dest_DC = CreateCompatibleDC_(hDC) 
    SelectObject_(Dest_DC, hIMG1) 
    BitBlt_(Dest_DC, 0, 0, WI, HE, Src_DC, 0, 0, #NOTSRCCOPY)  
    DeleteDC_(Src_DC) 
    DeleteDC_(Dest_DC) 
  
    CreateGadgetList(hWnd) 
     StartDrawing(WindowOutput(0)) 
      
     ImageGadget(#IMG1, 300, WindowHeight(0)-200, 0, 0, 0)    ;  x, y Position 
     SetGadgetState(#IMG1, ImageID(#IMG1))    ; For BITBLIT 
      
     ImageGadget(#IMG0, 300, 10, 0, 0, 0)    ;  x, y Posistion 
     SetGadgetState(#IMG0, ImageID(#IMG0))   ; ORIGINAL Image 
    
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
