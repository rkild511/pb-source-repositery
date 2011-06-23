; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1726
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. July 2003
; OS: Windows
; Demo: No


; Mouse position relative to the top-left corner of ScrollAreaGadget 
; Mausposition relativ zum Gadgetursprung im ScrollAreaGadget 
; 
; by Danilo, 18.07.2003 - german forum 
; 
Procedure GetMouseX(Gadget) 
  GetCursorPos_(mouse.POINT) 
  MapWindowPoints_(0,GadgetID(Gadget),mouse,1) 
  ProcedureReturn mouse\x 
EndProcedure 


Procedure GetMouseY(Gadget) 
  GetCursorPos_(mouse.POINT) 
  MapWindowPoints_(0,GadgetID(Gadget),mouse,1) 
  ProcedureReturn mouse\y 
EndProcedure 


Procedure MakeImage() 
  hImg = CreateImage(1,1024,768) 
  StartDrawing(ImageOutput(1)) 
    For x = 0 To 1024 Step 100 
      For y = 0 To 768 Step 100 
        Box(x,y,50,50,$00FFFF) 
      Next y 
    Next x 
  StopDrawing() 
  ProcedureReturn hImg 
EndProcedure 



OpenWindow(0,200,200,300,320,"Test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  TextGadget(1,  0,0,100,20,"MouseClick X: 0") 
  TextGadget(2,100,0,100,20,"MouseClick Y: 0") 

  ScrollAreaGadget(3,0,20,300,300,1024,768,10) 
    ImageGadget(4,0,0,1024,768,MakeImage()) 
  CloseGadgetList() 

Repeat
  Select WaitWindowEvent() 
    
    Case #PB_Event_CloseWindow:End 
    Case 13100;#WM_LBUTTONDOWN 
      SetGadgetText(1,"MouseClick X: "+Str( GetMouseX(4) )) 
      SetGadgetText(2,"MouseClick Y: "+Str( GetMouseY(4) )) 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
