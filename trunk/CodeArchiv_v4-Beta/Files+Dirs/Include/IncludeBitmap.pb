; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6624&highlight=
; Author: TerryHough (updated for PB4.00 by blbltheworm)
; Date: 18. June 2003
; OS: Windows
; Demo: Yes

CatchImage(0, ?Logo) 

If OpenWindow(1, 0, 0, 200, 100, "Embedded Image",#PB_Window_ScreenCentered| #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
  CreateGadgetList(WindowID(1)) 
  x = (WindowWidth(1) - ImageWidth(0)) / 2 
  y = (WindowHeight(1) - ImageHeight(0)) /2 
  ImageGadget(0, x, y, ImageWidth(0), ImageHeight(0), 0, #PB_Image_Border) 
EndIf 

  SetGadgetState(0, ImageID(0))  ; Change the picture in the gadget 
   ; ---------------- This is the main processing loop ---------------------- 
  Repeat 
    EventID = WaitWindowEvent() 
      
    ; ------------------- Process the menu events -------------------------- 
    If EventID = #PB_Event_Menu 
      Select EventMenu()     ;  see which menu item was selected 
        Case 1    ; Import 
        Case 5    ; Exit menu chosen 
          Quit = 1  ; Set the exit flag 
      EndSelect 
    EndIf 
      
    ; ------------------ Process the gadget events ------------------------- 
    If EventID = #PB_Event_Gadget 
      Select EventGadget() 
        Case 1    ; Panel gadget chosen 
      EndSelect 
    EndIf    
      
    If EventID =  #WM_CLOSE ;  #PB_EventCloseWindow 
      Quit = 1      
    EndIf 

  ; ------------ Insure changes are saved when quit received --------------- 
  If Quit = 1 
;   Miscellaneous cleanups before closing 
  EndIf  

  Until Quit = 1 
  ; -------------------End of the main processing loop --------------------- 
End 

Logo: IncludeBinary "..\..\Graphics\Gfx\purebasic.bmp" 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
