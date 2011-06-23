; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1646&highlight=
; Author: wichtel (updated for PB4.00 by blbltheworm)
; Date: 08. July 2003
; OS: Windows
; Demo: No

#window=0 
#image1=1 
#image2=2 

#normal1=1 
#over1=2 
#normal2=3 
#over2=4 


Procedure MakePlate(id.l,x.l,y.l,t$,fg.l,bg.l) 
  CreateImage(id,x,y) 
  StartDrawing(ImageOutput(id)) 
  Box(0, 0,x,y,bg) 
  DrawingMode(1) 
  FrontColor(RGB(Red(fg),Green(fg),Blue(fg))) 
  w.l=TextWidth(t$) 
  h.l=TextWidth("Mi") 
  DrawText(x/2-w/2,y/2-h/2,t$) 
  StopDrawing() 
EndProcedure 



Procedure myMouseOver(hWnd) 
  GetCursorPos_(cursor.POINT) 
  MapWindowPoints_(0,hWnd,cursor,1) 
  ProcedureReturn ChildWindowFromPoint_(hWnd,cursor\x,cursor\y) 
EndProcedure 


MakePlate(#normal1,150,300,"Bild1a",$FFFFFF,$11FF11) 
MakePlate(#over1,150,300,"Bild1b",$FFFFFF,$1111FF) 
MakePlate(#normal2,200,200,"Bild2a",$FFFFFF,$FF1111) 
MakePlate(#over2,200,200,"Bild2b",$FFFFFF,$11FFFF) 



OpenWindow(#window,600,400,600,400, "mouseover", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#window)) 
ImageGadget(#image1,10,10,150,300,ImageID(#normal1)) 
ImageGadget(#image2,300,100,200,200,ImageID(#normal2),#PB_Image_Border ) 



Repeat 
  EventID = WaitWindowEvent() 
  MouseOverID=myMouseOver(WindowID(#window)) 
  Select MouseOverID 
    Case GadgetID(#image1) 
      SetGadgetState(#image1,ImageID(#over1)) 
    Case GadgetID(#image2) 
      SetGadgetState(#image2,ImageID(#over2)) 
    Default    
    SetGadgetState(#image1,ImageID(#normal1)) 
    SetGadgetState(#image2,ImageID(#normal2)) 
  EndSelect 
Until  EventID=#PB_Event_CloseWindow 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
