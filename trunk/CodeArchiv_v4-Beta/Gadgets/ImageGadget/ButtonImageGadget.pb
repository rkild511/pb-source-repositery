; www.purebasic.com
; Author: Andre Beer  (PureBasic-Team  -  www.purebasic.com) (updated for PB4.00 by blbltheworm)
; Date: 4. May 2003
; OS: Windows
; Demo: Yes

Image1 = LoadImage(0,"..\..\Graphics\Gfx\PB.bmp") 
Image2 = LoadImage(1,"..\..\Graphics\Gfx\PB2.bmp") 
ImageID = Image1

If OpenWindow(0, 10, 100, 320,180, "ButtonImageGadget & SetGadgetState", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
  If CreateGadgetList(WindowID(0))
    ButtonImageGadget(0,10,10,291,155,ImageID)
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_Gadget
          gad.l = EventGadget()
          If gad = 0
            If ImageID = Image1
              ImageID = Image2
            Else
              ImageID = Image1
            EndIf
            SetGadgetState(0,ImageID)
          EndIf
        EndIf 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
        
    Until Quit = 1 
  EndIf  
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP