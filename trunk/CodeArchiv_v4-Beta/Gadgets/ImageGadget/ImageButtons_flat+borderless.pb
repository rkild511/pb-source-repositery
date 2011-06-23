; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1470&highlight=
; Author: Wichtel (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: No

#BS_FLAT  = $8000 

links=70 
oben=50 
breite=40 
hoehe=40 


;der offset ist desktop abhängig 
xoffset=3 
yoffset=30 


OpenWindow(0,300,300,100,100,"Test",#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
TextGadget(1,10,10,80,20,"hallo",#PB_Text_Border ) 
box.l = CreateImage(0, breite,hoehe) 
StartDrawing(ImageOutput(0)) 
Box(0, 0,breite, hoehe,$FF8811) 
DrawingMode(1) 
StopDrawing() 
ImageGadget(0, links, oben, breite, hoehe,box) 

ButtonImageGadget(1,  10, 50, 40, 40, box) 
s.l=GetWindowLong_(GadgetID(1), #GWL_STYLE) 
SetWindowLong_(GadgetID(1), #GWL_STYLE, #BS_FLAT | s) 
HideGadget(1, 0) ; Need to redraw the gadget after changing it's style :( 


Repeat 
  EventID.l = WaitWindowEvent() 
  ww.l = WindowWidth(0) 
    wh.l = WindowHeight(0) 
    mx.l = WindowMouseX(0) 
    my.l = WindowMouseY(0)  

  ;SetGadgetText(1,"x: "+Str(mx)+"   y: "+Str(my)) 
  Select EventID 
  Case #WM_LBUTTONDOWN 
    If mx>=links+xoffset And mx<=links+xoffset+breite And my>=oben+yoffset And my<=oben+yoffset+hoehe 
      MessageRequester("Maus","Bild getroffen!",0) 
    EndIf 
  Case #PB_Event_Gadget 
    GadgetID = EventGadget() 
    Select GadgetID 
    Case 1 
      MessageRequester("Button","Button gedrückt!",0) 
    EndSelect 
  EndSelect    
Until EventID = #PB_Event_CloseWindow 

End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
