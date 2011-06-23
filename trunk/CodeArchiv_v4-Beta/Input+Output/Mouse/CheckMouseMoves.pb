; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2381&postdays=0&postorder=asc&start=10
; Author: Kaeru Gaman (updated for PB 4.00 by Andre)
; Date: 12. March 2005
; OS: Windows, Linux
; Demo: Yes


InitKeyboard() 
InitMouse() 
InitSprite() 

ExamineDesktops()
Screenwidth  = DesktopWidth(0)
Screenheight = DesktopHeight(0)

OpenScreen(Screenwidth, Screenheight, 32, "test") 

Repeat 

    ExamineKeyboard() 
    ExamineMouse() 
    
    MDX = MouseDeltaX() 
    MDY = MouseDeltaY() 
    MB1 = MouseButton(1) 
    MB2 = MouseButton(2) 
    
    MMV = MDX Or MDY Or MB1 Or MB2 
    
    ClearScreen(RGB(0,0,0))
    StartDrawing(ScreenOutput()) 
        DrawingMode(1) 
        FrontColor(RGB(64,128,255))
        DrawText(100,  60, "MDX = " + Str(MDX)) 
        DrawText(100,  80, "MDY = " + Str(MDY)) 
        DrawText(100, 100, "MB1 = " + Str(MB1)) 
        DrawText(100, 120, "MB2 = " + Str(MB2)) 
        DrawText(100, 140, "MMV = " + Str(MMV)) 
    StopDrawing() 
    FlipBuffers() 

Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -