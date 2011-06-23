; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 23. February 2003
; OS: Windows
; Demo: No

search$ = "" 
GetAsyncKeyState_(#VK_RETURN) ; flush buffer of RETURNkey 
If OpenWindow( 1, 50, 200, 500, 100," Eingabe Wortteil ", #PB_Window_SystemMenu) 
  Fenster_1_ID = WindowID( 1) 
  If CreateGadgetList( Fenster_1_ID ) 
    ;SetGadgetFont( UseFont( 0 ) ) 
    TextGadget( 5, 10, 40, 150, 24, "suche Wortteil : " ) 
    StringGadget( 6, 161, 36, 170, 24, "" ) 
    ButtonGadget( 7, 350, 36, 40, 24, " OK ") 
    OptionGadget( 8, 161, 70, 80, 24, "einschl.") 
    OptionGadget( 9, 246, 70, 80, 24, "ausschl.") 
    SetGadgetState( 8, 1) : einschl = 1 : mitohne$ = "mit " 
    SetActiveGadget(6) 
  EndIf 
  Repeat 
    EventID = WaitWindowEvent() 
    If EventID = #PB_Event_Gadget 
      Select EventGadget() 
        Case 6 ; wait for search$ 
          search$ = GetGadgetText( 6 ) 
        Case 7 ; Quit... 
          EventID = #PB_Event_CloseWindow 
        Case 8 
          einschl = GetGadgetState( 8 ) 
        Case 9 
           einschl = GetGadgetState( 8 ) : mitohne$ = "ohne " 
      EndSelect 
    Else 
      If GetAsyncKeyState_(#VK_RETURN) = -32767 ; RETURN key was pressed 
        Debug "Return-Taste wurde gedrückt!"
        ;  EventID = #PB_EventCloseWindow 
      EndIf 
    EndIf 
  Until EventID = #PB_Event_CloseWindow 
  CloseWindow( 1 ) 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP