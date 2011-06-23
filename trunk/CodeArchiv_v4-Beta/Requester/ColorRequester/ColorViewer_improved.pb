; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1418&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: Yes

Procedure UpdateColorz() 
  Shared rot, gruen, blau 
  Wert = (blau << 16) | (gruen << 8) | (rot) 
  StartDrawing(ImageOutput(1)) 
                 Box(0, 0, 260, 20, RGB(rot, gruen, blau)) 
               StopDrawing() 
               SetGadgetState(50,ImageID(1)) 
               SetGadgetText(30, "$"+RSet(Hex(blau),2,"0")+RSet(Hex(gruen),2,"0")+RSet(Hex(rot),2,"0")) 
  StartDrawing(ImageOutput(2)) 
                 Box(0, 0, 260, 20, Wert) 
               StopDrawing() 
               SetGadgetState(51,ImageID(2)) 
               SetGadgetText(40, StrU(Wert,2)) 
EndProcedure 

If OpenWindow(0, 0, 0, 340, 140, "FarbenHexer", #PB_Window_MinimizeGadget| #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    TextGadget(0, 5, 5, 25, 20, "rot") 
    TrackBarGadget(1, 35,  5, 265, 20, 0, 255) 
    StringGadget(2, 305, 5, 30, 20, "0", #PB_String_ReadOnly) 
    
    TextGadget(10, 5, 30, 25, 20, "grün") 
    TrackBarGadget(11, 35, 30, 265, 20, 0, 255) 
    StringGadget(12, 305, 30, 30, 20, "0", #PB_String_ReadOnly) 
    
    TextGadget(20, 5, 55, 25, 20, "blau") 
    TrackBarGadget(21, 35, 55, 265, 20, 0, 255) 
    StringGadget(22, 305, 55, 30, 20, "0", #PB_String_ReadOnly) 
    
    StringGadget(30, 5, 90 , 60, 20, "$000000", #PB_String_ReadOnly) 
    StringGadget(40, 5, 115, 60, 20, "0"      , #PB_String_ReadOnly) 

    CreateImage(1, 260, 20) 
    CreateImage(2, 260, 20) 
    ImageGadget(50,75, 90,260,20,ImageID(1)) 
    ImageGadget(51,75,115,260,20,ImageID(2)) 
  EndIf 
  
EndIf 

Repeat  
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      GadgetID = EventGadget() 
      Select GadgetID 
        Case 1 
          rot = GetGadgetState(1) 
          SetGadgetText(2, Str(rot)) 
        Case 11 
          gruen = GetGadgetState(11) 
          SetGadgetText(12, Str(gruen)) 
        Case 21 
          blau = GetGadgetState(21) 
          SetGadgetText(22, Str(blau)) 
      EndSelect 
      If GadgetID=1 Or GadgetID=11 Or GadgetID=21 
        UpdateColorz() 
      EndIf 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
