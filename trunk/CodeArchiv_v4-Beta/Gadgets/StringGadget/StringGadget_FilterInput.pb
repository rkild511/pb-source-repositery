; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8500&highlight=
; Author: TeddyLM (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: No

;============================
;StringGadget with KEY-FILTER
;Thanks to Art Sentinel for the Hook-Tutorial
;============================
Global hhook
Global hookValue.b : hookValue = 0
Global CommaPoint.b : CommaPoint = 0
#StringID1 = 11
#StringID2 = 14
;************
;PROCEDURES
;************
Procedure KeyboardProc(nCode, wParam, lParam)
  Define.b Result
  If wParam < 31
    Result = 0
  ElseIf wParam = 188 And CommaPoint = 0 ;","
    Result = 0
  ElseIf wParam = 8 ;Del
    Result = 0
  ElseIf wParam = 37 ;ArrowLeft
    Result = 0
  ElseIf wParam = 38 ;ArrowUp
    Result = 0
  ElseIf wParam = 39 ;ArrowRight
    Result = 0
  ElseIf wParam = 40 ;ArrowDown
    Result = 0
  ElseIf wParam = 46 ;Entf
    Result = 0
  ElseIf wParam = 48 ;0
    Result = 0
  ElseIf wParam = 49 ;1
    Result = 0
  ElseIf wParam = 50 ;2
    Result = 0
  ElseIf wParam = 51 ;3
    Result = 0
  ElseIf wParam = 52 ;4
    Result = 0
  ElseIf wParam = 53 ;5
    Result = 0
  ElseIf wParam = 54 ;6
    Result = 0
  ElseIf wParam = 55 ;7
    result = 0
  ElseIf wParam = 56 ;8
    Result = 0
  ElseIf wParam = 57 ;9
    Result = 0
  Else
    Result = 1
  EndIf
  ProcedureReturn Result
EndProcedure
;***********
;***********
Procedure HookProc(Hooked)
  Shared hhook
  Shared CommaPoint
  Select Hooked
  Case 1
    hInstance = GetModuleHandle_(0)
    lpdwProcessId = GetWindowThreadProcessId_(WindowID, 0)
    hhook = SetWindowsHookEx_(#WH_KEYBOARD, @KeyboardProc(), hInstance, lpdwProcessId)
  Case 0
    UnhookWindowsHookEx_(hhook)
  EndSelect
EndProcedure
;************
;************
WindowID = OpenWindow(0, 150, 150, 300, 300, "Decimal-Filter (Thanks to Art Sentinel)", #PB_Window_SystemMenu)
If WindowID <> 0
  ;GadgetList
  If CreateGadgetList(WindowID(0))
    TextGadget(10, 50, 96, 180, 22, "No Filter :")
    StringGadget(#StringID1, 50, 120, 180, 22, "") : SendMessage_(GadgetID(#StringID1), #EM_LIMITTEXT, 20, 0)
    TextGadget(12, 50, 166, 180, 22, "Filter Decimal-Value :")
    StringGadget(#StringID2, 50, 190, 180, 22, "") : SendMessage_(GadgetID(#StringID2), #EM_LIMITTEXT, 20, 0)
    SetActiveGadget(#StringID1)
    
    ;Main loop
    Repeat
      Select WaitWindowEvent()
      Case #WM_KEYDOWN
        If EventwParam() = 13
          Select EventGadget()
          Case #StringID1
            text$ = GetGadgetText(#StringID2)
            SendMessage_(GadgetID(#StringID2), #EM_SETSEL, 0, Len(text$))
            SetActiveGadget(#StringID2)
          Case #StringID2
            text$ = GetGadgetText(#StringID1)
            SendMessage_(GadgetID(#StringID1), #EM_SETSEL, 0, Len(text$))
            SetActiveGadget(#StringID1)
          EndSelect
        EndIf
      Case #PB_Event_Gadget
        Select EventGadget()
        Case #StringID2
          Text$=GetGadgetText(#StringID2)
          StLength = Len(Text$)
          CommaPoint = 0
          If StLength > 0
            For counter = 1 To StLength
              If Mid(Text$,counter,1) = ","
                CommaPoint = CommaPoint + 1
              EndIf
            Next
          EndIf
          If hookValue = 0 : hookValue = 1 : HookProc(1) : EndIf
          Default
          If hookValue = 1 : hookValue = 0 : HookProc(0) : EndIf
        EndSelect
      Case #WM_CLOSE
        Quit = 1
      EndSelect
    Until Quit = 1
  EndIf
EndIf
End
;============================

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
