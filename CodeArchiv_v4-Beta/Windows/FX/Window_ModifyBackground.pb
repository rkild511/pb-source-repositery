; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB3.93 by Donald, updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes


;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#Gadget_0 = 0 
#Gadget_1 = 1 

CreateImage(0 ,600,300) 
StartDrawing(ImageOutput(0 )) 
  Box(0,0,600,300) 
  Circle(300,150,50,RGB(255,255,255)) 
StopDrawing() 
Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 221, 0, 600, 300, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ImageGadget(#Gadget_0, 0, 0, 600, 300, ImageID(0)) 
      ButtonGadget(#Gadget_1, 200, 80, 200, 40, "Hintergrundbild abschalten") 
      DisableGadget(#Gadget_0,1)
    EndIf 
  EndIf 
EndProcedure 


Open_Window_0() 

Repeat 
  Event = WaitWindowEvent() 
    If Event=#PB_Event_Gadget 
      Select EventGadget() 
        Case #Gadget_1 
          If Hide=0 
            HideGadget(#Gadget_0,1) 
            SetGadgetText(#Gadget_1, "Hintergrundbild anschalten") 
            DisableGadget(#Gadget_0,1)
            Hide=1 
          Else 
            HideGadget(#Gadget_0,0) 
            SetGadgetText(#Gadget_1, "Hintergrundbild abschalten") 
            DisableGadget(#Gadget_0,1)
            Hide=0 
          EndIf 
      EndSelect 
    EndIf 
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP