; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2847&highlight=
; Author: Andre (changed original ScrollArea example by Danilo) (updated for PB4.00 by blbltheworm)
; Date: 16. November 2003
; OS: Windows
; Demo: No

; 
; maus mapping auf gadget 
; 

#ImageW = 360
#ImageH = 260

Procedure GetMouseX(Gadget) 
  GetCursorPos_(mouse.POINT) 
  MapWindowPoints_(0,GadgetID(Gadget),mouse,1) 
  ProcedureReturn mouse\X 
EndProcedure 


Procedure GetMouseY(Gadget) 
  GetCursorPos_(mouse.POINT) 
  MapWindowPoints_(0,GadgetID(Gadget),mouse,1) 
  ProcedureReturn mouse\Y 
EndProcedure 


Procedure MakeImage() 
  hImg = CreateImage(1,#ImageW,#ImageH) 
  StartDrawing(ImageOutput(1)) 
    For X = 0 To #ImageW Step 100 
      For Y = 0 To #ImageH Step 100 
        Box(X,Y,60,60,$0000FF) 
      Next Y 
    Next X 
  StopDrawing() 
  ProcedureReturn hImg 
EndProcedure 



OpenWindow(0,200,200,400,300,"Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  TextGadget(1,  0,0,100,20,"MouseClick X: 0") 
  TextGadget(2,100,0,100,20,"MouseClick Y: 0") 
  ImageGadget(3,20,25,#ImageW,#ImageH,MakeImage()) 
Repeat 
  Debug WaitWindowEvent()
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow:End 
    Case 13100;#PB_EventType_LeftClick
      X = GetMouseX(3) : Y =  GetMouseY(3) 
      If X >= 0 And X <= #ImageW And Y >= 0 And Y <= #ImageH
        SetGadgetText(1,"MouseClick X: "+Str(X) ) 
        SetGadgetText(2,"MouseClick Y: "+Str(Y) ) 
      EndIf
  EndSelect 
ForEver 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
