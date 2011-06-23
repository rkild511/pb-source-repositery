; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7460
; Author: Danilo (posted by blueb) (updated for PB4.00 by blbltheworm)
; Date: 06. September 2003
; OS: Windows
; Demo: No

;------------------------------------------------- 
; Another great little demo from Danilo on timers 
; and scrolling. 
;------------------------------------------------- 

Global myText$ 
Global hWnd.l 
Global TextWidth.l 
#ScrollSpeed_in_Milliseconds = 70 


myText$ = "     This is a little Scroller-Test with the Timer by Danilo     " 
TextWidth = Len(myText$) 


Procedure Scroller() 
;Shared Scroller_a 
Shared Scroller_Position 
Shared Scroller_Direction 

If Scroller_Position < TextWidth + 1 And Scroller_Direction = 0 
    TEMP$ = Right(myText$,Scroller_Position) 
    SetWindowText_(hWnd, TEMP$) 
    Scroller_Position+1 
Else 
    Scroller_Direction = 1 
    TEMP$ = Right(myText$,Scroller_Position) 
    SetWindowText_(hWnd, TEMP$) 
    Scroller_Position-1 
    If Scroller_Position = 0 : Scroller_Direction = 0 : EndIf 
EndIf 
EndProcedure 


Procedure mybeep() 
  Beep_(500,1000) 
  KillTimer_(WindowID(0),0) 
  DisableGadget(0,0) 
  DisableGadget(1,0) 
  SetTimer_(WindowID(0),1, #ScrollSpeed_in_Milliseconds, @Scroller()) 
EndProcedure 


Procedure Alarm() 
  Beep_(500,60) 
EndProcedure 


;MessageRequester("Minimal Timer Resolution",Str(GetMinTimerResolution()),0) 
;MessageRequester("Maximal Timer Resolution",Str(GetMaxTimerResolution()),0) 


hWnd = OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN)-400)/2,(GetSystemMetrics_(#SM_CYSCREEN)-100)/2, 400, 100,"", #PB_Window_SystemMenu) 


  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(0,  10, 10, 100, 25, "Quit Scroller") 
    DisableGadget(0,1) 
    ButtonGadget(1, 120, 10, 250, 25, "Change Timer from Scroller to Beep") 
    DisableGadget(1,1) 
  EndIf 
SetForegroundWindow_(hWnd) 

SetTimer_(WindowID(0),0,1000,@mybeep()) 
;StartTimer(0,1000, @mybeep()) 

;message loop 
  Repeat 
           EventID.l=WaitWindowEvent() 
              If EventID = #PB_Event_Gadget 
                 Select EventGadget() 
                  Case 0 ; End the Timer 
                    A$ = GetGadgetText(0) 
                    If A$ = "Quit Alarm" 
                       SetGadgetText(0,"Exit Program") 
                       DisableGadget(1,1) 
                    EndIf 
                    If A$ = "Exit Program" 
                       Quit = 1 
                    EndIf 
                    KillTimer_(WindowID(0),1) 
                  Case 1 
                    SetGadgetText(0,"Quit Alarm") 
                    SetTimer_(WindowID(0),1, 100, @Alarm()) 
                 EndSelect 
              EndIf 
              ; pressed CloseButton or ALT+F4 ?? 
              If EventID = #PB_Event_CloseWindow 
                 Quit = 1 
              EndIf 
  Until Quit = 1 
; the end 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
