; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=981&start=10
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 14. May 2003
; OS: Windows
; Demo: No

Global hFocus.l,hLastFocus.l 

Procedure GetLastFocus() 
  Buffer$ = Space(260) 
  Focus.l = GetFocus_() 
  GetClassName_(Focus,Buffer$,260) 
  If Focus <> hFocus 
    hFocus = Focus 
    If UCase(Buffer$) = "EDIT" 
      hLastFocus.l = hFocus 
    EndIf 
  EndIf 
EndProcedure 

#WindowWidth  = 390 
#WindowHeight = 350 

If OpenWindow(0, 100, 200, #WindowWidth, #WindowHeight, "PureBasic - Gadget Demonstration", #PB_Window_MinimizeGadget) 
If CreateGadgetList(WindowID(0)) 
    StringGadget(10,  20, 10, 100, 20, "") 
    StringGadget(11,  120, 10, 100, 20, "") 
    ButtonGadget(1, 20, 70,  30, 30, "1") 
    ButtonGadget(2, 20, 100,  30, 30, "2") 
    ButtonGadget(3, 20, 130,  30, 30, "3") 
    ButtonGadget(4, 20, 160,  30, 30, "4") 
    ButtonGadget(5, 20, 190,  30, 30, "5") 
    ButtonGadget(6, 20, 220,  30, 30, "6") 
    ButtonGadget(7, 20, 250,  30, 30, "7") 
    ButtonGadget(8, 20, 280,  30, 30, "8") 
    ButtonGadget(9, 20, 310,  30, 30, "9") 
EndIf 
  Repeat 
    EventID = WaitWindowEvent() 
    If EventID = #PB_Event_Gadget 
      GetLastFocus() 
      Buffer$ = Space(260) 
      GetWindowText_(hLastFocus,Buffer$,260) 
      Select EventGadget() 
        Case 1 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(1)) 
        Case 2 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(2)) 
        Case 3 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(3)) 
        Case 4 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(4)) 
        Case 5 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(5)) 
        Case 6 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(6)) 
        Case 7 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(7)) 
        Case 8 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(8)) 
        Case 9 
          SetWindowText_(hLastFocus,Buffer$ + GetGadgetText(9)) 
      EndSelect 
    EndIf 
  Until EventID = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
