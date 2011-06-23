; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1779&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 23. July 2003
; OS: Windows
; Demo: Yes

; 
; by Danilo, 23.07.2003 - german forum 
; 
Procedure UpdatePixelArray() 
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
  StartDrawing(ScreenOutput()) 
    For x = 0 To 280-1 Step 2 
      For y = 0 To 160-1 Step 2 
        Select Random(2) 
          Case 0 : color = $000000 
          Case 1 : color = $7F7F7F 
          Case 2 : color = $FFFFFF 
        EndSelect 
        Plot(x,y,color) 
      Next y 
    Next x 

    FrontColor(RGB($FF,$FF,$00)) 
    DrawingMode(1) 
    DrawText(100,80,"Pixel Array") 
  StopDrawing() 
EndProcedure 

If InitSprite() And InitMouse() 
  OpenWindow(1,200,200,400,180,"Yo!",#PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(1)) 
    ListViewGadget(1,0,0,100,100) 
      AddGadgetItem(1,-1,"ListBox") 
    StringGadget(2,0,100,100,20,"StringGadget") 
    ButtonGadget(3,0,120,100,20,"Taste 1") 
    ButtonGadget(4,0,140,100,20,"Taste 2") 
    ButtonGadget(5,0,160,100,20,"Taste 3") 

    OpenWindowedScreen(WindowID(1),110,10,280,160,0,0,0) 

    Repeat 
      Event = WindowEvent() 
      Select Event 
        Case #PB_Event_CloseWindow 
          End 
        Case 0 
          Delay(1) 
          UpdatePixelArray() 
      EndSelect 
    ForEver 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
