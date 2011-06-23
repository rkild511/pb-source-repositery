; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2647&highlight=
; Author: Danilo (improved example of PureVampy, updated for PB4.00 by blbltheworm)
; Date: 24. October 2003
; OS: Windows
; Demo: Yes


; The StringGadget will become automatically activated, after the window get the focus again
; Das StringGadget wird automatisch aktiviert, nachdem das Fenster den Fokus erhalten hat (aktiviert wurde)

Procedure Open_Window() 
  If OpenWindow(0, 408, 321, 200, 100, "Texteingabe",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
    If CreateGadgetList(WindowID(0)) 
      StringGadget(0, 30, 30, 130, 20, "") 
      ButtonGadget(1,100,60,60,30,"Ok") 
    EndIf 
  EndIf 
EndProcedure 

Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_SIZE 
      If wParam = #SIZE_RESTORED 
      EndIf 
    Case #WM_ACTIVATE 
        SetActiveGadget(0) 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

Open_Window() 

SetWindowCallback(@MyWindowCallback()) 

Repeat 
  ;ActivateGadget(0)     => hier wird der Fokus zwar richtig gesetzt, aber der Button ignoriert! 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget 
   GadgetID = EventGadget() 
   If GadgetID = 0 
    ;Code 
   EndIf 
  EndIf 
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
