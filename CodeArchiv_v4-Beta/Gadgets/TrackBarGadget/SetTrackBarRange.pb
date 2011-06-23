; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1196&highlight=
; Author: glubschi90 (updated for PB 4.00 by Andre)
; Date: 12. December 2004
; OS: Windows
; Demo: No

id=OpenWindow(0,0,0,200,80,"Trackbar",#PB_Window_ScreenCentered|#PB_Window_MinimizeGadget) 

CreateGadgetList(id) 

;-Gadgets 
TrackBarGadget(0,10,10,180,25,0,100) 
TextGadget(1,10,55,50,15,"0") 
ButtonGadget(2,100,50,80,25,"Set! (25,50)") 


;-Procedures 
Procedure SetTrackbarRange(Gadget,Min,Max) ; Wenn Min bzw. Max -1 ist, wird der entsprechende Wert nicht verändert 
  If Min>-1 
    SendMessage_(GadgetID(Gadget),#TBM_SETRANGEMIN,#True,Min) 
  EndIf 
  If Max>-1 
    SendMessage_(GadgetID(Gadget),#TBM_SETRANGEMAX,#True,Max) 
  EndIf 
EndProcedure 

Repeat 
 event=WaitWindowEvent() 
  Select event 
    Case #PB_Event_CloseWindow 
      quit=1 
    Case #PB_Event_Gadget 

      Select EventGadget() 
        Case 0 ; "Trackbar-Wert" anzeigen 
          SetGadgetText(1,Str(GetGadgetState(0))) 
        Case 2 ; "Den Minimum-Wert auf 25 und den Maximum-Wert auf 50 setzen 
          SetTrackbarRange(0,25,50) 
      EndSelect 

  EndSelect 
Until quit=1
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -