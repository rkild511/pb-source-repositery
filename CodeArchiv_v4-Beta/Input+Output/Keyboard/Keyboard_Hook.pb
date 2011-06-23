; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1693&highlight=hook
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 17. July 2003
; OS: Windows
; Demo: No


; Example for filtering "Strg-Z" (Undo) from input in an EditorGadget

#Window = 0 

#Gadget_Editor = 0 
#Gadget_Button_Hook = 1 
#Gadget_Button_Exit = 2 

#WindowWidth = 600 
#WindowHeight = 300 
#minWindowWidth = 100 
#minWindowHeight = 50 

Global hook.l 

Procedure OpenMainWindow() 
  Result = OpenWindow(#Window, 0, 0, #WindowWidth, #WindowHeight, "STRG-Z Hook", #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
  If Result 
    If CreateGadgetList(WindowID(#Window)) 
      EditorGadget(#Gadget_Editor, 10, 10, #WindowWidth - 20, #WindowHeight - 60) 
      ButtonGadget(#Gadget_Button_Hook, 10, WindowHeight(#Window) - 40, 120, 30, "Hook Einschalten") 
      ButtonGadget(#Gadget_Button_Exit, WindowWidth(#Window) - 70, WindowHeight(#Window) - 40, 60, 30, "Exit") 
    EndIf 
  EndIf 
ProcedureReturn Result 
EndProcedure 
; 

Procedure WindowCallback(WindowID, Message, wParam, lParam) 
  Select Message 
    Case #WM_SIZE 
      If WindowWidth(#Window) < #minWindowWidth Or WindowHeight(#Window) < #minWindowHeight 
        If WindowWidth(#Window) < #minWindowWidth 
          ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,#minWindowWidth, WindowHeight(#Window)) 
        EndIf 
        If WindowHeight(#Window) < #minWindowHeight 
          ResizeWindow(#Window,#PB_Ignore,#PB_Ignore,WindowWidth(#Window), #minWindowHeight) 
        EndIf 
      Else 
        ResizeGadget(#Gadget_Editor,#PB_Ignore,#PB_Ignore, WindowWidth(#Window) - 20, WindowHeight(#Window) - 60) 
        ResizeGadget(#Gadget_Button_Hook,#PB_Ignore, WindowHeight(#Window) - 40,#PB_Ignore,#PB_Ignore) 
        ResizeGadget(#Gadget_Button_Exit, WindowWidth(#Window) - 70, WindowHeight(#Window) - 40,#PB_Ignore,#PB_Ignore) 
      EndIf 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 
; 
  
Procedure.l KeyboardHook(nCode.l, wParam.l, lParam.l) 
  If nCode < 0 
    ProcedureReturn CallNextHookEx_(hook, nCode, wParam, lParam) 
  EndIf 
  If GetAsyncKeyState_(#VK_RCONTROL) Or GetAsyncKeyState_(#VK_LCONTROL) 
    If wParam = 90 
      ; Debug RSet(Bin(lParam), 32,"0") 
      ; Debug "HOOKED" 
      ProcedureReturn 1 
    EndIf 
  EndIf 
ProcedureReturn CallNextHookEx_(hook, nCode, wParam, lParam) 
EndProcedure 
; 
If OpenMainWindow() 
  SetWindowCallback(@WindowCallback()) 
  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Gadget_Button_Hook 
            If Aktiv ; aktiv dann ausschalten 
              UnhookWindowsHookEx_(hook) 
;              Debug "HOOK AUS" 
              Aktiv = 0 
              SetGadgetText(#Gadget_Button_Hook, "Hook Einschalten") 
            Else ; hook einschalten 
              hInstance = GetModuleHandle_(0) 
              lpdwProcessId = GetWindowThreadProcessId_(WindowID(#Window), 0) 
              hook = SetWindowsHookEx_(#WH_KEYBOARD, @KeyboardHook(), hInstance, lpdwProcessId) 
;              Debug "HOOK AN" 
              Aktiv = 1 
              SetGadgetText(#Gadget_Button_Hook, "Hook Ausschalten") 
            EndIf 
          Case #Gadget_Button_Exit 
            quit = 1 
;          Case #Gadget_Editor 
        EndSelect 
      Case #PB_Event_CloseWindow  
        quit = 1 
    EndSelect 
  Until quit 
EndIf 

If Aktiv 
  UnhookWindowsHookEx_(hook) 
  ; Debug "HOOK ausschalten nicht vergessen !" 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
