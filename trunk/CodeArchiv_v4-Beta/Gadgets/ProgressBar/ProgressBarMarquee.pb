; English forum: http://www.purebasic.fr/english/viewtopic.php?t=17711&start=15
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 15. November 2005
; OS: Windows
; Demo: No


;--> *************************** 
;--> Code:    ProgressBarMarquee 
;--> Author:  Sparkie 
;--> Date:    November 15, 2005 
;--> *************************** 

#Container = 0 
#Progress = 1 
#Button = 2 

;--> Create our image for use in ProgressBarMarquee 
CreateImage(0, 60, 20) 
StartDrawing(ImageOutput(0)) 
Box(0, 0, 100, 20, #White) 
Box(5, 3, 5, 14, RGB(255, 225, 225)) 
Box(10, 3, 5, 14, RGB(255, 200, 200)) 
Box(15, 3, 5, 14, RGB(255, 175, 175)) 
Box(20, 3, 5, 14, RGB(255, 150, 150)) 
Box(25, 3, 5, 14, RGB(255, 125, 125)) 
Box(30, 3, 5, 14, RGB(255, 100, 100)) 
Box(35, 3, 5, 14, RGB(255, 75, 75)) 
Box(40, 3, 5, 14, RGB(255, 50, 50)) 
Box(45, 3, 10, 14, RGB(255, 0, 0)) 
StopDrawing() 

;--> Timer for displaying ProgressBarMarquee 
Procedure MarqueeTimer() 
  x = GadgetX(#Progress) + 1 
  If x > GadgetWidth(#Container) 
    x = -50 
    ResizeGadget(#Progress, x, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
  Else 
    ResizeGadget(#Progress, x+1, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
  EndIf 
EndProcedure 

Procedure ProgressMarquee(container, progress, x, y, w, h) 
  ContainerGadget(container, x, y, w, h, #PB_Container_Single) 
  ;--> Change container gadget to white 
  SetClassLong_(GadgetID(container), #GCL_HBRBACKGROUND, GetStockObject_(#WHITE_BRUSH)) 
  ImageGadget(progress, 0, 0, 100, 20, ImageID(0)) 
  CloseGadgetList() 
  HideGadget(container, 1) 
  ProcedureReturn 
EndProcedure 

Procedure ProgressStart(speed) 
  ;--> Turn on progress marquee 
  SetTimer_(WindowID(0), 1, speed, @MarqueeTimer()) 
  HideGadget(#Container, 0) 
EndProcedure 

Procedure ProgressEnd() 
  ;--> Turn off progress marquee 
  KillTimer_(WindowID(0), 1)  
  leftEdge = -50 
  ResizeGadget(#Progress, leftEdge, -1, -1, -1) 
  HideGadget(#Container, 1) 
EndProcedure 

If OpenWindow(0, 0, 0, 300, 150, "ProgressBarMarquee", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ;--> Create our ProgressBarMarqueegadget 
  ProgressMarquee(#Container, #Progress, 100, 10, 100, 20) 
  ButtonGadget(#Button, 75, 70, 150, 20, "Start Progress Marquee") 
  Repeat 
    event = WaitWindowEvent() 
    Select event 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 2 
            If GetGadgetText(#Button) = "Start Progress Marquee" 
              SetGadgetText(#Button, "Stop Progress Marquee") 
              ;--> Start and show the progress marquee with speed 
              ;--> (the parameter passed is a timer delay in milliseconds) 
              ProgressStart(10) 
            Else 
              SetGadgetText(#Button, "Start Progress Marquee") 
              ;--> Stop and hide the progress marquee 
              ProgressEnd() 
            EndIf 
        EndSelect 
    EndSelect 
  Until event = #PB_Event_CloseWindow 
  KillTimer_(WindowID(0), 1) 
EndIf 
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP