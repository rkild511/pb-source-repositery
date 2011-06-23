; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2285&postdays=0&postorder=asc&start=10
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 12. March 2005
; OS: Windows, Linux
; Demo: Yes


; Binary Sierpinski triangle
; Binäres Sierpinskidreieck

Img = CreateImage(#PB_Any, 500, 500) 
StartDrawing(ImageOutput(Img)) 
  For x = 0 To 500 
    For y = 0 To 500 
      If x & y <> 0  
        Plot(x,y, $FF) 
      EndIf 
    Next y 
  Next x 
StopDrawing() 

OpenWindow(0, 200,200, 500,500, "", #PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
ImageGadget(0, 0, 0, 500, 500, ImageID(Img)) 


Repeat 
  Event = WaitWindowEvent() 
  If Event = 0 
    Delay(1) 
  EndIf 
Until Event = #PB_Event_CloseWindow
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger