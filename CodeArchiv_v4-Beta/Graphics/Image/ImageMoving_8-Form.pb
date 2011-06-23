; German forum: http://www.purebasic.fr/german/viewtopic.php?t=125&highlight=
; Author: freedimension (updated for PB 4.00 by Andre)
; Date: 13. September 2004
; OS: Windows
; Demo: No


Procedure logo(bild) 
  Global x, s 
  
  d.f = 150.0 / 3.14159265 
  
  x + s 
  y = Sin((s*x) / d) * 100.0 
  
  If (x > 150) Or (x < -150) 
    s = -s 
  EndIf 
  
  StartDrawing(WindowOutput(0)) 
  Box(0,0,400,300, $FFFFFF) 
  DrawImage(bild, x+200, y+100) 
  StopDrawing() 
EndProcedure 
UseJPEGImageDecoder() 

OpenWindow(0,0,0,400,300,"Bild",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
bild.l=LoadImage(#PB_Any,"..\Gfx\image1.jpg") 
;bild.l = CreateImage(#PB_Any, 10, 10) 
bild = ImageID(bild) 
NewColor = GetSysColor_(#COLOR_BTNFACE) ; #COLOR_WINDOW 
NewColor = RGB(Blue(NewColor),Green(NewColor),Red(NewColor)) 
x=0:s=1:y=0 
f=0.1 
intervall = 1.0/f 
Repeat 
  Delay(10) 
  logo(bild) 
  Select WindowEvent() 
    Case #PB_Event_CloseWindow 
      quit = 1 
  EndSelect 
Until quit 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger