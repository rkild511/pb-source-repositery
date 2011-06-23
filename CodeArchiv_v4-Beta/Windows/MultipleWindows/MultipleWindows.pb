; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5956&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 26. April 2003
; OS: Windows
; Demo: Yes

; 
; by Danilo, 08.03.2003 (de-forum) 
; 
Global FensterZahl 

Procedure FensterThread(value) 
  FensterZahl + 1 
  OpenWindow(FensterZahl, Random(300), Random(300), 200, 200, "Fenster "+Str(FensterZahl), #PB_Window_MinimizeGadget) 

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
        QuitThread = 1 
    EndSelect 
  Until QuitThread = 1 

EndProcedure 


If OpenWindow(0, 0, 0, 150, 100, "Hauptfenster", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  #Button1 = 1:ButtonGadget(#Button1, 0, 0, 150, 21, "Neues Fenster erstellen") 

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_Gadget 
        Select EventGadget() ;Gadgets 
          Case #Button1 ;ButtonGadget 
            CreateThread(@FensterThread(),0) 
        EndSelect ;EventGadgetID() 
      Case #PB_Event_CloseWindow 
        Quit = 1 
    EndSelect ;Event 
  Until Quit = 1 

  End 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
