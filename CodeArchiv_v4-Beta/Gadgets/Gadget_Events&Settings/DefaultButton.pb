; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2194&postdays=0&postorder=asc&start=30
; Author: nco2k (updated for PB 4.00 by Andre, reworked by nco2k itself)
; Date: 27. Februar 2005
; OS: Windows
; Demo: No


; If a button gets the focus, it will be set as 'Default' and Return on this button can be used.
; Wenn ein Schalter den Fokus erhält, wird er als 'Default' gesetzt und anschließend kann darauf Return genutzt werden.

;/ Default-Button Example by nco2k 

#Button_A = 0 
#Button_B = 1 
#Button_Exit = 2 

#Shortcut_Escape = 0 
#Shortcut_Return = 1 

Global ButtonACallback.l 
Global ButtonBCallback.l 
Global ButtonExitCallback.l 
Global DefaultButton.l 

Procedure ButtonACallbackProc(hWnd, uMsg, wParam, lParam) 
  If uMsg = #WM_SETFOCUS 
    SendMessage_(GadgetID(#Button_A), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
    SendMessage_(GadgetID(#Button_B), #BM_SETSTYLE, 0, #True) 
    SendMessage_(GadgetID(#Button_Exit), #BM_SETSTYLE, 0, #True) 
    DefaultButton = #Button_A 
  EndIf 
  ProcedureReturn CallWindowProc_(ButtonACallback, hWnd, uMsg, wParam, lParam) 
EndProcedure 

Procedure ButtonBCallbackProc(hWnd, uMsg, wParam, lParam) 
  If uMsg = #WM_SETFOCUS 
    SendMessage_(GadgetID(#Button_A), #BM_SETSTYLE, 0, #True) 
    SendMessage_(GadgetID(#Button_B), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
    SendMessage_(GadgetID(#Button_Exit), #BM_SETSTYLE, 0, #True) 
    DefaultButton = #Button_B 
  EndIf 
  ProcedureReturn CallWindowProc_(ButtonBCallback, hWnd, uMsg, wParam, lParam) 
EndProcedure 

Procedure ButtonExitCallbackProc(hWnd, uMsg, wParam, lParam) 
  If uMsg = #WM_SETFOCUS 
    SendMessage_(GadgetID(#Button_A), #BM_SETSTYLE, 0, #True) 
    SendMessage_(GadgetID(#Button_B), #BM_SETSTYLE, 0, #True) 
    SendMessage_(GadgetID(#Button_Exit), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
    DefaultButton = #Button_Exit 
  EndIf 
  ProcedureReturn CallWindowProc_(ButtonExitCallback, hWnd, uMsg, wParam, lParam) 
EndProcedure 

Procedure WindowCallbackProc(hWnd, Msg, wParam, lParam) 
  If Msg = #WM_ACTIVATE 
    If hWnd = WindowID(0) 
      If (wParam & $FFFF) = #WA_INACTIVE 
        SendMessage_(GadgetID(#Button_A), #BM_SETSTYLE, 0, #True) 
        SendMessage_(GadgetID(#Button_B), #BM_SETSTYLE, 0, #True) 
        SendMessage_(GadgetID(#Button_Exit), #BM_SETSTYLE, 0, #True) 
      ElseIf IsGadget(DefaultButton) And GadgetType(DefaultButton) = #PB_GadgetType_Button 
        SendMessage_(GadgetID(DefaultButton), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
      EndIf 
    EndIf 
  EndIf 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

If OpenWindow(0, 0, 0, 320, 95, "Default-Button Example", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(#Button_A, 110, 5, 100, 25, "A") 
    ButtonACallback = SetWindowLong_(GadgetID(#Button_A), #GWL_WNDPROC, @ButtonACallbackProc()) 
    ButtonGadget(#Button_B, 110, 35, 100, 25, "B", #PB_Button_Default) 
    SetActiveGadget(#Button_B) 
    ButtonBCallback = SetWindowLong_(GadgetID(#Button_B), #GWL_WNDPROC, @ButtonBCallbackProc()) 
    DefaultButton = #Button_B 
    ButtonGadget(#Button_Exit, 110, 65, 100, 25, "Exit") 
    ButtonExitCallback = SetWindowLong_(GadgetID(#Button_Exit), #GWL_WNDPROC, @ButtonExitCallbackProc()) 
  EndIf 
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, #Shortcut_Escape) 
  AddKeyboardShortcut(0, #PB_Shortcut_Return, #Shortcut_Return) 
  SetWindowCallback(@WindowCallbackProc(), 0) 
EndIf 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case #Shortcut_Escape 
          End 
        Case #Shortcut_Return 
          If DefaultButton = #Button_A 
            Debug "A" 
          ElseIf DefaultButton = #Button_B 
            Debug "B" 
          ElseIf DefaultButton = #Button_Exit 
            End 
          EndIf 
      EndSelect 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #PB_Event_Gadget 
          Case #Button_A 
            Debug "A" 
          Case #Button_B 
            Debug "B" 
          Case #Button_Exit 
            End 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 


; Alternative event loop, where menu/keyboard events are switched to related gadget events
; ----------------------
; Repeat 
;   WinEvent = WaitWindowEvent() 
;   Select WinEvent 
;     Case #PB_Event_Menu, #PB_Event_Gadget 
;       GadgetEvent = -1 
;       Select WinEvent 
;         Case #PB_Event_Menu 
;           MenuEvent = EventMenu() 
;           Select MenuEvent 
;             Case #Shortcut_Escape 
;               GadgetEvent = #Button_Exit 
;             Case #Shortcut_Return 
;               GadgetEvent = DefaultButton 
;           EndSelect 
;         Case #PB_Event_Gadget 
;           GadgetEvent = EventGadget() 
;       EndSelect 
;       If GadgetEvent >= 0 
;         Select GadgetEvent 
;           Case #Button_A 
;             Debug "A" 
;           Case #Button_B 
;             Debug "B" 
;           Case #Button_Exit 
;             End 
;         EndSelect 
;       EndIf 
;     Case #PB_Event_CloseWindow 
;       End 
;   EndSelect 
; ForEver 

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -