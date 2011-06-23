; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5268&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 05. August 2004
; OS: Windows, Linux
; Demo: Yes


; Simulate two different windows in one, using the ContainerGadget
; Simulieren von zwei Fenstern in einem, mittels des ContainerGadget

Global MainWin.l, Image1.l, Image2.l 

Enumeration ;Entries 
  #Gad_WinE1 
  #Gad_ToWinE1 
  #Gad_Image1 
  #Gad_WinE2 
  #Gad_ToWinE2 
  #Gad_Image2 
EndEnumeration 

Image1 = CreateImage(#PB_Any, 400, 280) 
If Image1 
  StartDrawing(ImageOutput(Image1)) 
    Ellipse(200, 140, 200, 140, $FF0000) 
    DrawingMode(3) 
    FrontColor(RGB(0, $FF, $FF))
    DrawText(196, 132, "1") 
  StopDrawing() 
EndIf 

Image2 = CreateImage(#PB_Any, 400, 280) 
If Image2 
  StartDrawing(ImageOutput(Image2)) 
    Ellipse(200, 140, 200, 140, $00FF00) 
    DrawingMode(3) 
    FrontColor(RGB($FF, 0, $FF))
    DrawText(196, 132, "2") 
  StopDrawing() 
EndIf 


MainWin.l = OpenWindow(#PB_Any, 0, 0, 400, 300, "Zwei in einem", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
If MainWin 
  If CreateGadgetList(WindowID(MainWin)) 
    ContainerGadget(#Gad_WinE1, 0, 0, 400, 300, #PB_Container_BorderLess) 
      ButtonGadget(#Gad_ToWinE2, 0, 0, 400, 20, "Gehe zu Win 2") 
      ImageGadget(#Gad_Image1, 0, 20, 400, 280, ImageID(Image1)) 
    CloseGadgetList() 
    
    ContainerGadget(#Gad_WinE2, 0, 0, 400, 300, #PB_Container_BorderLess) 
    HideGadget(#Gad_WinE2, 1) 
      ButtonGadget(#Gad_ToWinE1, 0, 0, 400, 20, "Gehe zu Win 1") 
      ImageGadget(#Gad_Image2, 0, 20, 400, 280, ImageID(Image2)) 
    CloseGadgetList() 
    
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_CloseWindow 
          Break 
        
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #Gad_ToWinE1 
              HideGadget(#Gad_WinE2, 1) 
              HideGadget(#Gad_WinE1, 0) 
              
            Case #Gad_ToWinE2 
              HideGadget(#Gad_WinE1, 1) 
              HideGadget(#Gad_WinE2, 0) 
          EndSelect 
      EndSelect 
    ForEver 
  EndIf 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP