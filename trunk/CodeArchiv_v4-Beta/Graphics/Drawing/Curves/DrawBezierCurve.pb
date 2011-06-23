; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6511&highlight=
; Author: ricardo (updated for PB4.00 by blbltheworm + Andre)
; Date: 12. June 2003
; OS: Windows
; Demo: No

Structure PointAPI 
  x.l 
  y.l 
EndStructure 

Global Dim P.PointAPI(3) 

Procedure CreateBezier() 
  StartDrawing(WindowOutput(0))
    Red = RGB(255,0,0) 
    Blue = RGB(0,0,255) 
    P(0)\x = 0 
    P(0)\y = 0 
    P(1)\x = 80 
    P(1)\y = 10 
    P(2)\x = 150 
    P(2)\y = 70 
    P(3)\x = 130 
    P(3)\y = 230 
    
    LineXY(P(0)\x+10,P(0)\y+10,P(1)\x+10,P(1)\y+10,Blue) 
    Box(P(0)\x+10,P(0)\y+10, 4, 4,Red) 
    Box(P(1)\x+10,P(1)\y+10, 4, 4,Red) 
    
    LineXY(P(2)\x+10,P(2)\y+10,P(3)\x+10,P(3)\y+10,Blue) 
    Box(P(2)\x+10,P(2)\y+10, 4, 4,Red) 
    Box(P(3)\x+10,P(3)\y+10, 4, 4,Red) 
    hDC = GetDC_(GadgetID(1)) 
    PolyBezier_(hDC,@P(),4) 
  StopDrawing() 
EndProcedure 


If OpenWindow(0,100,150,450,300,"Create Beizer Curve",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ImageGadget(1,10,10,255,255,0) 
  ButtonGadget(3,300,140,50,25,"Curve") 
  Repeat 
    EventID=WaitWindowEvent() 
    
    Select EventID 
    
      Case #PB_Event_Gadget 
        Select EventGadget() 
            
          Case 3 
            CreateBezier() 

        EndSelect 
    
    EndSelect 
    
  Until EventID=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
