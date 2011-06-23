; English forum:
; Author: Freak (updated for PB4.00 by blbltheworm)
; Date: 04. September 2002
; OS: Windows
; Demo: No


#Image = 1              ; just to make more clear, which values mean the same thing...
#PanelGadget = 1       
#ImageGadget = 2
  
  
If OpenWindow(0, 0, 0, 640, 480, "CreateImage / Imagegadget Example", #PB_Window_SystemMenu) = 0  ; open window
  MessageRequester("","Window Error!",0)           ; some error
  End
EndIf 
  
If CreateImage(#Image, 300, 300) = 0               ; create image to draw on
  MessageRequester("","Image Error!",0)            ; some error
  End
EndIf
  
back.l = GetSysColor_(#COLOR_BTNFACE)              ; gets the background color for Windows (to draw the image background)
  
; this one is only needed, if you did stuff with other Images after
                                                   ; the CreateImage() command.
StartDrawing(ImageOutput(#Image))                        ; Start Drawing on the Image

  FrontColor(RGB(Red(back),Green(back),Blue(back)))   ; Set the Background Color
  Box(0, 0, 300, 300)                              ; draw background
  
  FrontColor(RGB(0,0,0))                              ; just some drawing action
  DrawingMode(1 | 4)
  Circle(150, 150, 100)
  Box(100, 100, 100, 100)
  Line(50, 50, 200, 200)
  
  DrawText(10, 10,"Hello World!")
  
StopDrawing()                                       ; drawing ends here. (the drawing stuff must be done before the 
                                                    ; ImageGadget() command
                                                    
CreateGadgetList(WindowID(0))                        ; create GadgetList
PanelGadget(#PanelGadget, 20, 20, 600, 440)         ; Panelgadget
  AddGadgetItem(#PanelGadget, -1, "Panel 1")        ; First Panel
  
    ; again, only needed if you used some other Images before
    ImageGadget(#ImageGadget, 50, 50, 300, 300, ImageID(#Image)) ; create the Imagegadget using the current Image
   
  AddGadgetItem(#PanelGadget, -1, "Panel 2")        ; some other Panels
  AddGadgetItem(#PanelGadget, -1, "Panel 3")
CloseGadgetList()                                   ; close PanelGadget
  
SetGadgetState(#PanelGadget, 0)                     ; otherwise the drawings are not visible at the beginning
                                                    ; Thanks to Franco for the hint
  
Repeat                                             ; Main loop, only waits for close of Window
  Event.l = WaitWindowEvent()
Until Event = #PB_Event_CloseWindow
  
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -