; English forum: http://www.purebasic.fr/english/viewtopic.php?t=10218&highlight=
; Author: USCode (updated for PB 4.00 by Andre)
; Date: 17. April 2004
; OS: Windows
; Demo: Yes


; Test source for the include file RS_ResizeGadgets.pb, so this is needed too !


; WebBrowser
; ----------
; Another more practical example on using RS_ResizeGadgets, using a simplifed
; version of Fred's Mini Web Browser as an example. 3 easy steps and the rest
; is automatic.

;RESIZE step 1
IncludeFile "RS_ResizeGadgets.pb"

If OpenWindow(0, 0, 0, 500, 300, "Mini-Browser", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)

  CreateGadgetList(WindowID(0))
  ButtonGadget(1,   0, 0, 50, 25, "Back")
  ButtonGadget(2,  50, 0, 50, 25, "Next")
  ButtonGadget(3, 100, 0, 50, 25, "Stop")

  StringGadget(4, 150, 3, 325, 20, "http://")

  ButtonGadget(5, 475, 0, 25 , 25, "Go")

  Frame3DGadget(6, 1, 30, 500, 2, "", 2)

  If WebGadget(10, 5, 35, 490, 260, "") = 0 : MessageRequester("Error", "ATL.dll not found", 0) : End : EndIf

  AddKeyboardShortcut(0, #PB_Shortcut_Return, 0)

  ;RESIZE step 2
  RS_Register(0,4,#True,#True,#True,#False)
  RS_Register(0,5,#False,#True,#True,#False)
  RS_Register(0,6,#True,#True,#True,#False)
  RS_Register(0,10,#True,#True,#True,#True)

  Repeat
    Event = WaitWindowEvent()

    ;RESIZE step 3 ... DONE!
    RS_Resize(Event,EventWindow())

    Select Event
      Case #PB_Event_Gadget

        Select EventGadget()
          Case 1
            SetGadgetState(10, #PB_Web_Back)

          Case 2
            SetGadgetState(10, #PB_Web_Forward)

          Case 3
            SetGadgetState(10, #PB_Web_Stop)

          Case 5
            SetGadgetText(10, GetGadgetText(4))

        EndSelect

      Case #PB_Event_Menu
        SetGadgetText(10, GetGadgetText(4))

    EndSelect

  Until Event = #PB_Event_CloseWindow

EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP