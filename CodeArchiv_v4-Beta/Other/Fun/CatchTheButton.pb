; German forum: http://www.purebasic.fr/german/viewtopic.php?t=717&highlight=
; Author: Sunny (updated for PB 4.00 by Andre)
; Date: 17. November 2004
; OS: Windows
; Demo: No

If OpenWindow(0, Random(500), Random(500), 450, 100, "PureBasic Window", #PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  ButtonGadget(0, 225 - 30, 40, 60, 60, "Button")

  SetTimer_(WindowID(0), 1, 50, 0)

  Repeat

    SetFocus_(WindowID(0))
    If WindowMouseX(0) >= GadgetX(0) - 2 And WindowMouseX(0) <= GadgetX(0) + GadgetWidth(0) - 2 And WindowMouseY(0) >= GadgetY(0) - 2 And WindowMouseY(0) <= GadgetY(0) + GadgetHeight(0) + 2
      If WindowMouseX(0) <= GadgetX(0) + (GadgetWidth(0) / 2)
        MoveWindow_(GadgetID(0), WindowMouseX(0) + 2, 40, 60, 60, #True)
      Else
        MoveWindow_(GadgetID(0), WindowMouseX(0) - GadgetWidth(0) - 2, 40, 60, 60, #True)
      EndIf

      If GadgetX(0) >= 390 Or GadgetX(0) <= 0
        MoveWindow_(GadgetID(0), 225 - (GadgetWidth(0) / 2), 40, 60, 60, #True)
      EndIf
    EndIf

    EventID.l = WaitWindowEvent()

    If EventID = #PB_Event_CloseWindow
      quit = 1
    EndIf

  Until quit = 1
EndIf
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP