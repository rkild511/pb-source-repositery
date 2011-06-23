; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14249&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 20. March 2005
; OS: Windows
; Demo: Yes

#WindowWidth  = 450 
#WindowHeight = 305 

If OpenWindow(30, 100, 200, #WindowWidth, #WindowHeight, "PureBasic - Advanced Gadget Demonstration", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget) 

  If CreateGadgetList(WindowID(30)) 
    ImageGadget(0, 20, 5, 100, 80, 0, #PB_Image_Border|#WS_EX_DLGMODALFRAME) 
  EndIf 

  ; Image = LoadImage(1,"..\..\Graphics\Gfx\PB.bmp") 
  ; SetGadgetState(0, Image)

  Repeat 
    EventID = WaitWindowEvent() 
    
    If EventID = #PB_Event_Gadget 
      
      Select EventGadget() 
        
        
      EndSelect 
      
    EndIf 
    
  Until EventID = #PB_Event_CloseWindow 
EndIf 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -