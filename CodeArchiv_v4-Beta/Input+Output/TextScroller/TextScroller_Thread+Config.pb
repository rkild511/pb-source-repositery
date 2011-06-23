; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3465&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 18. January 2004
; OS: Windows
; Demo: Yes

#Scrolling_Image = 0 

Enumeration 
  #Scrolling_Gadget 
  #String_Gadget 
  #Button_Gadget 
  #TrackBar_Gadget 
EndEnumeration 

;{- Scrolling 

#Scrolling_Width = 390 
#Scrolling_Height = 20 

Enumeration 
  #Scrolling_OK 
  #Scrolling_End 
  #Scrolling_SetText 
  #Scrolling_Wait_SetText 
EndEnumeration 

Global Scrolling_Text.s, Scrolling_Status.l, Scrolling_Delay.l 

Procedure Scrolling(Dummy.l) 
  Protected x.l, y.l, Text.s, TextWidth.l, a.l 
  
  If CreateImage(#Scrolling_Image, #Scrolling_Width, #Scrolling_Height) 
    
    Text = Scrolling_Text 
    
    StartDrawing(ImageOutput(#Scrolling_Image)) 
      TextWidth = TextWidth(Text) 
    StopDrawing() 
    x = #Scrolling_Width 
    
    Scrolling_Status = #Scrolling_OK 
    
    Repeat 
      StartDrawing(ImageOutput(#Scrolling_Image)) 
        Box(0, 0, #Scrolling_Width, #Scrolling_Height, RGB(0, 255, 255)) 
        
        DrawingMode(1) 
        FrontColor(RGB(0,0,0)) 
        DrawText(x, y,Text) 
      StopDrawing() 
      
      SetGadgetState(#Scrolling_Gadget, ImageID(#Scrolling_Image)) 
      
      x - 1 
      If x <= -TextWidth 
        x = #Scrolling_Width 
      EndIf 
      
      Delay(Scrolling_Delay) 
      
      Select Scrolling_Status 
        Case #Scrolling_OK 
          ;Nothing to do 
          
        Case #Scrolling_End 
          Break 
        
        Case #Scrolling_SetText 
          StartDrawing(ImageOutput(#Scrolling_Image)) 
            a = TextWidth(Scrolling_Text) 
          StopDrawing() 
          Scrolling_Status = #Scrolling_Wait_SetText 
        
        Case #Scrolling_Wait_SetText 
          If x = #Scrolling_Width 
            Text = Scrolling_Text 
            TextWidth = a 
            Scrolling_Status = #Scrolling_OK 
          EndIf 
      EndSelect 
    ForEver 
  EndIf 

EndProcedure 

Procedure Scrolling_Start(Scrolltext.s, ScrollDelay.l) 
  Scrolling_Text = Scrolltext 
  Scrolling_Delay = ScrollDelay 
  CreateThread(@Scrolling(), 0) 
EndProcedure 

Procedure Scrolling_End() 
  Scrolling_Status = #Scrolling_End 
EndProcedure 

Procedure Scrolling_SetText(Scrolltext.s) 
  Scrolling_Status = #Scrolling_SetText 
  Scrolling_Text = Scrolltext 
EndProcedure 

Procedure Scrolling_SetDelay(ScrollDelay.l) 
  Scrolling_Delay = ScrollDelay 
EndProcedure 
;} 

Scrolltext.s = "Test" 

If OpenWindow(0, 0, 0, 400, 100, "Testfenster - 2", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ImageGadget(#Scrolling_Gadget, 5, 5, #Scrolling_Width, #Scrolling_Height, 0) 
    
    StringGadget(#String_Gadget, 5, 30, 370, 20, Scrolltext) 
    ButtonGadget(#Button_Gadget, 375, 30, 20, 20, "OK") 
    TrackBarGadget(#TrackBar_Gadget, 5, 55, 390, 20, 0, 50) 
    SetGadgetState(#TrackBar_Gadget, 10) 
    
    Scrolling_Start(Scrolltext, 10) 
    
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_CloseWindow 
          End 
          
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #Button_Gadget 
              Scrolling_SetText(GetGadgetText(#String_Gadget)) 
            
            Case #TrackBar_Gadget 
              Scrolling_SetDelay(GetGadgetState(#TrackBar_Gadget)) 
          EndSelect 
      EndSelect 
    ForEver 
  EndIf 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableThread
; EnableXP
